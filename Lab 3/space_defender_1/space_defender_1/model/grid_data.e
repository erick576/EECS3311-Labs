note
	description: "Summary description for {GRID_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID_DATA

create
	make

feature {NONE} -- Initialization
	make
		do
			create starfighter.make (0, 0)
			create projectiles.make (0)

			valid_command_count := 0
			error_count := 0

			create grid_elements.make_empty

			currently_playing := false
			is_error := false
			still_alive := false

			create operation_message.make_empty
			create error_message.make_empty
		end

feature {NONE} -- Attributes

	starfighter : STARFIGHTER
	projectiles : ARRAYED_LIST[PROJECTILE]

	valid_command_count : INTEGER
	error_count : INTEGER

	grid_elements : ARRAY[CHARACTER]

	currently_playing : BOOLEAN
	is_error : BOOLEAN
	still_alive : BOOLEAN

	operation_message : STRING
	error_message : STRING


feature -- Getters

	get_starfighter : STARFIGHTER
		do
			Result := starfighter
		end

	get_projectiles : ARRAYED_LIST[PROJECTILE]
		do
			Result := projectiles
		end

	get_valid_command_count : INTEGER
		do
			Result := valid_command_count
		end

	get_error_count : INTEGER
		do
			Result := error_count
		end

	get_grid_elements : ARRAY[CHARACTER]
		do
			Result := grid_elements
		end

	get_currently_playing : BOOLEAN
		do
			Result := currently_playing
		end

	get_is_error : BOOLEAN
		do
			Result := is_error
		end

	get_still_alive : BOOLEAN
		do
			Result := still_alive
		end

	get_operation_message : STRING
		do
			Result := operation_message
		end

	get_error_message : STRING
		do
			Result := error_message
		end

feature -- Setters

	set_error_message (new_error_message : STRING)
		do
			error_message := new_error_message
		end

	set_operation_message (new_operation_message : STRING)
		do
			operation_message := new_operation_message
		end

	set_player_status (new_currently_playing : BOOLEAN ; new_is_error : BOOLEAN ; new_still_alive : BOOLEAN)
		do
			currently_playing := new_currently_playing
			is_error := new_is_error
			still_alive := new_still_alive
		end

	set_grid (new_grid_elements : ARRAY[CHARACTER])
		do
			grid_elements := new_grid_elements
		end

	set_counters (new_error_count : INTEGER ; new_valid_command_count : INTEGER)
		do
			valid_command_count := new_valid_command_count
			error_count := new_error_count
		end

	set_starfighter (new_starfighter : STARFIGHTER)
		do
			starfighter := new_starfighter
		end

	set_projectiles (new_projectiles : ARRAYED_LIST[PROJECTILE])
		do
			projectiles := new_projectiles
		end


end
