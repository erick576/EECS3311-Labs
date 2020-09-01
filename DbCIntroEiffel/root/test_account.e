note
	description: "Summary description for {TEST_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ACCOUNT
inherit
	ES_TEST
create
	make

feature -- Constructor for adding tests
	make
		do
			-- Two kinds of tests you can add
--			add_boolean_case (agent test_withdraw)
--			add_violation_case_with_tag ("positive_balance", agent test_illegal_initial_balance)
			add_violation_case_with_tag ("init_balance_set", agent test_wrong_imp_of_make)
		end

feature -- Test queries (test to succeed)

	test_withdraw: BOOLEAN
		-- This is a test query becuase it has a return value. 
		local
			acc: ACCOUNT
		do
			comment("Test withdraw")
			create {ACCOUNT} acc.make("Alan", 100)
			-- after this, we want to know if alan has
			-- got 100 initial balance

			-- Imagine that acc.make always initializes
			-- balance as 90
			Result := acc.balance = 100
			-- this very first re-assignment
			-- will change Result to false

			-- we need such an assertion at each
			-- intermediate point to make sure
			-- Result is never false.
			check Result end

			-- Imagine that acc.withdraw always
			-- withdraw nothing
			acc.withdraw (10)
			Result := acc.balance = 90
			-- this second re-assignment will
			-- change result to true

		end

feature -- Test commands (test to fail)

	test_illegal_initial_balance
		local
			acc: ACCOUNT
		do
			comment ("Test to violate a precondtion")
			-- We expect a precondition violation to occur
			create {ACCOUNT} acc.make ("Alan", -100)
		end

	test_wrong_imp_of_make
		local
			acc: ACCOUNT
		do
			comment ("Test to violate a postcondition")
			-- We expect a postcondition violation to occur
			create {ACCOUNT} acc.make ("Alan", 100)
		end

end
