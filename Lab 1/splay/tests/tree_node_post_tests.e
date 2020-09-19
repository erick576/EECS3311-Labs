note
	description: "Summary description for {TREE_NODE_POST_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE_POST_TESTS

inherit
	TEST_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			env_empty

			add_no_parent__tests
			add_left_is_external_tests
			add_left_is_assigned
			add_keep_left_parent_reference
			add_right_is_external
			add_right_is_assigned
			add_keep_right_parent_reference
			add_correct_result
			add_left_external_means_current_is_minimum
			add_result_is_minimum_in_this_subtree
			add_right_external_means_current_is_maximum
			add_result_is_maximum_in_this_subtree
			add_case_of_key_found
			add_case_of_key_not_found
			add_correct_search_result
			add_inorder_means_result_is_sorted_incrementally
		end

feature -- add_no_parent__tests

	add_no_parent__tests
		do
			add_violation_case_with_tag ("no_parent", agent tn_no_parent)
		end

	tn_no_parent
		local
			tn : TREE_NODE_VIOLATING_NO_PARENT[INTEGER, INTEGER]
		do
			comment ("tn_no_parent: POSTCONDITION, no_parent")
			create tn.make_external
		end

feature -- add_left_is_external_tests

	add_left_is_external_tests
		do
			add_violation_case_with_tag ("left_is_external", agent tn_left_is_external_test)
		end

	tn_left_is_external_test
		local
			tn : TREE_NODE_VIOLATING_LEFT_IS_EXTERNAL[INTEGER, INTEGER]
		do
			comment ("tn_left_is_external_test: POSTCONDITION, left_is_external")
			create tn.make_internal(1, 2)
		end

feature -- add_left_is_assigned

	add_left_is_assigned
		do
			add_violation_case_with_tag ("left_is_assigned", agent tn_left_is_assigned)
		end

	tn_left_is_assigned
		local
			tn : TREE_NODE_VIOLATING_LEFT_IS_ASSIGNED[INTEGER, INTEGER]
			tn_insert : TREE_NODE_VIOLATING_LEFT_IS_ASSIGNED[INTEGER, INTEGER]
		do
			comment ("tn_left_is_assigned: POSTCONDITION, left_is_assigned")
			create tn.make_internal (2, 2)
			create tn_insert.make_internal (1, 1)
			tn.insert_left (tn_insert)
		end

feature -- add_keep_left_parent_reference

	add_keep_left_parent_reference
		do
			add_violation_case_with_tag ("keep_left_parent_reference", agent tn_keep_left_parent_reference)
		end

	tn_keep_left_parent_reference
		local
			tn : TREE_NODE_VIOLATING_KEEP_LEFT_PARENT_REFERENCE[INTEGER, INTEGER]
			tn_insert : TREE_NODE_VIOLATING_KEEP_LEFT_PARENT_REFERENCE[INTEGER, INTEGER]
		do
			comment ("tn_keep_left_parent_reference: POSTCONDITION, keep_left_parent_reference")
			create tn.make_internal (2, 2)
			create tn_insert.make_internal (1, 1)
			tn.insert_left (tn_insert)
		end

feature -- add_right_is_external

	add_right_is_external
		do
			add_violation_case_with_tag ("right_is_external", agent tn_right_is_external)
		end

	tn_right_is_external
		local
			tn : TREE_NODE_VIOLATING_RIGHT_IS_EXTERNAL[INTEGER, INTEGER]
		do
			comment ("tn_right_is_external: POSTCONDITION, right_is_external")
			create tn.make_internal(1, 2)
		end

feature -- add_right_is_assigned

	add_right_is_assigned
		do
			add_violation_case_with_tag ("right_is_assigned", agent tn_right_is_assigned)
		end

	tn_right_is_assigned
		local
			tn : TREE_NODE_VIOLATING_RIGHT_IS_ASSIGNED[INTEGER, INTEGER]
			tn_insert : TREE_NODE_VIOLATING_RIGHT_IS_ASSIGNED[INTEGER, INTEGER]
		do
			comment ("tn_right_is_assigned: POSTCONDITION, right_is_assigned")
			create tn.make_internal (1, 1)
			create tn_insert.make_internal (2, 2)
			tn.insert_right (tn_insert)
		end

feature -- add_keep_right_parent_reference

	add_keep_right_parent_reference
		do
			add_violation_case_with_tag ("keep_right_parent_reference", agent tn_keep_right_parent_reference1)
		end

	tn_keep_right_parent_reference1
		local
			tn : TREE_NODE_VIOLATING_KEEP_RIGHT_PARENT_REFERENCE[INTEGER, INTEGER]
			tn_insert : TREE_NODE_VIOLATING_KEEP_RIGHT_PARENT_REFERENCE[INTEGER, INTEGER]
		do
			comment ("tn_keep_right_parent_reference: POSTCONDITION, keep_right_parent_reference")
			create tn.make_internal (1, 1)
			create tn_insert.make_internal (2, 2)
			tn.insert_right (tn_insert)
		end


feature -- add_correct_result

	add_correct_result
		do
			add_violation_case_with_tag ("correct_result", agent tn_correct_result)
		end

	tn_correct_result
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_CORRECT_RESULT[INTEGER, INTEGER]
			ans : INTEGER
		do
			comment ("tn_correct_result: POSTCONDITION, correct_result")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.count
		end

feature -- add_left_external_means_current_is_minimum

	add_left_external_means_current_is_minimum
		do
			add_violation_case_with_tag ("left_external_means_current_is_minimum", agent tn_left_external_means_current_is_minimum)
		end

	tn_left_external_means_current_is_minimum
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_LEFT_EXTERNAL_MEANS_CURRENT_IS_MINIMUM[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_left_external_means_current_is_minimum: POSTCONDITION, left_external_means_current_is_minimum")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.min_node
		end

feature -- add_result_is_minimum_in_this_subtree

	add_result_is_minimum_in_this_subtree
		do
			add_violation_case_with_tag ("result_is_minimum_in_this_subtree", agent tn_result_is_minimum_in_this_subtree)
		end

	tn_result_is_minimum_in_this_subtree
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_RESULT_IS_MINIMUM_IN_THIS_SUBTREE[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_result_is_minimum_in_this_subtree: POSTCONDITION, result_is_minimum_in_this_subtree")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.min_node
		end


feature -- add_right_external_means_current_is_maximum

	add_right_external_means_current_is_maximum
		do
			add_violation_case_with_tag ("right_external_means_current_is_maximum", agent tn_right_external_means_current_is_maximum)
		end

	tn_right_external_means_current_is_maximum
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_RIGHT_EXTERNAL_MEANS_CURRENT_IS_MAXIMUM[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_right_external_means_current_is_maximum: POSTCONDITION, right_external_means_current_is_maximum")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.max_node
		end

feature -- add_result_is_maximum_in_this_subtree

	add_result_is_maximum_in_this_subtree
		do
			add_violation_case_with_tag ("result_is_maximum_in_this_subtree", agent tn_result_is_maximum_in_this_subtree)
		end

	tn_result_is_maximum_in_this_subtree
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_RESULT_IS_MAXIMUM_IN_THIS_SUBTREE[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_result_is_maximum_in_this_subtree: POSTCONDITION, result_is_maximum_in_this_subtree")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.max_node
		end

feature -- add_case_of_key_found

	add_case_of_key_found
		do
			add_violation_case_with_tag ("case_of_key_found", agent tn_case_of_key_found)
		end

	tn_case_of_key_found
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_CASE_OF_KEY_FOUND[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_case_of_key_found: POSTCONDITION, case_of_key_found")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.tree_search(1)
		end

feature -- add_case_of_key_not_found

	add_case_of_key_not_found
		do
			add_violation_case_with_tag ("case_of_key_not_found", agent tn_case_of_key_not_found)
		end

	tn_case_of_key_not_found
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_CASE_OF_KEY_NOT_FOUND[INTEGER, INTEGER]
			ans : TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_case_of_key_not_found: POSTCONDITION, case_of_key_not_found")


			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.tree_search(10)
		end

feature -- add_correct_search_result

	add_correct_search_result
		do
			add_violation_case_with_tag ("correct_search_result", agent tn_correct_search_result)
		end

	tn_correct_search_result
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_CORRECT_SEARCH_RESULT[INTEGER, INTEGER]
			ans : BOOLEAN
		do
			comment ("tn_correct_search_result: POSTCONDITION, correct_search_result")


			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.has(1)
		end

feature -- add_inorder_means_result_is_sorted_incrementally

	add_inorder_means_result_is_sorted_incrementally
		do
			add_violation_case_with_tag ("inorder_means_result_is_sorted_incrementally", agent tn_inorder_means_result_is_sorted_incrementally)
		end

	tn_inorder_means_result_is_sorted_incrementally
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE_VIOLATING_INORDER_MEANS_RESULT_IS_SORTED_INCREMENTALLY[INTEGER, INTEGER]
			ans : LIST[TREE_NODE[INTEGER, INTEGER]]
		do
			comment ("tn_inorder_means_result_is_sorted_incrementally: POSTCONDITION, inorder_means_result_is_sorted_incrementally")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			ans := l_4.nodes
		end
end
