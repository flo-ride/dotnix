{ config, lib, pkgs, ... }:

let
  cfg = config.modules.gui.dictation;

  # Script to toggle recording and transcribe
  dictationScript = pkgs.writeShellScriptBin "whisper-dictate" ''
    #!/usr/bin/env bash
    PID_FILE="/tmp/whisper_dictation.pid"
    WAV_FILE="/tmp/whisper_dictation.wav"
    MODEL_DIR="$HOME/.cache/whisper-models"
    MODEL_PATH="$MODEL_DIR/ggml-base.bin"

    export PATH=${lib.makeBinPath [ pkgs.pipewire pkgs.ffmpeg pkgs.whisper-cpp pkgs.wtype pkgs.libnotify pkgs.coreutils pkgs.curl pkgs.gawk ]}:$PATH

    # Download model if not exists
    if [ ! -f "$MODEL_PATH" ]; then
        notify-send "Dictation" "Downloading Whisper base model..." -t 3000
        mkdir -p "$MODEL_DIR"
        curl -L "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin" -o "$MODEL_PATH"
        notify-send "Dictation" "Model downloaded!" -t 2000
    fi

    if [ -f "$PID_FILE" ]; then
        # Stop recording
        RECORD_PID=$(cat "$PID_FILE")
        rm "$PID_FILE"
        kill -INT "$RECORD_PID" 2>/dev/null
        sleep 0.2
        
        notify-send "Dictation" "Transcribing..." -t 2000
        
        # whisper.cpp needs 16kHz wav
        ffmpeg -y -i "$WAV_FILE" -ar 16000 -ac 1 -c:a pcm_s16le "''${WAV_FILE}.16k.wav" 2>/dev/null
        
        # Transcribe
        # -l auto = auto-detect language (French or English), -np = no extra prints
        TEXT=$(whisper-cli -l auto -m "$MODEL_PATH" -f "''${WAV_FILE}.16k.wav" -np 2>/dev/null \
            | grep -E '^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3} -->' \
            | sed -E 's/^\[[0-9:.]+ --> [0-9:.]+\][[:space:]]+//' \
            | grep -vE '^\[[A-Za-z_]+\]$' \
            | paste -sd " " \
            | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        # Type the text
        if [ -n "$TEXT" ]; then
            # Small delay to ensure focus
            sleep 0.1
            wtype "$TEXT "
            notify-send "Dictation" "Done." -t 1000
        else
            notify-send "Dictation" "No speech detected." -t 1000
        fi
    else
        # Start recording
        notify-send "Dictation" "Recording... Press again to stop." -t 2000
        pw-record "$WAV_FILE" &
        echo $! > "$PID_FILE"
    fi
  '';
in {
  options.modules.gui.dictation.enable = lib.mkEnableOption "Whisper dictation script";

  config = lib.mkIf cfg.enable {
    home.packages = [ dictationScript ];
  };
}
