---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- Gluglis 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.resources.Globals')
local composer = require( "composer" )
local fxTap = audio.loadSound( "fx/click.wav")
local facebook = require("plugin.facebook.v4")
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local json = require("json")

-- Grupos y Contenedores
local screen, grpScreens
local scene = composer.newScene()

-- Variables
local newH = 0
local h = display.topStatusBarContentHeight
local txtEmail, txtPass, txtRePass, txtEmailS, txtPassS
local subFig = ""
local bgSplash1, bgSplash2
local idxScr = 1
local wFixScr = 1.25
local wScrPhone = 402

local circles = {}
local sshots = {}
local labelTitle, labelSubTitle

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function toLoginUserName(event)
    --composer.removeScene( "src.LoginUserName" )
    --composer.gotoScene( "src.LoginUserName", { time = 400, effect = "crossFade" })
end

function gotoHome()
	composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function facebookListener( event )

    if ( "session" == event.type ) then
		local params = { fields = "id,name,first_name,last_name,gender,locale,email" }
        facebook.request( "me", "GET", params )

    elseif ( "request" == event.type ) then
        local response = event.response
		if ( not event.isError ) then
	        response = json.decode( event.response )
            if not (response.email == nil) then
                RestManager.createUser(response.email, '', response.name, response.gender, response.id, playerId)
            end
        else
			-- printTable( event.response, "Post Failed Response", 3 )
		end
    end
end

function loginFB(event)
	--RestManager.createUser("a", '', "a", "male", "111", "000")
    facebook.login( facebookListener, {"public_profile","email"} )
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" then
        direction = 0
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart)
        if direction == 0 then
            if x < -10 and idxScr < 4 then
                direction = 1
            elseif x > 10 and idxScr > 1 then
                direction = -1
            end
        elseif direction == 1 then
            -- Mover pantalla
            if x < 0 and x > -320 then
                if idxScr < 4 then
                    sshots[idxScr].x = midW + (x * wFixScr)
                    sshots[idxScr + 1].x = (midW + wScrPhone) + (x * wFixScr)
                end
            end
        elseif direction == -1 then
			---print(x)
            if x > 0 and x < 240 then
                if idxScr > 1 then
                    sshots[idxScr].x = midW + (x * wFixScr)
                    sshots[idxScr - 1].x = (midW - wScrPhone) + (x * wFixScr)
                end
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local x = (event.x - event.xStart)
        if direction == 1 then
            if x > -150 then 
                -- Cancel
                transition.to( sshots[idxScr], { x = midW, time = 200 })
                transition.to( sshots[idxScr+1], { x = midW + wScrPhone, time = 200 })
            else 
                -- Do
                transition.to( sshots[idxScr], { x = midW - wScrPhone, time = 200 })
                transition.to( sshots[idxScr+1], { x = midW, time = 200 })
                newScr(idxScr+1)
            end
        end
         -- Inter Screens left to rigth
		if direction == -1 then
			--print('adios')
            if x < 150 then 
                -- Cancel
                transition.to( sshots[idxScr], { x = midW, time = 200 })
                transition.to( sshots[idxScr-1], { x = midW + wScrPhone, time = 200 })
            else 
                -- Do
                transition.to( sshots[idxScr], { x = midW + wScrPhone, time = 200 })
                transition.to( sshots[idxScr-1], { x = midW, time = 200 })
                newScr(idxScr-1)
            end
        end
    end
end

