---------------------------------------------------------------------------------
-- Gluglis Rex
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require( 'src.Tools' )
require( 'src.resources.Globals' )
local widget = require( "widget" )
require( 'src.components.ComboBox' )
require('src.resources.majorCities')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpSettings
local langOpt = {}

-- Variables
local lblLanguage
---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

---------------------------------------------
-- deshabilita los eventos tap no deseados
-- deshabilita el traspaso del componentes
---------------------------------------------
function noAction( event )
	return true
end

function saveSettings( event )
	--print( lblLanguage.value )
	DBManager.updatLanguage(lblLanguage.value)
	local setting = DBManager.getSettings()
	language = require('src.resources.Language')
	if setting.language == "es" then language = language.es
	elseif setting.language == "en" then language = language.en
	elseif setting.language == "it" then language = language.it
	elseif setting.language == "de" then language = language.de 
	elseif setting.language == "zh" then language = language.zh
	elseif setting.language == "he" then language = language.he 
	else language = language.en end
	composer.removeScene( "src.Home" )
	composer.gotoScene( "src.Home", { time = 400, effect = "fade"})
	return true
end

function selectOptionComboS( event )
	local t = event.target
	
	if t.label then
		t.label.text = t.option
		t.label.value = t.value
	end
	hideComboBox( "" )
	
	return true
end

function showComboBoxS( event )
	t = event.target
	showComboBox(t.name, t.option, t )
end




-------------------------------------------------
-- Creacion de los togle buttons
-- @param item valor inicia de los elementos
-- @param posY2 coordenada y del elemento
-------------------------------------------------
function createComboBoxS(item, name, coordY, coordX )
	local setting = DBManager.getSettings()
	coordY = coordY - 25
	-- BG Component
	--intW - 65, coordY, 400 , 90
	--[[local bg0CheckAcco = display.newRect( intW - 65, coordY, 400, 90 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco:setFillColor( 129/255, 61/255, 153/255 )
	scrPerfile:insert(bg0CheckAcco)]]
	local bg0CheckAcco = display.newRect( intW - 65, coordY + 25, 400, 90 )
	--bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco:setFillColor( 1 )
	bg0CheckAcco.name = name
	
	grpSettings:insert(bg0CheckAcco)
	
	local triangle = display.newImage("img/down.png")
	triangle:translate(coordX + 295, coordY + 25)
	triangle.height = 48
	triangle.width = 48
	grpSettings:insert(triangle)
	if name == "language" then
		local abbrL = "en"
		local nameL = "English"
		for i = 1, #langOpt, 1 do
			if( langOpt[i].value == setting.language ) then
				abbrL = langOpt[i].value
				nameL = langOpt[i].name
			end
		end
		bg0CheckAcco.name = name
		bg0CheckAcco.option = langOpt
		lblLanguage = display.newText({
			text = nameL,
			x = coordX + 65, y = coordY + 25,
			width = 360, --height = 30,
			font = fontFamilyBold,   
			fontSize = 26, align = "right"
		})
		lblLanguage:setFillColor( 0 )
		lblLanguage.value = abbrL
		grpSettings:insert(lblLanguage)
		bg0CheckAcco.label = lblLanguage
		bg0CheckAcco.functionEvent = selectOptionComboS
	end
	
	bg0CheckAcco:addEventListener( 'tap', showComboBoxS )
end

----------------------------------------------
-- Crea las opciones de las configuraciones --
----------------------------------------------
function createSetting()
	
	-- Opciones
    local posY = 200 + h
    local opt = {
        {label= language.SChangeLanguage, wField = 380, x = 660, nameField = "language", type="comboBox"},  
	}
		
	--group Filter
	local line = display.newLine( 0, posY - 53 , intW, posY - 53 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	grpSettings:insert(line)
	
	for i=1, #opt do
		
		local bgField = display.newRect( midW, posY, intW, 100 )
		bgField:setFillColor( 1 )
		grpSettings:insert(bgField)
		
		local line = display.newLine( 0, posY + 50 , intW, posY + 50)
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		grpSettings:insert(line)	
		
		local lbl = display.newText({
            text = opt[i].label, 
            x = midW + 65, y = posY,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 24, align = "left"
        })
        lbl:setFillColor( 50/255 )
        grpSettings:insert(lbl)
		
		if ( opt[i].type == "comboBox" ) then
			createComboBoxS("", opt[i].nameField, posY - 2, 380)
		end
    
		posY = posY + 102
    end 
	
	local line = display.newLine( 0, posY - 52, intW, posY - 52 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	grpSettings:insert(line)	
	
	return true
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	
	screen = self.view
    screen.y = h
	grpTextField = display.newGroup()
	--bg screen
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 0 )
	--o:addEventListener( 'touch', listenerSlider )
	--o:addEventListener( 'tap', closeAll )
	o:setFillColor( 245/255 )
    screen:insert(o)
	
	--creacion del toolbar
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	--group Filter
	grpSettings = display.newGroup()
	screen:insert(grpSettings)
	--grpFilter.y = h
	
	-- Opciones
	langOpt = {
        { value = "es", name = "Español" },
		{ value = "en", name = "English" },
		{ value = "it", name = "Italian" },
		{ value = "fr", name = "French" },
		{ value = "de", name = "Deutsch" },
		{ value = "zh", name = "中国" }, 
		{ value = "he", name = "עברי" },
	}
    
	createSetting()
	
	local btnSaveSettings = display.newRect( midW, intH - 175, intW, 120 )
	btnSaveSettings.anchorY = 0
	btnSaveSettings:setFillColor( 0/255, 174/255, 239/255 )
    grpSettings:insert(btnSaveSettings)
	btnSaveSettings:addEventListener( 'tap', saveSettings )
	
	local lblSaveSettings = display.newText({
        text = language.SSaveSettings,
        x = midW, y = intH - 115,
        font = fontFamilyBold,
        fontSize = 32, align = "left"
    })
    lblSaveSettings:setFillColor( 1 )
	grpSettings:insert(lblSaveSettings)
	
   
   
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	bubble()
end

-- Hide scene
function scene:hide( event )
	
end

-- Destroy scene
function scene:destroy( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene