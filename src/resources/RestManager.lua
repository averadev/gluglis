--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	
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
	-------------------------------------
    -- da de alta un nuevo usuario por facebook
    -------------------------------------
	RestManager.createUser = function(email, password, name, gender, birthday, location, facebookId, playerId)
	
        -- Set url
		password = crypto.digest(crypto.md5, password)
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
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
			url = url.."/location/"..urlencode(location)
		end
		if facebookId ~= "" then
			url = url.."/facebookId/"..urlencode(facebookId)
		end
		url = url.."/playerId/"..urlencode(playerId)
	
        local function callback(event)
            if ( event.isError ) then
				print('error')
				--noConnectionMessages("Error con el servidor. Intentelo mas tarde")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						DBManager.updateUser(data.idApp, email, name)
						gotoHome()
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
	
	
	---------------------------------- Pantalla Login ----------------------------------
	-------------------------------------
    -- da de alta un nuevo usuario
    -------------------------------------
	RestManager.createUserNormal = function(email, password, playerId)
	
        -- Set url
		password = crypto.digest(crypto.md5, password)
        local url = site
        url = url.."api/createUser/format/json"
        url = url.."/idApp/"..settings.idApp
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
	
	RestManager.validateUser = function( email, password, playerId )
		-- Set url
		password = crypto.digest(crypto.md5, password)
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
	
	--obtiene el avatar de messajes, en caso de no existir en fichero interno
	RestManager.getImagePerfilMessage = function( item )
        loadImage({idx = 0, name = "MessageAvatars", path = "assets/img/avatar/", items = item})
    end

    ---------------------------------- Pantalla HOME ----------------------------------
	
	-------------------------------------
    -- Obtiene los datos del usuario por id
    -------------------------------------
    RestManager.getUsersById = function()
		local settings = DBManager.getSettings()
		local site = settings.url
        local url = site.."api/getUsersById/format/json"
		url = url.."/idApp/" .. settings.idApp
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if #data.items > 0 then
					loadImage({idx = 0, name = "UserAvatars", path = "assets/img/avatar/", items = data.items})
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
    -------------------------------------
    -- Obtiene los usuarios por ubicacion
    -------------------------------------
    RestManager.getUsersByCity = function()
        local url = site.."api/getUsersByCity/format/json"
		url = url.."/idApp/" .. settings.idApp
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
	RestManager.getUsersByFilter = function()
	
		local settFilter = DBManager.getSettingFilter()
		
        local url = site.."api/getUsersByFilter/format/json"
		url = url.."/idApp/" 	.. settings.idApp
		url = url.."/city/" 	.. urlencode(settFilter.city)
		url = url.."/iniDate/" 	.. urlencode(settFilter.iniDate)
		url = url.."/endDate/" 	.. urlencode(settFilter.endDate)
		url = url.."/genH/" 	.. settFilter.genH
		url = url.."/genM/" 	.. settFilter.genM
		url = url.."/iniAge/" 	.. settFilter.iniAge
		url = url.."/endAge/" 	.. settFilter.endAge
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local data = json.decode(event.response)
						loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
					else
						noConnectionMessage('Error con el servidor')
					end
				else
					noConnectionMessage('Error con el servidor')
				end
				--loadImage({idx = 0, name = "HomeAvatars", path = "assets/img/avatar/", items = data.items})
            end
            return true
        end
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
	
	---------------------------------- Pantalla FILTER ----------------------------------
    -------------------------------------
    -- Obtiene los usuarios por ubicacion
    -------------------------------------
    RestManager.getCity = function(city)
        local url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
		url = url .. city
		url = url.."&types=(cities)&key=AIzaSyA01vZmL-1IdxCCJevyBdZSEYJ04Wu2EWE"
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data then
					if data.status == "OK" then
						showCities(data.predictions)
					elseif data.status == "ZERO_RESULTS" then
						showCities(0)
					end
				else
				end
				--print(json.encode(event.response.status))
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
			getUserPerfil(obj.items[1])
		elseif  obj.name == "MessagesAvatars" then
			setItemsListMessages(obj.items)
		elseif  obj.name == "MessageAvatars" then
			setImagePerfilMessage(obj.items)
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
					url = site..obj.path..img
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
		
		return {date1,date2}
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