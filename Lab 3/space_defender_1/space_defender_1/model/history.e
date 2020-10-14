note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature{NONE} -- create
	make
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
		end

	history: LIST[OPERATION]

end
