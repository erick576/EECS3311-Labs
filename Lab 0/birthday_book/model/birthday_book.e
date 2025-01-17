note
	description: "Summary description for {BIRTHDAY_BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY_BOOK

create
	make_empty

feature -- Attributes

	names: ARRAY[STRING]

	birthdays: LIST[BIRTHDAY] -- program from the interface not from the implementation

	count: INTEGER
		-- Number of stored name-birthday records

feature -- Queries

	get_birthday (name: STRING): BIRTHDAY
		-- Given an existing `name`, returns the corresponding birthday
		require
			existing_name:
				names.has(name)

		local
			i: INTEGER

		do
			-- because the return type BIRTHDAY is attached, we must explicitly initialize Result
			create Result.make (10, 15) -- just to initialize Result
			from
				i := 1
			until
				i > names.count
			loop
				if names[i] ~ name then
					Result := birthdays[i]
				end
				i := i + 1
			end

		ensure
			correct_result:
				Result ~ birthdays[index_of_name (name)]
		end

	get_detachable_birthday (name: STRING): detachable BIRTHDAY
			-- Returns the corresponding birthday, if the `name` exists, otherwise returns void (null)
		local
			i: INTEGER

		do
--			from
--				i := 1
--			until
--				i > names.count
--			loop
--				if names[i] ~ name then
--					-- if this condition re-assignment never occurs,
--					-- Result will remain to store the default value void
--					-- This is acceptable because the return type is `detachable BIRTHDAY`.
--					Result := birthdays[i]
--				end
--				i := i + 1
--			end
			i := index_of_name (name)
			if i > 0 then
				Result := birthdays[i]
			end
		ensure
			case_of_non_void_result:
--				Result /= void implies (Result ~ birthdays[index_of_name (name)])
				attached Result implies Result ~ birthdays[index_of_name (name)]
			case_of_void_result:
--				Result = void implies not names.has (name)
				not attached Result implies not names.has (name)
		end


	celebrate (today: BIRTHDAY): like names -- Will specify the type of names (anchor type)
		-- Given the date of `today`, returns a collection (anchoring the type of `names`) of names.
		local
			i: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			until
				i > names.count
			loop
				if today.day ~ birthdays[i].day and today.month ~ birthdays[i].month
					then
						Result.force (names[i], Result.count + 1)
				end
				i := i + 1
			end
			Result.compare_objects

		ensure
			lower_of_result: -- Do not modify
				Result.lower = 1
			every_name_in_result_is_an_existing_name:
				((across Result is name all names.has (name) end) or Result.count = 0)
			every_name_in_result_has_birthday_today:
				((across Result is name all birthdays[index_of_name(name)].day = today.day and birthdays[index_of_name(name)].month = today.month end) or Result.count = 0)
		end

		-- You should also write boolean test queries to test the implementation of `celebrate`
		-- You should also write violation test commands to test the postcondition of `celebrate`


feature -- Auxiliary Queries

	index_of_name (name: STRING): INTEGER
		-- Returns the index of `name` in the `names` array, if it exists
		-- Otherwise returns 0
		local
			i: INTEGER
		do
			i := 1 -- assuming that names.lower = 1
			Result := 0
			across
				names is l_n
			loop
				if l_n ~ name then
					Result := i
				end
				i := i + 1
			end
		end

feature -- Command

	make_empty
		-- Creates an empty birthday book.
		do
			create names.make_empty -- equivalent to: create {ARRAY[STRING]} names.make_empty
			create {LINKED_LIST[BIRTHDAY]} birthdays.make
			names.compare_objects
			birthdays.compare_objects

		ensure

		end

	add (name: STRING; birthday: BIRTHDAY)
			-- Adds a new record with `name` and `birthday`.
		require
			non_existing_name:
			-- Three ways to check if name exists
--				not names.has(name)
--				not (across names is l_n some l_n ~ name end)
				across names is l_n all l_n /~ name end
		do
			names.force (name, names.count + 1)
			birthdays.extend (birthday)
			count := count + 1

		ensure
			count_incremented:
				count = old count + 1

			name_added_to_end:
				names[count] ~ name

			birthday_added_to_end:
				birthdays[count] ~ birthday
		end

invariant
	consistent_counts:
		count = names.count and count = birthdays.count


	no_duplicate_names:
		across 1 |..| names.count is i
		all
			across 1 |..| names.count is j
				all
					i /= j implies names[i] /~ names[j]
			end
		end

end
