extern printf
extern scanf
extern sin
extern cos
global area

segment .data ;Where we put all the text outpurs
;declare pi
pi: dq 0x400921FB54442D18

; DECLARING TEXT
text db "We take care of all your triangles. ",10,0

text2 db "Please enter your name: ",0

name db "%s", 0

text3 db "Goodmorning %s, please enter the length of slide 1, slide 2, and size(degrees) "
      db "of the included angle between them as real float numbers. Seperate the numbers by white "
      db "space, and be sure to press <enter> after the last inputted number.",10,0

input_float3 db "%lf %lf %lf",0

text4 db "Thank you %s. You have entered %.7lf %.7lf %.7lf", 10,0

;valid inputs that are non-negative
area_output db "The area of your triangle is %.7lf square units",10,0
parimeter_output db "The parameter is %.5lf linear units",10,0
goodbye_output db "The area will now be sent to the driver function", 10,0

;invalid inputs
;error db "Unfortunately, one of your inputs is invalid, Please run this program again",10,0
;error2 db "An integer zero will now be sent to the operating system. Have a good day bye", 10,0

segment .bss ;
user resb 64 ; array of bites for user
perimeter: resq 1 ; resq = reserve n qwords (here, n = 1)
area_: resq 1

segment .text
area:

push    rbp
mov     rbp,rsp
push    rbx
push    rcx
push    rdx
push    rdi
push    r8
push    r9
push    r10
push    r11
push    r12
push    r13
push    r14
push    r15
pushf

;Displaying text 1 and 2
push qword 0
;Display a prompt message asking for inputs
mov rax, 0
mov rdi, 0
mov rdi, text ; we take care of all your triangles
call printf
pop rax

push qword 0
;display the text2
mov rax, 0
mov rdi, 0
mov rdi, text2
call printf
pop rax

;Enter Name of user
push qword 0
mov rax,0
mov rdi, name
mov rsi, user
call scanf
pop rax

;display text #3 "Goodmorning Luis,....."
push qword 0
mov rax, 0
mov rdi, text3
mov rsi, user
call printf
pop rax

;inputting 3 floats
push qword -1
push qword -2
push qword -3
mov rax, 0
mov rdi, input_float3  ;"%lf%lf%lf"
mov rsi, rsp                   ;rsi points to first quadword on the stack
mov rdx, rsp
add rdx, 8                     ;rdx points to second quadword on the stack
mov rcx, rsp
add rcx, 16                    ;rcx points to third quadword on the stack
call scanf
movsd xmm15, [rsp]
movsd xmm14, [rsp+8]
movsd xmm13, [rsp+16]
pop rax                        ;Reverse the previous "push qword -3"
pop rax                        ;Reverse the previous "push qword -2"
pop rax                        ;Reverse the previous "push qword -1"


;text 4
push qword 0
mov rax, 3
mov rdi, text4
mov rsi, user
movsd xmm0, xmm15
movsd xmm1, xmm14
movsd xmm2, xmm13
call printf
pop rax

;========================Area CALCULATIONS ====================================
movsd xmm12, [pi] ; xmm12 = pi(numerator)
mov rax, 180
cvtsi2sd xmm11, rax ; xmm11 = 180 (denominator)
divsd xmm12, xmm11 ; xmm12 = pi/180
mulsd xmm13, xmm12 ; -- xmm13 = rad angle --
; area = [A*B*sin(x)] / 2
;xmm15 = Angle A
;xmm14 = Angle B
;xmm13 = Angle(DEGREES)
movsd xmm0, xmm13
call sin ; xmmo == sin(x)

movsd xmm12, xmm0 ; mov xmm 12 onto xmm0
mulsd xmm12, xmm15 ; A * B = Replaces A with result
mulsd xmm12, xmm14 ; A*B result * An
mov rax, 2
cvtsi2sd xmm11, rax; xmm12 == area
divsd xmm12,xmm11
movsd[area_], xmm12
;==============================================================================
;area output
push qword 0
mov rax, 1
movsd xmm0, [area_]
mov rdi, area_output
call printf
pop rax

;========================MATH PORTION =========================================


;PARIMETER
; missing side (C) = sqrt(A^2 + B^2 - 2AB*cos(x))

; xmm15 = A
; xmm14 = B
; xmm13 = angle (rad)
mov rax, 2
cvtsi2sd xmm12, rax
mulsd xmm12, xmm15 ; xmm12 * xmm15 = result changes xmm12 number
mulsd xmm12, xmm14 ; xmm12 = 2AB

movsd xmm11, xmm15 ; xmm11 * xmm12 = result(is stored in xmm11)
mulsd xmm11, xmm11 ; xmm11 = A^2

movsd xmm10, xmm14
mulsd xmm10, xmm10 ; xmm10 = B^2

; cos(x)
movsd xmm0, xmm13
call cos ; xmm0 = cos(x)

mov rax, 1
cvtsi2sd xmm9, rax
mulsd xmm9, xmm12 ; xmm9 = -2AB
mulsd xmm9, xmm0 ; xmm9 = -2AB*cos(x)
addsd xmm9, xmm10
addsd xmm9, xmm11 ; xmm9 = A^2 + B^2 - 2AB*cos(x)
sqrtsd xmm9, xmm9 ; xmm9 = missing side (C)

;; add our sides!
addsd xmm9, xmm15; adds xmm9 with 15, xmm9 number is channged with result
addsd xmm9, xmm14; --- xmm9 = perimeter ---

movsd [perimeter], xmm9 ; store for later

;call perimeter
push qword 0
mov rax, 1
movsd xmm0, [perimeter]
mov rdi, parimeter_output
call printf
pop rax

;goodbye outputs
push qword 0
mov rax,0
mov rdi, goodbye_output
call printf
pop rax

push qword 0
movsd xmm0, [area_]
pop rax

;=========================PRINTING RESULTS=====================================
;movsd xmm0, [perimeter]
;movsd xmm1, [area_]

;Restore the original values to the GPRs
popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Restore rbp
ret
