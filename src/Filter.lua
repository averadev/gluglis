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
local grpTextField, grpDatePicker, grpScrCity, grpFilter

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
local pickerWheel2
local sliderX = 0
local circleSlider1, circleSlider2
local checkGen = {}
local lblGen = {}
local poscCircle1, poscCircle2
local newPoscCircle = nil
local isCircle = false
local blockTouch = false
local accommodation
local bgToogle1 = nil
local toogle1 = nil
local toggleButton = nil

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

--------------------------------
-- cierra todo los componentes
-------------------------------
function closeAll( event )
	native.setKeyboardFocus(nil)
	deleteGrpScrCity()
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
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
	local textLocation = trimString(txtLocation.text)
	if txtLocation.text == "" or txtLocation.text == " " or txtLocation.text == "  " then
		textLocation = 0
	end
	typeSearch = "filter"
	DBManager.updateFilter(textLocation, lblIniDate.date, lblEndDate.date, checkGen[1].isTrue, checkGen[2].isTrue, lblSlider1.text, lblSlider2.text, accommodation, txtLocation.id )
	composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "slideLeft" } )
end

-------------------------------------------
-- asigna la ciudad selecionada
-------------------------------------------
function getCityFilter(city, id)
	txtLocation.text = city
	txtLocation.city = city
	txtLocation.id = id
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
		local itemOption = {posY = 275, posX = 465, height = 340, width = 380}
		txtLocation.city = ""
		txtLocation.id = 0
		RestManager.getCity(txtLocation.text, "location", screen, itemOption )
    end
end

-------------------------------------
-- Genera una ciudad aleatoriamente
-- @param event datos del boton
-------------------------------------
function randomCities( event )
	local numCity = math.random(1, 100)
	txtLocation.text = majorCities[numCity]
end

-------------------------------------
-- Limpia los campos de fecha
-------------------------------------
function cleanDateField( event )
	--lblIniDate.date
	lblIniDate.text = ""
	lblEndDate.text = ""
	lblIniDate.date = "0000-00-00"
	lblEndDate.date = "0000-00-00"
end


-------------------------------------
-- Mueve el toggleButton
-- @param event datos del toggleButton
-------------------------------------
function moveToggleButton( event )
	local t = event.target
	if t.onOff == "Sí" then
		t.onOff = "No"
		transition.to( toogle1, { x = toogle1.x - 70, time = 200})
		accommodation = "No"
		toogle1:setFillColor( 1 )
		bgToogle1:setFillColor( .7 )
		--toogle1:setFillColor( .9 )
	else
		t.onOff = "Sí"
		transition.to( toogle1, { x = toogle1.x + 70, time = 200})
		accommodation = "Sí"
		toogle1:setFillColor( 1 )
		bgToogle1:setFillColor( 0/255, 174/255, 239/255 )
		--toogle1:setFillColor( 129/255, 61/255, 153/255 )
	end
end

--------------------------------------
-- Marca el genero a buscar
-- @param event datos de los checkBox
--------------------------------------
function changeGender( event )
	local posc = event.target.posc
	if checkGen[posc].isTrue == 0 then
		checkGen[posc].isTrue = 1
		checkGen[posc]:setFillColor( 45/255, 10/255, 65/255 )
		lblGen[posc]:setFillColor( 1 )
	--si esta activo
	else
		checkGen[posc].isTrue = 0
		checkGen[posc]:setFillColor( 245/255 )
		lblGen[posc]:setFillColor( 0 )
	end
end

