---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
-- Gluglis 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local fxTap = audio.loadSound( "fx/click.wav")
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, grpMain, grpNew, grpLogIn, grpLoad
local scene = composer.newScene()

-- Variables
local newH = 0
local txtEmail, txtPass, txtRePass, txtEmailS, txtPassS, txtUser
local btnNew, btnSignIn
local flag = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-----------------------------------------------------------
-- Regresa a la pantalla de login normal o login con FB
-----------------------------------------------------------
function moveBack(event)
	if grpLogIn.x == 0 then
		composer.gotoScene( "src.LoginSplash", { time = 400, effect = "crossFade" })
	else
		transition.to( grpLogIn, { x = 0, time = 400 } )
		transition.to( grpNew, { x = 768, time = 400 })
	end
end

------------------------------------
--mueve a la pantalla de registro
------------------------------------
function moveNew(event)
    local t = event.target
    t.alpha = .5
    transition.to( grpLogIn, { x = -768, time = 400 } )
    transition.to( grpNew, { x = 0, time = 400, onComplete = function() t.alpha = 1 end })
    
end

---------------------------------------------------------
-- Manda a la pantalla de home(si el logueo fue exitoso)
-- @param message mensaje que regresa el logueo
-- @param name define si fue un registo o un logueo
-- @param success indica si fue exitoso el logueo
----------------------------------------------------------
function gotoHomeUN( message, name, success )
	isReadOnly = false
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
			if ( name == "login" ) then
				composer.removeScene( "src.Home" )
				composer.gotoScene("src.Home", { time = 400, effect = "fade" } )
			else
				composer.removeScene( "src.Hometown" )
				composer.gotoScene( "src.Hometown", { time = 400, effect = "fade"})
			end
		end
	end, 1 )
end

-----------------------------
-- Realiza el login normal
-----------------------------
function toLogIn( event )

	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end

	if flag == 0 then
		flag = 1
		--trim
		local textEmail = trimString(txtEmailS.text)
		local textPass = txtPassS.text
		if textEmail ~= "" and textPass ~= "" then
			tools:setLoading(true,grpLoad)
			RestManager.validateUser( textEmail, textPass, 11 )
		else
			alertLogin( true, language.LUNEmptyFields, 2 )
			timeMarker = timer.performWithDelay( 2000, function()
				alertLogin(false,"",2)
				flag = 0
			end, 1 )
		end
	end
	return true
end

--------------------------------------------
-- Realiza el registo de un nuevo usuario
--------------------------------------------
function doCreate( event )

	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end

	if flag == 0 then
		flag = 1
		-- trim  de los campos
		local textUser = trimString(txtUser.text)
		local textEmail = trimString(txtEmail.text)
		local textPass = txtPass.text
		local textRePass = txtRePass.text
		if textUser ~= "" and textEmail ~= "" and textPass ~= "" and textRePass ~= "" then
			tools:setLoading(true,grpLoad)
			if textPass == textRePass then
				RestManager.createUserNormal(textUser, textEmail, textPass, "", "", "", playerId)
			else
				alertLogin(true,language.LUNDifferentPass,2)
				timeMarker = timer.performWithDelay( 2000, function()
					alertLogin(false,"",2)
					flag = 0
				end, 1 )
			end
		else
			alertLogin(true,language.LUNEmptyFields,2)
			timeMarker = timer.performWithDelay( 2000, function()
				alertLogin(false,"",2)
				flag = 0
			end, 1 )
		end
	end
	return true
end

----------------------------------
-- event focus de los textField
----------------------------------
function onTxtFocus(event)
    if ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
        if event.target.action == 'new' then
            doCreate()
        else
            toLogIn()
        end
    end
end

---------------------------------
-- Pinta las lineas requeridas
---------------------------------
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
        
        txtUser.x = intW + 500
        txtEmail.x = intW + 500
        txtPass.x = intW + 500
        txtRePass.x = intW + 500
        txtEmailS.x = -500
        txtPassS.x = -500
    else
        
        txtUser.x = midW + 110
        txtEmail.x = midW + 110
        txtPass.x = midW + 110
        txtRePass.x = midW + 110
        txtEmailS.x = midW + 100
        txtPassS.x = midW + 100
        
        if grpTerms then
            grpTerms:removeSelf()
            grpTerms = nil
        end
    end
