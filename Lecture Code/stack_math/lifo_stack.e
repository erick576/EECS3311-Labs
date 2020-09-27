note
	description: "Summary description for {LIFO_STACK}."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	LIFO_STACK[G -> attached ANY]

create
	make

feature {NONE} -- Implementation
	-- Strategy 1: Array and last item as top
--	imp: ARRAY[G]

	-- Strategy 2: Linked List and first item as top
	imp: LINKED_LIST[G]

	-- Strategy 3: Linked List and last item as top
--	imp: LINKED_LIST[G]
feature
	make
		do
			-- Strategy 1: Array and last item as top
--			create imp.make_empty

			-- Strategy 2: Linked List and first item as top
			create imp.make

			-- Strategy 3: Linked List and last item as top
--			create imp.make
		end

feature -- Abstraction function of a stack
	model: SEQ[G]
			-- Abstraction of a FIFO stack as a immutable sequence.
		do
			-- Strategy 1: Array and last item as top
--			create Result.make_from_array (imp)

			-- Strategy 2: Linked List and first item as top
			create Result.make_empty
			across
				imp as cursor
			loop
				Result.prepend (cursor.item)
			end

			-- Strategy 3: Linked List and last item as top
--			create Result.make_empty
--			across
--				imp as cursor
--			loop
--				Result.append (cursor.item)
--			end
		ensure
			consistent_counts:
				imp.count = Result.count

			-- Strategy 1: Array and last item as top
--			consistent_countens:
--				across
--					1 |..| Result.count as i
--				all
--					imp[i.item] ~ Result[i.item]
--				end

			-- Strategy 2: Linked List and first item as top
			consistent_countens:
				across
					1 |..| Result.count as i
				all
					Result[i.item] ~ imp[count - i.item + 1]
				end

			-- Strategy 3: Linked List and last item as top
--			consistent_countens:
--				across
--					1 |..| Result.count as i
--				all
--					imp[i.item] ~ Result[i.item]
--				end
		end

feature -- Queries
	count: INTEGER
		do
			Result := imp.count
		ensure
			correct_result: Result = model.count
		end

feature -- Commands
	push (g: G)
		do
			-- Strategy 1: Array and last item as top
--			imp.force (g, imp.count + 1)

			-- Strategy 2: Linked List and first item as top
			imp.put_front (g)

			-- Strategy 3: Linked List and last item as top
--			imp.extend (g)
		ensure
			model ~ (old model.deep_twin).appended (g)
		end

	top: G
		require
			not_empty: not model.is_empty
		do
			-- Strategy 1: Array and last item as top
			Result := imp[imp.lower]

			-- Strategy 2: Linked List and first item as top
--			Result := imp [imp.count]

			-- Strategy 3: Linked List and last item as top
--			Result := imp.last
		ensure
			model_unchanged:
				model ~ old model.deep_twin
			lifo_property:
				Result ~ model.last
		end

	pop
		require
			not_empty: not model.is_empty
		do
			-- Strategy 1: Array and last item as top
--			imp.remove_tail (1)

			-- Strategy 2: Linked List and first item as top
			imp.start
			imp.remove

			-- Strategy 3: Linked List and last item as top
--			imp.finish
--			imp.remove
		ensure
			stack_popped:
				model ~ (old model.deep_twin).front
			top_updated:
				count > 0 implies top ~ (old model.deep_twin).front.last
		end
end
