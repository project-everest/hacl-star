#include <stdio.h>
#include <stdint.h>
#include "vale_testInline.h"

int fail(char *s)
{
    printf("Vale TestInline failed: %s\n", s);
    return 1;
}

int main()
{
    if (test_inline_mov_input(10) != 10) {return fail("test_inline_mov_input");}
    if (test_inline_mov_add_input(20) != 21) {return fail("test_inline_mov_add_input");}
    if (test_inline_mul_inputs(33, 1000) != 33000) {return fail("test_inline_mul_inputs");}
    if (test_inline_mov_mul_rax_100(44) != 4400) {return fail("test_inline_mov_mul_rax_100");}
//TODO:    if (test_inline_mov_add_input_dummy_mul(50) != 51) {return fail("test_inline_mov_add_input_dummy_mul");}
    return 0;
}
