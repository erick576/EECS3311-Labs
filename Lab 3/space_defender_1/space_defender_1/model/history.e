note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature {NONE} -- Initialization (BOUNDED_LIST)
	make
		do
			create {ARRAYED_LIST[OPERATION]} history.make (20)
		end

feature {NONE} -- Attributes

	history: LIST[OPERATION]


feature -- commands

	-- For the history list a type SOME_LIST was posited, with features put, empty, before, is_
	-- first, is_last, back, forth, item and remove_all_right. (There is also on_item, expressed in
	-- terms of empty and before, and not_last, expressed in terms of empty and is_last.)

	put(operation : OPERATION)
		do
			if not is_last then remove_all_right end
			history.force (operation)
			history.finish
		end

	remove_all
		do
			history := 	create {ARRAYED_LIST[OPERATION]}.make (20)
		end

	before: BOOLEAN
		do
			Result := history.index = 0
		end

	after: BOOLEAN
		do
			Result := history.index = history.count + 1
		end

	back
		require
			not before
		do
			history.back
		end

	forth
		require
			not after
		do
			history.forth
		end

	is_last : BOOLEAN
		do
			Result := history.index = history.count
		end

	is_first : BOOLEAN
		do
			Result := history.index = 1
		end

	item: OPERATION
		require
			on_item
		do
			Result := history.item
		end

	on_item: BOOLEAN
		do
			Result := not history.before and not history.after
		end

	remove_all_right
		do
			from
				history.forth
			until
				history.after
			loop
				history.remove
			end
		end

end
