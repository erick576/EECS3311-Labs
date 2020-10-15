note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
		local
			operation_fire : OPERATION_FIRE
    	do
			-- perform some update on the model state
			create {OPERATION_FIRE} operation_fire.make
			operation_fire.execute
			if not model.grid.did_error_occur then
				model.grid.history.put (operation_fire)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
