---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

-----------------------------------------
--------------- aundio ------------------
-----------------------------------------

-- Set the audio mix mode to allow sounds from the app to mix with other sounds from the device
if audio.supportsSessionProperty == true then
    print("supportsSessionProperty is true")
	audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)
end
	 
-- Store whether other audio is playing.  It's important to do this once and store the result now,
-- as referring to audio.OtherAudioIsPlaying later gives misleading results, since at that point
-- the app itself may be playing audio
isOtherAudioPlaying = false
	 
if audio.supportsSessionProperty == true then
	print("supportsSessionProperty is true")
	if not(audio.getSessionProperty(audio.OtherAudioIsPlaying) == 0) then
		print("I think there is other Audio Playing")
		isOtherAudioPlaying = true
	end
end

--Includes
display.setStatusBar( display.TranslucentStatusBar )
local json = require("json")
require('src.resources.Globals')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
display.setDefault( "background", 0 )

--obtiene el usuario y/o crea la base de datos local
local isUser = DBManager.setupSquema()

--obtiene la configuracion de usuario
local setting = DBManager.getSettings()
--obtiene los lenguajes disponibles
language = require('src.resources.Language')
--asigna el lenguaje 
if setting.language == "es" then language = language.es
elseif setting.language == "en" then language = language.en
elseif setting.language == "it" then language = language.it
elseif setting.language == "de" then language = language.de 
elseif setting.language == "fr" then language = language.fr 
elseif setting.language == "zh" then language = language.zh
elseif setting.language == "he" then language = language.he 
else language = language.en end

--verifica que exista un usuario logueado
if isUser then
	composer.removeScene( "src.Welcome" )
	composer.gotoScene( "src.Welcome", { time = 400, effect = "fade"})
else
	composer.removeScene( "src.LoginSplash" )
	composer.gotoScene("src.LoginSplash")
end
---------------------Notificaciones---------------------------

------------------------------------------------
-- evento cuando se recibe y abre una notificacion
-- @param message mensaje de la notificacion
-- @param additionalData identificador y tipo de mensaje
-- @param isActive indica si la app esta abierta
------------------------------------------------
function DidReceiveRemoteNotification(message, additionalData, isActive)
	print("LLego una notificacion")
	--determina si la aplicacion esta activa
    if isActive then
		if (additionalData) then
			--define el tipo de notificacion
			if additionalData.type == "1" then
				local item = json.decode(additionalData.item)
				local currScene = composer.getSceneName( "current" )
				--si la scena actual es message pinta los nuevos mensajes 
				if currScene == "src.Message" then
				else
					system.vibrate()
					local RestManager = require('src.resources.RestManager')
					RestManager.getUnreadChats()
				end
				--si la scena messages existe acomoda los chats
				local titleScene = composer.getScene( "src.Messages" )
				if titleScene then
					movedChat(item[1], item[1].message, item[1].NoRead)
				end
			end
		end
	--si no esta activa te manda al chat de la notificacion
	else
		if (additionalData) then
            local currScene = composer.getSceneName( "current" )
            if currScene == "src.Message" then
            elseif additionalData.type == "1" then
				local RestManager = require('src.resources.RestManager')
				local item = json.decode(additionalData.item)
				local tmpListMain = {}
				tmpListMain[1] = {id = item[1].id, image = item[1].image, image2 = item[1].image2, name = item[1].display_name, subject = item[1].message, channelId = item[1].channel_id, blockYour = item[1].blockYour, blockMe = item[1].blockMe, recipientId = item[1].id  }
				composer.removeScene( "src.Message" )
				composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = tmpListMain[1] } } )
			end
		end
	end
end

------------------------------------------------
-- inicializa el plugin de notificaciones
------------------------------------------------
local OneSignal = require("plugin.OneSignal")

OneSignal.Init("b7f8ee34-cf02-4671-8826-75d45b3aaa07", "836420576135", DidReceiveRemoteNotification)

------------------------------------------------
-- obtiene el token por telefono
------------------------------------------------
function IdsAvailable(playerID, pushToken)
	--OneSignal.ClearAllNotifications()
	playerId = playerID
end

------------------------------------------------
-- llama a la funcion para obtener el token del telefono
------------------------------------------------
OneSignal.IdsAvailableCallback(IdsAvailable)