note
	description: "Tests given by instructor to illustrate reference vs. shallow copies."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ARRAY_COPIES

inherit
	ES_TEST

create
	make

feature -- Adding tests
	make
		do
			add_boolean_case (agent test_array_ref_copy)
			add_boolean_case (agent test_array_shallow_copy_1)
			add_boolean_case (agent test_array_shallow_copy_2)
			add_boolean_case (agent test_array_deep_copy_1)
			add_boolean_case (agent test_array_deep_copy_2)

			show_browser
			run_espec
		end

feature -- Misc test
	test_array_ref_copy: BOOLEAN
		local
			imp, old_imp: ARRAY[STRING]
		do
			comment("Test of a reference copy.")
			create {ARRAY[STRING]} imp.make_empty
			imp.force ("Alan", 1)
			imp.force ("Mark", 2)
			imp.force ("Tom", 3)
			Result :=
				imp.count = 3 and imp[1] ~ "Alan" and imp[2] ~ "Mark" and imp[3] ~ "Tom"
			check Result end

			old_imp := imp
			-- Result is assigned to true because
			-- address of imp is stored into old_imp
			Result := old_imp = imp
			check Result end

			imp[2] := "Jim"
			-- The across expression is trivially true,
			-- because imp and old_imp refer to the same object.
			Result :=
				across
					1 |..| imp.count as j
				all
					imp [j.item] ~ old_imp [j.item]
				end
		end

	test_array_shallow_copy_1: BOOLEAN
		local
			imp, old_imp: ARRAY[STRING]
		do
			comment("Test of a shallow copy with 1st-level change.")
			create {ARRAY[STRING]} imp.make_empty
			imp.force ("Alan", 1)
			imp.force ("Mark", 2)
			imp.force ("Tom", 3)
			Result :=
				imp.count = 3 and imp[1] ~ "Alan" and imp[2] ~ "Mark" and imp[3] ~ "Tom"
			check Result end

			old_imp := imp.twin
			-- Result is assigned to FALSE because
			-- address of a new array is stored into old_imp
			Result := old_imp = imp
			check not Result end

			imp[2] := "Jim"
			-- The across expression is now false,
			-- because imp and old_imp refer to different array structures:
			-- old_imp referes to the array structure before the change: <<"Alan", "Mark", "Tom">>
			-- imp referes to the array structure after the change: <<"Alan", "Jim", "Tom">>
			Result :=
				across
					1 |..| imp.count as j
				all
					imp [j.item] ~ old_imp [j.item]
				end
			check not Result end


			-- Instead, we can say that except for the string at index 2 being assigned,
			-- all other strings are the same between two arrays.
			Result :=
				across
					1 |..| imp.count as j
				all
					j.item /= 2 implies imp [j.item] ~ old_imp [j.item]
				end
			check Result end
		end

	test_array_shallow_copy_2: BOOLEAN
		local
			imp, old_imp: ARRAY[STRING]
		do
			comment("Test of a shallow copy with 2nd-level change.")
			create {ARRAY[STRING]} imp.make_empty
			imp.force ("Alan", 1)
			imp.force ("Mark", 2)
			imp.force ("Tom", 3)
			Result :=
				imp.count = 3 and imp[1] ~ "Alan" and imp[2] ~ "Mark" and imp[3] ~ "Tom"
			check Result end

			old_imp := imp.twin
			-- Result is assigned to FALSE because
			-- address of a new array is stored into old_imp
			Result := old_imp = imp
			check not Result end

			imp[2].append ("***")
			-- The across expression is now true,
			-- because imp and old_imp, even though referring to different array structures,
			-- actually refer to the same STRING objects at the 2nd level.
			Result :=
				across
					1 |..| imp.count as j
				all
					imp [j.item] ~ old_imp [j.item]
				end
			check Result end
		end

	test_array_deep_copy_1: BOOLEAN
		local
			imp, old_imp: ARRAY[STRING]
		do
			comment("Test of a deep copy with 1st-level change.")
			create {ARRAY[STRING]} imp.make_empty
			imp.force ("Alan", 1)
			imp.force ("Mark", 2)
			imp.force ("Tom", 3)
			Result :=
				imp.count = 3 and imp[1] ~ "Alan" and imp[2] ~ "Mark" and imp[3] ~ "Tom"
			check Result end

			old_imp := imp.deep_twin
			-- Result is assigned to FALSE because
			-- address of a new array is stored into old_imp
			Result := old_imp = imp
			check not Result end

			imp[2] := "Jim"
			-- The across expression is now false,
			-- because imp and old_imp refer to different array structures
			Result :=
				across
					1 |..| imp.count as j
				all
					imp [j.item] ~ old_imp [j.item]
				end
			check not Result end


			-- Instead, we can say that except for the string at index 2 being assigned,
			-- all other strings are the same between two arrays.
			Result :=
				across
					1 |..| imp.count as j
				all
					j.item /= 2 implies imp [j.item] ~ old_imp [j.item]
				end
			check Result end
		end

	test_array_deep_copy_2: BOOLEAN
		local
			imp, old_imp: ARRAY[STRING]
		do
			comment("Test of a deep copy with 2nd-level change.")
			create {ARRAY[STRING]} imp.make_empty
			imp.force ("Alan", 1)
			imp.force ("Mark", 2)
			imp.force ("Tom", 3)
			Result :=
				imp.count = 3 and imp[1] ~ "Alan" and imp[2] ~ "Mark" and imp[3] ~ "Tom"
			check Result end

			old_imp := imp.deep_twin
			-- Result is assigned to FALSE because
			-- address of a new array is stored into old_imp
			Result := old_imp = imp
			check not Result end

			imp[2].append ("***")
			-- The across expression is now false,
			-- because imp and old_imp, while referring to different array structures,
			-- also refer to different STRING objects at the 2nd level.
			Result :=
				across
					1 |..| imp.count as j
				all
					imp [j.item] ~ old_imp [j.item]
				end
			check not Result end

			-- Instead, we can say that except for the string at index 2 being assigned,
			-- all other strings are the same between two arrays.
			Result :=
				across
					1 |..| imp.count as j
				all
					j.item /= 2 implies imp [j.item] ~ old_imp [j.item]
				end
			check Result end
		end

end
