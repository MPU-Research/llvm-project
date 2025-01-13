# RUN: llvm-mc %s -triple=riscv64 -mattr=+xmpe -M no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+xmpe < %s \
# RUN:     | llvm-objdump --mattr=+xmpe -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# CHECK-ASM-AND-OBJ: ml m20, (t2)
# CHECK-ASM: encoding: [0x77,0x8a,0x03,0x22]
ml      m20, (x7)

# CHECK-ASM-AND-OBJ: ms m5, (t0)
# CHECK-ASM: encoding: [0xf7,0x92,0x02,0x22]
ms      m5, (x5)

# CHECK-ASM-AND-OBJ: mmac m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x00,0x31,0x66]
mmac    m1, m2, m3

# CHECK-ASM-AND-OBJ: mmacu m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x00,0x31,0x62]
mmacu   m1, m2, m3

# CHECK-ASM-AND-OBJ: mmacf m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x00,0x31,0x6a]
mmacf   m1, m2, m3

# CHECK-ASM-AND-OBJ: madd m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x10,0x31,0x66]
madd    m1, m2, m3

# CHECK-ASM-AND-OBJ: maddu m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x10,0x31,0x62]
maddu   m1, m2, m3

# CHECK-ASM-AND-OBJ: maddf m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x10,0x31,0x6a]
maddf   m1, m2, m3

# CHECK-ASM-AND-OBJ: msub m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x20,0x31,0x66]
msub    m1, m2, m3

# CHECK-ASM-AND-OBJ: msubu m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x20,0x31,0x62]
msubu   m1, m2, m3

# CHECK-ASM-AND-OBJ: msubf m1, m2, m3
# CHECK-ASM: encoding: [0xf7,0x20,0x31,0x6a]
msubf   m1, m2, m3
