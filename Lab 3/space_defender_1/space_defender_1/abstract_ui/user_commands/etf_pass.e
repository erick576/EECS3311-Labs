note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PASS
inherit
	ETF_PASS_INTERFACE
create
	make
feature -- command
	pass
		local
			operation_pass : OPERATION_PASS
    	do
			-- perform some update on the model state
			create {OPERATION_PASS} operation_pass.make
			operation_pass.execute
			if not model.grid.did_error_occur then
				model.grid.history.put (operation_pass)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
