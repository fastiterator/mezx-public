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

STR_L   modS=internal/dynvar
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( internal/rex  internal/codegen/framework )
INTERNAL_FRAMEWORK_A_retsReset

repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_A_loadDependencies
    INTERNAL_FRAMEWORK_A_retsReset
    eval INTERNAL_CODEGEN_FRAMEWORK_A_selfCodegen
    eval INTERNAL_CODEGEN_FRAMEWORK_A_stateReset
    unset codeL
    INTERNAL_FRAMEWORK_F_modCacheWrite \
	--module ${modS} \
	--depend internal/rex internal/codegen/framework
    if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
	errI=1;  print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" --  \
            INTERNAL_FRAMEWORK_F_modCacheWrite  ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_errI};  break;  fi
    errB=${B_F};  done
if [[ ${errB} -eq ${B_T} ]]; then
    print -f "ERROR: %s:  { %s;  errI=%d }\n" --  ${modUS}  ${errS}  ${errI};  exit 1;  fi
INTERNAL_FRAMEWORK_A_defEnd


if false; then
#CODEGEN_ACTIVE{
INTERNAL_FRAMEWORK_A_retsReset


# global variables


#CODEGEN_EXEC{
INTERNAL_FRAMEWORK_A_localErrvarsCreate
STR_L   modS=internal/dynvar
STR_L   modUS=${(U)modS//\//_}
INT_L   gcperiodI=0
STR_L   initialS  refvalS  typeS  startS  codeS  listnameS  availnameLS  availnameMS  usetotalnameS  usesincenameS  dynnameS
LIST_L  codeL=()
LIST_L  typeL=(
    B  BOOL    val  '${B_T}'
    I  INT     val  '0'
    S  STR     val  '""'
    F  FLOATF  val  '0.0'
    E  FLOATE  val  '0.0'
    L  LIST    ref  '( )'
    M  MAP     ref  '( )'
)

for initialS typeS refvalS startS in ${typeL}; do
    print -v listnameS -f   "%s_VI_%s_%sL"    --  ${modUS}  ${typeS}  ${refvalS}
    print -v availnameLS -f "%s_VI_%s_availL" --  ${modUS}  ${typeS}
    print -v availnameMS -f "%s_VI_%s_availM" --  ${modUS}  ${typeS}
    print -v usetotalnameS -f  "%s_VI_%s_usetotalI" --  ${modUS}  ${typeS}
    print -v usesincenameS -f  "%s_VI_%s_usesinceI" --  ${modUS}  ${typeS}
    print -v codeS -f "LIST_G  %s=( ); " --  ${listnameS}
    codeL+=( ${codeS} )
    print -v codeS -f "LIST_G  %s=( ); " --  ${availnameLS}
    codeL+=( ${codeS} )
    print -v codeS -f "MAP_G   %s=( ); " --  ${availnameMS}
    codeL+=( ${codeS} )
    print -v codeS -f "INT_G   %s=0; "   --  ${usetotalnameS}
    codeL+=( ${codeS} )
    print -v codeS -f "INT_G   %s=0; "   --  ${usesincenameS}
    codeL+=( ${codeS} );  done
#print "codeL=\n----"
#print -f "%s\n" ${codeL}
#print -f "----\n"
INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL
codeL=( )

for initialS typeS refvalS startS in ${typeL}; do
    print -v listnameS -f "%s_VI_%s_%sL" --  ${modUS}  ${typeS}  ${refvalS}
    print -v availnameLS -f "%s_VI_%s_availL" --  ${modUS}  ${typeS}
    print -v availnameMS -f "%s_VI_%s_availM" --  ${modUS}  ${typeS}
    print -v usetotalnameS -f  "%s_VI_%s_usetotalI" --  ${modUS}  ${typeS}
    print -v usesincenameS -f  "%s_VI_%s_usesinceI" --  ${modUS}  ${typeS}
    if [[ ${refvalS} = val ]]; then
	# usage: e.g. INTERNAL_DYNVAR_F_allocINT
	print -v codeS -f '
	    function %s_F_alloc%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		eval INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
                
		if [[ ${#%s} -ne 0 ]]; then  ; 
 		    refI=${%s[-1]}; 
		    %s[-1]=( ); 
		    unset "%s[${refI}]"; 
		    %s[${refI}]=%s; 
		else  ; 
		    %s+=( %s ); 
		    refI=${#%s};  fi; 
		%s+=1;  %s+=1;
		%s_V_replyS="%s[${refI}]"; 
		%s_V_replyI=${refI}; 
		return ${B_T}; 
	    } 
	    
' -- \
	      ${modUS}  ${typeS} \
 	      ${availnameLS}  ${availnameLS}  ${availnameLS}  ${availnameMS}  ${listnameS}  "${startS}" \
	      ${listnameS}  "${startS}"  ${listnameS}  \
	      ${usetotalnameS}  ${usesincenameS}  ${modUS}  ${listnameS}  ${modUS};
	codeL+=${codeS}
	# print -f "### codeS=%s\n" -- ${codeS}
	
	# usage: e.g. INTERNAL_DYNVAR_F_freeINT <refI>...
	print -v codeS -f '
	    function %s_F_free%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
		INT_L   argcI=$#  argindexI=1; 
		LIST_L  argL=( "${(@)@}" ); 
		
		while [[ ${argindexI} -le ${argcI} ]]; do  ; 
		    refI=${argL[${argindexI}]}; 
		    if [[ ${refI} -gt 0  &&  ${refI} -le ${#%s} ]]; then  ; 
			%s+=( ${refI} );
			%s[${refI}]=1; 
			%s[${refI}]=%s;  fi;
		    argindexI+=1;  done;
		%s+=1;  %s+=1; 
		if [[ ${%s} -gt %s ]]; then  ;
		    %s_F_gc%s;  fi; 
		return ${B_T}; 
	    }
	    
' -- \
	      ${modUS}  ${typeS} \
	      ${listnameS}  ${availnameLS}  ${availnameMS}  ${listnameS}  ${startS} \
	      ${usetotalnameS}  ${usesincenameS}  ${usesincenameS}  ${gcperiodI}  ${modUS}  ${typeS};
	codeL+=${codeS}
	
	# usage: e.g. INTERNAL_DYNVAR_F_gcINT
	print -v codeS -f '
	    function %s_F_gc%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
		INT_L   indexI;
		LIST_L  keyI_L;
		
		keyI_L=( ${(kOn)%s} );
		for refI in ${keyI_L}; do  ;
		    if [[ ${refI} -ne ${#%s} ]]; then  continue;  fi; 
		    %s[${refI}]=( ); 
		    unset "%s[${refI}]";
		    indexI=${%s[(Ie)${refI}]};
		    if [[ ${indexI} -eq 0 ]]; then  continue;  fi;
		    %s[${indexI}]=( );
		done;
		%s+=1;  %s=0;
		return ${B_T}; 
	    }

' -- \
	      ${modUS}  ${typeS} \
	      ${availnameMS}  ${listnameS}  ${listnameS}  ${availnameMS}  ${availnameLS}  ${availnameLS} \
	      ${usetotalnameS}  ${usesincenameS};
	codeL+=${codeS}

    else
	# usage: e.g. INTERNAL_DYNVAR_F_allocLIST
	print -v dynnameS -f "%s_VI_%s_contentL" --  ${modUS}  ${typeS}
	print -v codeS -f '
	    function %s_F_alloc%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
		STR_L   replyS; 
                
		if [[ ${#%s} -ne 0 ]]; then  ; 
 		    refI=${%s[-1]};
		    %s[-1]=( ); 
		    unset "%s[${refI}]";
		else  ; 
		    %s+=( 0 ); 
		    refI=${#%s};  fi;
		eval "%s_G %s_${refI}=( ); ";
	        replyS="%s_${refI}"; 
		%s+=1;  %s+=1;
		%s_V_replyS=${replyS}; 
		%s_V_replyI=${refI}; 
		return ${B_T}; 
	    } 

' -- \
	      ${modUS}  ${typeS} \
 	      ${availnameLS}  ${availnameLS}  ${availnameLS}  ${availnameMS} \
	      ${listnameS}  ${listnameS} \
	      ${typeS}  ${dynnameS}  ${dynnameS}  ${usetotalnameS}  ${usesincenameS} ${modUS}  ${modUS};
	codeL+=${codeS}

	# usage: e.g. INTERNAL_DYNVAR_F_freeLIST <refI>...
	print -v codeS -f '
	    function %s_F_free%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
		STR_L   replyS; 
		INT_L   argcI=$#  argindexI=1; 
		LIST_L  argL=( "${(@)@}" ); 
		
		while [[ ${argindexI} -le ${argcI} ]]; do  ; 
		    refI=${argL[${argindexI}]}; 
		    if [[ ${refI} -gt 0  &&  ${refI} -le ${#%s} ]]; then  ; 
		        if [[ ${%s[${refI}]} -ne -1 ]]; then
			    %s+=( ${refI} ); 
			    %s[${refI}]=1; 
			    %s[${refI}]=-1;
			    unset %s_${refI};  fi;  fi; 
		    argindexI+=1;  done; 
		%s+=1;  %s+=1; 
		if [[ ${%s} -gt %s ]]; then  ;
		    %s_F_gc%s;  fi; 
		return ${B_T}; 
	    }

' -- \
	      ${modUS}  ${typeS} \
	      ${listnameS}  ${listnameS}  ${availnameLS}  ${availnameMS}  ${listnameS}  ${dynnameS} \
	      ${usetotalnameS}  ${usesincenameS}  ${usesincenameS}  ${gcperiodI}  ${modUS}  ${typeS};
	codeL+=${codeS}

	# usage: e.g. INTERNAL_DYNVAR_F_gcLIST
	print -v codeS -f '
	    function %s_F_gc%s() { 
	        INTERNAL_DYNVAR_A_selfmodSetup;
		INTERNAL_FRAMEWORK_A_localErrvarsCreate;
		INTERNAL_FRAMEWORK_A_retsReset;
	        INT_L   refI; 
		INT_L   indexI;
		LIST_L  keyI_L;
		
		keyI_L=( ${(kOn)%s} );
		for refI in ${keyI_L}; do  ;
		    if [[ ${refI} -ne ${#%s} ]]; then  continue;  fi; 
		    %s[${refI}]=( ); 
		    unset "%s[${refI}]";
		    indexI=${%s[(Ie)${refI}]};
		    if [[ ${indexI} -eq 0 ]]; then  continue;  fi;
		    %s[${indexI}]=( );
		done;
		%s+=1;  %s=0;
		return ${B_T}; 
	    }

' -- \
	      ${modUS}  ${typeS} \
	      ${availnameMS}  ${listnameS}  ${listnameS}  ${availnameMS}  ${availnameLS}  ${availnameLS} \
	      ${usetotalnameS}  ${usesincenameS};
	codeL+=${codeS}


    fi
done
#print "codeL=\n----"
#print -f "%s\n" ${codeL}
#print -f "----\n"
INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL

#}CODEGEN_EXEC


# aliases

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
    print "'${modUS}': ENTRY to $0";
'


#}CODEGEN_ACTIVE
fi
true
