---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
-- Gluglis 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
local json = require("json")
local widget = require( "widget" )
require('src.resources.Globals')
local composer = require( "composer" )
local facebook = require("plugin.facebook.v4")
local fxTap = audio.loadSound( "fx/click.wav")
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, grpScreens
local scene = composer.newScene()

-- Variables
local subFig = ""
local bgSplash2
local idxScr = 1
local wFixScr = 1.25
local wScrPhone = 402
local circles = {}
local sshots = {}
local labelTitle, labelSubTitle, grpTerms

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

----------------------------------------------------
-- Llama a la pantalla de login o registro normal
----------------------------------------------------
function toLoginUserName(event)
    composer.removeScene( "src.LoginUserName" )
	composer.gotoScene( "src.LoginUserName", { time = 400, effect = "crossFade" })
end

-------------------------------------------
-- Muestra la aplicacion sin loquearse
-------------------------------------------
function toLoginFree( event )
	isReadOnly = true
	composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

----------------------------------------------------------
--llama a la pantalla de home(si el logueo fue exitoso)
----------------------------------------------------------
function gotoHome(SignUp)
	isReadOnly = false
	if( SignUp ) then
		composer.removeScene( "src.Welcome" )
		composer.gotoScene( "src.Welcome", { time = 400, effect = "fade", params = { type = "SignUp" }})
	else
		composer.removeScene( "src.Welcome" )
		composer.gotoScene( "src.Welcome", { time = 400, effect = "crossFade" })
	end
end

----------------------------------------------------------
-- llama a terminos y condiciones
----------------------------------------------------------
function tapTerms()
	
    if not(grpTerms) then
        grpTerms = display.newGroup()
        screen:insert(grpTerms)

        function setDes(event)
            return true
        end
        local bg = display.newRect( midW, midH, intW, intH )
        bg:setFillColor( .85 )
        bg:addEventListener( 'tap', setDes)
        bg.alpha = .3
        grpTerms:insert(bg)
        
        local bgContent = display.newRect( midW, midH, intW - 140, intH - 300 )
        bgContent:setFillColor( 1 )
        grpTerms:insert(bgContent)
        
        local sc = widget.newScrollView(
        {
            width = intW - 140,
            height = intH - 360
        })
        sc.x = midW
        sc.y = midH
        grpTerms:insert(sc)
        
        local lblTTitle = display.newText( {
            text = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
            x = midW - 70, y = 50,
            font = native.systemFontBold,  
            width = intW - 200, fontSize = 20, align = "center"
        })
        lblTTitle:setFillColor( .7 )
        sc:insert(lblTTitle)
        
        local cY = 100
        local lblC = {}
        for i = 1, #conA do
            lblC[i] = display.newText( {
                text = conA[i],
                x = midW - 70, y = 50,
                font = native.systemFontBold,  
                width = intW - 240, fontSize = 20
            })
            lblC[i].anchorY = 0
            lblC[i].y = cY
            lblC[i]:setFillColor( .7 )
            sc:insert(lblC[i])
            
            cY = cY + lblC[i].contentHeight + 30
        end
        
        local iconClose = display.newImage("img/iconClose.png", true) 
        iconClose.x = intW - 100
        iconClose.y = 180
        iconClose:addEventListener( "tap", tapTerms )
        grpTerms:insert(iconClose)
        
    else
        if grpTerms then
            grpTerms:removeSelf()
            grpTerms = nil
        end
    end
end

