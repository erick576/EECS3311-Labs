note
	description: "Each account is associated with owner and balance."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

create
	make

feature -- Attributes
	owner : STRING
	balance : INTEGER

	make(nn: STRING; nb: INTEGER)
		require
			positive_balance: nb >= 0
		do
			owner := nn
			-- wrong
			balance := 90
--			balance := nb
		ensure
			init_balance_set: balance = nb
		end

feature -- Commands
	withdraw(amount: INTEGER)
		require
			non_negative_amount: amount >= 0
			affordable_amount: amount <= balance
		do
			-- Correct Implementation
--			balance := balance - amount
			-- Wrong
			balance := balance
			-- Wrong Implementation
--			balance := balance + amount
		ensure
--			balance_deducted: balance = old balance - amount
		end

invariant
	positive_balance: balance > 0
end
