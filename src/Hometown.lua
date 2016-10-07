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
local grpHometown, grpCityHt
local txtLocationHt
local bgCompCity
local bgCity = {}
local btnSearch = nil

-- Variables

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

function onTxtFocusHomeTown( event )
	
	if ( event.phase == "began" ) then
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
    elseif ( event.phase == "editing" ) then
		--hace la busqueda de la ciudad
		local itemOption = {posY = (intH/2 + h) - 100, posX = 335, height = 500, width = 538}
		btnSearch.city = ""
		btnSearch.id = 0
		RestManager.getCity(txtLocationHt.text, "hometown", grpHometown, itemOption )
    end
	
end

function selectCityHt( event )
	for i = 1, #bgCity do
		bgCity[i].alpha = 1
	end
	event.target.alpha = .3
	btnSearch.city = event.target.city
	btnSearch.id = event.target.id
	return true
end

function OptionLocationHt( item )

	if grpCityHt then
		grpCityHt:removeSelf()
	end
	
	grpCityHt = display.newGroup()
	screen:insert(grpCityHt)
	grpCityHt.y = h
	
	local lastY = 355
	
	bgCompCity = widget.newScrollView({
		top = lastY,
		left = 0,
		width = intW,
		height = intH/2,
		horizontalScrollDisabled = true,
		backgroundColor = { .88 }
	})
	grpCityHt:insert(bgCompCity)
	
	lastY = 3
	bgCity = nil
	bgCity = {}
	
	local heightItem = 150
	for i = 1, #item do
	
		bgCity[i] = display.newRect( midW, lastY, intW, heightItem )
		bgCity[i].anchorY = 0
		bgCity[i].city = item[i].description
		bgCity[i].id = item[i].id
		bgCity[i]:setFillColor( 1 )
		bgCompCity:insert(bgCity[i])
		bgCity[i]:addEventListener( 'tap', selectCityHt )
		
		local lbl0 = display.newText({
			text = item[i].description, 
			x = midW, y = lastY + (heightItem - (heightItem/2)),
			width = intW - 50,
			font = native.systemFont,   
			fontSize = fontsize, align = "left"
		})
		lbl0:setFillColor( 0 )
		bgCompCity:insert(lbl0)
		
		lastY = lastY + heightItem + 3
				
	end
	
end

function saveCityHt( event )
	print(event.target.id )
	if ( event.target.id ~= 0 ) then
		RestManager.saveLocationProfile( event.target.city, event.target.id )
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
		goToHomeHt()
	else
		NewAlert(true, message)
		timeMarker = timer.performWithDelay( 1000, function()
			NewAlert(false, message)
		end, 1 )
	end
	
end

function goToHomeHt( event )
	--closeAllWelcome( 0 )
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
	local textLocation = trimString(btnSearch.city)
	if textLocation == "" then
		textLocation = 0
	end
	--DBManager.updateCity(textLocation, btnSearch.id)
	--RestManager.saveCityU
	
	composer.gotoScene( "src.Home", { time = 400, effect = "fade" } )
end

---------------------------------------------
-- deshabilita los eventos tap no deseados
-- deshabilita el traspaso del componentes
---------------------------------------------
function noAction( event )
	return true
end

--------------------------------
-- cierra todo los componentes
-------------------------------
function closeAllHometown( event )
	native.setKeyboardFocus(nil)
	--deleteGrpScrCity()
	return true
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )

	screen = self.view
    screen.y = h
	
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	o:addEventListener( 'tap', closeAllHometown )
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
	
	tools = Tools:new()
	
	grpHometown = display.newGroup()
	screen:insert(grpHometown)
	grpHometown.y = h
	
	local iconLogo = display.newImage("img/iconLogo.png")
	iconLogo:translate(display.contentWidth/2, 45)
	grpHometown:insert( iconLogo )
	
	local lastY = 100
	
	local lblWelco= display.newText({
		text = "Welcome! Please select your hometown", 
		x = midW, y = lastY,
		font = native.systemFont, 
		fontSize = 38, align = "center"
	})
	lblWelco:setFillColor( 129/255, 61/255, 153/255 )
	grpHometown:insert(lblWelco)
	
	local lastY = lastY + 100
	
	local bgSearchHt = display.newRect( midW , lastY, intW, 150 )
	bgSearchHt.anchorY = 0
	bgSearchHt:setFillColor( .8 )
	grpHometown:insert(bgSearchHt)
	
	local bgText = display.newRoundedRect( midW, lastY + 125, intW - 150, 100, 50 )
	bgText.anchorY = 1
	bgText:setFillColor( 1 )
	grpHometown:insert(bgText)
	
	txtLocationHt = native.newTextField( midW - 25, lastY + 125, intW - 250, 100 )
	txtLocationHt.anchorY = 1
	txtLocationHt.inputType = "default"
	txtLocationHt.hasBackground = false
	txtLocationHt:addEventListener( "userInput", onTxtFocusHomeTown )
	txtLocationHt:setReturnKey( "default" )
	txtLocationHt.size = 40
	txtLocationHt.placeholder = "Ingresa una ciudad"
	txtLocationHt:setTextColor( .5 )
	grpHometown:insert( txtLocationHt )
	
	lastY = intH - 200
	
	btnSearch = display.newRoundedRect( midW, lastY, 650, 100, 10 )
    btnSearch:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    grpHometown:insert(btnSearch)
	btnSearch.city = ""
	btnSearch.id = 0
	btnSearch:addEventListener( 'tap', saveCityHt )
	--local textButtom = "Ok! Start Glugling!"
	--btnSearch:addEventListener( 'tap', goToHome )
	
	local lblSearch = display.newText({
        text = "Ok! Start Glugling!", 
        x = midW, y = lastY,
        font = native.systemFontBold,   
        fontSize = 32, align = "center"
    })
    lblSearch:setFillColor( 1 )
    grpHometown:insert(lblSearch)
	
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus(nil)
	if txtLocationHt then
		txtLocationHt.x = -intW
	end
end

-- Destroy scene
function scene:destroy( event )
	if txtLocationHt then
		txtLocationHt:removeSelf()
		txtLocationHt = nil
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene