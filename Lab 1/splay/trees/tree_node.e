note
	description: "[
		A class representing a tree node in a SPLAY_TREE.
		
		A tree node has a comparable key and a value, and a left child, 
		a right child, and a parent pointers. 
		
		A tree node may be either internal or external. 
		An internal node has two non-void children,
		and an external node has two void children.
		
		A node should always keep track of bidirectional pointer reference.
		(i.e. a child must reference their parent, and parent must 
		refer to the child by its either of left or right child.)
		The left, right, and parent pointers must not be itself.
		(i.e. no circular reference)
		]"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE[K -> COMPARABLE, V -> ANY]
		-- The two variables `K` and `V` above are called type parameters (`K` for search keys and `V` for data values). A client
		-- or user of the `TREE_NODE` class must specify what `K` and `V` are when declaring a variable. As an example, by
		-- writing `node_1: TREE NODE[INTEGER, PERSON]`, the stored keys are integers and values are references of person
		-- objects. As another example, by writing `node_2: TREE NODE[STRING, REAL]`, the stored keys are references
		-- of string objects and values are single point float values.

inherit
	COMPARABLE
		-- A tree node may be compared to another node by their keys
		-- using comparison operators: `~`, `>`, `<`, `<=`, `>=`.
		-- Inheriting `COMPARABLE` requires client(TREE_NODE) to
		-- implement `is_less`.
		undefine
			out
		end

	DEBUG_OUTPUT
		undefine
			is_equal
		redefine
			out
		end

create
	make_internal, make_external
		-- A tree node may be created as an internal node or
		-- an external node.

-- Note. All features marked with `TODO` in the TREE_NODE class are considered as basic.

feature -- Comparable

	is_less alias "<" (other: TREE_NODE[K, V]): BOOLEAN
			-- Does this node have a smaller key than the node `other`?
		do
			-- This implementation is given to you. Do not modify.
			if
				attached key as a_key and
				attached other.key as a_other_key
			then
				Result := a_key < a_other_key
			end
		end

feature {TREE_NODE, ES_TEST} -- Initialization

	make_external
			-- Makes an external (empty) node.
		do
			-- Implementation does nothing. Do not modify.
		ensure
			-- The postconditions `no_left_child`, `no_right_child` are
			-- completed for you. Do not modify.
			no_left_child:
				not attached left
			no_right_child:
				not attached right
			no_parent:
				-- TODO: complete this postcondition.
				not attached parent
		end

	make_internal (p_key: K; p_value: V)
			-- Makes an internal node.
		do
			-- This implementation is given to you. Do not modify.
			key := p_key
			value := p_value

			create left.make_external

			if
				attached left as a_left
			then
				a_left.parent := Current
			end

			create right.make_external

			if
				attached right as a_right
			then
				a_right.parent := Current
			end
		ensure
			-- The postconditions `key_exists`, `value_exists` are
			-- completed for you. Do not modify.
			key_exists:
				attached key

			value_exists:
				attached value

			left_is_external:
				-- TODO: Complete this postcondition.
				-- Hint: `left` is detachable, so for void safety, the compiler
				-- would not allow you to call `left.is_external` directly.
				-- You'd need to make sure that `left`, the call target, is not void.
				attached left as a_left
					and then
					(
						not attached a_left.left
						and
						not attached a_left.right
					)

			right_is_external:
				-- TODO: complete this postcondition.
				-- Hint: See above.
				attached right as a_right
					and then
					(
						not attached a_right.right
						and
						not attached a_right.left
					)

			result_node_is_internal:
				is_internal
		end

feature -- Attributes

	key: detachable K assign set_key
		-- The keyword `assign` is used to indicate an assigner command `set_key`,
		-- which can set the value of the attribute `key`.
		-- Without the assigner command, the `key` attribute
		-- will never be changed after the initialization of `Current`.

	value: detachable V assign set_value

	parent: detachable like Current assign set_parent

	left: like parent assign set_left

	right: like left assign set_right

	sibling: like right
		do
			-- This implementation is given to you. Do not modify.
			if
				attached parent as a_parent
			then
				if
					current = a_parent.left
				then
					Result := a_parent.right
				else
					Result := a_parent.left
				end
			else
				-- Result is nothing.
			end
		ensure
			-- These postconditions are completed for you. Do not modify.
			current_is_left_of_parent_means_result_is_right:
				attached parent as a_parent
				implies
				(
					(
						attached a_parent.left as a_left and then
						a_left = Current
					)
					implies
					(
						attached a_parent.right as a_right and then
						Result = a_right
					)
				)
			current_is_right_of_parent_means_result_is_left:
				attached parent as a_parent
				implies
				(
					(
						attached a_parent.right as a_right and then
						a_right = Current
					)
					implies
					(
						attached a_parent.left as a_left and then
						Result = a_left
					)
				)
			current_no_parent_means_no_result:
				not attached parent as a_parent
				implies
				not attached Result
		end

