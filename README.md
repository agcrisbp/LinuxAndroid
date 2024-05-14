# INSTALL
```
chmod +x install.sh
./install.sh
```

# FIX SOUND & ENABLE MICROPHONE


1. Open/create a file for the TCP and SLES modules:

```
nano /etc/pulse/default.pa.d/tcp_sles.conf
```

- Add the lines:

```
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
load-module module-sles-source
```

2. Open the main PulseAudio configuration file:

```
nano /etc/pulse/default.pa
```

- Add or adjust the echo cancellation section:

```
load-module module-echo-cancel use_master_format=1 aec_method=webrtc source_name=echoCancel_source sink_name=echoCancel_sink
set-default-source echoCancel_source
set-default-sink echoCancel_sink
```

3. Save this to `.bashrc` or `.zshrc`:
```bash
export PULSE_SERVER=127.0.0.1 && pulseaudio --start --exit-idle-time=-1
```

4. Back to Termux:
- Install `pulseaudio`:

```
pkg install pulseaudio -y
```

- Then save this to `.bashrc` or `.zshrc`:

```bash
pulseaudio --start --exit-idle-time=-1
```

- Or just manually:

```
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
load-module module-sles-source
```

5. Restart your Termux!

> GOOD LUCK!!!

## LOGIN

```
charis
```

- sudo psswd:

```
ch
```