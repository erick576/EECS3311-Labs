note
	description: "An account class with owner and balance."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature -- Constructor
	make (n: STRING)
		do
			owner := n
			balance := 0
		end

feature -- Attributes
	owner: STRING
	balance: INTEGER

feature -- Commands
	deposit(a: INTEGER)
			-- Deposit 'a' into current account.
		do
			balance := balance + a
		ensure
			balance = old balance + a
		end

feature -- Equality
	is_equal(other: ACCOUNT): BOOLEAN
			-- Is current equal to 'other'?
		do
			Result :=
					owner ~ other.owner
				and balance = other.balance
		end
end
