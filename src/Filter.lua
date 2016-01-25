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
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpTextField, grpDatePicker, grpScrCity

-- Variables
local settFilter
local txtLocation
local datePicker
local days = {}
local months = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Deciembre" }
local years = {}
local poscTabla = {}
local scrDatePicker
local lblSlider1, lblSlider2
local genH, genM
local lblIniDate, lblEndDate
local slider1, slider2
local pickerWheel2

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

-------------------------------------------
-- deshabilita los eventos tap no deseados
-- deshabilita el traspaso del componentes
-------------------------------------------
function noAction( event )
	return true
end

--------------------------------
-- cierra todo los componentes
-------------------------------
function closeAll( event )
	native.setKeyboardFocus(nil)
	if grpScrCity then
		grpScrCity:removeSelf()
		grpScrCity = nil
	end
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	return true
end

--------------------------------------------
-- Filtra los usuarios por las preferencias
--------------------------------------------
function filterUser( event )
	closeAll( 0 )
	local textLocation = txtLocation.text
	if txtLocation.text == "" or txtLocation.text == " " or txtLocation.text == "  "then
		textLocation = 0
	end
	DBManager.updateFilter(textLocation, lblIniDate.date, lblEndDate.date, genH.alpha, genM.alpha, lblSlider1.text, lblSlider2.text )
	composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "slideLeft" } )
	--RestManager.getUsersByFilter()
end

-------------------------
-- Selecciona la ciudad
-------------------------
function selectCity( event )
	txtLocation.text = event.target.city
	event.target.alpha = .5
	timeMarker = timer.performWithDelay( 100, function()
		event.target.alpha = 1
		if grpScrCity then
			grpScrCity:removeSelf()
			grpScrCity = nil
		end
	end, 1 )
	return true
end

