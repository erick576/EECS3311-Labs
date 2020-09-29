note
	description: "Iteration cursor for TREE_DB. (Postorder iteration)"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_IT[K -> COMPARABLE, V -> attached ANY]

inherit
	ITERATION_CURSOR[TUPLE[K,V]]

create
	make

feature {NONE} -- Initialization

	make (p_db: TREE_DB[K, V])
		do
			-- TODO: Complete this implementation.
			pairs := p_db.model.as_array
			cursor_pos := pairs.upper
		end

feature -- Access

	item: TUPLE[key: K; value: V]
			-- Item at current cursor position.
		do
			-- TODO: Complete this implementation.
			create Result
			Result := pairs[cursor_pos]
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			-- TODO: Complete this implementation.
			Result := (cursor_pos < pairs.lower)
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			-- TODO: Complete this implementation.
			cursor_pos := cursor_pos - 1
		end

feature {NONE} -- Underlying Values

	pairs : ARRAY[TUPLE[K,V]]
	cursor_pos : INTEGER

end