function newScr(idx)
    idxScr = idx
    direction = 0
    circles[idx]:setFillColor( 75/255, 176/255, 217/255 )
    if idx > 1 then
        circles[idx-1]:setFillColor( 182/255, 207/255, 229/255 )
    end
    if idx < 4 then
        circles[idx+1]:setFillColor( 182/255, 207/255, 229/255 )
    end
	
	if idx == 1 then 
		labelTitle.y = 120
		labelTitle.text = "ESTA POR COMENZAR,\nEL MEJOR VIAJE DE TU VIDA..." 
		labelSubTitle.alpha = 0
	else
		labelTitle.y = 80
		labelSubTitle.alpha = 1
		if idx == 2 then 
			labelTitle.text = "CONOCE A TUS ANFITRIONES..." 
			labelSubTitle.text = "¿A donde? ¿con que tipo de persona \nte gustaria conectarte?"
		end
		if idx == 3 then 
			labelTitle.text = "CONOCE QUIEN SERÁ TU PRÓXIMO GUÍA  " 
			labelSubTitle.text = "Navega entre las personas que cumplen con el perfil \nque Tu estas búscando y conoce más acerca de ellos."
		end
		if idx == 4 then 
			labelTitle.text = "CONVERSA CON ELLOS" 
			labelSubTitle.text = "Abre una conversación privada con los usuarios \nque desees y conócelos más para definir \nquien te acompañara en tu próximo viaje."
		end
	end
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
    
    local o = display.newRect( midW, midH + h, intW, intH )
    o:setFillColor( 1 )   
    screen:insert(o)
	local posYBg = intH - 200
    if (intH > 1366) then
        posYBg = 1166
    elseif (intH < 1100) then
        subFig = "XMin"
        wScrPhone = 260
        wFixScr = .76
		posYBg = posYBg + 30
    elseif (intH < 1300) then
        subFig = "Min"
        wScrPhone = 350
        wFixScr = .97
		posYBg = posYBg + 30
    end
	
	grpScreens = display.newGroup()
	screen:insert(grpScreens)
    
    -- screens
    for i = 1, 4 do
		sshots[i] = display.newImage("img/bgk/screen"..i..subFig..".png", true) 
        sshots[i].x = midW + 402
        sshots[i].anchorY  = 1
        sshots[i].y = posYBg - 135
        grpScreens:insert(sshots[i])
    end
    sshots[1].x = midW
	
	bgSplash2 = display.newImage("img/bgk/bgPhone"..subFig..".png", true)
	bgSplash2.anchorX = 0
    bgSplash2.x = 0
    bgSplash2.anchorY  = 1
    bgSplash2.y = posYBg
    screen:insert(bgSplash2)
	
	local bgPink = display.newRect( midW, posYBg - 110, intW, intH - posYBg + 400  )
	bgPink.anchorY = 0
	bgPink:setFillColor( 99/255, 53/255, 137/255 )
	screen:insert(bgPink)
	
	bgSplash2 = display.newImage("img/bgk/vectores_ciudad" .. subFig .. ".png", true) 
    bgSplash2.x = midW
    bgSplash2.anchorY = 1
    bgSplash2.y = posYBg - 80
    screen:insert(bgSplash2)
	
	--title heard
	
	local bgTextHeard = display.newRect( midW, 50, intW, 150  )
	bgTextHeard.anchorY = 0
	bgTextHeard:setFillColor( .3 )
	screen:insert(bgTextHeard)
	bgTextHeard.alpha = .3
	
	labelTitle = display.newText( {
		text = "ESTA POR COMENZAR,\nEL MEJOR VIAJE DE TU VIDA...",
		x = midW, y = 120,
		font = native.systemFontBold,  
		width = intW,
		fontSize = 30, align = "center"
	})
	labelTitle:setFillColor( 1 )
	screen:insert(labelTitle)
	
	labelSubTitle = display.newText( {
		text = "",
		x = midW, y = 145,
		font = native.systemFont,  
		width = intW - 100, height = 80,
		fontSize = 24, align = "center"
	})
	labelSubTitle:setFillColor( 1 )
	screen:insert(labelSubTitle)
	labelSubTitle.alpha = 0
	
	-- Circles position
	for i = 1, 4 do
        circles[i] = display.newRoundedRect( 260 + (i * 50), posYBg - 100, 30, 30, 16 )
        circles[i]:setFillColor( 182/255, 207/255, 229/255 )
        screen:insert(circles[i])
    end
    circles[1]:setFillColor( 75/255, 176/255, 217/255 )
	
	-- Recalculate position
     if (intH > 1366) then
        xtra = intH - (posYBg+200)
        if xtra > 0 then
            posYBg = posYBg + (xtra/4)
        end
    end
    
	posYBg = posYBg - 80
	
    -- Btn FB
    local btnShadow = display.newImage("img/bgShadow.png", true) 
    btnShadow.x = midW
    btnShadow.y = posYBg + 115
    screen:insert(btnShadow)
	
	local bgBtn = display.newRoundedRect( midW, posYBg + 85, 600, 105, 10 )
	bgBtn:setFillColor( 0, 51/255, 86/255 )
	screen:insert(bgBtn)
    
    local btn = display.newRoundedRect( midW, posYBg + 80, 600, 95, 10 )
	btn:setFillColor( 0, 109/255, 175/255 )
    btn:addEventListener( "tap", loginFB )
	screen:insert(btn)
	
	local lblBtn = display.newText( {
        text = "CONECTATE CON FACEBOOK",
        x = midW, y = posYBg + 82,
        font = native.systemFontBold,  
        fontSize = 32, align = "center"
    })
	lblBtn:setFillColor( 1 )
    screen:insert(lblBtn)
	
	-- User / Email
    local bgBtnUserName = display.newRect( 240, posYBg + 198, 200, 100 )
	bgBtnUserName:setFillColor( 0 )
    bgBtnUserName.alpha = .02
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	screen:insert(bgBtnUserName)
	
	local lblBottom = display.newText( {
        text = "INGRESA CON: USUARIO Ó CORREO",
        x = 240, y = posYBg + 198,
        font = native.systemFontBold,  
        width = 200,
        fontSize = 24, align = "right"
    })
    lblBottom:setFillColor( 1 )
    screen:insert(lblBottom)
	
	local lineSep = display.newRect( midW, posYBg + 197, 8, 40 )
	lineSep:setFillColor( .6 )
	screen:insert(lineSep)
	
	local lblFree = display.newText( {
        text = "CONOCE MÁS SOBRE LA APLICACIÓN",
        x = 530, y = posYBg + 198,
        font = native.systemFontBold,  
        width = 200,
        fontSize = 24, align = "left"
    })
    lblFree:setFillColor( 1 )
    screen:insert(lblFree)
    
	screen:addEventListener( "touch", touchScreen )
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene