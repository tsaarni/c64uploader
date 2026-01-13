# Assembly64 Browser - C64 Client
# Oscar64 Makefile

# Oscar64 compiler path (adjust if needed)
OSCAR64 = oscar64

# Oscar64 include path - set if not installed system-wide
# Example: OSCAR64_INCLUDE = /home/user/oscar64/include
OSCAR64_INCLUDE ?=

# Project settings
PROJECT = a64browser
SRCDIR = src
OUTDIR = build

# Source files
SOURCES = $(SRCDIR)/main.c $(SRCDIR)/ultimate.c

# Output files
PRG = $(OUTDIR)/$(PROJECT).prg
CRT = $(OUTDIR)/$(PROJECT).crt
D64 = $(OUTDIR)/$(PROJECT).d64

# Compiler flags
# -n  = native code (faster)
# -O2 = optimization level 2
# -tm = target machine (c64)
CFLAGS = -n -O2 -tm=c64

# Add include path if specified
ifneq ($(OSCAR64_INCLUDE),)
CFLAGS += -i=$(OSCAR64_INCLUDE)
endif

# Cartridge flags (8KB autostart)
CRTFLAGS = -tf=crt8

.PHONY: all clean prg crt d64

all: prg

# Create output directory
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Build PRG file
prg: $(OUTDIR) $(SOURCES)
	$(OSCAR64) $(CFLAGS) -o=$(PRG) $(SOURCES)

# Build CRT cartridge
crt: $(OUTDIR) $(SOURCES)
	$(OSCAR64) $(CFLAGS) $(CRTFLAGS) -o=$(CRT) $(SOURCES)

# Build D64 disk image (requires c1541 from VICE)
d64: prg
	c1541 -format "a64browser,ab" d64 $(D64) -write $(PRG) $(PROJECT)

clean:
	rm -rf $(OUTDIR)

# Run in VICE (x64sc)
run: prg
	x64sc $(PRG)

# Deploy to Ultimate II+ via FTP
# Set U2P_HOST environment variable to your Ultimate's IP
deploy: prg
	@if [ -z "$$U2P_HOST" ]; then echo "Set U2P_HOST to your Ultimate IP"; exit 1; fi
	curl -T $(PRG) ftp://$$U2P_HOST/Usb0/$(PROJECT).prg

help:
	@echo "Assembly64 Browser - C64 Client"
	@echo ""
	@echo "Targets:"
	@echo "  prg     - Build PRG file (default)"
	@echo "  crt     - Build CRT cartridge"
	@echo "  d64     - Build D64 disk image"
	@echo "  run     - Run in VICE emulator"
	@echo "  deploy  - Upload to Ultimate II+ via FTP"
	@echo "  clean   - Remove build files"
	@echo ""
	@echo "Requirements:"
	@echo "  - oscar64 compiler in PATH"
	@echo "  - c1541 (VICE) for d64 target"
	@echo "  - x64sc (VICE) for run target"
