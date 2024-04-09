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

STR_L   modS=internal/codegen/framework
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( internal/rex );  INTERNAL_FRAMEWORK_A_loadDependencies


# global variables

INTERNAL_FRAMEWORK_A_retsReset
LIST_G  ${modUS}_V_codeL
STR_G   ${modUS}_V_codeS
INT_G   ${modUS}_V_errnoInternalI
INT_G   ${modUS}_V_errnoI
BOOL_G  ${modUS}_V_preparedB=${B_F}


# module-global regex patterns

STR_G   ${modUS}_V_reAnyS='^[ \t]*[#][}]?CODEGEN(_[A-Z]+)*[{]?[ \t]*$'
STR_G   ${modUS}_V_reActivestartS='^[ \t]*[#]CODEGEN_ACTIVE[{][ \t]*$'
STR_G   ${modUS}_V_reActivestopS='^[ \t]*[#][}]CODEGEN_ACTIVE[ \t]*$'
STR_G   ${modUS}_V_reExecstartS='^[ \t]*[#]CODEGEN_EXEC[{][ \t]*$'
STR_G   ${modUS}_V_reExecstopS='^[ \t]*[#][}]CODEGEN_EXEC[ \t]*$'
STR_G   ${modUS}_V_reExeccopystartS='^[ \t]*[#]CODEGEN_EXEC_COPY[{][ \t]*$'
STR_G   ${modUS}_V_reExeccopystopS='^[ \t]*[#][}]CODEGEN_EXEC_COPY[ \t]*$'


# module code

# USAGE
#     ..._A_selfmodSetup
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'"${modS}"'"  modUS="'"${modUS}"'";
'


STR_L   selfS=${modUS}_A_stateReset
alias ${selfS}='
    : '${selfS}' ENTRY;
    eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T};
    repeat 1; do  ;
        '${modUS}_F_stateReset';
        if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
            errB='${modUS}'_V_errB  errI='${modUS}'_V_errI  errS='${modUS}'_V_errS;  break;  fi;
        errB=${B_F};  done;
    : '${selfS}' EXIT;
'
unset selfS


