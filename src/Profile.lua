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
RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local scrPerfile, scrElements
local grpTextProfile, grpOptionsLabel, grpOptionsCombo

-- Variables
local posY = 350
local textUserName, textUserResidence
local toggleButtons = {}
local hobbies = {}
local myHobbies = {}
local languages = {}
local myLanguages = {}
local posYE = 0
local myElements = {}
local container = {}
local lblInts, lblLang
local btnSaveProfile

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

--------------------------------
-- Guarda la lista de hobbies
--------------------------------
function setList(hobbie, language)
	hobbies = hobbie
	languages = language
end

--------------------------------
-- Guarda los datos del perfil
--------------------------------
function saveProfile()
	btnSaveProfile:removeEventListener( 'tap', saveProfile )
	tools:setLoading(true,scrPerfile)
	for i=1, #myHobbies, 1 do
		myHobbies[i] = string.gsub( myHobbies[i], "/", '...' )
	end
	for i=1, #myLanguages, 1 do
		myLanguages[i] = string.gsub( myLanguages[i], "/", '...' )
	end
	RestManager.saveProfile(textUserName.text, textUserResidence.text, toggleButtons[1].onOff, toggleButtons[2].onOff,toggleButtons[3].onOff,myHobbies, myLanguages)
end

--devuelve el resultado de guardar los datos
function resultSaveProfile( isTrue, message)
	grpTextProfile.x = intW
	NewAlert(true, message)
	timeMarker = timer.performWithDelay( 1000, function()
		NewAlert(false, message)
		grpTextProfile.x = 0
		tools:setLoading(false,scrPerfile)
		btnSaveProfile:addEventListener( 'tap', saveProfile )
	end, 1 )
	
end

function savePreferences( event )
	t = event.target
	local labelPreferences
	if #myElements > 0 then
        local max = 4
        if #myElements < max then 
            max = #myElements 
        end
        for i=1, max do
            if i == 1 then
                labelPreferences = myElements[i]
            else
                labelPreferences = labelPreferences..', '..myElements[i]
            end
        end
        if #myElements > max then 
            labelPreferences = labelPreferences .. '...'
        end
    else
		if t.name == "hobbies" then
			labelPreferences = 'Editar pasatiempos'
		end
    end
	
	if t.name == "hobbies" then
		myHobbies = myElements
		lblInts.text = labelPreferences
	else
		myLanguages = myElements
		lblLang.text = labelPreferences
	end
	if grpOptionsLabel then
		grpOptionsLabel:removeSelf()
		grpOptionsLabel = nil
	end
	grpTextProfile.x = 0
	container = nil
	container = {}
	return true
end

--------------------------------
-- cierra todo los componentes
-------------------------------
function closeAll( event )
	native.setKeyboardFocus(nil)
	deleteGrpScrCity()
	return true
end

----------------------------------
-- inicia una nueva conversacion
----------------------------------
function startConversation( event )
	RestManager.startConversation(event.target.id)
	return true
end

-------------------------------------------------------
-- crea la informacion e inicia la conversacion(chats)
-- @param item informacion del perfil
-------------------------------------------------------
function showNewConversation(item)
	local tmpList = {id = 0, photo = item.image, name = item.display_name, subject = "", channelId = item.channel_id,
			blockMe = item.blockMe, blockYour = item.blockYour, NoRead = 0, identifier = item.identifier}
	composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = tmpList } } )
end

---------------------------------------------------------------------------
-- Pinta la imagen del usuario en caso de no encontrarse al crear la scena
-- @param item nombre de la imagen
---------------------------------------------------------------------------
function setImagePerfil( item )
	local avatar = display.newImage(item[1].image, system.TemporaryDirectory)
	avatar:translate(midW - 190, 170)
	avatar.height = 230
	avatar.width = 230
	scrPerfile:insert(avatar)
end

function getCityProfile(city)
	textUserResidence.text = city
end

function userInputProfile( event )
	local t = event.target
	if ( event.phase == "began" ) then
		if t.name == "residence" then
			textUserName.y = 100
		end
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
		if t.name == "residence" then
			textUserName.y = 130
		end
    elseif ( event.phase == "editing" ) then
		if t.name == "residence" then
			RestManager.getCity(t.text, "residence", scrPerfile)
		end
    end
	
	return true
