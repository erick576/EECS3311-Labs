note
	description: "All starter tests."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	STARTER_TESTS

inherit
	TEST_ENVIRONMENT

create
	make

feature
	make
		do
			reset_as_linear_db

			add_boolean_case (agent test_hash_table_retrieval)
			add_boolean_case (agent test_relation_and_tuples)


			add_model_tests

			add_insert_tests
			add_count_tests
			add_search_tests
			add_delete_tests
			add_has_key_tests

			add_override_tests
			add_common_key_db_tests

			add_interval_image_tests

			add_inner_join_tests

-- 			TODO: Uncomment this once you made `DATABASE` iterable.
			add_iterator_tests
		end

feature -- syntax demo

	test_hash_table_retrieval: BOOLEAN
		local
			table: HASH_TABLE[STRING, INTEGER]
			values: LINKED_LIST[STRING]
		do
			comment ("test_hash_table_retrieval: test return value from hash table")

			create table.make (10) -- maximum capacity of 10 entries to begin with
			Result := table.count = 0 and table.is_empty
			check Result end

			table.extend ("value1", 1)
			table.extend ("value2", 2)

			Result := table.count = 2 and table[1] ~ "value1" and table[2] ~ "value2"
			check Result end

			create values.make
			-- Version 1: this line does not compile because
			-- each member of the `values` array is expected to be non-void,
			-- but table[k], from the compiler's point of view, might return void
			-- if k is not an existing key of the has table.

--			values.extend (table[1])

			-- Version 2: assert to the compiler (via a check assertion) that
			-- table[1] and table[2] specifically would return non-void value,
			-- because we are certain that 1 and 2 are existing keys.
			-- Overall a check assertion goes like: check B then S end,
			-- where B is a Boolean expression, and S is a sequene of instructions (assignments, if-statements, loops, etc.).
			check
				-- `attached` is a keyword.
				-- Writing `attached E as VAR` evalues to either true or false.
				-- If `E` is an expression that denotes a non-void (i.e., attached) object, then
				-- let a new local variable `VAR` point to that object.
				-- Otherwise, if `E` is not attached, the expression evalues to false.
				attached table[1] as v1  and attached table[2] as v2
			then
				values.extend (v1)
				values.extend (v2)
			end

			Result := values.count = 2 and values[1] ~ "value1" and values[2] ~ "value2"
		end

	test_relation_and_tuples: BOOLEAN
		local
			rel: REL[INTEGER, STRING]
			domain: SET[INTEGER]
			range: SET[STRING]
			-- pay attention to how we refer to fields `k` and `v` of `tuples`
			tuples: ARRAY[TUPLE[k: INTEGER; v: STRING]]
		do
			comment ("test_relation_and_tuples: test the use of relation and tuples")

 			create rel.make_from_tuple_array (<<[1, "alan"], [2, "mark"], [3, "tom"]>>)
			Result := rel.count = 3 and not rel.is_empty
			check Result end

			-- domain of model function
			create domain.make_from_array (<<1, 2, 3>>)
			Result := rel.domain ~ domain
			check Result end

			-- range of model function
			create range.make_from_array (<<"alan", "mark", "tom">>)
			Result := rel.range ~ range
			check Result end

			-- applications of model function
			Result :=
						rel[1].count = 1 and rel[1].has ("alan") -- relational image (returning a set)
						and
						rel.image (2).count = 1 and rel.image(2).has ("mark") -- relational image using the indexing notation
						and
						rel[3].count = 1 and rel[3].has ("tom")
			check Result end

			-- convert model to an array of tuples
			create tuples.make_empty
			across
				rel is pair
			loop
				tuples.force ([pair.first, pair.second],
									tuples.count + 1)
			end
			Result :=
								tuples.count = 3
						and	tuples[1].k ~ 1 and tuples[1].v ~ "alan"
						and	tuples[2].k ~ 2 and tuples[2].v ~ "mark"
						and	tuples[3].k ~ 3 and tuples[3].v ~ "tom"
		end

