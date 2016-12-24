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
				font = fontFamilyBold,   
				font = fontFamilyBold,   
				fontSize = 36, align = "center"
			})
			lblCityW[i]:setFillColor( 68/255, 14/255, 98/255 )
			bgCompCity:insert(lblCityW[i])
		else
			lblCityW[i] = display.newText({
				text = bgCity[i].city, 
				x = midW, y = lastY + (heightItem - (heightItem/2)),
				width = intW - 50,
				font = fontFamilyRegular,   
				fontSize = 30, align = "center"
			})
			lblCityW[i]:setFillColor( 68/255, 14/255, 98/255 )
			bgCompCity:insert(lblCityW[i])
		end
		lastY = lastY + heightItem + 5
	end
	event.target:setFillColor( 1 )
	
	tools:setLoading(true,grpWelcome)
	
	local itemOption = {posY = (intH/2 + h) - 100, posX = 335, height = 500, width = 538}
	
	RestManager.getCityEn(event.target.city, "welcome", grpWelcome, itemOption )
	
	return true
end

function setItemCityWc( item )

	print("entro")
	
	if( #item > 0 ) then
		txtLocationW.text = item[1].description
		txtLocationW.city = item[1].description
		txtLocationW.id = item[1].place_id
	end
	
	tools:setLoading(false,grpWelcome)
	
	--txtLocationW.text = event.target.city
	--txtLocationW.city = event.target.city
	--txtLocationW.id = event.target.id
	
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
	--grpCityWc.y = h
	
	local lastY = 355
	local heiScroll = (btnSearch.y - txtLocationW.y) - 100
	bgCompCity = widget.newScrollView({
		top = bgText.y,
		left = 0,
		width = intW,
		height = heiScroll,
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
			font = fontFamilyRegular,   
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
		local message = language.WCSelectCity;
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

function showBubbleWelcome(total)
	bubble()
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )

	screen = self.view
    screen.y = h
	
	--se crea y se deshace la imagen del fondo
    local o = display.newRect( midW, midH + h, intW+8, intH )
	o:setFillColor( 245/255 )
    screen:insert(o)
	o:addEventListener( 'tap', closeAllWelcome )
	
	tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	grpWelcome = display.newGroup()
	screen:insert(grpWelcome)
	--grpWelcome.y = h
	
	local lastY = 250 + h
	
	local iconLogo = display.newImage( "img/logo.png"  )
	iconLogo:translate( midW, lastY )
	grpWelcome:insert(iconLogo)
	
	lastY = lastY + 270
	
	local bgText0 = display.newRoundedRect( midW, lastY + 3, intW, 116, 0 )
	bgText0.anchorY = 1
	bgText0:setFillColor( 225/255 )
	grpWelcome:insert(bgText0)
	
	bgText = display.newRoundedRect( midW, lastY, intW, 110, 0 )
	bgText.anchorY = 1
	bgText:setFillColor( 1 )
	grpWelcome:insert(bgText)
	
	txtLocationW = native.newTextField( midW - 75, lastY, 540, 110 )
	txtLocationW.anchorY = 1
	txtLocationW.inputType = "default"
	txtLocationW.hasBackground = false
	txtLocationW:addEventListener( "userInput", onTxtFocusWelcome )
	txtLocationW:setReturnKey( "default" )
	txtLocationW.size = 40
	txtLocationW.placeholder = language.WCEnterCity
	txtLocationW:setTextColor( 45/255, 10/255, 65/255 )
	txtLocationW.city = ""
	txtLocationW.id = 0
	txtLocationW.font = native.newFont( fontFamilyRegular )
	grpWelcome:insert( txtLocationW )
	
	local imgClean = display.newImage( "img/1476237545_Cancel-01.png" )
	imgClean:translate( intW - 160, lastY - 55 )
	grpWelcome:insert(imgClean)
	imgClean.height = 48
	imgClean.width = 48
	imgClean:addEventListener( 'tap', cleanTxtLocationW )
	
	local imgDado = display.newImage( "img/1454731709.png" )
	imgDado:translate( intW - 65, lastY - 50 )
	imgDado.height = 80
	imgDado.width = 80
	grpWelcome:insert(imgDado)
	imgDado:addEventListener( 'tap', randomCitiesWelcome )
	
	lastY = intH - 185
	
	local btnSearch0 = display.newRoundedRect( midW, lastY + 2, intW, 126, 0 )
	btnSearch0:setFillColor( 225/255 )
	grpWelcome:insert(btnSearch0)
	
	btnSearch = display.newRoundedRect( midW, lastY, intW, 120, 0 )
	btnSearch:setFillColor( 45/255, 10/255, 65/255 )
	grpWelcome:insert(btnSearch)
	local textButtom = ""
	btnSearch:addEventListener( 'tap', goToHome )
	
	local lblSearch = display.newText({
        text = language.WCSearch, 
        x = midW, y = lastY,
        font = fontFamilyBold,  
		width = intW - 200,
        fontSize = 32, align = "center"
    })
    lblSearch:setFillColor( 1 )
    grpWelcome:insert(lblSearch)
	
	lastY = intH - 60
	
	--[[local btnFilter0 = display.newRoundedRect( midW, lastY + 2, intW, 106, 0 )
	btnFilter0:setFillColor( 225/255 )
	grpWelcome:insert(btnFilter0)]]
	
	local btnFilter = display.newRect( midW, lastY, intW, 120 )
	--btnFilter.anchorY = 0
	btnFilter:setFillColor( 1 )
	grpWelcome:insert(btnFilter)
	btnFilter:addEventListener( 'tap', goFilter )
	
	local lblFilter = display.newText({
        text = language.WCMoreFilters,
        x = midW, y = lastY,
        font = fontFamilyRegular,
		width = intW - 270,
        fontSize = 30, align = "right"
    })
    lblFilter:setFillColor( 90/255 )
    grpWelcome:insert(lblFilter)
	
	local imgMoreFilter = display.newImage( "img/buscar.png" )
	imgMoreFilter:translate( intW - 65, lastY )
	imgMoreFilter.height = 80
	imgMoreFilter.width = 80
	grpWelcome:insert(imgMoreFilter)
	
	if isReadOnly == false then
		--obtiene la lista de mensajes no leidos
		RestManager.getUnreadChats()
		--actualiza el token de notificaciones
		timeMarker = timer.performWithDelay( 1000, function( event )
			if playerId ~= 0 then
				timer.cancel( event.source )
				if isPlayerIdUpdate == 0 then
					RestManager.updatePlayerId()
					isPlayerIdUpdate = 1
				end
			end
		end, -1)
	end
	
	local RowIcon=display.newText(grpWelcome, "Ýá¢Ý©ä", 0, -15, native.systemFontBold,27 )
                    RowIcon:setTextColor( 65, 227, 255)
	
    --RestManager.getUserAvatar()
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	showBubbleWelcome()
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