----------------------------------------------------------------
--evento que se dispara cuando se inicia el loqueo por face
----------------------------------------------------------------
function facebookListener( event )
	--pide los datos del usuario
    if ( "session" == event.type ) then
		local params = { fields = "id,name,first_name,last_name,gender,locale,email,birthday,location" }
        facebook.request( "me", "GET", params )
	--resibe los datos pedidos y verifica el loqueo
    elseif ( "request" == event.type ) then
        local response = event.response
		if ( not event.isError ) then
	        response = json.decode( event.response )
			
			--si devuelve los datos verifica el correo
            if not (response.email == nil) then
				-- Birthday user
				local birthday = ""
                if not (response.birthday == nil) then
					local t = {}
					for mo, da, ye in string.gmatch( response.birthday, "(%w+)/(%w+)/(%w+)" ) do
						t[1] = mo
						t[2] = da
						t[3] = ye
					end
					birthday = t[3] .. "-" .. t[1] .. "-" .. t[2] .. " " .. "00:00:00"
                end
				local location = ""
                if not (response.location == nil) then
					location = response.location.name
                end
				local userLogin = response.first_name .. response.last_name
				userLogin = string.gsub(userLogin , "%s", "")
                RestManager.createUser(userLogin, response.email, '', response.name, response.gender, birthday, location, response.id, playerId)
            end
        else
			-- printTable( event.response, "Post Failed Response", 3 )
		end
    end
end

--------------------------------
--login por medio de facebook
--------------------------------
function loginFB(event)
	--se inicia el login y pide los perrmisos
    facebook.login( facebookListener, {"public_profile","email","user_birthday","user_location"} )
