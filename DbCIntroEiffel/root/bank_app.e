note
	description: "bank application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_APP

inherit
	ARGUMENTS

create
	make

feature -- Initialization

	make
			-- Run application.
		local
			alan: ACCOUNT
--			mark: ACCOUNT
--			tom: ACCOUNT
--			jim: ACCOUNT
--			jeremy: ACCOUNT
		do
			-- This will cause a violation of the precondition with tag "positive_balance"
			create {ACCOUNT} alan.make ("Alan", -10)

			-- This will trigger a vioilation of the precondition with tag "non_negative_amount"
--			create {ACCOUNT} mark.make ("Mark", 100)
--			mark.withdraw (-1000000)

			-- This will trigger a violation of the precondition with tag "affordable_amount"
--			create {ACCOUNT} tom.make ("Tom", 100)
--			tom.withdraw (150)

--			-- This will trigge a violation of the class invariant with tag "positive_balance"
--			create {ACCOUNT} jim.make ("Jim", 100)
--			jim.withdraw (100)

			-- Now, modify TEMPORARILY the withdraw feature in ACCOUNT to have this wrong implementation:
			--   balance := balance - amount
			-- This will trigge a violation of the postcondition with tag "balance_deducted"
--			create {ACCOUNT} jeremy.make ("Jeremy", 100)
--			jeremy.withdraw (50)
			-- Once you have seen the postcondition violation, change it back to the correct implementation!
		end

end
