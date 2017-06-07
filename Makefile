euid=$(shell id -u)
egid=$(shell id -g)

all: 
	clang -fPIC -DPIC -fmodules -shared -rdynamic -DCURRENT_EUID=$(euid) -DCURRENT_EGID=$(egid) -o pam_touchid.so pam_touchid.m

