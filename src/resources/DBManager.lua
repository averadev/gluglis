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
	
	--obtiene la configuracion del filtro
	dbManager.getSettingFilter = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM filter;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--actualiza la informacion de los usuarios
	dbManager.updateUser = function(idApp, user_email, display_name )
		openConnection( )
        local query = "UPDATE config SET idApp = '"..idApp.."', user_email = '"..user_email.."', display_name = '"..display_name.."';"
        db:exec( query )
		closeConnection( )
	end
	
	--actualiza la configuracion de los filtros
	dbManager.updateFilter = function(city, iniDate, endDate, genH, genM, iniAge, endAge )
		openConnection( )
        local query = "UPDATE filter SET city = '"..city.."', iniDate = '"..iniDate.."', endDate = '"..endDate.."', genH = '"..genH.."', genM = '"..genM.."', iniAge = '"..iniAge.."', endAge = '"..endAge.."';"
        db:exec( query )
		closeConnection( )
	end
	
	--limpia la tabla de config y filtro
    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, user_email = '', display_name = '';"
        db:exec( query )
		query = "delete from filter;"
        db:exec( query )
		query = "INSERT INTO filter VALUES (1, '0', '0000-00-00', '0000-00-00', 1, 1, 18, 99);"
		db:exec( query )
		closeConnection( )
    end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, user_email TEXT, display_name TEXT, url TEXT);"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS filter (id INTEGER PRIMARY KEY, city TEXT, iniDate TEXT, endDate TEXT, genH INTEGER, genM INTEGER, iniAge INTEGER, endAge INTEGER );"
		db:exec( query )
		
		local countFilter = 0
		for row in db:nrows("SELECT * FROM filter;") do
			countFilter = countFilter + 1
		end
		if countFilter == 0 then
			query = "INSERT INTO filter VALUES (1, '0', '0000-00-00', '0000-00-00', 1, 1, 18, 99);"
			db:exec( query )
		end
		
		--[[local oldVersion = true
		for row in db:nrows("PRAGMA table_info(config);") do
			if row.name == 'facebookId' then
				oldVersion = false
            end
		end
		
		if oldVersion then
			local query = "ALTER TABLE config ADD COLUMN facebookId TEXT;"
            db:exec( query )
			oldVersion = true
		end]]

		for row in db:nrows("SELECT idApp FROM config;") do
            closeConnection( )
            if row.idApp == 0 then
                return false
            else
                return true
            end
		end

		query = "INSERT INTO config VALUES (1, 0, '', '', 'http://geekbucket.com.mx/gluglis/');"
		--query = "INSERT INTO config VALUES (1, 0, '', '', 'http://localhost:8080/gluglis_api/');"
		db:exec( query )

		closeConnection( )

        return false
	end
	
	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager