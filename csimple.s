.data

.text

.globl Main

Main:
push %ebp
mov %esp, %ebp
push $4
push $2
pop %ebx
pop %eax
div %ebx, %eax
push %eax
push $5
push $2
pop %ebx
pop %eax
imul %ebx, %eax
push %eax
pop %ebx
pop %eax
add %ebx, %eax
push %eax
pop %eax
leave
ret
