---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
-- GeekBucket 2016
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

DatePicker = {}
function DatePicker:new()
	
	local self = display.newGroup()
	
	
	function self:buildPicker()
		
		if self then
			self:removeSelf()
			self = nil
		end
		self = display.newGroup()
		self.y = intH
		
		local bgDatePicker = display.newRect( midW, 80, intW, 400 )
		bgDatePicker.anchorY = 0
		bgDatePicker:setFillColor( 1 )
		self:insert(bgDatePicker)
		--background buttom
		local bgBtnDatePicker = display.newRect( midW, 50, intW, 80 )
		self:insert(bgBtnDatePicker)
		bgBtnDatePicker:setFillColor( {
			type = 'gradient',
			color1 = { 129/255, 61/255, 153/255 }, 
			color2 = { 89/255, 31/255, 103/255 },
			direction = "bottom"
		} )
		--buttom
		local btnAceptDate = display.newRect( intW, 50, 250, 80 )
		btnAceptDate.anchorX = 1
		--btnAceptDate.type = event.target.name
		btnAceptDate.name = "accept"
		self:insert(btnAceptDate)
		btnAceptDate:addEventListener( 'tap', destroyDatePicker )
		btnAceptDate:setFillColor( {
			type = 'gradient',
			color1 = { 129/255, 61/255, 153/255 }, 
			color2 = { 89/255, 31/255, 103/255 },
			direction = "bottom"
		})
		--label buttom
		local labelAcceptDate = display.newText({
				text = "Aceptar", 
				x = intW, y = 50,
				width = 250,
				font = fontFamilyRegular,   
				fontSize = 35, align = "center"
			})
		labelAcceptDate:setFillColor( 1 )
		labelAcceptDate.anchorX = 1
		self:insert(labelAcceptDate)
		
		--crea el datePicker
		--DatePicker(event.target.name)
		
		createDatePicker()
		
		--mueve el widget hacia arriba
		transition.to( self, { y = intH - 406, time = 400, transition = easing.outExpo })
		
		
	end
	
	function destroyDatePicker()
		if self then
			self:removeSelf()
			self = nil
		end
		
		return true
	end
	
	function createDatePicker()
	
		local widget = require( "widget" )

		-- Set up the picker wheel columns
		local columnData =
		{
			{
				align = "center",
				width = intW/3,
				startIndex = 1,
				labels = { "Hoodie", "Short Sleeve", "Long Sleeve", "Sweatshirt" }
			},
			{
				align = "center",
				width = intW/3,
				labelPadding = 10,
				startIndex = 1,
				labels = { "Dark Grey", "White", "Black", "Orange" }
			},
			{
				align = "center",
				labelPadding = 10,
				width = intW/3,
				startIndex = 1,
				labels = { "S", "M", "L", "XL", "XXL" }
			}
		}

		-- Create the widget
		local pickerWheel = widget.newPickerWheel({
			x = display.contentCenterX,
			top = intH - 306,
			columns = columnData,
			style = "resizable",
			width = intW,
			rowHeight = 100,
			fontSize = 20
		})  

		-- Get the table of current values for all columns
		-- This can be performed on a button tap, timer execution, or other event
		local values = pickerWheel:getValues()

		-- Get the value for each column in the wheel, by column index
		local currentStyle = values[1].value
		local currentColor = values[2].value
		local currentSize = values[3].value

		print( currentStyle, currentColor, currentSize )
	
	end
	
	return self
end