final: prev: {
  msmtp = prev.msmtp.override {
    commandLineArgs = "--proxy-server='https=127.0.0.1:3128;http=127.0.0.1:3128'";
  };
}
