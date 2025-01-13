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

# CHECK-ASM-AND-OBJ: mmv.mm m1, m2
# CHECK-ASM: encoding: [0xf7,0x00,0x01,0x42]
mmv.mm m1, m2

# CHECK-ASM-AND-OBJ: mmv.xm m1, sp
# CHECK-ASM: encoding: [0xf7,0x00,0x11,0x42]
mmv.xm m1, x2

# CHECK-ASM-AND-OBJ: mmv.zx ra, m2
# CHECK-ASM: encoding: [0xf7,0x00,0x21,0x42]
mmv.zx x1, m2

# CHECK-ASM-AND-OBJ: mmv.zm m1, m2
# CHECK-ASM: encoding: [0xf7,0x00,0x41,0x42]
mmv.zm m1, m2

# CHECK-ASM-AND-OBJ: mmv.fm m1, ft2
# CHECK-ASM: encoding: [0xf7,0x00,0x51,0x42]
mmv.fm m1, f2

# CHECK-ASM-AND-OBJ: mmv.zf ft1, m2
# CHECK-ASM: encoding: [0xf7,0x00,0x61,0x42]
mmv.zf f1, m2

# CHECK-ASM-AND-OBJ: mmv.fz m1, ft2
# CHECK-ASM: encoding: [0xf7,0x00,0x71,0x42]
mmv.fz m1, f2

# CHECK-ASM-AND-OBJ: mmv.xm m1, zero
# CHECK-ASM: encoding: [0xf7,0x00,0x10,0x42]
mzero  m1

# CHECK-ASM-AND-OBJ: mmv.xm m2, zero
# CHECK-ASM: encoding: [0x77,0x01,0x10,0x42]
mz  m2
