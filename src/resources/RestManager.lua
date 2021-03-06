---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local RestManager = {}

	---------------------------------------------------------------------------------
	-- OBJETOS Y VARIABLES
	---------------------------------------------------------------------------------
	-- Includes
	local mime = require("mime")
	local json = require("json")
	require('src.resources.Globals')
	local crypto = require("crypto")
	local openssl = require( "plugin.openssl" )
	local cipher = openssl.get_cipher("aes-256-cbc")
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
	-----------------------------------------------
    -- da de alta un nuevo usuario por facebook
	--@params informacion del nuevo usuario
    -----------------------------------------------
	RestManager.createUser = function(userLogin, email, password, name, gender, birthday, location, facebookId, playerId)
	
		settings = DBManager.getSettings()
		site = settings.url
		
		password = encryptedPass(password)
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
		
        -- Set url
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/userLogin/"..urlencode(userLogin)
		url = url.."/email/"..urlencode(email)
		url = url.."/pass/"..urlencode(password)
		url = url.."/language/"..urlencode(settings.language)
		if name ~= "" then
			url = url.."/name/"..urlencode(name)
		end
		if gender ~= "" then
			url = url.."/gender/"..urlencode(gender)
		end
		if birthday ~= "" then
			url = url.."/birthday/"..urlencode(birthday)
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
	
	-----------------------------------------------
    -- Encrypta la contraseña por openssl
	-- @params pass contraseña a encriptar
    -----------------------------------------------
	function encryptedPass(pass)
		local encryptedData = cipher:encrypt ( pass, "key" )
		local mime = require ( "mime" )
		local encryptedData = mime.b64 ( cipher:encrypt ( pass, "key" ) )
		return encryptedData
	end
	
	---------------------------------- Pantalla Login ----------------------------------
	-------------------------------------
    -- da de alta un nuevo usuario
	-- @params usuario, email, contraseña y token de notificaciones
    -------------------------------------
	RestManager.createUserNormal = function(userLogin, email, password, playerId)
	
		settings = DBManager.getSettings()
		site = settings.url
		
		password = encryptedPass(password)
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
        -- Set url
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/userLogin/"..urlencode(userLogin)
		url = url.."/email/"..urlencode(email)
		url = url.."/pass/"..urlencode(password)
		url = url.."/playerId/"..urlencode(playerId)
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				gotoHomeUN( language.RMTryLater, "login", false )
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
					gotoHomeUN( language.RMTryLater, "login", false )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--------------------------
	-- valida el logueo
	-- @params email, contraseña y token de notificaciones
	-------------------------
	RestManager.validateUser = function( email, password, playerId )
	
		settings = DBManager.getSettings()
		site = settings.url
	
		password = encryptedPass(password)
		
		password = string.gsub( password, "/", '&#47;' )
		password = string.gsub( password, "\\", '&#92;' )
		password = string.gsub( password, "%%", '&#37;' )
		-- Set url
        local url = site
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/email/"..urlencode(email)
		url = url.."/password/"..urlencode(password)
		url = url.."/playerId/"..urlencode(playerId)
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				gotoHomeUN( language.RMTryLater, "login", false )
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
					gotoHomeUN( language.RMTryLater, "login", false )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
		
	end
	
	---------------------------------- Pantalla Messages ----------------------------------
	
    ---------------------------------------
    -- Obtiene la lista de los mensajes
    ---------------------------------------
	RestManager.getListMessageChat = function()
	
		settings = DBManager.getSettings()
		site = settings.url
	
        -- Set url
        local url = site
        url = url.."api/getListMessageChat/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/timeZone/" .. urlencode(timeZone)
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
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
						noConnectionMessages(language.RMErrorServer)
					end
				else
					noConnectionMessages(language.RMErrorServer)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			--notifica si no existe conexion a internet
			noConnectionMessages(language.RMNoInternetConnection)
		end
    end
	
	---------------------------------- Pantalla Message ----------------------------------
	
    -------------------------------------
    -- Obtiene los mensajes del chat seleccionado
    -- @param channelId identificador del canal de los mensajes
    -------------------------------------
	RestManager.getChatMessages = function(channelId)
	
		settings = DBManager.getSettings()
		site = settings.url
        -- Set url
        local url = site
        url = url.."api/getChatMessages/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/channelId/".. channelId
		url = url.."/timeZone/" .. urlencode(timeZone)
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
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
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMErrorServer)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			--notifica si no existe conexion a internet
			noConnectionMessage(language.RMNoInternetConnection)
		end
    end
	
	------------------------------------------------------------
    -- Envia los mensajes del chat
    -- @param channelId identificador del canal de los mensajes
	-- @param message mensaje a enviar
	-- @param poscM posicion en la que esta colocado el chat
    ------------------------------------------------------------
	RestManager.sendChat = function(channelId, message, poscM)
		settings = DBManager.getSettings()
		site = settings.url
        -- Set url
        local url = site
		url = url.."api/saveChat2"
		
		local function networkListener( event )
			if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
			else
				local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							--cambia la fecha en la que se envio el mensaje
							changeDateOfMSG(data.items[1],poscM)
						else
							noConnectionMessage(language.RMErrorServer)
						end
					else
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMErrorServer)
				end
			end
		end

		local headers = {}

		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"

		local body = ""
		body = body.."idApp=" .. settings.idApp
		body = body.."&channelId=" .. channelId
		body = body.."&message=" .. message
		body = body.."&timeZone=" .. timeZone
		body = body.."&language=".. settings.language
		
		local params = {}
		params.headers = headers
		params.body = body
		
        -- Do request
		if networkConnection then
			network.request( url, "POST", networkListener, params )
		else
			noConnectionMessage(language.RMNoInternetConnection)
		end
		
    end
	
	---------------------------------------
    -- Obtiene los mensajes no leidos
    ---------------------------------------
	RestManager.getMessagesByChannel = function(channelId)
	
		settings = DBManager.getSettings()
		site = settings.url
		local url = site
        url = url.."api/getMessagesByChannel/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/timeZone/" .. urlencode(timeZone)
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local items = data.items
						local lastRead = data.lastRead
						showNewMessages( items, lastRead )
					else
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMErrorServer)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage(language.RMNoInternetConnection)
		end
	end
	
	--------------------------------------------------------------------
    -- Bloquea o desbloquea el chat selecionado
    -- @param channelId identificador del canal de los mensajes
	-- @param status define si el canal estara bloqueado o desbloqueado
    --------------------------------------------------------------------
	RestManager.blokedChat = function(channelId,status)
		settings = DBManager.getSettings()
		site = settings.url
        -- Set url
        local url = site
        url = url.."api/blokedChat/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/status/" .. status
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						--bloquea o desbloquea el chats
						changeStatusBlock(data.status)
					else
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMNoInternetConnection)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage(language.RMErrorServer)
		end
    end
	
	---------------------------------------------------------------
    -- marca los mensajes como leidos
    -- @param channelId identificador del canal de los mensajes
	-- @param idMessage identificador del mensaje
    ---------------------------------------------------------------
	RestManager.changeStatusMessages = function(channelId,idMessage)
        settings = DBManager.getSettings()
		site = settings.url
        -- Set url
        local url = settings.url
        url = url.."api/changeStatusMessages/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/channelId/" .. channelId
		url = url.."/idMessage/" .. idMessage
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						--elimina las burbujas de mensajes no leidos
						deleteNotBubble()
					else
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMErrorServer)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage(language.RMNoInternetConnection)
		end
    end
	
	--------------------------------------------------------------------
    -- Obtiene el avatar de messajes, en caso de no existir en fichero interno
    -- @param item informacion
    --------------------------------------------------------------------
	RestManager.getImagePerfilMessage = function( recipientId )
		settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getImagePerfilMessage/format/json"
        url = url.."/idApp/" .. settings.idApp
		url = url.."/recipientId/" .. recipientId
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages(language.RMErrorServer)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if #data.items > 0 then
							--cargamos los elementos del mensaje
							loadImage({idx = 0, name = "MessageAvatars", path = "assets/img/avatar/", items = data.items})
						else
							--notificamos que no existen chats
							noConnectionMessage(language.RMErrorServer)
						end
					else
						noConnectionMessage(language.RMErrorServer)
					end
				else
					noConnectionMessage(language.RMErrorServer)
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			noConnectionMessage(language.RMNoInternetConnection)
		end
    end

    ---------------------------------- Pantalla HOME ----------------------------------
	
	---------------------------------------------------------------------
    -- Obtiene los datos del usuario por id
	-- @params after indica que pasara cuando se consulten los datos
    ---------------------------------------------------------------------
    RestManager.getUsersById = function(after)
		settings = DBManager.getSettings()
		local site = settings.url
        local url = site.."api/getUsersById/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/language/"..urlencode(settings.language)
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
		url = url.."/language/"..urlencode(settings.language)
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
	
    -----------------------------------------
    -- Obtiene los usuarios por ubicacion
	-- @params limit paginador
    -----------------------------------------
    RestManager.getUsersByCity = function(limit)
		settings = DBManager.getSettings()
		local settFilter = DBManager.getSettingFilter()
        local url = site.."api/getUsersByCity/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/version/v2"
		url = url.."/city/" 	.. urlencode(settFilter.cityId)
		url = url.."/limit/" .. urlencode(limit)
		url = url.."/language/"..urlencode(settings.language)
		
        local function callback(event)
            if ( event.isError ) then
				HomeError( language.RMErrorServer )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						setTotalCard(data.total)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						if data.error then
							HomeError( language.RMErrorServer )
						else
							HomeError(data.message)
						end
					end
				else
					HomeError( language.RMErrorServer )
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
		url = url.."/version/v2"
		url = url.."/city/" 	.. urlencode(settFilter.cityId)
		url = url.."/genH/" 	.. settFilter.genH
		url = url.."/genM/" 	.. settFilter.genM
		url = url.."/iniAge/" 	.. settFilter.iniAge
		url = url.."/endAge/" 	.. settFilter.endAge
		url = url.."/limit/" .. urlencode(limit)
		url = url.."/language/"..urlencode(settings.language)
		
        local function callback(event)
            if ( event.isError ) then
				HomeError( language.RMErrorServer )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						setTotalCard(data.total)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						if data.error then
							HomeError( language.RMErrorServer )
						else
							HomeError(data.message)
						end
					end
				else
					HomeError( language.RMErrorServer )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	 ---------------------------------------
    -- Obtiene los usuarios falsos
	-- @params limit paginador
    ---------------------------------------
    RestManager.getUsersDemo = function(limit)
		settings = DBManager.getSettings()
		local settFilter = DBManager.getSettingFilter()
        local url = site.."api/getUsersDemo/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/city/" 	.. 0
		url = url.."/version/v2"
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				HomeError( language.RMErrorServer )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						setTotalCard(data.total)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						if data.error then
							HomeError( language.RMErrorServer )
						else
							HomeError(data.message)
						end
					end
				else
					HomeError( language.RMErrorServer )
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
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/clearUser/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				resultCleanUser( false, data.message)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						resultCleanUser( true, data.message )
					else
						resultCleanUser( false, language.RMErrorLogOut )
					end
				else
					resultCleanUser( false, language.RMErrorLogOut )
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
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/updatePlayerId/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/playerId/"..urlencode(playerId)
        -- Do request
		network.request( url, "GET", callback )
    end
	
	--------------------------------------------------
    -- Obtiene el numero total de chats sin leer
    --------------------------------------------------
    RestManager.getUnreadChats = function()
		settings = DBManager.getSettings()
		site = settings.url
	
        -- Set url
        local url = site
        url = url.."api/getUnreadChats/format/json"
        url = url.."/idApp/"..settings.idApp
		
        local function callback(event)
            if ( event.isError ) then
				--noConnectionMessages( language.RMErrorServer )
				print( language.RMErrorServer )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						unreadChats = data.items
						require('src.Tools')
						bubble()
					else
						--noConnectionMessages( language.RMErrorServer )
					end
				else
					--noConnectionMessages( language.RMErrorServer )
				end
            end
            return true
        end
        -- Do request
		if networkConnection then
			network.request( url, "GET", callback )
		else
			--notifica si no existe conexion a internet
			--noConnectionMessages( language.RMNoInternetConnection )
		end
    end
	
	
	---------------------------------- Pantalla PROFILE ----------------------------------
    -------------------------------------
    -- Inicia una nueva conversacion con los usuarios
	--@param idUser usuario con que se iniciara el chat
    -------------------------------------
    RestManager.startConversation = function(idUser)
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/startConversation/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/idUser/" .. idUser
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				
            else
                local data = json.decode(event.response)
				if data then
					showNewConversation(data.item)
				end
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
	RestManager.saveProfile = function(UserName, birthdate, hobbies, name, lastName, gender, originCountry, residence, residenceTime, accommodation, vehicle, food, languages, race, workArea, ownAccount, pet, sport, smoke, drink, psychrotrophic, idResidence )
		settings = DBManager.getSettings()
		site = settings.url
		
		local hobbies2 = json.encode(hobbies)
		local language2 = json.encode(languages)
		local sport2 = json.encode(sport)
        local url = site.."api/saveProfile/format/json"
		url = url.."/idApp/" .. settings.idApp
		if UserName ~= 'UserName' then
			url = url.."/UserName/" .. urlencode(UserName)
		end
		if birthdate ~= '0000-00-00' then
			url = url.."/birthdate/" .. urlencode(birthdate)
		end
		if name ~= '' then
			url = url.."/name/" .. urlencode(name)
		end
		if lastName ~= '' then
			url = url.."/lastName/" .. urlencode(lastName)
		end
		if gender ~= language.MpSelect then
			url = url.."/gender/" .. urlencode(gender)
		end
		if originCountry ~= '' then
			url = url.."/originCountry/" .. urlencode(originCountry)
		end
		if residence ~= '' then
			url = url.."/residence/" .. urlencode(residence)
		end
		if idResidence ~= '' then
			url = url.."/idResidence/" .. urlencode(idResidence)
		end
		if residenceTime ~= language.MpSelect then
			url = url.."/residenceTime/" .. urlencode(residenceTime)
		end
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
						resultSaveProfile( false, language.RMErrorSavingProfile)
					end
				else
					resultSaveProfile( false, language.RMErrorSavingProfile)
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
	
		
		-- Callback function to handle the upload events that are generated.
		-- There will be several events: one to indicate the start and end of the
		-- process and several to indicate the progress (depends on the file size).
		-- Always test for your error conditions!
		 
		local function uploadListener( event )
			if ( event.isError ) then
				print( "Network Errorr." )
				print( "Status:", event.status )
				print( "Response:", event.response )
				native.showAlert( "Gluglis", "Network Errorr.", { "OK" } )
			else
				if ( event.phase == "began" ) then
					print( "Upload started" )
				elseif ( event.phase == "progress" ) then
					print( "Uploading... bytes transferred ", event.bytesTransferred )
				elseif ( event.phase == "ended" ) then
					print( "Upload ended..." )
					print( "Status:", event.status )
					print( "Response:", event.response )
					if event.status == 201 then
						changeImageAvatar(json.decode(event.response))
					end
				end
			end
		end
		 
		-- Sepcify the URL of the PHP script to upload to. Do this on your own server.
		-- Also define the method as "PUT".
		local url = "http://www.gluglis.travel/gluglis_api/UploadImage/uploadImage"
		local method = "PUT"
		 
		-- Set some reasonable parameters for the upload process:
		local params = {
			timeout = 60,
			progress = true,
			bodyType = "text"
		}
		 
		-- Specify what file to upload and where to upload it from.
		-- Also, set the MIME type of the file so that the server knows what to expect.
		local filename =  photophoto .. ".png"
		local baseDirectory = system.TemporaryDirectory
		local contentType = "image/jpeg"  --another option is "text/plain"
		 
		local headers = {}

		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		headers.filename = filename
		params.headers = headers
		 
		network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
		
	end
	
	---------------------------------------------------------
    -- Guarda la residencia actual de usuario
	-- @param residence Nombre de la ciudad
	-- @param idResidence place_id de la ciudad
    ----------------------------------------------------------
	RestManager.saveLocationProfile = function( residence, idResidence )
		
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/saveLocationProfile/format/json"
		url = url.."/idApp/" .. settings.idApp
		if idResidence ~= '' then
			url = url.."/residence/" .. urlencode(residence)
			url = url.."/idResidence/" .. urlencode(idResidence)
		end
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						returnLocationProfile( true, data.message)
					else
						returnLocationProfile( false, language.RMErrorSavingProfile )
					end
				else
					returnLocationProfile( false, language.RMErrorSavingProfile )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	-------------------------------------
    -- Valida seleccion de ciudad
    -------------------------------------
    RestManager.getLocation = function()
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/getLocation/format/json"
		url = url.."/idApp/" .. settings.idApp
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if ( not(data.success) ) then
						toHometown()
					end
				end
            end
            return true
        end
        -- Do request
        print(url)
		network.request( url, "GET", callback )
    end
	
	-------------------------------------
    -- Obtiene la lista de hobbies, lenguajes
    -------------------------------------
    RestManager.getHobbies = function()
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/getHobbies/format/json"
		url = url.."/idApp/" .. settings.idApp
		url = url.."/language/"..urlencode(settings.language)
        local function callback(event)
            if ( event.isError ) then
				--noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						setList( data.hobbies, data.language, data.sport, data.residenceTime, data.race, data.workArea, data.gender )
					else
						--noConnectionMessages("Error con el servidor. Intentelo mas tarde")
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
	
	---------------------------------- Pantalla FILTER ----------------------------------
    ---------------------------------------------------------------------
    -- Obtiene los usuarios por ubicacion
	-- @params city nombre de la ciudad
	-- @params name nombre de la pantalla
	-- @params parent donde se inserta los datos
	-- @params itemOption coordenadas y tamaño de los componentes
    ---------------------------------------------------------------------
    RestManager.getCity = function(city,name,parent, itemOption)
		settings = DBManager.getSettings()
		site = settings.url
        local url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
		url = url .. urlencode(city)
		url = url.."&language=en"
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
	
	---------------------------------------------------------------------
	-- Obtiene la identificacion del lugar en ingles
	-- @params city nombre de la ciudad
	-- @params name nombre de la pantalla
	-- @params parent donde se inserta los datos
	-- @params itemOption coordenadas y tamaño de los componentes
	---------------------------------------------------------------------
	RestManager.getCityEn = function(city,name,parent, itemOption)
		settings = DBManager.getSettings()
		site = settings.url
        local url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
		url = url .. urlencode(city)
		url = url.."&language=en"
		url = url.."&types=(cities)&key=AIzaSyA01vZmL-1IdxCCJevyBdZSEYJ04Wu2EWE"
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.status == "OK" then
						if( name == "hometown" ) then
							setItemCityHt(data.predictions)
						elseif( name == "welcome" ) then
							setItemCityWc(data.predictions)
						elseif( name == "location" ) then
							getCityFilter(data.predictions)
						elseif( name == "residence" ) then
							getCityProfile(data.predictions)
						end
						
					elseif data.status == "ZERO_RESULTS" then
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
		settings = DBManager.getSettings()
		site = settings.url
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
		settings = DBManager.getSettings()
		site = settings.url
        RandomCities()
    end
	
	------------------------------------------
    -- Obtiene las ciudades aleatoriamente
    ------------------------------------------
	function RandomCities()
		settings = DBManager.getSettings()
		site = settings.url
        local url = site.."api/getRandomCities/format/json"
		url = url.."/idApp/" .. settings.idApp
		
        local function callback(event)
            if ( event.isError ) then
				noConnectionMessages( language.RMErrorServer )
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						getCityById( data.item.residenciaId)
					else
						noConnectionMessages( language.RMErrorServer )
					end
				else
					noConnectionMessages( language.RMErrorServer )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	----------------------------------------------
    -- Obtiene las ciudades por identificador
    ----------------------------------------------
	function getCityById(cityId)
		settings = DBManager.getSettings()
		site = settings.url
		local url = "https://maps.googleapis.com/maps/api/place/details/json?placeid="
		url = url .. cityId
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
			setImagePerfilMessage(obj.items)
        elseif  obj.name == "ProfileAvatars" then
			setImagePerfil(obj.items[1].image)
		elseif  obj.name == "ProfileAvatars" then
			setImagePerfil(obj.items[1].image)
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
					local sizeAvatar = 'width=720&height=720'
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
    -- Cambia la nueva imagen subida al servidor a TemporaryDirectory
    -- @param obj registros de la consulta con la propiedad image
    ------------------------------------- 
    function changeImageAvatar(photophoto)
        -- Next Image
		-- Determinamos si la imagen existe para eliminarla
           
		local function imageListener2( event )
			if ( event.isError ) then
			else
				-- Eliminamos la imagen creada
				if event.target then
					event.target:removeSelf()
					event.target = nil
					setImagePerfil(photophoto)
				else
					setImagePerfil("avatar.png")
				end
			end
		end
		-- Descargamos de la nube
		local url = "http://gluglis.travel/gluglis_api/assets/img/avatar/" .. photophoto
		
		display.loadRemoteImage( url ,"GET", imageListener2, photophoto, system.TemporaryDirectory ) 
		-- Dirigimos al metodo pertinente
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
		
		local months = { language.RMJanuary, language.RMFebruary, language.RMMarch, language.RMApril, language.RMMay, language.RMJune, language.RMJuly, language.RMAugust, language.RMSeptember, language.RMOctober, language.RMNovember, language.RMDecember }
		date2 = day .. "/" .. month2 .. "/" .. year
		
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