#!/bin/zsh

# MEZX_startup{ v1.4
typeset +g selfpathS=$0
function {
    typeset +g pathnameS=${MEZXDIR-MEZXDIR_VAR_NOT_DEFINED}/internal/bootstrap.zsh  tmpbaseS=/tmp/${selfpathS:t}.$$
    . ${pathnameS} 1>${tmpbaseS}.out 2>${tmpbaseS}.err
    typeset +g -i resultI=$?  exitI=0
    exec >&0 2>&1
    if [[ ${resultI} -ne 0 ]]; then
        print -f "ERROR: %s (mezx-startup):  { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n" -- \
              ${selfpathS}  ${pathnameS}  ${resultI}  "$(cat ${tmpbaseS}.out)"  "$(cat ${tmpbaseS}.err)"
        exitI=1;  fi
    rm -f ${tmpbaseS}.{out,err}
    if [[ ${exitI} -ne 0 ]]; then exit ${exitI};  fi
}
unset selfpathS
# }MEZX_startup v1.4


# module name & setup

STR_L   modS=internal/tree/binary
STR_L   modUS=${(U)modS//\//_}
LIST_L  modL=( internal/rex  internal/codegen/framework  internal/struct )
INTERNAL_FRAMEWORK_A_defStart
INTERNAL_FRAMEWORK_A_loadDependencies



# global variables & constants
INT_G   ${modUS}_C_compareEqualI=0
INT_G   ${modUS}_C_compareOrderedI=1
INT_G   ${modUS}_C_compareDisorderedI=2


# aliases


# USAGE
#     ..._A_selfmodSetup
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_L   selfS=${modUS}_A_selfmodSetup
STR_G   ${selfS}_SE='
    STR_L   modS="'"${modS}"'"  modUS="'"${modUS}"'"  selfS=$0;
    : "print \"'${modUS}': ENTRY to $0\"";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localModCommonvarsCreate
STR_G   ${selfS}_SE='
; '
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_checkargc
#
# USAGE
#     argcReqI=<argcReqI>  eval <selfS>
#
STR_G   ${selfS}_SE='
        if [[ ${argcI} -ne ${argcReqI} ]]; then
            curerrI=1;  eval INTERNAL_FRAMEWORK_A_argL_to_argL_S;
            errI=1;
            print -v errS -f "argcI is not %d: %d;  argL=( %s )" --  ${argcReqI}  ${argcI}  ${argL_S};  break;  fi;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


# functions


STR_L   selfS=${modUS}_F_init
#
# USAGE
#     ${selfS}
#
# DESCRIPTION
#     Sets up internal struct defs, etc
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    STR_L   nametypeS=local
    LIST_L  varnameL=( calleemodUS  calleeS  selectorS  curerrI  structmapSDL  defheadL  defL  evalS )
    BOOL_L  printB=${B_F}
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  errI=${(P)${:-${selfS}_V_nexterrI}}  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=0  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS  nametypeS  varnameL  printB
 
function ${selfS}() {
    repeat 1; do
	eval INTERNAL_TREE_BINARY_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        structmapSDL=( MAP  ${modUS}_structM )
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        defheadL=( STR treetypeS  STR treerefS   STR comparatorFuncnameS  BOOL countB  INT countI )
        defL=( STR headrefS   STR parentrefS  STR refL_S   STR refR_S   INT countL_I   INT countR_I )
        calleemodUS=INTERNAL_STRUCT calleeS=F_define
        curerrI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ));  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  headSD  defheadL
        curerrI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ));  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  nodeSD  defL
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_arrayContainsPairP
#
# USAGE
#     <selfS>  <varnameS>  <value1_S>  <value2_S>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   varnameS  value1_S  value2_S  typeS  valL_S  valR_S
 
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        varnameS=$1  value1_S=$2  value2_S=$3
        if ! [[ ${varnameS} =~ ${INTERNAL_FRAMEWORK_C_reVarnameA_S} ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  varnameS  INTERNAL_FRAMEWORK_C_reVarnameA_S  ${INTERNAL_FRAMEWORK_C_reVarnameA_S}  ${varnameS};  break;  fi
        if ! [[ -v ${varnameS} ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to extant var: \"%s\"" -- \
                  varnameS  ${varnameS};  break;  fi
        typeS=${(Pt)varnameS}
        case ${typeS} in
            (array*) ;;
            (*)
                errI=4
                print -v errS -f "\"%s\" arg value does not refer to var of \"%s*\" type: \"%s\";  typeS=\"%s\"" -- \
                      varnameS  array  ${varnameS}  ${typeS};  break ;;  esac
        replyB=${B_F}
        for  valL_S valR_S in "${(P@)varnameS}"; do
            if [[ ${valL_S} = ${value1_S} ]]  &&  [[ ${valR_S} = ${value2_S} ]]; then
                replyB=${B_T};  break;  fi;  done
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_create
#
# USAGE
#     <selfS>  <treetypeS>  <comparatorFuncnameS>  <optcountB>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  comparatorFuncnameS  typerefS  headrefS  treerefS  optcountB_S
 
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        treetypeS=$1  comparatorFuncnameS=$2  optcountB_S=$3
        if ! [[ ${treetypeS} =~ ${INTERNAL_FRAMEWORK_C_reVarnameA_S} ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  treetypeS  INTERNAL_FRAMEWORK_C_reVarnameA_S  ${INTERNAL_FRAMEWORK_C_reVarnameA_S}  ${treetypeS};  break;  fi
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if ! functions ${comparatorFuncnameS} >/dev/null; then
            errI=4
            print -v errS -f "\"%s\" arg value does not refer to known function: \"%s\"" -- \
                  comparatorFuncnameS  ${comparatorFuncnameS};  break;  fi
        if ! [[ ${optcountB_S} = ${B_T}  ||  ${optcountB_S} = ${B_F} ]]; then
            errI=5
            print -v errS -f "\"%s\" arg value not in  ( %d %d ): \"%s\"" -- \
                  optcountB  ${B_T}  ${B_F}  ${optcountB_S};  break;  fi
        typerefS=${INTERNAL_STRUCT_V_structdefM[${treetypeS}]}
        calleemodUS=${modUS} calleeS=F_arrayContainsPairP curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${typerefS}  ${modUS}_nodeSD  ${modUS}_nodeST
        if [[ ${(P)${:-${modUS}_V_replyB}} -ne ${B_T} ]]; then
            errI=7
            print -v errS -f "\"%s\" arg value refers to type that does not contain \"%s\" field: \"%s\";  typerefS=\"%s\";  *typerefS=( %s )" -- \
                  treetypeS  ${modUS}_nodeST  ${treetypeS}  ${typerefS}  "${(P)typerefS}";  break;  fi
        calleemodUS=INTERNAL_STRUCT calleeS=F_create
        curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  ${modUS}_headSD  X_${RANDOM}_ST
        headrefS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_setFieldvalueByStructrefFieldname
        curerrI=11;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  comparatorFuncnameS  \${comparatorFuncnameS}
        curerrI=12;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  treetypeS  \${treetypeS}
        curerrI=13;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  countB  \${optcountB_S}
        curerrI=14;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  countI  0
        replyS=${headrefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_insert
#
# USAGE
#     <selfS>  <treetypeS>  <treerefS>  <inValueS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treevalueS  treerefS  inValueS  structtypeS  noderefS  headrefS  parentrefS  childrefS  fieldrefS  valueS  sideS  varnameS  evalS=
    STR_L   compare_errB_S  compare_errI_S  compare_errS_S  compare_replyI_S  comparatorFuncnameS
    INT_L   evalI
    BOOL_L  foundB
 
    repeat 1; do
        okB=${B_F}  replyB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2  inValueS=$3
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if ! [[ -v "${treerefS}" ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to existing var: \"%s\"" -- \
                  treerefS  ${treerefS};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  INTERNAL_STRUCT_structtypeS
        structtypeS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${structtypeS} = ${modUS}_headSD ]]; then
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS
            if [[ ${INTERNAL_STRUCT_V_replyS} = _NULL_ ]]; then
                calleeS=F_create curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treetypeS}  X_${RANDOM}_ST
                childrefS=${INTERNAL_STRUCT_V_replyS}
                calleeS=F_setFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS  \\\${childrefS}
                calleeS=F_setFieldvalueByStructrefFieldname curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  ${modUS}_nodeST.headrefS  \\\${treerefS}
                calleeS=F_setFieldvalueByStructrefFieldname curerrI=9;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  valueS  \\\${inValueS}
                replyS=${childrefS};  okB=${B_T};  fi
            headrefS=${treerefS}
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=10;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS
            treerefS=${INTERNAL_STRUCT_V_replyS}
        fi
        calleeS=F_getFieldrefByStructrefFieldname curerrI=11;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  ${modUS}_nodeST
        noderefS=${(P)INTERNAL_STRUCT_V_replyS}
        if [[ ${#headrefS} -eq 0 ]]; then
            calleeS=F_getValuerefByStructrefFieldname curerrI=12;  eval INTERNAL_FRAMEWORK_A_callSimple  \${noderefS}  headrefS
            headrefS=${(P)INTERNAL_STRUCT_V_replyS};  fi
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=13;  eval INTERNAL_FRAMEWORK_A_callSimple  \${headrefS}  comparatorFuncnameS
        comparatorFuncnameS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=14;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        eval "${comparatorFuncnameS} \${valueS} \${inValueS}"; evalI=$?
        if [[ ${evalI} -ne 0 ]]; then
            errI=15
            print -v errS -f "call to comparatorFuncnameS (i.e. \"%s\") failed: %d" -- \
                  ${comparatorFuncnameS}  ${evalI};  break;  fi
        for varnameS  curerrI in   errB 16  errI 17  errS 18  replyI 19; do
            if [[ ! -v "${comparatorFuncnameS}_V_${varnameS}" ]]; then
                errI=${curerrI}
                print -v errS -f "var \"%s_V_%s\" does not exist;  comparatorFuncnameS=\"%s\"" -- \
                      ${comparatorFuncnameS}  ${varnameS}  ${comparatorFuncnameS};  break 2;  fi
            evalS+="compare_${varnameS}_S=\${${comparatorFuncnameS}_V_${varnameS}};  ";  done
        eval ${evalS};  evalS=
        case ${compare_errB_S} in
            (${B_T}) ;;
            (${B_F}) ;;
            (*)
                errI=20
                print -v errS -f "var named \"%s\", returned by comparatorFuncnameS (i.e. \"%s\"), not in  ( %d %d ): %d" -- \
                      ${comparatorFuncnameS}_V_errB  ${comparatorFuncnameS}  ${B_T}  ${B_F}  ${compare_errB_S};  break ;;  esac
        if [[ ${compare_errB_S} -eq ${B_T} ]]; then
            errI=21
            print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" -- \
                  ${comparatorFuncnameS}  ${compare_errS_S}  ${compare_errI_S};  break;  fi
        case ${compare_replyI_S} in
            (${(P)${:-${modUS}_C_compareEqualI}})
                okB=${B_T};  break ;;
            (${(P)${:-${modUS}_C_compareDisorderedI}})
                sideS=L ;;
            (${(P)${:-${modUS}_C_compareOrderedI}})
                sideS=R ;;
            (*)
                errI=22
                print -v errS -f "var named \"%s\", returned by comparatorFuncnameS (i.e. \"%s\"), not in  ( %s (%d)   %s (%d)   %s (%d) ): %d" -- \
                      ${comparatorFuncnameS}_V_replyI  ${comparatorFuncnameS}  \
                      ${modUS}_C_compareEqualI  ${(P)${:-${modUS}_C_compareEqualI}} \
                      ${modUS}_C_compareOrderedI  ${(P)${:-${modUS}_C_compareOrderedI}} \
                      ${modUS}_C_compareDisorderedI  ${(P)${:-${modUS}_C_compareDisorderedI}} \
                      ${compare_errB_S};  break ;;  esac
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=23;  eval INTERNAL_FRAMEWORK_A_callSimple  \${noderefS}  ref${sideS}_S
        childrefS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${childrefS} != _NULL_ ]]; then
            calleemodUS=${modUS}  calleeS=F_insert curerrI=24;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treetypeS}  \${childrefS}  \${inValueS}
            replyS=${(P)${:-${modUS}_V_replyS}}  replyB=${(P)${:-${modUS}_V_replyB}}
        else
            calleeS=F_create curerrI=25;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treetypeS}  X_${RANDOM}_ST
            childrefS=${INTERNAL_STRUCT_V_replyS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=26;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${noderefS}  ref${sideS}_S  \\\${childrefS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=27;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  ${modUS}_nodeST.parentrefS  \\\${treerefS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=28;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  valueS  \\\${inValueS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=29;  eval INTERNAL_FRAMEWORK_A_callSimple  \${childrefS}  ${modUS}_nodeST.headrefS  \${headrefS}
            replyS=${childrefS}  replyB=${B_T};  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_nodeShow
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treerefS  parentrefS  childrefL_S  childrefR_S  valueS
 
    repeat 1; do
        okB=${B_F}  replyB=${B_T}
        argcReqI=2;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ${modUS}_nodeST.parentrefS
        parentrefS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ${modUS}_nodeST.refL_S
        childrefL_S=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ${modUS}_nodeST.refR_S
        childrefR_S=${INTERNAL_STRUCT_V_replyS}
        calleemodUS=${modUS}
        print -f "%s: ^node=\"%s\"  value=\"%s\"  ^parent=\"%s\"  ^left=\"%s\"  ^right=\"%s\"\n" -- \
              ${selfS}  ${treerefS}  "${valueS}"  "${parentrefS}"  "${childrefL_S}"  "${childrefR_S}"
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


#
# USAGE
#     set  <styleS>  <errI>  <visitFuncmodS>  <visitFuncnameS>  <visitFMNS>  <treetypeS>  <treerefS>;  eval <selfS>
#
STR_L   selfS=${modUS}_F_traverse_A_visit
STR_G   ${selfS}_SE='
    if [[ ${styleS} = $1 ]]; then  ;
        calleemodUS=$3  calleeS=$4  curerrI=$2;  eval INTERNAL_FRAMEWORK_A_callSimple  \$6  \$7;
        if [[ ${(P)+${:-${3}_V_errB}} -eq 1 ]]; then  ;
            if [[ ${(P)${:-${3}_V_errB}} -eq ${B_N} ]]; then  ;
                okB=${B_T};  replyS=$7;  break;  fi;
            if [[ ${(P)${:-${3}_V_errB}} -eq ${B_T} ]]; then  ;
                errI=$(( $2 + 1 ));
                print -v errS -f "call to visit function (\"%s\") failed: { %s; errI=%d }" -- \
                    $5  ${(P)${:-${3}_V_errS}}  ${(P)${:-${3}_V_errI}};  break;  fi;  fi;  fi;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_F_traverse
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>  ( inorder | preorder | postorder )  <visitFuncmodS>  <visitFuncnameS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treerefS  visitFuncmodS  visitFuncnameS  childrefL_S  childrefR_S  styleS  visitFMNS
 
    repeat 1; do
        okB=${B_F}
        argcReqI=5;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2  styleS=$3  visitFuncmodS=$4  visitFuncnameS=$5
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if ! [[ -v "${treerefS}" ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to existing var: \"%s\"" -- \
                  treerefS  ${treerefS};  break;  fi
        case ${styleS} in
            (inorder) ;;
            (preorder) ;;
            (postorder) ;;
            (*)
                errI=4
                print -v errS -f "unknown value for \"%s\" arg: \"%s\"; must be in  [ %s ]" -- \
                      styleS  "${styleS}"  "preorder inorder postorder";  break ;; esac
        if [[ ${visitFuncmodS} = NONE || ${visitFuncmodS} = UNDEF ]]; then
            visitFuncmodS=;  fi
        if [[ ${visitFuncnameS} = NONE || ${visitFuncnameS} = UNDEF ]]; then
            visitFuncnameS=;  fi
        if [[ "${visitFuncmodS}${visitFuncnameS}" = '' ]]; then
            visitFuncmodS=${modUS}  visitFuncnameS=F_nodeShow;  fi
        visitFMNS="${visitFuncmodS}_${visitFuncnameS}"
        if [[ ${visitFuncmodS} = '' ]]; then
            visitFMNS=${visitFuncnameS};  fi
        if [[ ${visitFMNS} != '' ]]  &&  ! functions "${visitFMNS}" >/dev/null; then
            errI=5
            print -v errS -f "\"%s\" and \"%s\" args refer to non-existent function: \"%s\"" -- \
                  visitFuncmodS  visitFuncnameS  ${visitFMNS};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS} INTERNAL_STRUCT_structtypeS
        if [[ ${INTERNAL_STRUCT_V_replyS} = ${modUS}_headSD ]]; then
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS} treerefS
            treerefS=${INTERNAL_STRUCT_V_replyS};
            if [[ ${treerefS} = _NULL_ ]]; then
                okB=${B_T};  break;  fi;  fi
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ${modUS}_nodeST.refL_S
        childrefL_S=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=9;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ${modUS}_nodeST.refR_S
        childrefR_S=${INTERNAL_STRUCT_V_replyS}
	set  preorder  10  ${visitFuncmodS}  ${visitFuncnameS}  ${visitFMNS}  ${treetypeS}  ${treerefS}; \
	    eval ${modUS}_F_traverse_A_visit
        if  [[ ${childrefL_S} != _NULL_ ]]; then
            calleemodUS=${modUS} calleeS=F_traverse curerrI=12
	    eval "${modUS}_V_replyS="
            eval INTERNAL_FRAMEWORK_A_callSimple  \${treetypeS}  \${childrefL_S}  \${styleS}  \${visitFuncmodS}  \${visitFuncnameS}
	    if [[ ${(P)${:-${modUS}_V_replyS}} != '' ]]; then
		replyS=${(P)${:-${modUS}_V_replyS}};  okB=${B_T};  break;  fi;  fi
	set  inorder  13  ${visitFuncmodS}  ${visitFuncnameS}  ${visitFMNS}  ${treetypeS}  ${treerefS}; \
	    eval ${modUS}_F_traverse_A_visit
        if  [[ ${childrefR_S} != _NULL_ ]]; then
            calleemodUS=${modUS} calleeS=F_traverse curerrI=15;  eval "${modUS}_V_replyS="; \
		eval INTERNAL_FRAMEWORK_A_callSimple  \${treetypeS}  \${childrefR_S}  \${styleS}  \${visitFuncmodS}  \${visitFuncnameS}
	    if [[ ${(P)${:-${modUS}_V_replyS}} != '' ]]; then
		replyS=${(P)${:-${modUS}_V_replyS}};  okB=${B_T};  break;  fi;  fi
	set  postorder  16  ${visitFuncmodS}  ${visitFuncnameS}  ${visitFMNS}  ${treetypeS}  ${treerefS}; \
	    eval ${modUS}_F_traverse_A_visit
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_search
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>  <valueS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treerefS  inValueS  childrefS  valueS  noderefS  headrefS  varnameS  sideS
    STR_L   compare_errB_S  compare_errI_S  compare_errS_S  compare_replyI_S  comparatorFuncnameS  structtypeS  headrefS
    INT_L   evalI
 
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2  inValueS=$3
	print -f "INFO: %s: treetypeS=\"%s\"  treerefS=\"%s\"  inValueS=\"%s\"\n" -- \
	      ${selfS}  "${treetypeS}"  "${treerefS}"  "${inValueS}"
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if [[ ${treerefS} = _NULL_ ]]; then
            replyB=${B_F}  okB=${B_T};  break;  fi
        if ! [[ -v "${treerefS}" ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to existing var: \"%s\"" -- \
                  treerefS  ${treerefS};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  INTERNAL_STRUCT_structtypeS
        structtypeS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${structtypeS} = ${modUS}_headSD ]]; then
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS
            if [[ ${#INTERNAL_STRUCT_V_replyS} -eq 0 ]]; then
                replyB=${B_F};  okB=${B_T};  break;  fi
            treerefS=${INTERNAL_STRUCT_V_replyS};  fi
        if [[ ${treerefS} = _NULL_ ]]; then
            replyB=${B_F}  okB=${B_T};  break;  fi
        calleeS=F_getFieldrefByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  ${modUS}_nodeST
        noderefS=${(P)INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${noderefS}  headrefS
        headrefS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple \\\${headrefS}  comparatorFuncnameS
        comparatorFuncnameS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=9;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        eval "${comparatorFuncnameS} \${valueS} \${inValueS}"; evalI=$?
        if [[ ${evalI} -ne 0 ]]; then
            errI=10
            print -v errS -f "call to comparatorFuncnameS (i.e. \"%s\") failed: %d" -- \
                  ${comparatorFuncnameS}  ${evalI};  break;  fi
        for varnameS  curerrI in   errB 11  errI 12  errS 13  replyI 14; do
            if [[ ! -v "${comparatorFuncnameS}_V_${varnameS}" ]]; then
                errI=${curerrI}
                print -v errS -f "var \"%s_V_%s\" does not exist;  comparatorFuncnameS=\"%s\"" -- \
                      ${comparatorFuncnameS}  ${varnameS}  ${comparatorFuncnameS};  break 2;  fi
            evalS+="compare_${varnameS}_S=\${${comparatorFuncnameS}_V_${varnameS}};  ";  done
        eval ${evalS};  evalS=
        case ${compare_errB_S} in
            (${B_T}) ;;
            (${B_F}) ;;
            (*)
                errI=15
                print -v errS -f "var named \"%s\", returned by comparatorFuncnameS (i.e. \"%s\"), not in  ( %d %d ): %d" -- \
                      ${comparatorFuncnameS}_V_errB  ${comparatorFuncnameS}  ${B_T}  ${B_F}  ${compare_errB_S};  break ;;  esac
        if [[ ${compare_errB_S} -eq ${B_T} ]]; then
            errI=16
            print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" -- \
                  ${comparatorFuncnameS}  ${compare_errS_S}  ${compare_errI_S};  break;  fi
        case ${compare_replyI_S} in
            (${(P)${:-${modUS}_C_compareEqualI}})
                replyB=${B_T}  replyS=${treerefS}  okB=${B_T};  break ;;
            (${(P)${:-${modUS}_C_compareDisorderedI}})
                sideS=L ;;
            (${(P)${:-${modUS}_C_compareOrderedI}})
                sideS=R ;;
            (*)
                errI=17
                print -v errS -f "var named \"%s\", returned by comparatorFuncnameS (i.e. \"%s\"), not in  ( %s (%d)   %s (%d)   %s (%d) ): %d" -- \
                      ${comparatorFuncnameS}_V_replyI  ${comparatorFuncnameS}  \
                      ${modUS}_C_compareEqualI  ${(P)${:-${modUS}_C_compareEqualI}} \
                      ${modUS}_C_compareOrderedI  ${(P)${:-${modUS}_C_compareOrderedI}} \
                      ${modUS}_C_compareDisorderedI  ${(P)${:-${modUS}_C_compareDisorderedI}} \
                      ${compare_errB_S};  break ;;  esac
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=18;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${noderefS}  ref${sideS}_S
        childrefS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${childrefS} != _NULL_ ]]; then
            calleemodUS=${modUS} calleeS=F_search curerrI=19;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treetypeS}  \\\${childrefS}  \\\${inValueS}
            replyB=${(P)${:-${modUS}_V_replyB}}  replyS=${(P)${:-${modUS}_V_replyS}}
        else  replyB=${B_F};  fi
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_SVT_visit
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>
#
BOOL_G  ${selfS}_V_errB
INT_G   ${selfS}_V_errI
STR_G   ${selfS}_V_errS
INT_G   ${selfS}_V_replyI
STR_G   ${selfS}_V_comparatorFuncnameS=UNDEF
STR_G   ${selfS}_V_valueS=UNDEF
 
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   valueS  value1_S  comparatorFuncnameS
    eval "${selfS}_V_errB=${B_F}  ${selfS}_V_errI=0  ${selfS}_V_errS=  ${selfS}_V_replyI=0"
 
    repeat 1; do
        okB=${B_F}
        argcReqI=2;  eval ${modUS}_A_checkargc
	treetypeS=$1  treerefS=$2
	comparatorFuncnameS=${(P)${:-${selfS}_V_comparatorFuncnameS}}  	inValueS=${(P)${:-${selfS}_V_valueS}}
	if [[ ${comparatorFuncnameS} = UNDEF ]]; then
	    errI=2
	    print -v errS -f "\"%s\" var not set; please use \"%s\" func before using this func" -- \
		  ${selfS}_V_comparatorFuncnameS  ${selfS}_F_setup;  break;  fi
	if [[ ${inValueS} = UNDEF ]]; then
	    errI=3
	    print -v errS -f "\"%s\" var not set; please use \"%s\" func before using this func" -- \
		  ${selfS}_V_valueS  ${selfS}_F_setup;  break;  fi
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=4
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if ! [[ -v "${treerefS}" ]]; then
            errI=5
            print -v errS -f "\"%s\" arg value does not refer to existing var: \"%s\"" -- \
                  treerefS  ${treerefS};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  INTERNAL_STRUCT_structtypeS
        structtypeS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${structtypeS} = ${modUS}_headSD ]]; then
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS
            if [[ ${#INTERNAL_STRUCT_V_replyS} -eq 0 ]]; then
                replyB=${B_F};  okB=${B_T};  break;  fi
            treerefS=${INTERNAL_STRUCT_V_replyS};  fi
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=11;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        eval "${comparatorFuncnameS}  \${valueS}  \${inValueS}";  evalI=$?
        if [[ ${evalI} -ne 0 ]]; then
            errI=12
            print -v errS -f "call to comparatorFuncnameS (\"%s\") failed: %d" -- \
                  ${comparatorFuncnameS}  ${evalI};  break;  fi
        for varnameS curerrI in   errB 13  errI 14  errS 15  replyI 16; do
            if [[ ! -v "${comparatorFuncnameS}_V_${varnameS}" ]]; then
                errI=${curerrI}
                print -v errS -f "var \"%s_V_%s\" does not exist;  comparatorFuncnameS=\"%s\"" -- \
                      ${comparatorFuncnameS}  ${varnameS}  ${comparatorFuncnameS};  break 2;  fi
            evalS+="compare_${varnameS}_S=\${${comparatorFuncnameS}_V_${varnameS}};  ";  done
        eval ${evalS};  evalS=
        case ${compare_errB_S} in
            (${B_T}) ;;
            (${B_F}) ;;
            (*)
                errI=17
                print -v errS -f "var named \"%s\", returned by comparatorFuncnameS (i.e. \"%s\"), not in  ( %d %d ): %d" -- \
                      ${comparatorFuncnameS}_V_errB  ${comparatorFuncnameS}  ${B_T}  ${B_F}  ${compare_errB_S};  break ;;  esac
        if [[ ${compare_errB_S} -eq ${B_T} ]]; then
            errI=18
            print -v errS -f "call to %s (\"%s\") failed:  { %s;  errI=%d }" -- \
                  comparatorFuncnameS  ${comparatorFuncnameS}  ${compare_errS_S}  ${compare_errI_S};  break;  fi
	if [[ ${compare_replyI_S} -eq ${(P)${:-${modUS}_C_compareEqualI}} ]]; then
	    errB=${B_N}  replyB=${B_T}  replyS=${treerefS}  okB=${B_T};  break;  fi
print -f "%s: replyI=%s\n" --  ${selfS}  ${replyI}
        eval "${selfS}_V_replyI=\${replyI}";  okB=${B_T};  done
#    if [[ ${okB} -ne ${B_T} ]]
#    then  eval "${selfS}_V_errB=\${B_T}  ${selfS}_V_errI=\${errI}  ${selfS}_V_errS=\${errS}"
#    else  eval "${selfS}_V_errB=\${errB}  ${selfS}_V_replyS=\${replyS}  ${selfS}_V_replyB=\${replyB}";  fi
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_SVT_comparator_F_setup
STR_G   ${selfS}_V_parentnameS=${modUS}_F_SVT_visit
#
# USAGE
#    <selfS>  <comparatorFuncnameS>  <valueS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   parentnameS=${(P)${:-${selfS}_V_parentnameS}}
    STR_L   parent_valueS_varnameS=${parentnameS}_V_valueS
    STR_L   parent_comparatorFuncnameS_varnameS=${parentnameS}_V_comparatorFuncnameS
    repeat 1; do
        okB=${B_F}
        eval "${parent_comparatorFuncnameS_varnameS}=UNDEF  ${parent_valueS_varnameS}=UNDEF"
        argcReqI=2;  eval ${modUS}_A_checkargc
	comparatorFuncnameS=$1  valueS=$2
	if ! functions "${comparatorFuncnameS}" >/dev/null; then
	    errI=2
	    print -v errS -f "function named by \"%s\" arg does not exist: \"%s\"" -- \
		  comparatorFuncnameS  ${comparatorFuncnameS};  break;  fi
        eval "${parent_comparatorFuncnameS_varnameS}=\${comparatorFuncnameS}  ${parent_valueS_varnameS}=\${valueS}"
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_search_via_traverse
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>  <valueS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treerefS  inValueS  childrefS  valueS  noderefS  headrefS  varnameS  sideS
    STR_L   compare_errB_S  compare_errI_S  compare_errS_S  compare_replyI_S  comparatorFuncnameS  structtypeS
    INT_L   evalI
 
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2  inValueS=$3
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        if ! [[ -v "INTERNAL_STRUCT_V_structdefM[${treetypeS}]" ]]; then
            errI=2
            print -v errS -f "\"%s\" arg value does not refer to known type: \"%s\"" -- \
                  treetypeS  ${treetypeS};  break;  fi
        if ! [[ -v "${treerefS}" ]]; then
            errI=3
            print -v errS -f "\"%s\" arg value does not refer to existing var: \"%s\"" -- \
                  treerefS  ${treerefS};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  INTERNAL_STRUCT_structtypeS
        structtypeS=${INTERNAL_STRUCT_V_replyS}
	if !  [[ ${structtypeS} = ${modUS}_headSD  ||  ${structtypeS} = ${modUS}_nodeSD  ]]; then
	    errI=4
	    print -v errS -f "struct type not in  ( %s  %s ):  \"%s\"" -- \
		  ${modUS}_headSD  ${modUS}_nodeSD  ${structtypeS};  break;  fi
        if [[ ${structtypeS} = ${modUS}_headSD ]]; then
            calleeS=F_getFieldvalueByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  treerefS
            if [[ ${#INTERNAL_STRUCT_V_replyS} -eq 0 ]]; then
                replyB=${B_F};  okB=${B_T};  break;  fi
            treerefS=${INTERNAL_STRUCT_V_replyS}
            print -f "INFO: %s: treerefS=\"%s\"\n" -- ${selfS} ${treerefS}
	fi
        calleeS=F_getFieldrefByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treerefS}  ${modUS}_nodeST
        noderefS=${(P)INTERNAL_STRUCT_V_replyS}
        calleeS=F_getValuerefByStructrefFieldname curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${noderefS}  headrefS
        headrefS=${(P)INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  comparatorFuncnameS
        comparatorFuncnameS=${INTERNAL_STRUCT_V_replyS}
        ${modUS}_F_SVT_comparator_F_setup  ${comparatorFuncnameS}  "${inValueS}"
        ${modUS}_F_traverse  ${treetypeS}  ${treerefS}  preorder  ${modUS}  F_SVT_visit
	replyB=${(P)${:-${modUS}_V_replyB}}  replyI=${(P)${:-${modUS}_V_replyI}}  replyS=${(P)${:-${modUS}_V_replyS}}
	if [[ ${replyB} -eq ${B_N} ]]; then
	    replyB=${B_T};  fi
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_delete
#
# USAGE
#    <selfS>  <treetypeS>  <treerefS>  <valueS>
#
function ${selfS}() {
    eval INTERNAL_TREE_BINARY_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treetypeS  treerefS  inValueS  childrefS  valueS  noderefS  headrefS  varnameS  childsideS  parentsideS
    STR_L   childrefL_S  childrefR_S  parentrefL_S  parentrefR_S  subrefS  structtypeS  targetrefS  parentrefS
    STR_L   parentparentrefS=_NULL_
    INT_L   evalI
    BOOL_L  headB
 
    repeat 1; do
        okB=${B_F}  headB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        treetypeS=$1  treerefS=$2  inValueS=$3
	calleemodUS=${modUS}  calleeS=F_search curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${treetypeS}  \\\${treerefS}  \\\${inValueS}
	replyB=${(P)${:-${modUS}_V_replyB}}  replyS=${(P)${:-${modUS}_V_replyS}}
	if [[ ${replyB} -eq ${B_F} ]]; then  okB=${B_T};  break;  fi
	targetrefS=${replyS}
	print "INFO: ${selfS}: targetrefS=${targetrefS}"
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.parentrefS
	parentrefS=${INTERNAL_STRUCT_V_replyS}
	if [[ ${parentrefS} = _NULL_ ]]; then   headB=${B_T};  fi
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.refL_S
	childrefL_S=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.refR_S
	childrefR_S=${INTERNAL_STRUCT_V_replyS}
	if   [[ ${childrefL_S}${childrefR_S} = _NULL__NULL_ ]]; then  childsideS=N;  print "INFO: ${selfS}: target has no children"
	elif [[ ${childrefL_S} = _NULL_ ]]; then  childsideS=R;  print "INFO: ${selfS}: target has RHS child (only): ${childrefR_S} "
	elif [[ ${childrefR_S} = _NULL_ ]]; then  childsideS=L;  print "INFO: ${selfS}: target has LHS child (only), ${childrefL_S}"
	else  childsideS=B;  print "INFO: ${selfS}: target has both LHS & RHS children: ${childrefL_S} ${childrefR_S}";  fi
	if [[ ${headB} -eq ${B_T} ]]; then
	    print "INFO: ${selfS}: target is head"
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.headrefS
	    headrefS=${INTERNAL_STRUCT_V_replyS}
	else
	    print "INFO: ${selfS}: target is not head;  parent=${parentrefS}"
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.parentrefS
	    parentparentrefS=${INTERNAL_STRUCT_V_replyS}
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.refL_S
	    parentrefL_S=${INTERNAL_STRUCT_V_replyS}
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.refR_S
	    parentrefR_S=${INTERNAL_STRUCT_V_replyS}
	    if   [[ ${parentrefL_S} = ${targetrefS} ]]; then parentsideS=L
	    elif [[ ${parentrefR_S} = ${targetrefS} ]]; then parentsideS=R
	    else
		errI=9
		print -v errS -f "neither child of target's parent is target: parentrefL_S=\"%s\"  parentrefR_S=\"%s\"" -- \
		      "${targetrefS}"  "${parentrefL_S}"  "${parentrefR_S}";  break;  fi;  fi
	if [[ ${childsideS} = N  &&  ${headB} -eq ${B_T} ]]; then
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=10;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  treerefS  _NULL_
	    print "INFO: ${selfS}: still need to free target"
	    okB=${B_T};  break
	elif [[ ${childsideS} = N ]]; then
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=11;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.ref${parentsideS}_S  _NULL_
	    print "INFO: ${selfS}: still need to free node: ${targetrefS}"
	    okB=${B_T};  break
	elif [[ ${childsideS} != B   &&  ${headB} -eq ${B_T} ]]; then
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=12;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.ref${childsideS}_S
	    childrefS=${INTERNAL_STRUCT_V_replyS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=13;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  treerefS  \\\${childrefS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=14;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  ${modUS}_nodeST.parentrefS  _NULL_
	    print "INFO: ${selfS}: still need to free target"
	    okB=${B_T};  break
	elif [[ ${childsideS} != B ]]; then
	    calleeS=F_getFieldvalueByStructrefFieldname curerrI=15;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${targetrefS}  ${modUS}_nodeST.ref${childsideS}_S
	    childrefS=${INTERNAL_STRUCT_V_replyS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=16; \
		eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.ref${parentsideS}_S  \\\${childrefS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=17; \
		eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefS}  ${modUS}_nodeST.parentrefS  \\\${parentrefS}
	    print "INFO: ${selfS}: still need to free node: ${targetrefS}"
	    okB=${B_T};  break;  fi
	# our target has both LHS and RHS children
	# does our LHS child have a RHS child? if not, we can do an easy flip
	print "INFO: ${selfS}: entering case the last"
	calleeS=F_getFieldvalueByStructrefFieldname curerrI=18;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefL_S}  ${modUS}_nodeST.refR_S
	subrefS=${INTERNAL_STRUCT_V_replyS}
	if [[ ${subrefS} = _NULL_ ]]; then
	    print "INFO: ${selfS}: LHS child has no RHS child"
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=19; \
		eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefL_S}  ${modUS}_nodeST.parentrefS  \\\${parentrefS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=19;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefL_S}  ${modUS}_nodeST.refR_S  \\\${childrefR_S}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=20;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefR_S}  ${modUS}_nodeST.parentrefS  \\\${childrefL_S}
	    if [[ ${headB} -eq ${B_T} ]]; then
		calleeS=F_setFieldvalueByStructrefFieldname curerrI=21;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  treerefS  \\\${childrefL_S}
	    else
		calleeS=F_setFieldvalueByStructrefFieldname curerrI=21; \
		    eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.ref${parentsideS}_S  \\\${childrefL_S};  fi
	    print "INFO: ${selfS}: still need to free target"
	    okB=${B_T};  break;  fi
	# our LHS child has a RHS child
	# does our RHS child have a LHS child? if not, we can do an easy flip
	calleeS=F_getFieldvalueByStructrefFieldname curerrI=22;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefR_S}  ${modUS}_nodeST.refL_S
	subrefS=${INTERNAL_STRUCT_V_replyS}
	if [[ ${subrefS} = _NULL_ ]]; then
	    print "INFO: ${selfS}: RHS child has no LHS child"
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=19; \
		eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefR_S}  ${modUS}_nodeST.parentrefS  \\\${parentrefS}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=23;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefR_S}  ${modUS}_nodeST.refL_S  \\\${childrefL_S}
	    calleeS=F_setFieldvalueByStructrefFieldname curerrI=24;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${childrefL_S}  ${modUS}_nodeST.parentrefS  \\\${childrefR_S}
	    if [[ ${headB} -eq ${B_T} ]]; then
		calleeS=F_setFieldvalueByStructrefFieldname curerrI=21;  eval INTERNAL_FRAMEWORK_A_callSimple  \\\${headrefS}  treerefS  \\\${childrefR_S}
	    else
		calleeS=F_setFieldvalueByStructrefFieldname curerrI=21; \
		    eval INTERNAL_FRAMEWORK_A_callSimple  \\\${parentrefS}  ${modUS}_nodeST.ref${parentsideS}_S  \\\${childrefR_S};  fi
	    print "INFO: ${selfS}: still need to free target"
	    okB=${B_T};  break;  fi
	# our RHS child has a LHS child
	print "INFO: ${selfS}: LHS child has RHS child and RHS child has LHS child"
	# @@@ this case has not yet been written
    	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


BOOL_L  okB=${B_F}
INT_L   curerrI
STR_L   errS
repeat 1; do
    curerrI=1;  INTERNAL_FRAMEWORK_A_retsReset
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    if [[ ${curerrI} -eq 1 ]]
    then  print -v errS -f "%s; errI=%d" --  "${INTERNAL_FRAMEWORK_V_errS}"  ${INTERNAL_FRAMEWORK_V_errI}
    else  print -v errS -f "%s; errI=%d" --  "${(P)${:-${modUS}_V_errS}}"  ${(P)${:-${modUS}_V_errI}};  fi
    print -v errS -f "%s:  { %s };  errI=%d" --  ${modS}  ${errS}  ${curerrI}
    print -f "%s\n" -- ${errS}
    exit ${curerrI};  fi


repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_F_retsReset  ${modS}
    eval INTERNAL_CODEGEN_FRAMEWORK_A_selfCodegen
    eval INTERNAL_CODEGEN_FRAMEWORK_A_stateReset
    INTERNAL_FRAMEWORK_F_modCacheWrite \
        --module internal/tree/binary \
        --depend internal/rex internal/codegen/framework internal/struct \
        --include alias \
            ${modUS}_F_traverse_A_visit \
        --include var \
            ${modUS}'_${CdotS}${CstarS}_SE' \
            ${modUS}'_F_${CparenlS}${CbsoS}a-zA-Z0-9_${CbscS}${CparenrS}${CreoneormoreS}_${CbsoS}CV${CbscS}_${CdotS}${CstarS}'
    if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
        errI=1;  print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" --  \
            INTERNAL_FRAMEWORK_F_modCacheWrite  ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_errI};  break;  fi
    errB=${B_F};  done
if [[ ${errB} -eq ${B_T} ]]; then
    print -f "ERROR: %s:  { %s;  errI=%d }\n" --  ${modUS}  ${errS}  ${errI};  exit 1;  fi
INTERNAL_FRAMEWORK_A_defEnd


if false; then
#CODEGEN_ACTIVE{
STR_L   modS=internal/tree/binary
STR_L   modUS=${(U)modS//\//_}

#CODEGEN_EXEC{
INTERNAL_FRAMEWORK_A_localErrvarsCreate
STR_L   modS=internal/tree/binary
STR_L   modUS=${(U)modS//\//_}
LIST_L  codeL=()

INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL
unset codeL
#}CODEGEN_EXEC


#}CODEGEN_ACTIVE
fi
true
