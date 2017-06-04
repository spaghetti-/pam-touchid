all: 
	clang -fPIC -DPIC -fmodules -shared -rdynamic -o pam_touchid.so pam_touchid.m
