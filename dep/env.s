.text
.globl env
env:
  mov environ@GOTPCREL(%rip), %rax
  mov (%rax), %rax
  ret
