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


LIST_L  modL=( internal/struct  internal/tree/binary );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test/internal/tree/binary
STR_L   modUS=${(U)modS//\//_}
STR_G   ${modUS}_V_treerefS
eval "MAP_G   ${modUS}_V_dumpedM=( )"


STR_L   selfS=${modUS}_A_selfmodSetup
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'"  selfS="$0";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_callIt
#
# USAGE
#     calleemodUS=<calleemodUS>  calleeS=<calleeS>  <selfS>  <funcarg>...
#
STR_G   ${selfS}_SE='eval ${calleemodUS}_${calleeS}'
alias ${selfS}=${(P)${:-${selfS}_SE}}
alias ${modUS}_CALLIT=${selfS}
alias TITB_CALLIT=${selfS}


STR_L   selfS=${modUS}_A_localCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    BOOL_L  okB;
    STR_L   calleemodUS  calleeS  evalS;
    INT_L   curerrI  argcReqI;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_funcStart
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    setopt  NO_LOCAL_LOOPS;
    '"${INTERNAL_FRAMEWORK_A_localErrvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localMatchvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localReplyvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localArgvarsCreate_SE}"' ;
    '"${(P)${:-${modUS}_A_selfmodSetup_SE}}"' ;
    '"${(P)${:-${modUS}_A_localCommonvarsCreate_SE}}"' ;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_funcEnd
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    if [[ ${okB} -ne ${B_T} ]]; then  ;
        if [[ ${errI} -eq 0 ]]; then  ;
            errI=${curerrI};
            print -v errS -f "call to \"%s_%s\" failed:  { %s; errI=%d }" -- \
                  ${calleemodUS}  ${calleeS}  ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}};  fi;
        print -v errS -f "%s:  { %s; errI=%d }" -- \
              $0  ${errS}  ${errI};
        evalS="${modUS}_V_errB=\${B_T}  ${modUS}_V_errS=\${errS}  ${modUS}_V_errI=\${errI}";
        eval ${evalS};  break;  fi;
    evalS="${modUS}_V_replyI=\${replyI}  ${modUS}_V_replyS=\${replyS}";
    eval ${evalS};
    return ${B_T};
'
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


STR_L   selfS=${modUS}_F_setup
#
# USAGE
#     <selfS>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   structrefS
    LIST_L  defL=( INTERNAL_TREE_BINARY_nodeSD INTERNAL_TREE_BINARY_nodeST  STR valueS )
    
    repeat 1; do
        okB=${B_F}
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  TITB_CALLIT
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=3;  TITB_CALLIT  ${modS}  nodeSD  defL
        calleemodUS=INTERNAL_TREE_BINARY calleeS=F_create curerrI=4;  TITB_CALLIT  ${modUS}_nodeSD  ${modUS}_F_comparator
        structrefS=${INTERNAL_TREE_BINARY_V_replyS}
        STR_G   ${modUS}_V_treerefS=${structrefS}
        okB=${B_T};  done
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_mapDump
#
# USAGE
#    <selfS>  <maprefS>  <indentI>  <levelsI>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   maprefS  nameS  valueS  value2S  preS  indentS=  reStructvarnameS=${INTERNAL_STRUCT_C_reStructVarnameA_S}
    LIST_L  nameL
    INT_L   iI  indentI  levelsI
    
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        maprefS=$1  indentI=$2  levelsI=$3
        if [[ ${maprefS} = '' ]]; then
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
            if [[ ${nameS} =~ "^INTERNAL_STRUCT_structM.*$" ]]; then  continue;  fi
            if [[ ${nameS} =~ "^INTERNAL_STRUCT_structmapST.*$" ]]; then  continue;  fi
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
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_listDump
#
# USAGE
#    <selfS>  <listrefS>  <indentI>  <levelsI>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   listrefS  valueS  indentS=
    INT_L   iI  indentI  levelsI
    
    repeat 1; do
        okB=${B_F}
        argcReqI=3;  eval ${modUS}_A_checkargc
        listrefS=$1  indentI=$2  levelsI=$3
        if [[ ${indentI} -gt 0 ]]; then
            for iI in {1..${indentI}}; do
                indentS+=" ";  done;  fi
        if [[ ${listrefS} = '' ]]; then
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
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_assocDump
#
# USAGE
#    <selfS>  <listrefS>  <indentI>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   assocrefS  keyS  valueS  indentS=
    INT_L   iI  indentI
    
    repeat 1; do
        okB=${B_F}
        argcReqI=2;  eval ${modUS}_A_checkargc
        assocrefS=$1  indentI=$2
        if [[ ${indentI} -gt 0 ]]; then
            for iI in {1..${indentI}}; do
                indentS+=" ";  done;  fi
        if [[ ${assocrefS} = '' ]]; then
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
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_inputRead
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    INT_L   curerrI=1
    STR_L   tmpS
    STR_L   styleshortS
    
    repeat 1; do
        okB=${B_F}
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_retsReset  curerrI=2;  TITB_CALLIT
	print ">>> enter text strings, separated by [return] <<<"
        while read tmpS; do
            if [[ ${tmpS} =~ '^PRINT$' ]]; then
                styleshortS='in'
                calleemodUS=INTERNAL_TREE_BINARY calleeS=F_traverse curerrI=${curerrI}
                print "*** ${calleemodUS}_${calleeS} ${styleshortS}order"
                TITB_CALLIT  ${modUS}_nodeSD  \${${modUS}_V_treerefS}  ${styleshortS}order
                print "fgfg"
                okB=${B_T};  continue;  fi
            okB=${B_F}
            calleemodUS=INTERNAL_TREE_BINARY  calleeS=F_insert  curerrI=3;  TITB_CALLIT  ${modUS}_nodeSD  \${${modUS}_V_treerefS}  \${tmpS}
            print -f "%s: INFO: inserted at node: %s\n" -- \
                  ${selfS}  ${(P)${:-${calleemodUS}_V_replyS}}
            okB=${B_T};  done
        if [[ ${okB} -ne ${B_T} ]]; then  break;  fi
        okB=${B_T};  done
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_outputWrite
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    eval TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   styleshortS
    INT_L   curerrI=1
    
    repeat 1; do
        okB=${B_F}
        argcReqI=0;  eval ${modUS}_A_checkargc
        calleemodUS=${modUS}
