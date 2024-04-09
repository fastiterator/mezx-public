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


LIST_L  modL=( internal/struct );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test/struct
STR_L   modUS=${(U)modS//\//_}
STR_G   ${modUS}_V_treerefS


STR_L   selfS=${modUS}_A_selfmodSetup
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'"  selfS="$0";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localModCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
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
            errI=1
            print -v errS -f "argcI is not %d: %d" --  ${argcReqI}  ${argcI};  break;  fi
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_F_stdsetup
#
# USAGE
#     <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L  defL=( STR refL_S   STR refR_S   STR valueS )
    LIST_L  def2L=( ${modUS}_nodeSD nodeST )
    LIST_L  def3L=( ${modUS}_node2SD node2ST )
 
    repeat 1; do
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  BT_nodeSD  defL
        calleemodUS=INTERNAL_STRUCT calleeS=F_create curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modUS}_BT_nodeSD  topST
        STR_G   ${modUS}_V_treerefS=${INTERNAL_STRUCT_V_replyS}
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_altsetup
#
# USAGE
#     <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L  defL=( STR refL_S   STR refR_S   STR valueS )
    LIST_L  def2L=( ${modUS}_nodeSD nodeST )
    LIST_L  def3L=( ${modUS}_node2SD node2ST )
    STR_G   ${modUS}_V_xrefS
 
    repeat 1; do
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  nodeSD  defL
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  node2SD  def2L
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  node3SD  def3L
        calleemodUS=INTERNAL_STRUCT calleeS=F_create curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modUS}_nodeSD  topST
        STR_G   ${modUS}_V_treerefS=${INTERNAL_STRUCT_V_replyS}
        calleemodUS=INTERNAL_STRUCT calleeS=F_create curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modUS}_node2SD  other2ST
        calleemodUS=INTERNAL_STRUCT calleeS=F_create curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modUS}_node3SD  other3ST
        STR_G   ${modUS}_V_xrefS=${INTERNAL_STRUCT_V_replyS}
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_opsetup
#
# USAGE
#     <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L  defL=( INT numI )
    STR_G   ${modUS}_V_oprefS
 
    repeat 1; do
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}  numholderSD defL
        STR_G   ${modUS}_V_oprefS=${INTERNAL_STRUCT_V_replyS}
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L  selfS=${modUS}_F_treeInsert
#
# USAGE
#     <selfS>  <treerefS>  <numI>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treerefS  childrefS  fieldrefS  valueS  sideS
    INT_L   numI
 
    repeat 1; do
        argcReqI=2;  eval ${modUS}_A_checkargc
        treerefS=$1  numI=$2
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${numI} -eq ${valueS} ]]; then
            okB=${B_T};  break;  fi
        if [[ ${valueS} = _NULL_ ]]; then
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS  ${numI}
            replyS=${treerefS};  okB=${B_T};  break;  fi
        if [[ ${numI} -lt ${valueS} ]]; then  sideS=L  else  sideS=R;  fi
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ref${sideS}_S
        childrefS=${INTERNAL_STRUCT_V_replyS}
        if [[ ${childrefS} != _NULL_ ]]; then
            ${selfS}  ${childrefS}  ${numI}
            replyS=${(P)${:-${modUS}_V_replyS}}
        else
            calleeS=F_create curerrI=5;   eval INTERNAL_FRAMEWORK_A_callSimple  \${modUS}_nodeSD  X_${RANDOM}_ST
            childrefS=${INTERNAL_STRUCT_V_replyS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=6;   eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  ref${sideS}_S  ${childrefS}
            calleeS=F_setFieldvalueByStructrefFieldname curerrI=7;   eval INTERNAL_FRAMEWORK_A_callSimple  \${childrefS}  valueS  ${numI}
            replyS=${childrefS};  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_mapDump
#
# USAGE
#    <selfS>  <maprefS>  <indentI>  <levelsI>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   maprefS  nameS  valueS  value2S  preS  indentS=  reStructvarnameS=${INTERNAL_STRUCT_C_reStructVarnameA_S}
    LIST_L  nameL
    INT_L   iI  indentI  levelsI
 
    repeat 1; do
        argcReqI=3;  eval ${modUS}_A_checkargc
        maprefS=$1  indentI=$2  levelsI=$3
        if [[ ${maprefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        if [[ ${indentI} -gt 0 ]]; then
            for iI in {1..${indentI}}; do
                indentS+=" ";  done;  fi
        print -v preS -f "%smaprefS \"%s\"  " -- \
              "${indentS}"  ${maprefS}
        if [[ -v "${modUS}_V_dumpedM[${maprefS}]" ]]; then
            print -f "%s (prev dumped)\n" -- ${preS};  okB=${B_T};  break;  fi
        print -f "%s  ...\n" -- ${preS}
        eval "${modUS}_V_dumpedM[\${maprefS}]=1"
        nameL=( ${(Pok)maprefS} )
        for nameS in ${nameL}; do
            valueS=${(P)${:-${maprefS}[${nameS}]}}
            print -v preS -f "%s    field \"%s\": \"%s\"" -- \
                  "${indentS}"  ${nameS}  "${valueS}"
            if [[ ${valueS} =~ '^.*[ML]$' ]]; then
                if [[ -v "${modUS}_V_dumpedM[${valueS}]" ]]; then
                    print -f "%s (prev dumped)\n" -- ${preS};  continue;  fi
                if [[ ${levelsI} -lt 1 ]]; then
                    print -f "%s -> ... (elided)\n" -- ${preS};  continue;  fi
                if [[ ${valueS} =~ '^.*M$' ]]; then
                    print -f "%s -> ...\n" -- ${preS}
                    eval ${selfS}  ${valueS}  $(( ${indentI} + 8 ))  $(( ${levelsI} - 1 ));  fi
                if [[ ${valueS} =~ '^.*L$' ]]; then
                    print -f "%s -> ...\n" -- ${preS}
                    eval ${modUS}_F_listDump  ${valueS}  $(( ${indentI} + 8 ))  $(( ${levelsI} - 1 ));  fi
            elif [[ ${valueS} =~ '^.*\[.*\]$' ]]; then
                value2S=${(P)valueS}
                if [[ ${value2S} = '' ]]; then
                    print -f "%s ->  value (direct): \"%s\"\n" -- \
                          ${preS}  "${valueS}";  continue;  fi
                print -v preS -f "%s ->  value (indirect): \"%s\"" -- \
                      ${preS}  "${value2S}"
                if [[ ${value2S} = '' ]]; then
                    print -f "%s\n" -- ${preS};  continue
                elif [[ ${value2S} =~ '^.*L$' ]]; then
                    if [[ -v "${modUS}_V_dumpedM[${value2S}]" ]]; then
                        print -f "%s (prev dumped)\n" -- ${preS};  continue;  fi
                    print -f "%s\n" -- ${preS}
                    ${modUS}_F_listDump  ${value2S}  $(( ${indentI} + 8 ))  $(( ${levelsI} - 1 ))
                elif [[ ${value2S} =~ '^.*M$' ]]; then
                    if [[ -v "${modUS}_V_dumpedM[${value2S}]" ]]; then
                        print -f "%s (prev dumped)\n" -- ${preS};  continue;  fi
                    print -f "%s\n" -- ${preS}
                    ${modUS}_F_mapDump  ${value2S}  $(( ${indentI} + 8 ))  $(( ${levelsI} - 1 ))
                else
                    print -f "%s\n" --  ${preS};  fi
            else
                print -f "%s ->  value:\"%s\"\n" --  ${preS}  ${valueS};  fi;  done
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_listDump
#
# USAGE
#    <selfS>  <listrefS>  <indentI>  <levelsI>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   listrefS  valueS  indentS=
    INT_L   iI  indentI  levelsI
 
    repeat 1; do
        argcReqI=3;  eval ${modUS}_A_checkargc
        listrefS=$1  indentI=$2  levelsI=$3
        if [[ ${indentI} -gt 0 ]]; then
            for iI in {1..${indentI}}; do
                indentS+=" ";  done;  fi
        if [[ ${listrefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        print -v preS -f "%slistrefS \"%s\"" -- \
              "${indentS}"  ${listrefS}
        if [[ -v "${modUS}_V_dumpedM[${listrefS}]" ]]; then
            print -f "%s (prev dumped)\n" -- ${preS};  okB=${B_T};  break;  fi
        if [[ ${levelsI} -lt 1 ]]; then
            print -f "%s -> ... (elided)\n" -- ${preS};  okB=${B_T};  break;  fi
        print -f "%s  ...\n" -- ${preS}
        eval "${modUS}_V_dumpedM[\${listrefS}]=1"
        for valueS in ${(P)listrefS}; do
            print -f "%s    value: \"%s\"\n" -- \
                  "${indentS}"  "${valueS}";  done
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_assocDump
#
# USAGE
#    <selfS>  <listrefS>  <indentI>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   assocrefS  keyS  valueS  indentS=
    INT_L   iI  indentI
 
    repeat 1; do
        argcReqI=2;  eval ${modUS}_A_checkargc
        assocrefS=$1  indentI=$2
        if [[ ${indentI} -gt 0 ]]; then
            for iI in {1..${indentI}}; do
                indentS+=" ";  done;  fi
        if [[ ${assocrefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        print -v preS -f "%assocrefS \"%s\"" -- \
              "${indentS}"  ${assocrefS}
        if [[ -v "${modUS}_V_dumpedM[${assocrefS}]" ]]; then
            print -f "%s (prev dumped)\n" -- ${preS};  okB=${B_T};  break;  fi
        if [[ ${levelsI} -lt 1 ]]; then
            print -f "%s -> ... (elided)\n" -- ${preS};  okB=${B_T};  break;  fi
        print -f "%s  ...\n" -- ${preS}
        eval "${modUS}_V_dumpedM[\${assocrefS}]=1"
        for keyS valueS in ${(Pkv)assocrefS}; do
            print -f "%s    key: \"%s\"  value: \"%s\"\n" -- \
                  "${indentS}"  "${keyS}"  "${valueS}";  done
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_treeNodeShow
#
# USAGE
#    <selfS>  <treerefS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treerefS  childrefL_S  childrefR_S  valueS
 
    repeat 1; do
        argcReqI=1;  eval ${modUS}_A_checkargc
        treerefS=$1
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  refL_S
        childrefL_S=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  refR_S
        childrefR_S=${INTERNAL_STRUCT_V_replyS}
        calleemodUS=${modUS}
        print -f "%s: ^node=\"%s\" value=\"%s\" ^left=\"%s\"  ^right=\"%s\"\n" -- \
              ${selfS}  ${treerefS}  ${valueS}  ${childrefL_S}  ${childrefR_S}
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_treeTraverse
#
# USAGE
#    <selfS>  <treerefS>  ( inorder | preorder | postorder )
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   treerefS  childrefL_S  childrefR_S  valueS  styleS
 
    repeat 1; do
        argcReqI=2;  eval ${modUS}_A_checkargc
        treerefS=$1  styleS=$2
        if [[ ${treerefS} = _NULL_ ]]; then
            okB=${B_T};  break;  fi
        case ${styleS} in
            (inorder) ;;
            (preorder) ;;
            (postorder) ;;
            (*)
                errI=2
                print -v errS -f "unknown value for \"%s\" arg: \"%s\"; must be in  [ %s ]" -- \
                      styleS  "${styleS}"  "preorder inorder postorder";  break ;; esac
        calleemodUS=INTERNAL_STRUCT
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  valueS
        valueS=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  refL_S
        childrefL_S=${INTERNAL_STRUCT_V_replyS}
        calleeS=F_getFieldvalueByStructrefFieldname curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS}  refR_S
        childrefR_S=${INTERNAL_STRUCT_V_replyS}
        calleemodUS=${modUS}
        if [[ ${styleS} = preorder ]]; then
            calleeS=F_treeNodeShow  curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS};  fi
        if  [[ ${childrefL_S} != _NULL_ ]]; then
            calleeS=F_treeTraverse curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple  \${childrefL_S}  \${styleS};  fi
        if [[ ${styleS} = inorder ]]; then
            calleeS=F_treeNodeShow  curerrI=8;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS};  fi
        if  [[ ${childrefR_S} != _NULL_ ]]; then
            calleeS=F_treeTraverse curerrI=9;  eval INTERNAL_FRAMEWORK_A_callSimple  \${childrefR_S}  \${styleS};  fi
        if [[ ${styleS} = postorder ]]; then
            calleeS=F_treeNodeShow  curerrI=10;  eval INTERNAL_FRAMEWORK_A_callSimple  \${treerefS};  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_inputRead
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    INT_L   numI
 
    repeat 1; do
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_retsReset  curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple
        calleemodUS=${modUS}
        while read numI; do
            okB=${B_F}
            calleeS=F_treeInsert curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple  \${${modUS}_V_treerefS}  \${numI}
            print -f "%s: INFO: inserted at node: %s\n" -- \
                  ${selfS}  ${(P)${:-${modUS}_V_replyS}}
            okB=${B_T};  done
        if [[ ${okB} -ne ${B_T} ]]; then  break;  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_outputWrite
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   styleshortS
    INT_L   curerrI=1
 
    repeat 1; do
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=${modUS}
        calleeS=F_mapDump curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple \${${modUS}_V_treerefS}  0  20
        print ""
	for styleshortS in pre in post; do
            curerrI+=1
            calleemodUS=${modUS} calleeS=F_treeTraverse curerrI=${curerrI}
            print "*** ${calleeS} ${styleshortS}order"
            eval INTERNAL_FRAMEWORK_A_callSimple  \${${modUS}_V_treerefS}  \${styleshortS}order;  done
        okB=${B_T}; done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_op
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   styleshortS
    INT_L   curerrI=1
    INT_L   xI;
 
    repeat 1; do
	# @@@ actually put the op code here
        okB=${B_T}; done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L   selfS=${modUS}_F_op_F_incr
#
# USAGE
#    <selfS>
#
function ${selfS}() {
}


STR_L   selfS=${modUS}_F_main
#
# USAGE
#    <selfS>  (alt|std)
#
function ${selfS}() {
    eval TEST_STRUCT_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_funcStart
    STR_L  selectorS
 
    repeat 1; do
        if [[ ${argcI} -ne 1 ]]; then
            errI=1
            print -v errS -f "argcI is not 1: %d" --  ${argcI};  break;  fi
        selectorS=$1
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  eval INTERNAL_FRAMEWORK_A_callSimple
        case ${selectorS} in
            (std) ;;
            (alt) ;;
            (op) ;;
            (*)
                errI=2
                print -v errS -f "\"%s\" arg not in  ( std  alt  op ): \"%s\"" -- ${selectorS};  break;  esac
        calleemodUS=${modUS}
        calleeS=F_${selectorS}setup curerrI=3;  eval INTERNAL_FRAMEWORK_A_callSimple
        eval "MAP_G ${modUS}_V_dumpedM=()"
        if [[ ${selectorS} = alt ]]; then
            calleeS=F_mapDump curerrI=4;  eval INTERNAL_FRAMEWORK_A_callSimple  \${${modUS}_V_xrefS}  0  0
	elif [[ ${selectorS} = op ]]; then
	    calleeS=F_op curerrI=5;  eval INTERNAL_FRAMEWORK_A_callSimple
        else
            calleeS=F_inputRead curerrI=6;  eval INTERNAL_FRAMEWORK_A_callSimple
            calleeS=F_outputWrite curerrI=7;  eval INTERNAL_FRAMEWORK_A_callSimple;  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


repeat 1; do
    ${modUS}_F_main op;  done
if [[ ${(P)${:-${modUS}_V_errB}} -ne ${B_F} ]]; then
    print -f "%s: ERROR:  { %s; errI=%d }\n" -- \
          $0  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}}
    exit 1;  fi
exit 0