STR_L   selfS=${modUS}_A_codeExec
alias ${selfS}='
    : '${selfS}' ENTRY;
    eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;
    INT_L   '${selfS}_V_resultI'=0;
    while true; do  ;
        STR_L   '${selfS}_V_saveModS'=${modS-UNDEF};
        STR_L   modS='${modS}';  INTERNAL_FRAMEWORK_A_retsReset;
        if [[ X${'${selfS}_V_saveModS'} = XUNDEF ]]; then  unset modS;  else  modS=${'${selfS}_V_saveModS'};  fi;
        unset '${selfS}_V_saveModS';
        if [[ ${'${modUS}_V_preparedB'} -ne ${B_T} ]]; then  '${modUS}_A_codePrepare';  fi;
        eval ${'${modUS}_V_codeS'};  '${selfS}_V_resultI'=$?;
        errB=${B_F};  break;  done;
    if [[ ${errB} -ne ${B_F} ]]; then  ;
        if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
            errI=${'${modUS}_V_errI'}  errS=${'${modUS}_V_errS'};
        elif [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then  ;
            errI=1  errS=${INTERNAL_FRAMEWORK_V_errS};
        elif [[ ${'${selfS}_V_resultI'} -ne 0 ]]; then  ;
            errI=2;  print -v errS -f "eval of user code failed: %d;  evalS=%q" -- \
                ${'${selfS}_V_resultI'}  ${'${modUS}_V_codeS'};  fi;
        print -v errS -f "%s:  { %s;  errI=%d }" -- '${selfS}'  ${errS}  ${errI};
        BOOL_G  '${modUS}'_V_errB=${B_T};
        INT_G   '${modUS}'_V_errI=${errI};
        STR_G   '${modUS}'_V_errS=${errS};
        unset '${selfS}'_V_resultI;
        break;  fi;
    unset '${selfS}'_V_resultI;
    : '${selfS}' EXIT;
'
unset selfS


STR_L   selfS=${modUS}_A_codePrepareExec
alias ${selfS}='
    : '${selfS}' ENTRY;
    STR_L   '${selfS}'_saveModS=${modS-UNDEF};
    STR_L   modS='${modS}';  INTERNAL_FRAMEWORK_A_retsReset;
    if [[ X${'${selfS}'_saveModS} = XUNDEF ]]; then  unset modS;  else  modS=${'${selfS}'_saveModS};  fi;
    unset '${selfS}'_saveModS;
 
    '${modUS}'_F_codePrepare;
    '${modUS}'_A_codeExec;
    : '${selfS}' EXIT;
'
unset selfS


# usage:  varnameS=<listvarnameS>  <self>
STR_L   selfS=${modUS}_A_listCodegen
alias ${selfS}='
    : '${selfS}' ENTRY;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        repeat 1; do  ;
            eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T};
            eval INTERNAL_FRAMEWORK_A_localMatchvarsCreate;
 
            STR_L modS='${modS}';  set  1  internal_framework  A  retsReset;  INTERNAL_FRAMEWORK_A_callIt;  unset modS;
            if [[ ${+varnameS} -eq 0 ]]; then  ;
                errI=1;  print -v errS -f "varnameS arg does not exist";  break;  fi;
            case ${(t)varnameS} in
                (scalar*) ;;
                (*) errI=2;  print -v errS -f "varnameS arg not scalar* type: %s" --  ${(t)varnameS};
                    break ;;  esac;
            if ! [[ ${varnameS} =~ ${INTERNAL_REX_C_reVarnameA_S} ]]; then  ;
                errI=3; print -v errS \
                    -f "varnameS arg does not match regex \"%s\" (\"%s\"): %s" -- \
                        INTERNAL_REX_C_reVarnameA_S ${INTERNAL_REX_C_reVarnameA_S}  ${varnameS};  break;  fi;
            if [[ ${(P)+varnameS} -eq 0 ]]; then
                errI=4;  print -v errS -f "^varnameS arg does not exist: %s" --  ${varnameS};  break;  fi;
            case ${(Pt)varnameS} in
                (array*) ;;
                (*) errI=5;  print -v errS -f "^varnameS not array* type: %s;  varnameS=%s" -- \
                        ${(Pt)varnameS}  ${varnameS};  break ;;  esac;
            set  8  '${modUS}'  F  listCodegen "" ${varnameS} ;  INTERNAL_FRAMEWORK_A_callIt;
            errB=${B_F};  done;
        if [[ ${errB} -eq ${B_T} ]]; then  ;
            if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
                errS=${'${modUS}_V_errS'}  errI=${'${modUS}_V_errI'}; fi
            print -v errS -f "%s:  { %s;  errI=%d }" --  '${selfS}'  ${errS}  ${errI};
            BOOL_G  '${modUS}_V_errB'=${B_T};
            INT_G   '${modUS}_V_errI'=${errI};
            STR_G   '${modUS}_V_errS'=${errS};  fi;
    };
    eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;
    if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
        errB=${B_T}  errI=${'${modUS}_V_errI'}  errS=${'${modUS}_V_errS'};  break;  fi;
    : '${selfS}' EXIT;
'
unset selfS


STR_L   selfS=${modUS}_A_selfCodegen
alias ${selfS}='
    : '${selfS}' ENTRY;
    STR_L '${selfS}_themS'=$0;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        repeat 1; do  ;
            eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T};
            INT_L   resultI;
 
            INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen < ${'${selfS}_themS'};  resultI=$?;  unset '${selfS}_themS';
            if [[ ${resultI} -ne ${B_T} ]]; then  ;
                errI=1;  print -v errS -f "call to \"%s\" failed:  { errS=%s;  errI=%d }" -- \
                    INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen  ${INTERNAL_CODEGEN_FRAMEWORK_V_errS}  ${errI};  break;  fi;
            eval INTERNAL_CODEGEN_FRAMEWORK_A_codePrepareExec;
            errB=${B_F};  done;
        if [[ ${errB} -eq ${B_T} ]]; then  ;
            if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
                errS=${'${modUS}_V_errS'}  errI=${'${modUS}_V_errI'}; fi
            print -v errS -f "%s:  { %s;  errI=%d }" --  '${selfS}'  ${errS}  ${errI};
            BOOL_G  '${modUS}_V_errB'=${B_T};
            INT_G   '${modUS}_V_errI'=${errI};
            STR_G   '${modUS}_V_errS'=${errS};  fi;
    };
    eval INTERNAL_FRAMEWORK_A_localErrvarsCreate;
    if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  ;
        errB=${B_T}  errI=${'${modUS}_V_errI'}  errS=${'${modUS}_V_errS'};  break;  fi;
    : '${selfS}' EXIT;