end
---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
	
	tools = Tools:new()
	
    local o = display.newRect( midW, midH + h, intW+8, intH )
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
    local circle1 = display.newCircle( grpMain, midW, (h+140), 120 )
    circle1:setFillColor( .84 )
    local circle2 = display.newCircle( grpMain, midW, (h+140), 110 )
    circle2:setFillColor( 1 )
    local logo = display.newImage( grpMain, "img/logo.png" )
    logo:scale(.7, .7)
    logo:translate( midW, (h+140) )
    
    
    -- Create New
	local midR = midW
    grpNew = display.newGroup()
    screen:insert(grpNew)
	grpNew.x = intW
    grpNew.y = -midH + 450
    print( -midH + 250)
    local btnBack = display.newImage( grpNew, "img/btnBack.png" )
    btnBack:translate( midR - 335, midH - 45 )
    btnBack:addEventListener( 'tap', moveBack)
    -- Set Lines
    getLine(grpNew, midR, midH)
    getLine(grpNew, midR, midH + 95)
    getLine(grpNew, midR, midH + 190)
    getLine(grpNew, midR, midH + 285)
	getLine(grpNew, midR, midH + 380)
	-- Set text email
    local lblUser = display.newText({
        text = language.LUNUser,     
        x = midR - 190, y = midH + 50,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
	lblUser:setFillColor( .52 )
    grpNew:insert(lblUser)
	txtUser = native.newTextField( midR + 110, midH + 50, 400, 70 )
    txtUser.inputType = "default"
    txtUser.action = "new"
    txtUser.hasBackground = false
    txtUser:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtUser)
    -- Set text email
    local lblEmail = display.newText({
        text = language.LUNEmail,     
        x = midR - 190, y = midH + 145,
        width = 240,
        font = native.systemFont,   
        align = "left",
        fontSize = 30
    })
    lblEmail:setFillColor( .52 )
    grpNew:insert(lblEmail)
    txtEmail = native.newTextField( midR + 110, midH + 145, 400, 70 )
    txtEmail.inputType = "email"
    txtEmail.action = "new"
    txtEmail.hasBackground = false
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtEmail)
    -- Set text password
    local lblPass = display.newText({
        text = language.LUNPass,     
        x = midR - 190, y = midH + 240,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPass:setFillColor( .52 )
    grpNew:insert(lblPass)
    txtPass = native.newTextField( midR + 110, midH + 240, 400, 70 )
    txtPass.inputType = "password"
    txtPass.action = "new"
    txtPass.hasBackground = false
	txtPass.isSecure = true
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtPass)
    -- Set text re-password
    local lblRePass = display.newText({
        text = language.LUNRePass,     
        x = midR - 190, y = midH + 335,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRePass:setFillColor( .52 )
    grpNew:insert(lblRePass)
    txtRePass = native.newTextField( midR + 110, midH + 335, 400, 70 )
    txtRePass.inputType = "password"
    txtRePass.action = "new"
    txtRePass.hasBackground = false
	txtRePass.isSecure = true
    txtRePass:addEventListener( "userInput", onTxtFocus )
	grpNew:insert(txtRePass)
    -- Button
    btnNew = display.newRect( midR, midH + 450, intW, 100 )
    btnNew:setFillColor( 128/255, 72/255, 149/255 )
    btnNew:addEventListener( 'tap', doCreate )
    grpNew:insert(btnNew)
    local lblRegistrar = display.newText({
        text = language.LUNRegistrar,     
        x = midR + 70, y = midH + 450,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRegistrar:setFillColor( 217/255, 200/255, 223/255 )
    grpNew:insert(lblRegistrar)
    local icoRegistrar = display.newImage( grpNew, "img/icoRegistrar.png" )
    icoRegistrar:translate( midR - 80, midH + 450 )
    
    -- Terms
	local chkOn = display.newImage("img/checkOn.png", true)
	chkOn:translate(100, midH + 540)
    grpNew:insert(chkOn)
    local lblTerms1 = display.newText( {
        text = language.LUNTerms1,
        x = midW, y = midH + 530,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms1:setFillColor( .5 )
    grpNew:insert(lblTerms1)
    local lblTerms2 = display.newText( {
        text = language.LUNTerms2,
        x = midW, y = midH + 550,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms2:setFillColor( .5,.5,1 )
    grpNew:insert(lblTerms2)
    
    local btnTerms = display.newRect( 330, midH + 540, 400, 50 )
	btnTerms.alpha = .02
    btnTerms:addEventListener( "tap", tapTerms )
	grpNew:insert(btnTerms)
    
    midR = midW
    -- LogIn
    grpLogIn = display.newGroup()
    grpLogIn.y = -midH + 450
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
        text =  language.LUNEmail,     
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
    txtEmailS.action = "login"
    txtEmailS.hasBackground = false
    txtEmailS:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtEmailS)
    -- Set text password
    local lblPassS = display.newText({
        text = language.LUNPass,     
        x = midR - 190, y = midH + 150,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblPassS:setFillColor( .52 )
    grpLogIn:insert(lblPassS)
    txtPassS = native.newTextField( midR + 100, midH + 150, 400, 70 )
    txtPassS.inputType = "default"
    txtPassS.action = "login"
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
        text = language.LUNBtnSignIn,     
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
        text = language.LUNBtnRegister,     
        x = midR + 70, y = midH + 400,
        width = 240,
        font = native.systemFont,   
        fontSize = 30, align = "left"
    })
    lblRegister:setFillColor( 220/255, 186/255, 218/255 )
    grpLogIn:insert(lblRegister)
    local icoLogIn = display.newImage( grpLogIn, "img/icoRegistrar.png" )
    icoLogIn:translate( midR - 80, midH + 400 )
    
    -- Terms
	local chkOn2 = display.newImage("img/checkOn.png", true)
	chkOn2:translate(100, midH + 500)
    grpLogIn:insert(chkOn2)
    local lblTerms12 = display.newText( {
        text = language.LUNTerms1,
        x = midW, y = midH + 490,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms12:setFillColor( .5 )
    grpLogIn:insert(lblTerms12)
    local lblTerms22 = display.newText( {
        text = language.LUNTerms2,
        x = midW, y = midH + 510,
        font = native.systemFontBold,  
        width = 500,
        fontSize = 20, align = "left"
    })
    lblTerms22:setFillColor( .5,.5,1 )
    grpLogIn:insert(lblTerms22)
    
    local btnTerms2 = display.newRect( 330, midH + 500, 400, 50 )
	btnTerms2.alpha = .02
    btnTerms2:addEventListener( "tap", tapTerms )
	grpLogIn:insert(btnTerms2)

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