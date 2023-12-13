section .data
    KADD_1 dq 13591409
    result dq 0.0
    top_term dq 42698670.6663334
    mid_term dq 0
    K_6 db 0
    K_3 db 3
    K_2 dq -262537412640768000
    K_5 dq 545140134
    K db 0
section .text


global _factorial, factorial
;extern int factorial(int x);
_factorial:
factorial:
	push rbx                        ; save callee-save register
	mov	rax, rdi	                ; save x (param 1) to rax
	mov rcx, 1                      ; initialise rcx to 1

multiplication_loop:
	cmp rax, 0		                ; check if bl reached 0
	je  exit_loop_factorial         ; if yes, go to exit_loop
	imul rcx,rax                    ; multiply the curent value by rax
    dec rax			                ; decrement the value at address of x by one
    jmp multiplication_loop	        ; go to replace_loop

exit_loop_factorial:
	; subroutine epilogue
    pop rbx				; bring back the caller's value of rbx from the stack
    mov rax,rcx         ; return the result of rax
	ret


global _exponential, exponential
;extern int exponential(int x rdi, int n rsi)
_exponential:
exponential:
    push rbx                           ; save callee-save register
    mov rax, 1          ; Initialize result to 1
    mov rcx, rsi        ; Set counter to n

    my_function_loop:
       cmp rcx, 0      ; Check if counter is zero
       je  my_function_end  ; If zero, exit loop
       imul rax, rdi    ; Multiply result by x
       dec rcx          ; Decrement counter
       jmp my_function_loop  ; Jump to the beginning of the loop

    my_function_end:
    ; Result is in rax
    pop rbx				; bring back the caller's value of rbx from the stack
ret



calculateK6:
    push rbx
    mov eax, [K]            ; Load the value of n from the stack
    imul eax, 6             ; Multiply n by 6
    push rdi                ; push rdi to the stack to save it while it is beying used in the next function
    mov rdi, rax            ; assign rdi the value of eax whichs is currently (6n)
    call factorial          ; calculate (6n)!
    pop rdi                 ; restore the value of rdi
    mov [K_6], rax          ; Save the result of (6n)! to K_6
    pop rbx
    ret

calculateK5:
    push rbx
    mov rax, [K]                ; Copy the value from edi to eax
    mov r8, [K_5]
    imul r8, rax
    xor rax, rax
    mov rax, [KADD_1]
    add r8, rax
    xor rax, rax
    mov rax, [K_6]
    imul r8, rax
    mov [mid_term],r8
;    cvtsi2sd xmm1, [K]          ; Convert the value from eax to a double-precision floating-point value
;    movsd xmm0, [K_5]           ; Load the quad-precision floating-point value from memory into xmm register
;    mulsd xmm0, xmm1            ; multiply xmm0 , with xmm1
;    xorps xmm1 ,xmm1
;    movsd xmm0, [KADD_1]        ; move value 13591409.0 into xmm1
;    addsd xmm0, xmm1            ; add (K_5*n) and KADD_1
;    movsd xmm1, [K_6]           ; move k_6 (6n)! into xmm1
;    mulsd xmm0,xmm1             ; multiply (6n)!*(K_5n+KADD_1)
;    movsd [mid_term], xmm0      ; Store the result back into memory
;    movq rax, xmm0             ; Return the contents of K_5 (xmm0 contains the result)
    pop rbx
    ret

calculateK3:
    push rbx
    mov eax, [K]            ; Load the value of n from the stack
    imul eax, 3             ; Multiply n by 3

    push rdi                ; push rdi to the stack to save it while it is beying used in the next function
    mov rdi, rax            ; assign rdi the value of rax which is currently (3n)
    call factorial          ; calculate (3n)!
    pop rdi                 ; restore the value of rdi
    mov [K_3], rax          ; Save the result of (3n)! to K_3

    call factorial          ; callculate the factorial of n
    push rdi                ; save rdi
    mov rdi, rax            ; assign rdi to the result of n!
    mov rsi, 3              ; set the exponent
    call exponential        ; calculate (n!)^3
    mov R8 , [K_3]          ; load k_3 into r8 register
    imul R8, rax            ; calculate (3n)!*(n!)^3
    mov [K_3], R8           ; Save the result to K_3
    pop rdi                 ; restore rdi to n
    pop rbx
    ret

