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

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpTextField, grpDatePicker

-- Variables
local txtLocation, txtIniDate, txtEndDate, txtIniAge, txtEndAge
local datePicker
local days = {}
local months = {"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dec"}
local years = {}
local poscTabla = {}
local scrDatePicker
local lblSlider1, lblSlider2
local genH, genM
local lblIniDate, lblEndDate

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

--
function changeGender( event )
	
	if event.target.name == "M" then
		genH.alpha = 0
		genM.alpha = 1
	else
		genM.alpha = 0
		genH.alpha = 1
	end
	
end

function sliderListener( event )
		
	if event.phase == "moved" then
	
		if event.value > 17 and event.value < 100 then
			if event.target.name == "slider1" then
				if event.value >= tonumber(lblSlider2.text) then
					event.target:setValue(tonumber(lblSlider1.text))
				else
					lblSlider1.text = event.value
				end
			elseif event.target.name == "slider2" then
				if event.value <= tonumber(lblSlider1.text) then
					event.target:setValue(tonumber(lblSlider2.text))
				else
					lblSlider2.text = event.value
				end
			end
		end
	
		if event.value < 18 then
			event.target:setValue(18)
		end
		if event.value > 99 then
			event.target:setValue(99)
		end
		
	end
	return true
end

--llena las tablas de fecha
function setDate()
	-- Populate the "days" table
	for d = 1, 31 do
		days[d] = d
	end

	-- Populate the "years" table
	for y = 1, 10 do
		years[y] = 2015 + y
	end
end

function changeDate( event )

	local arrow = event.target
	local total
	if arrow.tabla == 1 then
		total = #months
	elseif arrow.tabla == 2 then
		total = #days
	else
		total = #years
	end
	if arrow.type == "up" and poscTabla[arrow.tabla] < total then
		local x, y = scrDatePicker[arrow.tabla]:getContentPosition()
		scrDatePicker[arrow.tabla]:scrollToPosition{
			y = y - 66,
			time = 50,
		}
		poscTabla[arrow.tabla] = poscTabla[arrow.tabla]  + 1
	elseif arrow.type == "down" and poscTabla[arrow.tabla] > 1 then
		local x, y = scrDatePicker[arrow.tabla]:getContentPosition()
		scrDatePicker[arrow.tabla]:scrollToPosition{
			y = y + 66,
			time = 50,
		}
		poscTabla[arrow.tabla] = poscTabla[arrow.tabla]  - 1
	end

	return true
end

--crea el datepicker
function createDatePicker( event )
	
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	
	grpTextField.x = -intW
	
	grpDatePicker = display.newGroup()
	screen:insert(grpDatePicker)
	
	local bgDatePicker = display.newRect( midW, midH + h, intW, intH )
	bgDatePicker:setFillColor( 0 )
	bgDatePicker.alpha = .9
    grpDatePicker:insert(bgDatePicker)
	
	--mostramos el tipo de datePicker
	datePickerAndroid(event.target)
	local platformName = system.getInfo( "platformName" )
	
	--[[if platformName == "Mac OS X" or platformName == "iPhone OS"  then
		
	else
		datePickerAndroid(event.target)
	end]]
	
end