'
unset selfS


function ${modUS}_F_errnoInit() {
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INT_G   ${modUS}_V_errnoInternalI=1
 
    while true; do
        INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
        INTERNAL_FRAMEWORK_A_retsReset
        INTERNAL_FRAMEWORK_A_localMatchvarsCreate
        INTERNAL_FRAMEWORK_A_localArgvarsCreate
        if [[ ${argcI} -gt 1 ]]; then
            errI=1;  print -v errS -f "argcI not in {0..1}: %d" --  ${argcI};  break;  fi
        if [[ ${argcI} -eq 1 ]]; then
            if ! [[ $1 =~ '^[1-9][0-9]*$' ]]; then
                errI=2;  print -v errS -f "errnoI arg does not match (in-line) regex (\"%s\"): %s" --  '^[1-9][0-9]*$'  $1
                break;  fi
            eval "${modUS}_V_errnoInternalI=$1";  fi
        errB=${B_F};  break;  done
 
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=3;  print -v errS -f "call to \"%s\" failed; errS=%s; errI=%d" -- \
                INTERNAL_FRAMEWORK_A_retsReset  ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_errI}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi
 
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


function ${modUS}_F_errnoIncr() {
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INT_G   ${modUS}_V_errnoInternalI
    INT_L   incrI=1
 
    while true; do
        INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
        INTERNAL_FRAMEWORK_A_retsReset
        INTERNAL_FRAMEWORK_A_localMatchvarsCreate
        INTERNAL_FRAMEWORK_A_localArgvarsCreate
        if [[ ${argcI} -gt 1 ]]; then
            errI=2;  print -v errS -f "argcount > 1: %d;  required: {0..1}" --  ${argcI};  break;  fi
        if [[ ${argcI} -eq 1 ]]; then
            if ! [[ $1 =~ '^[1-9][0-9]*$' ]]; then
                errI=3;  print -v errS -f "errnoI arg does not match (in-line) regex (\"%s\"): %q" -- \
                    '^[1-9][0-9]*$'  $1;  break;  fi
            incrI=$1;  fi
        eval "${modUS}_V_errnoInternalI+=\${incrI}"
        eval "${modUS}_V_errnoI=\${${modUS}_V_errnoInternalI}"
        errB=${B_F};  break;  done
 
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=1;  print -v errS -f "call to \"%s\" failed;  errS=%s;  errI=%d" -- \
                'INTERNAL_FRAMEWORK_A_retsReset'  "${INTERNAL_FRAMEWORK_V_errS}"  ${INTERNAL_FRAMEWORK_V_errI}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi
 
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


function ${modUS}_F_errnoGet() {
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INT_G   ${modUS}_V_errnoInternalI  ${modUS}_V_errnoI
    INT_L   incrI=1
 
    while true; do
        INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
        INTERNAL_FRAMEWORK_A_retsReset
        INTERNAL_FRAMEWORK_A_localMatchvarsCreate
        INTERNAL_FRAMEWORK_A_localArgvarsCreate
        if [[ ${argcI} -gt 1 ]]; then
            errI=2;  print -v errS -f "argcount > 1: %d;  required: {0..1}" --  ${argcI};  break;  fi
        if [[ ${argcI} -eq 1 ]]; then
            if ! [[ $1 =~ '^[1-9][0-9]*$' ]]; then
                errI=3;  print -v errS -f "errnoI arg does not match (in-line) regex (\"%s\"): %q" -- \
                    '^[1-9][0-9]*$'  $1;  break;  fi
            incrI=$1;  fi
        eval "${modUS}_V_errnoI=\${${modUS}_V_errnoInternalI}"
        eval "${modUS}_V_errnoInternalI+=\${incrI}"
        errB=${B_F};  break;  done
 
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=1;  print -v errS -f "call to \"%s\" failed;  errS=%s;  errI=%d" -- \
                INTERNAL_FRAMEWORK_A_retsReset  "${INTERNAL_FRAMEWORK_V_errS}"  ${INTERNAL_FRAMEWORK_V_errI}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi
 
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


function ${modUS}_F_stateReset() {
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_retsReset
 
    eval "LIST_G  ${modUS}_V_codeL=();"
    STR_G   ${modUS}_V_codeS=;
    INT_G   ${modUS}_V_preparedB=${B_F}
 
    return ${B_T}
}


function ${modUS}_F_codePrepare() {
    STR_L   codeS=  sepS=
    STR_L   nlS  eltS
    print -v nlS -f '\n'
 
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_retsReset
 
    for eltS in "${(P@)${:-${modUS}_V_codeL}}"; do
        codeS+="${sepS}${eltS}";  sepS=${nlS};  done
    codeS+=${nlS}
    #print -f "INFO: %s: codeS=%q\n" --  $0  ${codeS}
    STR_G   ${modUS}_V_codeS=${codeS}
    INT_G   ${modUS}_V_preparedB=${B_T}
 
    return ${B_T}
}


function ${modUS}_F_codeStrAdd() {
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_retsReset
    if [[ $# -ne 0 ]]; then
	if [[ ${#1} -gt 0 ]]; then
	    eval "${modUS}_V_codeL+=( \"\$1\" )"
	    #print -f "INFO: %s: added: %q\n" --  $0  $1
	fi;  fi
    INT_G   ${modUS}_V_preparedB=${B_F}
 
    return ${B_T}
}


function ${modUS}_F_codeListAdd() {
    STR_L   listnameS
    STR_L   sS
    LIST_L  match  mbegin  mend
    BOOL_L  errB=${B_T}
    INT_L   errI=0
    STR_L   errS=
 
    while true; do
	INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
        INTERNAL_FRAMEWORK_A_localErrvarsCreate
        INTERNAL_FRAMEWORK_A_retsReset
        INTERNAL_FRAMEWORK_A_localMatchvarsCreate
        INTERNAL_FRAMEWORK_A_localArgvarsCreate
        if [[ ${argcI} -ne 1 ]]; then
            errI=2;  print -v errS -f "argcountI not 1: %d" --  ${argcI};  break;  fi
        listnameS=$1
        if [[ ${(P)+listnameS} -eq 0 ]]; then
            errI=3;  print -v errS -f "^listnameS does not exist;  listnameS=%s" -- \
                ${listnameS};  break;  fi
        if ! [[ ${(Pt)listnameS} =~ '^array[-a-z]*$' ]]; then
            errI=4;  print -v errS -f "^listnameS var not array* type: %s;  listnameS=%s" -- \
                ${(Pt)listnameS}  ${listnameS};  break;  fi
        for sS in "${(@P)listnameS}"; do
            INTERNAL_CODEGEN_FRAMEWORK_F_codeStrAdd "${sS}";  resultI=$?
            if [[ ${resultI} -ne ${B_T} ]]; then
                errI=5;  print -v errS -f "call to \"%s\" failed: errS=%s;  errI=%d;  sS=%q" -- \
                    INTERNAL_CODEGEN_FRAMEWORK_F_codeStrAdd  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}} ${sS};  break 2;  fi;  done
        errB=${B_F};  break;  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=1;  print -v errS -f "call to \"%s\" failed: errS=%s;  errI=%d" -- \
                INTERNAL_FRAMEWORK_A_retsReset  "${INTERNAL_FRAMEWORK_V_errS}"  ${INTERNAL_FRAMEWORK_V_errI}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi
 
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


function ${modUS}_F_stdinCodegen() {
    STR_L   sS=
    LIST_L  inputL=()
 
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    while true; do
        set  1  INTERNAL_FRAMEWORK  A  retsReset;  INTERNAL_FRAMEWORK_A_callIt
        while read -r sS; do  inputL+=( "${sS}" );  done
        set  4  ${modUS}  A  listCodegen  "STR_L varnameS=inputL; ";  INTERNAL_FRAMEWORK_A_callIt
        errB=${B_F};  break;  done
    if [[ ${errB} -ne ${B_F} ]]; then  ;
        if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
            errI=1;  print -v errS -f "%s;  argL=( %s )" -- \
                ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_replyS}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi;
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


function ${modUS}_F_listCodegen() {
    STR_L   listnameS
    STR_L   sS=  calltargetS=  callmodS=  nlS  evalS  eltS  sepS
    BOOL_L  activeB=${B_F}  execB=${B_F}  execcopyB=${B_F}
    INT_L   resultI
    LIST_L  codeL
    print -v nlS -f '\n'
 
    INTERNAL_CODEGEN_FRAMEWORK_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_A_localMatchvarsCreate
    INTERNAL_FRAMEWORK_A_localArgvarsCreate
    evalS=  sepS=
    for eltS in any activestart activestop execstart execstop execcopystart execcopystop; do
        evalS+="${sepS}STR_L   re${(C)eltS}S=\${${modUS}_V_re${(C)eltS}S}"; sepS=";  "; done
    eval ${evalS}
 
    while true; do
        calltargetS=INTERNAL_FRAMEWORK_A_retsReset  callmodS=internal/framework;  eval ${calltargetS}
        if [[ ${argcI} -ne 1 ]]; then
            errI=1;  print -v errS -f "argcountI not 1";  break;  fi
        listnameS=$1
        if ! [[ ${listnameS} =~ ${INTERNAL_REX_C_reVarnameA_S} ]]; then
            errI=2;  print -v errS -f "listnameS arg does not match regex \"%s\" (\"%s\"): %s" -- \
                INTERNAL_REX_C_reVarnameA_S ${INTERNAL_REX_C_reVarnameA_S}  ${listnameS};  break;  fi
        if [[ ${(P)+listnameS} -eq 0 ]]; then
            errI=3;  print -v errS -f "^listnameS does not exist;  listnameS=%s" --  ${listnameS};  break;  fi
        if ! [[ ${(Pt)listnameS} =~ '^array[-a-z]*$' ]]; then
            errI=4;  print -v errS -f "^listnameS is not array* type: %s;  listnameS=%s" -- \
                ${(Pt)listnameS}  ${listnameS};  break;  fi
        eval "${modUS}_F_stateReset"
        if [[ ${(P)${:-${modUS}_V_errB}} -eq ${B_T} ]]; then
            errI=22;  print -v errS -f "call to %s_F_stateReset failed: errS=%s;  errI=%d" -- \
                ${modUS}  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}};  break;  fi
        for sS in "${(@P)listnameS}"; do
            if [[ ${sS} =~ ${reActivestartS} ]]; then
                if [[ ${activeB} -eq ${B_T} ]]; then
                    errI=5;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN active: %q" -- \
                        reActivestartS  ${reActivestartS}  ${sS};  break 2;  fi
                activeB=${B_T}; continue; fi
            if [[ ${sS} =~ ${reActivestopS} ]]; then
                if [[ ${activeB} -eq ${B_F} ]]; then
                    errI=6;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN inactive: %q" -- \
                        reActivestopS  ${reActivestopS}  ${sS};  break 2;  fi
                if [[ ${execB} -eq ${B_T} ]]; then
                    errI=7;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC active: %q" -- \
                        reActivestopS  ${reActivestopS}  ${sS};  break 2;  fi
                if [[ ${execcopyB} -eq ${B_T} ]]; then
                    errI=8;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC_COPY active: %q" -- \
                        reActivestopS  ${reActivestopS}  ${sS};  break 2;  fi
                activeB=${B_F}; continue; fi
            if [[ ${sS} =~ ${reExecstartS} ]]; then
                if [[ ${activeB} -eq ${B_F} ]]; then
                    errI=9;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN inactive: %q" -- \
                        reExecstartS  ${reExecstartS}  ${sS};  break 2;  fi
                if [[ ${execB} -eq ${B_T} ]]; then
                    errI=10;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC active: %q" -- \
                        reExecstartS  ${reExecstartS}  ${sS};  break 2;  fi
                if [[ ${execcopyB} -eq ${B_T} ]]; then
                    errI=11;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC_COPY active: %q" -- \
                        reExecstartS  ${reExecstartS}  ${sS};  break 2;  fi
                execB=${B_T}; codeL=(); continue; fi
            if [[ ${sS} =~ ${reExecstopS} ]]; then
                if [[ ${activeB} -eq ${B_F} ]]; then
                    errI=12;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN inactive: %q" -- \
                        reExecstopS  ${reExecstopS}  ${sS};  break 2;  fi
                if [[ ${execB} -eq ${B_F} ]]; then
                    errI=13;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC active: %q" -- \
                        reExecstopS  ${reExecstopS}  ${sS};  break 2;  fi
                execB=${B_F}  evalS=  sepS=
                for eltS in "${(@)codeL}"; do
                    evalS+="${sepS}${eltS}"; sepS=${nlS}; done
                eval ${evalS}; resultI=$?
                if [[ ${resultI} -ne 0 ]]; then
                    errI=14;  print -v errS -f "eval of CODEGEN_EXEC code failed: resultI=%d;  evalS=%s" -- \
                        ${resultI}  ${evalS};  break 2;  fi
                continue; fi
            if [[ ${sS} =~ ${reExeccopystartS} ]]; then
                if [[ ${activeB} -eq ${B_F} ]]; then
                    errI=15;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN inactive: %q" -- \
                        reExeccopystartS  ${reExeccopystartS}  ${sS};  break 2;  fi
                if [[ ${execB} -eq ${B_T} ]]; then
                    errI=16;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC active: %q" -- \
                        reExeccopystartS  ${reExeccopystartS}  ${sS};  break 2;  fi
                if [[ ${execcopyB} -eq ${B_T} ]]; then
                    errI=17;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC_COPY active: %q" -- \
                        reExeccopystartS  ${reExeccopystartS}  ${sS};  break 2;  fi
                execcopyB=${B_T}; codeL=(); continue; fi
            if [[ ${sS} =~ ${reExeccopystopS} ]]; then
                if [[ ${activeB} -eq ${B_F} ]]; then
                    errI=18;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN inactive: %q" -- \
                        reExeccopystopS  ${reExeccopystopS}  ${sS};  break 2;  fi
                if [[ ${execcopyB} -eq ${B_F} ]]; then
                    errI=19;  print -v errS -f "regex \"%s\" (\"%s\") matched when CODEGEN_EXEC_COPY inactive: %q" -- \
                        reExeccopystopS  ${reExeccopystopS}  ${sS};  break 2;  fi
                execcopyB=${B_F}  evalS=  sepS=
                for eltS in "${(@)codeL}"; do
                    evalS+="${sepS}${eltS}"; sepS=${nlS}; done
                eval ${evalS}; resultI=$?
                if [[ ${resultI} -ne 0 ]]; then
                    errI=20;  print -v errS -f "exec of CODEGEN_EXEC_COPY code failed: resultI=%d; evalS=%q" -- \
                        ${resultI}  ${evalS};  break 2;  fi
                continue; fi
            if [[ ${sS} =~ ${reAnyS} ]]; then
                errI=21;  print -v errS -f "regex \"%s\" (\"%s\") matched: %q;  no other regex matched;  code error indicated" -- \
                    reAnyS  ${reAnyS}  ${sS};  break 2;  fi
            if [[ ${execB} -eq ${B_T} || ${execcopyB} -eq ${B_T} ]]; then
                codeL+=( ${sS} ); fi
            if [[ ${activeB} -eq ${B_T} && ${execB} -eq ${B_F} ]]; then
                INTERNAL_CODEGEN_FRAMEWORK_F_codeStrAdd "${sS}";  fi;  done
        errB=${B_F};  break;  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=23;  print -v errS -f "call to \"%s\" failed; errS=%s; errI=%d" -- \
                ${calltargetS}  "${(P)${:-${callmodS}_V_errS}}"  ${(P)${:-${callmodS}_V_errI}}; fi
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS};  fi
 
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


INTERNAL_FRAMEWORK_A_defEnd
INTERNAL_FRAMEWORK_F_modCacheWrite \
    --module internal/codegen/framework \
    --depend internal/rex
