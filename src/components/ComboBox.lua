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
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local grpComboBox

---------------------------------------------------
-- Destruye el combobox 
---------------------------------------------------
function hideComboBox()
	componentActive = false
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	
	return true
end

---------------------------------------------------
-- Muestra el combobox
-- @params name nombre del componente
-- @params items elementos a pintarse
-- @params eventT evento que se disparara cuando se seleccione una opcion
---------------------------------------------------
function showComboBox( name, items, eventT )
	componentActive = "comboBox"
	--elimina los componentes para crear otros
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	--grpTextProfile.x = intW
	grpComboBox = display.newGroup()
	componentActive = "comboBox"
		--combobox
	local bg0 = display.newRect( midW, midH + h, intW, intH )
	bg0:setFillColor( 0 )
	bg0.alpha = .4
	grpComboBox:insert( bg0 )
	bg0:addEventListener( 'tap', hideComboBox )
	local bg1 = display.newRect( midW, midH + h, 606, midH )
	bg1:setFillColor( 1 )
	grpComboBox:insert( bg1 )
	--bg1.anchorY = 0
	--scrollview
	scrCombo = widget.newScrollView({
		y = midH + h,
		x = midW,
		width = 600,
		height = midH - 10,
		horizontalScrollDisabled = true,
		backgroundColor = { .96 }
	})
	grpComboBox:insert(scrCombo)
	local setElements = items
	local posY = 0
	for i = 1, #setElements, 1 do
		local container2 = display.newContainer( 600, 100 )
		scrCombo:insert(container2)
		container2.anchorY = 0
		container2:translate( 300, posY )
		local bg0OptionCombo = display.newRect( 0, 0, 600, 100 )
		bg0OptionCombo:setFillColor( 1 )
		bg0OptionCombo.name = name
		bg0OptionCombo.option = setElements[i].name
		bg0OptionCombo.value = setElements[i].value
		bg0OptionCombo.label = eventT.label
		container2:insert( bg0OptionCombo )
		bg0OptionCombo:addEventListener( 'tap', eventT.functionEvent )
		
		--label nombre
		local lblNameOption = display.newText({
			text = setElements[i].name,
			x = 0, y = 0,
			width = 500,
			font = fontFamilyRegular, 
			fontSize = 30, align = "left"
		})
		lblNameOption:setFillColor( 0 )
		container2:insert(lblNameOption)
		
		posY = posY + 106
	end
end