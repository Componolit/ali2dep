ECHO = @echo
OBJ_DIR ?= obj
prefix					?= /dummy
ADA_INCLUDE_DIR		?= /dummy
ADA_RTL_OBJ_DIR		?= /dummy
target_noncanonical	?= /dummy
libsubdir				?= /dummy

DUMMY := $(shell mkdir -p $(OBJ_DIR)/generated)

ifneq ($(CONTRIB_DIR),)
GPRBUILD_ARGS += -XCONTRIB_DIR=$(CONTRIB_DIR)
endif

all: obj/generated/sdefault.adb
	@gprbuild $(GPRBUILD_ARGS) -P build/build

obj/generated/sdefault.adb:
	$(ECHO) "pragma Style_Checks (Off);"											>  $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "with Osint; use Osint;"													>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "package body Sdefault is"												>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   S0 : constant String := \"$(prefix)/\";"						>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   S1 : constant String := \"$(ADA_INCLUDE_DIR)/\";"			>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   S2 : constant String := \"$(ADA_RTL_OBJ_DIR)/\";"			>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   S3 : constant String := \"$(target_noncanonical)/\";"		>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   S4 : constant String := \"$(libsubdir)/\";"					>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   function Include_Dir_Default_Name return String_Ptr is"	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   begin"																	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "      return Relocate_Path (S0, S1);"								>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   end Include_Dir_Default_Name;"									>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   function Object_Dir_Default_Name return String_Ptr is"	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   begin"																	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "      return Relocate_Path (S0, S2);"								>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   end Object_Dir_Default_Name;"										>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   function Target_Name return String_Ptr is"					>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   begin"																	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "      return new String'(S3);"										>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   end Target_Name;"														>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   function Search_Dir_Prefix return String_Ptr is"			>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   begin"																	>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "      return Relocate_Path (S0, S4);"								>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "   end Search_Dir_Prefix;"												>> $(OBJ_DIR)/tmp-sdefault.adb
	$(ECHO) "end Sdefault;"																>> $(OBJ_DIR)/tmp-sdefault.adb
	@mv $(OBJ_DIR)/tmp-sdefault.adb $@

clean:
	@rm -rf $(OBJ_DIR) ali2dep