-------------------------------------------
-- crea el el widget de  fecha
-------------------------------------------
function DatePicker(name)
	
	local dates = {}
	local currentDate
	if name == "iniDate" then
		currentDate = lblIniDate.date
	elseif name == "endDate" then
		currentDate = lblEndDate.date
	end
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
	local days = {}
	local years = {}

	-- Populate the "days" table
	for d = 1, 31 do
		days[d] = d
	end

	-- Populate the "years" table
	for y = 1, 15 do
		years[y] = tonumber(dates[3].year) - 1 + y
	end

	-- Configure the picker wheel columns
	local columnData = {
		-- Days
		{
			align = "left",
			width = 120,
			startIndex = tonumber(dates[3].day),
			labels = days
		},
		-- Months
		{ 
			align = "center",
			width = 200,
			startIndex = tonumber(dates[3].month),
			labels = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Deciembre" }
		},
		-- Years
		{
			align = "right",
			width = 200,
			startIndex = 1,
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
		y = 250,
		x = 285,
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
	componentActive = "datePicker"
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	
	grpDatePicker = display.newGroup()
	screen:insert(grpDatePicker)
	grpDatePicker.y = intH
	
	local index = {}
	--background
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
	--label buttom
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
	
	--crea el datePicker
	DatePicker(event.target.name)
	--mueve el widget hacia arriba
	transition.to( grpDatePicker, { y = intH - 406, time = 400, transition = easing.outExpo })
	
	return true
	
end

---------------------------
-- Destruye el datePicker
-- Obtiene la fecha selecionada
---------------------------
function destroyDatePicker( event )
	--define si se quiere obtener la fecha o solo destruir el componente
	if event.target.name == "accept" then
		local values = pickerWheel2:getValues()

		-- obtiene los valores de las columnas
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
		--devuelve el resultado a los campos
		if event.target.type == "iniDate" then
			lblIniDate.text = dateS
			lblIniDate.date = dateS2
		else
			lblEndDate.text = dateS
			lblEndDate.date = dateS2
		end
	end
	componentActive = false
	--destruye el widget
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	grpTextField.x = 0
	return true
end

---------------------------
-- Destruye el datePicker
-- Obtiene la fecha selecionada
---------------------------
function destroyDatePicker2( )
	componentActive = false
	--destruye el widget
	if grpDatePicker then
		grpDatePicker:removeSelf()
		grpDatePicker = nil
	end
	grpTextField.x = 0
end

-----------------------------------------------
-- Crea los componentes
-- @param name nombre del componente
-- @param wField tamaño del componente
-- @param coordX coordenadas x donde se crea
-- @param coordY coordenadas y donde se crea
-----------------------------------------------
--creamos los textField y opciones
function createTextField( name, wField, coordX, coordY, typeF )
	if typeF == "textField" then
		--crea un textField si es la opcion de ciudad
		if name == "location" then
			txtLocation = native.newTextField( coordX, coordY - 1, wField, 90 )
			txtLocation.anchorX = 1
			txtLocation.inputType = "default"
			txtLocation.hasBackground = false
			txtLocation:addEventListener( "userInput", onTxtFocusFilter )
			txtLocation:setReturnKey( "next" )
			txtLocation.city = ""
			txtLocation.id = 0
			grpTextField:insert( txtLocation )
			if settFilter.city ~= '0' then
				txtLocation.text = settFilter.city
				txtLocation.city = settFilter.city
				txtLocation.id = settFilter.cityId
			end
			
		end
	elseif typeF == "datePicker" then
		--asigna la fecha de ida o vuelta
		local s
		if name == "iniDate" then
			s = settFilter.iniDate
		else
			s = settFilter.endDate
		end
		--split
		local t = {}
		for Ye, Mi, Da in string.gmatch( s, "(%w+)-(%w+)-(%w+)" ) do
			t[1] = Ye
			t[2] = Mi
			t[3] = Da
		end
		--convierte la fehca a un formato dd/mm/yyyy
		local dateC = t[3] .. "/" .. t[2] .. "/" .. t[1]
		if dateC == "00/00/0000" then
			dateC = "00/00/0000"
		end
		--crea el componente de fecha de ida
		if name == "iniDate" then
			lblIniDate = display.newText({
				text = dateC, 
				x = coordX - 70, y = coordY,
				width = 140,
				font = native.systemFont,   
				fontSize = 24, align = "left"
			})
			lblIniDate:setFillColor( 0 )
			lblIniDate.date = settFilter.iniDate
			screen:insert(lblIniDate)
		--crea el componente de fecha de vuelta
		
		elseif name == "endDate" then
			lblEndDate = display.newText({
				text = dateC,
				x = coordX - 70, y = coordY,
				width = 140,
				font = native.systemFont,   
				fontSize = 24, align = "left"
			})
			lblEndDate:setFillColor( 0 )
			lblEndDate.date = settFilter.endDate
			screen:insert(lblEndDate)
			
			--[[local imgCleanDate = display.newImage( screen, "img/iconClean.png" )
			imgCleanDate:translate( coordX + 40, coordY )
			screen:insert(imgCleanDate)
			imgCleanDate:addEventListener( 'tap', cleanDateField )]]
			
		end
	--crea el componente toggleButton
	elseif typeF == "toggleButton" then
		local lblYes = display.newText({
			text = "Si", 
			x = coordX - 150, y = coordY,
			width = 100,
			font = native.systemFont, 
			fontSize = 35, align = "center"
		})
		lblYes:setFillColor( 1 )
		screen:insert(lblYes)
		
		local posXTB = coordX - 3
		local onOff = "Sí"
		accommodation = "Sí"
		if settFilter.accommodation == "No" then
			posXTB = 303
			onOff = "No"
			accommodation = "No"
		end
		--boton del toggleButton
		--toggleButton = display.newRoundedRect( posXTB, coordY, 60, 60, 30 )
		
		--toggleButton.anchorY = 0
		--toggleButton.anchorX = 1
		--toggleButton:setFillColor( 89/255, 31/255, 103/255 )
		
		--[[
		
			toogle1 = display.newRoundedRect( xFields[i].x - 3, posY + xFields[i].y, 60, 60, 30 )
			toogle1.anchorX = 1
			toogle1:setFillColor( 129/255, 61/255, 153/255 )
			screen:insert(toogle1)
			
		]]
		
		--screen:insert(toggleButton)
		if onOff == "No" then
			--toggleButton:setFillColor( .7 )
			bgToogle1:setFillColor( .7 )
			toogle1:setFillColor( 1 )
		end
		toogle1.name = name
		bgToogle1.onOff = onOff
		bgToogle1:addEventListener( 'tap', moveToggleButton )
	end
end

---------------------------------------------------------------------
-- Evento touch de los componentes de slider
-- definen el rango de fechas de los slider cada vez que se mueven
---------------------------------------------------------------------
function listenerSlider( event )
	if event.phase == "began" then
		
		isCircle = false
		--rango valido para hacer funcionar los slider
		if event.yStart > 617 and event.yStart < 667 then
			newPoscCircle = nil
			direction = 0
			sliderX = event.x
		
			--detecta cual boton esta activo y encima de otro
			if event.x > poscCircle1 - 30 and event.x < poscCircle1 + 30 and circleSlider1.front == 1   then
				isCircle = true
				circleSlider1:toFront()
				circleSlider1.front = 1
				circleSlider2.front = 0
				newPoscCircle = circleSlider1
				newPoscCircle.name = "slider1"
			elseif event.x > poscCircle1 - 30 and event.x < poscCircle1 + 30 and circleSlider2.front == 1  then
				isCircle = true
				circleSlider2:toFront()
				circleSlider1.front = 0
				circleSlider2.front = 1
				newPoscCircle = circleSlider2
				newPoscCircle.name = "slider2"
			else
				if event.x > poscCircle1 - 30 and event.x < poscCircle1 + 30  then
					isCircle = true
					newPoscCircle = circleSlider1
					newPoscCircle.name = "slider1"
				elseif event.x > poscCircle2 - 30 and event.x < poscCircle2 + 30  then
					isCircle = true
					newPoscCircle = circleSlider2
					newPoscCircle.name = "slider2"
				end
			end
			
		end
	elseif event.phase == "moved" then
	
		print(midW - 10)
	
		if isCircle then
			local x = (event.x - sliderX)
			local xM = (event.target.x * 1.5)
			if x < 0 then
					direction = 1
			elseif x > 0 then
				direction = -1
			end
			--mueve los botones de izquierda o derecha
			--print(event.x)
			if event.x <= 221 then
				newPoscCircle.x = 222
			elseif event.x >= 591 then
				newPoscCircle.x = 590
			else
				if (circleSlider1.x >= circleSlider2.x and direction == -1 and newPoscCircle.name == "slider1" ) then
					circleSlider1.x = circleSlider2.x
				
				elseif (circleSlider1.x >= circleSlider2.x and direction == 1 and newPoscCircle.name == "slider2" ) then
					circleSlider2.x = circleSlider1.x
				else
					newPoscCircle.x = event.x
				end
				local poscX = 0
				poscX = (newPoscCircle.x - 176)/4.61
				poscX = math.round( poscX ) + 7
				if newPoscCircle.name == "slider1" then
					lblSlider1.text = tonumber(poscX)
				elseif newPoscCircle.name == "slider2" then
					lblSlider2.text = tonumber(poscX)
				end
			end
		end
	elseif event.phase == "ended" or event.phase == "cancelled" then
		if isCircle then
			--acomoda los botones a una pocision valida
			if event.x <= 221 then
				newPoscCircle.x = 222
			elseif event.x >= 591 then
				newPoscCircle.x = 590
			else
				if (circleSlider1.x >= circleSlider2.x and newPoscCircle.name == "slider1" ) then
					circleSlider1.x = circleSlider2.x
				elseif (circleSlider1.x >= circleSlider2.x and newPoscCircle.name == "slider2" ) then
					circleSlider2.x = circleSlider1.x
				else
					newPoscCircle.x = event.x
				end
			end
			local poscX = 0
			poscX = (newPoscCircle.x - 176)/4.61
			poscX = math.round( poscX ) + 7
			if newPoscCircle.name == "slider1" then
				lblSlider1.text = tonumber(poscX)
			elseif newPoscCircle.name == "slider2" then
				lblSlider2.text = tonumber(poscX)
			end
		end
		poscCircle1 = circleSlider1.x
		poscCircle2 = circleSlider2.x
		isCircle = false
	end
	return true
end

------------------------------------------------
-- detecta y manda los botones hacia adelante
------------------------------------------------
function inFront( event )
	if event.phase == "began" then
		if blockTouch == false then
			blockTouch = true
			if event.target.name == "slider1" then
				circleSlider1:toFront()
				circleSlider2.front = 0
				circleSlider1.front = 1
			elseif event.target.name == "slider2" then
				circleSlider2:toFront()
				circleSlider1.front = 0
				circleSlider2.front = 1
			end
		else
			blockTouch = false
		end
	elseif event.phase == "ended" or event.phase == "cancelled" then
		blockTouch = false
	end
end

-----------------------------------
--crea los componentes del slider
-----------------------------------
function newSlider( w,x,y )
	--background
	local bgSlider0 = display.newRoundedRect( x, y, w, 10, 5 )
    bgSlider0.anchorY = 0
    --bgSlider0:setFillColor( 129/255, 61/255, 153/255 )
	bgSlider0:setFillColor( 245/255 )
    screen:insert(bgSlider0)
	local bgSlider1 = display.newRect( x, y, w , 10 )
    bgSlider1.anchorY = 0
    bgSlider1:setFillColor( 0 )
    screen:insert(bgSlider1)
	--botones
	circleSlider1 = display.newRoundedRect( x - w/2, y + 5, 40, 40, 20 )
	circleSlider1:setFillColor( 0/255, 174/255, 239/255 )
	circleSlider1.name = "slider1"
	screen:insert(circleSlider1)
	circleSlider1.front = 0
	poscCircle1 = circleSlider1.x
	circleSlider1:addEventListener( 'touch', inFront )
	circleSlider2 = display.newRoundedRect( x + w/2, y + 5, 40, 40, 20 )
	circleSlider2:setFillColor( 0/255, 174/255, 239/255 )
	circleSlider2.name = "slider2"
	screen:insert(circleSlider2)
	poscCircle2 = circleSlider2.x
	circleSlider2.front = 0
	circleSlider2:addEventListener( 'touch', inFront )
	local poscC1 = (settFilter.iniAge - 18)*4.61
	local poscC2 = ( 99 - settFilter.endAge )*4.61
	circleSlider1.x = circleSlider1.x + tonumber(poscC1)
	circleSlider2.x = circleSlider2.x - tonumber(poscC2)
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
	--se crea y se deshace la imagen del fondo
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 0 )
    --[[o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2]]
	o:addEventListener( 'touch', listenerSlider )
	o:addEventListener( 'tap', closeAll )
	o:setFillColor( 245/255 )
    screen:insert(o)
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
	
	--creacion del toolbar
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	grpFilter = display.newGroup()
	screen:insert(grpFilter)
	--grpFilter.y = h
    
    -- BG Component
	--523
    --[[local bgComp1 = display.newRoundedRect( midW, 160, 650, 603, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, 160, 646, 600, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)]]
    
    -- Opciones
    local posY = 200 + h
    local opt = {
        {icon = 'brujula', label= 'Ciudad:', wField = 380, nameField = "location", type="textField"}, 
		{icon = 'down', label= '¿Cuando viajas?', wField = 380, nameField = "iniDate", type = "datePicker"}, 
		{icon = 'down', label= '¿Cuando Regresas?', wField = 380, nameField = "endDate", type="datePicker"}, 
        --{icon = 'icoFilterAvailable', label= ' ida', wField = 160, nameField = "endDate", type="datePicker"}, 
        --{label= 'Género:'}, 
        --{label= 'Edad Entre:'},
		--{icon = 'icoFilterCheck', label= 'Alojamiento'},
		}
		
	local line = display.newLine( 0, posY - 53 , intW, posY - 53 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	grpFilter:insert(line)	
		
    for i=1, #opt do
		
		local bgField = display.newRect( midW, posY, intW, 100 )
		bgField:setFillColor( 1 )
		grpFilter:insert(bgField)
		
		local line = display.newLine( 0, posY + 50 , intW, posY + 50)
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		grpFilter:insert(line)	
		
		local ico
        if opt[i].icon then
            ico = display.newImage( screen, "img/"..opt[i].icon..".png" )
            ico:translate( intW - 65, posY )
			grpFilter:insert(ico)
        end
		
		local lbl = display.newText({
            text = opt[i].label, 
            x = midW, y = posY,
            width = intW - 65,
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        lbl:setFillColor( 50/255 )
        grpFilter:insert(lbl)
		
        if opt[i].wField then
			local disX = 0
            local bg2 = display.newRoundedRect( 660 - disX, posY - 1, opt[i].wField - 4, 90, 5 )
            bg2.anchorX = 1
            bg2:setFillColor( 1 )
			bg2.name = opt[i].nameField
            screen:insert(bg2)
			if opt[i].nameField == "endDate" or opt[i].nameField == "iniDate" then
				bg2:addEventListener( 'tap', createDatePicker )
			end
			createTextField(opt[i].nameField, opt[i].wField, 660 - disX, posY ,  opt[i].type)
			-- - 60	
        end
        -- Fix Mujer
        if opt[i].fixM then 
            ico.x = 350 
            lbl.x = 590 
        end
		 posY = posY + 102
    end 
	
	
	
	posY = posY - 1
    -- Campos
    xFields = {
		{label = "HOMBRE", x = 0, y = 0, w = midW, type = "checkBox", isGen = "H"},
		{label = "MUJER", x = midW, y = 0, w = midW, type = "checkBox", isGen = "M"},
		{label = "Entre:", label2 = "Años", x = midW + 20, y = 102 , w = midW - 10, type = "slider", isGen = "M"},
		{label = "Requiero Alojamiento:", x = 720, y = 204, w = 140, nameField = "alojamiento:", type = "toggleButton"} 
        --[[{label = "vuelta", x = 435, y = -180},
        {w = 160, x = 370, y = -180, nameField = "iniDate", type = "datePicker"},
		{label = "HOMBRE", x = 430, y = -90, w = 170, isGen = "H"},
        {label = "MUJER", x = 630, y = -90, w = 150, isGen = "M"} ,
		{label = "MUJER", x = 630, y = -90, w = 150, isGen = "M"} ,
		{x = 500, y = 90, w = 200, nameField = "alojamiento", type = "toggleButton"} ,]]
	}
    for i=1, #xFields do
		if  xFields[i].type == "checkBox" then
			local numCheck = #checkGen + 1
			checkGen[numCheck] = display.newRect( xFields[i].x, posY + xFields[i].y, xFields[i].w, 100 )
			checkGen[numCheck].anchorX = 0
			checkGen[numCheck]:setFillColor( 45/255, 10/255, 65/255 )
			checkGen[numCheck].isTrue = 1
			checkGen[numCheck].posc = numCheck
			grpFilter:insert(checkGen[numCheck])
			checkGen[numCheck]:addEventListener( 'tap', changeGender )
			
			lblGen[numCheck] = display.newText({
                text = xFields[i].label, 
                x = xFields[i].x +  (xFields[i].w / 2), y = posY + xFields[i].y,
                width = xFields[i].w,
                font = native.systemFont,   
                fontSize = 22, align = "center"
            })
            lblGen[numCheck]:setFillColor( 1 )
            screen:insert(lblGen[numCheck])
			
			if xFields[i].isGen == "H" and settFilter.genH == 0 then
				checkGen[numCheck]:setFillColor( 245/255  )
				checkGen[numCheck].isTrue = 0
				lblGen[numCheck]:setFillColor( 0 )
			elseif xFields[i].isGen == "M" and settFilter.genM == 0 then
				checkGen[numCheck]:setFillColor( 245/255 )
				checkGen[numCheck].isTrue = 0
				lblGen[numCheck]:setFillColor( 0 )
			end
			
		end
		
		if  xFields[i].type == "slider" then
		
			local bgField = display.newRect( midW, posY + xFields[i].y, intW, 100 )
			bgField:setFillColor( 1 )
			grpFilter:insert(bgField)
			
			local lbl = display.newText({
				text = xFields[i].label, 
				x = midW, y = posY + xFields[i].y,
				width = intW - 65,
				font = native.systemFont,   
				fontSize = 24, align = "left"
			})
			lbl:setFillColor( 50/255 )
			grpFilter:insert(lbl)
			
			lblSlider1 = display.newText({
				text = settFilter.iniAge, 
				x = 185, y = posY + xFields[i].y,
				font = native.systemFontBold,   
				fontSize = 25, align = "center"
			})
			lblSlider1:setFillColor( 0 )
			grpFilter:insert(lblSlider1)
			lblSlider2 = display.newText({
				text = settFilter.endAge, 
				x = 625, y = posY + xFields[i].y,
				font = native.systemFontBold,   
				fontSize = 25, align = "center"
			})
			lblSlider2:setFillColor( 0 )
			screen:insert(lblSlider2)
			
			local lbl2 = display.newText({
				text = xFields[i].label2, 
				x = intW + 250, y = posY + xFields[i].y,
				width = intW - 65,
				font = native.systemFontBold,   
				fontSize = 25, align = "left"
			})
			lbl2:setFillColor( 0 )
			grpFilter:insert(lbl2)
			
			--creacion del slider para edad
			newSlider( xFields[i].w,  xFields[i].x, posY + xFields[i].y - 6 )
			
		end
		
		if  xFields[i].type == "toggleButton" then
			
			local bgField = display.newRect( midW, posY + xFields[i].y, intW, 100 )
			bgField:setFillColor( 1 )
			grpFilter:insert(bgField)
			
			local lbl = display.newText({
				text = xFields[i].label, 
				x = midW, y = posY + xFields[i].y,
				width = intW - 65,
				font = native.systemFont,   
				fontSize = 24, align = "left"
			})
			lbl:setFillColor( 50/255 )
			grpFilter:insert(lbl)
			
			bgToogle1 = display.newRoundedRect( xFields[i].x, posY + xFields[i].y, xFields[i].w, 70, 35 )
			bgToogle1.anchorX = 1
			bgToogle1:setFillColor( 0/255, 174/255, 239/255 )
			screen:insert(bgToogle1)
			toogle1 = display.newRoundedRect( xFields[i].x - 3, posY + xFields[i].y, 60, 60, 30 )
			toogle1.anchorX = 1
			toogle1:setFillColor( 1 )
			screen:insert(toogle1)
			createTextField(xFields[i].nameField, xFields[i].w, xFields[i].x, posY + xFields[i].y, xFields[i].type)
			
		end
		
		local line = display.newLine( 0, posY + xFields[i].y + 52, intW, posY + xFields[i].y + 52  )
		line:setStrokeColor( 227/255 )
		line:setStrokeColor( 0 )
		line.strokeWidth = 2
		grpFilter:insert(line)
	
        --[[if  xFields[i].label then
			
			if xFields[i].isGen then
				local numCheck = #checkGen + 1
				local bg0 = display.newRoundedRect( xFields[i].x - 110, posY + xFields[i].y, xFields[i].w, 70, 10 )
				bg0.anchorX = 0
				bg0:setFillColor( .93 )
				screen:insert(bg0)
				
				
				
			end
		
            
			
		elseif  xFields[i].type == "toggleButton" then 
			-- BG Component
			
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
			createTextField(xFields[i].nameField, xFields[i].w, xFields[i].x, posY + xFields[i].y, xFields[i].type)
        end]]
    end
	--[[
	--label slider
    
    -- Genero
	--genH = Hombre
	--genM = Mujer
    genH = display.newImage( screen, "img/icoFilterH.png" )
    genH:translate( 350, posY - 90 )
	--genH.alpha = settFilter.genH
    genM = display.newImage( screen, "img/icoFilterM.png" )
    genM:translate( 548, posY - 90 )
	--genM.alpha = settFilter.genM]]
    
    -- Search Button
	--170
    posY = posY + 400
    local btnSearch = display.newRect( midW, posY, intW, 120 )
    btnSearch:setFillColor( 0/255, 174/255, 239/255 )
    screen:insert(btnSearch)
	btnSearch:addEventListener( 'tap', filterUser )
    local lblSearch = display.newText({
        text = "BUSCAR", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 32, align = "center"
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