end

--mueve el toggleButton
function moveToggleButtons( event )
	
	local t = event.target
	if t.onOff == "Sí" then
		t.onOff = "No"
		transition.to( t, { x = 303, time = 200})
	else
		t.onOff = "Sí"
		transition.to( t, { x = 403, time = 200})
	end
	
end

--se crean los togle buttons
function createToggleButtons(item, posY2)

	for i=1, 3, 1 do
		-- BG Component
		local bg0CheckAcco = display.newRect( 300, posY2, 200, 50 )
		bg0CheckAcco.anchorY = 0
		bg0CheckAcco.anchorX = 0
		bg0CheckAcco:setFillColor( 89/255, 31/255, 103/255 )
		scrPerfile:insert(bg0CheckAcco)
		
		local bg0CheckAcco = display.newRect( 303, posY2 + 3, 194, 44 )
		bg0CheckAcco.anchorY = 0
		bg0CheckAcco.anchorX = 0
		bg0CheckAcco:setFillColor( 129/255, 61/255, 153/255 )
		scrPerfile:insert(bg0CheckAcco)
		
		local lblYes = display.newText({
			text = "Si", 
			x = 350, y = posY2 + 25,
			width = 100,
			font = native.systemFont, 
			fontSize = 35, align = "center"
		})
		lblYes:setFillColor( 1 )
		scrPerfile:insert(lblYes)
		
		local lblNo = display.newText({
			text = "No", 
			x = 450, y = posY2 + 25,
			width = 100,
			font = native.systemFont, 
			fontSize = 35, align = "center"
		})
		lblNo:setFillColor( 1 )
		lblNo.alpha = .8
		scrPerfile:insert(lblNo)
		
		local posXTB = 303 + 100
		local onOff
		--alojamiento
		if i == 1 and item.alojamiento ~= nil and item.alojamiento == 'Sí' then
			onOff = "Sí"
			posXTB = 303 + 100
		elseif i == 1 then
			onOff = "No"
			posXTB = 303
		end
		-- transporte
		
		if i == 2 and item.vehiculo ~= nil and item.vehiculo == 'Sí' then
			
			onOff = "Sí"
			posXTB = 303 + 100
		elseif i == 2 then
			onOff = "No"
			posXTB = 303
		end
		--disponibilidad
		if i == 3 and item.diponibilidad ~= nil and item.diponibilidad == 'Siempre' then
			onOff = "Sí"
			posXTB = 303 + 100
		elseif i == 3 then
			onOff = "No"
			posXTB = 303
		end
		local num = #toggleButtons + 1
		
		toggleButtons[num] = display.newRect( posXTB, posY2 + 3, 97, 44 )
		toggleButtons[num].anchorY = 0
		toggleButtons[num].anchorX = 0
		toggleButtons[num].onOff = onOff
		toggleButtons[num]:setFillColor( 89/255, 31/255, 103/255 )
		scrPerfile:insert(toggleButtons[num])
		toggleButtons[num]:addEventListener( 'tap', moveToggleButtons )
		
		posY2 = posY2 + 75
		
	end

end

--añade los elementos selecionados
function addElements(name)

	local num = #container + 1
	container[num] = display.newContainer( 600, 80 )
	scrElements:insert(container[num])
	container[num].anchorY = 0
	container[num]:translate( 300, posYE )

	local bg0OptionCombo = display.newRect( 0, 0, 600, 80 )
	bg0OptionCombo:setFillColor( 1 )
	bg0OptionCombo.name = name
	container[num]:insert( bg0OptionCombo )
	bg0OptionCombo:addEventListener( 'tap', noAction )
		
	local lblNameOption = display.newText({
		text = name, 
		x = 0, y = 0,
		width = 500,
		font = native.systemFont, 
		fontSize = 30, align = "left"
	})
	lblNameOption:setFillColor( 0 )
	container[num]:insert(lblNameOption)
			
	local deleteElements = display.newImage("img/delete.png")
	deleteElements:translate(260, 0)
	deleteElements.height = 50
	deleteElements.width = 50
	deleteElements.id = num
	container[num]:insert(deleteElements)
	deleteElements:addEventListener( 'tap', deleteElement )
		
	posYE = posYE + 83

