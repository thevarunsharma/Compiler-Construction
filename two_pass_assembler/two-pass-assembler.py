#!/usr/bin/env python3

import sys
import re

class TwoPassAssembler:
    opcodes = { "MVI_A" : "3E",
                "LDA" : "3A",
                "STA" : "32",
                "MOV_B_A" : "47",
                "MVI_A" : "3E",
                "ADD_B" : "80",
                "ADI" : "C6" ,
                "HLT" : "76"}
    def __init__(self, filename, start_addr):
        self.filename = filename
        self.start_addr = start_addr
        self.table = {}
        self.labels = {}
        self.end_addr = start_addr

    def symbol_parse(self):
        prog = open(self.filename, "r")
        lines = prog.readlines()
        prog.close()
        addr = self.start_addr
        prev = ""
        for line in lines:
            lab = re.findall(r"([0-9a-zA-Z_]+)\s*:", line)
            labi = 0
            words = re.findall(r"[0-9a-zA-Z_]+", line)
            for word in words:
                if word in self.labels:
                    word = "%.4X"%self.labels[word]
                if prev in {"STA", "LDA", "JMP", "CALL"} and re.match(r"[0-9a-fA-F]{4}", word):
                    byte2, byte1 = word[:2], word[2:]
                    self.table[addr] = byte1
                    addr = (addr + 1)&0xFFFF
                    self.table[addr] = byte2
                    addr = (addr + 1)&0xFFFF
                elif labi < len(lab) and word == lab[labi]:
                    self.labels[word] = addr
                    labi += 1
                else:
                    self.table[addr] = word
                    addr = (addr + 1)&0xFFFF
                prev = word
        self.end_addr = addr

    def to_machine_code(self):
        machine_code = {}
        addr = self.start_addr
        while addr != self.end_addr:
            tok = self.table[addr]
            if tok in __class__.opcodes:
                tok = __class__.opcodes[tok]
            machine_code[addr] = tok
            addr = (addr + 1)&0xFFFF
        return machine_code

start_addr = int(sys.argv[2], 16)
if start_addr < 0x0000 or start_addr > 0xFFFF:
    print("Error: invalid starting address for 8085")
    sys.exit(-1)
filename = sys.argv[1]

assembler = TwoPassAssembler(filename, start_addr)
assembler.symbol_parse()
machine_code = assembler.to_machine_code()

addr = assembler.start_addr
print("Address\t\tPnemonic\tMachine Code")
while addr != assembler.end_addr:
    print("0x%.4X\t\t%s\t\t%s"%(addr, assembler.table[addr], machine_code[addr]))
    addr = (addr + 1)&0xFFFF
