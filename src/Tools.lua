---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
require('src.resources.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local facebook = require("plugin.facebook.v4")
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local scrMenu, bgShadow, grpNewAlert, grpAlertLogin, grpScrCity, avatar, loopAvatar, loadAvatar
local btnBackFunction = false
local iconChat, iconChat2, lblIconChat

Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local filtroGdacs, headLogo, bottomCheck, grpLoading, grpLoadingPerson, grpConnection, grpNoMessages
    local h = display.topStatusBarContentHeight
    local fxTap = audio.loadSound( "fx/click.wav")
    self.y = h
	
    -------------------------------
    -- Creamos la el toolbar
	-------------------------------
    function self:buildHeader()
		if not bgShadow then 
			bgShadow = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
			bgShadow.alpha = 0
			bgShadow.anchorX = 0
			bgShadow.anchorY = 0
			bgShadow:setFillColor( 0 )
        end
		
		local bgToolbar0 = display.newRect( midW, 84, display.contentWidth, 10 )
		bgToolbar0.anchorY = 0
		bgToolbar0:setFillColor( 103/255, 67/255, 123/255 )
		self:insert( bgToolbar0 )
		
		bgToolbar = display.newRect( midW, 0, display.contentWidth, 90 )
		bgToolbar.anchorY = 0
		bgToolbar:setFillColor( 68/255, 14/255, 98/255 )
		self:insert( bgToolbar )
		
        local currentScene = composer.getSceneName( "current" )
        if currentScene == "src.Home" or currentScene == "src.Welcome"  then
            -- Iconos Home
            local iconMenu = display.newImage("img/menu.png")
            iconMenu:translate(80, 45)
			iconMenu.screen = 'Menu'
            iconMenu:addEventListener( 'tap', toScreen)
            self:insert( iconMenu )
        else
			bgIcoBack = display.newRect( (intW/3)/2, 0, intW/3, 90 )
			bgIcoBack.anchorY = 0
			bgIcoBack:setFillColor( 68/255, 14/255, 98/255 )
			bgIcoBack.screen = 'Home'
			bgIcoBack.alpha = .01
			bgIcoBack.isReturn = 1
			bgIcoBack:addEventListener( 'tap', toScreen)
			self:insert( bgIcoBack )
		
            local icoBack = display.newImage("img/Regresar-icono.png")
            icoBack:translate(60, 45)
            self:insert( icoBack )
			
			local lblIcoBack  = display.newText({
				text = language.TBack, 
				x = 130, y = 45,
				font = fontFamilyLight,   
				fontSize = 24, align = "left"
			})
			lblIcoBack:setFillColor( 1 )
			self:insert(lblIcoBack)
        end
		if currentScene ~= "src.Welcome" then
			if not isReadOnly then
				local bgIcoHome = display.newRect( midW, 0, intW/3, 90 )
				bgIcoHome.anchorY = 0
				bgIcoHome:setFillColor( 45/255, 10/255, 65/255 )
				bgIcoHome.screen = 'Welcome'
				bgIcoHome:addEventListener( 'tap', toScreen)
				self:insert( bgIcoHome )
				
				local iconHome = display.newImage("img/home.png")
				iconHome:translate(midW, 40)
				self:insert( iconHome )
			end
		end
		
		if not grpChats then	
			grpChats = display.newGroup()
			grpChats.y = h
			
			iconChat = display.newImage("img/mensajes.png")
			iconChat:translate(intW - 90, 75)
			iconChat.screen = 'Messages'
			iconChat:addEventListener( 'tap', toScreen)
			grpChats:insert( iconChat )
					
			iconChat2 = display.newImage("img/Mensajes_Notificacion.png")
			iconChat2:translate(intW - 90, 75)
			iconChat2.screen = 'Messages'
			iconChat2:addEventListener( 'tap', toScreen)
			grpChats:insert( iconChat2 )
			
			lblIconChat  = display.newText({
				text = "", 
				x = intW - 68, y = 42,
				width = 50,
				font = fontFamilyLight,   
				fontSize = 22, align = "center"
			})
			lblIconChat:setFillColor( 1 )
			grpChats:insert(lblIconChat)
			
		end
		
		if grpChats then
			local currentScene = composer.getSceneName( "current" )
			if currentScene == "src.Messages" or currentScene == "src.Message" then
				grpChats.alpha = 0
			else
				grpChats.alpha = 1
			end
		end
    end
	
	------------------------------------------------------------------------------
    -- Creamos loading
	-- @params isLoading indica si el loading se muestra u oculta
	-- @params parent grupo donde se insertara el componente
	------------------------------------------------------------------------------
    function self:setLoading(isLoading, parent)
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
			local bg = display.newRect( midW, midH, intW, intH )
            bg:setFillColor( .95 )
            bg.alpha = .3
            grpLoading:insert(bg)
			bg:addEventListener( 'tap', noAction )
            
            local sheet, loading
            if parent.cards then
                sheet = graphics.newImageSheet(Sprites.loadingMini.source, Sprites.loadingMini.frames)
                loading = display.newSprite(sheet, Sprites.loadingMini.sequences)
               
            else
                sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
                loading = display.newSprite(sheet, Sprites.loading.sequences)
            end
            loading.x = display.contentWidth / 2
            loading.y = parent.height / 2 
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
        else
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
        end
    end
	
	-------------------------------
    -- Efecto avatar
	-------------------------------
	function avatarBreath()
        if avatar.status == 1 then
            avatar.status = 0
            transition.to( avatar, {time = 900, width = 150, height = 150} )
            transition.to( loadAvatar, {time = 900, width = 150, height = 150} )
        else
            avatar.status = 1
            transition.to( avatar, {time = 900, width = 250, height = 250} )
            transition.to( loadAvatar, {time = 900, width = 260, height = 260} )
            
        end
    end
	
	-----------------------------------------------------------------------
    -- Creamos loading person
	-- @params isLoading indica si el loading se muestra u oculta
	-- @params parent grupo donde se insertara el componente
	-----------------------------------------------------------------------
	function self:setLoadingPerson(isLoading, parent)
        if isLoading then
            if grpLoadingPerson then
                grpLoadingPerson:removeSelf()
                grpLoadingPerson = nil
            end
            grpLoadingPerson = display.newGroup()
            parent:insert(grpLoadingPerson)
            
            local bg = display.newRect( (display.contentWidth / 2), (parent.height / 2), 
                display.contentWidth, parent.height )
            bg:setFillColor( .95 )
            bg.alpha = .3
            grpLoadingPerson:insert(bg)
            
            local config = DBManager.getSettings()
            if config.idAvatar then
                
                local posY = (parent.height / 2) - 128
                if not(config.idAvatar == '') then
                    avatar = display.newImage(config.idAvatar, system.TemporaryDirectory)
                else
                    avatar = display.newImage("img/tmpPerson.jpg")
                end

                avatar.status = 1
                avatar.x = display.contentWidth / 2
                avatar.y = posY
                avatar.width = 250
                avatar.height = 250
                grpLoadingPerson:insert(avatar)

                loadAvatar = display.newImage("img/bgk/loadAvatar.png")
                loadAvatar.x = display.contentWidth / 2
                loadAvatar.y = posY
                loadAvatar.width = 260
                loadAvatar.height = 260
                grpLoadingPerson:insert(loadAvatar)

                loopAvatar = timer.performWithDelay( 1000, avatarBreath, 0)
            end
            
        else
            timer.cancel( loopAvatar )
            if grpLoadingPerson then
                grpLoadingPerson:removeSelf()
                grpLoadingPerson = nil
            end
        end
    end
	
	------------------------------------------------------
	-- creacion de mensaje de problema con la conexion
	-- @params isConnection indica si el mensaje se muestra u oculta
	-- @params parent grupo donde se insertara el componente
	-- @params message Texto informativo
	------------------------------------------------------
	function self:noConnection(isConnection, parent, message)
		if isConnection then
            if grpConnection then
                grpConnection:removeSelf()
                grpConnection = nil
            end
            grpConnection = display.newGroup()
            parent:insert(grpConnection)
			
			local bgNoConection = display.newRect( midW, 150 + h, display.contentWidth, 80 )
			bgNoConection:setFillColor( 236/255, 151/255, 31/255, .7 )
			grpConnection:insert(bgNoConection)
			
			local lblNoConection = display.newText({
				text = message, 
				x = midW, y = 150 + h,
				font = fontFamilyLight,   
				fontSize = 34, align = "center"
			})
			lblNoConection:setFillColor( 1 )
			grpConnection:insert(lblNoConection)
            
        else
            if grpConnection then
                grpConnection:removeSelf()
                grpConnection = nil
            end
        end
	end
	
	---------------------------------------------------------------------
	-- creacion de mensaje cuando no se encuentren mensajes o canales
	-- @params isMesage indica si el mensaje se muestra u oculta
	-- @params parent grupo donde se insertara el componente
	-- @params message Texto informativo
	---------------------------------------------------------------------
	function self:NoMessages(isMesage, parent, message)
		if isMesage then
            if grpNoMessages then
                grpNoMessages:removeSelf()
                grpNoMessages = nil
            end
            grpNoMessages = display.newGroup()
            parent:insert(grpNoMessages)
			
			local titleNoMessages = display.newText({
				text = message,     
				x = midW, y = midH - 200,
				font = native.systemFontBold, width = intW - 50, 
				fontSize = 34, align = "center"
			})
			titleNoMessages:setFillColor( 0 )
			grpNoMessages:insert( titleNoMessages )
        else
            if grpNoMessages then
                grpNoMessages:removeSelf()
                grpNoMessages = nil
            end
        end
		return grpNoMessages
	end
	
	-----------------------
    -- Cambia las scenas
	-- @params event.target.screen scena
	-----------------------
    function toScreen(event)
		tools:setLoading(false,"")
        -- Animate    
        local t = event.target
        audio.play(fxTap)
        t.alpha = 0
        timer.performWithDelay(200, function() t.alpha = 1 end, 1)
        -- Change Screen
        if t.isReturn then
            composer.gotoScene("src.Home", { time = 400, effect = "slideRight" } )
        else
            composer.removeScene( "src."..t.screen )
			if t.screen == "MyProfile" then
				composer.gotoScene("src."..t.screen, { time = 400, effect = "fade", params = { item = itemProfile } } )
			elseif t.screen == "LoginSplash" then
				RestManager.clearUser()
			else
				composer.gotoScene("src."..t.screen, { time = 400, effect = "fade" } )
			end
        end
        return true
    end
    
	---------------------------------------------------------------
	-- Regresa a la scena anterior con el boton atras de android
	---------------------------------------------------------------
	function returnScene()
        composer.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
		return true
	end
	
	-------------------------
	-- Creamos una alerta
	-- @params isTrue indica si el mensaje se muestra u oculta
	-- @params text Texto informativo
	-------------------------
	function NewAlert(isTrue, text)
		if isTrue then
			if grpNewAlert then
				grpNewAlert:removeSelf()
				grpNewAlert = nil
			end
			grpNewAlert = display.newGroup()
			
			--combobox
			local bg0 = display.newRect( midW, midH + h, intW, intH )
			bg0:setFillColor( 0 )
			bg0.alpha = .8
			grpNewAlert:insert( bg0 )
			bg0:addEventListener( 'tap', noAction )
		
			local bg1 = display.newRoundedRect( midW, midH + h, 608, 310, 10 )
			bg1:setFillColor( 129/255, 61/255, 153/255 )
			grpNewAlert:insert( bg1 )
			
			local bg2 = display.newRoundedRect( midW, midH + h, 600, 300, 10 )
			bg2:setFillColor( 1 )
			grpNewAlert:insert( bg2 )
			
			local lbl0 = display.newText({
				text = text, 
				x = midW, y = midH + h,
				width = 500,
				font = 	fontFamilyLight,   
				fontSize = 38, align = "center"
			})
			lbl0:setFillColor( 0 )
			grpNewAlert:insert(lbl0)
		else
			if grpNewAlert then
				grpNewAlert:removeSelf()
				grpNewAlert = nil
			end
		end
	end
	
	------------------------------------------
	-- alerta que se despliega desde abajo
	-- @params isTrue indica si el mensaje se muestra u oculta
	-- @params typeS Indica si es un mensaje exitoso o no
	-- @params meessage Texto informativo
	------------------------------------------
	function alertLogin(isTrue, meessage, typeS)
		if isTrue then
			if grpAlertLogin then
				grpAlertLogin:removeSelf()
				grpAlertLogin = nil
			end
			
			grpAlertLogin = display.newGroup()
			grpAlertLogin.y = intH
		
			local bgIconPasswordLogin = display.newRect( intW/2, intH - 100, intW, 200 )
			if typeS == 1 then
				bgIconPasswordLogin:setFillColor( 68/255, 157/255, 68/255, .9 )
			else
				bgIconPasswordLogin:setFillColor( 236/255, 151/255, 31/255, .9 )
			end
			grpAlertLogin:insert(bgIconPasswordLogin)
		
			local title = display.newText( meessage, 0, 15, fontDefault, 40)
			title:setFillColor( 1 )
			title.x = display.contentWidth / 2
			title.y = intH - 140
			grpAlertLogin:insert(title)
		
			if typeS == 1 then
				iconMessageSignIn= display.newImage( "img/iconTickWhite.png"  )
			else
				iconMessageSignIn= display.newImage( "img/iconWarningWhite.png"  )
			end
			iconMessageSignIn.width = 70
			iconMessageSignIn.height = 70
			iconMessageSignIn.x = intW/2
			iconMessageSignIn.y = intH - 60
			grpAlertLogin:insert(iconMessageSignIn)
		
			transition.to( grpAlertLogin, { y = 0, time = 600, transition = easing.outExpo, onComplete=function() end })
		else
			if grpAlertLogin then
				transition.to( grpAlertLogin, { y = 200, time = 300, transition = easing.inQuint, onComplete=function()
					if grpAlertLogin then
						grpAlertLogin:removeSelf()
						grpAlertLogin = nil
					end
				end})
			end
		end
	end
	
	-------------------------------------------
	-- deshabilita los eventos tap no deseados
	-- deshabilita el traspaso del componentes
	-------------------------------------------
	function noAction( event )
		return true
	end
	
	-------------------------
	-- Elimina la lista de ciudades
	-------------------------
	function deleteGrpScrCity()
		if grpScrCity then
			componentActive = false
			grpScrCity:removeSelf()
			grpScrCity = nil
		end
	end
	
	--------------------------
	-- Selecciona la ciudad
	--------------------------
	function selectCity( event )
		native.setKeyboardFocus( nil )
		event.target.alpha = .5
		timeMarker = timer.performWithDelay( 100, function()
			event.target.alpha = 1
			if grpScrCity then
				grpScrCity:removeSelf()
				grpScrCity = nil
			end
			if event.target.name == "residence" then
				local itemOption = {posY = (intH/2 + h) - 100, posX = 335, height = 500, width = 538}
				RestManager.getCityEn(event.target.city, "residence", grpScrCity, itemOption )
				
			elseif event.target.name == "location" then
			
				local itemOption = {posY = (intH/2 + h) - 100, posX = 335, height = 500, width = 538}
	
				RestManager.getCityEn(event.target.city, "location", grpScrCity, itemOption )
			elseif event.target.name == "welcome" then
				getCityWelcome(event.target.city, event.target.id)
			end
		end, 1 )
		return true
	end
	
	-----------------------------------------------------------------
	-- Muestra una lista de las ciudades por el nombre
	-- @param item nombre de la ciudad y su pais
	-- @param name del elemento
	-- @param parent indica donde se insertara las opciones
	-- @param itemOption coordenadas y tamaño de las opciones
	-----------------------------------------------------------------
	function showCities( item, name, parent, itemOption )
		componentActive = "cities"
		--elimina los componentes para crear otros
		if grpScrCity then
			grpScrCity:removeSelf()
			grpScrCity = nil
		end
		--grp ciudad
		grpScrCity = display.newGroup()
		parent:insert( grpScrCity )
		
		local bgCompCity = display.newRect( itemOption.posX, itemOption.posY, itemOption.width, itemOption.height )
		bgCompCity.anchorY = 0
		bgCompCity:setFillColor( .88 )
		grpScrCity:insert(bgCompCity)
		bgCompCity:addEventListener( 'tap', noAction )
		
		if name == "residence" then
			bgCompCity.anchorY = 1
		end
		
		--pinta la lista de las ciudades
		if item ~= 0 then
			local posY = itemOption.posY + 2
			local posX = itemOption.posX
			if name == "residence" then
				posY = itemOption.posY - 103
			end
			local heightItem = 100
			local fontsize = 20
			if name == "welcome" then
				heightItem = 80
				fontsize = 25
			end
			for i = 1, #item do
				local bg0 = display.newRect( posX, posY, itemOption.width, heightItem )
				bg0.anchorY = 0
				bg0.city = item[i].description
				bg0.id = item[i].place_id
				bg0:setFillColor( 1 )
				grpScrCity:insert(bg0)
				bg0.name = name
				bg0:addEventListener( 'tap', selectCity )
			
				local lbl0 = display.newText({
					text = item[i].description, 
					x = posX, y = posY + (heightItem - (heightItem/2)),
					width = itemOption.width - 50,
					font = fontFamilyRegular,   
					fontSize = 22, align = "left"
				})
				lbl0:setFillColor( 0 )
				grpScrCity:insert(lbl0)
				if name == "residence" then
					posY = posY - (heightItem + 3)
				else
					posY = posY + (heightItem + 3)
				end
			end
			bgCompCity.height = (heightItem + 3) * #item + 2
		end
	end
	
    return self
end

-----------------------------------------------------------------
-- burbuja que muestra los mensaje no leidos por canal 
-----------------------------------------------------------------
function bubble()
	local currentScene = composer.getSceneName( "current" )
	if currentScene == "src.Messages" or currentScene == "src.Message" then
		grpChats.alpha = 0
	else
		grpChats.alpha = 1
	end
	
	if unreadChats > 0 then
		iconChat.alpha = 0
		iconChat2.alpha = 1
		lblIconChat.text = unreadChats
		native.setProperty( "applicationIconBadgeNumber", unreadChats )
	else
		iconChat.alpha = 1
		iconChat2.alpha = 0
		lblIconChat.text = ""
		native.setProperty( "applicationIconBadgeNumber", 0 )
	end
end

-----------------------------------------------------------------
-- Elimina la burbuja si no existe mensajes no leidos
-----------------------------------------------------------------
function noBubble()
	if grpChats then
		grpChats:removeSelf()
		grpChats = nil
	end
end

function keuEve()
	local openssl = require("plugin.openssl")
	local cipher = openssl.get_cipher("aes-256-cbc")
	local encryptedData = cipher:encrypt ( "text", "key" )
	local mime = require ( "mime" )
	local encryptedData = mime.b64 ( cipher:encrypt ( "text", "key" ) )
	return true
end


-----------------------------------------------------------------
-- Evento del boton atras de android
-----------------------------------------------------------------
local function onKeyEventBack( event )
	local phase = event.phase
	local keyName = event.keyName
	local platformName = system.getInfo( "platformName" )
	
	if( "back" == keyName and phase == "up" ) then
		if ( platformName == "Android" ) then
			if composer.getSceneName( "current" ) == "src.Home" then
				if componentActive == "menu" then
					--showMenu()
				else
				return false
				--return true
				end
			else
				print(componentActive)
				if componentActive == "multiComboBox" then
					hideOptionsLabels()
				elseif componentActive == "comboBox" then
					hideComboBox( "" )
				elseif componentActive == "cities" then
					deleteGrpScrCity()
				elseif componentActive == "datePicker" then
					destroyDatePicker2( "" )
				elseif componentActive == "blockChat" then
					blockedChatMsg( "", false, false )
				elseif componentActive == "PictureAvatar" then
					hideOptionSaveAvatar()
				elseif componentActive == "OptionAvatar" then
					hideoptionAvatar()
				elseif composer.getSceneName( "current" ) == "src.Welcome" then
					return false
				else
					returnScene()
				end
			end
			return true
		end
	end
	return false
end

-----------------------------------------------------------------
-- Activa el boton atras de android
-----------------------------------------------------------------
if btnBackFunction == false then
	btnBackFunction = true
	Runtime:addEventListener( "key", onKeyEventBack )
end