feature -- Status setting
		-- All set commands except `set_to_internal`
		-- are implemented. Do not modify.
	set_parent (p_node: like parent)
			-- Sets `Current`'s parent.
		do
			parent := p_node
		ensure
			parent = p_node
		end

	set_left (p_node: like left)
			-- Sets `Current`'s left.
		do
			left := p_node
		ensure
			left = p_node
		end

	set_right (p_node: like right)
			-- Sets `Current`'s right.
		do
			right := p_node
		ensure
			right = p_node
		end

	set_key (p_key: like key)
			-- Sets `Current`'s key.
		do
			key := p_key
		ensure
			key = p_key
		end

	set_value (p_value: like value)
			-- Sets `Current`'s value.
		do
			value := p_value
		ensure
			value = p_value
		end

	set_to_internal (p_key: K; p_value: V)
			-- Transforms the current external node to be an internal node storing `p_key` and `p_value`.
		require
			is_external
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hints: You must transform the external `Current` node to an internal node that has
			--		  `p_key` and `p_value`. Think about the difference between the definition of
			-- 		  an internal node and an external node. Make sure to satisfy the postconditions.
			Current.make_internal (p_key, p_value)

		ensure
			-- These postconditions are completed for you. Do not modify.
			current_is_internal:
				is_internal
			parent_does_not_change:
				parent = (old parent)
		end

feature -- Insertion

	insert_left (p_node: like Current)
			-- Inserts the tree node `p_node` in the left external child,
			-- by replacing the left external node with the `p_node`.
			-- This command is used to build trees from scratch.
			-- e.g., `{STARTER_TESTS}.env_int_int`
		require
			p_node_is_inertnal_node:
				p_node.is_internal
			smaller_than_Current:
				p_node < Current
			left_is_external:
				-- TODO: Complete this precondition.
				-- Hint: left child must be external.
				attached left as a_left
					and then
					(
						not attached a_left.left
						and
						not attached a_left.right
					)
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			Current.set_left (p_node)

			if
				attached left as a_left
			then
				a_left.parent := Current
			end

		ensure
			left_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: `Current`'s left child must be `p_node`.
				Current.left = p_node

			keep_left_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The left child keeps its parent reference correctly.
				attached left as a_left
					and then
					(
						a_left.parent = Current
					)
		end

	insert_right (p_node: like Current)
			-- Inserts the tree node `p_node` in the right external child,
			-- by replacing the right external node with the `p_node`.
			-- This command is used to build trees from scratch.
			-- e.g., {STARTER_TESTS}.env_int_int
		require
			p_node_is_inertnal_node:
				p_node.is_internal
			bigger_or_equal_to_Current:
				Current < p_node
			right_is_external:
				-- TODO: Complete this precondition.
				-- Hint: right child must be external.
				attached right as a_right
					and then
					(
						not attached a_right.left
						and
						not attached a_right.right
					)
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			Current.set_right (p_node)

			if
				attached right as a_right
			then
				a_right.parent := Current
			end

		ensure
			right_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: `Current`'s right child must be `p_node`.
				Current.right = p_node

			keep_right_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The right child keeps its parent reference correctly.
				attached right as a_right
					and then
					(
						a_right.parent = Current
					)
		end

feature -- Status Query

	is_external: BOOLEAN
			-- Is the `Current` node external node? ( Does this node have both `left` and `right` not attached? )
		do
			-- This implementation is given to you. Do not modify.
			Result := not attached left and not attached right
		ensure
			has_no_children:
				-- This postcondition is completed for you. Do not modify.
				Result = (not attached left and not attached right)
		end

	is_internal: BOOLEAN
			-- Is the `Current` node internal node? ( Does this node have either `left` and `right` attached? )
		do
			-- This implementation is given to you. Do not modify.
			Result := not is_external
		ensure
			has_a_child:
				-- This postcondition is completed for you. Do not modify.
				Result = (attached left or attached right)
		end

	count: INTEGER
			-- Returns the number of descendants of the tree rooted at `Current`.
			-- Descendants include itself (if internal) and internal nodes.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			if
				is_external
			then
				Result := 0
			end

			if
				not is_external
			then
				Result := 1
			end

			if
				attached right as a_right
			then
				Result := Result + a_right.count
			end

			if
				attached left as a_left
			then
				Result:= Result + a_left.count
			end

		ensure
			correct_result:
				-- TODO: Complete this postcondition.
				-- Hint: the return value of this query (`Result`) is the same as the size
				-- of the linear version (`nodes`) of the tree rooted at `Current`.
				old Current.deep_twin.nodes.count = Result
		end

	min_node: TREE_NODE[K, V]
			-- Returns the node with minimum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			Result := Current
			if
				attached left as a_left
			then
				if
					attached a_left.left as a_left_left
				then
					Result:= a_left.min_node
				end
			end

		ensure
			left_external_means_current_is_minimum:
				-- TODO: Complete this postcondition.
				-- Hint: `left` being external means `Current` is a leaf node.
				(attached left as a_left
					and then
					(
						not attached a_left.left
						and
						not attached a_left.right
					)
				)
				implies
				(attached right as a_right
					and then
					(
						not attached a_right.left
						and
						not attached a_right.right
					)
				)


			result_is_minimum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the `Result` is the smallest node among all the descendants.
				across Current.nodes is i all Result <= i end

			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

	max_node: TREE_NODE[K, V]
			-- Returns the node with maximum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			Result := Current
			if
				attached right as a_right
			then
				if
					attached a_right.right as a_right_right
				then
					Result:= a_right.max_node
				end
			end

		ensure
			right_external_means_current_is_maximum:
				-- TODO: Complete this postcondition.
				-- Hint: `right` being external means `Current` is a leaf node.
				(attached right as a_right
					and then
					(
						not attached a_right.left
						and
						not attached a_right.right
					)
				)
				implies
				(attached left as a_left
					and then
					(
						not attached a_left.left
						and
						not attached a_left.right
					)
				)

			result_is_maximum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the `Result` is the biggest node among all the descendants.
				across Current.nodes is i all Result >= i end

			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

