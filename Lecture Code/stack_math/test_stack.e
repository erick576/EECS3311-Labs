note
	description: "stack_math application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STACK

inherit
	ES_TEST

create
	make

feature -- Initialization

	make
			-- Add tests.
		do
			add_boolean_case (agent test_rel)
			add_boolean_case (agent test_model)
			add_boolean_case (agent test_push)
			add_boolean_case (agent test_pop)

			show_browser
			run_espec
		end

feature -- Tests
	test_rel: BOOLEAN
		local
			r, t: REL[STRING, INTEGER]
			ds: SET[STRING]
		do
			comment ("test_rel: test command and query")
			create r.make_from_tuple_array (
				<<["a", 1], ["b", 2], ["c", 3],
					["a", 4], ["b", 5], ["c", 6],
					["d", 1], ["e", 2], ["f", 3]>>)

			create ds.make_from_array (<<"a">>)
			-- r is not changed
			t := r.domain_subtracted (ds)
			Result :=
						t /~ r
				and	not t.domain.has ("a")
				and	r.domain.has ("a")
			check Result end

			-- r is now changed
			r.domain_subtract (ds)
			Result :=
						t ~ r
				and	not t.domain.has ("a")
				and	not r.domain.has ("a")
			check Result end
		end

	test_model: BOOLEAN
		local
			s: LIFO_STACK[STRING]
			m: SEQ[STRING]
		do
			comment ("test_model")
			create s.make
			create m.make_empty
			Result := s.model ~ m
			check Result end

			s.push ("A")
			m.append ("A")
			Result := s.model ~ m
			check Result end

			s.push ("B")
			m.append ("B")
			Result := s.model ~ m
			check Result end
		end

	test_push: BOOLEAN
		local
			s: LIFO_STACK[STRING]
		do
			comment ("test_push: add an item")
			create s.make
			s.push ("A")
			Result := s.count = 1 and s.top ~ "A"
			check Result end

			s.push ("B")
			Result := s.count = 2 and s.top ~ "B"
		end


	test_pop: BOOLEAN
		local
			s: LIFO_STACK[STRING]
		do
			comment ("test_pop: delete the top")
			create s.make
			s.push ("A")
			s.push ("B")

			s.pop
			Result := s.count = 1 and s.top ~ "A"
			check Result end

			s.pop
			Result := s.count = 0
			check Result end
		end
end
