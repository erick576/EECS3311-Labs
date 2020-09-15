note
	description: "Summary description for {BANK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK

create
	make

feature -- Constructor
	make
			-- Initialize an empty account list.
		do
			create accounts.make_empty
		end

feature -- Attributes
	accounts: ARRAY[ACCOUNT]

feature -- Queries
	account_of (n: STRING): ACCOUNT
		require
			across accounts as acc some acc.item.owner ~ n end
		do
			create Result.make ("")
			across
				accounts as cursor
			loop
				if cursor.item.owner ~ n then
					Result := cursor.item
				end
			end
			check not Result.owner.is_empty end
		ensure
			Result.owner ~ n
		end

feature -- Commands
	add (n: STRING)
		require
			across accounts as acc all acc.item.owner /~ n end
		local
			new_account: ACCOUNT
		do
			create new_account.make (n)
			accounts.force (new_account, accounts.upper + 1)
		end

	deposit_on_v1 (n: STRING; a: INTEGER)
			-- Deposit 'a' into the account of 'n'.
			-- Version with correct implementation and incomplete contracts.
		require
			across accounts as acc some acc.item.owner ~ n end
		local
			i: INTEGER
		do
			from
				i := accounts.lower
			until
				i > accounts.upper
			loop
				if accounts[i].owner ~ n then
					accounts[i].deposit (a)
				end
				i := i + 1
			end
		ensure
			num_of_accounts_unchanged:
				accounts.count = old accounts.count
			balance_of_n_increased:
				account_of (n).balance = old account_of (n).balance + a
		end

	deposit_on_v2 (n: STRING; a: INTEGER)
			-- Deposit 'a' into the account of 'n'.
			-- Version with wrong implementation but incomplete contracts.
		require
			across accounts as acc some acc.item.owner ~ n end
		local
			i: INTEGER
		do
			from
				i := accounts.lower
			until
				i > accounts.upper
			loop
				if accounts[i].owner ~ n then
					accounts[i].deposit (a)
				end
				i := i + 1
			end
			-- wrong implemenation: also deposit in the first account
			accounts[accounts.lower].deposit (a)
		ensure
			num_of_accounts_unchanged:
				accounts.count = old accounts.count
			balance_of_n_increased:
				account_of (n).balance = old account_of (n).balance + a
		end

	deposit_on_v3 (n: STRING; a: INTEGER)
			-- Deposit 'a' into the account of 'n'.
			-- Version with wrong implementation, complete contracts, but reference copy.
		require
			across accounts as acc some acc.item.owner ~ n end
		local
			i: INTEGER
		do
			from
				i := accounts.lower
			until
				i > accounts.upper
			loop
				if accounts[i].owner ~ n then
					accounts[i].deposit (a)
				end
				i := i + 1
			end
			-- wrong implemenation: also deposit in the first account
			accounts[accounts.lower].deposit (a)
		ensure
			num_of_accounts_unchanged:
				accounts.count = old accounts.count
			balance_of_n_increased:
				account_of (n).balance = old account_of (n).balance + a
			across
				old accounts as cursor
			all
				cursor.item.owner /~ n implies
					cursor.item ~ account_of (cursor.item.owner)
			end
		end

	deposit_on_v4 (n: STRING; a: INTEGER)
			-- Deposit 'a' into the account of 'n'.
			-- Version with wrong implementation, complete contracts, but shallow object copy.
		require
			across accounts as acc some acc.item.owner ~ n end
		local
			i: INTEGER
		do
			from
				i := accounts.lower
			until
				i > accounts.upper
			loop
				if accounts[i].owner ~ n then
					accounts[i].deposit (a)
				end
				i := i + 1
			end
			-- wrong implemenation: also deposit in the first account
			accounts[accounts.lower].deposit (a)
		ensure
			num_of_accounts_unchanged:
				accounts.count = old accounts.count
			balance_of_n_increased:
				account_of (n).balance = old account_of (n).balance + a
			across
				old accounts.twin as cursor
			all
				cursor.item.owner /~ n implies
					cursor.item ~ account_of (cursor.item.owner)
			end
		end

	deposit_on_v5 (n: STRING; a: INTEGER)
			-- Deposit 'a' into the account of 'n'.
			-- Version with wrong implementation, complete contracts, but deep object copy.
		require
			across accounts as acc some acc.item.owner ~ n end
		local
			i: INTEGER
		do
			from
				i := accounts.lower
			until
				i > accounts.upper
			loop
				if accounts[i].owner ~ n then
					accounts[i].deposit (a)
				end
				i := i + 1
			end
			-- wrong implemenation: also deposit in the first account
			accounts[accounts.lower].deposit (a)
		ensure
			num_of_accounts_unchanged:
				accounts.count = old accounts.count
			balance_of_n_increased:
				account_of (n).balance = old account_of (n).balance + a
			across
				old accounts.deep_twin as cursor
			all
				cursor.item.owner /~ n implies
					cursor.item ~ account_of (cursor.item.owner)
			end
		end
end