end
----------------------------------------------
-- Le da movimiento a las pantallas del cel
----------------------------------------------
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
----------------------------------------
-- Mueve el encabezado y los circulos
----------------------------------------
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
		labelTitle.y = 140
		labelTitle.text = "ESTA POR COMENZAR,\nEL MEJOR VIAJE DE TU VIDA..." 
		labelSubTitle.alpha = 0
		if (intH < 1300) then
			labelTitle.y = 130
		end
	else
		labelTitle.y = 90
		labelSubTitle.alpha = 1
		if idx == 2 then 
			labelTitle.text = "CONOCE A TUS ANFITRIONES..." 
			labelSubTitle.text = "¿A dondé? ¿con que tipo de persona \nte gustaría conectarte?"
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
    --bg
    local o = display.newRect( midW, midH + h, intW+8, intH )
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
    
    -- pantallas del celular
    for i = 1, 4 do
		sshots[i] = display.newImage("img/bgk/screen"..i..subFig..".png", true) 
        sshots[i].x = midW + 402
        sshots[i].anchorY  = 1
        sshots[i].y = posYBg - 135
        grpScreens:insert(sshots[i])
    end
    sshots[1].x = midW
	
	--screen superior
	bgSplash2 = display.newImage("img/bgk/bgPhone"..subFig..".png", true)
	bgSplash2.anchorX = 0
    bgSplash2.x = 0
    bgSplash2.anchorY  = 1
    bgSplash2.y = posYBg
    screen:insert(bgSplash2)
	
	--bg del segundo splash
	local bgPink = display.newRect( midW, posYBg - 110, intW, intH - posYBg + 400  )
	bgPink.anchorY = 0
	bgPink:setFillColor( 99/255, 53/255, 137/255 )
	screen:insert(bgPink)
	--splash de los edificioa
	local bgSplash3 = display.newImage("img/bgk/vectores_ciudad" .. subFig .. ".png", true) 
    bgSplash3.x = midW
    bgSplash3.anchorY = 1
    bgSplash3.y = posYBg - 80
    screen:insert(bgSplash3)
	
	--title heard
	local bgTextHeard = display.newRect( midW, 60, intW, 160  )
	bgTextHeard.anchorY = 0
	bgTextHeard:setFillColor( .3 )
	screen:insert(bgTextHeard)
	bgTextHeard.alpha = .3
	
	labelTitle = display.newText( {
		text = "ESTA POR COMENZAR,\nEL MEJOR VIAJE DE TU VIDA...",
		x = midW, y = 140,
		font = native.systemFontBold,  
		width = intW,
		fontSize = 30, align = "center"
	})
	labelTitle:setFillColor( 1 )
	screen:insert(labelTitle)
	labelSubTitle = display.newText( {
		text = "",
		x = midW, y = 160,
		font = native.systemFont,  
		width = intW - 100, height = 100,
		fontSize = 24, align = "center"
	})
	labelSubTitle:setFillColor( 1 )
	screen:insert(labelSubTitle)
	labelSubTitle.alpha = 0
	
	if (intH < 1300) then
		bgTextHeard.y = 50
		labelTitle.y = 130
	end
	
	-- posicion de los circulos
	for i = 1, 4 do
		circles[i] = display.newCircle(  260 + (i * 50), posYBg - 100, 8 )
		circles[i]:setFillColor( 182/255, 207/255, 229/255 )
		screen:insert(circles[i])
    end
    circles[1]:setFillColor( 75/255, 176/255, 217/255 )
	
	-- recalcular posicion
     if (intH > 1366) then
        xtra = intH - (posYBg+200)
        if xtra > 0 then
            posYBg = posYBg + (xtra/4)
        end
    end
    
	posYBg = posYBg - 80
	
    -- boton FB
    local btnShadow = display.newImage("img/bgShadow.png", true) 
    btnShadow.x = midW
    btnShadow.y = posYBg + 100
    screen:insert(btnShadow)
	
	local bgBtn = display.newRoundedRect( midW, posYBg + 70, 600, 105, 10 )
	bgBtn:setFillColor( 0, 51/255, 86/255 )
	screen:insert(bgBtn)
    
    local btn = display.newRoundedRect( midW, posYBg + 65, 600, 95, 10 )
	btn:setFillColor( 0, 109/255, 175/255 )
    btn:addEventListener( "tap", loginFB )
	screen:insert(btn)
	
	local lblBtn = display.newText( {
        text = "CONECTATE CON FACEBOOK",
        x = midW, y = posYBg + 67,
        font = native.systemFontBold,  
        fontSize = 32, align = "center"
    })
	lblBtn:setFillColor( 1 )
    screen:insert(lblBtn)
	
    -- User / Email
    local bgBtnUserName = display.newRect( 240, posYBg + 178, 200, 100 )
	bgBtnUserName:setFillColor( 0 )
    bgBtnUserName.alpha = .02
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	screen:insert(bgBtnUserName)
	
	local lblBottom = display.newText( {
        text = "INGRESA CON: USUARIO Ó CORREO",
        x = 220, y = posYBg + 178,
        font = native.systemFontBold,  
        width = 250,
        fontSize = 22, align = "right"
    })
    lblBottom:setFillColor( 1 )
    screen:insert(lblBottom)
	
	local lineSep = display.newRect( midW, posYBg + 177, 8, 40 )
	lineSep:setFillColor( .6 )
	screen:insert(lineSep)
	
	-- free app
    local bgBtnFree = display.newRect( 510, posYBg + 178, 200, 100 )
	bgBtnFree:setFillColor( 0 )
    bgBtnFree.alpha = .02
    bgBtnFree:addEventListener( "tap", toLoginFree )
	screen:insert(bgBtnFree)
	
	local lblFree = display.newText( {
        text = "CONOCE MÁS SOBRE LA APLICACIÓN",
        x = 550, y = posYBg + 178,
        font = native.systemFontBold,  
        width = 250,
        fontSize = 22, align = "left"
    })
    lblFree:setFillColor( 1 )
    screen:insert(lblFree)
    
    -- Terms
	chkOn = display.newImage("img/checkOn.png", true)
	chkOn:translate(130, posYBg + 245)
    screen:insert(chkOn)
    local lblTerms1 = display.newText( {
        text = "Al iniciar sesión usted está aceptando los",
        x = midW+30, y = posYBg + 237,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms1:setFillColor( .8 )
    screen:insert(lblTerms1)
    local lblTerms2 = display.newText( {
        text = "términos y condiciones.",
        x = midW+30, y = posYBg + 255,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms2:setFillColor( .5,.5,1 )
    screen:insert(lblTerms2)
    
    
    local btnTerms = display.newRect( 360, posYBg + 245, 400, 50 )
	btnTerms.alpha = .02
    btnTerms:addEventListener( "tap", tapTerms )
	screen:insert(btnTerms)
    
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