---------------------------------------------------
-- Muestra una lista de las ciudades por el nombre
-- @param item nombre de la ciudad y su pais
---------------------------------------------------
function showCities(item)

	--elimina los componentes para crear otros
	if grpScrCity then
		grpScrCity:removeSelf()
		grpScrCity = nil
	end
	--grp ciudad
	grpScrCity = display.newGroup()
	screen:insert( grpScrCity )

	local bgComp1 = display.newRect( 453, 320, 410, 340 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    grpScrCity:insert(bgComp1)
	bgComp1:addEventListener( 'tap', noAction )
	
	--pinta la lista de las ciudades
	if item ~= 0 then
		local posY = 321
		for i = 1, #item do
			local bg0 = display.newRect( 453, posY, 406, 60 )
			bg0.anchorY = 0
			bg0.city = item[i].description
			bg0:setFillColor( 1 )
			grpScrCity:insert(bg0)
			bg0:addEventListener( 'tap', selectCity )
			
			local lbl0 = display.newText({
				text = item[i].description, 
				x = 453, y = posY + 50,
				width = 390, height = 60,
				font = native.systemFont,   
				fontSize = 20, align = "left"
			})
			lbl0:setFillColor( 0 )
			grpScrCity:insert(lbl0)
			
			posY = posY + 63
		end
		bgComp1.height = 63 * #item + 2
		
	else
	
	end
end

-------------------------------------
-- Evento focus del textField
-- @param event datos del textField
-------------------------------------
function onTxtFocusFilter( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
    elseif ( event.phase == "editing" ) then
		--hace la busqueda de la ciudad
		RestManager.getCity(txtLocation.text)
    end
end

--------------------------------------
-- Marca el genero a buscar
-- @param event datos de los checkBox
--------------------------------------
function changeGender( event )
	if event.target.name == "M" then
		--si esta inactivo
		if genM.alpha == 0 then
			genM.alpha = 1
			event.target:setFillColor( .93 )
		--si esta activo
		else
			genM.alpha = 0
			event.target:setFillColor( 1 )
		end
	else
		--si esta inactivo
		if genH.alpha == 0 then
			genH.alpha = 1
			event.target:setFillColor( .93 )
		else
			genH.alpha = 0
			event.target:setFillColor( 1 )
		end
	end
end

-------------------------------------------
-- Cuarda el porcentaje de edad a filtrar
-- @param event valor de los slider
-------------------------------------------
function sliderListener( event )
	if event.phase == "moved" then
		if event.value > 17 and event.value < 100 then
			if event.target.name == "slider1" then
				if slider1.value >= slider2.value then
					slider1:setValue(slider2.value - 1)
				else
					lblSlider1.text = event.value
				end
			elseif event.target.name == "slider2" then
				if slider2.value <= slider1.value then
					slider2:setValue(slider1.value + 1)
				else
					lblSlider2.text = event.value
				end
			end
		elseif event.value < 18 then
			event.target:setValue(18)
		elseif event.value > 99 then
			event.target:setValue(99)
		end
	
		if event.value < 18 then
			event.target:setValue(18)
		end
		if event.value > 99 then
			event.target:setValue(99)
		end
	elseif event.phase == "ended" then
		if event.target.name == "slider1" then
			event.target:setValue(tonumber(lblSlider1.text))
		elseif event.target.name == "slider2" then
			event.target:setValue(tonumber(lblSlider2.text))
		end
	end
	return true
end

function DatePicker()
	
	-- Create two tables to hold data for days and years      
	local days = {}
	local years = {}

	-- Populate the "days" table
	for d = 1, 31 do
		days[d] = d
	end

	-- Populate the "years" table
	for y = 1, 15 do
		years[y] = 2015 + y
	end

	-- Configure the picker wheel columns
	local columnData = {
		-- Days
		{
			align = "left",
			width = 120,
			startIndex = 22,
			labels = days
		},
		-- Months
		{ 
			align = "center",
			width = 200,
			startIndex = 1,
			labels = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Deciembre" }
		},
		-- Years
		{
			align = "right",
			width = 200,
			startIndex = 10,
			labels = years
		}
	}

	-- Image sheet options and declaration
	local options = {
		frames = 
		{
			{ x=0, y=0, width=900, height=222 },
			{ x=900, y=0, width=900, height=222 },
			{ x=2000, y=0, width=8, height=222 }
		},
		sheetContentWidth = 1808,
		sheetContentHeight = 222
	}
	local pickerWheelSheet = graphics.newImageSheet( "img/pickerSheet4.png", options )
	
	-- Create the widget
	pickerWheel2 = widget.newPickerWheel({
		top = midH - 550,
		left = -100,
		columns = columnData,
        sheet = pickerWheelSheet,
        overlayFrame = 1,
        overlayFrameWidth = 900,
        overlayFrameHeight = 222,
        backgroundFrame = 2,
        backgroundFrameWidth = 900,
        backgroundFrameHeight = 222,
        separatorFrame = 3,
        separatorFrameWidth = 8,
        separatorFrameHeight = 222,
        columnColor = { 0, 0, 0, 0 },
        fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 129/255, 61/255, 153/255},
		fontSize = 32,
    })
	pickerWheel2:addEventListener( 'tap', noAction )
	
	grpDatePicker:insert(pickerWheel2)
	
end

--------------------------------------------
-- Crea el componente de DatePicker
--------------------------------------------
function createDatePicker( event )
	
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	
	--grpTextField.x = -intW
	
	grpDatePicker = display.newGroup()
	screen:insert(grpDatePicker)
	grpDatePicker.y = intH
	
	local index = {}
	--event.target.name
	
	local bgDatePicker = display.newRect( midW, 80, intW, 400 )
	bgDatePicker.anchorY = 0
	bgDatePicker:setFillColor( 1 )
    grpDatePicker:insert(bgDatePicker)
	
	local bgBtnDatePicker = display.newRect( midW, 50, intW, 80 )
    grpDatePicker:insert(bgBtnDatePicker)
	bgBtnDatePicker:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
	
	local btnAceptDate = display.newRect( intW, 50, 250, 80 )
	btnAceptDate.anchorX = 1
	btnAceptDate.type = event.target.name
	btnAceptDate.name = "accept"
    grpDatePicker:insert(btnAceptDate)
	btnAceptDate:addEventListener( 'tap', destroyDatePicker )
	btnAceptDate:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    })
	
	local labelAcceptDate = display.newText({
            text = "Aceptar", 
            x = intW, y = 50,
            width = 250,
            font = native.systemFont,   
            fontSize = 35, align = "center"
        })
	labelAcceptDate:setFillColor( 1 )
	labelAcceptDate.anchorX = 1
	grpDatePicker:insert(labelAcceptDate)
	
	DatePicker()
	
	transition.to( grpDatePicker, { y = intH - 406, time = 400, transition = easing.outExpo })
	
	--mostramos el tipo de datePicker
	--datePickerAndroid(event.target)
	local platformName = system.getInfo( "platformName" )
	
	--[[if platformName == "Mac OS X" or platformName == "iPhone OS"  then
		
	else
		datePickerAndroid(event.target)
	end]]
	
	return true
	
end

---------------------------
-- Destruye el datePicker
---------------------------
function destroyDatePicker( event )
	if event.target.name == "accept" then
	
		local values = pickerWheel2:getValues()

		-- Get the value for each column in the wheel (by column index)
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
	
		if tonumber(month) < 10 then month = "0" .. month2 end
		if tonumber(day) < 10 then day = "0" .. day end
		local dateS = day .. "/" .. month .. "/" .. year
		local dateS2 = year .. "-" .. month .. "-" .. day
		print(dateS)
		print(dateS2)
		if event.target.type == "iniDate" then
			lblIniDate.text = dateS
			lblIniDate.date = dateS2
		else
			lblEndDate.text = dateS
			lblEndDate.date = dateS2
		end
	end
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	grpTextField.x = 0
	return true
end

-----------------------------------------------
-- Crea los componentes
-- @param name nombre del componente
-- @param wField tamaño del componente
-- @param coordX coordenadas x donde se crea
-- @param coordY coordenadas y donde se crea
-----------------------------------------------
--creamos los textField y opciones
function createTextField( name, wField, coordX, coordY  )
	local s
	if name == "iniDate" then
		s = settFilter.iniDate
	else
		s = settFilter.endDate
	end

	local t = {}
	for Ye, Mi, Da in string.gmatch( s, "(%w+)-(%w+)-(%w+)" ) do
		t[1] = Ye
		t[2] = Mi
		t[3] = Da
	end
		
	local dateC = t[3] .. "-" .. t[2] .. "-" .. t[1]
	if dateC == "00-00-0000" then
		dateC = ""
	end

	if name == "location" then
		txtLocation = native.newTextField( coordX, coordY, wField, 50 )
		txtLocation.anchorX = 1
		txtLocation.inputType = "default"
		txtLocation.hasBackground = false
		txtLocation:addEventListener( "userInput", onTxtFocusFilter )
		txtLocation:setReturnKey( "next" )
		grpTextField:insert( txtLocation )
		grpTextField.text = settFilter.city
	elseif name == "iniDate" then
	
		lblIniDate = display.newText({
            text = dateC, 
            x = coordX - 60, y = coordY,
            width = 140,
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        lblIniDate:setFillColor( 0 )
		lblIniDate.date = settFilter.iniDate
        screen:insert(lblIniDate)
	elseif name == "endDate" then
		lblEndDate = display.newText({
            text = dateC, 
            x = coordX - 60, y = coordY,
            width = 140,
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        lblEndDate:setFillColor( 0 )
		lblEndDate.date = settFilter.endDate
        screen:insert(lblEndDate)
	end
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )

	--obtiene la configuracion de los filtros
	settFilter = DBManager.getSettingFilter()

	screen = self.view
    screen.y = h
    
	grpTextField = display.newGroup()
	
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	o:addEventListener( 'tap', closeAll )
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, 160, 650, 523, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, 160, 646, 520, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, 160, 650, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, 220, 650, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    screen:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "BÚSQUEDA AVANZADA", 
        x = 310, y = 195,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    screen:insert(lblTitle)
    
    -- Options
    local posY = 205
    local opt = {
        {icon = 'icoFilterCity', label= 'Ciudad:', wField = 410, nameField = "location"}, 
        {icon = 'icoFilterAvailable', label= 'Disponible entre:', wField = 140, nameField = "endDate"}, 
        {label= 'Género:'}, 
        {label= 'Edad Entre:'}
		}
    for i=1, #opt do
        posY = posY + 90
        if opt[i].fixM then posY = posY - 85 end
        
        local ico
        if opt[i].icon then
            ico = display.newImage( screen, "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 5 )
        end
        local lbl = display.newText({
            text = opt[i].label, 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        screen:insert(lbl)
        
        if opt[i].wField then
            local bg1 = display.newRoundedRect( 660, posY, opt[i].wField, 50, 5 )
            bg1.anchorX = 1
            bg1:setFillColor( .93 )
            screen:insert(bg1)
            local bg2 = display.newRoundedRect( 658, posY, opt[i].wField - 4, 46, 5 )
            bg2.anchorX = 1
            bg2:setFillColor( 1 )
			bg2.name = opt[i].nameField
            screen:insert(bg2)
			if opt[i].nameField == "endDate" then
				bg2:addEventListener( 'tap', createDatePicker )
			end
			createTextField(opt[i].nameField, opt[i].wField, 658, posY)
			
        end
        
        -- Fix Mujer
        if opt[i].fixM then 
            ico.x = 350 
            lbl.x = 590 
        end
    end
    
    -- Fields
    xFields = {
        {label = "y", x = 540, y = -180},
        {w = 140, x = 470, y = -180, nameField = "iniDate"},
		{label = "HOMBRE", x = 430, y = -90, w = 170, isGen = "H"},
        {label = "MUJER", x = 630, y = -90, w = 150, isGen = "M"} ,
		}
    for i=1, #xFields do
        if  xFields[i].label then
			
			if xFields[i].isGen then
				local bg0 = display.newRoundedRect( xFields[i].x - 110, posY + xFields[i].y, xFields[i].w, 70, 10 )
				bg0.anchorX = 0
				bg0:setFillColor( .93 )
				screen:insert(bg0)
				bg0:addEventListener( 'tap', changeGender )
				bg0.name = xFields[i].isGen
				
				if xFields[i].isGen == "H" and settFilter.genH == 0 then
					bg0:setFillColor( 1 )
				elseif xFields[i].isGen == "M" and settFilter.genM == 0 then
					bg0:setFillColor( 1 )
				end
			end
		
            local lbl = display.newText({
                text = xFields[i].label, 
                x = xFields[i].x, y = posY + xFields[i].y,
                width = 100,
                font = native.systemFont,   
                fontSize = 22, align = "left"
            })
            lbl:setFillColor( .5 )
            screen:insert(lbl)
			
        else
            local bg1 = display.newRoundedRect( xFields[i].x, posY + xFields[i].y, xFields[i].w, 50, 5 )
            bg1.anchorX = 1
            bg1:setFillColor( .93 )
            screen:insert(bg1)
            local bg2 = display.newRoundedRect( xFields[i].x - 2, posY + xFields[i].y, xFields[i].w - 4, 46, 5 )
            bg2.anchorX = 1
            bg2:setFillColor( 1 )
			bg2.name = xFields[i].nameField
            screen:insert(bg2)
			if xFields[i].nameField == "iniDate" then
				bg2:addEventListener( 'tap', createDatePicker )
			end
			createTextField(xFields[i].nameField, xFields[i].w, xFields[i].x, posY + xFields[i].y)
        end
    end
	
	--label slider
	lblSlider1 = display.newText({
        text = settFilter.iniAge, 
        x = 310, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSlider1:setFillColor( 0 )
    screen:insert(lblSlider1)
	
	lblSlider2 = display.newText({
        text = settFilter.endAge, 
        x = 670, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSlider2:setFillColor( 0 )
    screen:insert(lblSlider2)
	
	--slider
	
	local options = {
		frames = {
			{ x=0, y=0, width=36, height=64 },
			{ x=40, y=0, width=36, height=64 },
			{ x=80, y=0, width=36, height=64 },
			{ x=124, y=0, width=36, height=64 },
			{ x=168, y=0, width=64, height=64 }
		},
		sheetContentWidth = 232,
		sheetContentHeight = 64
	}
	local sliderSheet = graphics.newImageSheet( "img/sliderSheet2.png", options )
	
	slider1 = widget.newSlider({
        sheet = sliderSheet,
        leftFrame = 1,
        middleFrame = 2,
        rightFrame = 3,
        fillFrame = 4,
        frameWidth = 36,
        frameHeight = 64,
        handleFrame = 5,
        handleWidth = 64,
        handleHeight = 64,
        top = posY - 30,
        left= 310,
        orientation = "horizontal",
        width = 350,
		value = settFilter.iniAge,
        listener = sliderListener
	})
	slider1.name = "slider1"
	screen:insert(slider1)
	
	--slider
	slider2 = widget.newSlider({
        sheet = sliderSheet,
        leftFrame = 1,
        middleFrame = 2,
        rightFrame = 3,
        fillFrame = 4,
        frameWidth = 36,
        frameHeight = 64,
        handleFrame = 5,
        handleWidth = 64,
        handleHeight = 64,
        top = posY + 35,
        left= 310,
        orientation = "horizontal",
        width = 350,
		value = settFilter.endAge,
        listener = sliderListener
	})
	slider2.name = "slider2"
	screen:insert(slider2)
    
    -- Genero
	--genH = Hombre
	--genM = Mujer
    genH = display.newImage( screen, "img/icoFilterH.png" )
    genH:translate( 350, posY - 90 )
	genH.alpha = settFilter.genH
    genM = display.newImage( screen, "img/icoFilterM.png" )
    genM:translate( 548, posY - 90 )
	genM.alpha = settFilter.genM
    
    -- Search Button
    posY = posY + 170
    local btnSearch = display.newRoundedRect( midW, posY, 650, 80, 10 )
    btnSearch:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    screen:insert(btnSearch)
	btnSearch:addEventListener( 'tap', filterUser )
    local lblSearch = display.newText({
        text = "BUSCAR", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSearch:setFillColor( 1 )
    screen:insert(lblSearch)
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	if grpTextField then
		grpTextField.x = 0
	end
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus(nil)
	if grpTextField then
		grpTextField.x = -intW
	end
end

-- Destroy scene
function scene:destroy( event )
	if grpTextField then
		grpTextField:removeSelf()
		grpTextField = nil
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene