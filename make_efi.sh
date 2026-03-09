#!/bin/bash


SRC="UEFI.c"
OBJ="UEFI.o"
SO="UEFI.so"
EFI="UEFI.efi"

EFI_INC="/usr/include/efi"
EFI_INC_X86="/usr/include/efi/x86_64"

EFI_LIB="/usr/lib"
LDS="$EFI_LIB/elf_x86_64_efi.lds"
CRT0="$EFI_LIB/crt0-efi-x86_64.o"


echo "[1/3] Compiling..."
gcc -Os -s \
    -I$EFI_INC -I$EFI_INC_X86 \
    -fpic -fshort-wchar -mno-red-zone \
    -Wall -DEFI_FUNCTION_WRAPPER \
    -c "$SRC" -o "$OBJ"


echo "[2/3] Linking..."
ld -nostdlib -znocombreloc -shared -Bsymbolic \
   -T "$LDS" \
   "$CRT0" \
   "$OBJ" \
   -o "$SO" \
   -L$EFI_LIB -lefi -lgnuefi


echo "[3/3] Creating EFI binary..."
objcopy \
    -j .text -j .sdata -j .data -j .dynamic \
    -j .dynsym -j .rel -j .rela -j .reloc -j .rodata \
    --target=efi-app-x86_64 \
    "$SO" "$EFI"


echo "Cleaning..."
rm -f "$OBJ" "$SO"


echo "Done → $EFI"