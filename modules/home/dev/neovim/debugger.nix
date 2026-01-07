{...}: {
  plugins = {
    dap.enable = true;

    # C/C++/Rust
    dap-lldb.enable = true;

    # Python
    dap-python.enable = true;
  };
}