feature -- model

	add_model_tests
		do
			add_boolean_case (agent dbt_model1)
			add_boolean_case (agent dbt_model3)
			add_boolean_case (agent dbt_model5)
			add_boolean_case (agent dbt_model7)
		end

	dbt_model7: BOOLEAN
		local
		do
			comment ("dbt_model7: int LINEAR_DB, check if its model maps all the keys and values")
			reset_as_linear_db

			env_int_int (db_int_int)

			if
				attached {LINEAR_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				Result :=
					across
						a_db.model is i_pair
					all
						attached i_pair.first as a_key and then
						attached i_pair.second as a_value
						and then
						a_db.values [a_key] ~ a_value
					end
			end

		end

	dbt_model5: BOOLEAN
		local
		do
			comment ("dbt_model5: int TREE_DB, check if its model maps all the keys and values")
			reset_as_tree_db

			env_int_int (db_int_int)

			if
				attached {TREE_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				Result :=
					across
						a_db.model is i_pair
					all
						attached i_pair.first as a_key and then
						attached i_pair.second as a_value
						and then
						a_db.search (a_key) ~ a_value
					end
			end
		end

	dbt_model3: BOOLEAN
		local
		do
			comment ("dbt_model3: int LINEAR_DB, check if its keys and its values map to a model")
			reset_as_linear_db

			env_int_int (db_int_int)

			if
				attached {LINEAR_DB[INTEGER, INTEGER]} db_int_int as a_db
			then

				Result :=
					across
						a_db.keys is i_key
					all
						attached a_db.model.domain_restricted_by (i_key).range as a_range
						and then
						a_range.count = 1
						and then
						a_range.has (a_db.values[i_key])
					end
			end

		end

	dbt_model1: BOOLEAN
		local
			l_bst: BALANCED_BST[INTEGER, INTEGER]
			l_list: LIST[TREE_NODE[INTEGER, INTEGER]]
		do
			comment ("dbt_model1: int TREE_DB, check if its keys and its values map to a model")
			reset_as_tree_db

			env_int_int (db_int_int)

			if
				attached {TREE_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				l_bst := a_db.bst
				l_list := l_bst.nodes

				Result :=
					across
						l_list is l_node
					all
						(
							attached l_node.key as a_key and then
							attached l_node.value as a_value
						)
						implies
						(
							attached a_db.model.domain_restricted_by(a_key).range as a_range
							and then
							a_range.count = 1
							and then
							a_range.has(a_value)
						)
					end
			end



		end

feature -- insert

	add_insert_tests
		do
			add_boolean_case (agent dbt_insert1)
			add_boolean_case (agent dbt_insert2)
			add_boolean_case (agent dbt_insert3)
			add_boolean_case (agent dbt_insert4)
		end

	dbt_insert6
	 	local
	 	do
	 		comment ("dbt_insert6: PRECONDITION, no_previous_entry")
			reset_as_linear_db
			db_str_str.insert ("A", "TEST3")
			db_str_str.insert ("A", "TEST2")
	 	end

	dbt_insert5: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert5: insert A, K, E, S, Z, T, I, P, Q, H")
			reset_as_linear_db
			Result := db_str_str.count = 0
			check Result end
			db_str_str.insert ("A", "TEST3")
			Result := db_str_str.count = 1 and db_str_str.search ("A") ~ "TEST3"
			check Result end
			db_str_str.insert ("K", "TEST2")
			Result := db_str_str.count = 2 and db_str_str.search ("K") ~ "TEST2"
			check Result end
			db_str_str.insert ("E", "TEST4")
			Result := db_str_str.count = 3 and db_str_str.search ("E") ~ "TEST4"
			check Result end
			db_str_str.insert ("S", "TEST1")
			Result := db_str_str.count = 4 and db_str_str.search ("S") ~ "TEST1"
			check Result end
			db_str_str.insert ("Z", "TEST5")
			Result := db_str_str.count = 5 and db_str_str.search ("Z") ~ "TEST5"
			check Result end
			db_str_str.insert ("T", "TEST6")
			Result := db_str_str.count = 6 and db_str_str.search ("T") ~ "TEST6"
			check Result end
			db_str_str.insert ("I", "TEST7")
			Result := db_str_str.count = 7 and db_str_str.search ("I") ~ "TEST7"
			check Result end
			db_str_str.insert ("P", "TEST10")
			Result := db_str_str.count = 8 and db_str_str.search ("P") ~ "TEST10"
			check Result end
			db_str_str.insert ("Q", "TEST8")
			Result := db_str_str.count = 9 and db_str_str.search ("Q") ~ "TEST8"
			check Result end
			db_str_str.insert ("H", "TEST9")
			Result := db_str_str.count = 10 and db_str_str.search ("H") ~ "TEST9"

	 	end

	 dbt_insert4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert4: insert 1, 10, 2, 9, 3, 8, 4, 7, 5, 6")
			reset_as_linear_db
			Result := db_int_int.count = 0
			check Result end
			db_int_int.insert (1, 10)
			Result := db_int_int.count = 1 and db_int_int.search (1) ~ 10
			check Result end
			db_int_int.insert (10, 9)
			Result := db_int_int.count = 2 and db_int_int.search (10) ~ 9
			check Result end
			db_int_int.insert (2, 8)
			Result := db_int_int.count = 3 and db_int_int.search (2) ~ 8
			check Result end
			db_int_int.insert (9, 7)
			Result := db_int_int.count = 4 and db_int_int.search (9) ~ 7
			check Result end
			db_int_int.insert (3, 6)
			Result := db_int_int.count = 5 and db_int_int.search (3) ~ 6
			check Result end
			db_int_int.insert (8, 5)
			Result := db_int_int.count = 6 and db_int_int.search (8) ~ 5
			check Result end
			db_int_int.insert (4, 4)
			Result := db_int_int.count = 7 and db_int_int.search (4) ~ 4
			check Result end
			db_int_int.insert (7, 3)
			Result := db_int_int.count = 8 and db_int_int.search (7) ~ 3
			check Result end
			db_int_int.insert (5, 2)
			Result := db_int_int.count = 9 and db_int_int.search (5) ~ 2
			check Result end
			db_int_int.insert (6, 1)
			Result := db_int_int.count = 10 and db_int_int.search (6) ~ 1
	 	end

	 dbt_insert3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert3: insert 1, 2, 3, 4, 5, 6, 7, 8, 9, 10")
			reset_as_linear_db
			Result := db_int_str.count = 0
			check Result end
			db_int_str.insert (1, "TEST3")
			Result := db_int_str.count = 1 and db_int_str.search (1) ~ "TEST3"
			check Result end
			db_int_str.insert (2, "TEST2")
			Result := db_int_str.count = 2 and db_int_str.search (2) ~ "TEST2"
			check Result end
			db_int_str.insert (3, "TEST4")
			Result := db_int_str.count = 3 and db_int_str.search (3) ~ "TEST4"
			check Result end
			db_int_str.insert (4, "TEST1")
			Result := db_int_str.count = 4 and db_int_str.search (4) ~ "TEST1"
			check Result end
			db_int_str.insert (5, "TEST5")
			Result := db_int_str.count = 5 and db_int_str.search (5) ~ "TEST5"
			check Result end
			db_int_str.insert (6, "TEST6")
			Result := db_int_str.count = 6 and db_int_str.search (6) ~ "TEST6"
			check Result end
			db_int_str.insert (7, "TEST7")
			Result := db_int_str.count = 7 and db_int_str.search (7) ~ "TEST7"
			check Result end
			db_int_str.insert (8, "TEST10")
			Result := db_int_str.count = 8 and db_int_str.search (8) ~ "TEST10"
			check Result end
			db_int_str.insert (9, "TEST8")
			Result := db_int_str.count = 9 and db_int_str.search (9) ~ "TEST8"
			check Result end
			db_int_str.insert (10, "TEST9")
			Result := db_int_str.count = 10 and db_int_str.search (10) ~ "TEST9"

	 	end

	 dbt_insert2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert2: insert 1 ~ 3")
			reset_as_linear_db

			db_int_int.insert (1, 1)
			db_int_int.insert (2, 2)
			db_int_int.insert (3, 3)
			Result := db_int_int.count = 3
	 	end

	 dbt_insert1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert1: insert 1")
			reset_as_linear_db

			db_int_int.insert (1, 1)
			Result := db_int_int.count = 1
	 	end

feature -- count

	add_count_tests
		do
			add_boolean_case(agent dbt_count1)
			add_boolean_case(agent dbt_count2)
		end

	dbt_count1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_count1: count, insert 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.count = 10
	 	end

	dbt_count2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_count2: count, insert none")
			reset_as_linear_db

			Result := db_int_int.count = 0
	 	end

feature -- search

	add_search_tests
		do
			add_boolean_case(agent dbt_search1)
			add_boolean_case(agent dbt_search2)
			add_boolean_case(agent dbt_search3)
			add_boolean_case(agent dbt_search4)
		end

	dbt_search2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search2: search 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.search (10) = 10
	 	end

	dbt_search1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search1: search 1")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.search (1) = 1
	 	end

	dbt_search3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search3: search `Z`")
			reset_as_linear_db
			env_str_str (db_str_str)

			Result := db_str_str.search ("Z") = void
	 	end

	dbt_search4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search4: search 11")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.search (11) = 0
	 	end

feature -- delete

	add_delete_tests
		do
			add_boolean_case(agent dbt_delete1)
			add_boolean_case(agent dbt_delete2)
			add_boolean_case(agent dbt_delete3)
			add_boolean_case(agent dbt_delete4)
		end

	dbt_delete2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete2: delete `i`")
			reset_as_linear_db
			env_str_str (db_str_str)
			db_str_str.delete ("i")

			Result := db_str_str.count = 9
	 	end

	dbt_delete1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete1: delete 1")
			reset_as_linear_db
			env_int_int (db_int_int)
			db_int_int.delete (1)

			Result := db_int_int.count = 9
	 	end

	dbt_delete3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete3: all int_int")
			reset_as_linear_db
			Result := db_int_int.count = 0
			check Result end
			db_int_int.insert (1, 10)
			db_int_int.insert (10, 9)
			db_int_int.insert (2, 8)
			db_int_int.insert (9, 7)
			db_int_int.insert (3, 6)
			db_int_int.insert (8, 5)
			db_int_int.insert (4, 4)
			db_int_int.insert (7, 3)
			db_int_int.insert (5, 2)
			db_int_int.insert (6, 1)

			db_int_int.delete (1)
			Result := db_int_int.count = 9 and db_int_int.search (1) ~ 0
			check Result end

			db_int_int.delete (10)
			Result := db_int_int.count = 8 and db_int_int.search (10) ~ 0
			check Result end

			db_int_int.delete (2)
			Result := db_int_int.count = 7 and db_int_int.search (2) ~ 0
			check Result end

			db_int_int.delete (9)
			Result := db_int_int.count = 6 and db_int_int.search (9) ~ 0
			check Result end

			db_int_int.delete (3)
			Result := db_int_int.count = 5 and db_int_int.search (3) ~ 0
			check Result end

			db_int_int.delete (8)
			Result := db_int_int.count = 4 and db_int_int.search (8) ~ 0
			check Result end

			db_int_int.delete (4)
			Result := db_int_int.count = 3 and db_int_int.search (4) ~ 0
			check Result end

			db_int_int.delete (7)
			Result := db_int_int.count = 2 and db_int_int.search (7) ~ 0
			check Result end

			db_int_int.delete (5)
			Result := db_int_int.count = 1 and db_int_int.search (5) ~ 0
			check Result end

			db_int_int.delete (6)
			Result := db_int_int.count = 0 and db_int_int.search (6) ~ 0
	 	end

	dbt_delete4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete4: delete all str_str")
			reset_as_linear_db
			db_str_str.insert ("A", "TEST3")
			db_str_str.insert ("K", "TEST2")
			db_str_str.insert ("E", "TEST4")
			db_str_str.insert ("S", "TEST1")
			db_str_str.insert ("Z", "TEST5")
			db_str_str.insert ("T", "TEST6")
			db_str_str.insert ("I", "TEST7")
			db_str_str.insert ("P", "TEST10")
			db_str_str.insert ("Q", "TEST8")
			db_str_str.insert ("H", "TEST9")

			db_str_str.delete ("A")
			Result := db_str_str.count = 9 and db_str_str.search ("A") ~ void
			check Result end

			db_str_str.delete ("K")
			Result := db_str_str.count = 8 and db_str_str.search ("K") ~ void
			check Result end

			db_str_str.delete ("E")
			Result := db_str_str.count = 7 and db_str_str.search ("E") ~ void
			check Result end

			db_str_str.delete ("S")
			Result := db_str_str.count = 6 and db_str_str.search ("S") ~ void
			check Result end

			db_str_str.delete ("Z")
			Result := db_str_str.count = 5 and db_str_str.search ("Z") ~ void
			check Result end

			db_str_str.delete ("T")
			Result := db_str_str.count = 4 and db_str_str.search ("T") ~ void
			check Result end

			db_str_str.delete ("I")
			Result := db_str_str.count = 3 and db_str_str.search ("I") ~ void
			check Result end

			db_str_str.delete ("P")
			Result := db_str_str.count = 2 and db_str_str.search ("P") ~ void
			check Result end

			db_str_str.delete ("Q")
			Result := db_str_str.count = 1 and db_str_str.search ("Q") ~ void
			check Result end

			db_str_str.delete ("H")
			Result := db_str_str.count = 0 and db_str_str.search ("H") ~ void
	 	end

feature -- has_key

	add_has_key_tests
		do
			add_boolean_case(agent dbt_has_key1)
			add_boolean_case(agent dbt_has_key2)
			add_boolean_case(agent dbt_has_key3)
			add_boolean_case(agent dbt_has_key4)
		end

	dbt_has_key2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key2: has_key `i`")
			reset_as_linear_db
			env_str_str (db_str_str)
			Result := db_str_str.has_key ("i")
	 	end

	dbt_has_key1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key1: has_key 1")
			reset_as_linear_db
			env_int_int (db_int_int)
			Result := db_int_int.has_key (1)
	 	end

	dbt_has_key3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key2: has_key `Z`")
			reset_as_linear_db
			env_str_str (db_str_str)
			Result := not db_str_str.has_key ("z")
	 	end

	dbt_has_key4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key4: has_key 11")
			reset_as_linear_db
			env_int_int (db_int_int)
			Result := not db_int_int.has_key (11)
	 	end


feature -- override

	add_override_tests
		do
			add_boolean_case(agent dbt_override1)
			add_boolean_case(agent dbt_override2)
			add_boolean_case(agent dbt_override3)
			add_boolean_case(agent dbt_override4)
		end

	dbt_override4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override4: override (`Z`, `ZZZ`)")
	 		reset_as_linear_db
			env_str_str (db_str_str)

			db_str_str.override ("Z", "ZZZ")
			Result := db_str_str.search ("Z") ~ "ZZZ"
	 	end

	dbt_override3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override3: override (`A`, `AAA`)")
	 		reset_as_linear_db
			env_str_str (db_str_str)
			db_str_str.override ("a", "AAA")
			Result := db_str_str.search ("a") ~ "AAA"
	 	end

	dbt_override2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override2: override (11, 999)")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.override (11, 999)
			Result := db_int_int.search (11) = 999
	 	end

	dbt_override1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override1: override (1, 372)")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.override (1, 372)
			Result := db_int_int.search (1) = 372
	 	end

feature -- common_key_db

	add_common_key_db_tests
		do
			add_boolean_case(agent dbt_common_key_db1)
			add_boolean_case(agent dbt_common_key_db2)
			add_boolean_case(agent dbt_common_key_db3)
			add_boolean_case(agent dbt_common_key_db4)
			add_boolean_case(agent dbt_common_key_db5)
		end

	dbt_common_key_db5: BOOLEAN
		local
			l_duplicate_db: like db_str_str
			l_result_db: like db_str_str
		do
			comment ("dbt_common_key_db5: common key db_str_str, db_str_str smaller")
			reset_as_linear_db
			env_str_str (db_str_str)

			l_duplicate_db := db_str_str.deep_twin

			l_duplicate_db.delete ("a")
			l_duplicate_db.delete ("c")
			l_duplicate_db.delete ("e")
			l_duplicate_db.delete ("g")
			l_duplicate_db.delete ("i")

			l_result_db := db_str_str.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 5 and
				l_result_db.search ("b") ~ "b" and
				l_result_db.search ("d") ~ "d" and
				l_result_db.search ("f") ~ "f" and
				l_result_db.search ("h") ~ "h" and
				l_result_db.search ("j") ~ "j" and
				l_result_db.search ("a") = void and
				l_result_db.search ("c") = void and
				l_result_db.search ("e") = void and
				l_result_db.search ("g") = void and
				l_result_db.search ("i") = void
		end

	dbt_common_key_db4: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db4: common key db_int_int, db_int_int none")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			across
				1 |..| db_int_int.count is i
			loop
				db_int_int.delete (i)
			end

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 0
		end

	dbt_common_key_db3: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db3: common key db_int_int, other db smaller")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			l_duplicate_db.delete (1)
			l_duplicate_db.delete (3)
			l_duplicate_db.delete (5)
			l_duplicate_db.delete (7)
			l_duplicate_db.delete (9)

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 5 and
				l_result_db.search (2) = 2 and
				l_result_db.search (4) = 4 and
				l_result_db.search (6) = 6 and
				l_result_db.search (8) = 8 and
				l_result_db.search (10) = 10 and
				l_result_db.search (1) = 0 and
				l_result_db.search (3) = 0 and
				l_result_db.search (5) = 0 and
				l_result_db.search (7) = 0 and
				l_result_db.search (9) = 0
		end

	dbt_common_key_db2: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db2: common key db_int_int, db_int_int smaller")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			db_int_int.delete (1)
			db_int_int.delete (3)
			db_int_int.delete (5)
			db_int_int.delete (7)
			db_int_int.delete (9)

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 5 and
				l_result_db.search (2) = 2 and
				l_result_db.search (4) = 4 and
				l_result_db.search (6) = 6 and
				l_result_db.search (8) = 8 and
				l_result_db.search (10) = 10 and
				l_result_db.search (1) = 0 and
				l_result_db.search (3) = 0 and
				l_result_db.search (5) = 0 and
				l_result_db.search (7) = 0 and
				l_result_db.search (9) = 0
		end


	dbt_common_key_db1: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db1: common key db_int_int clone")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin
			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 10 and
				l_result_db.search (1) = 1 and
				l_result_db.search (2) = 2 and
				l_result_db.search (3) = 3 and
				l_result_db.search (4) = 4 and
				l_result_db.search (5) = 5 and
				l_result_db.search (6) = 6 and
				l_result_db.search (7) = 7 and
				l_result_db.search (8) = 8 and
				l_result_db.search (9) = 9 and
				l_result_db.search (10) = 10
		end

feature -- interval_image

	add_interval_image_tests
		do
			add_boolean_case(agent dbt_interval_image1)
			add_boolean_case(agent dbt_interval_image2)
			add_boolean_case(agent dbt_interval_image3)
			add_boolean_case(agent dbt_interval_image4)
			add_boolean_case(agent dbt_interval_image5)
		end

	dbt_interval_image3: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image3: env_int_int, [8, 50)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (8, 50)
			Result := l_list.count = 3 and
				l_list.has (8) and
				l_list.has (9) and
				l_list.has (10)
		end

	dbt_interval_image2: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image2: env_int_int, [-5, 3)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (-5, 3)
			Result := l_list.count = 2 and
				l_list.has (1) and
				l_list.has (2)
		end

	dbt_interval_image1: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image1: env_int_int, [3, 7)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (3, 7)
			Result := l_list.count = 4 and
				l_list.has (3) and
				l_list.has (4) and
				l_list.has (5) and
				l_list.has (6) and
				not l_list.has (7)
		end

	dbt_interval_image4: BOOLEAN
		local
			l_list: LIST[STRING]
		do
			comment ("dbt_interval_image4: env_str_str, [a, c)")
			reset_as_linear_db
			env_str_str (db_str_str)

			l_list := db_str_str.interval_image ("a", "c")
			Result := l_list.count = 2 and
				l_list.has ("a") and
				l_list.has ("b") and
				not l_list.has ("c")
		end

	dbt_interval_image5: BOOLEAN
		local
			l_list: LIST[STRING]
		do
			comment ("dbt_interval_image5: env_str_str, [g, z)")
			reset_as_linear_db
			env_str_str (db_str_str)

			l_list := db_str_str.interval_image ("g", "z")
			Result := l_list.count = 4 and
				l_list.has ("g") and
				l_list.has ("h") and
				l_list.has ("i") and
				l_list.has ("j") and
				not l_list.has ("a") and
				not l_list.has ("b") and
				not l_list.has ("c")
		end

feature -- inner_join

	add_inner_join_tests
		do
			add_boolean_case(agent dbt_inner_join1)
			add_boolean_case(agent dbt_inner_join2)
			add_boolean_case(agent dbt_inner_join3)
			add_boolean_case(agent dbt_inner_join4)
		end

	dbt_inner_join4: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join4: int_int, and int_str, no int_str entries")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 0
		end

	dbt_inner_join3: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join3: int_int, and int_str, int_int only odd keys")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.delete (2)
			db_int_int.delete (4)
			db_int_int.delete (6)
			db_int_int.delete (8)
			db_int_int.delete (10)

			db_int_str.insert (1, "a")
			db_int_str.insert (2, "b")
			db_int_str.insert (3, "c")
			db_int_str.insert (4, "d")
			db_int_str.insert (5, "e")
			db_int_str.insert (6, "f")
			db_int_str.insert (7, "g")
			db_int_str.insert (8, "h")
			db_int_str.insert (9, "i")
			db_int_str.insert (10, "j")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 5 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")])
		end

	dbt_inner_join2: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join2: int_int, and int_str, int_str only odd keys")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_str.insert (1, "a")
			db_int_str.insert (3, "c")
			db_int_str.insert (5, "e")
			db_int_str.insert (7, "g")
			db_int_str.insert (9, "i")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 5 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")])
		end

	dbt_inner_join1: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join1: int_int, and int_str")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_str.insert (1, "a")
			db_int_str.insert (2, "b")
			db_int_str.insert (3, "c")
			db_int_str.insert (4, "d")
			db_int_str.insert (5, "e")
			db_int_str.insert (6, "f")
			db_int_str.insert (7, "g")
			db_int_str.insert (8, "h")
			db_int_str.insert (9, "i")
			db_int_str.insert (10, "j")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 10 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (2).has ([2, create {PAIR[INTEGER, STRING]}.make(2, "b")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (4).has ([4, create {PAIR[INTEGER, STRING]}.make(4, "d")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (6).has ([6, create {PAIR[INTEGER, STRING]}.make(6, "f")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (8).has ([8, create {PAIR[INTEGER, STRING]}.make(8, "h")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")]) and
					l_relation.domain_restricted_by (10).has ([10, create {PAIR[INTEGER, STRING]}.make(10, "j")])
		end

-- TODO: Uncomment these tests once you made `DATABASE` iterable.
feature -- iterator

	add_iterator_tests
		do
			add_boolean_case(agent dbt_iterator1)
			add_boolean_case(agent dbt_iterator5)

		end

 	dbt_iterator5: BOOLEAN
		local
			l_list: LIST[TUPLE[INTEGER, INTEGER]]
	 	do
	 		comment ("dbt_iterator5: TREE_DB, int_int, go through 1 ~ 10")
			reset_as_tree_db
			env_int_int (db_int_int)

			create {ARRAYED_LIST[TUPLE[INTEGER, INTEGER]]} l_list.make (db_int_int.count)

			across
				db_int_int is i_item
			loop
				l_list.force (i_item)
			end

			Result :=
				across
					l_list.count |..| 1 is i
				all
					l_list[i][1] ~ i
					and
					l_list[i][2] ~ i
				end

	 	end

 	dbt_iterator1: BOOLEAN
		local
			l_list: LIST[TUPLE[INTEGER, INTEGER]]
	 	do
	 		comment ("dbt_iterator1: LINEAR_DB, int_int, go through 1 ~ 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			create {ARRAYED_LIST[TUPLE[INTEGER, INTEGER]]} l_list.make (db_int_int.count)

			across
				db_int_int is i_item
			loop
				l_list.force (i_item)
			end

			Result :=
				across
					l_list.count |..| 1 is i
				all
					l_list[i][1] ~ i
					and
					l_list[i][2] ~ i
				end

	 	end
end

