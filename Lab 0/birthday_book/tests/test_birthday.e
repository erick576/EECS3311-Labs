note
	description: "[
		Test examples with arrays and regular expressions.
		First test fails as Result is False by default.
		Write your own tests.
		Included libraries:
			base and extension
			Espec unit testing
			Mathmodels
			Gobo structures
			Gobo regular expressions
		]"
	author: "Eric kwok"
	date: "$Date$"
	revision: "$Revision 19.05$"

CLASS
	TEST_BIRTHDAY

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			-- boolean tests
			add_boolean_case (agent t_always_passes)
			add_boolean_case (agent t_static_query)
			add_boolean_case (agent t_create_new_birthday)
--			add_boolean_case (agent t_create_invalid_birthday)-- Commented out because we need a violation test instead
			add_boolean_case (agent t_birthday_equality)

			-- violation tests
			add_violation_case_with_tag("valid_combination", agent t_precond_birthday_make)
			add_violation_case_with_tag("day_set", agent t_postcond_birthday_make)
		end

feature -- boolean tests
	t_always_passes: BOOLEAN
		do
			comment("t_always_passes: a test always passing")
			Result := true
			-- Return Result
		end

	t_static_query: BOOLEAN
		do
			comment("t_static_query: test is_month_with_31_days")
			-- For a boolean test query to pass
			-- 1. No Contract Violations
			-- 2. Last Re-Assigned value of Result must be true
			Result := {BIRTHDAY}.is_month_with_31_days (1)
			-- for each intermediate re-assignment to Result
			-- We must make sure it's not re-assigned to false.
			check
				Result
			end
--			Result := {BIRTHDAY}.is_month_with_31_days (4) = false
			Result := not {BIRTHDAY}.is_month_with_31_days (4)

			Result := {BIRTHDAY}.is_month_with_30_days (4)
			check
				Result
			end
			Result := not {BIRTHDAY}.is_month_with_30_days (1)
		end


	t_create_new_birthday: BOOLEAN
		local
			bd: BIRTHDAY
		do
			comment("t_create_new_birthday: create a valid instance of birthday")
			create bd.make (10, 15) -- command make is used as a constructor
			Result := bd.month = 10 and bd.day = 15
			check Result end
			create bd.make (9, 14) -- command make is used as a constructor
			Result := bd.month = 9 and bd.day = 14
			check Result end
			bd.make (7, 15)
			Result := bd.month = 7 and bd.day = 15
		end

--	t_create_invalid_birthday: BOOLEAN
--		local
--			bd: BIRTHDAY
--		do
--			comment("t_create_invalid_birthday: create an invalid instance of birthday")
--			-- The input values 11 and 31 is going to cause a precondition violation
--			-- preventing the implementation of make from being called
--			-- Even though a precondition violation hAppens in this case
--			-- it is expected and properly protects the supplier
--			create bd.make (11, 31)
--			-- Boolean test query would not be suitable for this case,
--			-- because it fails either because result is false or
--			-- when some violation occurs regardless of it being expected or not
--			
--			-- We need to write another kind of test in which we expect a particulat tagged
--			-- violation should occur
--			
--		end

	t_birthday_equality: BOOLEAN
		local
			bd1, bd2 : BIRTHDAY
		do
			comment("t_birthday_equality: test ref and obj equality of birthdays")
			create bd1.make (10, 15)
			create bd2.make (10, 15)

			-- Different objects
			Result := bd1 /= bd2
			check Result end

			Result := bd1.is_equal (bd2)
			check Result end

			Result := bd1 ~ bd2 -- bd1.is_equal(bd2)
		end

feature -- violation tests

	t_precond_birthday_make
	local
		bd: BIRTHDAY
	do
		comment("t_precond_brithday_make: test that the precondition with tag valid_combination is violated as expected")
		-- Since we are expecting a violation to occur
		-- you only have to write lines of code that will lead to that particular violation
		create bd.make (11, 31)
	end


	t_postcond_birthday_make
		local
			bd: BAD_BIRTHDAY_VIOLATING_DAY_SET
		do
			comment("t_postcond_birthday_make: test that the postcondition with tag day_set is violated as expected ")
			create bd.make(10, 14) -- the wrong implementation int "BAD_BIRTHDAY_VIOLARTING_DAY_SET" should
								   -- trigger the poistcondition with tag "day_set"
		end

end
