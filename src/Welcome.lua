---------------------------------------------------------------------------------
-- Gluglis Rex
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
require('src.resources.majorCities')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpWelcome
local txtLocationW

-- Variables

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

---------------------------------------------
-- deshabilita los eventos tap no deseados
-- deshabilita el traspaso del componentes
---------------------------------------------
function noAction( event )
	return true
end

---------------------------------------------
-- mueve el textField cuando se despliega el menu
-- @param posX posicione en la que se movera el textfield
---------------------------------------------
function moveTextFieldWelcome( poscX )
	if txtLocationW then
		txtLocationW.x = poscX
	end
end

-------------------------------------
-- Evento focus del textField
-- @param event datos del textField
-------------------------------------
function onTxtFocusWelcome( event )
	if ( event.phase == "began" ) then
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
    elseif ( event.phase == "editing" ) then
		--hace la busqueda de la ciudad
		local itemOption = {posY = (intH/2 + h) - 100, posX = 335, height = 500, width = 538}
		RestManager.getCity(txtLocationW.text, "welcome", grpWelcome, itemOption )
    end
end

-------------------------------------------
-- asigna la ciudad selecionada
-------------------------------------------
function getCityWelcome(city)
	txtLocationW.text = city
end

-------------------------------------
-- Genera una ciudad aleatoriamente
-- @param event datos del boton
-------------------------------------
function randomCitiesWelcome( event )
	local numCity = math.random(1, 100)
	txtLocationW.text = majorCities[numCity]
end

-------------------------------------
-- Manda a la pantalla d home con la ciudad selecionada
-------------------------------------
function goToHome( event )
	closeAllWelcome( 0 )
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
	local textLocation = trimString(txtLocationW.text)
	if textLocation == "" then
		textLocation = 0
	end
	typeSearch = "welcome"
	DBManager.updateCity(textLocation)
	composer.gotoScene( "src.Home", { time = 400, effect = "fade" } )
end

-------------------------------------
-- Manda a la pantalla de filtros
-------------------------------------
function goFilter( event )
	closeAllWelcome( 0 )
	composer.gotoScene( "src.Filter", { time = 400, effect = "fade" } )
end

-------------------------------------
-- Manda a la pantalla de filtros
-------------------------------------
function validateCity( event )
	RestManager.getValidateCity(txtLocationW.text )
end

function returnValidateCity(result)

	if (result) then
		RestManager.saveLocationProfile( txtLocationW.text )
	else
		local message = "Seleccione una ciudad validad.";
		NewAlert(true, message)
		timeMarker = timer.performWithDelay( 1000, function()
			NewAlert(false, message)
		end, 1 )
	end
end

function returnLocationProfile( isTrue, message )
	
	if (isTrue) then
		goToHome()
	else
		NewAlert(true, message)
		timeMarker = timer.performWithDelay( 1000, function()
			NewAlert(false, message)
		end, 1 )
	end
	
end

--------------------------------
-- cierra todo los componentes
-------------------------------
function closeAllWelcome( event )
	native.setKeyboardFocus(nil)
	deleteGrpScrCity()
	return true
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )

	--obtiene la configuracion de los filtros
	--settFilter = DBManager.getSettingFilter()

	local typeScene = event.params.type

	screen = self.view
    screen.y = h
	
	--grpWelcome.y = 200 + h
	
	--se crea y se deshace la imagen del fondo
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	o:addEventListener( 'tap', closeAllWelcome )
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
	
	tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	grpWelcome = display.newGroup()
	screen:insert(grpWelcome)
	grpWelcome.y = h
	
	--[[
	local lineGoFilter = display.newLine( 430, 85, 720, 85 )
	lineGoFilter:setStrokeColor( 0 )
	lineGoFilter.strokeWidth = 3
	grpWelcome:insert(lineGoFilter)]]
	
	local lastY = intH/6
	
	local iconLogo = display.newImage( "img/logo.png"  )
	iconLogo:translate( midW, lastY )
	grpWelcome:insert(iconLogo)
	
	lastY = (intH/2 + h) - 100
	
	local bgText = display.newRoundedRect( midW - 50, lastY + 5, 540, 100, 5 )
	bgText.anchorY = 1
	bgText:setFillColor( 1 )
	grpWelcome:insert(bgText)
	
	txtLocationW = native.newTextField( midW - 55, lastY, 540, 100 )
	txtLocationW.anchorY = 1
	txtLocationW.inputType = "default"
	txtLocationW.hasBackground = false
	txtLocationW:addEventListener( "userInput", onTxtFocusWelcome )
	txtLocationW:setReturnKey( "default" )
	txtLocationW.size = 40
	if ( typeScene == "Welcome" ) then
		txtLocationW.placeholder = "Ingresa una ciudad"
	else
		txtLocationW.placeholder = "Ingresa su ciudad"
	end
	txtLocationW:setTextColor( .5 )
	grpWelcome:insert( txtLocationW )
		
	if ( typeScene == "Welcome" ) then
		local imgDado = display.newImage( "img/1454731709.png" )
		imgDado:translate( intW - 85, lastY - 50 )
		imgDado.height = 100
		imgDado.width = 100
		grpWelcome:insert(imgDado)
		imgDado:addEventListener( 'tap', randomCitiesWelcome )
	end
	lastY = lastY + 100
	
	
	local btnSearch = display.newRoundedRect( midW, lastY, 650, 100, 10 )
    btnSearch:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    grpWelcome:insert(btnSearch)
	local textButtom = ""
	if ( typeScene == "Welcome" ) then
		btnSearch:addEventListener( 'tap', goToHome )
		textButtom = "BUSCAR"
	elseif ( typeScene == "SignUp" ) then
	btnSearch:addEventListener( 'tap', validateCity )
		textButtom = "ACEPTAR"
	end
	
	local lblSearch = display.newText({
        text = textButtom, 
        x = midW, y = lastY,
        font = native.systemFontBold,   
        fontSize = 30, align = "center"
    })
    lblSearch:setFillColor( 1 )
    grpWelcome:insert(lblSearch)
	
	
	posY = 110 + h
	
	if ( typeScene == "Welcome" ) then
		local bgSearch = display.newRect( 590 , intH - posY, 350, 100 )
		bgSearch.anchorY = 0
		bgSearch:setFillColor( 1 )
		bgSearch.alpha = .1
		grpWelcome:insert(bgSearch)
		bgSearch:addEventListener( 'tap', goFilter )
		
		local iconSearch = display.newImage( "img/iconSearch.png" )
		iconSearch:translate( intW - 75, intH - posY/2 - 12 )
		iconSearch.height = 80
		iconSearch.width = 80
		grpWelcome:insert(iconSearch)
	
		local lblSearch = display.newText({
			text = "Mas Filtros", 
			x = 550, y = intH - posY/2 - 12,
			font = native.systemFont, 
			fontSize = 25, align = "center"
		})
		lblSearch:setFillColor( 0 )
		grpWelcome:insert(lblSearch)
	end
	
	
    RestManager.getUserAvatar()
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus(nil)
	if txtLocationW then
		txtLocationW.x = -intW
	end
end

-- Destroy scene
function scene:destroy( event )
	if txtLocationW then
		txtLocationW:removeSelf()
		txtLocationW = nil
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene