module Spec.FFDHE

open FStar.Mul

open Lib.IntTypes
open Lib.Sequence
open Lib.ByteSequence

#set-options "--z3rlimit 50 --fuel 0 --ifuel 0"

(** https://tools.ietf.org/html/rfc7919#appendix-A *)

noeq type ffdhe_params_t =
  | Mk_ffdhe_params:
       ffdhe_p_len:size_nat
    -> ffdhe_p:lseq pub_uint8 ffdhe_p_len
    -> ffdhe_g_len:size_nat
    -> ffdhe_g:lseq pub_uint8 ffdhe_g_len
    -> ffdhe_params_t


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_g2: List.Tot.llist pub_uint8 1 =
  [@inline_let]
  let l = [ 0x02uy ] in
  assert_norm (List.Tot.length l == 1);
  l

let ffdhe_g2: lseq pub_uint8 1 = of_list list_ffdhe_g2


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_p2048: List.Tot.llist pub_uint8 256 =
  [@inline_let]
  let l = [
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy;
    0xADuy; 0xF8uy; 0x54uy; 0x58uy; 0xA2uy; 0xBBuy; 0x4Auy; 0x9Auy;
    0xAFuy; 0xDCuy; 0x56uy; 0x20uy; 0x27uy; 0x3Duy; 0x3Cuy; 0xF1uy;
    0xD8uy; 0xB9uy; 0xC5uy; 0x83uy; 0xCEuy; 0x2Duy; 0x36uy; 0x95uy;
    0xA9uy; 0xE1uy; 0x36uy; 0x41uy; 0x14uy; 0x64uy; 0x33uy; 0xFBuy;
    0xCCuy; 0x93uy; 0x9Duy; 0xCEuy; 0x24uy; 0x9Buy; 0x3Euy; 0xF9uy;
    0x7Duy; 0x2Fuy; 0xE3uy; 0x63uy; 0x63uy; 0x0Cuy; 0x75uy; 0xD8uy;
    0xF6uy; 0x81uy; 0xB2uy; 0x02uy; 0xAEuy; 0xC4uy; 0x61uy; 0x7Auy;
    0xD3uy; 0xDFuy; 0x1Euy; 0xD5uy; 0xD5uy; 0xFDuy; 0x65uy; 0x61uy;
    0x24uy; 0x33uy; 0xF5uy; 0x1Fuy; 0x5Fuy; 0x06uy; 0x6Euy; 0xD0uy;
    0x85uy; 0x63uy; 0x65uy; 0x55uy; 0x3Duy; 0xEDuy; 0x1Auy; 0xF3uy;
    0xB5uy; 0x57uy; 0x13uy; 0x5Euy; 0x7Fuy; 0x57uy; 0xC9uy; 0x35uy;
    0x98uy; 0x4Fuy; 0x0Cuy; 0x70uy; 0xE0uy; 0xE6uy; 0x8Buy; 0x77uy;
    0xE2uy; 0xA6uy; 0x89uy; 0xDAuy; 0xF3uy; 0xEFuy; 0xE8uy; 0x72uy;
    0x1Duy; 0xF1uy; 0x58uy; 0xA1uy; 0x36uy; 0xADuy; 0xE7uy; 0x35uy;
    0x30uy; 0xACuy; 0xCAuy; 0x4Fuy; 0x48uy; 0x3Auy; 0x79uy; 0x7Auy;
    0xBCuy; 0x0Auy; 0xB1uy; 0x82uy; 0xB3uy; 0x24uy; 0xFBuy; 0x61uy;
    0xD1uy; 0x08uy; 0xA9uy; 0x4Buy; 0xB2uy; 0xC8uy; 0xE3uy; 0xFBuy;
    0xB9uy; 0x6Auy; 0xDAuy; 0xB7uy; 0x60uy; 0xD7uy; 0xF4uy; 0x68uy;
    0x1Duy; 0x4Fuy; 0x42uy; 0xA3uy; 0xDEuy; 0x39uy; 0x4Duy; 0xF4uy;
    0xAEuy; 0x56uy; 0xEDuy; 0xE7uy; 0x63uy; 0x72uy; 0xBBuy; 0x19uy;
    0x0Buy; 0x07uy; 0xA7uy; 0xC8uy; 0xEEuy; 0x0Auy; 0x6Duy; 0x70uy;
    0x9Euy; 0x02uy; 0xFCuy; 0xE1uy; 0xCDuy; 0xF7uy; 0xE2uy; 0xECuy;
    0xC0uy; 0x34uy; 0x04uy; 0xCDuy; 0x28uy; 0x34uy; 0x2Fuy; 0x61uy;
    0x91uy; 0x72uy; 0xFEuy; 0x9Cuy; 0xE9uy; 0x85uy; 0x83uy; 0xFFuy;
    0x8Euy; 0x4Fuy; 0x12uy; 0x32uy; 0xEEuy; 0xF2uy; 0x81uy; 0x83uy;
    0xC3uy; 0xFEuy; 0x3Buy; 0x1Buy; 0x4Cuy; 0x6Fuy; 0xADuy; 0x73uy;
    0x3Buy; 0xB5uy; 0xFCuy; 0xBCuy; 0x2Euy; 0xC2uy; 0x20uy; 0x05uy;
    0xC5uy; 0x8Euy; 0xF1uy; 0x83uy; 0x7Duy; 0x16uy; 0x83uy; 0xB2uy;
    0xC6uy; 0xF3uy; 0x4Auy; 0x26uy; 0xC1uy; 0xB2uy; 0xEFuy; 0xFAuy;
    0x88uy; 0x6Buy; 0x42uy; 0x38uy; 0x61uy; 0x28uy; 0x5Cuy; 0x97uy;
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy
  ] in
  assert_norm (List.Tot.length l == 256);
  l

let ffdhe_p2048: lseq pub_uint8 256 = of_list list_ffdhe_p2048

// The estimated symmetric-equivalent strength of this group is 103 bits.
let ffdhe_params_2048 : ffdhe_params_t =
  Mk_ffdhe_params 256 ffdhe_p2048 1 ffdhe_g2


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_p3072: List.Tot.llist pub_uint8 384 =
  [@inline_let]
  let l = [
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy;
    0xADuy; 0xF8uy; 0x54uy; 0x58uy; 0xA2uy; 0xBBuy; 0x4Auy; 0x9Auy;
    0xAFuy; 0xDCuy; 0x56uy; 0x20uy; 0x27uy; 0x3Duy; 0x3Cuy; 0xF1uy;
    0xD8uy; 0xB9uy; 0xC5uy; 0x83uy; 0xCEuy; 0x2Duy; 0x36uy; 0x95uy;
    0xA9uy; 0xE1uy; 0x36uy; 0x41uy; 0x14uy; 0x64uy; 0x33uy; 0xFBuy;
    0xCCuy; 0x93uy; 0x9Duy; 0xCEuy; 0x24uy; 0x9Buy; 0x3Euy; 0xF9uy;
    0x7Duy; 0x2Fuy; 0xE3uy; 0x63uy; 0x63uy; 0x0Cuy; 0x75uy; 0xD8uy;
    0xF6uy; 0x81uy; 0xB2uy; 0x02uy; 0xAEuy; 0xC4uy; 0x61uy; 0x7Auy;
    0xD3uy; 0xDFuy; 0x1Euy; 0xD5uy; 0xD5uy; 0xFDuy; 0x65uy; 0x61uy;
    0x24uy; 0x33uy; 0xF5uy; 0x1Fuy; 0x5Fuy; 0x06uy; 0x6Euy; 0xD0uy;
    0x85uy; 0x63uy; 0x65uy; 0x55uy; 0x3Duy; 0xEDuy; 0x1Auy; 0xF3uy;
    0xB5uy; 0x57uy; 0x13uy; 0x5Euy; 0x7Fuy; 0x57uy; 0xC9uy; 0x35uy;
    0x98uy; 0x4Fuy; 0x0Cuy; 0x70uy; 0xE0uy; 0xE6uy; 0x8Buy; 0x77uy;
    0xE2uy; 0xA6uy; 0x89uy; 0xDAuy; 0xF3uy; 0xEFuy; 0xE8uy; 0x72uy;
    0x1Duy; 0xF1uy; 0x58uy; 0xA1uy; 0x36uy; 0xADuy; 0xE7uy; 0x35uy;
    0x30uy; 0xACuy; 0xCAuy; 0x4Fuy; 0x48uy; 0x3Auy; 0x79uy; 0x7Auy;
    0xBCuy; 0x0Auy; 0xB1uy; 0x82uy; 0xB3uy; 0x24uy; 0xFBuy; 0x61uy;
    0xD1uy; 0x08uy; 0xA9uy; 0x4Buy; 0xB2uy; 0xC8uy; 0xE3uy; 0xFBuy;
    0xB9uy; 0x6Auy; 0xDAuy; 0xB7uy; 0x60uy; 0xD7uy; 0xF4uy; 0x68uy;
    0x1Duy; 0x4Fuy; 0x42uy; 0xA3uy; 0xDEuy; 0x39uy; 0x4Duy; 0xF4uy;
    0xAEuy; 0x56uy; 0xEDuy; 0xE7uy; 0x63uy; 0x72uy; 0xBBuy; 0x19uy;
    0x0Buy; 0x07uy; 0xA7uy; 0xC8uy; 0xEEuy; 0x0Auy; 0x6Duy; 0x70uy;
    0x9Euy; 0x02uy; 0xFCuy; 0xE1uy; 0xCDuy; 0xF7uy; 0xE2uy; 0xECuy;
    0xC0uy; 0x34uy; 0x04uy; 0xCDuy; 0x28uy; 0x34uy; 0x2Fuy; 0x61uy;
    0x91uy; 0x72uy; 0xFEuy; 0x9Cuy; 0xE9uy; 0x85uy; 0x83uy; 0xFFuy;
    0x8Euy; 0x4Fuy; 0x12uy; 0x32uy; 0xEEuy; 0xF2uy; 0x81uy; 0x83uy;
    0xC3uy; 0xFEuy; 0x3Buy; 0x1Buy; 0x4Cuy; 0x6Fuy; 0xADuy; 0x73uy;
    0x3Buy; 0xB5uy; 0xFCuy; 0xBCuy; 0x2Euy; 0xC2uy; 0x20uy; 0x05uy;
    0xC5uy; 0x8Euy; 0xF1uy; 0x83uy; 0x7Duy; 0x16uy; 0x83uy; 0xB2uy;
    0xC6uy; 0xF3uy; 0x4Auy; 0x26uy; 0xC1uy; 0xB2uy; 0xEFuy; 0xFAuy;
    0x88uy; 0x6Buy; 0x42uy; 0x38uy; 0x61uy; 0x1Fuy; 0xCFuy; 0xDCuy;
    0xDEuy; 0x35uy; 0x5Buy; 0x3Buy; 0x65uy; 0x19uy; 0x03uy; 0x5Buy;
    0xBCuy; 0x34uy; 0xF4uy; 0xDEuy; 0xF9uy; 0x9Cuy; 0x02uy; 0x38uy;
    0x61uy; 0xB4uy; 0x6Fuy; 0xC9uy; 0xD6uy; 0xE6uy; 0xC9uy; 0x07uy;
    0x7Auy; 0xD9uy; 0x1Duy; 0x26uy; 0x91uy; 0xF7uy; 0xF7uy; 0xEEuy;
    0x59uy; 0x8Cuy; 0xB0uy; 0xFAuy; 0xC1uy; 0x86uy; 0xD9uy; 0x1Cuy;
    0xAEuy; 0xFEuy; 0x13uy; 0x09uy; 0x85uy; 0x13uy; 0x92uy; 0x70uy;
    0xB4uy; 0x13uy; 0x0Cuy; 0x93uy; 0xBCuy; 0x43uy; 0x79uy; 0x44uy;
    0xF4uy; 0xFDuy; 0x44uy; 0x52uy; 0xE2uy; 0xD7uy; 0x4Duy; 0xD3uy;
    0x64uy; 0xF2uy; 0xE2uy; 0x1Euy; 0x71uy; 0xF5uy; 0x4Buy; 0xFFuy;
    0x5Cuy; 0xAEuy; 0x82uy; 0xABuy; 0x9Cuy; 0x9Duy; 0xF6uy; 0x9Euy;
    0xE8uy; 0x6Duy; 0x2Buy; 0xC5uy; 0x22uy; 0x36uy; 0x3Auy; 0x0Duy;
    0xABuy; 0xC5uy; 0x21uy; 0x97uy; 0x9Buy; 0x0Duy; 0xEAuy; 0xDAuy;
    0x1Duy; 0xBFuy; 0x9Auy; 0x42uy; 0xD5uy; 0xC4uy; 0x48uy; 0x4Euy;
    0x0Auy; 0xBCuy; 0xD0uy; 0x6Buy; 0xFAuy; 0x53uy; 0xDDuy; 0xEFuy;
    0x3Cuy; 0x1Buy; 0x20uy; 0xEEuy; 0x3Fuy; 0xD5uy; 0x9Duy; 0x7Cuy;
    0x25uy; 0xE4uy; 0x1Duy; 0x2Buy; 0x66uy; 0xC6uy; 0x2Euy; 0x37uy;
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy
  ] in
  assert_norm (List.Tot.length l == 384);
  l

let ffdhe_p3072: lseq pub_uint8 384 = of_list list_ffdhe_p3072

// The estimated symmetric-equivalent strength of this group is 125 bits.
let ffdhe_params_3072 : ffdhe_params_t =
  Mk_ffdhe_params 384 ffdhe_p3072 1 ffdhe_g2


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_p4096: List.Tot.llist pub_uint8 512 =
  [@inline_let]
  let l = [
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy;
    0xADuy; 0xF8uy; 0x54uy; 0x58uy; 0xA2uy; 0xBBuy; 0x4Auy; 0x9Auy;
    0xAFuy; 0xDCuy; 0x56uy; 0x20uy; 0x27uy; 0x3Duy; 0x3Cuy; 0xF1uy;
    0xD8uy; 0xB9uy; 0xC5uy; 0x83uy; 0xCEuy; 0x2Duy; 0x36uy; 0x95uy;
    0xA9uy; 0xE1uy; 0x36uy; 0x41uy; 0x14uy; 0x64uy; 0x33uy; 0xFBuy;
    0xCCuy; 0x93uy; 0x9Duy; 0xCEuy; 0x24uy; 0x9Buy; 0x3Euy; 0xF9uy;
    0x7Duy; 0x2Fuy; 0xE3uy; 0x63uy; 0x63uy; 0x0Cuy; 0x75uy; 0xD8uy;
    0xF6uy; 0x81uy; 0xB2uy; 0x02uy; 0xAEuy; 0xC4uy; 0x61uy; 0x7Auy;
    0xD3uy; 0xDFuy; 0x1Euy; 0xD5uy; 0xD5uy; 0xFDuy; 0x65uy; 0x61uy;
    0x24uy; 0x33uy; 0xF5uy; 0x1Fuy; 0x5Fuy; 0x06uy; 0x6Euy; 0xD0uy;
    0x85uy; 0x63uy; 0x65uy; 0x55uy; 0x3Duy; 0xEDuy; 0x1Auy; 0xF3uy;
    0xB5uy; 0x57uy; 0x13uy; 0x5Euy; 0x7Fuy; 0x57uy; 0xC9uy; 0x35uy;
    0x98uy; 0x4Fuy; 0x0Cuy; 0x70uy; 0xE0uy; 0xE6uy; 0x8Buy; 0x77uy;
    0xE2uy; 0xA6uy; 0x89uy; 0xDAuy; 0xF3uy; 0xEFuy; 0xE8uy; 0x72uy;
    0x1Duy; 0xF1uy; 0x58uy; 0xA1uy; 0x36uy; 0xADuy; 0xE7uy; 0x35uy;
    0x30uy; 0xACuy; 0xCAuy; 0x4Fuy; 0x48uy; 0x3Auy; 0x79uy; 0x7Auy;
    0xBCuy; 0x0Auy; 0xB1uy; 0x82uy; 0xB3uy; 0x24uy; 0xFBuy; 0x61uy;
    0xD1uy; 0x08uy; 0xA9uy; 0x4Buy; 0xB2uy; 0xC8uy; 0xE3uy; 0xFBuy;
    0xB9uy; 0x6Auy; 0xDAuy; 0xB7uy; 0x60uy; 0xD7uy; 0xF4uy; 0x68uy;
    0x1Duy; 0x4Fuy; 0x42uy; 0xA3uy; 0xDEuy; 0x39uy; 0x4Duy; 0xF4uy;
    0xAEuy; 0x56uy; 0xEDuy; 0xE7uy; 0x63uy; 0x72uy; 0xBBuy; 0x19uy;
    0x0Buy; 0x07uy; 0xA7uy; 0xC8uy; 0xEEuy; 0x0Auy; 0x6Duy; 0x70uy;
    0x9Euy; 0x02uy; 0xFCuy; 0xE1uy; 0xCDuy; 0xF7uy; 0xE2uy; 0xECuy;
    0xC0uy; 0x34uy; 0x04uy; 0xCDuy; 0x28uy; 0x34uy; 0x2Fuy; 0x61uy;
    0x91uy; 0x72uy; 0xFEuy; 0x9Cuy; 0xE9uy; 0x85uy; 0x83uy; 0xFFuy;
    0x8Euy; 0x4Fuy; 0x12uy; 0x32uy; 0xEEuy; 0xF2uy; 0x81uy; 0x83uy;
    0xC3uy; 0xFEuy; 0x3Buy; 0x1Buy; 0x4Cuy; 0x6Fuy; 0xADuy; 0x73uy;
    0x3Buy; 0xB5uy; 0xFCuy; 0xBCuy; 0x2Euy; 0xC2uy; 0x20uy; 0x05uy;
    0xC5uy; 0x8Euy; 0xF1uy; 0x83uy; 0x7Duy; 0x16uy; 0x83uy; 0xB2uy;
    0xC6uy; 0xF3uy; 0x4Auy; 0x26uy; 0xC1uy; 0xB2uy; 0xEFuy; 0xFAuy;
    0x88uy; 0x6Buy; 0x42uy; 0x38uy; 0x61uy; 0x1Fuy; 0xCFuy; 0xDCuy;
    0xDEuy; 0x35uy; 0x5Buy; 0x3Buy; 0x65uy; 0x19uy; 0x03uy; 0x5Buy;
    0xBCuy; 0x34uy; 0xF4uy; 0xDEuy; 0xF9uy; 0x9Cuy; 0x02uy; 0x38uy;
    0x61uy; 0xB4uy; 0x6Fuy; 0xC9uy; 0xD6uy; 0xE6uy; 0xC9uy; 0x07uy;
    0x7Auy; 0xD9uy; 0x1Duy; 0x26uy; 0x91uy; 0xF7uy; 0xF7uy; 0xEEuy;
    0x59uy; 0x8Cuy; 0xB0uy; 0xFAuy; 0xC1uy; 0x86uy; 0xD9uy; 0x1Cuy;
    0xAEuy; 0xFEuy; 0x13uy; 0x09uy; 0x85uy; 0x13uy; 0x92uy; 0x70uy;
    0xB4uy; 0x13uy; 0x0Cuy; 0x93uy; 0xBCuy; 0x43uy; 0x79uy; 0x44uy;
    0xF4uy; 0xFDuy; 0x44uy; 0x52uy; 0xE2uy; 0xD7uy; 0x4Duy; 0xD3uy;
    0x64uy; 0xF2uy; 0xE2uy; 0x1Euy; 0x71uy; 0xF5uy; 0x4Buy; 0xFFuy;
    0x5Cuy; 0xAEuy; 0x82uy; 0xABuy; 0x9Cuy; 0x9Duy; 0xF6uy; 0x9Euy;
    0xE8uy; 0x6Duy; 0x2Buy; 0xC5uy; 0x22uy; 0x36uy; 0x3Auy; 0x0Duy;
    0xABuy; 0xC5uy; 0x21uy; 0x97uy; 0x9Buy; 0x0Duy; 0xEAuy; 0xDAuy;
    0x1Duy; 0xBFuy; 0x9Auy; 0x42uy; 0xD5uy; 0xC4uy; 0x48uy; 0x4Euy;
    0x0Auy; 0xBCuy; 0xD0uy; 0x6Buy; 0xFAuy; 0x53uy; 0xDDuy; 0xEFuy;
    0x3Cuy; 0x1Buy; 0x20uy; 0xEEuy; 0x3Fuy; 0xD5uy; 0x9Duy; 0x7Cuy;
    0x25uy; 0xE4uy; 0x1Duy; 0x2Buy; 0x66uy; 0x9Euy; 0x1Euy; 0xF1uy;
    0x6Euy; 0x6Fuy; 0x52uy; 0xC3uy; 0x16uy; 0x4Duy; 0xF4uy; 0xFBuy;
    0x79uy; 0x30uy; 0xE9uy; 0xE4uy; 0xE5uy; 0x88uy; 0x57uy; 0xB6uy;
    0xACuy; 0x7Duy; 0x5Fuy; 0x42uy; 0xD6uy; 0x9Fuy; 0x6Duy; 0x18uy;
    0x77uy; 0x63uy; 0xCFuy; 0x1Duy; 0x55uy; 0x03uy; 0x40uy; 0x04uy;
    0x87uy; 0xF5uy; 0x5Buy; 0xA5uy; 0x7Euy; 0x31uy; 0xCCuy; 0x7Auy;
    0x71uy; 0x35uy; 0xC8uy; 0x86uy; 0xEFuy; 0xB4uy; 0x31uy; 0x8Auy;
    0xEDuy; 0x6Auy; 0x1Euy; 0x01uy; 0x2Duy; 0x9Euy; 0x68uy; 0x32uy;
    0xA9uy; 0x07uy; 0x60uy; 0x0Auy; 0x91uy; 0x81uy; 0x30uy; 0xC4uy;
    0x6Duy; 0xC7uy; 0x78uy; 0xF9uy; 0x71uy; 0xADuy; 0x00uy; 0x38uy;
    0x09uy; 0x29uy; 0x99uy; 0xA3uy; 0x33uy; 0xCBuy; 0x8Buy; 0x7Auy;
    0x1Auy; 0x1Duy; 0xB9uy; 0x3Duy; 0x71uy; 0x40uy; 0x00uy; 0x3Cuy;
    0x2Auy; 0x4Euy; 0xCEuy; 0xA9uy; 0xF9uy; 0x8Duy; 0x0Auy; 0xCCuy;
    0x0Auy; 0x82uy; 0x91uy; 0xCDuy; 0xCEuy; 0xC9uy; 0x7Duy; 0xCFuy;
    0x8Euy; 0xC9uy; 0xB5uy; 0x5Auy; 0x7Fuy; 0x88uy; 0xA4uy; 0x6Buy;
    0x4Duy; 0xB5uy; 0xA8uy; 0x51uy; 0xF4uy; 0x41uy; 0x82uy; 0xE1uy;
    0xC6uy; 0x8Auy; 0x00uy; 0x7Euy; 0x5Euy; 0x65uy; 0x5Fuy; 0x6Auy;
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy
  ] in
  assert_norm (List.Tot.length l == 512);
  l

let ffdhe_p4096: lseq pub_uint8 512 = of_list list_ffdhe_p4096

// The estimated symmetric-equivalent strength of this group is 150 bits.
let ffdhe_params_4096 : ffdhe_params_t =
  Mk_ffdhe_params 512 ffdhe_p4096 1 ffdhe_g2


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_p6144: List.Tot.llist pub_uint8 768 =
  [@inline_let]
  let l = [
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy;
    0xADuy; 0xF8uy; 0x54uy; 0x58uy; 0xA2uy; 0xBBuy; 0x4Auy; 0x9Auy;
    0xAFuy; 0xDCuy; 0x56uy; 0x20uy; 0x27uy; 0x3Duy; 0x3Cuy; 0xF1uy;
    0xD8uy; 0xB9uy; 0xC5uy; 0x83uy; 0xCEuy; 0x2Duy; 0x36uy; 0x95uy;
    0xA9uy; 0xE1uy; 0x36uy; 0x41uy; 0x14uy; 0x64uy; 0x33uy; 0xFBuy;
    0xCCuy; 0x93uy; 0x9Duy; 0xCEuy; 0x24uy; 0x9Buy; 0x3Euy; 0xF9uy;
    0x7Duy; 0x2Fuy; 0xE3uy; 0x63uy; 0x63uy; 0x0Cuy; 0x75uy; 0xD8uy;
    0xF6uy; 0x81uy; 0xB2uy; 0x02uy; 0xAEuy; 0xC4uy; 0x61uy; 0x7Auy;
    0xD3uy; 0xDFuy; 0x1Euy; 0xD5uy; 0xD5uy; 0xFDuy; 0x65uy; 0x61uy;
    0x24uy; 0x33uy; 0xF5uy; 0x1Fuy; 0x5Fuy; 0x06uy; 0x6Euy; 0xD0uy;
    0x85uy; 0x63uy; 0x65uy; 0x55uy; 0x3Duy; 0xEDuy; 0x1Auy; 0xF3uy;
    0xB5uy; 0x57uy; 0x13uy; 0x5Euy; 0x7Fuy; 0x57uy; 0xC9uy; 0x35uy;
    0x98uy; 0x4Fuy; 0x0Cuy; 0x70uy; 0xE0uy; 0xE6uy; 0x8Buy; 0x77uy;
    0xE2uy; 0xA6uy; 0x89uy; 0xDAuy; 0xF3uy; 0xEFuy; 0xE8uy; 0x72uy;
    0x1Duy; 0xF1uy; 0x58uy; 0xA1uy; 0x36uy; 0xADuy; 0xE7uy; 0x35uy;
    0x30uy; 0xACuy; 0xCAuy; 0x4Fuy; 0x48uy; 0x3Auy; 0x79uy; 0x7Auy;
    0xBCuy; 0x0Auy; 0xB1uy; 0x82uy; 0xB3uy; 0x24uy; 0xFBuy; 0x61uy;
    0xD1uy; 0x08uy; 0xA9uy; 0x4Buy; 0xB2uy; 0xC8uy; 0xE3uy; 0xFBuy;
    0xB9uy; 0x6Auy; 0xDAuy; 0xB7uy; 0x60uy; 0xD7uy; 0xF4uy; 0x68uy;
    0x1Duy; 0x4Fuy; 0x42uy; 0xA3uy; 0xDEuy; 0x39uy; 0x4Duy; 0xF4uy;
    0xAEuy; 0x56uy; 0xEDuy; 0xE7uy; 0x63uy; 0x72uy; 0xBBuy; 0x19uy;
    0x0Buy; 0x07uy; 0xA7uy; 0xC8uy; 0xEEuy; 0x0Auy; 0x6Duy; 0x70uy;
    0x9Euy; 0x02uy; 0xFCuy; 0xE1uy; 0xCDuy; 0xF7uy; 0xE2uy; 0xECuy;
    0xC0uy; 0x34uy; 0x04uy; 0xCDuy; 0x28uy; 0x34uy; 0x2Fuy; 0x61uy;
    0x91uy; 0x72uy; 0xFEuy; 0x9Cuy; 0xE9uy; 0x85uy; 0x83uy; 0xFFuy;
    0x8Euy; 0x4Fuy; 0x12uy; 0x32uy; 0xEEuy; 0xF2uy; 0x81uy; 0x83uy;
    0xC3uy; 0xFEuy; 0x3Buy; 0x1Buy; 0x4Cuy; 0x6Fuy; 0xADuy; 0x73uy;
    0x3Buy; 0xB5uy; 0xFCuy; 0xBCuy; 0x2Euy; 0xC2uy; 0x20uy; 0x05uy;
    0xC5uy; 0x8Euy; 0xF1uy; 0x83uy; 0x7Duy; 0x16uy; 0x83uy; 0xB2uy;
    0xC6uy; 0xF3uy; 0x4Auy; 0x26uy; 0xC1uy; 0xB2uy; 0xEFuy; 0xFAuy;
    0x88uy; 0x6Buy; 0x42uy; 0x38uy; 0x61uy; 0x1Fuy; 0xCFuy; 0xDCuy;
    0xDEuy; 0x35uy; 0x5Buy; 0x3Buy; 0x65uy; 0x19uy; 0x03uy; 0x5Buy;
    0xBCuy; 0x34uy; 0xF4uy; 0xDEuy; 0xF9uy; 0x9Cuy; 0x02uy; 0x38uy;
    0x61uy; 0xB4uy; 0x6Fuy; 0xC9uy; 0xD6uy; 0xE6uy; 0xC9uy; 0x07uy;
    0x7Auy; 0xD9uy; 0x1Duy; 0x26uy; 0x91uy; 0xF7uy; 0xF7uy; 0xEEuy;
    0x59uy; 0x8Cuy; 0xB0uy; 0xFAuy; 0xC1uy; 0x86uy; 0xD9uy; 0x1Cuy;
    0xAEuy; 0xFEuy; 0x13uy; 0x09uy; 0x85uy; 0x13uy; 0x92uy; 0x70uy;
    0xB4uy; 0x13uy; 0x0Cuy; 0x93uy; 0xBCuy; 0x43uy; 0x79uy; 0x44uy;
    0xF4uy; 0xFDuy; 0x44uy; 0x52uy; 0xE2uy; 0xD7uy; 0x4Duy; 0xD3uy;
    0x64uy; 0xF2uy; 0xE2uy; 0x1Euy; 0x71uy; 0xF5uy; 0x4Buy; 0xFFuy;
    0x5Cuy; 0xAEuy; 0x82uy; 0xABuy; 0x9Cuy; 0x9Duy; 0xF6uy; 0x9Euy;
    0xE8uy; 0x6Duy; 0x2Buy; 0xC5uy; 0x22uy; 0x36uy; 0x3Auy; 0x0Duy;
    0xABuy; 0xC5uy; 0x21uy; 0x97uy; 0x9Buy; 0x0Duy; 0xEAuy; 0xDAuy;
    0x1Duy; 0xBFuy; 0x9Auy; 0x42uy; 0xD5uy; 0xC4uy; 0x48uy; 0x4Euy;
    0x0Auy; 0xBCuy; 0xD0uy; 0x6Buy; 0xFAuy; 0x53uy; 0xDDuy; 0xEFuy;
    0x3Cuy; 0x1Buy; 0x20uy; 0xEEuy; 0x3Fuy; 0xD5uy; 0x9Duy; 0x7Cuy;
    0x25uy; 0xE4uy; 0x1Duy; 0x2Buy; 0x66uy; 0x9Euy; 0x1Euy; 0xF1uy;
    0x6Euy; 0x6Fuy; 0x52uy; 0xC3uy; 0x16uy; 0x4Duy; 0xF4uy; 0xFBuy;
    0x79uy; 0x30uy; 0xE9uy; 0xE4uy; 0xE5uy; 0x88uy; 0x57uy; 0xB6uy;
    0xACuy; 0x7Duy; 0x5Fuy; 0x42uy; 0xD6uy; 0x9Fuy; 0x6Duy; 0x18uy;
    0x77uy; 0x63uy; 0xCFuy; 0x1Duy; 0x55uy; 0x03uy; 0x40uy; 0x04uy;
    0x87uy; 0xF5uy; 0x5Buy; 0xA5uy; 0x7Euy; 0x31uy; 0xCCuy; 0x7Auy;
    0x71uy; 0x35uy; 0xC8uy; 0x86uy; 0xEFuy; 0xB4uy; 0x31uy; 0x8Auy;
    0xEDuy; 0x6Auy; 0x1Euy; 0x01uy; 0x2Duy; 0x9Euy; 0x68uy; 0x32uy;
    0xA9uy; 0x07uy; 0x60uy; 0x0Auy; 0x91uy; 0x81uy; 0x30uy; 0xC4uy;
    0x6Duy; 0xC7uy; 0x78uy; 0xF9uy; 0x71uy; 0xADuy; 0x00uy; 0x38uy;
    0x09uy; 0x29uy; 0x99uy; 0xA3uy; 0x33uy; 0xCBuy; 0x8Buy; 0x7Auy;
    0x1Auy; 0x1Duy; 0xB9uy; 0x3Duy; 0x71uy; 0x40uy; 0x00uy; 0x3Cuy;
    0x2Auy; 0x4Euy; 0xCEuy; 0xA9uy; 0xF9uy; 0x8Duy; 0x0Auy; 0xCCuy;
    0x0Auy; 0x82uy; 0x91uy; 0xCDuy; 0xCEuy; 0xC9uy; 0x7Duy; 0xCFuy;
    0x8Euy; 0xC9uy; 0xB5uy; 0x5Auy; 0x7Fuy; 0x88uy; 0xA4uy; 0x6Buy;
    0x4Duy; 0xB5uy; 0xA8uy; 0x51uy; 0xF4uy; 0x41uy; 0x82uy; 0xE1uy;
    0xC6uy; 0x8Auy; 0x00uy; 0x7Euy; 0x5Euy; 0x0Duy; 0xD9uy; 0x02uy;
    0x0Buy; 0xFDuy; 0x64uy; 0xB6uy; 0x45uy; 0x03uy; 0x6Cuy; 0x7Auy;
    0x4Euy; 0x67uy; 0x7Duy; 0x2Cuy; 0x38uy; 0x53uy; 0x2Auy; 0x3Auy;
    0x23uy; 0xBAuy; 0x44uy; 0x42uy; 0xCAuy; 0xF5uy; 0x3Euy; 0xA6uy;
    0x3Buy; 0xB4uy; 0x54uy; 0x32uy; 0x9Buy; 0x76uy; 0x24uy; 0xC8uy;
    0x91uy; 0x7Buy; 0xDDuy; 0x64uy; 0xB1uy; 0xC0uy; 0xFDuy; 0x4Cuy;
    0xB3uy; 0x8Euy; 0x8Cuy; 0x33uy; 0x4Cuy; 0x70uy; 0x1Cuy; 0x3Auy;
    0xCDuy; 0xADuy; 0x06uy; 0x57uy; 0xFCuy; 0xCFuy; 0xECuy; 0x71uy;
    0x9Buy; 0x1Fuy; 0x5Cuy; 0x3Euy; 0x4Euy; 0x46uy; 0x04uy; 0x1Fuy;
    0x38uy; 0x81uy; 0x47uy; 0xFBuy; 0x4Cuy; 0xFDuy; 0xB4uy; 0x77uy;
    0xA5uy; 0x24uy; 0x71uy; 0xF7uy; 0xA9uy; 0xA9uy; 0x69uy; 0x10uy;
    0xB8uy; 0x55uy; 0x32uy; 0x2Euy; 0xDBuy; 0x63uy; 0x40uy; 0xD8uy;
    0xA0uy; 0x0Euy; 0xF0uy; 0x92uy; 0x35uy; 0x05uy; 0x11uy; 0xE3uy;
    0x0Auy; 0xBEuy; 0xC1uy; 0xFFuy; 0xF9uy; 0xE3uy; 0xA2uy; 0x6Euy;
    0x7Fuy; 0xB2uy; 0x9Fuy; 0x8Cuy; 0x18uy; 0x30uy; 0x23uy; 0xC3uy;
    0x58uy; 0x7Euy; 0x38uy; 0xDAuy; 0x00uy; 0x77uy; 0xD9uy; 0xB4uy;
    0x76uy; 0x3Euy; 0x4Euy; 0x4Buy; 0x94uy; 0xB2uy; 0xBBuy; 0xC1uy;
    0x94uy; 0xC6uy; 0x65uy; 0x1Euy; 0x77uy; 0xCAuy; 0xF9uy; 0x92uy;
    0xEEuy; 0xAAuy; 0xC0uy; 0x23uy; 0x2Auy; 0x28uy; 0x1Buy; 0xF6uy;
    0xB3uy; 0xA7uy; 0x39uy; 0xC1uy; 0x22uy; 0x61uy; 0x16uy; 0x82uy;
    0x0Auy; 0xE8uy; 0xDBuy; 0x58uy; 0x47uy; 0xA6uy; 0x7Cuy; 0xBEuy;
    0xF9uy; 0xC9uy; 0x09uy; 0x1Buy; 0x46uy; 0x2Duy; 0x53uy; 0x8Cuy;
    0xD7uy; 0x2Buy; 0x03uy; 0x74uy; 0x6Auy; 0xE7uy; 0x7Fuy; 0x5Euy;
    0x62uy; 0x29uy; 0x2Cuy; 0x31uy; 0x15uy; 0x62uy; 0xA8uy; 0x46uy;
    0x50uy; 0x5Duy; 0xC8uy; 0x2Duy; 0xB8uy; 0x54uy; 0x33uy; 0x8Auy;
    0xE4uy; 0x9Fuy; 0x52uy; 0x35uy; 0xC9uy; 0x5Buy; 0x91uy; 0x17uy;
    0x8Cuy; 0xCFuy; 0x2Duy; 0xD5uy; 0xCAuy; 0xCEuy; 0xF4uy; 0x03uy;
    0xECuy; 0x9Duy; 0x18uy; 0x10uy; 0xC6uy; 0x27uy; 0x2Buy; 0x04uy;
    0x5Buy; 0x3Buy; 0x71uy; 0xF9uy; 0xDCuy; 0x6Buy; 0x80uy; 0xD6uy;
    0x3Fuy; 0xDDuy; 0x4Auy; 0x8Euy; 0x9Auy; 0xDBuy; 0x1Euy; 0x69uy;
    0x62uy; 0xA6uy; 0x95uy; 0x26uy; 0xD4uy; 0x31uy; 0x61uy; 0xC1uy;
    0xA4uy; 0x1Duy; 0x57uy; 0x0Duy; 0x79uy; 0x38uy; 0xDAuy; 0xD4uy;
    0xA4uy; 0x0Euy; 0x32uy; 0x9Cuy; 0xD0uy; 0xE4uy; 0x0Euy; 0x65uy;
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy
  ] in
  assert_norm (List.Tot.length l == 768);
  l

let ffdhe_p6144: lseq pub_uint8 768 = of_list list_ffdhe_p6144

// The estimated symmetric-equivalent strength of this group is 175 bits.
let ffdhe_params_6144 : ffdhe_params_t =
  Mk_ffdhe_params 768 ffdhe_p6144 1 ffdhe_g2


[@"opaque_to_smt"]
inline_for_extraction
let list_ffdhe_p8192: List.Tot.llist pub_uint8 1024 =
  [@inline_let]
  let l = [
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy;
    0xADuy; 0xF8uy; 0x54uy; 0x58uy; 0xA2uy; 0xBBuy; 0x4Auy; 0x9Auy;
    0xAFuy; 0xDCuy; 0x56uy; 0x20uy; 0x27uy; 0x3Duy; 0x3Cuy; 0xF1uy;
    0xD8uy; 0xB9uy; 0xC5uy; 0x83uy; 0xCEuy; 0x2Duy; 0x36uy; 0x95uy;
    0xA9uy; 0xE1uy; 0x36uy; 0x41uy; 0x14uy; 0x64uy; 0x33uy; 0xFBuy;
    0xCCuy; 0x93uy; 0x9Duy; 0xCEuy; 0x24uy; 0x9Buy; 0x3Euy; 0xF9uy;
    0x7Duy; 0x2Fuy; 0xE3uy; 0x63uy; 0x63uy; 0x0Cuy; 0x75uy; 0xD8uy;
    0xF6uy; 0x81uy; 0xB2uy; 0x02uy; 0xAEuy; 0xC4uy; 0x61uy; 0x7Auy;
    0xD3uy; 0xDFuy; 0x1Euy; 0xD5uy; 0xD5uy; 0xFDuy; 0x65uy; 0x61uy;
    0x24uy; 0x33uy; 0xF5uy; 0x1Fuy; 0x5Fuy; 0x06uy; 0x6Euy; 0xD0uy;
    0x85uy; 0x63uy; 0x65uy; 0x55uy; 0x3Duy; 0xEDuy; 0x1Auy; 0xF3uy;
    0xB5uy; 0x57uy; 0x13uy; 0x5Euy; 0x7Fuy; 0x57uy; 0xC9uy; 0x35uy;
    0x98uy; 0x4Fuy; 0x0Cuy; 0x70uy; 0xE0uy; 0xE6uy; 0x8Buy; 0x77uy;
    0xE2uy; 0xA6uy; 0x89uy; 0xDAuy; 0xF3uy; 0xEFuy; 0xE8uy; 0x72uy;
    0x1Duy; 0xF1uy; 0x58uy; 0xA1uy; 0x36uy; 0xADuy; 0xE7uy; 0x35uy;
    0x30uy; 0xACuy; 0xCAuy; 0x4Fuy; 0x48uy; 0x3Auy; 0x79uy; 0x7Auy;
    0xBCuy; 0x0Auy; 0xB1uy; 0x82uy; 0xB3uy; 0x24uy; 0xFBuy; 0x61uy;
    0xD1uy; 0x08uy; 0xA9uy; 0x4Buy; 0xB2uy; 0xC8uy; 0xE3uy; 0xFBuy;
    0xB9uy; 0x6Auy; 0xDAuy; 0xB7uy; 0x60uy; 0xD7uy; 0xF4uy; 0x68uy;
    0x1Duy; 0x4Fuy; 0x42uy; 0xA3uy; 0xDEuy; 0x39uy; 0x4Duy; 0xF4uy;
    0xAEuy; 0x56uy; 0xEDuy; 0xE7uy; 0x63uy; 0x72uy; 0xBBuy; 0x19uy;
    0x0Buy; 0x07uy; 0xA7uy; 0xC8uy; 0xEEuy; 0x0Auy; 0x6Duy; 0x70uy;
    0x9Euy; 0x02uy; 0xFCuy; 0xE1uy; 0xCDuy; 0xF7uy; 0xE2uy; 0xECuy;
    0xC0uy; 0x34uy; 0x04uy; 0xCDuy; 0x28uy; 0x34uy; 0x2Fuy; 0x61uy;
    0x91uy; 0x72uy; 0xFEuy; 0x9Cuy; 0xE9uy; 0x85uy; 0x83uy; 0xFFuy;
    0x8Euy; 0x4Fuy; 0x12uy; 0x32uy; 0xEEuy; 0xF2uy; 0x81uy; 0x83uy;
    0xC3uy; 0xFEuy; 0x3Buy; 0x1Buy; 0x4Cuy; 0x6Fuy; 0xADuy; 0x73uy;
    0x3Buy; 0xB5uy; 0xFCuy; 0xBCuy; 0x2Euy; 0xC2uy; 0x20uy; 0x05uy;
    0xC5uy; 0x8Euy; 0xF1uy; 0x83uy; 0x7Duy; 0x16uy; 0x83uy; 0xB2uy;
    0xC6uy; 0xF3uy; 0x4Auy; 0x26uy; 0xC1uy; 0xB2uy; 0xEFuy; 0xFAuy;
    0x88uy; 0x6Buy; 0x42uy; 0x38uy; 0x61uy; 0x1Fuy; 0xCFuy; 0xDCuy;
    0xDEuy; 0x35uy; 0x5Buy; 0x3Buy; 0x65uy; 0x19uy; 0x03uy; 0x5Buy;
    0xBCuy; 0x34uy; 0xF4uy; 0xDEuy; 0xF9uy; 0x9Cuy; 0x02uy; 0x38uy;
    0x61uy; 0xB4uy; 0x6Fuy; 0xC9uy; 0xD6uy; 0xE6uy; 0xC9uy; 0x07uy;
    0x7Auy; 0xD9uy; 0x1Duy; 0x26uy; 0x91uy; 0xF7uy; 0xF7uy; 0xEEuy;
    0x59uy; 0x8Cuy; 0xB0uy; 0xFAuy; 0xC1uy; 0x86uy; 0xD9uy; 0x1Cuy;
    0xAEuy; 0xFEuy; 0x13uy; 0x09uy; 0x85uy; 0x13uy; 0x92uy; 0x70uy;
    0xB4uy; 0x13uy; 0x0Cuy; 0x93uy; 0xBCuy; 0x43uy; 0x79uy; 0x44uy;
    0xF4uy; 0xFDuy; 0x44uy; 0x52uy; 0xE2uy; 0xD7uy; 0x4Duy; 0xD3uy;
    0x64uy; 0xF2uy; 0xE2uy; 0x1Euy; 0x71uy; 0xF5uy; 0x4Buy; 0xFFuy;
    0x5Cuy; 0xAEuy; 0x82uy; 0xABuy; 0x9Cuy; 0x9Duy; 0xF6uy; 0x9Euy;
    0xE8uy; 0x6Duy; 0x2Buy; 0xC5uy; 0x22uy; 0x36uy; 0x3Auy; 0x0Duy;
    0xABuy; 0xC5uy; 0x21uy; 0x97uy; 0x9Buy; 0x0Duy; 0xEAuy; 0xDAuy;
    0x1Duy; 0xBFuy; 0x9Auy; 0x42uy; 0xD5uy; 0xC4uy; 0x48uy; 0x4Euy;
    0x0Auy; 0xBCuy; 0xD0uy; 0x6Buy; 0xFAuy; 0x53uy; 0xDDuy; 0xEFuy;
    0x3Cuy; 0x1Buy; 0x20uy; 0xEEuy; 0x3Fuy; 0xD5uy; 0x9Duy; 0x7Cuy;
    0x25uy; 0xE4uy; 0x1Duy; 0x2Buy; 0x66uy; 0x9Euy; 0x1Euy; 0xF1uy;
    0x6Euy; 0x6Fuy; 0x52uy; 0xC3uy; 0x16uy; 0x4Duy; 0xF4uy; 0xFBuy;
    0x79uy; 0x30uy; 0xE9uy; 0xE4uy; 0xE5uy; 0x88uy; 0x57uy; 0xB6uy;
    0xACuy; 0x7Duy; 0x5Fuy; 0x42uy; 0xD6uy; 0x9Fuy; 0x6Duy; 0x18uy;
    0x77uy; 0x63uy; 0xCFuy; 0x1Duy; 0x55uy; 0x03uy; 0x40uy; 0x04uy;
    0x87uy; 0xF5uy; 0x5Buy; 0xA5uy; 0x7Euy; 0x31uy; 0xCCuy; 0x7Auy;
    0x71uy; 0x35uy; 0xC8uy; 0x86uy; 0xEFuy; 0xB4uy; 0x31uy; 0x8Auy;
    0xEDuy; 0x6Auy; 0x1Euy; 0x01uy; 0x2Duy; 0x9Euy; 0x68uy; 0x32uy;
    0xA9uy; 0x07uy; 0x60uy; 0x0Auy; 0x91uy; 0x81uy; 0x30uy; 0xC4uy;
    0x6Duy; 0xC7uy; 0x78uy; 0xF9uy; 0x71uy; 0xADuy; 0x00uy; 0x38uy;
    0x09uy; 0x29uy; 0x99uy; 0xA3uy; 0x33uy; 0xCBuy; 0x8Buy; 0x7Auy;
    0x1Auy; 0x1Duy; 0xB9uy; 0x3Duy; 0x71uy; 0x40uy; 0x00uy; 0x3Cuy;
    0x2Auy; 0x4Euy; 0xCEuy; 0xA9uy; 0xF9uy; 0x8Duy; 0x0Auy; 0xCCuy;
    0x0Auy; 0x82uy; 0x91uy; 0xCDuy; 0xCEuy; 0xC9uy; 0x7Duy; 0xCFuy;
    0x8Euy; 0xC9uy; 0xB5uy; 0x5Auy; 0x7Fuy; 0x88uy; 0xA4uy; 0x6Buy;
    0x4Duy; 0xB5uy; 0xA8uy; 0x51uy; 0xF4uy; 0x41uy; 0x82uy; 0xE1uy;
    0xC6uy; 0x8Auy; 0x00uy; 0x7Euy; 0x5Euy; 0x0Duy; 0xD9uy; 0x02uy;
    0x0Buy; 0xFDuy; 0x64uy; 0xB6uy; 0x45uy; 0x03uy; 0x6Cuy; 0x7Auy;
    0x4Euy; 0x67uy; 0x7Duy; 0x2Cuy; 0x38uy; 0x53uy; 0x2Auy; 0x3Auy;
    0x23uy; 0xBAuy; 0x44uy; 0x42uy; 0xCAuy; 0xF5uy; 0x3Euy; 0xA6uy;
    0x3Buy; 0xB4uy; 0x54uy; 0x32uy; 0x9Buy; 0x76uy; 0x24uy; 0xC8uy;
    0x91uy; 0x7Buy; 0xDDuy; 0x64uy; 0xB1uy; 0xC0uy; 0xFDuy; 0x4Cuy;
    0xB3uy; 0x8Euy; 0x8Cuy; 0x33uy; 0x4Cuy; 0x70uy; 0x1Cuy; 0x3Auy;
    0xCDuy; 0xADuy; 0x06uy; 0x57uy; 0xFCuy; 0xCFuy; 0xECuy; 0x71uy;
    0x9Buy; 0x1Fuy; 0x5Cuy; 0x3Euy; 0x4Euy; 0x46uy; 0x04uy; 0x1Fuy;
    0x38uy; 0x81uy; 0x47uy; 0xFBuy; 0x4Cuy; 0xFDuy; 0xB4uy; 0x77uy;
    0xA5uy; 0x24uy; 0x71uy; 0xF7uy; 0xA9uy; 0xA9uy; 0x69uy; 0x10uy;
    0xB8uy; 0x55uy; 0x32uy; 0x2Euy; 0xDBuy; 0x63uy; 0x40uy; 0xD8uy;
    0xA0uy; 0x0Euy; 0xF0uy; 0x92uy; 0x35uy; 0x05uy; 0x11uy; 0xE3uy;
    0x0Auy; 0xBEuy; 0xC1uy; 0xFFuy; 0xF9uy; 0xE3uy; 0xA2uy; 0x6Euy;
    0x7Fuy; 0xB2uy; 0x9Fuy; 0x8Cuy; 0x18uy; 0x30uy; 0x23uy; 0xC3uy;
    0x58uy; 0x7Euy; 0x38uy; 0xDAuy; 0x00uy; 0x77uy; 0xD9uy; 0xB4uy;
    0x76uy; 0x3Euy; 0x4Euy; 0x4Buy; 0x94uy; 0xB2uy; 0xBBuy; 0xC1uy;
    0x94uy; 0xC6uy; 0x65uy; 0x1Euy; 0x77uy; 0xCAuy; 0xF9uy; 0x92uy;
    0xEEuy; 0xAAuy; 0xC0uy; 0x23uy; 0x2Auy; 0x28uy; 0x1Buy; 0xF6uy;
    0xB3uy; 0xA7uy; 0x39uy; 0xC1uy; 0x22uy; 0x61uy; 0x16uy; 0x82uy;
    0x0Auy; 0xE8uy; 0xDBuy; 0x58uy; 0x47uy; 0xA6uy; 0x7Cuy; 0xBEuy;
    0xF9uy; 0xC9uy; 0x09uy; 0x1Buy; 0x46uy; 0x2Duy; 0x53uy; 0x8Cuy;
    0xD7uy; 0x2Buy; 0x03uy; 0x74uy; 0x6Auy; 0xE7uy; 0x7Fuy; 0x5Euy;
    0x62uy; 0x29uy; 0x2Cuy; 0x31uy; 0x15uy; 0x62uy; 0xA8uy; 0x46uy;
    0x50uy; 0x5Duy; 0xC8uy; 0x2Duy; 0xB8uy; 0x54uy; 0x33uy; 0x8Auy;
    0xE4uy; 0x9Fuy; 0x52uy; 0x35uy; 0xC9uy; 0x5Buy; 0x91uy; 0x17uy;
    0x8Cuy; 0xCFuy; 0x2Duy; 0xD5uy; 0xCAuy; 0xCEuy; 0xF4uy; 0x03uy;
    0xECuy; 0x9Duy; 0x18uy; 0x10uy; 0xC6uy; 0x27uy; 0x2Buy; 0x04uy;
    0x5Buy; 0x3Buy; 0x71uy; 0xF9uy; 0xDCuy; 0x6Buy; 0x80uy; 0xD6uy;
    0x3Fuy; 0xDDuy; 0x4Auy; 0x8Euy; 0x9Auy; 0xDBuy; 0x1Euy; 0x69uy;
    0x62uy; 0xA6uy; 0x95uy; 0x26uy; 0xD4uy; 0x31uy; 0x61uy; 0xC1uy;
    0xA4uy; 0x1Duy; 0x57uy; 0x0Duy; 0x79uy; 0x38uy; 0xDAuy; 0xD4uy;
    0xA4uy; 0x0Euy; 0x32uy; 0x9Cuy; 0xCFuy; 0xF4uy; 0x6Auy; 0xAAuy;
    0x36uy; 0xADuy; 0x00uy; 0x4Cuy; 0xF6uy; 0x00uy; 0xC8uy; 0x38uy;
    0x1Euy; 0x42uy; 0x5Auy; 0x31uy; 0xD9uy; 0x51uy; 0xAEuy; 0x64uy;
    0xFDuy; 0xB2uy; 0x3Fuy; 0xCEuy; 0xC9uy; 0x50uy; 0x9Duy; 0x43uy;
    0x68uy; 0x7Fuy; 0xEBuy; 0x69uy; 0xEDuy; 0xD1uy; 0xCCuy; 0x5Euy;
    0x0Buy; 0x8Cuy; 0xC3uy; 0xBDuy; 0xF6uy; 0x4Buy; 0x10uy; 0xEFuy;
    0x86uy; 0xB6uy; 0x31uy; 0x42uy; 0xA3uy; 0xABuy; 0x88uy; 0x29uy;
    0x55uy; 0x5Buy; 0x2Fuy; 0x74uy; 0x7Cuy; 0x93uy; 0x26uy; 0x65uy;
    0xCBuy; 0x2Cuy; 0x0Fuy; 0x1Cuy; 0xC0uy; 0x1Buy; 0xD7uy; 0x02uy;
    0x29uy; 0x38uy; 0x88uy; 0x39uy; 0xD2uy; 0xAFuy; 0x05uy; 0xE4uy;
    0x54uy; 0x50uy; 0x4Auy; 0xC7uy; 0x8Buy; 0x75uy; 0x82uy; 0x82uy;
    0x28uy; 0x46uy; 0xC0uy; 0xBAuy; 0x35uy; 0xC3uy; 0x5Fuy; 0x5Cuy;
    0x59uy; 0x16uy; 0x0Cuy; 0xC0uy; 0x46uy; 0xFDuy; 0x82uy; 0x51uy;
    0x54uy; 0x1Fuy; 0xC6uy; 0x8Cuy; 0x9Cuy; 0x86uy; 0xB0uy; 0x22uy;
    0xBBuy; 0x70uy; 0x99uy; 0x87uy; 0x6Auy; 0x46uy; 0x0Euy; 0x74uy;
    0x51uy; 0xA8uy; 0xA9uy; 0x31uy; 0x09uy; 0x70uy; 0x3Fuy; 0xEEuy;
    0x1Cuy; 0x21uy; 0x7Euy; 0x6Cuy; 0x38uy; 0x26uy; 0xE5uy; 0x2Cuy;
    0x51uy; 0xAAuy; 0x69uy; 0x1Euy; 0x0Euy; 0x42uy; 0x3Cuy; 0xFCuy;
    0x99uy; 0xE9uy; 0xE3uy; 0x16uy; 0x50uy; 0xC1uy; 0x21uy; 0x7Buy;
    0x62uy; 0x48uy; 0x16uy; 0xCDuy; 0xADuy; 0x9Auy; 0x95uy; 0xF9uy;
    0xD5uy; 0xB8uy; 0x01uy; 0x94uy; 0x88uy; 0xD9uy; 0xC0uy; 0xA0uy;
    0xA1uy; 0xFEuy; 0x30uy; 0x75uy; 0xA5uy; 0x77uy; 0xE2uy; 0x31uy;
    0x83uy; 0xF8uy; 0x1Duy; 0x4Auy; 0x3Fuy; 0x2Fuy; 0xA4uy; 0x57uy;
    0x1Euy; 0xFCuy; 0x8Cuy; 0xE0uy; 0xBAuy; 0x8Auy; 0x4Fuy; 0xE8uy;
    0xB6uy; 0x85uy; 0x5Duy; 0xFEuy; 0x72uy; 0xB0uy; 0xA6uy; 0x6Euy;
    0xDEuy; 0xD2uy; 0xFBuy; 0xABuy; 0xFBuy; 0xE5uy; 0x8Auy; 0x30uy;
    0xFAuy; 0xFAuy; 0xBEuy; 0x1Cuy; 0x5Duy; 0x71uy; 0xA8uy; 0x7Euy;
    0x2Fuy; 0x74uy; 0x1Euy; 0xF8uy; 0xC1uy; 0xFEuy; 0x86uy; 0xFEuy;
    0xA6uy; 0xBBuy; 0xFDuy; 0xE5uy; 0x30uy; 0x67uy; 0x7Fuy; 0x0Duy;
    0x97uy; 0xD1uy; 0x1Duy; 0x49uy; 0xF7uy; 0xA8uy; 0x44uy; 0x3Duy;
    0x08uy; 0x22uy; 0xE5uy; 0x06uy; 0xA9uy; 0xF4uy; 0x61uy; 0x4Euy;
    0x01uy; 0x1Euy; 0x2Auy; 0x94uy; 0x83uy; 0x8Fuy; 0xF8uy; 0x8Cuy;
    0xD6uy; 0x8Cuy; 0x8Buy; 0xB7uy; 0xC5uy; 0xC6uy; 0x42uy; 0x4Cuy;
    0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy; 0xFFuy
  ] in
  assert_norm (List.Tot.length l == 1024);
  l

let ffdhe_p8192: lseq pub_uint8 1024 = of_list list_ffdhe_p8192

// The estimated symmetric-equivalent strength of this group is 192 bits.
let ffdhe_params_8192 : ffdhe_params_t =
  Mk_ffdhe_params 1024 ffdhe_p8192 1 ffdhe_g2


type ffdhe_alg =
  | FFDHE2048
  | FFDHE3072
  | FFDHE4096
  | FFDHE6144
  | FFDHE8192


let get_ffdhe_params (a:ffdhe_alg) : ffdhe_params_t =
  allow_inversion ffdhe_alg;
  match a with
  | FFDHE2048 -> ffdhe_params_2048
  | FFDHE3072 -> ffdhe_params_3072
  | FFDHE4096 -> ffdhe_params_4096
  | FFDHE6144 -> ffdhe_params_6144
  | FFDHE8192 -> ffdhe_params_8192


let ffdhe_len (a:ffdhe_alg) : size_pos =
  allow_inversion ffdhe_alg;
  match a with
  | FFDHE2048 -> 256
  | FFDHE3072 -> 384
  | FFDHE4096 -> 512
  | FFDHE6144 -> 768
  | FFDHE8192 -> 1024


val ffdhe_g2_lemma: unit -> Lemma (nat_from_bytes_be (of_list list_ffdhe_g2) = 2)
let ffdhe_g2_lemma () =
  let g = of_list list_ffdhe_g2 in
  assert_norm (Seq.index (Seq.seq_of_list list_ffdhe_g2) 0 = 0x02uy);
  nat_from_intseq_be_lemma0 g


val ffdhe_p_lemma0: a:ffdhe_alg -> Lemma
 (let ffdhe_p = get_ffdhe_params a in
  let len = ffdhe_len a in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in
  Seq.index p (len - 1) == 0xffuy)

let ffdhe_p_lemma0 a =
  let ffdhe_p = get_ffdhe_params a in
  let len = ffdhe_len a in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in

  allow_inversion ffdhe_alg;
  match a with
  | FFDHE2048 ->
    assert (p == of_list list_ffdhe_p2048);
    assert_norm (List.Tot.index list_ffdhe_p2048 255 == 0xffuy);
    assert (Seq.index (Seq.seq_of_list list_ffdhe_p2048) 255 == 0xffuy)
  | FFDHE3072 ->
    assert (p == of_list list_ffdhe_p3072);
    assert_norm (List.Tot.index list_ffdhe_p3072 383 == 0xffuy);
    assert (Seq.index (Seq.seq_of_list list_ffdhe_p3072) 383 == 0xffuy)
  | FFDHE4096 ->
    assert (p == of_list list_ffdhe_p4096);
    assert_norm (List.Tot.index list_ffdhe_p4096 511 == 0xffuy);
    assert (Seq.index (Seq.seq_of_list list_ffdhe_p4096) 511 == 0xffuy)
  | FFDHE6144 ->
    assert (p == of_list list_ffdhe_p6144);
    assert_norm (List.Tot.index list_ffdhe_p6144 767 == 0xffuy);
    assert (Seq.index (Seq.seq_of_list list_ffdhe_p6144) 767 == 0xffuy)
  | FFDHE8192 ->
    assert (p == of_list list_ffdhe_p8192);
    assert_norm (List.Tot.index list_ffdhe_p8192 1023 == 0xffuy);
    assert (Seq.index (Seq.seq_of_list list_ffdhe_p8192) 1023 == 0xffuy)


val ffdhe_p_lemma: a:ffdhe_alg -> Lemma
 (let ffdhe_p = get_ffdhe_params a in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in
  let p_n = nat_from_bytes_be p in
  p_n % 2 = 1 /\ 255 <= p_n) // 2 < p_n <==> g_n < p_n

let ffdhe_p_lemma a =
  let ffdhe_p = get_ffdhe_params a in
  let len = ffdhe_len a in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in
  let p_n = nat_from_bytes_be p in

  nat_from_intseq_be_slice_lemma p (len - 1);
  assert (p_n == nat_from_bytes_be (slice p (len - 1) len) + pow2 8 * nat_from_bytes_be (slice p 0 (len - 1)));
  nat_from_intseq_be_lemma0 (slice p (len - 1) len);
  assert (p_n == v p.[len - 1] + pow2 8 * nat_from_bytes_be (slice p 0 (len - 1)));
  ffdhe_p_lemma0 a


// RFC4419: 1 < sk /\ sk < (p - 1) / 2 = q
unfold let ffdhe_sk_t (a:ffdhe_alg) =
  sk:lseq uint8 (ffdhe_len a){1 < nat_from_bytes_be sk}

// pk_A = g ^^ sk_A % p
val ffdhe_secret_to_public: a:ffdhe_alg -> sk:ffdhe_sk_t a -> lseq uint8 (ffdhe_len a)
let ffdhe_secret_to_public a sk =
  let ffdhe_p = get_ffdhe_params a in
  let len = ffdhe_len a in
  let g = Mk_ffdhe_params?.ffdhe_g ffdhe_p in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in

  let g_n = nat_from_bytes_be g in
  let p_n = nat_from_bytes_be p in
  let sk_n = nat_from_bytes_be sk in

  ffdhe_g2_lemma ();
  ffdhe_p_lemma a;
  let pk_n = Lib.NatMod.pow_mod #p_n g_n sk_n in
  nat_to_bytes_be len pk_n


(** 5.1.  Checking the Peer's Public Key
   Peers MUST validate each other's public key Y (dh_Ys offered by the
   server or dh_Yc offered by the client) by ensuring that 1 < Y < p-1. *)
// ss = pk_B ^^ sk_A % p
val ffdhe_shared_secret:
     a:ffdhe_alg
  -> sk:ffdhe_sk_t a
  -> pk:lseq uint8 (ffdhe_len a) ->
  option (lseq uint8 (ffdhe_len a))

let ffdhe_shared_secret a sk pk =
  let ffdhe_p = get_ffdhe_params a in
  let len = ffdhe_len a in
  let p = Mk_ffdhe_params?.ffdhe_p ffdhe_p in

  let p_n = nat_from_bytes_be p in
  let sk_n = nat_from_bytes_be sk in
  let pk_n = nat_from_bytes_be pk in

  if 1 < pk_n && pk_n < p_n - 1 then begin
    ffdhe_p_lemma a;
    let ss_n = Lib.NatMod.pow_mod #p_n pk_n sk_n in
    let ss = nat_to_bytes_be len ss_n in
    Some ss end
  else None