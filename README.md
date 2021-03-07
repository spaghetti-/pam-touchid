Pluggable Authentication Module using Touch-ID
----------------------------------------------

This module allows us to authenticate services via touch-id using Apple's
`LocalAuthentication` API. I am using the module to authenticate `sudo` as it's
something we run frequently. The module can be dropped in to authenticate any
other PAM enabled service as well.

NOTE: Apple has added its own pam touch-id module to the OS and you should
use that. Please see: https://news.ycombinator.com/item?id=26302139


Compilation
-----------

Compile this module as the user who has touchid active. Otherwise manually edit
the user id's inside the .m file.


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

Screenshot
----------


Here's what shows on the touchbar when you try to `sudo` with the module
installed

![Touchbar screenshot](tscrot.png)

