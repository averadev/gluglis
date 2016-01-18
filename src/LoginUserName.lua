---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
-- Gluglis 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local composer = require( "composer" )
local fxTap = audio.loadSound( "fx/click.wav")
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, grpMain, grpNew, grpLogIn, grpLoad
local scene = composer.newScene()

-- Variables
local newH = 0
local txtEmail, txtPass, txtRePass, txtEmailS, txtPassS
local btnNew, btnSignIn
local flag = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--regresa a la pantalla de login normal o login con FB
function moveBack(event)
	if grpLogIn.x == 0 then
		composer.gotoScene( "src.LoginSplash", { time = 400, effect = "crossFade" })
	else
		transition.to( grpLogIn, { x = 0, time = 400 } )
		transition.to( grpNew, { x = 768, time = 400 })
	end
end

--mueve a la pantalla de registro
function moveNew(event)
    local t = event.target
    t.alpha = .5
    transition.to( grpLogIn, { x = -768, time = 400 } )
    transition.to( grpNew, { x = 0, time = 400, onComplete = function() t.alpha = 1 end })
    
end

--manda a la pantalla de home(si el logueo fue exitoso)
function gotoHomeUN( message, name, success )
	local result = success
	tools:setLoading(false,grpLoad)
	if success then
		success = 1
	else
		success = 2
	end
	alertLogin(true,message,success)
	
	timeMarker = timer.performWithDelay( 2000, function()
		alertLogin(false,"",success)
		flag = 0
		if result then 
			composer.removeScene( "src.Home" )
			composer.gotoScene("src.Home", { time = 400, effect = "fade" } )
		end
	end, 1 )
end

function toLogIn( event )
	if flag == 0 then
		flag = 1
		--trim
		local textEmail = string.gsub(txtEmailS.text , "%s", "")
		local textPass = string.gsub(txtPassS.text , "%s", "")
		if textEmail ~= "" and textPass ~= "" then
			tools:setLoading(true,grpLoad)
			RestManager.validateUser( textEmail, textPass, 11 )
		else
			alertLogin(true,"Campos vacios",2)
			timeMarker = timer.performWithDelay( 2000, function()
				alertLogin(false,"",2)
				flag = 0
			end, 1 )
		end
	end
	return true
end

function doCreate( event )
	if flag == 0 then
		flag = 1
		local textEmail = string.gsub(txtEmail.text , "%s", "")
		local textPass = string.gsub(txtPass.text , "%s", "")
		local textRePass = string.gsub(txtRePass.text , "%s", "")
		if textEmail ~= "" and textPass ~= "" and textRePass ~= "" then
			tools:setLoading(true,grpLoad)
			if textPass == textRePass then
				RestManager.createUserNormal(textEmail, textPass, "", "", "", playerId)
			else
				
				alertLogin(true,"Contraseñas distintas",2)
				timeMarker = timer.performWithDelay( 2000, function()
					alertLogin(false,"",2)
					flag = 0
				end, 1 )
			end
		else
			alertLogin(true,"Campos vacios",2)
			timeMarker = timer.performWithDelay( 2000, function()
				alertLogin(false,"",2)
				flag = 0
			end, 1 )
		end
	end
	return true
end

function onTxtFocus(event)
end

