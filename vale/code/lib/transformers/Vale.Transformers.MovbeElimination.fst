(**

   This module defines a transformer that eliminates movbe
   instructions, and replaces them with movs and bswaps.

*)
module Vale.Transformers.MovbeElimination


/// Open all the relevant modules

open Vale.X64.Bytes_Code_s
open Vale.X64.Instruction_s
open Vale.X64.Instructions_s
open Vale.X64.Machine_Semantics_s
open Vale.X64.Machine_s
open Vale.X64.Print_s

module L = FStar.List.Tot

open Vale.Transformers.InstructionReorder // open so that we don't
                                          // need to redefine things
                                          // equivalence etc.

open Vale.X64.InsLemmas

let coerce_to_normal (#a:Type0) (x:a) : y:(normal a){x == y} = x

let rec replace_movbe_in_code (c:code) : code =
  match c with
  | Ins (Instr i oprs (AnnotateMovbe64 proof_of_movbe)) ->
    let oprs:normal (instr_operands_t [out op64] [op64]) =
      coerce_to_normal #(instr_operands_t [out op64] [op64]) oprs in
    let (dst, (src, ())) = oprs in
    Block [
      Ins (make_instr ins_Mov64 dst src);
      Ins (make_instr ins_Bswap64 dst);
    ]
  | Ins i -> Ins i
  | Block l -> Block (replace_movbe_in_codes l)
  | IfElse c t f -> IfElse c (replace_movbe_in_code t) (replace_movbe_in_code f)
  | While c b -> While c (replace_movbe_in_code b)

and replace_movbe_in_codes (c:codes) : codes =
  match c with
  | [] -> []
  | x :: xs ->
    replace_movbe_in_code x :: replace_movbe_in_codes xs

#push-options "--initial_fuel 3 --max_fuel 3 --initial_ifuel 0 --max_ifuel 0"
let lemma_merge_mov_bswap dst src fuel (s:machine_state) :
  Lemma
    (ensures (
        let i1 = make_instr ins_Mov64 dst src in
        let i2 = make_instr ins_Bswap64 dst in
        let s_opt = machine_eval_code (Block [Ins i1; Ins i2]) fuel s in
        (Some? s_opt) /\
        (machine_eval_ins i2 (machine_eval_ins i1 ({s with ms_trace = []}))) ==
        {Some?.v s_opt with ms_trace = []})) =
  let i1 = make_instr ins_Mov64 dst src in
  let i2 = make_instr ins_Bswap64 dst in
  let s_opt = machine_eval_code (Block [Ins i1; Ins i2]) fuel s in
  assert_norm (Some? s_opt);
  let Some s1 = s_opt in
  let s2 = {s1 with ms_trace = []} in
  let s0 = {s with ms_trace = []} in
  let sopt1 = machine_eval_code (Ins i1) fuel s in
  assert_norm (Some? sopt1);
  let Some s11 = sopt1 in
  let sopt2 = machine_eval_code (Ins i2) fuel s11 in
  assert_norm (Some? sopt2);
  let Some s12 = sopt2 in
  assert (sopt2 == machine_eval_codes [Ins i1; Ins i2] fuel s);
  assert (sopt2 == s_opt);
  let o1 = ins_obs i1 s in
  let o2 = ins_obs i2 s11 in
  assert (s11 == {machine_eval_ins i1 s0 with ms_trace = o1 @ s.ms_trace});
  assert ({s11 with ms_trace = []} == {machine_eval_ins i1 s0 with ms_trace = []});
  assert ({s11 with ms_trace = []} == machine_eval_ins i1 s0);
  assert (machine_eval_ins i2 ({s11 with ms_trace = []}) == machine_eval_ins i2 (machine_eval_ins i1 s0));
  assert ({s12 with ms_trace = []} == machine_eval_ins i2 (machine_eval_ins i1 s0))
#pop-options

module T = Vale.Def.Types_s
module H = Vale.Arch.Heap

#push-options "--z3rlimit 10 --initial_fuel 0 --max_fuel 0 --initial_ifuel 2 --max_ifuel 2"
let lemma_update_to_valid_destination_keeps_it_as_valid_src (o:operand64) (s:machine_state) (v:nat64) :
  Lemma
    (requires (valid_dst_operand64 o s))
    (ensures (
        let s' = update_operand64_preserve_flags'' o v s s in
        valid_src_operand64_and_taint o s' /\
        eval_operand o s' == v)) =
  reveal_opaque (`%valid_addr64) valid_addr64;
  Vale.Def.Opaque_s.reveal_opaque update_heap64_def;
  Vale.Def.Opaque_s.reveal_opaque get_heap_val64_def
#pop-options

#push-options "--z3rlimit 10 --initial_fuel 0 --max_fuel 0 --initial_ifuel 1 --max_ifuel 1"
let lemma_double_update (dst:operand64) (s0 s1 s2 s3:machine_state) (v v_fin:nat64) :
  Lemma
    (requires (
        (valid_dst_operand64 dst s0) /\
        (s1 == update_operand64_preserve_flags'' dst v s0 s0) /\
        (s2 == update_operand64_preserve_flags'' dst v_fin s1 s1) /\
        (s3 == update_operand64_preserve_flags'' dst v_fin s0 s0)))
    (ensures (
        equiv_states s2 s3)) =
  match dst with
  | OConst _ -> ()
  | OReg r -> assert (equiv_states_ext s2 s3) (* OBSERVE *)
  | OMem (m, t) ->
    FStar.Pervasives.reveal_opaque (`%valid_addr64) valid_addr64;
    Vale.Def.Opaque_s.reveal_opaque update_heap64_def;
    let ptr = eval_maddr m s0 in
    if valid_addr64 ptr (H.heap_get s0.ms_heap) then (
      assert (Map.equal s2.ms_memTaint s3.ms_memTaint);
      assert (Map.equal (H.heap_get s2.ms_heap) (H.heap_get s3.ms_heap));
      assume (s2.ms_heap == s3.ms_heap) // TODO: HOW?!
    ) else ()
  | OStack (m, t) ->
    FStar.Pervasives.reveal_opaque (`%valid_addr64) valid_addr64;
    Vale.Def.Opaque_s.reveal_opaque update_heap64_def;
    let ptr = eval_maddr m s0 in
    assert (equiv_states_ext s2 s3) (* OBSERVE *)
#pop-options

#push-options "--initial_fuel 2 --max_fuel 2 --initial_ifuel 0 --max_ifuel 0"
let lemma_movbe_is_mov_bswap (dst src:operand64) (s:machine_state) :
  Lemma
    (requires (s.ms_trace = []))
    (ensures (
        let movbe = make_instr_annotate ins_MovBe64 (AnnotateMovbe64 ()) dst src in
        let mov = make_instr ins_Mov64 dst src in
        let bswap = make_instr ins_Bswap64 dst in
        equiv_states_or_both_not_ok
          (machine_eval_ins movbe s)
          (machine_eval_ins bswap (machine_eval_ins mov s)))) =
  let movbe = make_instr_annotate ins_MovBe64 (AnnotateMovbe64 ()) dst src in
  let mov = make_instr ins_Mov64 dst src in
  let bswap = make_instr ins_Bswap64 dst in
  let s_movbe = machine_eval_ins movbe s in
  let s_mov = machine_eval_ins mov s in
  let s_bswap = machine_eval_ins bswap s_mov in
  if valid_src_operand64_and_taint src s && valid_dst_operand64 dst s then (
    let src_v = eval_operand src s in
    let dst_movbe_v = T.reverse_bytes_nat64 src_v in
    let dst_mov_v = eval_operand dst s_mov in
    let dst_bswap_v = T.reverse_bytes_nat64 dst_mov_v in
    assert (s_movbe == update_operand64_preserve_flags'' dst dst_movbe_v s s);
    assert (s_mov == update_operand64_preserve_flags'' dst src_v s s);
    lemma_update_to_valid_destination_keeps_it_as_valid_src dst s src_v;
    assert (eval_operand dst s_mov == src_v);
    assert (valid_src_operand64_and_taint dst s_mov);
    assert (s_bswap == update_operand64_preserve_flags'' dst dst_bswap_v s_mov s_mov);
    assert (src_v == dst_mov_v);
    assert (dst_movbe_v == dst_bswap_v);
    lemma_double_update dst s s_mov s_bswap s_movbe src_v dst_bswap_v
  ) else (
    assert (s_movbe == {s with ms_ok = false});
    assert (s_mov == {s with ms_ok = false});
    assert (s_bswap.ms_ok == false)
  )
#pop-options

#restart-solver
#push-options "--z3rlimit 10 --initial_fuel 3 --max_fuel 3 --initial_ifuel 0 --max_ifuel 0"
let lemma_replace_movbe_specifically (i:ins{Instr? i}) (fuel:nat) (s:machine_state) :
  Lemma
    (requires (
        let Instr _ _ ann = i in
        AnnotateMovbe64? ann))
    (ensures (
        let c = Ins i in
        let c' = replace_movbe_in_code c in
        let os = machine_eval_code c fuel s in
        let os' = machine_eval_code c' fuel s in
        Some? os /\ Some? os' /\
        equiv_states_or_both_not_ok
          (Some?.v os)
          (Some?.v os'))) =
  let ins = i in
  let c = Ins i in
  let c' = replace_movbe_in_code c in
  let Instr i oprs (AnnotateMovbe64 proof_of_movbe) = i in
  let oprs:normal (instr_operands_t [out op64] [op64]) =
    coerce_to_normal #(instr_operands_t [out op64] [op64]) oprs in
  let (dst, (src, ())) = oprs in
  let ins_mov = make_instr ins_Mov64 dst src in
  let ins_bswap = make_instr ins_Bswap64 dst in
  assert (replace_movbe_in_code c == Block [Ins ins_mov; Ins ins_bswap]);
  let Some s1 = machine_eval_code c fuel s in
  let s2_opt = machine_eval_code (replace_movbe_in_code c) fuel s in
  assert_norm (Some? s2_opt); (* OBSERVE *)
  let Some s2 = s2_opt in
  let s_a = {s with ms_trace = []} in
  lemma_merge_mov_bswap dst src fuel s;
  let s1_a = {s1 with ms_trace = []} in
  let s2_a = {s2 with ms_trace = []} in
  assert (machine_eval_ins ins_bswap (machine_eval_ins ins_mov s_a) == s2_a);
  assert (machine_eval_ins ins s_a == s1_a);
  assert (machine_eval_ins (make_instr_annotate ins_MovBe64 (AnnotateMovbe64 ()) dst src) s_a == s1_a);
  lemma_movbe_is_mov_bswap dst src s_a;
  assert (equiv_states_or_both_not_ok s1_a s2_a)
#pop-options

#push-options "--initial_fuel 2 --max_fuel 2 --initial_ifuel 1 --max_ifuel 1"
let rec lemma_replace_movbe_in_code (c:code) (fuel:nat) (s:machine_state) :
  Lemma
    (requires (
        (Some? (machine_eval_code c fuel s)) /\
        (Some?.v (machine_eval_code c fuel s)).ms_ok))
    (ensures (
        let c' = replace_movbe_in_code c in
        equiv_option_states
          (machine_eval_code c fuel s)
          (machine_eval_code c' fuel s)))
    (decreases %[fuel; c; 1]) =
  match c with
  | Ins (Instr i oprs (AnnotateMovbe64 proof_of_movbe)) ->
    lemma_replace_movbe_specifically (Instr i oprs (AnnotateMovbe64 proof_of_movbe)) fuel s
  | Ins i -> ()
  | Block l -> lemma_replace_movbe_in_codes l fuel s
  | IfElse c t f ->
    let (st, b) = machine_eval_ocmp s c in
    let s' = {st with ms_trace = (BranchPredicate b)::s.ms_trace} in
    if b then lemma_replace_movbe_in_code t fuel s' else lemma_replace_movbe_in_code f fuel s'
  | While _ _ ->
    lemma_replace_movbe_in_while c fuel s

and lemma_replace_movbe_in_codes (cs:codes) (fuel:nat) (s:machine_state) :
  Lemma
    (requires (
        (Some? (machine_eval_codes cs fuel s)) /\
        (Some?.v (machine_eval_codes cs fuel s)).ms_ok))
    (ensures (
        let cs' = replace_movbe_in_codes cs in
        equiv_option_states
          (machine_eval_codes cs fuel s)
          (machine_eval_codes cs' fuel s)))
    (decreases %[fuel; cs]) =
  match cs with
  | [] -> ()
  | x :: xs ->
    if not ((Some?.v (machine_eval_code x fuel s)).ms_ok) then (
      lemma_not_ok_propagate_codes xs fuel (Some?.v (machine_eval_code x fuel s))
    ) else ();
    lemma_replace_movbe_in_code x fuel s;
    let Some s' =  machine_eval_code x fuel s in
    let Some s'' = machine_eval_code (replace_movbe_in_code x) fuel s in
    lemma_eval_codes_equiv_states (replace_movbe_in_codes xs) fuel s' s'';
    lemma_replace_movbe_in_codes xs fuel s'

and lemma_replace_movbe_in_while (c:code{While? c}) (fuel:nat) (s:machine_state) :
  Lemma
    (requires (
        (Some? (machine_eval_code c fuel s)) /\
        (Some?.v (machine_eval_code c fuel s)).ms_ok))
    (ensures (
        let c' = replace_movbe_in_code c in
        equiv_option_states
          (machine_eval_code c fuel s)
          (machine_eval_code c' fuel s)))
    (decreases %[fuel; c; 0]) =
  if fuel = 0 then () else (
    let While cond body = c in
    let (s, b) = machine_eval_ocmp s cond in
    if not b then () else (
      let s = { s with ms_trace = (BranchPredicate true) :: s.ms_trace } in
      lemma_replace_movbe_in_code body (fuel - 1) s;
      let Some s1 = machine_eval_code body (fuel - 1) s in
      let Some s2 = machine_eval_code (replace_movbe_in_code body) (fuel - 1) s in
      assert (equiv_states_or_both_not_ok s1 s2);
      if s1.ms_ok then (
        lemma_replace_movbe_in_while c (fuel - 1) s1;
        lemma_eval_while_equiv_states (replace_movbe_in_code c) (fuel - 1) s1 s2;
        assert (Some? (machine_eval_code (replace_movbe_in_code c) (fuel - 1) s1));
        assert (Some? (machine_eval_code (replace_movbe_in_code c) (fuel - 1) s2));
        assert (Some?.v (machine_eval_code (replace_movbe_in_code c) (fuel - 1) s2)).ms_ok;
        lemma_replace_movbe_in_while (replace_movbe_in_code c) (fuel - 1) s2;
        lemma_eval_code_equiv_states (replace_movbe_in_code c) (fuel - 1) s1 s2
      ) else ()
    )
  )
#pop-options
