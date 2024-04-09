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

STR_L   modS=internal/struct
STR_L   modUS=${(U)modS//\//_}
LIST_L  modL=( internal/rex  internal/codegen/framework )
INTERNAL_FRAMEWORK_A_defStart
INTERNAL_FRAMEWORK_A_loadDependencies



# global variables

STR_G   ${modUS}_C_reStructVarnameF_S='INTERNAL_STRUCT_((V_(BOOL|INT|STR|FLOATF|FLOATE)_value_L)|(VD_(LIST_MAP)_ref_L))\[[0-9]+\]'
STR_G   ${modUS}_C_reStructVarnameA_S="^${(P)${:-${modUS}_C_reStructVarnameF_S}}$"

eval "MAP_G   ${modUS}_V_structdefM=( )  ${modUS}_V_structM=( )"
INT_G   ${modUS}_V_structdefI=0  ${modUS}_V_structI=0

STR_L   typeS  storageS  evalS=
eval "MAP_G   ${modUS}_C_typeStorageM=(
    BOOL    value
    INT     value
    STR     value
    FLOATF  value
    FLOATE  value
    LIST    ref
    MAP     ref
)"
for typeS storageS in ${(Pkv)${:-${modUS}_C_typeStorageM}}; do
    evalS+="LIST_G  ${modUS}_V_${typeS}_${storageS}_L=( );  "
    evalS+="MAP_G   ${modUS}_V_${typeS}_free_L=( );  "
    eval ${evalS};  done
eval ${evalS}
unset  typeS  storageS  evalS


eval "MAP_G   ${modUS}_C_typeValueM=(
    BOOL    \"${B_T}\"
    INT     \"0\"
    STR     \"NULL\"
    FLOATF  \"0.0\"
    FLOATE  \"0.0\"
    LIST    \"ref\"
    MAP     \"ref\"
)"


# aliases


# USAGE
#     ..._A_selfmodSetup
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_L   selfS=${modUS}_A_selfmodSetup
STR_G ${selfS}_SE='
    STR_L   modS="'"${modS}"'"  modUS="'"${modUS}"'"  selfS=$0;
    : "print \"'${modUS}': ENTRY to $0\"";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localCommonvarsCreate
STR_G   ${selfS}_SE='
    BOOL_L  okB=${B_F};
    STR_L   calleemodUS  calleeS  evalS;
    INT_L   curerrI;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


# functions

