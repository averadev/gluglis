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

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, noConecta INTEGER);"
		db:exec( query )

		query = "CREATE TABLE IF NOT EXISTS project (id INTEGER PRIMARY KEY, key TEXT, name TEXT);"
        db:exec( query )

		query = "CREATE TABLE IF NOT EXISTS area (id INTEGER PRIMARY KEY, key TEXT, name TEXT, parent TEXT);"
        db:exec( query )

		query = "CREATE TABLE IF NOT EXISTS subarea (id INTEGER PRIMARY KEY, key TEXT, name TEXT, parent TEXT);"
        db:exec( query )
    
        query = "CREATE TABLE IF NOT EXISTS riesgo (id INTEGER PRIMARY KEY, idRiesgo INTEGER, parent TEXT, nd INTEGER, np INTEGER, nc INTEGER);"
        db:exec( query )

		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			do return end
		end

		query = "INSERT INTO config VALUES (1,1);"
		db:exec( query )
    
		closeConnection( )
    
        return 1
	end

    dbManager.getRisk = function( parent )
		local result, counter = {}, 1
		openConnection( )
        local query = "SELECT * FROM riesgo WHERE parent = "..parent..";"
    
        -- Get rows
		for row in db:nrows( query ) do
			result[counter] = row
			counter = counter + 1
		end
		closeConnection( )
		return result
	end

    dbManager.getCatalog = function(table, parent)
		local result, counter = {}, 1
		openConnection( )
        local query = "SELECT * FROM "..table..";"
        if parent then
            query = "SELECT * FROM "..table.." WHERE parent = "..parent..";"
        end
        
        -- Get rows
		for row in db:nrows( query ) do
			result[counter] = row
			counter = counter + 1
		end
		closeConnection( )
		return result
	end

    dbManager.insertRow = function(table, item)
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT key FROM "..table.." WHERE key = '"..item.key.."';") do
            closeConnection( )
			return  "ERROR"
		end
        
        query = "INSERT INTO "..table.." (key, name) VALUES ('"..item.key.."', '"..item.name.."');"
		db:exec( query )
        
		closeConnection( )
		return 0
	end

    dbManager.updateRow = function(table, item)
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT key FROM "..table.." WHERE key = '"..item.key.."' and id <> "..item.id..";") do
            closeConnection( )
			return  "ERROR"
		end
        
        query = "UPDATE "..table.." SET key = '"..item.key.."', name = '"..item.name.."' WHERE id = "..item.id..";"
		db:exec( query )
        
		closeConnection( )
		return 0
	end

	
	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager