/* This file auto-generated by KreMLin! */
#ifndef __Hacl_Bignum_Modulo_H
#define __Hacl_Bignum_Modulo_H


#include "Prims.h"
#include "FStar_Mul.h"
#include "FStar_Squash.h"
#include "FStar_StrongExcludedMiddle.h"
#include "FStar_List_Tot.h"
#include "FStar_Classical.h"
#include "FStar_ListProperties.h"
#include "FStar_SeqProperties.h"
#include "FStar_Math_Lemmas.h"
#include "FStar_BitVector.h"
#include "FStar_UInt.h"
#include "FStar_Int.h"
#include "FStar_FunctionalExtensionality.h"
#include "FStar_PropositionalExtensionality.h"
#include "FStar_PredicateExtensionality.h"
#include "FStar_TSet.h"
#include "FStar_Set.h"
#include "FStar_Map.h"
#include "FStar_Ghost.h"
#include "FStar_All.h"
#include "Hacl_UInt64.h"
#include "Hacl_UInt128.h"
#include "Hacl_UInt32.h"
#include "Hacl_UInt8.h"
#include "Hacl_Cast.h"
#include "Hacl_Bignum_Constants.h"
#include "FStar_Buffer.h"
#include "Hacl_Bignum_Parameters.h"
#include "Hacl_Bignum_Limb.h"
#include "Hacl_Bignum_Wide.h"
#include "Hacl_Bignum_Bigint.h"
#include "Hacl_Bignum_Fsum_Spec.h"
#include "Hacl_Bignum_Fsum.h"
#include "Hacl_Bignum_Fproduct_Spec.h"
#include "Hacl_Bignum_Fmul_Lemmas.h"
#include "kremlib.h"
#include "testlib.h"

extern uint64_t Hacl_Bignum_Modulo_mask_2_44;

extern uint64_t Hacl_Bignum_Modulo_mask_2_42;

extern uint64_t Hacl_Bignum_Modulo_five;

void Hacl_Bignum_Modulo_add_zero(uint64_t *b);

void Hacl_Bignum_Modulo_carry_top(uint64_t *b);

bool Hacl_Bignum_Modulo_reduce_pre(void *s);

void *Hacl_Bignum_Modulo_reduce_spec(void *s);

void Hacl_Bignum_Modulo_reduce(uint64_t *b);

void *Hacl_Bignum_Modulo_carry_top_wide_spec(void *s);

void Hacl_Bignum_Modulo_carry_top_wide(FStar_UInt128_t *b);
#endif