STR_L   selfS=${modUS}_F_define
# USAGE
#     ${selfS}  [internalB=${B_(T|F)}]  <modS>  <structdefnameS>  <structdefL_S>
#
# DESCRIPTION
#     Creates a struct definition type that can be used by ..._F_create
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=inModS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reModnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structdefnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructdefnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structdefL_S
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reListnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcMinI=3  argcMaxI=4  indentI=8
    STR_G   ${selfS}_C_checkargc_3or4_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=3  indentI=8
    STR_G   ${selfS}_C_checkargc_3_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( internalB  inModS  inModUS  structdefnameS  structdefL_S  structtypeS  typeS  nameS  typetypeS  initS \
                                  thisM  thisL  thisvarnameS  evalS  formatS  internalDefL )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        internalB=${B_F}
        eval ${(P)${:-${selfS}_C_checkargc_3or4_SE}}
        if [[ ${argcI} -eq 4 ]]  &&  [[ $1 =~ '^internalB=[01]$' ]] then
           internalB=${1[11]};  shift argL;  argcI+=-1;  fi
        eval ${(P)${:-${selfS}_C_checkargc_3_SE}}
        inModS=${argL[1]}  structdefnameS=${argL[2]}  structdefL_S=${argL[3]}
        eval ${(P)${:-${selfS}_C_varcheck_inModS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_structdefnameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_structdefL_S_SE}}
        inModUS=${(U)inModS//\//_}
        case ${(Pt)structdefL_S} in
            (array*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not \"%s*\" type: \"%s\"" -- \
                      structdefL_S  ${structdefL_S}  array  ${(Pt)structdefL_S}
                break ;; esac
        if [[ ${(P)#structdefL_S} -eq 0  ||  $(( ${(P)#structdefL_S} % 2 )) -eq 1 ]]; then
            formatS="\"%s\" list var (from \"%s\" arg) has invalid item count: %d; required: positive, non-zero, even number;  %s=( %s )"
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
            print -v errS -f ${formatS} -- \
                  ${structdefL_S}  structdefL_S  ${(P)#structdefL_S}  "^structdefL_S"  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- ${structdefL_S})"
            break;  fi
        print -v structtypeS -f "%s_%s" -- \
              ${inModUS}  ${structdefnameS}
        if [[ -v "${modUS}_V_structdefM[${structtypeS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "struct def named by \"%s\" and \"%s\" vars already exists: \"%s\"" -- \
                  inModS  structdefnameS  ${structtypeS}
            break;  fi
        internalDefL=( STR ${modUS}_structtypeS )
        if [[ ${internalB} -eq ${B_F} ]]; then  internalDefL+=( ${modUS}_structmapSD ${modUS}_structmapST );  fi
        for typeS  nameS in  ${(@)internalDefL}  ${(P)structdefL_S}; do
            typetypeS=internal
            if ! [[ ${nameS} =~ ${INTERNAL_REX_C_reVarnameA_S} ]]; then
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 4 ))
                print -v errS -f "\"%s\" %s" --  \
                      ${structdefL_S} \
                      "$(INTERNAL_FRAMEWORK_F_regexShow -T F -n nameS -v ${nameS} -P -A -m INTERNAL_REX_C_reVarnameA_S)"
                break 2;  fi
            if [[ -v "thisM[${nameS}]" ]]; then
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 5 ))
                print -v errS -f "fieldname used more than once in struct def: \"%s\";  %s=( %s )" -- \
                      ${nameS}  ${structdefL_S}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- ${structdefL_S})"
                break 2;  fi
            if ! [[  -v "INTERNAL_FRAMEWORK_C_typenameToInitM[${typeS}]" ]]; then
                if ! [[ -v "${modUS}_V_structdefM[${typeS}]" ]]; then
                    errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 6 ))
                    print -v errS -f "unknown type used in \"%s\" var: \"%s\";  %s=( %s )" -- \
                          ${structdefL_S}  ${typeS}  ${structdefL_S}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- ${structdefL_S})"
                    break 2
                else  typetypeS=struct;  fi;  fi
            if [[ ${typetypeS} = internal ]]; then
                initS=${INTERNAL_FRAMEWORK_C_typenameToInitM[${typeS}]}
                if [[ ${nameS[-${#initS},-1]} != ${initS} ]]; then
                    formatS="var name / type mismatch in \"%s\" var:  varnameS=\"%s\"  typeS=\"%s\""
                    formatS+=";  required var ending: \"%s\";  %s=( %s )"
                    errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 7 ))
                    print -v errS -f ${formatS} -- \
                          ${structdefL_S}  ${nameS}  ${typeS}  ${initS} \
                          ${structdefL_S}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- ${structdefL_S})";
                    break 2;  fi
            elif ! [[ ${nameS} =~ ${INTERNAL_FRAMEWORK_C_reStructnameA_S} ]]; then
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 8 ))
                print -v errS -f "\"%s\" %s" -- \
                      ${structdefL_S} \
                      "$(INTERNAL_FRAMEWORK_F_regexShow -T F -n nameS -v ${nameS} -P -A -m INTERNAL_FRAMEWORK_C_reStructnameA_S)"
                break 2;  fi
            thisM[${nameS}]=${typeS};  thisL+=( ${typeS} ${nameS} );  done
        thisvarnameS="${modUS}_VD_structdef_${(P)${:-${modUS}_V_structdefI}}_L"
        evalS="LIST_G  ${thisvarnameS}=( ${thisL} );  ${modUS}_V_structdefI+=1"
        evalS+=";  ${modUS}_V_structdefM[${structtypeS}]=${thisvarnameS}"
        eval ${evalS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_create
# USAGE
#     ${selfS}  <structtypeS>  <structnameS>
#
# DESCRIPTION
#     Creates an instance of a struct that was previously defined by use of ..._F_define
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structtypeS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructtypenameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structtypeS  structnameS  structdefrefS  structrefS  nameS  typeS  typetypeS  evalS  refS  name2S  ref2S  value2S  structM_refS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
 
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structtypeS=$1  structnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structtypeS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_structnameS_SE}}
        if ! [[ -v "${modUS}_V_structdefM[${structtypeS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct def named by \"%s\" var does not exist: \"%s\"" -- \
                  structtypeS  ${structtypeS}
            break;  fi
        if [[ -v "${modUS}_V_structM[${structtypeS}_${structnameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
            print -v errS -f "struct instance named by \"%s\" and \"%s\" args already exists: \"%s\"" -- \
                  structtypeS  structnameS  "${structtypeS}_${structnameS}"
            break;  fi
        structdefrefS=${(P)${:-${modUS}_V_structdefM[${structtypeS}]}}
        structrefS="${modUS}_VD_struct_${(P)${:-${modUS}_V_structI}}_M"
        evalS="MAP_G   ${structrefS}=( )"
        evalS+=";  ${modUS}_V_structM[${structtypeS}_${structnameS}]=${structrefS}"
        evalS+=";  ${modUS}_V_structI+=1"
        eval ${evalS}
        for typeS nameS in ${(Pkv)structdefrefS}; do
            typetypeS=internal
            if ! [[  -v "INTERNAL_FRAMEWORK_C_typenameToInitM[${typeS}]" ]]; then
                if ! [[ -v "${modUS}_V_structdefM[${typeS}]" ]]; then
                    errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
                    print -v errS -f "unknown type used in \"%s\" struct def (from %s=\"%s\", %s=\"%s\"): \"%s\";  %s=( %s )" -- \
                          ${structdefrefS}  modS  ${inModS}  structdefnameS  ${structdefnameS}  ${typeS} \
                          ${structdefrefS}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- "${structdefrefS}")"
                    break 2
                else  typetypeS=struct;  fi;  fi
            if [[ ${typetypeS} = internal ]]; then
                ${modUS}_F_valueCreateInternal ${typeS}
                eval "${structrefS}[${nameS}]=\"${(P)${:-${modUS}_V_replyS}}\""
            else
                ${modUS}_F_create  ${typeS}  ${structtypeS}_${RANDOM}_ST
                refS=${(P)${:-${modUS}_V_replyS}}
                eval "${structrefS}[${nameS}]=\${refS}"
                for name2S ref2S in ${(Pkv)refS}; do
                    value2S=${(P)ref2S}
                    eval "${structrefS}[${nameS}.${name2S}]=\${ref2S}";  done
                ${modUS}_F_getFieldvalueByStructrefFieldname  ${structrefS}  ${modUS}_structmapST.${modUS}_structM
                structM_refS=${(P)${:-${modUS}_V_replyS}}
                eval "${structM_refS}[\${nameS}]=\${refS}"
            fi
            if [[ ${typeS} = STR  &&  ${nameS} = ${modUS}_structtypeS ]]; then
                ${modUS}_F_setFieldvalueByStructrefFieldname  ${structrefS}  ${nameS}  ${structtypeS};  fi
        done
        replyS=${structrefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_valueCreateInternal
# USAGE
#     ${selfS}  <typeS>
#
# DESCRIPTION
#     Creates an instance of a particular type of internal variable.
#     Returns ref (name) of that variable in ..._V_replyS
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=typeS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reTypenameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( typeS  storageS  valueS  evalS  storagenameS  refS  initS  eltnameS  freenameS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        typeS=$1
        eval ${(P)${:-${selfS}_C_varcheck_typeS_SE}}
        freenameS=${modUS}_V_${typeS}_free_L
        storageS=${(P)${:-${modUS}_C_typeStorageM[${typeS}]}}
        valueS=${(P)${:-${modUS}_C_typeValueM[${typeS}]}}
        initS=${INTERNAL_FRAMEWORK_C_typenameToInitM[${typeS}]}
        storagenameS="${modUS}_V_${typeS}_${storageS}_L"
        if [[ ${(P)#freenameS} -ne 0 ]]; then
            refS="${storagenameS}[${${(P)freenameS}[-1]}]"
            evalS="${freenameS}[-1]=();  "
            if [[ ${typeS} = STR ]]
            then  evalS+="${refS}="
            else  evalS+="${refS}=\${valueS}";  fi
            eval ${evalS}
        else
            if [[ ${typeS} = STR ]]
            then  evalS="${storagenameS}+=( \"\" )"
            else  evalS="${storagenameS}+=( ${valueS} )";  fi
            eval ${evalS}
            print -v refS -f "%s[%d]" -- \
                  ${storagenameS}  ${#${(P)storagenameS}}
            if [[ ${storageS} = ref ]]; then
                print -v eltnameS -f "%s_VD_%s_%d_%s" -- \
                      ${modUS}  ${typeS}  ${#${(P)storagenameS}}  ${initS}
                evalS="${typeS}_G  ${eltnameS}=( )"
                evalS+=";  ${storagenameS}[-1]=\"${eltnameS}\""
                eval ${evalS};  fi;  fi
        replyS=${refS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_valueDestroyInternal
# USAGE
#     ${selfS}  <refS>
#
# DESCRIPTION
#     Destroys instance of a particular type of internal variable, denoted by <varrefS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=varrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reVarrefA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( varrefS  refmodUS  reftypeS  refnumI  valueS  freenameS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
 
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        varrefS=$1
        eval ${(P)${:-${selfS}_C_varcheck_varrefS_SE}}
        if ! [[ -v "${varrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var ref'd by \"%s\" var does not exist: \"%s\"" -- \
                  varrefS  ${varrefS}
            break;  fi
        [[ ${varrefS} =~ ${INTERNAL_FRAMEWORK_C_reVarrefA_S} ]]
        refmodUS=$2  reftypeS=$6  refnumI=$7
        valueS=${(P)${:-${modUS}_C_typeValueM[${reftypeS}]}}
        if [[ ${reftypeS} = STR ]]
        then  evalS="${varrefS}=;  "
        else  evalS="${varrefS}=${valueS};  ";  fi
        freenameS=${refmodUS}_V_${reftypeS}_free_L
        evalS+=="${freenameS}+=( \${refnumI );  "
        eval ${evalS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_destroyByStructtypename
#
# USAGE
#     ${selfS}  <structtypenameS>
#
# DESCRIPTION
#     Destroys struct named by <structtypenameS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structtypenameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructtypenameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structtypenameS  structrefS  calleemodUS  calleeS  selectorS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
 
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structtypenameS=$1
        eval ${(P)${:-${selfS}_C_varcheck_structtypenameS_SE}}
        if ! [[ -v "${modUS}_V_structM[${structtypenameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct named by \"%s\" var does not exist: \"%s\"" -- \
                  structtypenameS  ${structtypenameS}
            break;  fi
        structrefS=${(P)${:-${modUS}_V_structM[${structtypenameS}]}}
        calleemodUS=${modUS}  calleeS=F_destroyByStructref  curerrI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
        eval INTERNAL_FRAMEWORK_A_callSimple  \${structrefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_destroyByStructref
#
# USAGE
#     ${selfS}  <structrefS>
#
# DESCRIPTION
#     Destroys struct ref'd by <structrefS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructrefA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
 
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        if ! [[ -v "${structrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct ref'd by \"%s\" var does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        structdefrefS=${(P)${:-${modUS}_V_structdefM[${structtypeS}]}}
        structrefS="${modUS}_VD_struct_${(P)${:-${modUS}_V_structI}}_M"
        evalS="MAP_G   ${structrefS}=( )"
        evalS+=";  ${modUS}_V_structM[${structtypeS}_${structnameS}]=${structrefS}"
        evalS+=";  ${modUS}_V_structI+=1"
        eval ${evalS}
        for typeS nameS in ${(Pkv)structdefrefS}; do
            typetypeS=internal
            if ! [[  -v "INTERNAL_FRAMEWORK_C_typenameToInitM[${typeS}]" ]]; then
                if ! [[ -v "${modUS}_V_structdefM[${typeS}]" ]]; then
                    errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                    print -v errS -f "unknown type used in \"%s\" struct def (from %s=\"%s\", %s=\"%s\"): \"%s\";  %s=( %s )" -- \
                          ${structdefrefS}  modS  ${inModS}  structdefnameS  ${structdefnameS}  ${typeS} \
                          ${structdefrefS}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- "${structdefrefS}")"
                    break 2
                else  typetypeS=struct;  fi;  fi
            if [[ ${typetypeS} = internal ]]; then  ${modUS}_F_valueCreateInternal ${typeS}
            else
                ${modUS}_F_instanceCreate  ${typeS}  ${structtypeS}_${RANDOM};  fi
            eval "${structrefS}[${nameS}]=\"${(P)${:-${modUS}_V_replyS}}\"";  done
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getStructrefByStructtypename
#
# USAGE
#     ${selfS}  <structtypenameS>
#
# DESCRIPTION
#     Returns <structrefS> (i.e. var name) of <structnameS> instance in  ..._V_replyS
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structtypenameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructtypenameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structtypenameS  structrefS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structtypenameS=$1
        eval ${(P)${:-${selfS}_C_varcheck_structtypenameS_SE}}
        if ! [[ -v "${modUS}_V_structM[${structtypenameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct does not exist: structtypenameS=\"%s\"" -- \
                  ${structtypenameS}
            break;  fi
        structrefS=${(P)${:-${modUS}_V_structM[${structtypenameS}]}}
        replyS=${structrefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getFieldrefByStructrefFieldname
#
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>
#
# DESCRIPTION
#     Returns <fieldrefS> (i.e. var name) of field named <fieldnameS> within <structrefS> struct
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  typeS  fieldrefS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
        if ! [[ -v "${structrefS}[${fieldnameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "%s denoted by \"%s\" arg (\"%s\")  does not exist in %s denoted by \"%s\" arg (\"%s\") : *\"%s\"=( %s )" -- \
                  fieldname  fieldnameS  ${fieldnameS}  'struct type'  structrefS  ${structrefS}  "${(P)structrefS}"
            break;  fi
        fieldrefS="${structrefS}[${fieldnameS}]"
        replyS=${fieldrefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_checkStructrefFieldname
#
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>
#
# DESCRIPTION
#     If no error: returns ${B_T} if structrefS/fieldnameS combo exists, otherwise ${B_F}
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  typeS  fieldrefS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
	replyB=${B_T}
        if ! [[ -v "${structrefS}[${fieldnameS}]" ]]; then  replyB=${B_F};  fi
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getFieldvalueByFieldref
#
# USAGE
#     ${selfS}  <fieldrefS>
#
# DESCRIPTION
#     Returns <valueS> (i.e. var content) of field ref'd by <fieldrefS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( fieldrefS  valuerefS  valueS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        fieldrefS=$1
        eval ${(P)${:-${selfS}_C_varcheck_fieldrefS_SE}}
        if ! [[ -v ${fieldrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  fieldrefS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
        if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
        valueS=${(P)valuerefS}
	if [[ ${valueS} = '' ]]; then  valueS=_NULL_;  fi
        replyS=${valueS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getValuerefByStructrefFieldname
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>
#
# DESCRIPTION
#     Returns <valueS> (i.e. var content) of field ref'd by <structrefS>/<fieldnameS> combination
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  fieldrefS  valuerefS  typeS  )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
        fieldrefS="${structrefS}[${fieldnameS}]"
        if ! [[ -v "${fieldrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "field named by \"%s\" and \"%s\" args does not exist: \"%s\"" -- \
                  structrefS  fieldnameS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
        replyS=${valuerefS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getFieldvalueByStructrefFieldname
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>
#
# DESCRIPTION
#     Returns <valueS> (i.e. var content) of field ref'd by <structrefS>/<fieldnameS> combination
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  fieldrefS  valuerefS  typeS  valueS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
        fieldrefS="${structrefS}[${fieldnameS}]"
	if ! [[ -v "${fieldrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "field named by \"%s\" and \"%s\" args does not exist: \"%s\"" -- \
                  structrefS  fieldnameS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
         if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 4 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
        valueS=${(P)valuerefS}
	if [[ ${valueS} = '' ]]; then  valueS=_NULL_;  fi
#print -f "INFO: %s: structrefS=\"%s\"  fieldnameS=\"%s\"  valueS=\"%s\"\n" --  ${selfS}  ${structrefS}  ${fieldnameS}  ${valueS}
        replyS=${valueS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getOpSetFieldvalueByStructrefFieldname
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>  <funcnameS>  [ <funcargS>... ]
#
# DESCRIPTION
#     1. Retrieves content (i.e. <valueS>) of field ref'd by <structrefS>/<fieldnameS> combination
#     2. Calls <funcnameS> with <valueS>
#     3. Sets value of field ref'd by <structrefS>/<fieldnameS> combination to returned <valueS>
#     4. Returns new <valueS> to caller
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=funcnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reFuncnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcMinI=3  argcMaxI=99  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  fieldrefS  valuerefS  typeS  valueS  funcnameS  funcargL )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2  funcnameS=$3
	if [[ ${argcI} -gt 3 ]]; then  funcargL=( "${argL[4,-1]}" );  fi
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_funcnameS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
        fieldrefS="${structrefS}[${fieldnameS}]"
	if ! [[ -v "${fieldrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "field named by \"%s\" and \"%s\" args does not exist: \"%s\"" -- \
                  structrefS  fieldnameS  ${fieldrefS}
            break;  fi
        if ! functions ${funcnameS} >/dev/null; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 4 ))
            print -v errS -f "\"%s\" arg value does not refer to known function: \"%s\"" -- \
                  funcnameS  ${funcnameS};  break;  fi
        valuerefS=${(P)fieldrefS}
        if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 5 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
        valueS=${(P)valuerefS}
	if [[ ${valueS} = '' ]]; then  valueS=_NULL_;  fi
        eval "${funcnameS} \${funcargL} \${valueS}"; evalI=$?
        if [[ ${evalI} -ne 0 ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 6 ))
            print -v errS -f "call to funcnameS (i.e. \"%s\") failed: %d" -- \
                  ${funcnameS}  ${evalI};  break;  fi
	curerrI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 7 ))
        for varnameS in  errB  errI  errS  replyS; do
            if [[ ! -v "${funcnameS}_V_${varnameS}" ]]; then
                errI=${curerrI}
                print -v errS -f "var \"%s_V_%s\" does not exist;  funcnameS=\"%s\"" -- \
                      ${funcnameS}  ${varnameS}  ${funcnameS};  break 2;  fi
            evalS+="STR_L   result_${varnameS}_S=\${${funcnameS}_V_${varnameS}};  "
	    curerrI+=1;  done
        eval ${evalS};  evalS=
        case ${result_errB_S} in
            (${B_T}) ;;
            (${B_F}) ;;
            (*)
                errI=$(( ${curerrI} + 0 ))
                print -v errS -f "var named \"%s\", returned by funcnameS (i.e. \"%s\"), not in  ( %d %d ): %d" -- \
                      ${funcnameS}_V_errB  ${funcnameS}  ${B_T}  ${B_F}  ${result_errB_S};  break ;;  esac
        if [[ ${result_errB_S} -eq ${B_T} ]]; then
            errI=$(( ${curerrI} + 1 ))
            print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" -- \
                  ${funcnameS}  ${result_errS_S}  ${result_errI_S};  break;  fi
	valueS=${result_replyS_S}
        eval "${valuerefS}=\${valueS}"
	replyS=${valueS}  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_getFieldvalueByStructtypenameFieldname
#
# USAGE
#     ${selfS}  <structtypenameS>  <fieldnameS>
#
# DESCRIPTION
#     Returns <valueS> (i.e. var content) of field ref'd by <structtypenameS>/<fieldnameS> combination
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structtypenameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructtypenameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structtypenameS  structrefS  fieldnameS  typeS  fieldrefS  valuerefS  valueS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structtypenameS=$1  fieldnameS=$2
        eval ${(P)${:-${selfS}_C_varcheck_structtypenameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        if ! [[ -v "${modUS}_V_structM[${structtypenameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct named by \"%s\" arg does not exist: \"%s\"" -- \
                  structtypenameS  ${structtypenameS}
            break;  fi
        structrefS=${(P)${:-${modUS}_V_structM[${structtypenameS}]}}
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structtypenameS  ${structtypenameS}  association  ${typeS}
                break ;;  esac
        fieldrefS="${structrefS}[${fieldnameS}]"
        if ! [[ -v "${fieldrefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "field named by \"%s\" and \"%s\" args does not exist: \"%s\"" -- \
                  structtypenameS  fieldnameS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
        if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 4 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
        valueS=${(P)valuerefS}
	if [[ ${valueS} = '' ]]; then  valueS=_NULL_;  fi
        replyS=${valueS};  okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_setFieldvalueByFieldref
#
# USAGE
#     ${selfS}  <fieldrefS>  <valueS>
#
# DESCRIPTION
#     Sets var content of field ref'd by <fieldrefS> to <valueS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=valueS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( fieldrefS  valuerefS  valueS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        fieldrefS=$1  valueS=$2
        eval ${(P)${:-${selfS}_C_varcheck_fieldrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_valueS_SE}}
        if ! [[ -v ${fieldrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  fieldrefS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
        if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
	case ${valueS} in
	    (_NULL_)    valueS= ;;
	    (\\_NULL_)  valueS=_NULL_ ;;  esac
        eval "${valuerefS}=\${valueS}"
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_setFieldvalueByStructrefFieldname
#
# USAGE
#     ${selfS}  <structrefS>  <fieldnameS>  <valueS>
#
# DESCRIPTION
#     Sets var content of field ref'd by the <structrefS>/<fieldnameS> combination to <valueS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structrefS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=valueS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=3  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structrefS  fieldnameS  fieldrefS  valuerefS  typeS  valueS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structrefS=$1  fieldnameS=$2  valueS=$3
        eval ${(P)${:-${selfS}_C_varcheck_structrefS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_valueS_SE}}
        if ! [[ -v ${structrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  structrefS  ${structrefS}
            break;  fi
        typeS=${(Pt)structrefS}
        case ${typeS} in
            (association*) ;;
            (*)
                errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 2 ))
                print -v errS -f "var named by \"%s\" arg (\"%s\") is not of type \"%s*\": \"%s\"" -- \
                      structrefS  ${structrefS}  association  ${typeS}
                break ;;  esac
        if ! [[ -v "${structrefS}[${fieldnameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 3 ))
            print -v errS -f "field named by \"%s\" arg does not exist: \"%s\"" -- \
                  fieldnameS  ${fieldnameS}
            break;  fi
        fieldrefS="${structrefS}[${fieldnameS}]"
        if ! [[ -v ${fieldrefS} ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 4 ))
            print -v errS -f "var named by \"%s\" arg does not exist: \"%s\"" -- \
                  fieldrefS  ${fieldrefS}
            break;  fi
        valuerefS=${(P)fieldrefS}
        if ! [[ -v "${valuerefS}" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 5 ))
            print -v errS -f "INTERNAL: value referred to by \"%s\" var does not exist: \"%s\"" -- \
                  valuerefS  ${valuerefS}
            break;  fi
	case ${valueS} in
	    (_NULL_)    valueS= ;;
	    (\\_NULL_)  valueS=_NULL_ ;;  esac
        eval "${valuerefS}=\${valueS}"
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_setFieldvalueByStructnameFieldname
#
# USAGE
#     ${selfS}  <structnameS>  <fieldnameS>  <valueS>
#
# DESCRIPTION
#     Sets var content of field ref'd by the <structnameS>/<fieldnameS> combination to <valueS>
#
INT_G   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=structnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=fieldnameS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8  rexvarnameS=INTERNAL_FRAMEWORK_C_reStructfieldnameA_S
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgRequireVarTypeRex  selectorS=valueS
    eval INTERNAL_FRAMEWORK_A_callSimple \
        callerS=${selfS}  varnameS=${selectorS}  typeS=str  errI=${(P)${:-${selfS}_V_nexterrI}}  prependS= \
        indentI=8
    STR_G   ${selfS}_C_varcheck_${selectorS}_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_cgCheckargc  selectorS="arg count"
    eval INTERNAL_FRAMEWORK_A_callSimple \
         errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=3  indentI=8
    STR_G   ${selfS}_C_checkargc_SE=${INTERNAL_FRAMEWORK_V_replyS}
    eval "${selfS}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}"
 
    STR_L   nametypeS=local
    LIST_L  varnameL=( structnameS  fieldnameS  valueS  structrefS  calleemodS  calleeS )
    BOOL_L  printB=${B_F}
    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_localVarsMake  selectorS="local vars";  eval INTERNAL_FRAMEWORK_A_callSimple
    STR_G   ${selfS}_C_localvarsMake_SE=${INTERNAL_FRAMEWORK_V_replyS}
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        structnameS=$1  fieldnameS=$2  valueS=$3
        eval ${(P)${:-${selfS}_C_varcheck_structnameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_fieldnameS_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_valueS_SE}}
        if ! [[ -v "${modUS}_V_structM[${structnameS}]" ]]; then
            errI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
            print -v errS -f "struct named by \"%s\" arg is not defined: \"%s\"" -- \
                  structnameS  ${structnameS}
            break;  fi
        structrefS=${(P)${:-${modUS}_V_structM[${structnameS}]}}
        calleemodS=${modUS}  calleeS=F_setFieldvalueByStructrefFieldname; \
            eval INTERNAL_FRAMEWORK_A_callSimple  ${structrefS}  \${fieldnameS}  \${valueS}
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_internalInit
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
    LIST_L  varnameL=( calleemodUS  calleeS  selectorS  curerrI  structmapSDL )
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
	eval INTERNAL_STRUCT_A_selfmodSetup
        eval INTERNAL_FRAMEWORK_A_funcStart
        eval ${(P)${:-${selfS}_C_localvarsMake_SE}}
        structmapSDL=( MAP  ${modUS}_structM )
        curerrI=1;  eval INTERNAL_FRAMEWORK_A_argL_to_argL_S
        eval ${(P)${:-${selfS}_C_checkargc_SE}}
        calleemodUS=INTERNAL_STRUCT calleeS=F_define curerrI=$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))
        eval INTERNAL_FRAMEWORK_A_callSimple  internalB=${B_T}  \${modS}  structmapSD  structmapSDL
        okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


BOOL_L  okB=${B_F}
INT_L   curerrI
STR_L   errS
repeat 1; do
    curerrI=1;  INTERNAL_FRAMEWORK_A_retsReset
    curerrI=2;  ${modUS}_F_internalInit
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    if [[ ${curerrI} -eq 1 ]]
    then  print -v errS -f "%s; errI=%d" --  "${INTERNAL_FRAMEWORK_V_errS}"  ${INTERNAL_FRAMEWORK_V_errI}
    else  print -v errS -f "%s; errI=%d" --  "${(P)${:-${modUS}_V_errS}}"  ${(P)${:-${modUS}_V_errI}};  fi
    print -v errS -f "%s:  { %s;  errI=%d }" --  ${modS}  ${errS}  ${curerrI}
    print -f "%s\n" -- ${errS}
    exit ${curerrI};  fi


repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_F_retsReset  ${modS}
    eval INTERNAL_CODEGEN_FRAMEWORK_A_selfCodegen
    eval INTERNAL_CODEGEN_FRAMEWORK_A_stateReset
    INTERNAL_FRAMEWORK_F_modCacheWrite \
        --module internal/struct \
        --depend internal/rex internal/codegen/framework \
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
STR_L   modS=internal/struct
STR_L   modUS=${(U)modS//\//_}

#CODEGEN_EXEC{
INTERNAL_FRAMEWORK_A_localErrvarsCreate
STR_L   modS=internal/struct
STR_L   modUS=${(U)modS//\//_}
LIST_L  codeL=()

INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL
unset codeL
#}CODEGEN_EXEC


#}CODEGEN_ACTIVE
fi
true