--pinta las lineas requeridas
function getLine(parent, x, y)
    local line = display.newRect( x, y, intW, 6 )
    line:setFillColor( {
        type = 'gradient',
        color1 = { 1, .5 }, 
        color2 = { .3, .2 },
        direction = "top"
    } ) 
    parent:insert(line)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
	
	tools = Tools:new()
	
    local o = display.newRect( midW, midH + h, intW, intH )
    o:setFillColor( 232/255 )   
    screen:insert(o)
	
	-- Main options
	grpMain = display.newGroup()
    screen:insert(grpMain)
    grpMain.x = 0
	
	grpLoad = display.newGroup()
	screen:insert(grpLoad)
    grpLoad.y = intH - 150
	
    -- Logo on circle
    local circle1 = display.newCircle( grpMain, midW, (midH*.45), 160 )
    circle1:setFillColor( .84 )
    local circle2 = display.newCircle( grpMain, midW, (midH*.45), 145 )
    circle2:setFillColor( 1 )
    local logo = display.newImage( grpMain, "img/logo.png" )
    logo:translate( midW, (midH*.45) )
    
    -- Text Descrip
    newH = circle1.y + (circle1.height / 2) + 50
    local lblTitle = display.newText({
        text = "Gluglis",     
        x = midW, y = newH,
        font = native.systemFont,   
        fontSize = 35, align = "center"
    })
    grpMain:insert(lblTitle)
    local lblSubTitle = display.newText({
        text = "an app to travel free",     
        x = midW, y = newH + 35,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    lblSubTitle:setFillColor( 69/255, 189/255, 222/255 )
    grpMain:insert(lblSubTitle)
    
    --local midR = in
    -- Create New
	local midR = midW
    grpNew = display.newGroup()
    screen:insert(grpNew)
	grpNew.x = intW
    local btnBack = display.newImage( grpNew, "img/btnBack.png" )
    btnBack:translate( midR - 335, midH - 45 )
    btnBack:addEventListener( 'tap', moveBack)
    -- Set Lines
    getLine(grpNew, midR, midH)
    getLine(grpNew, midR, midH + 100)
    getLine(grpNew, midR, midH + 200)
    getLine(grpNew, midR, midH + 300)
    -- Set text email
    local lblEmail = display.newText({
        text = "E-mail:",     
        x = midR - 190, y = midH + 50,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
    lblEmail:setFillColor( .52 )
    grpNew:insert(lblEmail)
    txtEmail = native.newTextField( midR + 100, midH + 50, 400, 70 )
    txtEmail.inputType = "email"
    txtEmail.hasBackground = false
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtEmail)
    -- Set text password
    local lblPass = display.newText({
        text = "Contraseña:",     
        x = midR - 190, y = midH + 150,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPass:setFillColor( .52 )
    grpNew:insert(lblPass)
    txtPass = native.newTextField( midR + 100, midH + 150, 400, 70 )
    txtPass.inputType = "password"
    txtPass.hasBackground = false
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtPass)
    -- Set text re-password
    local lblRePass = display.newText({
        text = "Re-Contraseña:",     
        x = midR - 190, y = midH + 250,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRePass:setFillColor( .52 )
    grpNew:insert(lblRePass)
    txtRePass = native.newTextField( midR + 100, midH + 250, 400, 70 )
    txtRePass.inputType = "password"
    txtRePass.hasBackground = false
    txtRePass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtRePass)
    -- Button
    btnNew = display.newRect( midR, midH + 450, intW, 100 )
    btnNew:setFillColor( 128/255, 72/255, 149/255 )
    btnNew:addEventListener( 'tap', doCreate )
    grpNew:insert(btnNew)
    local lblRegistrar = display.newText({
        text = "Registrarme",     
        x = midR + 70, y = midH + 450,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRegistrar:setFillColor( 217/255, 200/255, 223/255 )
    grpNew:insert(lblRegistrar)
    local icoRegistrar = display.newImage( grpNew, "img/icoRegistrar.png" )
    icoRegistrar:translate( midR - 80, midH + 450 )
    
    midR = midW
    -- LogIn
    grpLogIn = display.newGroup()
    screen:insert(grpLogIn)
    local btnBack2 = display.newImage( grpLogIn, "img/btnBack.png" )
    btnBack2:translate( midR - 335, midH - 45 )
    btnBack2:addEventListener( 'tap', moveBack)
    -- Set Lines
	getLine(grpLogIn, midR, midH)
    getLine(grpLogIn, midR, midH + 100)
    getLine(grpLogIn, midR, midH + 200)
    -- Set text email
    local lblEmailS = display.newText({
        text = "E-mail:",     
        x = midR - 190, y = midH + 50,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
    lblEmailS:setFillColor( .52 )
    grpLogIn:insert(lblEmailS)
    txtEmailS = native.newTextField( midR + 100, midH + 50, 400, 70 )
    txtEmailS.inputType = "email"
    txtEmailS.hasBackground = false
    txtEmailS:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtEmailS)
    -- Set text password
    local lblPassS = display.newText({
        text = "Contraseña:",     
        x = midR - 190, y = midH + 150,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPassS:setFillColor( .52 )
    grpLogIn:insert(lblPassS)
    txtPassS = native.newTextField( midR + 100, midH + 150, 400, 70 )
    txtPassS.inputType = "default"
	txtPassS.isSecure = true
    txtPassS.hasBackground = false
    txtPassS:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtPassS)
    -- Button
	btnSignIn = display.newRect( midR, midH + 290, intW, 100 )
    btnSignIn:setFillColor( 128/255, 72/255, 149/255 )
    btnSignIn:addEventListener( 'tap', toLogIn )
    grpLogIn:insert(btnSignIn)
    local lblSignIn = display.newText({
        text = "Acceder",     
        x = midR + 70, y = midH + 290,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblSignIn:setFillColor( 220/255, 186/255, 218/255 )
    grpLogIn:insert(lblSignIn)
    local icoLogIn = display.newImage( grpLogIn, "img/icoLogIn.png" )
    icoLogIn:translate( midR - 80, midH + 290 )
	
	local btnRegister = display.newRect( midR, midH + 400, intW, 100 )
    btnRegister:setFillColor( 128/255, 72/255, 149/255 )
    btnRegister:addEventListener( 'tap', moveNew)
    grpLogIn:insert(btnRegister)
    local lblRegister = display.newText({
        text = "Nuevo Usuario",     
        x = midR + 70, y = midH + 400,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRegister:setFillColor( 220/255, 186/255, 218/255 )
    grpLogIn:insert(lblRegister)
    local icoLogIn = display.newImage( grpLogIn, "img/icoRegistrar.png" )
    icoLogIn:translate( midR - 80, midH + 400 )
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
	alertLogin(false,"",success)
	--destruye los textField
	if grpLogIn then
		grpLogIn:removeSelf()
		grpLogIn = nil
	end
	if grpNew then
		grpNew:removeSelf()
		grpNew = nil
	end
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene