---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
--require('src.Menu')
require('src.resources.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local grpComboBox

function hideComboBox()
	componentActive = false
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	
	return true
end

---------------------------------------------------
-- Muestra una lista de las ciudades por el nombre
-- @param item nombre de la ciudad y su pais
---------------------------------------------------
--function showComboBox(item, name, parent, itemOption)
--[[function showComboBox( name, items, eventT )
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
	local bg1 = display.newRect( midW, 90 + h, intW, intH - (90 + h) )
	bg1:setFillColor( 1 )
	grpComboBox:insert( bg1 )
	bg1.anchorY = 0
	--bg1:addEventListener( 'tap', hideOptionsCombo )
	--scrollview
	scrCombo = widget.newScrollView({
		top = 90 + h,
		x = midW,
		width = intW,
		height = intH - (90 + h),
		--horizontalScrollDisabled = true,
		backgroundColor = { .96 }
	})
	grpComboBox:insert(scrCombo)
	local setElements = items
	local posY = 0
	for i = 1, #setElements, 1 do
		local container2 = display.newContainer( intW, 120 )
		scrCombo:insert(container2)
		container2.anchorY = 0
		container2:translate( midW, posY )
		--container2:addEventListener( 'tap', selectOptionCombo )
		local bg0OptionCombo = display.newRect( 0, 3, intW, 120 )
		bg0OptionCombo:setFillColor( 1 )
		bg0OptionCombo.name = name
		bg0OptionCombo.option = setElements[i].name
		bg0OptionCombo.value = setElements[i].value
		bg0OptionCombo.label = eventT.label
		container2:insert( bg0OptionCombo )
		--bg0OptionCombo:addEventListener( 'tap', noAction )
		bg0OptionCombo:addEventListener( 'tap', eventT.functionEvent )
		
		--label nombre
		local lblNameOption = display.newText({
			text = setElements[i].name,
			x = 32, y = 0,
			width = intW - 65,
			font = fontFamilyRegular, 
			fontSize = 30, align = "left"
		})
		lblNameOption:setFillColor( 0 )
		container2:insert(lblNameOption)
		
		posY = posY + 124
	end
end]]

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
		--container2:addEventListener( 'tap', selectOptionCombo )
		local bg0OptionCombo = display.newRect( 0, 0, 600, 100 )
		bg0OptionCombo:setFillColor( 1 )
		bg0OptionCombo.name = name
		bg0OptionCombo.option = setElements[i].name
		bg0OptionCombo.value = setElements[i].value
		bg0OptionCombo.label = eventT.label
		container2:insert( bg0OptionCombo )
		--bg0OptionCombo:addEventListener( 'tap', noAction )
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