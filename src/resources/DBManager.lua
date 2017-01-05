---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------
--Include sqlite
---------------------------------------------
local dbManager = {}

	require "sqlite3"
	local path, db

	-------------------------------------------------------
	-- Incia la conexion a la bd, si no existe se crea
	-------------------------------------------------------
	local function openConnection( )
	    path = system.pathForFile("care.db", system.DocumentsDirectory)
	    db = sqlite3.open( path )
	end

	-------------------------------------------------------
	-- Cierra la conexion
	-------------------------------------------------------
	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	-------------------------------------------------------
	-- Cierra la conexion cuando se finaliza de la app
	-------------------------------------------------------
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end
	
	-------------------------------------------------------
	-- Obtiene los datos del usuario
	-------------------------------------------------------
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
	
	-------------------------------------------------------
	-- Obtiene la configuracion del filtro
	-------------------------------------------------------
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
	
	-------------------------------------------------------
	-- Actualiza la informacion de los usuariosltro
	-------------------------------------------------------
	dbManager.updateUser = function(idApp, user_email, display_name )
		openConnection( )
        local query = "UPDATE config SET idApp = '"..idApp.."', user_email = '"..user_email.."', display_name = '"..display_name.."';"
        db:exec( query )
		closeConnection( )
	end
	
	-------------------------------------------------------
	--actualiza la configuracion de los filtros
	-------------------------------------------------------
	dbManager.updateFilter = function(city, iniDate, endDate, genH, genM, iniAge, endAge, accommodation, cityId )
		openConnection( )
        local query = "UPDATE filter SET city = '"..city.."', iniDate = '"..iniDate.."', endDate = '"..endDate.."', genH = '"..genH.."', genM = '"..genM.."', iniAge = '"..iniAge.."', endAge = '"..endAge.."', accommodation = '"..accommodation.."', cityId = '"..cityId.."';"
		db:exec( query )
		closeConnection( )
	end
	
	-------------------------------------------------------
	--actualiza la configuracion de los filtros
	-------------------------------------------------------
	dbManager.updateCity = function( city, cityId )
		openConnection( )
        local query = "UPDATE filter SET city = '"..city.."', cityId = '"..cityId.."';"
        db:exec( query )
		closeConnection( )
	end
	
	-------------------------------------------------------
	--actualiza la configuracion de los filtros
	-------------------------------------------------------
	dbManager.updateAvatar = function( avatar )
		openConnection( )
        local query = "UPDATE config SET idAvatar = '"..avatar.."';"
        db:exec( query )
		closeConnection( )
	end
	
	-------------------------------------------------------
	--actualiza el idioma de la app
	-------------------------------------------------------
	dbManager.updatLanguage = function( language )
		openConnection( )
        local query = "UPDATE config SET language = '"..language.."';"
        db:exec( query )
		closeConnection( )
	end
	
	-------------------------------------------------------
	--limpia la tabla de config y filtro
	-------------------------------------------------------
    dbManager.clearUser = function()
        openConnection( )
        local query = "UPDATE config SET idApp = 0, user_email = '', display_name = '';"
        db:exec( query )
		local query = "delete from filter;"
        db:exec( query )
		local query = "INSERT INTO filter VALUES (1, '0', '0000-00-00', '0000-00-00', 1, 1, 18, 99, 'Sí',0);"
		db:exec( query )
		closeConnection( )
    end

	-------------------------------------------------------
    -- Verificamos campo en tabla
	-------------------------------------------------------
    local function updateTable(table, field, typeF)
	    local oldVersion = true
        for row in db:nrows("PRAGMA table_info("..table..");") do
            if row.name == field then
                oldVersion = false
            end
        end
        if oldVersion then
            local query = "ALTER TABLE "..table.." ADD COLUMN "..field.." "..typeF..";"
            db:exec( query )
        end   
	end

	-------------------------------------------------------
	-- Crea el squema si no existe
	-------------------------------------------------------
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, user_email TEXT, display_name TEXT, url TEXT, idAvatar TEXT);"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS filter (id INTEGER PRIMARY KEY, city TEXT, iniDate TEXT, endDate TEXT, genH INTEGER, genM INTEGER, iniAge INTEGER, endAge INTEGER, accommodation TEXT );"
		db:exec( query )
		
		local oldVersion = true
		for row in db:nrows("PRAGMA table_info(filter);") do
			if row.name == 'cityId' then
				oldVersion = false
            end
		end
		if oldVersion then
			local query = "ALTER TABLE filter ADD COLUMN cityId TEXT;"
            db:exec( query )
			local query = "UPDATE filter SET cityId = '0';"
			db:exec( query )
			oldVersion = false
		end
		
		oldVersion = true
		for row in db:nrows("PRAGMA table_info(config);") do
			if row.name == 'language' then
				oldVersion = false
            end
		end
		
		if oldVersion then
			local query = "ALTER TABLE config ADD COLUMN language TEXT;"
            db:exec( query )
			local leng = system.getPreference( "locale", "language" )
			local query = "UPDATE config SET language = '" .. leng .. "';"
			db:exec( query )
			oldVersion = false
		end
    
        for row in db:nrows("SELECT * FROM config;") do
            closeConnection( )
            if row.idApp == 0 then
                return false
            else
                return true
            end
		end
		
		local leng = system.getPreference( "locale", "language" )
        
        query = "INSERT INTO config VALUES (0, 0, '', '', 'http://www.gluglis.travel/gluglis_api/', '','" .. leng .."');"
		db:exec( query )
        query = "INSERT INTO filter VALUES (1, '0', '0000-00-00', '0000-00-00', 1, 1, 18, 99, 'Sí',0);"
        db:exec( query )

		closeConnection( )

        return false
	end
	
	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager