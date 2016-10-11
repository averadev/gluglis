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
local widget = require( "widget" )
require('src.resources.majorCities')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpWelcome
local txtLocationW
local grpCityWc
local lblCityW = {}

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
		txtLocationW.city = ""
		txtLocationW.id = 0
		RestManager.getCity(txtLocationW.text, "welcome", grpWelcome, itemOption )
    end
end

-------------------------------------
-- limpia el campo de busqueda
-------------------------------------
function cleanTxtLocationW( event )

	if grpCityWc then
		grpCityWc:removeSelf()
	end
	if txtLocationW then
		txtLocationW.text = ""
		txtLocationW.city = ""
		txtLocationW.id = 0
	end
	return true
end

-------------------------------------
-- lSelecciona la ciudad 
-------------------------------------
function selectCityWc( event )
	local p = event.target.posc
	for i = 1, #bgCity do
		lblCityW[i]:removeSelf()
	end
	
	lblCityW = nil
	lblCityW = {}
	local heightItem = 120
	local lastY = 3
	for i = 1, #bgCity do
		bgCity[i]:setFillColor( 1, 1,1 ,.1 )
		if( i == p ) then
			lblCityW[i] = display.newText({
				text = bgCity[i].city, 
				x = midW, y = lastY + (heightItem - (heightItem/2)),
				width = intW - 50,
				font = native.systemFont,   
				fontSize = 42, align = "center"
			})
			lblCityW[i]:setFillColor( 68/255, 14/255, 98/255 )
			bgCompCity:insert(lblCityW[i])
		else
			lblCityW[i] = display.newText({
				text = bgCity[i].city, 
				x = midW, y = lastY + (heightItem - (heightItem/2)),
				width = intW - 50,
				font = native.systemFont,   
				fontSize = 30, align = "center"
			})
			lblCityW[i]:setFillColor( 68/255, 14/255, 98/255 )
			bgCompCity:insert(lblCityW[i])
		end
		lastY = lastY + heightItem + 5
	end
	event.target:setFillColor( 1 )
	
	txtLocationW.text = event.target.city
	txtLocationW.city = event.target.city
	txtLocationW.id = event.target.id
	return true
end

-------------------------------------
-- Muestra las opciones de ciudades 
-------------------------------------
function OptionLocationWc( item )

	if grpCityWc then
		grpCityWc:removeSelf()
	end
	
	grpCityWc = display.newGroup()
	screen:insert(grpCityWc)
	grpCityWc.y = h
	
	local lastY = 355
	
	bgCompCity = widget.newScrollView({
		top = bgText.y,
		left = 0,
		width = intW,
		height = intH/2.3,
		horizontalScrollDisabled = true,
		isBounceEnabled = false,
		hideBackground = true,
		backgroundColor = { .88 }
	})
	grpCityWc:insert(bgCompCity)
	
	lastY = 3
	bgCity = nil
	bgCity = {}
	lblCityW = nil
	lblCityW = {}
	
	local heightItem = 120
	for i = 1, #item do
	
		bgCity[i] = display.newRect( midW, lastY, intW, heightItem )
		bgCity[i].anchorY = 0
		bgCity[i].city = item[i].description
		bgCity[i].id = item[i].place_id
		bgCity[i]:setFillColor( 1, 1,1 ,.1 )
		bgCompCity:insert(bgCity[i])
		bgCity[i].posc = i
		bgCity[i]:addEventListener( 'tap', selectCityWc )
		
		lblCityW[i] = display.newText({
			text = item[i].description, 
			x = midW, y = lastY + (heightItem - (heightItem/2)),
			width = intW - 50,
			font = native.systemFont,   
			fontSize = 30, align = "center"
		})
		lblCityW[i]:setFillColor( 68/255, 14/255, 98/255 )
		bgCompCity:insert(lblCityW[i])
		
		lastY = lastY + heightItem + 5
				
	end
	
end

-------------------------------------------
-- asigna la ciudad selecionada
-------------------------------------------
function getCityWelcome(city, id)
	txtLocationW.text = city
	txtLocationW.city = city
	txtLocationW.id = id
end

