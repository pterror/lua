.text
.globl get_environ
get_environ:
  mov environ@GOTPCREL(%rip), %rax
  mov (%rax), %rax
  ret
