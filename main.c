#include <stdio.h>
#include "gmp.h"


extern int factorial(int x);
extern int exponential(int x, int n);
extern double my_double_function(double a, double b);
extern  double term_calculation(int n);
extern long long int test_term(int n);



int main(void)
{

//    printf(" result %lld",
//           test_term(0));


    printf(" result %.20f",
           term_calculation(0));

//    for (int i = 0; i < 10; ++i) {
//        printf("result of %d = %d\n",i, factorial(i));
//    }
//    int x = 6000;
//    mpz_t bigint;
//    mpz_init(bigint);
//    mpz_t another;
//    mpz_init(another);
//    mpz_fac_ui(bigint, x);
//    mpz_set_ui(another, 10);
//    gmp_printf("this is a number = %Zd \n\n", another);
//    gmp_printf("factorial of %d = \n\n %Zd \n\n", x, bigint);

//    printf("%d\n",somefunction());
//    char text[]="abracadabra";
//
//    printf("Input string      > %s\n", text);
//    func(&text[0]); // &text[0] = text
//    printf("Conversion results> %s\n", text);

    return 0;
}
