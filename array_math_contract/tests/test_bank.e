note
	description: "Summary description for {TEST_BANK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_BANK

inherit
	ES_TEST

create
	make

feature -- Constructor
	make
		do
--			add_boolean_case (agent test_bank_creation_and_addition)

			-- correct implementation, incomplete contract
			add_boolean_case (agent test_bank_deposit_correct_imp_incomplete_contract)

			-- wrong implementation, incomplete contract
			add_boolean_case (agent test_bank_deposit_wrong_imp_incomplete_contract)

			-- wrong implementation, complete contract with reference copy
			add_boolean_case (agent test_bank_deposit_wrong_imp_complete_contract_ref_copy)

			-- wrong implementation, complete contract with shallow object copy
			add_boolean_case (agent test_bank_deposit_wrong_imp_complete_contract_shallow_copy)

			-- wrong implementation, complete contract with deep object copy
			add_boolean_case (agent test_bank_deposit_wrong_imp_complete_contract_deep_copy)
		end

feature -- Tests
	test_bank_creation_and_addition: BOOLEAN
		local
			b: BANK
		do
			comment ("t0: test the creation and addition of accounts to a bank")
			create b.make
			b.add ("Bill")
			b.add ("Steve")
			Result :=
					b.account_of ("Bill").owner ~ "Bill"
				and b.account_of ("Steve").owner ~ "Steve"
			check Result end
		end

	test_bank_deposit_correct_imp_incomplete_contract: BOOLEAN
		local
			b: BANK
		do
			comment ("t1: test deposit_on with correct imp and incomplete contract")
			create b.make
			b.add ("Bill")
			b.add ("Steve")

			-- deposit 100 dolars to Steve's account
			b.deposit_on_v1 ("Steve", 100)
			Result :=
					b.account_of ("Bill").balance = 0
				and b.account_of ("Steve").balance = 100
			check Result end
		end

	test_bank_deposit_wrong_imp_incomplete_contract: BOOLEAN
		local
			b: BANK
		do
			comment ("t2: test deposit_on with wrong imp but incomplete contract")
			create b.make
			b.add ("Bill")
			b.add ("Steve")

			-- deposit 100 dolars to Steve's account
			b.deposit_on_v2 ("Steve", 100)
			Result :=
					b.account_of ("Bill").balance = 0
				and b.account_of ("Steve").balance = 100
			check Result end
		end

	test_bank_deposit_wrong_imp_complete_contract_ref_copy: BOOLEAN
		local
			b: BANK
		do
			comment ("t3: test deposit_on with wrong imp, complete contract with reference copy")
			create b.make
			b.add ("Bill")
			b.add ("Steve")

			-- deposit 100 dolars to Steve's account
			b.deposit_on_v3 ("Steve", 100)
			Result :=
					b.account_of ("Bill").balance = 0
				and b.account_of ("Steve").balance = 100
			check Result end
		end

	test_bank_deposit_wrong_imp_complete_contract_shallow_copy: BOOLEAN
		local
			b: BANK
		do
			comment ("t4: test deposit_on with wrong imp, complete contract with shallow object copy")
			create b.make
			b.add ("Bill")
			b.add ("Steve")

			-- deposit 100 dolars to Steve's account
			b.deposit_on_v4 ("Steve", 100)
			Result :=
					b.account_of ("Bill").balance = 0
				and b.account_of ("Steve").balance = 100
			check Result end
		end

	test_bank_deposit_wrong_imp_complete_contract_deep_copy: BOOLEAN
		local
			b: BANK
		do
			comment ("t5: test deposit_on with wrong imp, complete contract with deep object copy")
			create b.make
			b.add ("Bill")
			b.add ("Steve")

			-- deposit 100 dolars to Steve's account
			b.deposit_on_v5 ("Steve", 100)
			Result :=
					b.account_of ("Bill").balance = 0
				and b.account_of ("Steve").balance = 100
			check Result end
		end
end