--crea un datePicker tipo android
function datePickerAndroid( item )
	-- Create two tables to hold data for days and years
	local posXArrow = { 185, midW, 575 }
	scrDatePicker = {}
	local dates = { 
		months, days, years,
	}
	local posY = midH + h - 100
	local bg1 = display.newRect( midW, posY, 606, 606 )
	bg1:setFillColor( 1 )
    grpDatePicker:insert(bg1)
	
	local bg2 = display.newRoundedRect( midW, posY, 600, 600, 5 )
	bg2:setFillColor( .2 )
    grpDatePicker:insert(bg2)
	
	posY = posY - 250
	local nameTitle = "Fecha de inicio"
	if item.name == "endDate" then nameTitle = "Fecha de terminacion" end
	local labelTitle = display.newText({
            text = nameTitle, 
            x = midW, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 40, align = "center"
        })
	labelTitle:setFillColor( 1 )
	grpDatePicker:insert(labelTitle)
	
	posY = posY + 40
	
	local line1 = display.newRect( midW, posY, 550, 4 )
	line1:setFillColor( 1 )
	line1.alpha = .8
    grpDatePicker:insert(line1)
	
	posY = posY + 50
	
	--arrow
	
	for y=1, 3 do
	
		local arrowUp = display.newImage( screen, "img/arrowUp.png" )
		arrowUp:translate( posXArrow[y], posY )
		arrowUp.type = "up"
		arrowUp.tabla = y
		grpDatePicker:insert(arrowUp)
		arrowUp:addEventListener( 'tap', changeDate )
	
		local arrowDown = display.newImage( screen, "img/arrowDown.png" )
		arrowDown:translate( posXArrow[y], posY + 310 )
		arrowDown.type = "down"
		arrowDown.tabla = y
		grpDatePicker:insert(arrowDown)
		arrowDown:addEventListener( 'tap', changeDate )
		
		poscTabla[y] = 1
	
		local lastY = 33
	
		scrDatePicker[y] = widget.newScrollView({
			top = posY + 55,
			left = posXArrow[y] - 50,
			width = 100,
			height = 200,
			horizontalScrollDisabled = true,
			verticalScrollDisabled = true,
			backgroundColor = { .2  }
		})
		grpDatePicker:insert(scrDatePicker[y])
		
		local dateCurrent = dates[y]
	
		for i=1, #dates[y] do
		
			if i == 1 then
				lastY = lastY + 66
			end	
	
			local lblMonth = display.newText({
					text = dateCurrent[i], 
					x = 50, y = lastY,
					width = 100,
					font = native.systemFont,   
                fontSize = 30, align = "center"
            })
			lblMonth:setFillColor( 1 )
			scrDatePicker[y]:insert(lblMonth)
		
			lastY = lastY + 66
		
		end
		scrDatePicker[y]:setScrollHeight(lastY + 33)
	
		local bg1 = display.newRect( posXArrow[y], posY + 85, 100, 64 )
		bg1:setFillColor( 0 )
		bg1.alpha = .2
		grpDatePicker:insert(bg1)
	
		local line1 = display.newRect( posXArrow[y], posY + 54 + 64, 100, 4 )
		line1:setFillColor( 1 )
		grpDatePicker:insert(line1)
		
		local bg2 = display.newRect( posXArrow[y], posY + 221, 100, 64 )
		bg2:setFillColor( 0 )
		bg2.alpha = .2
		grpDatePicker:insert(bg2)
		
		local line2 = display.newRect( posXArrow[y], posY + 189, 100, 4 )
		line2:setFillColor( 1 )
		grpDatePicker:insert(line2)
	end
	
	--buttom
	posY = posY + 410
	
	local bgButtomAccept = display.newRect( 234, posY, 300, 100 )
	bgButtomAccept:setFillColor( 1 )
    grpDatePicker:insert(bgButtomAccept)
	
	local buttomAccept = display.newRect( 233, posY + 2, 298, 98 )
	buttomAccept:setFillColor( .2 )
	buttomAccept.name = "accept"
	buttomAccept.type = item.name
    grpDatePicker:insert(buttomAccept)
	buttomAccept:addEventListener( 'tap', destroyDatePicker )
	
	local labelAccept = display.newText({
            text = "Aceptar", 
            x = 233, y = posY,
            width = 300,
            font = native.systemFont,   
            fontSize = 36, align = "center"
        })
	labelAccept:setFillColor( 1 )
	grpDatePicker:insert(labelAccept)
	
	local bgButtomCancel = display.newRect( 535, posY, 300, 100 )
	bgButtomCancel:setFillColor( 1 )
    grpDatePicker:insert(bgButtomCancel)
	
	local buttomCancel = display.newRect( 535, posY + 2, 298, 98 )
	buttomCancel:setFillColor( .2 )
	buttomCancel.name = "cancel"
    grpDatePicker:insert(buttomCancel)
	buttomCancel:addEventListener( 'tap', destroyDatePicker )
	
	local labelCancel = display.newText({
            text = "Cancelar", 
            x = 535, y = posY,
            width = 300,
            font = native.systemFont,   
            fontSize = 36, align = "center"
        })
	labelCancel:setFillColor( 1 )
	grpDatePicker:insert(labelCancel)
	
	-----------------------------------
	-----------------------------------
	
