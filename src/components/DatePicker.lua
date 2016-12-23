---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
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

widget.setTheme( "widget_theme_android_holo_light" )

local grpComboBox
	
local grpDatePicker = display.newGroup()
local grpT
local days = {}
local months = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Deciembre" }
local years = {}
local pickerWheel
	
function destroyDatePicker( event )

	local t = event.target

	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	
	if grpT then
		grpT.x = 0
	end
	
	if t.name then
		if t.name == "accept" then
			local values = pickerWheel:getValues()
			
			local day = values[1].value
			local month = values[2].value
			local year = values[3].value
			local month2 = 1
			for i=1,12,1 do
				if month == months[i] then
					month = i
					break
				end
			end
		
			--hace la conversion
			if tonumber(month) < 10 then month = "0" .. month end
			if tonumber(day) < 10 then day = "0" .. day end
			local dateS = day .. "/" .. month .. "/" .. year
			local dateS2 = year .. "-" .. month .. "-" .. day
			
			--print(dateS)
			--print(dateS2)
			
			getBirthDate( dateS, dateS2 )
			
		end
	end
		
	return true
end
	
function noActionDate( event )
	return true
end
	
function buildPicker(dateb, textGrp)
	
	if textGrp then
		grpT = textGrp
		grpT.x = intW
	end
		
	grpDatePicker = display.newGroup()
	grpDatePicker.y = intH
		
	local bg0 = display.newRect( midW, - midH + h + ( 406), intW, intH )
	bg0.alpha = .35
	bg0:setFillColor( 0 )
	grpDatePicker:insert(bg0)
	bg0:addEventListener( 'tap', noActionDate )
		
	local bgDatePicker = display.newRect( midW, 80, intW, 400 )
	bgDatePicker.anchorY = 0
	bgDatePicker:setFillColor( 1 )
	grpDatePicker:insert(bgDatePicker)
	--background buttom
	local bgBtnDatePicker = display.newRect( midW, 50, intW, 80 )
	grpDatePicker:insert(bgBtnDatePicker)
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
	grpDatePicker:insert(btnAceptDate)
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
	grpDatePicker:insert(labelAcceptDate)
		
	--crea el datePicker
	--DatePicker(event.target.name)
	
	createDatePicker(dateb)
		
	--mueve el widget hacia arriba
	transition.to( grpDatePicker, { y = intH - 406, time = 400, transition = easing.outExpo })		
end
	
	
	
function createDatePicker(dateb)

	local dates = {}
	local currentDate
	if name == "iniDate" then
		currentDate = lblIniDate.date
	elseif name == "endDate" then
		currentDate = lblEndDate.date
	end
	currentDate = "0000-00-00"
	if currentDate ~= "0000-00-00" then
		local t = {}
		dates[1] = 0
		dates[2] = 0
		for Ye, Mi, Da in string.gmatch( currentDate, "(%w+)-(%w+)-(%w+)" ) do
			local datesArray = {day = Da,month = Mi,year = Ye}
			dates[3] = datesArray
		end
	else
		dates = RestManager.getDate()
	end
	-- Create two tables to hold data for days and years      
	days = {}
	years = {}

	-- Populate the "days" table
	for d = 1, 31 do
		days[d] = d
	end
		
	-- Populate the "years" table
	for y = 80, 1, -1 do
		years[y] = tonumber(dates[3].year) - y + 1
	end
	
	
	local dates2 = {}
	dates2[1] = 0
	dates2[2] = 0
	for Ye, Mi, Da in string.gmatch( dateb, "(%w+)-(%w+)-(%w+)" ) do
		dates2[1] = Da
		dates2[2] = Mi
		dates2[3] = Ye
		--dates2[3] = tonumber(dates2[3].year) - tonumber(Ye)
	end
	
	print(2016 - dates2[3])
	
	--edad = dates[3].day .. "/" .. dates[3].month .. "/" .. dates[3].year

	-- Set up the picker wheel columns
	local columnData = {
		{
			align = "center",
			width = intW/3,
			startIndex = 1,
			labels = days
		},
		{
			align = "center",
			width = intW/3,
			labelPadding = 10,
			startIndex = 1,
			--startIndex = tonumber( dates2[2] ),
			labels = months
		},
		{
			align = "center",
			labelPadding = 10,
			width = intW/3,
			--startIndex = tonumber( dates[3].year - dates2[3] + 1 ),
			startIndex = 1,
			labels = years
		}
	}

	-- Create the widget
	pickerWheel = widget.newPickerWheel({
		x = display.contentCenterX,
		top =   - 50,
		columns = columnData,
		style = "resizable",
		width = intW,
		rowHeight = 60,
		fontSize = 32
	})  
	pickerWheel.anchorY = 0
	grpDatePicker:insert( pickerWheel )

	-- Get the table of current values for all columns
	-- This can be performed on a button tap, timer execution, or other event

	-- Get the value for each column in the wheel, by column index
	--[[local currentStyle = values[1].value
	local currentColor = values[2].value
	local currentSize = values[3].value

	print( currentStyle, currentColor, currentSize )]]
	
end