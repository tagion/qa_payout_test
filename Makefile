SHELL:=$(shell which bash)
.SUFFIXES:
.ONESHELL:
WAIT:=10
URL:=https://qa.tagion.org/api/v1/

CURL=curl -X POST -H "Content-Type: application/octet-stream" --data-binary @$1 $(URL)$3 --output $2 

MAINWALLET?=wallet1

SIGNWALLET+=hugo
SIGNWALLET+=svend
SIGNWALLET+=bendt

AUSZAHLUNG:=auszahlung

PAYOUT_DIR:=$(MAINWALLET)/payout

ifndef PAYOUTFILE
$(error Failed payout file need to be set with PAYOUTFILE parameter)
endif

WALLETCONFIGS:=$(addsuffix .json,$(MAINWALLET) $(SIGNWALLET))

ifeq ("$(wildcard $(PAYOUTFILE))","") 
CSVFILE=$(PAYOUT_DIR)/$(PAYOUTFILE)
endif	

#
test1:
	@echo $(wildcard $(CSVFILE))	
	@echo $(X)

#
ifeq ("$(wildcard $(CSVFILE))","") 
$(error payout file not found $(CSVFILE))
endif

test:
	@echo X=$(X) Y=$(Y)
	@echo $(PAYOUT_DIR)
	@echo PAYOUTFILE=$(PAYOUTFILE)
	@echo CSVFILE=$(CSVFILE)
	@echo $(X)

payout: $(CSVFILE)  
	$(AUSZAHLUNG) $(WALLETCONFIGS) $<

CONTRACT_DIR:=$(MAINWALLET)/contracts

CONTRACT_NAME:=$(CONTRACT_DIR)/$(notdir $(basename $(CSVFILE)))

PAYOUT_CONTRACT:=$(CONTRACT_NAME).hibon
PAYOUT_CONTRACT_RESPONSE:=$(CONTRACT_NAME)_respose.hibon
UPDATE_CONTRACT:=$(CONTRACT_NAME)_update.hibon
UPDATE_CONTRACT_RESPONSE:=$(CONTRACT_NAME)_update_respose.hibon
BILL_UPDATE_CONTRACT:=$(CONTRACT_NAME)_bill_update.hibon
BILL_UPDATE_CONTRACT_RESPONSE:=$(CONTRACT_NAME)_bill_update_respose.hibon


info:
	@echo SHELL = $(SHELL)
	@echo CONTRACT_NAME                 =$(CONTRACT_NAME)
	@echo PAYOUT_CONTRACT               =$(PAYOUT_CONTRACT)
	@echo PAYOUT_CONTRACT_RESPONSE      =$(PAYOUT_CONTRACT_RESPONSE)
	@echo UPDATE_CONTRACT               =$(UPDATE_CONTRACT)
	@echo UPDATE_CONTRACT_RESPONSE      =$(UPDATE_CONTRACT_RESPONSE)
	@echo BILL_UPDATE_CONTRACT          =$(BILL_UPDATE_CONTRACT)
	@echo BILL_UPDATE_CONTRACT_RESPONSE	=$(BILL_UPDATE_CONTRACT_RESPONSE)

send:
	$(call CURL,$(PAYOUT_CONTRACT),$(PAYOUT_CONTRACT_RESPONSE),contract)
	@echo Wait $(WAIT)sec	
	for ((i;i<$(WAIT);i++))
	do 
		echo -n "# "
		sleep 1
	done 
	@echo
	$(call CURL,$(UPDATE_CONTRACT),$(UPDATE_CONTRACT_RESPONSE),dart)
	$(call CURL,$(BILL_UPDATE_CONTRACT),$(BILL_UPDATE_CONTRACT_RESPONSE),dart)
	@echo Now run
	@echo make update PAYOUTFILE=$(PAYOUTFILE)

update:
	$(AUSZAHLUNG) $(WALLETCONFIGS) --response $(UPDATE_CONTRACT_RESPONSE)
	$(AUSZAHLUNG) $(WALLETCONFIGS) --list
	$(AUSZAHLUNG) $(WALLETCONFIGS) --response $(BILL_UPDATE_CONTRACT_RESPONSE) $(CSVFILE)