end

function destroyDatePicker( event )
	if event.target.name == "accept" then
		local month = poscTabla[1]
		local day = days[poscTabla[2]]
		local year = years[poscTabla[3]]
		if month < 10 then month = "0" .. month end
		if day < 10 then day = "0" .. day end
		local dateS = month .. "/" .. day .. "/" .. year
		local dateS2 = year .. "/" .. day .. "/" .. month
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

--creamos los textField y opciones
function createTextField( name, wField, coordX, coordY  )
	if name == "location" then
		txtLocation = native.newTextField( coordX, coordY, wField, 50 )
		txtLocation.anchorX = 1
		txtLocation.inputType = "default"
		txtLocation.hasBackground = false
		--txtLocation:addEventListener( "userInput", onTxtFocus )
		txtLocation:setReturnKey( "next" )
		grpTextField:insert( txtLocation )
	elseif name == "iniDate" then
		lblIniDate = display.newText({
            text = "00/00/0000", 
            x = coordX - 60, y = coordY,
            width = 140,
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        lblIniDate:setFillColor( 0 )
		lblIniDate.date = "00/00/0000"
        screen:insert(lblIniDate)
	elseif name == "endDate" then
		lblEndDate = display.newText({
            text = "00/00/0000", 
            x = coordX - 60, y = coordY,
            width = 140,
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        lblEndDate:setFillColor( 0 )
		lblEndDate.date = "00/00/0000"
        screen:insert(lblEndDate)
	end
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
    
	grpTextField = display.newGroup()
	
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, 160, 650, 503, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, 160, 646, 500, 10 )
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
        text = "BUSQUEDA AVANZADA", 
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
        {label= 'Genero:'}, 
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
		{label = "HOMBRE", x = 430, y = -90, isGen = "H"},
        {label = "MUJER", x = 630, y = -90, isGen = "M"} ,
		}
    for i=1, #xFields do
        if  xFields[i].label then
            local lbl = display.newText({
                text = xFields[i].label, 
                x = xFields[i].x, y = posY + xFields[i].y,
                width = 100,
                font = native.systemFont,   
                fontSize = 22, align = "left"
            })
            lbl:setFillColor( .5 )
            screen:insert(lbl)
			
			if xFields[i].isGen then
				lbl:addEventListener( 'tap', changeGender )
				lbl.name = xFields[i].isGen
			end
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
	
	--slider
	
	lblSlider1 = display.newText({
        text = 18, 
        x = 340, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSlider1:setFillColor( 0 )
    screen:insert(lblSlider1)
	
	lblSlider2 = display.newText({
        text = 99, 
        x = 650, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSlider2:setFillColor( 0 )
    screen:insert(lblSlider2)
	
	local slider1 = widget.newSlider({
        top = posY - 20,
        left = 370,
        width = 250,
        value = 18,  -- Start slider at 10% (optional)
        listener = sliderListener
    })
	slider1.name = "slider1"
	screen:insert(slider1)
	
	--slider
	local slider2 = widget.newSlider({
        top = posY + 20 ,
        left = 370,
        width = 250,
        value = 99,  -- Start slider at 10% (optional)
        listener = sliderListener
    })
	slider2.name = "slider2"
	screen:insert(slider2)
    
    -- Genero
    genH = display.newImage( screen, "img/icoFilterH.png" )
    genH:translate( 350, posY - 90 )
    genM = display.newImage( screen, "img/icoFilterM.png" )
    genM:translate( 548, posY - 90 )
	genM.alpha = 0
    
    -- Search Button
    posY = posY + 150
    local btnSearch = display.newRoundedRect( midW, posY, 650, 80, 10 )
    btnSearch:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    screen:insert(btnSearch)
    local lblSearch = display.newText({
        text = "BUSCAR", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblSearch:setFillColor( 1 )
    screen:insert(lblSearch)
    
	setDate()
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	if grpTextField then
		grpTextField.x = 0
	end
end

-- Hide scene
function scene:hide( event )
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