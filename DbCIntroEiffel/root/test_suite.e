note
	description: "Summary description for {TEST_SUITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SUITE
inherit
	ES_SUITE
create
	make
feature -- Constructor for adding test classes
	make
		do 
			add_test (create {TEST_ACCOUNT}.make)

			show_browser
			run_espec
		end

end
