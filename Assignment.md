1.	x86-64 assembly mov rsi, [rdi]; mov edi, $.LC0; xor eax, eax; call printf; ret; It’s time to study some x86-64 assembly! You’ll learn to write basic programs consisting of multiple functions in assembly, targeting the Linux platform. At the end you should be able to demonstrate a simple, interactive program, like a calculator.
My assembly journey documentation 

Step 1 how to code assembly? Does it have an IDE?
https://www.tutorialspoint.com/assembly_programming/index.htm

hmm turns out this is for 32bit^^ 

my first objective is save the string “hello world 0/” in assembly and than print it

considering the strengths and weaknesses of assembly I think creating a calculator is a mood task as you will gain no speed coding in  assembly whichs is ultimately its biggest strength I will try to make a program that calculates decimals of PI in assembly as this is a heavy operation that goes faster the more power you throw at it I think this is a much better use of the language 

https://www.eagle44.io/blog/how-to-configure-an-ide-for-x86-nasm-on-linux/#guide-for-64-bit-x86

 
You
A third one comes from the theory of complex multiplication of elliptic curves, and was discovered by S. Ramanujan. This gives a number of beautiful formulas, but the most useful was missed by Ramanujan and discovered by the Chudnovsky's. It is the following (slightly modified for ease of programming): Set k_1 = 545140134; k_2 = 13591409; k_3 = 640320; k_4 = 100100025; k_5 = 327843840; k_6 = 53360; Then pi = (k_6 sqrt(k_3))/(S), where S = sum_(n = 0)^oo (-1)^n ((6n)!(k_2 + nk_1))/(n!^3(3n)!(8k_4k_5)^n) The great advantages of this formula are that 1) It converges linearly, but very fast (more than 14 decimal digits per term). 2) The way it is written, all operations to compute S can be programmed very simply. This is why the constant 8k_4k_5 appearing in the denominator has been written this way instead of 262537412640768000. This is how the Chudnovsky's have computed several billion decimals. i want to program this in assembly but first i need to understand it can you explain this further
ChatGPT
Certainly, let's break down the expression step by step:

The series term you provided is:
```LaTeX 
\[ (-1)^n \frac{(6n)!(k_2 + nk_1)}{n!^3(3n)!(8k_4k_5)^n} \]
```
Now, let's analyze the components:

1. \( (-1)^n \): This term alternates between -1 and 1 based on the value of \( n \). When \( n \) is even, it becomes 1, and when \( n \) is odd, it becomes -1.

2. \( \frac{(6n)!(k_2 + nk_1)}{n!^3(3n)!(8k_4k_5)^n} \): This fraction involves factorials and coefficients. It might look complex, but it's a mathematical expression that involves the factorial function and constants \( k_1, k_2, k_4, \) and \( k_5 \).

    - \( (6n)! \): The factorial of \( 6n \), which is the product of all positive integers up to \( 6n \).
    - \( n! \): The factorial of \( n \), which is the product of all positive integers up to \( n \).
    - \( (3n)! \): The factorial of \( 3n \), which is the product of all positive integers up to \( 3n \).
    - \( (k_2 + nk_1) \): A linear combination of constants \( k_2 \) and \( k_1 \).
    - \( (8k_4k_5)^n \): \( n \)th power of \( 8k_4k_5 \).

Regarding your concern about calculating the square root of a negative number, this expression doesn't involve square roots of negative numbers. It uses factorials, which are defined for all non-negative integers. The \( (-1)^n \) term ensures that the series alternates between positive and negative values.

The expression might be complex, but it's a valid mathematical formula. If you have a specific question or if there's a part of the expression you'd like more clarification on, feel free to ask!
You
so will this formula calculate more decimals of pi the longer it runs?
ChatGPT
ChatGPT
Yes, that's correct! The Chudnovsky algorithm is known for its rapid convergence, meaning that as you compute more terms in the series (i.e., increase the value of �n in the summation), you get more accurate digits of �π. The rate of convergence is faster compared to some other traditional methods for computing �π, making it particularly efficient for high-precision calculations.
In practice, each additional term in the summation contributes significantly to the precision of the result. The formula you provided, with its specific constants and structure, allows for the calculation of many decimal places of �π with relatively fewer terms compared to other series.
So, by running the algorithm for more iterations (increasing �n), you'll obtain a more accurate approximation of �π with each additional term, and the algorithm will continue to converge toward the true value of �π. However, keep in mind that computational limitations, such as available memory and processing power, may impose practical constraints on the number of iterations you can perform.

a conversation with chatgpt explaining how this might be hard but doable 
Absolutely, breaking down the algorithm into smaller, more manageable components is a good approach. Here's a suggested step-by-step breakdown:

1. **Factorial Function:**
   - Implement a function to calculate the factorial of a given number. This will be essential for the numerator and denominator in the series.

2. **Exponential Function:**
   - Implement a function to perform exponentiation, as the series involves terms with \( (8k_4k_5)^n \).

3. **Series Term Calculation:**
   - Implement a function that takes a value of \( n \) and calculates the individual term in the series: 
     \[ (-1)^n \frac{(6n)!(k_2 + nk_1)}{n!^3(3n)!(8k_4k_5)^n} \]

4. **Summation Function:**
   - Implement a function to sum up the series terms from \( n = 0 \) to some sufficiently large value. Keep summing until the contribution of additional terms becomes negligible.

5. **Final π Calculation:**
   - Once you have the sum \( S \), use it to calculate the final value of \( \pi \) according to the formula:
     \[ \pi = \frac{k_6 \sqrt{k_3}}{S} \]

By breaking down the algorithm into these components, you can test each part independently, ensuring that your implementation is correct at each stage. Once all functions are working as expected, you can then combine them to run the full Chudnovsky algorithm.

Remember to consider efficient ways to perform these calculations in assembly language, as precision and performance are crucial in high-precision computations like those required for calculating many decimal places of \(\pi\).

okay i got the basics of assembly down and i have made a program to calculate the factorial of a number:

```asm
 global _factorial, factorial
;extern int factorial(int *x);

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
 ```

found a c++ implementation of the algo i can use this to build out my asembly version
https://github.com/hyili/PIAlgoChud

calculating pi by hand using chudnovsky algo:
https://www.youtube.com/watch?v=LhlqCJjbEa0


today i implemated the exponential function
```asm 
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
```

today i realised thanks to robert that i have taken on a huge task the math is doable but the default size of integers and floatingpoints are insufficient for this algo
this can be solved by using arbitrary precession floats and ints but programing this in assembly is thesis level stuff
i think i might have a workaround using a c library called gmp as it implements these functions
i hope i can use assembly to access these variables if so this might still be possible if not i will revert to calculating the maximum number of pi i can manage with the build in presision