-------------------------------------
-- Genera una ciudad aleatoriamente
-- @param event datos del boton
-------------------------------------
function randomCitiesWelcome( event )
	RestManager.getRandomCities(  )
	--local numCity = math.random(1, 100)
	--txtLocationW.text = majorCities[numCity]
	tools:setLoading(true,grpWelcome)
end

function printRandomCities( city, cityId)
	if( city ~= false ) then
		txtLocationW.text = city
		txtLocationW.city = city
		txtLocationW.id = cityId
	end
	tools:setLoading(false,grpWelcome)
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
	DBManager.updateCity(textLocation, txtLocationW.id)
	composer.removeScene( "src.Home" )
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

	screen = self.view
    screen.y = h
	
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
	
	local lastY = intH/7
	
	local iconLogo = display.newImage( "img/logo2.png"  )
	iconLogo:translate( midW, lastY )
	grpWelcome:insert(iconLogo)
	
	lastY = lastY + 200
	
	local bgText0 = display.newRoundedRect( midW, lastY + 3, intW, 106, 0 )
	bgText0.anchorY = 1
	bgText0:setFillColor( 225/255 )
	grpWelcome:insert(bgText0)
	
	bgText = display.newRoundedRect( midW, lastY, intW, 100, 0 )
	bgText.anchorY = 1
	bgText:setFillColor( 1 )
	grpWelcome:insert(bgText)
	
	local imgClean = display.newImage( "img/x-mark-4-48.png" )
	imgClean:translate( 55, lastY - 50 )
	grpWelcome:insert(imgClean)
	imgClean:addEventListener( 'tap', cleanTxtLocationW )
	
	txtLocationW = native.newTextField( midW, lastY, 540, 100 )
	txtLocationW.anchorY = 1
	txtLocationW.inputType = "default"
	txtLocationW.hasBackground = false
	txtLocationW:addEventListener( "userInput", onTxtFocusWelcome )
	txtLocationW:setReturnKey( "default" )
	txtLocationW.size = 40
	txtLocationW.placeholder = "Ingresa una ciudad"
	txtLocationW:setTextColor( .5 )
	txtLocationW.city = ""
	txtLocationW.id = 0
	grpWelcome:insert( txtLocationW )
	
	local imgDado = display.newImage( "img/1454731709.png" )
	imgDado:translate( intW - 55, lastY - 50 )
	imgDado.height = 80
	imgDado.width = 80
	grpWelcome:insert(imgDado)
	imgDado:addEventListener( 'tap', randomCitiesWelcome )
	
	lastY = intH - 250
	
	local btnSearch0 = display.newRoundedRect( midW, lastY + 2, intW, 106, 0 )
	btnSearch0:setFillColor( 225/255 )
	grpWelcome:insert(btnSearch0)
	
	local btnSearch = display.newRoundedRect( midW, lastY, intW, 94, 0 )
	btnSearch:setFillColor( 1 )
	grpWelcome:insert(btnSearch)
	local textButtom = ""
	btnSearch:addEventListener( 'tap', goToHome )
	
	local lblSearch = display.newText({
        text = "Buscar", 
        x = midW, y = lastY,
        font = native.systemFontBold,  
		width = intW - 200,
        fontSize = 30, align = "left"
    })
    lblSearch:setFillColor( 68/255, 14/255, 98/255 )
    grpWelcome:insert(lblSearch)
	
	lastY = intH - 125
	
	local btnFilter0 = display.newRoundedRect( midW, lastY + 2, intW, 106, 0 )
	btnFilter0:setFillColor( 225/255 )
	grpWelcome:insert(btnFilter0)
	
	local btnFilter = display.newRoundedRect( midW, lastY, intW, 94, 0 )
	btnFilter:setFillColor( 1 )
	grpWelcome:insert(btnFilter)
	btnFilter:addEventListener( 'tap', goFilter )
	
	local lblFilter = display.newText({
        text = "Más Filtros", 
        x = midW, y = lastY,
        font = native.systemFontBold,
		width = intW - 200,
        fontSize = 30, align = "left"
    })
    lblFilter:setFillColor( 68/255, 14/255, 98/255 )
    grpWelcome:insert(lblFilter)
	
    --RestManager.getUserAvatar()
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