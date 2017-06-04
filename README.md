Pluggable Authenticate Module for Touch-ID
------------------------------------------

This module allows us to authenticate services via touch-id using Apple's
`LocalAuthentication` API. I am using the module to authenticate `sudo` as it is
a frequent command.

Compilation
-----------

`make all`

Caveats
------- 

The compiled module must be installed to `/usr/lib/pam` which is a system
directory protected by System Integrity Protection (SIP). To install the module
you have to disable this (no worries, it can be enabled later).

Reboot while holding Command-R, go into the recovery mode and spawn a new shell.
In the shell run 

```
csrutil disable
```

Reboot, copy the module over by doing `sudo cp pam_touchid.so /usr/lib/pam/`

Next, add this line to the top of `/etc/pam.d/sudo` 

```
auth       sufficient     pam_touchid.so
```

This also allows fallback to standard password authentication if your finger
fails.

Reboot back into recovery to enable SIP again

```
csrutil enable
```

