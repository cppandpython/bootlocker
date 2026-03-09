#!/bin/bash


ASM = MBR.asm
BIN = MBR.bin


nasm -f bin $(ASM) -o $(BIN)