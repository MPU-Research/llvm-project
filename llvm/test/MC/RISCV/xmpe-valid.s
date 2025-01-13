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
