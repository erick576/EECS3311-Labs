note
	description: "Example test cases."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE_TESTS

inherit
	TEST_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			env_empty

			add_splay_rotate_tests
			add_splay_splay_tests
			add_splay_search_tests
			add_splay_insert_tests
			add_splay_delete_tests
		end

feature -- rotate

	add_splay_rotate_tests
		do
			add_boolean_case (agent splay_rotate1)
			add_boolean_case (agent splay_rotate2)
		end

	splay_rotate1: BOOLEAN
		do
			comment ("splay_rotate1: env_empty, insert two, rotate from node 2")

			--          2
			--         /
			--        1

			env_empty

			bst_int_int.insert (1, 1)
			bst_int_int.insert (2, 2)

			Result :=
				bst_int_int.root.key = 2
				and
				bst_int_int.root.left = bst_int_int.root.tree_search (1)

			check Result end

			bst_int_int.rotate (bst_int_int.nodes[1])

			--          1
			--           \
			--            2

			Result :=
				bst_int_int.root.key = 1
				and
				bst_int_int.root.right = bst_int_int.root.tree_search (2)
		end

	splay_rotate2: BOOLEAN
		local
			l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("splay_rotate2: env_empty, insert nine, with many rotations")

			--          4
			--         / \
			--        2    7
			--       / \  / \
			--      1   3 6  8
			--            /   \
			--           5    9

			env_empty

			bst_int_int.insert (5, 5)
			bst_int_int.insert (9, 9)
			bst_int_int.insert (1, 1)
			bst_int_int.insert (3, 3)
			bst_int_int.insert (6, 6)
			bst_int_int.insert (8, 8)
			bst_int_int.insert (2, 2)
			bst_int_int.insert (7, 7)
			bst_int_int.insert (4, 4)

			create l2_1.make_internal (1, 1)
			create l2_2.make_internal (2, 2)
			create l2_3.make_internal (3, 3)
			create l2_4.make_internal (4, 4)
			create l2_5.make_internal (5, 5)
			create l2_6.make_internal (6, 6)
			create l2_7.make_internal (7, 7)
			create l2_8.make_internal (8, 8)
			create l2_9.make_internal (9, 9)

			l2_6.insert_left (l2_5)
			l2_7.insert_left (l2_6)

			l2_8.insert_right (l2_9)
			l2_7.insert_right (l2_8)

			l2_2.insert_left (l2_1)
			l2_2.insert_right (l2_3)

			l2_4.insert_right (l2_7)
			l2_4.insert_left (l2_2)

			Result :=
				bst_int_int.root.is_same_tree (l2_4)
		end

feature -- splay

	add_splay_splay_tests
		do
			add_boolean_case(agent splay_splay1)
			add_boolean_case(agent splay_splay2)
		end

	splay_splay1: BOOLEAN
		do
			comment ("splay_splay1: splay, zig-zig")
			env_empty

			bst_int_int.insert (1, 1)
			bst_int_int.insert (2, 2)
			bst_int_int.insert (3, 3)

			bst_int_int.splay (bst_int_int.nodes[1])

			Result := bst_int_int.root = bst_int_int.nodes[1]
		end

	splay_splay2: BOOLEAN
		local
			l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("splay_splay2: env_empty, insert 9 nodes, splay 1, tree structure")

			--          4
			--         / \
			--        2    7
			--       / \  / \
			--      1   3 6  8
			--            /   \
			--           5    9

			env_empty

			bst_int_int.insert (5, 5)
			bst_int_int.insert (9, 9)
			bst_int_int.insert (1, 1)
			bst_int_int.insert (3, 3)
			bst_int_int.insert (6, 6)
			bst_int_int.insert (8, 8)
			bst_int_int.insert (2, 2)
			bst_int_int.insert (7, 7)
			bst_int_int.insert (4, 4)

			bst_int_int.splay (bst_int_int.nodes[1])

			--		  1	
			--		   \
			--          2
			--           \
			--            4
			--           /  \
			--          3    7
			--    		    / \
			--    		   6   8
			--			  /		\
			--			 5		 9

			create l2_1.make_internal (1, 1)
			create l2_2.make_internal (2, 2)
			create l2_3.make_internal (3, 3)
			create l2_4.make_internal (4, 4)
			create l2_5.make_internal (5, 5)
			create l2_6.make_internal (6, 6)
			create l2_7.make_internal (7, 7)
			create l2_8.make_internal (8, 8)
			create l2_9.make_internal (9, 9)

			l2_8.insert_right (l2_9)
			l2_6.insert_left (l2_5)

			l2_7.insert_left (l2_6)
			l2_7.insert_right (l2_8)

			l2_4.insert_right (l2_7)
			l2_4.insert_left (l2_3)

			l2_2.insert_right (l2_4)
			l2_1.insert_right (l2_2)

			Result :=
				bst_int_int.root.is_same_tree (l2_1)
		end


feature -- search

	add_splay_search_tests
		do
			add_boolean_case (agent splay_search1)
			add_boolean_case (agent splay_search2)
			add_boolean_case (agent splay_search3)
		end

	splay_search1: BOOLEAN
		local
			l_search_result: STRING
		do
			comment ("splay_search1: env_root_insert_str_str, search 'g'")

			env_root_insert_str_str

			l_search_result := bst_str_str.search("g")

			Result := l_search_result ~ "g"

		end

	splay_search2: BOOLEAN
		local
			l_search_result: INTEGER
		do
			comment ("splay_search2: env_root_insert_int_int, search '5'")

			env_root_insert_int_int

			l_search_result := bst_int_int.search(5)

			Result := l_search_result ~ 5

		end

	splay_search3: BOOLEAN
		local
			l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			l_search_result: INTEGER
		do
			comment ("splay_search1: env_empty, insert 9 nodes, search node 1, tree structure")

			--          4
			--         / \
			--        2    7
			--       / \  / \
			--      1   3 6  8
			--            /   \
			--           5    9

			env_empty

			bst_int_int.insert (5, 5)
			bst_int_int.insert (9, 9)
			bst_int_int.insert (1, 1)
			bst_int_int.insert (3, 3)
			bst_int_int.insert (6, 6)
			bst_int_int.insert (8, 8)
			bst_int_int.insert (2, 2)
			bst_int_int.insert (7, 7)
			bst_int_int.insert (4, 4)

			l_search_result :=	bst_int_int.search (1)

			--		  1	
			--		   \
			--          2
			--           \
			--            4
			--           /  \
			--          3    7
			--    		    / \
			--    		   6   8
			--			  /		\
			--			 5		 9

			create l2_1.make_internal (1, 1)
			create l2_2.make_internal (2, 2)
			create l2_3.make_internal (3, 3)
			create l2_4.make_internal (4, 4)
			create l2_5.make_internal (5, 5)
			create l2_6.make_internal (6, 6)
			create l2_7.make_internal (7, 7)
			create l2_8.make_internal (8, 8)
			create l2_9.make_internal (9, 9)

			l2_8.insert_right (l2_9)
			l2_6.insert_left (l2_5)

			l2_7.insert_left (l2_6)
			l2_7.insert_right (l2_8)

			l2_4.insert_right (l2_7)
			l2_4.insert_left (l2_3)

			l2_2.insert_right (l2_4)
			l2_1.insert_right (l2_2)

			Result :=
				bst_int_int.root.is_same_tree (l2_1) and l_search_result = 1
		end

feature -- insert

	add_splay_insert_tests
		do
			add_boolean_case (agent splay_insert1)
		end

	splay_insert1: BOOLEAN
		local
		do
			comment ("splay_insert1: env_empty, insert 1, check the root's key")

			env_empty

			bst_int_int.insert(1, 1)

			Result :=
				bst_int_int.root.key ~ 1
		end

