note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
create
	make
feature -- command
	undo
    	do
			-- perform some update on the model state
			model.grid.undo
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
