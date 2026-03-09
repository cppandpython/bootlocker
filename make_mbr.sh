#!/bin/bash


ASM="MBR.asm"
BIN="MBR.bin"


echo "[1/2] Assembling $ASM..."
nasm -f bin "$ASM" -o "$BIN"


echo "[2/2] Checking result..."

if [ $? -eq 0 ]; then
    echo "Build successful → $BIN"
    ls -lh "$BIN"

    SIZE=$(stat -c%s "$BIN")
    echo "Size: $SIZE bytes"

    if [ "$SIZE" -ne 512 ]; then
        echo "Warning: Boot sector should be 512 bytes!"
    fi
else
    echo "Build failed"
    exit 1
fi