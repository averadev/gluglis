---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------
--------- aundio ----------
---------------------------
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

display.setStatusBar( display.TranslucentStatusBar )
local json = require("json")
require('src.resources.Globals')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
display.setDefault( "background", 0 )

local isUser = DBManager.setupSquema()

--local setting = DBManager.getSettings()
--Globals.language = Globals.language.setting.language
language = require('src.resources.Language')
--if setting.language == "es" then language = language.es
--elseif setting.language == "en" then language = language.en end
language = language.es

if isUser then
	composer.gotoScene( "src.Home", { time = 400, effect = "fade"})
else
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
	--determina si la aplicacion esta activa
    if isActive then
		if (additionalData) then
			--define el tipo de notificacion
			if additionalData.type == "1" then
				local item = json.decode(additionalData.item)
				local currScene = composer.getSceneName( "current" )
				--si la scena actual es message pinta los nuevos mensajes 
				if currScene == "src.Message" then
					--displaysInList(item[1], false )
				else
					system.vibrate()
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
				tmpListMain[1] = {id = item[1].id, image = item[1].image, image2 = item[1].image2, name = item[1].display_name, subject = item[1].message, channelId = item[1].channel_id, blockYour = item[1].blockYour, blockMe = item[1].blockMe }
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
	playerId = playerID
end

------------------------------------------------
-- llama a la funcion para obtener el token del telefono
------------------------------------------------
OneSignal.IdsAvailableCallback(IdsAvailable)