calculateK2:
    push rbx
    push rdi
    mov rsi, [K]        ;load n from the stack
    mov rdi, [K_2]
    call exponential
    mov R8, [K_3]
    imul R8, rax
    mov [K_2],R8
    pop rdi
    pop rbx
    ret




global _term_calculation, term_calculation ; extern double term_calculation(int n)
_term_calculation:
term_calculation:
    push rbx
    mov [K], edi
    call calculateK6
    call calculateK5
    call calculateK3
    call calculateK2

    cvtsi2sd xmm0,  [mid_term]    ; Load mid_term into xmm0
    cvtsi2sd xmm1,  [K_2]
    divsd xmm0, xmm1                ; Divide mid_term by K_2, result in xmm0
    xorps xmm1, xmm1
    movsd xmm1, [top_term]
    divsd xmm1, xmm0
    movsd  xmm0, xmm1
    movsd [result],xmm1
    pop rbx
    ret



global _test_term, test_term
_test_term:
test_term:
    push rbx
    mov [K], edi
    call calculateK6 ; confirmed working
    call calculateK5
    call calculateK3
;    call calculateK2
    mov rax, [K_2]
    pop rbx
    ret


;section .text
;    global my_double_function
;
;my_double_function:
;    ; input: xmm0 = first double parameter
;    ;        xmm1 = second double parameter
;    ; output: xmm0 = return value (double)
;
;    ; Your assembly code here to perform the computation
;    ; example: add the two double parameters
;    addsd xmm0, xmm1
;
;    ; return
;    ret


;global _term_calculation, term_calculation
;    ; extern double term_calculation(int n)
;_term_calculation:
;term_calculation:
;    push rbx                            ; save callee-save register
;
;    mov R8, rsi                        ; move n to rax dividend
;    mov rcx, 2                          ; set rcx to 2  divisor
;
;    xor rdx, rdx                           ; clear rdx
;    div rcx                             ; rax = rax / rcx, rdx = rax % rcx
;
;    cmp rdx,0                           ; check if the remainder is one
;    je remainder_is_zero ; jump if equal (remainder is zero)
;    mov R9, -1           ; set rcx to -1 (remainder is not zero)
;    jmp done              ; jump to the end
;
;    remainder_is_zero:
;    mov R9, 1            ; set rcx to 1 (remainder is zero)
;    jmp done
;
;    done:               ;code continues from here with R9 set to eighter -1 or 1
;    mov rdi, 6          ; set rdi to 6
;    imul rdi, R8        ; multiply rdi by n and save it to rdi
;    jmp factorial       ; calculate factorial of rdi
;    mov R10, rax        ; the result of factorial is put into r10
;    mov R11, [k_1]      ; move k_2 to r11
;    imul R11 , R8       ; multiply k1 by n
;    add R11, [k_2]      ;add k2
;    imul R10, R11       ; multiply the top half of the equation together into R10
;                        ; this code should now conclude the calculation for the numerator of the division
;
;
;ret






;;global _func, func		; '_func' for compatiility with NASM for Windows
;;
;;
;_func:
;func:
;	; subroutine prologue
;	push rbx        	; save callee-save register
;	mov	rax, rdi		; save address of *a (param 1) to rax
;
;	; subroutine body
;replace_loop:
;	mov bl, [rax]		; move value at address rax into 8bit register bl
;	cmp bl, 0			; check if reached end of string
;	je exit_loop		; if yes, go to exit_loop
;	cmp bl, 'a'			; check if current letter is 'a'
;	jne increment_loop	; if not, go to increment_loop
;	mov	BYTE [rax], '*'	; it is 'a' so change it to '*'
;
;increment_loop:
;    inc rax				; increment address of string by one byte
;    jmp replace_loop	; go to replace_loop
;
;exit_loop:
;	; subroutine epilogue
;	xor	rax, rax		; rax = 0
;	pop rbx				; bring back the caller's value of rbx from the stack
;	ret

;global _somefunction, somefunction
;
;_somefunction:
;somefunction:
;    mov rax, 123
;    ret
