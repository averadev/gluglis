---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db

	--Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
	    path = system.pathForFile("care.db", system.DocumentsDirectory)
	    db = sqlite3.open( path )     
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	--Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end
	
	--obtiene los datos del admin
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, user_login TEXT, user_email TEXT, display_name TEXT, url TEXT);"
		db:exec( query )

		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			do return end
		end

		query = "INSERT INTO config VALUES (1, 1, '', '', '', 'http://geekbucket.com.mx/gluglis/');"
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', 'http://localhost:8080/gluglis/');"
		db:exec( query )
    
		closeConnection( )
    
        return 1
	end
	
	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager