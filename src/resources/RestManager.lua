--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local openssl = require("plugin.openssl")
	local cipher = openssl.get_cipher("aes-256-cbc")
	local Globals = require('src.resources.Globals')
	local DBManager = require('src.resources.DBManager')
  
	
	local settings = DBManager.getSettings()
	local site = settings.url

	------------------------------------------------
    -- codifica los mensajes para mandarlo por url
	-- @param str mensaje a codificar
    ------------------------------------------------
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	---------------------------------- Pantalla Login ----------------------------------
	---------------------------------------------
    -- da de alta un nuevo usuario por facebook
    ---------------------------------------------
	RestManager.createUser = function(userLogin, email, password, name, gender, birthday, location, facebookId, playerId)
		
		password = encryptedPass(password)
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
		
        -- Set url
		--password = crypto.digest(crypto.md5, password)
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/userLogin/"..urlencode(userLogin)
		url = url.."/email/"..urlencode(email)
		url = url.."/pass/"..urlencode(password)
		if name ~= "" then
			url = url.."/name/"..urlencode(name)
		end
		if gender ~= "" then
			url = url.."/gender/"..urlencode(gender)
		end
		if birthday ~= "" then
			url = url.."/birthday/"..urlencode(birthday)
		end
		if location ~= "" then
			--url = url.."/location/"..urlencode(location)
		end
		if facebookId ~= "" then
			url = url.."/facebookId/"..urlencode(facebookId)
		end
		url = url.."/playerId/"..urlencode(playerId)
	
        local function callback(event)
            if ( event.isError ) then
				--noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						DBManager.updateUser(data.idApp, email, name)
						gotoHome(data.SignUp)
					else
						
					end
				else
					--noConnectionMessages("Error con el servidor. Intentelo mas tarde")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	function encryptedPass(pass)
		local encryptedData = cipher:encrypt ( pass, "key" )
		local mime = require ( "mime" )
		local encryptedData = mime.b64 ( cipher:encrypt ( pass, "key" ) )
		return encryptedData
	end
	
	---------------------------------- Pantalla Login ----------------------------------
	-------------------------------------
    -- da de alta un nuevo usuario
    -------------------------------------
	RestManager.createUserNormal = function(userLogin, email, password, playerId)
		
		password = encryptedPass(password)
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
        -- Set url
		--password = crypto.digest(crypto.md5, password)
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/userLogin/"..urlencode(userLogin)
		url = url.."/email/"..urlencode(email)
		url = url.."/pass/"..urlencode(password)
		url = url.."/playerId/"..urlencode(playerId)
	
        local function callback(event)
            if ( event.isError ) then
				gotoHomeUN( "Error intentelo mas tarde", "login", false )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						DBManager.updateUser(data.idApp, email, "")
						gotoHomeUN( data.message, "register", true )
					else
						if data.error then
							gotoHomeUN( data.error, "register", false )
						else
							gotoHomeUN( data.message, "register", false )
						end
					end
				else
					gotoHomeUN( "Error intentelo mas tarde", "login", false )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--------------------------
	-- valida el logueo
	-------------------------
	RestManager.validateUser = function( email, password, playerId )
	
		password = encryptedPass(password)
		
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
		-- Set url
		--password = crypto.digest(crypto.md5, password)
        local url = site
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/email/"..urlencode(email)
		url = url.."/password/"..urlencode(password)
		url = url.."/playerId/"..urlencode(playerId)
		
        local function callback(event)
            if ( event.isError ) then
				gotoHomeUN( "Error intentelo mas tarde", "login", false )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local item = data.item[1]
						DBManager.updateUser(item.id, item.user_email, item.display_name)
						gotoHomeUN( data.message, "login", true )
					else
						if data.error then
							gotoHomeUN( data.error, "login", false )
						else
							gotoHomeUN( data.message, "login", false )
						end
					end
				else
					gotoHomeUN( "Error intentelo mas tarde", "login", false )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
		
	end
	
	---------------------------------- Pantalla Messages ----------------------------------
	
    -------------------------------------
    -- Obtiene la lista de los mensajes
    -------------------------------------
	RestManager.getListMessageChat = function()
        -- Set url
        local url = site
        url = url.."api/getListMessageChat/format/json"
        url = url.."/idApp/"..settings.idApp
		--url = url.."/timeZone/" .. urlencode(timeZone)
		url = url.."/timeZone/" .. urlencode("-5")
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							--cargamos los elementos del mensaje
							loadImage({idx = 0, name = "MessagesAvatars", path = "assets/img/avatar/", items = data.items})
						else
							--notificamos que no existen chats
							notListMessages()
						end
					else
						noConnectionMessages("Error con el servidor. Intentelo mas tarde")
					end
				else
					noConnectionMessages("Error con el servidor. Intentelo mas tarde")
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			--notifica si no existe conexion a internet
			noConnectionMessages('No se detecto conexion a internet')
		end
    end
	
	---------------------------------- Pantalla Message ----------------------------------
	
    -------------------------------------
    -- Obtiene los mensajes del chat seleccionado
    -- @param channelId identificador del canal de los mensajes
    -------------------------------------
	RestManager.getChatMessages = function(channelId)
        -- Set url
        local url = site
        url = url.."api/getChatMessages/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/channelId/".. channelId
		url = url.."/timeZone/" .. urlencode(timeZone)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							--cargamos los elementos del mensaje
							setItemsMessages(data.items)
						else
							--notificamos que no existen mensajes nuevos
							notChatsMessages()
						end
					else
						noConnectionMessage('Error con el servidor. Intentelo mas tarde')
					end
				else
					noConnectionMessage('Error con el servidor. Intentelo mas tarde')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			--notifica si no existe conexion a internet
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	------------------------------------------------------------
    -- Envia los mensajes del chat
    -- @param channelId identificador del canal de los mensajes
	-- @param message mensaje a enviar
	-- @param poscM posicion en la que esta colocado el chat
    ------------------------------------------------------------
	RestManager.sendChat = function(channelId, message, poscM)
        -- Set url
        local url = site
        url = url.."api/saveChat/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/message/" .. urlencode(message)
		url = url.."/timeZone/" .. urlencode(timeZone)
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							--cambia la fecha en la que se envio el mensaje
							changeDateOfMSG(data.items[1],poscM)
						else
							noConnectionMessage('Error con el servidor')
						end
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	RestManager.getMessagesByChannel = function(channelId)
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessagesByChannel/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/timeZone/" .. urlencode(timeZone)
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local items = data.items
						local lastRead = data.lastRead
						showNewMessages( items, lastRead )
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
	end
	
	
	--------------------------------------------------------------------
    -- Bloquea o desbloquea el chat selecionado
    -- @param channelId identificador del canal de los mensajes
	-- @param status define si el canal estara bloqueado o desbloqueado
    --------------------------------------------------------------------
	RestManager.blokedChat = function(channelId,status)
        -- Set url
        local url = site
        url = url.."api/blokedChat/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/status/" .. status
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						--bloquea o desbloquea el chats
						changeStatusBlock(data.status)
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	---------------------------------------------------------------
    -- marca los mensajes como leidos
    -- @param channelId identificador del canal de los mensajes
	-- @param idMessage identificador del mensaje
    ---------------------------------------------------------------
	RestManager.changeStatusMessages = function(channelId,idMessage)
        local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/changeStatusMessages/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/idMessage/" .. idMessage
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						--elimina las burbujas de mensajes no leidos
						deleteNotBubble()
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage('No se detecto conexion a internet')
		end
    end
	
	--------------------------------------------------------------------
    -- Obtiene el avatar de messajes, en caso de no existir en fichero interno
    -- @param item informacion
    --------------------------------------------------------------------
	RestManager.getImagePerfilMessage = function( item )
        loadImage({idx = 0, name = "MessageAvatars", path = "assets/img/avatar/", items = item})
    end

    ---------------------------------- Pantalla HOME ----------------------------------
	
	-------------------------------------
    -- Obtiene los datos del usuario por id
    -------------------------------------
    RestManager.getUsersById = function(after)
		settings = DBManager.getSettings()
		local site = settings.url
        local url = site.."api/getUsersById/format/json"
		url = url.."/idApp/" .. settings.idApp
		print(url)
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if #data.items > 0 then
					loadImage({idx = 0, name = "UserAvatars", path = "assets/img/avatar/", items = data.items, after = after})
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	-------------------------------------
    -- Obtiene los datos del usuario por id
    -------------------------------------
    RestManager.getUserAvatar = function()
		settings = DBManager.getSettings()
		local site = settings.url
        local url = site.."api/getUserAvatar/format/json"
		url = url.."/idApp/" .. settings.idApp
	 
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if #data.items > 0 then
                    DBManager.updateAvatar(data.items[1].image)
					loadImage({idx = 0, path = "assets/img/avatar/", items = data.items, after = after})
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
    ---------------------------------------
    -- Obtiene los usuarios por ubicacion
    ---------------------------------------
    RestManager.getUsersByCity = function(limit)
		settings = DBManager.getSettings()
		local settFilter = DBManager.getSettingFilter()
        local url = site.."api/getUsersByCity/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/version/v2"
		--url = url.."/city/" 	.. urlencode(settFilter.city)
		url = url.."/city/" 	.. urlencode(settFilter.cityId)
		url = url.."/limit/" .. urlencode(limit)
		print(url)
        local function callback(event)
            if ( event.isError ) then
				HomeError( "Error con el servidor" )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						setTotalCard(data.total)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						if data.error then
							HomeError( "Error con el servidor" )
						else
							HomeError(data.message)
						end
					end
				else
					HomeError( "Error con el servidor" )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	---------------------------------------
    -- Obtiene los usuarios filtrados
    ---------------------------------------
	RestManager.getUsersByFilter = function(limit)
		settings = DBManager.getSettings()
		local settFilter = DBManager.getSettingFilter()
        local url = site.."api/getUsersByFilter/format/json"
		url = url.."/idApp/" 	.. settings.idApp
		--url = url.."/city/" 	.. urlencode(settFilter.city)
		url = url.."/version/v2"
		url = url.."/city/" 	.. urlencode(settFilter.cityId)
		url = url.."/iniDate/" 	.. urlencode(settFilter.iniDate)
		url = url.."/endDate/" 	.. urlencode(settFilter.endDate)
		url = url.."/genH/" 	.. settFilter.genH
		url = url.."/genM/" 	.. settFilter.genM
		url = url.."/iniAge/" 	.. settFilter.iniAge
		url = url.."/endAge/" 	.. settFilter.endAge
		url = url.."/accommodation/" .. urlencode(settFilter.accommodation)
		print(url)
		url = url.."/limit/" .. urlencode(limit)
        local function callback(event)
            if ( event.isError ) then
				HomeError( "Error con el servidor" )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						setTotalCard(data.total)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						if data.error then
							HomeError( "Error con el servidor" )
						else
							HomeError(data.message)
						end
					end
				else
					HomeError( "Error con el servidor" )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--------------------------------------------------
    -- Limpia los datos del usuario(playerId y local)
    --------------------------------------------------
    RestManager.clearUser = function()
        local url = site.."api/clearUser/format/json"
		url = url.."/idApp/" .. settings.idApp
	
        local function callback(event)
            if ( event.isError ) then
				resultCleanUser( false, data.message)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						resultCleanUser( true, data.message )
					else
						resultCleanUser( false, "Error al cerrar sesión")
					end
				else
					resultCleanUser( false, "Error al cerrar sesión")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--------------------------------------------------
    -- actualiza el playerId
    --------------------------------------------------
    RestManager.updatePlayerId = function()
        local url = site.."api/updatePlayerId/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/playerId/"..urlencode(playerId)
        -- Do request
		network.request( url, "GET", callback )
    end
	
	---------------------------------- Pantalla PROFILE ----------------------------------
    -------------------------------------
    -- Inicia una nueva conversacion con los usuarios
	--@param idUser usuario con que se iniciara el chat
    -------------------------------------
    RestManager.startConversation = function(idUser)
        local url = site.."api/startConversation/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/idUser/" .. idUser
	
        local function callback(event)
            if ( event.isError ) then
				
            else
                local data = json.decode(event.response)
				if data then
					showNewConversation(data.item)
				end
				--loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--obtiene el avatar de messajes, en caso de no existir en fichero interno
	RestManager.getImagePerfile = function( item )
        loadImage({idx = 0, name = "ProfileAvatars", path = "assets/img/avatar/", items = item})
    end
	
    -------------------------------------
    -- Actualiza los datos del usuario
	--@param idUser usuario con que se iniciara el chat
    -------------------------------------
    --RestManager.saveProfile = function(name, residence, accommodation, vehicle, available, hobbies, language)
	RestManager.saveProfile = function(UserName, hobbies, name, lastName, gender, originCountry, residence, residenceTime, emailContact, availability, accommodation, vehicle, food, language, race, workArea, ownAccount, pet, sport, smoke, drink, psychrotrophic, idResidence )
		
		local hobbies2 = json.encode(hobbies)
		local language2 = json.encode(language)
		local sport2 = json.encode(sport)
        local url = site.."api/saveProfile/format/json"
		url = url.."/idApp/" .. settings.idApp
		if UserName ~= 'UserName' then
			url = url.."/UserName/" .. urlencode(UserName)
		end
		if name ~= '' then
			url = url.."/name/" .. urlencode(name)
		end
		if lastName ~= '' then
			url = url.."/lastName/" .. urlencode(lastName)
		end
		url = url.."/gender/" .. urlencode(gender)
		if originCountry ~= '' then
			url = url.."/originCountry/" .. urlencode(originCountry)
		end
		if residence ~= '' then
			url = url.."/residence/" .. urlencode(residence)
		end
		if idResidence ~= '' then
			url = url.."/idResidence/" .. urlencode(idResidence)
		end
		url = url.."/residenceTime/" .. urlencode(residenceTime)
		if emailContact ~= '' then
			url = url.."/emailContact/" .. urlencode(emailContact)
		end
		url = url.."/availability/" .. urlencode(availability)
		url = url.."/accommodation/" .. urlencode(accommodation)
		url = url.."/vehicle/" .. urlencode(vehicle)
		url = url.."/food/" .. urlencode(food)
		url = url.."/race/" .. urlencode(race)
		url = url.."/workArea/" .. urlencode(workArea)
		url = url.."/ownAccount/" .. urlencode(ownAccount)
		url = url.."/workArea/" .. urlencode(workArea)
        if pet ~= 'No' then
			url = url.."/pet/" .. urlencode(pet)
		end
		url = url.."/smoke/" .. urlencode(smoke)
		url = url.."/drink/" .. urlencode(drink)
		url = url.."/psychrotrophic/" .. urlencode(psychrotrophic) 
		url = url.."/hobbies/" .. urlencode(hobbies2)
		url = url.."/language/" .. urlencode(language2)
		url = url.."/sport/" .. urlencode(sport2)
		
        local function callback(event)
            if ( event.isError ) then
				resultSaveProfile( false, event.error)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						resultSaveProfile( true, data.message)
					else
						resultSaveProfile( false, "error al guardar los datos del perfil")
					end
				else
					resultSaveProfile( false, "error al guardar los datos del perfil")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	RestManager.savePhoto = function( name )
		uploadImage( name )
	end
	
	function uploadImage(photophoto)
	
		local function uploadListener( event )
		   if ( event.isError ) then
			  print( "Network Error." )
		 
			  -- This is likely a time out or server being down. In other words,
			  -- It was unable to communicate with the web server. Now if the
			  -- connection to the web server worked, but the request is bad, this
			  -- will be false and you need to look at event.status and event.response
			  -- to see why the web server failed to do what you want.
		   else
			  if ( event.phase == "began" ) then
				 print( "Upload started" )
			  elseif ( event.phase == "progress" ) then
				 print( "Uploading... bytes transferred ", event.bytesTransferred )
			  elseif ( event.phase == "ended" ) then
				 print( "Upload ended..." )
				 print( "Status:", event.status )
				 print( "Response:", event.response )
			  end
		   end
		end	
	
		-- Sepcify the URL of the PHP script to upload to. Do this on your own server.
		-- Also define the method as "PUT".
		--local url = "http://192.168.1.77:8080/gluglis_api2/upload/uploadImage"
		local url = site.."upload/uploadImage"
		local method = "PUT"
		 
		-- Set some reasonable parameters for the upload process:
		local params = {
		   timeout = 60,
		   progress = true,
		   bodyType = "binary"
		}
		
		
		-- Specify what file to upload and where to upload it from.
		-- Also, set the MIME type of the file so that the server knows what to expect.
		local filename =  "tempFotos/" .. photophoto .. ".jpg"
		local baseDirectory = system.TemporaryDirectory
		local contentType = "image/jpeg"  --another option is "text/plain"
		 
		-- There is no standard way of using HTTP PUT to tell the remote host what
		-- to name the file. We'll make up our own header here so that our PHP script
		-- expects to look for that and provides the name of the file. Your PHP script
		-- needs to be "hardened" because this is a security risk. For example, someone
		-- could pass in a path name that might try to write arbitrary files to your
		-- server and overwrite critical system files with malicious code.
		-- Don't assume "This won't happen to me!" because it very well could.
		local headers = {}
		headers.filename = filename
		params.headers = headers
		 
		network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
	
	
		--[[local settings = DBManager.getSettings()
	
		local function networkListener( event )

			if ( event.isError ) then
				print( "Network Error." )
				print( "Network error: ", event.response )
			else
				if ( event.phase == "began" ) then
					--print( "Upload started" )
				elseif ( event.phase == "progress" ) then
					--print( "Uploading... bytes transferred ", event.bytesTransferred )
				elseif ( event.phase == "ended" ) then
					--print( "Upload ended..." )
					--print( "Status:", event.status )
					--print( "Response:", event.response )
					
					if event.status == 201 then
						print("imagen subida")
						
						
					else
						print("imagen no subida")
						
					end
					
					
				end
			end
			
		end

		local url = settings.url .. "upload/uploadImage"
		
		local params = {
			timeout = 60,
			progress = true,
			bodyType = "text"
		}
		
		local filename = "tempFotos/" .. name .. ".jpg"
		
		print(filename)
		print(url)
		
		local baseDirectory = system.TemporaryDirectory
		local contentType = "image/jpeg"
		
		local headers = {}

		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		headers.filename = filename
		params.headers = headers

		--network.request( "http://localhost:8080/booking/upload/uploadImage", "POST", networkListener, params )
		network.upload( url , "PUT", networkListener, params, filename, baseDirectory, contentType )]]
	
	end
	
	------------------------------------
    -- Actualiza los datos del usuario
	--@param idUser usuario con que se iniciara el chat
    -------------------------------------
    --RestManager.saveProfile = function(name, residence, accommodation, vehicle, available, hobbies, language)
	RestManager.saveLocationProfile = function( residence, idResidence )
		
		local settings = DBManager.getSettings()
		local site = settings.url
        local url = site.."api/saveLocationProfile/format/json"
		url = url.."/idApp/" .. settings.idApp
		if idResidence ~= '' then
			url = url.."/residence/" .. urlencode(residence)
			url = url.."/idResidence/" .. urlencode(idResidence)
		end
        local function callback(event)
            if ( event.isError ) then
				returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						returnLocationProfile( true, data.message)
					else
						returnLocationProfile( false, "error al guardar los datos del perfil")
					end
				else
					returnLocationProfile( false, "error al guardar los datos del perfil")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	-------------------------------------
    -- Obtiene la lista de hobbies
    -------------------------------------
    RestManager.getHobbies = function()
        local url = site.."api/getHobbies/format/json"
		url = url.."/idApp/" .. settings.idApp
		print(url)
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						setList( data.hobbies, data.language, data.sport, data.residenceTime, data.race, data.workArea, data.gender )
					else
						noConnectionMessages("Error con el servidor. Intentelo mas tarde")
					end
				else
					noConnectionMessages("Error con el servidor. Intentelo mas tarde")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	---------------------------------- Pantalla FILTER ----------------------------------
    -------------------------------------
    -- Obtiene los usuarios por ubicacion
    -------------------------------------
    RestManager.getCity = function(city,name,parent, itemOption)
        local url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
		url = url .. city
		--url = url.."&language=en"
		url = url.."&types=(cities)&key=AIzaSyA01vZmL-1IdxCCJevyBdZSEYJ04Wu2EWE"
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.status == "OK" then
						if( name == "hometown" ) then
							OptionLocationHt(data.predictions)
						elseif( name == "welcome" ) then
							OptionLocationWc(data.predictions)
						else
							showCities(data.predictions, name, parent, itemOption)
						end
						
					elseif data.status == "ZERO_RESULTS" then
						showCities(0, name, parent)
					end
				else
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	---------------------------------- Pantalla WELCOME ----------------------------------
    -------------------------------------
    -- valida que la ciudad exista
    -------------------------------------
    RestManager.getValidateCity = function(city)
        local url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
		url = url .. city
		--url = url.."&language=en"
		url = url.."&types=(cities)&key=AIzaSyA01vZmL-1IdxCCJevyBdZSEYJ04Wu2EWE"
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.status == "OK" then
						if(#data.predictions == 1) then
							returnValidateCity(true)
						else
							returnValidateCity(false)
						end
					elseif data.status == "ZERO_RESULTS" then
						returnValidateCity(false)
					end
				else
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
    -------------------------------------
    -- valida que la ciudad exista
    -------------------------------------
    RestManager.getRandomCities = function(city)
        RandomCities()
    end
	
	function RandomCities()
        local url = site.."api/getRandomCities/format/json"
		url = url.."/idApp/" .. settings.idApp
	
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						getCityById( data.item.residenciaId)
					else
						noConnectionMessages("Error con el servidor. Intentelo mas tarde")
					end
				else
					noConnectionMessages("Error con el servidor. Intentelo mas tarde")
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	function getCityById(cityId)
		local url = "https://maps.googleapis.com/maps/api/place/details/json?placeid="
		url = url .. cityId
		--url = url.."&language=en"
		url = url.."&types=(cities)&key=AIzaSyA01vZmL-1IdxCCJevyBdZSEYJ04Wu2EWE"
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.status == "OK" then
						printRandomCities(data.result.formatted_address, cityId);
					elseif data.status == "INVALID_REQUEST" then
						RandomCities()
					end
				else
					printRandomCities(false, false);
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
	end
	
    ---------------------------------- Metodos Comunes ----------------------------------
    -------------------------------------
    -- Redirije al metodo de la escena
    -- @param obj registros de la consulta
    -------------------------------------
    function goToMethod(obj)
        if obj.name == "HomeAvatars" then
            getFirstCards(obj.items)
		elseif  obj.name == "UserAvatars" then
			getUserPerfil(obj.items[1], obj.after)
		elseif  obj.name == "MessagesAvatars" then
			setItemsListMessages(obj.items)
		elseif  obj.name == "MessageAvatars" then
			setImagePerfilMessage(obj.items[1])
        elseif  obj.name == "ProfileAvatars" then
			setImagePerfil(obj.items)
        end
    end 

    -------------------------------------
    -- Carga de la imagen del servidor o de TemporaryDirectory
    -- @param obj registros de la consulta con la propiedad image
    ------------------------------------- 
    function loadImage(obj)
		
        -- Next Image
        if obj.idx < #obj.items then
			
            -- actualizamos index
            obj.idx = obj.idx + 1
            -- Determinamos si la imagen existe
           -- local img = obj.items[obj.idx].image
			local img2 = obj.items[obj.idx].image2
			local img = obj.items[obj.idx].image
            local path = system.pathForFile( img, system.TemporaryDirectory )
            local fhd = io.open( path )
            if fhd then
                -- Existe la imagen
                fhd:close()
                loadImage(obj)
            else
                local function imageListener( event )
                    if ( event.isError ) then
                    else
                        -- Eliminamos la imagen creada
						if event.target then
							event.target:removeSelf()
							event.target = nil
							loadImage(obj)
						else
							obj.items[obj.idx].image = "avatar.png"
							obj.items[obj.idx].identifier = nil
							obj.idx = obj.idx - 1
							loadImage(obj)
						end
                    end
                end
                -- Descargamos de la nube
				local url
				
				if obj.items[obj.idx].identifier then
					local sizeAvatar = 'width=550&height=550'
					url = "http://graph.facebook.com/".. obj.items[obj.idx].identifier .."/picture?large&"..sizeAvatar
					
				else
					url = img2
				end
                display.loadRemoteImage( url ,"GET", imageListener, img, system.TemporaryDirectory ) 
            end
        else
            -- Dirigimos al metodo pertinente
            goToMethod(obj)
        end
    end
	
	-------------------------------------
    -- obiene la fecha y hora actual
    -------------------------------------
	RestManager.getDate = function()
		local date = os.date( "*t" )    -- Returns table of date & time values
		local year = date.year
		local month = date.month
		local month2 = date.month
		local day = date.day
		local hour = date.hour
		local minute = date.min
		local segunds = date.sec 
		
		if month < 10 then
			month = "0" .. month
		end
		
		if day < 10 then
			day = "0" .. day
		end
		
		local date1 = year .. "-" .. month .. "-" .. day .. " " .. hour .. ":" .. minute .. ":" .. segunds
		
		local months = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}
		date2 = day .. " de " .. months[month2] .. " del " .. year
		
		local datesArray = {day = day,month = month,year = year}
		
		return {date1,date2,datesArray}
	end
	
	--------------------------------------------
    -- comprueba si existe conexion a internet
    --------------------------------------------
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end
	
return RestManager