feature -- delete

	add_splay_delete_tests
		do
			add_boolean_case (agent splay_delete1)
			add_boolean_case (agent splay_delete2)
			add_boolean_case (agent splay_delete3)
			add_boolean_case (agent splay_delete4)
			add_boolean_case (agent splay_delete5)
			add_boolean_case (agent splay_delete6)
			add_boolean_case (agent splay_delete7)
			add_boolean_case (agent splay_delete8)
			add_boolean_case (agent splay_delete9)
			add_boolean_case (agent splay_delete10)
			add_boolean_case (agent splay_delete11)
		end

	splay_delete1: BOOLEAN
		local
		do
			comment ("splay_delete1: env_empty, insert 1, delete 1, check its count")

			env_empty

			bst_int_int.insert (1, 1)

			bst_int_int.delete (1)

			Result :=
				bst_int_int.count = 0

		end

		splay_delete2: BOOLEAN
			local
			do
				comment ("splay_delete2: env_empty, insert 1 & 2, delete 1, check its count")

				env_empty

				bst_int_int.insert (1, 1)
				bst_int_int.insert (2, 2)

				bst_int_int.delete (1)

				Result :=
					bst_int_int.count = 1

			end

		splay_delete3: BOOLEAN
			local
				l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete3: env_empty, insert 9 nodes, delete node 1, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (1)

				--          2
				--           \
				--            4
				--           /  \
				--          3    7
				--    		    / \
				--    		   6   8
				--			  /		\
				--			 5		 9

				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_8.insert_right (l2_9)
				l2_6.insert_left (l2_5)

				l2_7.insert_left (l2_6)
				l2_7.insert_right (l2_8)

				l2_4.insert_right (l2_7)
				l2_4.insert_left (l2_3)

				l2_2.insert_right (l2_4)

				Result :=
					bst_int_int.root.is_same_tree (l2_2)
			end

		splay_delete4: BOOLEAN
			local
				l2_1, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete4: env_empty, insert 9 nodes, delete node 2, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (2)

				--          1
				--           \
				--            4
				--           /  \
				--          3    7
				--    		    / \
				--    		   6   8
				--			  /		\
				--			 5		 9

				create l2_1.make_internal (1, 1)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_8.insert_right (l2_9)
				l2_6.insert_left (l2_5)

				l2_7.insert_left (l2_6)
				l2_7.insert_right (l2_8)

				l2_4.insert_right (l2_7)
				l2_4.insert_left (l2_3)

				l2_1.insert_right (l2_4)

				Result :=
					bst_int_int.root.is_same_tree (l2_1)
			end

		splay_delete5: BOOLEAN
			local
				l2_1, l2_2, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete5: env_empty, insert 9 nodes, delete node 3, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (3)

				--          2
				--         / \
				--        1   4
				--              \
				--               7
				--    		    / \
				--    		   6   8
				--			  /		\
				--			 5		 9

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_8.insert_right (l2_9)
				l2_6.insert_left (l2_5)

				l2_7.insert_left (l2_6)
				l2_7.insert_right (l2_8)

				l2_4.insert_right (l2_7)

				l2_2.insert_right (l2_4)
				l2_2.insert_left (l2_1)

				Result :=
					bst_int_int.root.is_same_tree (l2_2)
			end

		splay_delete6: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_5, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete6: env_empty, insert 9 nodes, delete node 4, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (4)

				--          3
				--         / \
				--        2    7
				--       /    / \
				--      1    6   8
				--     		/     \
				--    	   5       9

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_8.insert_right (l2_9)
				l2_6.insert_left (l2_5)

				l2_7.insert_left (l2_6)
				l2_7.insert_right (l2_8)

				l2_2.insert_left (l2_1)

				l2_3.insert_right (l2_7)
				l2_3.insert_left (l2_2)

				Result :=
					bst_int_int.root.is_same_tree (l2_3)
			end

		splay_delete7: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_4, l2_6, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete7: env_empty, insert 9 nodes, delete node 5, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (5)

				--          4
				--         / \
				--        2   6
				--       / \   \
				--      1   3   7
				--    		     \
				--    		      8
				--			  	   \
				--			 		9

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_8.insert_right (l2_9)
				l2_7.insert_right (l2_8)
				l2_6.insert_right (l2_7)

				l2_2.insert_right (l2_3)
				l2_2.insert_left (l2_1)

				l2_4.insert_left (l2_2)
				l2_4.insert_right (l2_6)

				Result :=
					bst_int_int.root.is_same_tree (l2_4)
			end

		splay_delete8: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_4, l2_5, l2_7, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete8: env_empty, insert 9 nodes, delete node 6, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (6)

				--          5
				--         / \
				--        4    7
				--       /      \
				--      2        8
				--     / \		  \
				--    1   3		   9

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_2.insert_left (l2_1)
				l2_2.insert_right (l2_3)

				l2_4.insert_left (l2_2)

				l2_8.insert_right (l2_9)
				l2_7.insert_right (l2_8)

				l2_5.insert_left (l2_4)
				l2_5.insert_right (l2_7)

				Result :=
					bst_int_int.root.is_same_tree (l2_5)
			end

		splay_delete9: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_8, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete9: env_empty, insert 9 nodes, delete node 7, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (7)

				--          6
				--         / \
				--        4    8
				--       / \    \
				--      2   5    9
				--     / \
				--    1   3

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_8.make_internal (8, 8)
				create l2_9.make_internal (9, 9)

				l2_2.insert_left (l2_1)
				l2_2.insert_right (l2_3)

				l2_4.insert_left (l2_2)
				l2_4.insert_right (l2_5)

				l2_8.insert_right (l2_9)

				l2_6.insert_right (l2_8)
				l2_6.insert_left (l2_4)

				Result :=
					bst_int_int.root.is_same_tree (l2_6)
			end

		splay_delete10: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_9: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete10: env_empty, insert 9 nodes, delete node 8, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (8)

				--          7
				--         / \
				--        4    9
				--       /  \
				--      2    6
				--     / \  /
				--    1   3 5

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_9.make_internal (9, 9)

				l2_2.insert_left (l2_1)
				l2_2.insert_right (l2_3)

				l2_6.insert_left (l2_5)

				l2_4.insert_right (l2_6)
				l2_4.insert_left (l2_2)

				l2_7.insert_right (l2_9)
				l2_7.insert_left (l2_4)

				Result :=
					bst_int_int.root.is_same_tree (l2_7)
			end

		splay_delete11: BOOLEAN
			local
				l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8: TREE_NODE[INTEGER, INTEGER]
			do
				comment ("splay_delete11: env_empty, insert 9 nodes, delete node 9, tree structure")

				--          4
				--         / \
				--        2    7
				--       / \  / \
				--      1   3 6  8
				--            /   \
				--           5    9

				env_empty

				bst_int_int.insert (5, 5)
				bst_int_int.insert (9, 9)
				bst_int_int.insert (1, 1)
				bst_int_int.insert (3, 3)
				bst_int_int.insert (6, 6)
				bst_int_int.insert (8, 8)
				bst_int_int.insert (2, 2)
				bst_int_int.insert (7, 7)
				bst_int_int.insert (4, 4)

				bst_int_int.delete (9)

				--          4
				--         / \
				--        2    8
				--       / \   /
				--      1   3 7
				--     		 /
				--    		6
				--		   /
				--		  5

				create l2_1.make_internal (1, 1)
				create l2_2.make_internal (2, 2)
				create l2_3.make_internal (3, 3)
				create l2_4.make_internal (4, 4)
				create l2_5.make_internal (5, 5)
				create l2_6.make_internal (6, 6)
				create l2_7.make_internal (7, 7)
				create l2_8.make_internal (8, 8)

				l2_6.insert_left (l2_5)
				l2_7.insert_left (l2_6)
				l2_8.insert_left (l2_7)

				l2_2.insert_left (l2_1)
				l2_2.insert_right (l2_3)

				l2_4.insert_right (l2_8)
				l2_4.insert_left (l2_2)

				Result :=
					bst_int_int.root.is_same_tree (l2_4)
			end
end