end 

--elimina un elemento de la lista
function deleteElement( event )
	local t = event.target.id
	container[t]:removeSelf()
	table.remove( container, t )
	table.remove( myElements, t )
	posYE = 0
	for i=1,#container, 1 do
		container[i].y = posYE
		posYE = posYE + 83
		container[i][3].id = i
	end
	return true
end

--obtiene el resulado del combobox
function getOptionCombo( event )
	local t = event.target
	t.alpha = .5
	timeMarker = timer.performWithDelay( 100, function()
		t.alpha = 1
		hideOptionsCombo("")
		myElements[#myElements + 1] = t.name
		addElements(t.name)
		
	end, 1 )
	return true
end

--muestra las opciones del combobox
function showOptionsCombo( event )
	local t2 = event.target
	local setElements = {}
	if t2.name == "hobbies" then
		setElements = hobbies
	else
		setElements = languages
	end
	
	if not grpOptionsCombo then
	
		grpOptionsCombo = display.newGroup()
		grpOptionsLabel:insert(grpOptionsCombo)
	
		local bg0OptionCombo = display.newRoundedRect( midW, h + 186, 606, 606, 10 )
		bg0OptionCombo:setFillColor( 129/255, 61/255, 153/255 )
		bg0OptionCombo.anchorY = 0
		grpOptionsCombo:insert( bg0OptionCombo )
		bg0OptionCombo:addEventListener( 'tap', noAction)
	
		local bg0OptionCombo = display.newRect( midW, h + 178, 606, 20 )
		bg0OptionCombo:setFillColor( 129/255, 61/255, 153/255 )
		bg0OptionCombo.anchorY = 0
		grpOptionsCombo:insert( bg0OptionCombo )
	
		--scrollview
		local scrOptionCombo = widget.newScrollView({
			top = h + 185,
			left = 84,
			width = 600,
			height = 600,
			horizontalScrollDisabled = true,
			backgroundColor = { .8 },
		})
		grpOptionsCombo:insert(scrOptionCombo)
		
		local posYTemp = 0
		for i = 1, #setElements, 1 do
			local isTrue = false
			for j = 1, #myElements, 1 do
				if setElements[i].name == myElements[j] then
					isTrue = true
				end
			end
			if not isTrue then
				local bg0OptionCombo = display.newRect( 300, posYTemp, 600, 80 )
				bg0OptionCombo:setFillColor( 1 )
				bg0OptionCombo.anchorY = 0
				bg0OptionCombo.name = setElements[i].name
				bg0OptionCombo.id = setElements[i].id
				scrOptionCombo:insert( bg0OptionCombo )
				bg0OptionCombo:addEventListener( 'tap', getOptionCombo )
		
				local lblNameOption = display.newText({
					text = setElements[i].name, 
					x = 300, y = posYTemp + 40,
					width = 500,
					font = native.systemFont, 
					fontSize = 30, align = "left"
				})
				lblNameOption:setFillColor( 0 )
				scrOptionCombo:insert(lblNameOption)
		
				posYTemp = posYTemp + 83
			end
		end
	else
		hideOptionsCombo( event )
	end
	return true
end

function hideOptionsCombo( event )
	if grpOptionsCombo then
		grpOptionsCombo:removeSelf()
		grpOptionsCombo = nil
	end
	return true
end

--crea las opciones de las etiquetas
function showOptionsLabels( event )
	--hobbies
	local t = event.target
	if t.type == "create" then
		if grpOptionsLabel then
			grpOptionsLabel:removeSelf()
			grpOptionsLabel = nil
		end
		grpTextProfile.x = intW
		grpOptionsLabel = display.newGroup()
	
		--combobox
		local bg0 = display.newRect( midW, midH + h, intW, intH )
		bg0:setFillColor( 0 )
		bg0.alpha = .8
		bg0.type = "destroy"
		grpOptionsLabel:insert( bg0 )
		bg0:addEventListener( 'tap', showOptionsLabels )
		
		local bg1 = display.newRoundedRect( midW, midH + h, 660, intH - 100, 10 )
		bg1:setFillColor( 1 )
		grpOptionsLabel:insert( bg1 )
		bg1:addEventListener( 'tap', hideOptionsCombo )
		
		local bg0ComboBox = display.newRoundedRect( midW, h + 100, 606, 86, 10 )
		bg0ComboBox:setFillColor( 129/255, 61/255, 153/255 )
		bg0ComboBox.anchorY = 0
		grpOptionsLabel:insert( bg0ComboBox )
		bg0ComboBox:addEventListener( 'tap', noAction )
		
		local bg1ComboBox = display.newRoundedRect( midW, h + 103, 600, 80, 10 )
		bg1ComboBox:setFillColor( 1 )
		bg1ComboBox.anchorY = 0
		bg1ComboBox.name = t.name
		grpOptionsLabel:insert( bg1ComboBox )
		bg1ComboBox:addEventListener( 'tap', showOptionsCombo )
		
		local lblTitleCombo = display.newText({
			text = t.label, 
			x = midW, y = h + 160,
			width = 550, height = 80,
			font = native.systemFont, 
			fontSize = 36, align = "left"
		})
		lblTitleCombo:setFillColor( 0 )
		grpOptionsLabel:insert(lblTitleCombo)
		
		local triangle = display.newImage("img/triangleDown.png")
		triangle:translate(650, h + 145)
		grpOptionsLabel:insert(triangle)
		
		--elementos selecionados
		
		local bg0Elemets = display.newRoundedRect( midW, h + 230, 606, intH/2 + 6, 10 )
		bg0Elemets:setFillColor( 129/255, 61/255, 153/255 )
		bg0Elemets.anchorY = 0
		grpOptionsLabel:insert( bg0Elemets )
		
		--scrollview
		scrElements = widget.newScrollView({
			top = h + 233,
			left = 84,
			width = 600,
			height = intH/2,
			horizontalScrollDisabled = true,
			backgroundColor = { .8 },
		})
		grpOptionsLabel:insert(scrElements)
		
		posYE = 0
		if t.name == "hobbies" then
			myElements = myHobbies
		else
			myElements = myLanguages
		end
		
		for i = 1, #myElements, 1 do
			addElements(myElements[i])
		end
		
		--button
		local btnAceptOption = display.newRoundedRect( midW, intH - 100, 600, 80, 10 )
		btnAceptOption:setFillColor( {
			type = 'gradient',
			color1 = { 129/255, 61/255, 153/255 }, 
			color2 = { 89/255, 31/255, 103/255 },
			direction = "bottom"
		} )
		grpOptionsLabel:insert(btnAceptOption)
		btnAceptOption.name = t.name
		btnAceptOption:addEventListener( 'tap', savePreferences )
		local lblStartChat = display.newText({
			text = "Aceptar", 
			x = midW, y = intH - 100,
			font = native.systemFontBold,   
			fontSize = 30, align = "center"
		})
		lblStartChat:setFillColor( 1 )
		grpOptionsLabel:insert(lblStartChat)
		
	elseif t.type == "destroy" then
		if grpOptionsLabel then
			grpOptionsLabel:removeSelf()
			grpOptionsLabel = nil
		end
		grpTextProfile.x = 0
		container = nil
		container = {}
	end
		
	return true
end

---pinta los datos de otros usuarios
function otherProfile( item )

	-- informacion personal
    local lblName = display.newText({
        text = item.userName, 
        x = 550, y = 150,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 35, align = "left"
    })
    lblName:setFillColor( 0 )
    scrPerfile:insert(lblName)
	if not item.edad then item.edad = "" else item.edad = item.edad .. " Años" end
    local lblAge= display.newText({
        text = item.edad, 
        x = 550, y = 200,
        width = 400,
        font = native.systemFont, 
        fontSize = 35, align = "left"
    })
    lblAge:setFillColor( 0 )
    scrPerfile:insert(lblAge)
    local lblInts = display.newText({
        text = "", 
        x = 550, y = 250,
        width = 400,
        font = native.systemFont, 
        fontSize = 25, align = "left"
    })
    lblInts:setFillColor( 0 )
    scrPerfile:insert(lblInts)
	
	if item.hobbies then
        local max = 4
        if #item.hobbies < max then 
            max = #item.hobbies 
        end
        for i=1, max do
            if i == 1 then
                lblInts.text = item.hobbies[i]
            else
                lblInts.text = lblInts.text..', '..item.hobbies[i]
            end
        end
        if #item.hobbies > max then 
            lblInts.text = lblInts.text..'...'
        end
    else
        lblInts.text = ''
    end
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY, 650, 460, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    scrPerfile:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY, 646, 456, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    scrPerfile:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY, 650, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    scrPerfile:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, 650, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    scrPerfile:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "DETALLE:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    scrPerfile:insert(lblTitle)
	--disponibilidad
	local availability, iconAvailability, leng
	local iconOpcion = {}
	local infoOpcion = {}
	--residencia
	if not item.residencia then 
		infoOpcion[1] = ""
	else
		infoOpcion[1] = item.residencia
	end
	iconOpcion[1] = 'icoFilterCity'
	--idioma
	if item.idiomas then
        for i=1, #item.idiomas do
            if i == 1 then
                infoOpcion[2] = item.idiomas[i]
            else
                infoOpcion[2] = infoOpcion[2] ..', '.. item.idiomas[i]
            end
        end
    else
        infoOpcion[2] = ''
    end
	iconOpcion[2] = 'icoFilterLanguage'
	--alojamiento
	if item.alojamiento and item.alojamiento == 'Sí' then
		infoOpcion[3] = 'Disponible'
		iconOpcion[3] = "icoFilterCheck"
    else 
		infoOpcion[3] = 'No disponible'
		iconOpcion[3] = "icoFilterUnCheck"
    end
	-- transporte
    if item.vehiculo and item.vehiculo == 'Sí' then
        infoOpcion[4] = 'Cuenta con vehiculo propio'
		iconOpcion[4] = "icoFilterCheck"
    else 
        infoOpcion[4] = 'No cuenta con vehiculo propio'
		iconOpcion[4] = "icoFilterUnCheck"
    end 
	--disponibilidad
    if item.diponibilidad and item.diponibilidad == 'Siempre' then
        infoOpcion[5] = 'Disponible'
		iconOpcion[5] = "icoFilterCheckAvailble"
    else 
         infoOpcion[5] = 'No disponible'
		 iconOpcion[5] = "icoFilterUnCheck"
    end
    
    -- Options
    posY = posY + 45
    local opt = {
        {icon = iconOpcion[1], label= infoOpcion[1]}, 
        {icon = iconOpcion[2], label= infoOpcion[2]}, 
        {icon = iconOpcion[3], label= infoOpcion[3]}, 
        {icon = iconOpcion[4], label= infoOpcion[4]}, 
        {icon = iconOpcion[5], label= infoOpcion[5]}} 
    for i=1, #opt do
        posY = posY + 75
        
        local ico
        if opt[i].icon ~= '' then
           -- print("img/"..opt[i].icon..".png" )
            ico = display.newImage( "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = opt[i].label, 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
    end

end

function MyProfile( item )

	grpTextProfile = display.newGroup()
	scrPerfile:insert(grpTextProfile)
	
	--textField user name
	textUserName = native.newTextField( 550, 100, 400, 50 )
	textUserName.text = item.userName
	textUserName.hasBackground = false
	textUserName.size = 35
	textUserName:resizeHeightToFitFont()
	textUserName:addEventListener( "userInput", userInputProfile )
	grpTextProfile:insert(textUserName)
	
	if not item.edad then item.edad = "" else item.edad = item.edad .. " Años" end
    local lblAge= display.newText({
        text = item.edad, 
        x = 550, y = 180,
        width = 400,
        font = native.systemFont, 
        fontSize = 35, align = "left"
    })
    lblAge:setFillColor( 0 )
    scrPerfile:insert(lblAge)
	-- BG Component
    local bgInts = display.newRect( 550, 210, 410, 80 )
    bgInts.anchorY = 0
    bgInts:setFillColor( 1 )
	bgInts.alpha = .02
	bgInts.name = "hobbies"
	bgInts.label = "Tus hobbies"
	bgInts.type = "create"
    scrPerfile:insert(bgInts)
	bgInts:addEventListener( 'tap', showOptionsLabels )
	--label hobbies
    lblInts = display.newText({
        text = "", 
        x = 550, y = 250,
        width = 400,
        font = native.systemFont, 
        fontSize = 25, align = "left"
    })
    lblInts:setFillColor( 0 )
    scrPerfile:insert(lblInts)
	myHobbies = item.hobbies
	if item.hobbies then
        local max = 4
        if #item.hobbies < max then 
            max = #item.hobbies 
        end
        for i=1, max do
            if i == 1 then
                lblInts.text = item.hobbies[i]
            else
                lblInts.text = lblInts.text..', '..item.hobbies[i]
            end
        end
        if #item.hobbies > max then 
            lblInts.text = lblInts.text..'...'
        end
    else
        lblInts.text = 'Editar pasatiempos'
    end
	
	 -- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY, 650, 460, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    scrPerfile:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY, 646, 456, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    scrPerfile:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY, 650, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    scrPerfile:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, 650, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    scrPerfile:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "DETALLE:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    scrPerfile:insert(lblTitle)
	local iconOpcion = { 'icoFilterCity', 'icoFilterLanguage', 'icoFilterCheckAvailble', 'icoFilterCheckAvailble', 'icoFilterCheckAvailble' }
	local infoOpcion = { 'Residencia', 'Idioma', 'Alojamiento', 'Vehiculo', 'Disponibilidad'}
	
	local tempPosY = posY
	posY = posY + 125
	
	--textField residence
	textUserResidence = native.newTextField( 500, posY, 400, 50 )
	textUserResidence.text = item.residencia
	textUserResidence.hasBackground = false
	textUserResidence.size = 25
	textUserResidence:resizeHeightToFitFont()
	textUserResidence:addEventListener( "userInput", userInputProfile )
	textUserResidence.name = "residence"
	grpTextProfile:insert(textUserResidence)
	
	posY = posY + 75
	
	-- BG Component
    local bgLangs = display.newRect( 500, posY, 400, 80 )
   -- bgLangs.anchorY = 0
    bgLangs:setFillColor( 0 )
	bgLangs.alpha = .02
	bgLangs.name = "languages"
	bgLangs.label = "Tus Idiomas"
	bgLangs.type = "create"
    scrPerfile:insert(bgLangs)
	bgLangs:addEventListener( 'tap', showOptionsLabels )
	--label language
    lblLang = display.newText({
        text = "", 
		x = 500, y = posY,
		width = 400,
		font = native.systemFont,   
		fontSize = 22, align = "left"
    })
    lblLang:setFillColor( 0 )
    scrPerfile:insert(lblLang)
	
	--idioma
	myLanguages = item.idiomas
	if item.idiomas then
        for i=1, #item.idiomas do
            if i == 1 then
                lblLang.text = item.idiomas[i]
            else
                lblLang.text = lblLang.text..', '.. item.idiomas[i]
            end
        end
    else
		lblLang.text= 'Editar tus idiomas'
    end
	
	posY = posY + 45

	-- Create the widget
	-- Image sheet options and declaration
	createToggleButtons(item, posY)
	----
	
	posY = posY + 95
	
    -- Options
	posY = tempPosY + 45
    local opt = {
        {icon = iconOpcion[1], label= infoOpcion[1]}, 
        {icon = iconOpcion[2], label= infoOpcion[2]}, 
        {icon = iconOpcion[3], label= infoOpcion[3]}, 
        {icon = iconOpcion[4], label= infoOpcion[4]}, 
        {icon = iconOpcion[5], label= infoOpcion[5]}} 
    for i=1, #opt do
        posY = posY + 75
        
        local ico
        if opt[i].icon ~= '' then
           -- print("img/"..opt[i].icon..".png" )
            ico = display.newImage( "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = opt[i].label, 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
    end
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

---------------------------------------------
-- Se crea la scena con los datos del perfil
---------------------------------------------
function scene:create( event )
	local item = event.params.item
	screen = self.view
    --screen.y = h
	
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
	
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	o:addEventListener( 'tap', closeAll )
	
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
	
	--tools
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	RestManager.getHobbies()

	--scrollview
	scrPerfile = widget.newScrollView({
        top = 100 + h,
        left = 0,
        width = intW,
        height = intH-(100+h),
        hideBackground = true,
		horizontalScrollDisabled = true,
    })
	screen:insert(scrPerfile)
    
    -- Avatar
    local bgA1 = display.newRoundedRect( midW - 190, 170, 270, 270, 10 )
    bgA1:setFillColor( 11/225, 163/225, 212/225 )
    scrPerfile:insert(bgA1)
    
    local bgA2 = display.newRect( midW - 190, 170, 240, 240 )
    bgA2:setFillColor( 0, 193/225, 1 )
    scrPerfile:insert(bgA2)
    
	local path = system.pathForFile( item.image, system.TemporaryDirectory )
	local fhd = io.open( path )
	--verifica si existe la imagen
	if fhd then
		local avatar = display.newImage(item.image, system.TemporaryDirectory)
		avatar:translate(midW - 190, 170)
		avatar.height = 230
		avatar.width = 230
		scrPerfile:insert(avatar)
	else
		local items = {}
		items[1] = item
		RestManager.getImagePerfile(items)
	end
	
	if item.isMe == false then
	
		otherProfile( item )
	
		if isReadOnly then
			posY = posY + 120
			local lblReadOnly = display.newText( {
			text = "¿QUIERES CONVERSAR CON " .. item.userName .. "?",     
			x = midW, y = posY, width = 600,
			font = "Lato-Regular", fontSize = 26, align = "center"
			})
			lblReadOnly:setFillColor( 85/255, 85/255, 85/255 )
			scrPerfile:insert(lblReadOnly)
			
			posY = posY + 100
        
			local rctFree = display.newRoundedRect( midW, posY, 350, 80, 5 )
			rctFree:setFillColor( .2, .6 ,0 )
			rctFree.screen = "LoginSplash"
			rctFree:addEventListener( 'tap', toScreen)
			scrPerfile:insert(rctFree)
        
			local lblSign = display.newText( {
				text = "¡Registrate ahora!",     
				x = midW, y = posY, width = 600,
				fontSize = 32, align = "center"
			})
			lblSign:setFillColor( 1 )
			scrPerfile:insert(lblSign)
		
		else
			-- Btn Iniciar conversación
			posY = posY + 120
			local btnStartChat = display.newRoundedRect( midW, posY, 650, 80, 10 )
			btnStartChat.id = item.id
			btnStartChat:setFillColor( {
				type = 'gradient',
				color1 = { 129/255, 61/255, 153/255 }, 
				color2 = { 89/255, 31/255, 103/255 },
				direction = "bottom"
			} )
			scrPerfile:insert(btnStartChat)
			btnStartChat:addEventListener( 'tap', startConversation)
			local lblStartChat = display.newText({
				text = "INICIAR CONVERSACIÓN", 
				x = midW, y = posY,
				font = native.systemFontBold,   
				fontSize = 25, align = "center"
			})
			lblStartChat:setFillColor( 1 )
			scrPerfile:insert(lblStartChat)
		end
	else
	
		MyProfile( item )
	
		-- Btn Iniciar conversación
			posY = posY + 120
			btnSaveProfile = display.newRoundedRect( midW, posY, 650, 80, 10 )
			btnSaveProfile.id = item.id
			btnSaveProfile:setFillColor( {
				type = 'gradient',
				color1 = { 129/255, 61/255, 153/255 }, 
				color2 = { 89/255, 31/255, 103/255 },
				direction = "bottom"
			} )
			scrPerfile:insert(btnSaveProfile)
			btnSaveProfile:addEventListener( 'tap', saveProfile )
			local lblSaveProfile = display.newText({
				text = "Editar Perfil", 
				x = midW, y = posY,
				font = native.systemFontBold,   
				fontSize = 25, align = "center"
			})
			lblSaveProfile:setFillColor( 1 )
			scrPerfile:insert(lblSaveProfile)
	end
	
	scrPerfile:setScrollHeight(5000)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
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