---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
------------------------------------- Includes -------------------------------------
require('src.resources.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local platform = system.getInfo( "platform" )

if platform == "android" then
	widget.setTheme( "widget_theme_android_holo_light" )
elseif platform == "ios" then
 -- si se actualiza el corona de ios descomentar esto :)
	--widget.setTheme( "widget_theme_ios7" )
end

------------------------------------- Grupos y contenedores -------------------------------------
local grpComboBox
local grpDatePicker = display.newGroup()

------------------------------------- Variables -------------------------------------
local grpT
local days = {}
local months = { language.RMJanuary, language.RMFebruary, language.RMMarch, language.RMApril, language.RMMay, language.RMJune, language.RMJuly, language.RMAugust, language.RMSeptember, language.RMOctober, language.RMNovember, language.RMDecember }
local years = {}
local pickerWheel

---------------------------------------------
-- Destruye el componente de datePicker
---------------------------------------------
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
			-- hace la conversion
			if tonumber(month) < 10 then month = "0" .. month end
			if tonumber(day) < 10 then day = "0" .. day end
			local dateS = day .. "/" .. month .. "/" .. year
			local dateS2 = year .. "-" .. month .. "-" .. day
			getBirthDate( dateS, dateS2 )
		end
	end
		
	return true
end
	
---------------------------------------------
-- Impide la propagacion del tap
---------------------------------------------
function noActionDate( event )
	return true
end

---------------------------------------------
-- Crea los componentes del datePicker
-- @params dateb fecha actual
-- @params textGrp Grupo de textField
---------------------------------------------
function buildPicker( dateb, textGrp )
	
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
	
	local environment = system.getInfo( "environment" )
	
	if environment == "simulator" then
		createDatePickerAndroid(dateb)
	else
		--descomentar en android
		local platform = system.getInfo( "platform" )
		if platform == "android" then
			createDatePickerAndroid(dateb)
		else
			createDatePickerIos(dateb)
		end
		-------------------------
		--descomentar en ios
		--[[local platform = system.getInfo( "platformName" )
		if platform == "Android" then
			createDatePickerAndroid(dateb)
		else
			createDatePickerIos(dateb)
		end]]
	end

	--mueve el widget hacia arriba
	transition.to( grpDatePicker, { y = intH - 406, time = 400, transition = easing.outExpo })		
end
	
-------------------------------------------------
-- Crea el datePicker de ios y le asigna las fechas
-- @params dateb fecha actual
-------------------------------------------------
function createDatePickerIos(dateb)

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
	-- Crea las tablas de dia y año    
	days = {}
	years = {}
	-- Poblar la tabla de dia
	for d = 1, 31 do
		days[d] = d
	end
	-- Poblar la tabla de años
	for y = 80, 1, -1 do
		years[y] = tonumber(dates[3].year) - y + 1
	end
	
	-- asigna la fecha actual i existe
	local dates2 = {}
	if dateb ~= "0000-00-00" then
		for Ye, Mi, Da in string.gmatch( dateb, "(%w+)-(%w+)-(%w+)" ) do
			dates2[1] = Da
			dates2[2] = Mi
			dates2[3] = Ye
		end
		dates2[3] = tonumber( dates[3].year - dates2[3] + 1 )
	else
		dates2[1] = 1
		dates2[2] = 1
		dates2[3] = 1
	end

	-- Configure las columnas de la rueda selectora
	local columnData = {
		{
			align = "center",
			width = 200,
			startIndex = tonumber( dates2[1] ),
			labels = days
		},
		{
			align = "center",
			width = 200,
			labelPadding = 10,
			startIndex = tonumber( dates2[2] ),
			labels = months
		},
		{
			align = "center",
			labelPadding = 10,
			width = 200,
			startIndex = tonumber( dates2[3] ),
			labels = years
		}
	}
	
	local options = {
		frames = 
		{
			{ x=0, y=0, width=900, height=250 },
			{ x=900, y=0, width=900, height=250 },
			{ x=2000, y=0, width=8, height=250 }
		},
		sheetContentWidth = 1808,
		sheetContentHeight = 250
	}
	local pickerWheelSheet = graphics.newImageSheet( "img/pickerSheet4.png", options )

	-- pickerWheel
	pickerWheel = widget.newPickerWheel({
		y = 250,
		x = 230,
		columns = columnData,
        sheet = pickerWheelSheet,
        overlayFrame = 1,
        overlayFrameWidth = 900,
        overlayFrameHeight = 222,
        backgroundFrame = 2,
        backgroundFrameWidth = 900,
        backgroundFrameHeight = 222,
        separatorFrame = 20,
        separatorFrameWidth = 8,
        separatorFrameHeight = 222,
        columnColor = { 0, 0, 0, 0 },
        fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 129/255, 61/255, 153/255},
		fontSize = 35,
    })
	
	grpDatePicker:insert( pickerWheel )

end
	
-------------------------------------------------
-- Crea el datePicker de android y le asigna las fechas
-- @params dateb fecha actual
-------------------------------------------------
function createDatePickerAndroid(dateb)

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
	-- Crea las tablas de dia y año       
	days = {}
	years = {}

	-- Poblar la tabla de dia
	for d = 1, 31 do
		days[d] = d
	end
		
	-- Poblar la tabla de años
	for y = 80, 1, -1 do
		years[y] = tonumber(dates[3].year) - y + 1
	end
	
	
	local dates2 = {}
	if dateb ~= "0000-00-00" then
		for Ye, Mi, Da in string.gmatch( dateb, "(%w+)-(%w+)-(%w+)" ) do
			dates2[1] = Da
			dates2[2] = Mi
			dates2[3] = Ye
		end
		dates2[3] = tonumber( dates[3].year - dates2[3] + 1 )
	else
		dates2[1] = 1
		dates2[2] = 1
		dates2[3] = 1
	end

	-- Configure las columnas de la rueda selectora
	local columnData = {
		{
			align = "center",
			width = intW/3,
			startIndex = tonumber( dates2[1] ),
			labels = days
		},
		{
			align = "center",
			width = intW/3,
			labelPadding = 10,
			startIndex = tonumber( dates2[2] ),
			labels = months
		},
		{
			align = "center",
			labelPadding = 10,
			width = intW/3,
			startIndex = tonumber( dates2[3] ),
			labels = years
		}
	}

	-- pickerWheel
	pickerWheel = widget.newPickerWheel({
		x = display.contentCenterX,
		top =   - 50,
		columns = columnData,
		style = "resizable",
		width = intW,
		rowHeight = 60,
		fontSize = 35,
		--columnColor = { 0, 0, 0, 1 },
		fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 129/255, 61/255, 153/255},
	})  
	pickerWheel.anchorY = 0
	grpDatePicker:insert( pickerWheel )
	
end