#        calleeS=F_mapDump curerrI=5;  TITB_CALLIT  \""${(P)${:-${modUS}_V_treerefS}}"\"  0  20
        print ""
        for styleshortS in 'pre' 'in' 'post'; do
            curerrI+=1
            calleemodUS=INTERNAL_TREE_BINARY calleeS=F_traverse curerrI=${curerrI}
            print "*** ${calleeS} ${styleshortS}order"
            TITB_CALLIT  ${modUS}_nodeSD  \""${(P)${:-${modUS}_V_treerefS}}"\"  ${styleshortS}order;  done
        okB=${B_T}; done
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_comparator
#
# USAGE
#    <selfS>  <value1_S>  <value2_S>
#
BOOL_G  ${selfS}_V_errB
INT_G   ${selfS}_V_errI
STR_G   ${selfS}_V_errS
INT_G   ${selfS}_V_replyI
function ${selfS}() {
    TEST_INTERNAL_TREE_BINARY_A_funcStart
    STR_L   valueS  value1_S  value2_S
    INT_L   iI
    eval "${selfS}_V_errB=${B_F}  ${selfS}_V_errI=0  ${selfS}_V_errS=  ${selfS}_V_replyI=0"
    
    repeat 1; do
        okB=${B_F}
        argcReqI=2;  eval ${modUS}_A_checkargc
        for  iI in {1..2}; do
            eval "valueS=\$${iI}"
            eval "value${iI}_S=\${valueS}";  done
        if [[ ${value1_S} = ${value2_S} ]]; then  replyI=${INTERNAL_TREE_BINARY_C_compareEqualI}
        elif [[ ${value1_S} < ${value2_S} ]]; then  replyI=${INTERNAL_TREE_BINARY_C_compareOrderedI}
        else  replyI=${INTERNAL_TREE_BINARY_C_compareDisorderedI};  fi
print -f "%s: v1=\"%s\"  v2=\"%s\"  replyI=%s\n" --  ${selfS}  ${value1_S}  ${value2_S}  ${replyI}
        eval "${selfS}_V_replyI=\${replyI}";  okB=${B_T};  done
    if [[ ${okB} -ne ${B_T} ]]; then
        eval "${selfS}_V_errB=\${B_T}  ${selfS}_V_errI=\${errI}  ${selfS}_V_errS=\${errS}";  fi
    eval ${modUS}_A_funcEnd
}


STR_L   selfS=${modUS}_F_main
#
# USAGE
#    <selfS>
#
function ${selfS}() {
    TEST_INTERNAL_TREE_BINARY_A_funcStart
    
    repeat 1; do
        okB=${B_F}
        if [[ ${argcI} -ne 0 ]]; then
            errI=1
            print -v errS -f "argcI is not 0: %d" --  ${argcI};  break;  fi
        calleemodUS=INTERNAL_FRAMEWORK calleeS=A_retsReset curerrI=2;  TITB_CALLIT
        calleemodUS=${modUS}
        calleeS=F_setup curerrI=3;  TITB_CALLIT
        eval "MAP_G   INTERNAL_TREE_BINARY_V_dumpedM=()"
        calleeS=F_inputRead curerrI=4;  TITB_CALLIT
        calleeS=F_outputWrite curerrI=5;  TITB_CALLIT
        okB=${B_T};  done
    eval ${modUS}_A_funcEnd
}


repeat 1; do
    ${modUS}_F_main;  done
if [[ ${(P)${:-${modUS}_V_errB}} -ne ${B_F} ]]; then
    print -f "%s: ERROR:  { %s; errI=%d }\n" -- \
          $0  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}}
    calleemodUS=${modUS}
    calleeS=F_mapDump curerrI=5;  TITB_CALLIT  \${(P)${:-${modUS}_V_treerefS}}  0  20
    exit 1;  fi
exit 0