feature -- Status report

	tree_search (p_key: K): TREE_NODE[K, V]
			-- Returns either: 1. The node with the key `p_key` or
			-- 				   2. An external node where the node with the key `p_key` supposed to be.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hints: Cover the 4 cases of search:
			-- Case 1: Current node is external.
			-- Current node is internal and:
			-- Case 2: Current node's key matches `p_key`.
			-- Case 3: Current node's key is bigger than `p_key`.
			-- Case 4: Current node's key is smaller than `p_key`.
			Result := Current
			if is_external then Result := Current end
			if is_internal then
				if Current.key ~ p_key then
					Result := Current
				end

				if
					attached key as a_key
				then
					if p_key < a_key then
						if attached Current.left as a_current then
							Result := a_current.tree_search (p_key)
						end
					end

					if p_key > a_key then
						if attached Current.right as a_current then
							Result := a_current.tree_search (p_key)
						end
					end
				end
			end

		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: When we found the node, the result must be the current node due to the recursive
				-- nature of this query.
				(across Current.nodes is i some (i = Result and i.key ~ p_key) end)
				 or
				(across Current.nodes is i all (i /= Result and i.key /~ p_key) end)

			case_of_key_not_found:
				-- TODO: Complete this postcondition.
				-- Hint: If the node is external, it means the `Result` must be the current node.
				Current.is_external implies Current = Result
		end

	value_search (p_key: K): detachable V
			-- Returns mapped value from the key `p_key` from an internal node
			-- by searching the subtree rooted at `Current`.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: Think of various cases of search for `p_key`.
			Result := Current.value
			if is_external then Result := Current.value end
			if is_internal then
				if Current.key ~ p_key then
					Result := Current.value
				end

				if
					attached key as a_key
				then
					if p_key < a_key then
						if attached Current.left as a_current then
							Result := a_current.value_search (p_key)
						end
					end

					if p_key > a_key then
						if attached Current.right as a_current then
							Result := a_current.value_search (p_key)
						end
					end
				end
			end

		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: `p_key` existing means that the return value is same as one we find within
				-- 		 the same tree.
				(across Current.nodes is i some (i.value = Result and i.key ~ p_key) end)
				or
				(across Current.nodes is i all (i.value /= Result and i.key /~ p_key) end)

			-- We do not worry about specifying the other case (`case_of_key_not_found`).
			-- As an optional exercise, you are encouraged to think about how you might write it.
		end

	has (p_key: K): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has an internal node with
			-- the key `p_key` among its descendants. Returns false otherwise.
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: Think of various cases of search for `p_key`.
			Result := False
			if is_external then Result := False end
			if is_internal then
				if Current.key ~ p_key then
					Result := True
				end

				if
					attached key as a_key
				then
					if p_key < a_key then
						if attached Current.left as a_current then
							Result := a_current.has (p_key)
						end
					end

					if p_key > a_key then
						if attached Current.right as a_current then
							Result := a_current.has (p_key)
						end
					end
				end
			end

		ensure
			correct_search_result:
				-- TODO: Complete this postcondition.
				-- Hint: Result must be same as if we found the `p_key` from subtree rooted at `Current`.
				(Current.tree_search (p_key).key ~ p_key and Result = True)
				or
				(Current.tree_search (p_key).is_external and Result = False)
		end

	has_node (p_node: TREE_NODE[K,V]): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has
			-- an internal node with the same key as `p_node` among its descendants.
			-- Returns false otherwise.
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: You may use previous queries.
			Result := False
			if is_external then Result := False end
			if is_internal then
				if key ~ p_node.key then
					Result := True
				end

				if p_node < Current then
					if attached Current.left as a_current then
						Result := a_current.has_node (p_node)
					end
				end

				if p_node > Current then
					if attached Current.right as a_current then
						Result := a_current.has_node (p_node)
					end
				end
			end

		ensure
			correct_search_result:
				-- TODO: Complete this postcondition.
				-- Hint: Result must be same as the internal node we found from subtree rooted at `Current` with the key `p_key`.
				attached p_node.key as a_key
					and then
					(
						(Current.tree_search (a_key).key ~ a_key and Result = True)
						or
						(Current.tree_search (a_key).is_external and Result = False)
					)
		end

