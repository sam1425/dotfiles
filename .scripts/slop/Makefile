CC      := gcc
CFLAGS  := -Ofast -Wall -Wextra -std=c11 -D_GNU_SOURCE -march=native -flto -s -fno-plt -DNDEBUG
LDFLAGS := -flto -lpthread -Wl,-O1 -Wl,--as-needed -Wl,--sort-common -Wl,--hash-style=gnu

# Try using system libgit2 via pkg-config
# Fallback to local static if system pkg-config fails or if local directory exists
USE_SYSTEM_LIBGIT2 ?= 1

ifeq ($(USE_SYSTEM_LIBGIT2),1)
    PKGINCS := $(shell pkg-config --cflags libgit2 2>/dev/null)
    PKGLIBS := $(shell pkg-config --libs libgit2 2>/dev/null)
else
    LIBGIT2_DIR := libgit2_src
    PKGINCS     := -I$(LIBGIT2_DIR)/include
    PKGLIBS     := $(LIBGIT2_DIR)/build/libgit2.a -lz
endif

.PHONY: all install uninstall clean check-deps

all: check-deps gitstatus slop slopd

gitstatus: starshipslop.c
	$(CC) $(CFLAGS) $(PKGINCS) -o $@ $< $(LDFLAGS) $(PKGLIBS)

slop: slop.c
	$(CC) $(CFLAGS) -o $@ $<

slopd: slopd.c
	$(CC) $(CFLAGS) $(PKGINCS) -o $@ $< $(LDFLAGS) $(PKGLIBS)

install: all
	@mkdir -p $(HOME)/.local/bin
	install -m 755 gitstatus $(HOME)/.local/bin/gitstatus
	install -m 755 slop $(HOME)/.local/bin/slop
	install -m 755 slopd $(HOME)/.local/bin/slopd
	@echo "Installed binaries to $(HOME)/.local/bin"

uninstall:
	rm -f $(HOME)/.local/bin/gitstatus
	rm -f $(HOME)/.local/bin/slop
	rm -f $(HOME)/.local/bin/slopd

clean:
	rm -f gitstatus slop slopd

check-deps:
ifeq ($(USE_SYSTEM_LIBGIT2),1)
	@pkg-config --exists libgit2 2>/dev/null || { echo "ERROR: libgit2 not found via pkg-config. Try building with USE_SYSTEM_LIBGIT2=0 or install libgit2."; exit 1; }
endif
