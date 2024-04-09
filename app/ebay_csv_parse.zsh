#!/bin/zsh

# MEZX_startup{ v1.5
typeset +g selfpathS=$0
function {
    typeset +g pathnameS=${MEZXDIR-MEZXDIR_VAR_NOT_DEFINED}/internal/bootstrap.zsh  tmpbaseS=/tmp/${selfpathS:t}.$$
    . ${pathnameS} 1>${tmpbaseS}.out 2>${tmpbaseS}.err
    typeset +g -i resultI=$?  exitI=0
    if [[ ${resultI} -ne 0 ]]; then
        print -f "ERROR: %s (mezx-startup):  { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n" -- \
              ${selfpathS}  ${pathnameS}  ${resultI}  "$(cat ${tmpbaseS}.out)"  "$(cat ${tmpbaseS}.err)"
        exitI=1;  fi
    rm -f ${tmpbaseS}.{out,err}
    if [[ ${exitI} -ne 0 ]]; then exit ${exitI};  fi
}
unset selfpathS
# }MEZX_startup v1.5


LIST_L  modL=( lib/fsm lib/csv );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=app/ebay_csv_parse
STR_L   modUS=${(U)modS//\//_}
MAP_G   ${modUS}_V_orderM
INT_G   ${modUS}_V_countI


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


STR_L   selfS=${modUS}_F_main
#
# USAGE
#     <selfS>  <fileS>
#
function ${selfS}() {
    eval APP_EBAY_CSV_PARSE_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L   nameS_patternS_outputS_L=(
	"sales-record-number"	"Sales Record Number"	"Sales Record Number"
	"order-number"	"Order Number"	"Order Number"
	"buyer-username"	"Buyer Username"	"Buyer Username"
	"buyer-name"	"Buyer Name"	"Buyer Name"
	"buyer-email"	"Buyer Email"	"Buyer Email"
	"buyer-note"	"Buyer Note"	"Buyer Note"
	"buyer-address-1"	"Buyer Address 1"	"Buyer Address 1"
	"buyer-address-2"	"Buyer Address 2"	"Buyer Address 2"
	"buyer-city"	"Buyer City"	"Buyer City"
	"buyer-state"	"Buyer State"	"Buyer State"
	"buyer-zip"	"Buyer Zip"	"Buyer Zip"
	"buyer-country"	"Buyer Country"	"Buyer Country"
	"buyer-tax-identifier-name"	"Buyer Tax Identifier Name"	"Buyer Tax Identifier Name"
	"buyer-tax-identifier-value"	"Buyer Tax Identifier Value"	"Buyer Tax Identifier Value"
	"ship-to-name"	"Ship To Name"	"Ship To Name"
	"ship-to-phone"	"Ship To Phone"	"Ship To Phone"
	"ship-to-address-1"	"Ship To Address 1"	"Ship To Address 1"
	"ship-to-address-2"	"Ship To Address 2"	"Ship To Address 2"
	"ship-to-city"	"Ship To City"	"Ship To City"
	"ship-to-state"	"Ship To State"	"Ship To State"
	"ship-to-zip"	"Ship To Zip"	"Ship To Zip"
	"ship-to-country"	"Ship To Country"	"Ship To Country"
	"item-number"	"Item Number"	"Item Number"
	"item-title"	"Item Title"	"Item Title"
	"custom-label"	"Custom Label"	"Custom Label"
	"sold-via-promoted-listings"	"Sold Via Promoted Listings"	"Sold Via Promoted Listings"
	"quantity"	"Quantity"	"Quantity"
	"sold-for"	"Sold For"	"Sold For"
	"shipping-and-handling"	"Shipping And Handling"	"Shipping And Handling"
	"item-location"	"Item Location"	"Item Location"
	"item-zip-code"	"Item Zip Code"	"Item Zip Code"
	"item-country"	"Item Country"	"Item Country"
	"ebay-collect-and-remit-tax-Rate"	"eBay Collect And Remit Tax Rate"	"eBay Collect And Remit Tax Rate"
	"ebay-collect-and-remit-tax-Type"	"eBay Collect And Remit Tax Type"	"eBay Collect And Remit Tax Type"
	"ebay-reference-name"	"eBay Reference Name"	"eBay Reference Name"
	"ebay-reference-value"	"eBay Reference Value"	"eBay Reference Value"
	"tax-status"	"Tax Status"	"Tax Status"
	"seller-collected-tax"	"Seller Collected Tax"	"Seller Collected Tax"
	"ebay-collected-tax"	"eBay Collected Tax"	"eBay Collected Tax"
	"electronic-waste-recycling-fee"	"Electronic Waste Recycling Fee"	"Electronic Waste Recycling Fee"
	"mattress-recycling-fee"	"Mattress Recycling Fee"	"Mattress Recycling Fee"
	"battery-recycling-fee"	"Battery Recycling Fee"	"Battery Recycling Fee"
	"white-goods-disposal-tax"	"White Goods Disposal Tax"	"White Goods Disposal Tax"
	"tire-recycling-fee"	"Tire Recycling Fee"	"Tire Recycling Fee"
	"additional-fee"	"Additional Fee"	"Additional Fee"
	"ebay-collected-charges"	"eBay Collected Charges"	"eBay Collected Charges"
	"total-price"	"Total Price"	"Total Price"
	"ebay-collected-tax-and-fees-Included-in-Total"	"eBay Collected Tax and Fees Included in Total"	"eBay Collected Tax and Fees Included in Total"
	"payment-method"	"Payment Method"	"Payment Method"
	"sale-date"	"Sale Date"	"Sale Date"
	"paid-on-date"	"Paid On Date"	"Paid On Date"
	"ship-by-date"	"Ship By Date"	"Ship By Date"
	"minimum-estimated-delivery-date"	"Minimum Estimated Delivery Date"	"Minimum Estimated Delivery Date"
	"maximum-estimated-delivery-date"	"Maximum Estimated Delivery Date"	"Maximum Estimated Delivery Date"
	"shipped-on-date"	"Shipped On Date"	"Shipped On Date"
	"feedback-left"	"Feedback Left"	"Feedback Left"
	"feedback-received"	"Feedback Received"	"Feedback Received"
	"my-item-note"	"My Item Note"	"My Item Note"
	"paypal-transaction-id"	"PayPal Transaction ID"	"PayPal Transaction ID"
	"shipping-service"	"Shipping Service"	"Shipping Service"
	"tracking-number"	"Tracking Number"	"Tracking Number"
	"transaction-id"	"Transaction ID"	"Transaction ID"
	"variation-details"	"Variation Details"	"Variation Details"
	"global-shipping-program"	"Global Shipping Program"	"Global Shipping Program"
	"global-shipping-reference-id"	"Global Shipping Reference ID"	"Global Shipping Reference ID"
	"click-and-collect"	"Click And Collect"	"Click And Collect"
	"click-and-collect-reference-number"	"Click And Collect Reference Number"	"Click And Collect Reference Number"
	"ebay-plus"	"eBay Plus"	"eBay Plus"
	"authenticity-verification-program"	"Authenticity Verification Program"	"Authenticity Verification Program"
	"authenticity-verification-status"	"Authenticity Verification Status"	"Authenticity Verification Status"
	"authenticity-verification-outcome-reason"	"Authenticity Verification Outcome Reason"	"Authenticity Verification Outcome Reason"
	"ebay-vault-program"	"eBay Vault Program"	"eBay Vault Program"
	"vault-fulfillment-type"	"Vault Fulfillment Type"	"Vault Fulfillment Type"
	"ebay-fulfillment-program"	"eBay Fulfillment Program"	"eBay Fulfillment Program"
	"tax-city"	"Tax City"	"Tax City"
	"tax-state"	"Tax State"	"Tax State"
	"tax-zip"	"Tax Zip"	"Tax Zip"
	"tax-country"	"Tax Country"	"Tax Country"
	"ebay-international-shipping"	"eBay International Shipping"	"eBay International Shipping"
    )
    STR_L   pathnameS  headerS  lineS  platformidS  nameS  patternS  outputS  varnameS
    INT_L   subnumI
 
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    curerrI=2;  calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=1
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	pathnameS=$1
	if ! [[ -f ${pathnameS}  &&  -r ${pathnameS} ]]; then
	    errI=4
            print -v errS -f '"%s" arg value does not refer to extant/readable file: "%s"' -- \
		  pathnameS  "${pathnameS}";  break;  fi

	head -1 ${pathnameS} | read -r headerS
	headerS=${headerS/\/}
	calleemodUS=LIB_CSV calleeS=F_setup curerrI=5; \
	    INTERNAL_FRAMEWORK_A_callSimple  excel  target  nameS_patternS_outputS_L  \${headerS}

	print -f 'INFO: %s: processing records... ' -- $0
	INT_L   termI=0  countI=0
	tail +2 ${pathnameS} | while read -r lineS; do
	    lineS=${lineS/\/}
	    calleemodUS=LIB_CSV calleeS=F_extract curerrI=7;  \
		INTERNAL_FRAMEWORK_A_callSimple  target  \${lineS}
	    platformidS=${LIB_CSV_V_replyM[order-number]}
	    platformidS=${platformidS//-/_}
	    LIB_CSV_V_replyM[order-number]=${platformidS}
	    varnameS="${modUS}_V_orderM[\${platformidS}]"
	    if ! [[ -v ${varnameS} ]]; then
		eval "${varnameS}=0"; fi
	    eval "${varnameS}=\$(( \${${varnameS}} + 1 ));  subnumI=\${${varnameS}}"
	    varnameS="${modUS}_V_order_${platformidS}_${subnumI}_M"
	    eval "MAP_G   ${varnameS}=()"
	    eval "${varnameS}=( \"\${(kv@)LIB_CSV_V_replyM}\" )"
	    countI+=1
	    termI+=-1
	    if (( ${countI} % 100 == 0 )); then
		print -f '%d  ' -- ${countI};  fi
	    if [[ ${termI} -eq 0 ]]; then
		okB=${B_T};  break;  fi
	    okB=${B_T};  done
	print -f '%d  DONE\n' -- ${countI}
	INT_G   ${modUS}_V_countI=${countI};  done
    eval APP_EBAY_CSV_PARSE_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval APP_EBAY_CSV_PARSE_A_selfmodSetup
eval INTERNAL_FRAMEWORK_A_funcStart
eval INTERNAL_FRAMEWORK_A_retsReset
repeat 1; do
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	STR_L   pathnameS=$1
	calleemodUS=${modUS}  calleeS=F_main  curerrI=3;  INTERNAL_FRAMEWORK_A_callSimple  \${pathnameS}
	calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_modCacheWrite  curerrI=4
	INTERNAL_FRAMEWORK_A_callSimple \
	    --module ${modS} \
	    --exclude func ${modUS}_F_main
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${(P)${:-${modUS}_V_errB}} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
