CC=gcc

LIBUV_DIR=$(HOME)/program/xcode-projects/libuv

all: idle-basic

idle-basic: idle-basic.c

# -g With debugging info
CFLAGS = -L$(LIBUV_DIR)/build/Debug -I$(LIBUV_DIR)/include -Wall -g -luv -framework CoreFoundation -framework CoreServices

clean:
	rm -rf *.o *.dSYM idle-basic
