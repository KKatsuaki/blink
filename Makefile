##--PROJECT INFO--######################################
PROJECT      =kernel8
IMG          =$(PROJECT).img
ELF	     =$(PROJECT).elf
TARGET       =aarch64
OBJDIR       =tmp
SRCDIR       =src
INCLUDE      =headers
STARTUP      =$(SRCDIR)/boot.S
STARTUP_OBJ  =$(OBJDIR)/boot.o
LINK         =link.ld
SRCS         =$(wildcard $(SRCDIR)/*.c)
OBJS         =$(SRCS:src/%.c=tmp/%.o)
DUMP         =$(PROJECT).dump
SD_CARD      = #/path/to/mounted sd-card
########################################################

##--OPTIONS and FLAGS--#################################
CFLAGS   = -Wall -O2 -ffreestanding -nostdinc -nostdlib -mcpu=cortex-a72+nosimd -I $(INCLUDE)
LD       = ld.lld
OBJCOPY  = llvm-objcopy
OBJDUMP  = llvm-objdump
########################################################

##--comands depend on dev system--######################
EJECT = diskutil eject #command to eject sd card (default: for macOS)
########################################################

all: dump
build: $(IMG) 
dump: $(DUMP)

$(OBJDIR):;@mkdir $@

$(STARTUP_OBJ): $(STARTUP)
	clang --target=$(TARGET)-elf $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	clang --target=$(TARGET)-elf $(CFLAGS) -c $< -o $@

$(ELF): $(OBJDIR) $(STARTUP_OBJ) $(OBJS) 
	$(LD) -m $(TARGET)elf -nostdlib $(STARTUP_OBJ) $(OBJS) -T $(LINK) -o $@
$(IMG): $(ELF)
	$(OBJCOPY) -O binary $< $@

clean:; rm -rf $(ELF) $(OBJDIR) *~ */*~ $(DUMP) src/*.o
distclean: clean
	rm -rf $(IMG) 

$(DUMP): $(ELF)
	@rm -rf $(DUMP)
	@echo `date` > $(DUMP)
	@$(OBJDUMP) -d $(ELF) | tee -a $(PROJECT).dump | less

cp: $(IMG)
	cp $(IMG) $(SD_CARD)/$(IMG)
	$(EJECT) $(SD_CARD)