feature -- Conversion

	nodes: LIST[TREE_NODE[K, V]]
			-- Returns a linear ordering of nodes which corresponds to
			-- an in-order traversal of the tree rooted at Current.
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: To satisfy the void safety required by the compiler,
			-- you must first initialize the return value `Result`.
			-- Notice that the static return type of this query is a deferred class `LIST`,
			-- to create an object, you must use one of its effective descendant classes.

			Result := create {LINKED_LIST[TREE_NODE[K, V]]}.make

			if attached Current.left as a_current then
				Result.append(a_current.nodes)
			end

			if is_internal then
				Result.force (Current)
			end

			if attached Current.right as a_current then
				Result.append(a_current.nodes)
			end

			Result.compare_objects

		ensure
			number_of_nodes_not_changed:
				-- This postcondition is completed for you. Do not modify.
				count = old count
			inorder_means_result_is_sorted_incrementally:
				-- TODO: Complete this postcondition.
				across
					1 |..| (nodes.count - 1) is i
				all
					nodes[i] < nodes[i+1]
				end

			no_tree_structure_changed:
				-- TODO: Complete this postcondition.
				-- Hint 1: the tree rooted at Current **before** calling `nodes` has
				-- the same structure (defined by `is_same_tree`) as that **after** calling `nodes`.
				-- Hint 2: Invoking `is_same_tree(node)` is effectively invoking `Current.is_same_tree(node)`.
				is_same_tree (old Current.deep_twin)
		end

feature -- Helper features for postconditions

	is_same_tree(other: TREE_NODE[K, V]): BOOLEAN
			-- Is the tree rooted at Current same (in terms of structure) as tree rooted at other?
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: `Current` and `other` denote the same tree if:
			-- 1. `Current` and `other` are the same node (by content, not refernce).
			-- 			Notice that `is_less_than` is already implemented for you.
			--			According to `COMPARABLE`, parent of `TREE_NODE`, `is_equal` is then
			--			defined as: n1.is_equal(n2) <=> not (n1 < n2) and not (n2 < n2).
			--			That is, you can just use ~ to compare the two nodes.
			-- 2. Recursively, `Current`'s left subtree, if existing, is the same tree as other's left subtree, if existing.
			--		And similarly for the `Current`'s right subtree and `other`'s right subtree.

			if is_external and other.is_external then
				Result := True

			elseif is_external or other.is_external then
				Result := False

			elseif Current /~ other then
				Result := False

			end

			if attached Current.left as a_current then
				if attached other.left as a_other then
					Result := a_current.is_same_tree(a_other)
				end
			end

			if attached Current.right as a_current then
				if attached other.right as a_other then
					Result := a_current.is_same_tree(a_other)
				end
			end

			if attached Current.left as a_current_left then
				if attached other.left as a_other_left then
					if attached Current.right as a_current_right then
						if attached other.right as a_other_right then
							Result := a_current_left.is_same_tree(a_other_left) and a_current_right.is_same_tree(a_other_right)
						end
					end
				end
			end

		end


feature -- Out

	debug_output: STRING
			-- Debugger will show the `Result`.
		do
			Result := out
		end

	out: STRING
			-- Do not modify this.
		do
			if
				attached key as a_key and then
				attached value as a_value
			then
				Result := "(" + a_key.out + ", " + a_value.out + ")"
			else
				Result := "x"
			end

		end

invariant
	-- These class invariants are given to you. Do not modify them.
	-- However, you may study them carefully because they
	-- specify the defintions of external vs. internal nodes.

	if_internal_then_key_value_exist:
		is_internal implies attached key and attached value

	if_internal_then_left_and_right_exist:
		is_internal implies attached left and attached right

	if_external_then_left_and_right_do_not_exist:
		is_external implies not attached left and not attached right

	left_is_not_itself:
		attached left as a_left
		implies
		a_left /= Current

	right_is_not_itself:
		attached right as a_right
		implies
		a_right /= Current

	parent_is_not_itself:
		attached parent as a_parent
		implies
		a_parent /= Current
end
