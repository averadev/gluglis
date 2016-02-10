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
local scrPerfile, scrElements, scrCombo
local grpTextProfile, grpOptionsLabel, grpOptionsCombo, grpComboBox

-- Variables
local posY = 350
local textUserName, textName, textLastName, textOriginCountry, textUserResidence, textEmailContact, textPet
local toggleButtons = {}
local hobbies = {}
local myHobbies = {}
local languages = {}
local myLanguages = {}
local sports = {}
local mySports = {}
local residenceTimes = {}
local races = {}
local workAreas = {}
local posYE = 0
local myElements = {}
local container = {}
local lblInts, lblLang, lblSport, lblResidenceTime, lblRace, lblWorkArea
local btnSaveProfile
local gender, availability, accommodation, vehicle, food, ownAccount, pet, smoke, drink, psychrotrophic

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

--------------------------------
-- Guarda la lista de hobbies
--------------------------------
function setList(hobbie, language, sport, residenceTime, race, workArea)
	hobbies = hobbie
	languages = language
	sports = sport
	residenceTimes = residenceTime
	races = race
	workAreas = workArea
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
	for i=1, #mySports, 1 do
		mySports[i] = string.gsub( mySports[i], "/", '...' )
	end
	
	textUserName.text = string.gsub(textUserName.text , "%s", "")
	textName.text = string.gsub(textName.text , "%s", "")
	textLastName.text = string.gsub(textLastName.text , "%s", "")
	textOriginCountry.text = string.gsub(textOriginCountry.text , "%s", "")
	textUserResidence.text = string.gsub(textUserResidence.text , "%s", "")
	textEmailContact.text = string.gsub(textEmailContact.text , "%s", "")
	textPet.text = string.gsub(textPet.text , "%s", "")
	RestManager.saveProfile(
		textUserName.text, 
		myHobbies,
		textName.text,
		textLastName.text,
		gender,
		textOriginCountry.text,
		textUserResidence.text,
		lblResidenceTime.text, 
		textEmailContact.text,
		availability,
		accommodation,
		vehicle,
		food,
		myLanguages,
		lblRace.text,
		lblWorkArea.text,
		ownAccount,
		textPet.text,
		mySports,
		smoke,
		drink,
		psychrotrophic
	)
end

-------------------------------------------------------------
-- Muestra una alerta con los resulado de guardar un perfil 
-------------------------------------------------------------
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

------------------------------------------------------------
-- Actualiza los tablas con las preferencias selecionadas
-- tabla hobbie e idioma
------------------------------------------------------------
function savePreferences( event )
	t = event.target
	local labelPreferences
	--genera el nuevo texto a mostrar en perfil
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
	--guarda las opciones en sus tablas
	if t.name == "hobbies" then
		myHobbies = myElements
		lblInts.text = labelPreferences
	elseif t.name == "languages" then
		myLanguages = myElements
		lblLang.text = labelPreferences
	else
		mySports = myElements
		lblSport.text = labelPreferences
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

------------------------------------------------------------------------------
-- Pinta la imagen del usuario en caso de no encontrarse al crear la scena
-- @param item nombre de la imagen
------------------------------------------------------------------------------
function setImagePerfil( item )
	local avatar = display.newImage(item[1].image, system.TemporaryDirectory)
	avatar:translate(midW - 190, 170)
	avatar.height = 230
	avatar.width = 230
	scrPerfile:insert(avatar)
end

-----------------------------------
-- Obtiene la ciudad selecionada
-----------------------------------
function getCityProfile(city)
	textUserResidence.text = city
end

-------------------------------------------------------------------
-- event focus de los textField
-- @param event name residence: realiza la buqueda de ciudades
-------------------------------------------------------------------
function userInputProfile( event )
	local t = event.target
	if ( event.phase == "began" ) then
		if t.name == "residence" then
		
		end
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
		if t.name == "residence" then
			textName.x = 485
			textLastName.x = 485
			textOriginCountry.x = 500
		end
		native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
		if t.name == "residence" then
			textName.x = intH
			textLastName.x = intH
			textOriginCountry.x = intH
			RestManager.getCity(t.text, "residence", scrPerfile)
		end
    end
	
	return true
end

----------------------------
--mueve el toggleButton
---------------------------
function moveToggleButtons( event )
	local t = event.target
	if t.onOff == "Sí" then
		t.onOff = "No"
		transition.to( t, { x = t.x - 100, time = 200})
	else
		t.onOff = "Sí"
		transition.to( t, { x = t.x + 100, time = 200})
	end
	--gender, availability, accommodation, vehicle, food, ownAccount, pet, smoke, drink, psychrotrophic
	if t.name == "gender" then
		if t.onOff == "Sí" then
			gender = "Hombre"
		else
			gender = "Mujer"
		end
		
	elseif t.name == "availability" then
		if t.onOff == "Sí" then
			availability = "Siempre" 
		else
			availability = "Consultarme" 
		end
	elseif t.name == "accommodation" then
		accommodation = t.onOff 
	elseif t.name == "vehicle" then
		vehicle = t.onOff 
	elseif t.name == "food" then
		food = t.onOff 
	elseif t.name == "ownAccount" then
		if t.onOff == "Sí" then
			ownAccount = "Por cuenta propia" 
		else
			ownAccount = "Por cuenta ajena" 
		end
	elseif t.name == "smoke" then
		smoke = t.onOff 
	elseif t.name == "drink" then
		drink = t.onOff 
	elseif t.name == "psychrotrophic" then
		psychrotrophic = t.onOff 
	end
end

function showComboBox( event )
	local t = event.target
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	grpTextProfile.x = intW
	grpComboBox = display.newGroup()
	
		--combobox
	local bg0 = display.newRect( midW, midH + h, intW, intH )
	bg0:setFillColor( 0 )
	bg0.alpha = .8
	grpComboBox:insert( bg0 )
	bg0:addEventListener( 'tap', hideComboBox )
	local bg1 = display.newRoundedRect( midW, midH + h, 606, midH, 10 )
	bg1:setFillColor( 1 )
	grpComboBox:insert( bg1 )
	--bg1:addEventListener( 'tap', hideOptionsCombo )
	--scrollview
	scrCombo = widget.newScrollView({
		top = h + 346,
		left = 84,
		width = 600,
		height = midH - 10,
		horizontalScrollDisabled = true,
		backgroundColor = { .8 },
	})
	grpComboBox:insert(scrCombo)
	local setElements = {}
	if t.name == "residenceTime" then
		setElements = residenceTimes
	elseif t.name == "race" then
		setElements = races
	elseif t.name == "workArea" then
		setElements = workAreas
	end
	local posY = 0
	for i = 1, #setElements, 1 do
		local container2 = display.newContainer( 600, 80 )
		scrCombo:insert(container2)
		container2.anchorY = 0
		container2:translate( 300, posY )
		--container2:addEventListener( 'tap', selectOptionCombo )
		local bg0OptionCombo = display.newRect( 0, 0, 600, 80 )
		bg0OptionCombo:setFillColor( 1 )
		bg0OptionCombo.name = t.name
		bg0OptionCombo.option = setElements[i].name
		container2:insert( bg0OptionCombo )
		--bg0OptionCombo:addEventListener( 'tap', noAction )
		bg0OptionCombo:addEventListener( 'tap', selectOptionCombo )
		
		--label nombre
		local lblNameOption = display.newText({
			text = setElements[i].name, 
			x = 0, y = 0,
			width = 500,
			font = native.systemFont, 
			fontSize = 30, align = "left"
		})
		lblNameOption:setFillColor( 0 )
		container2:insert(lblNameOption)
		posY = posY + 84
	end
	
end

function selectOptionCombo( event )
	local t = event.target
	if t.name == "residenceTime" then
		lblResidenceTime.text = t.option
	elseif t.name == "race" then
		lblRace.text = t.option
	elseif t.name == "workArea" then
		lblWorkArea.text = t.option
	end
	hideComboBox( "" )
	return true
	
end

function hideComboBox( event )
	local t = event.target
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	grpTextProfile.x = 0
	return true
end

-------------------------------------------------
-- Creacion de los togle buttons
-- @param item valor inicia de los elementos
-- @param posY2 coordenada y del elemento
-------------------------------------------------
function createComboBox(item, name, coordY, coordX )

	coordY = coordY - 25
	-- BG Component
	local bg0CheckAcco = display.newRect( coordX, coordY, 300, 56 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 0
	bg0CheckAcco:setFillColor( 129/255, 61/255, 153/255 )
	scrPerfile:insert(bg0CheckAcco)
	local bg0CheckAcco = display.newRect( coordX + 3, coordY + 3, 294, 50 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 0
	bg0CheckAcco:setFillColor( 1 )
	bg0CheckAcco.name = name
	scrPerfile:insert(bg0CheckAcco)
	bg0CheckAcco:addEventListener( 'tap', showComboBox )
	local triangle = display.newImage("img/triangleDown.png")
	triangle:translate(coordX + 270, coordY + 30)
	triangle.height = 20
	triangle.widget = 20
	scrPerfile:insert(triangle)
	if name == "residenceTime" then
		lblResidenceTime = display.newText({
			text = item.tiempoResidencia, 
			x = coordX + 160, y = coordY + 30,
			width = 280, height = 30,
			font = native.systemFont,   
			fontSize = 22, align = "left"
		})
		lblResidenceTime:setFillColor( 0 )
		scrPerfile:insert(lblResidenceTime)
	elseif name == "race" then
		lblRace = display.newText({
			text = item.nivelEstudio, 
			x = coordX + 160, y = coordY + 30,
			width = 280, height = 30,
			font = native.systemFont,   
			fontSize = 22, align = "left"
		})
		lblRace:setFillColor( 0 )
		scrPerfile:insert(lblRace)
	elseif name == "workArea" then
		lblWorkArea = display.newText({
			text = item.areaLaboral, 
			x = coordX + 160, y = coordY + 30,
			width = 280, height = 30,
			font = native.systemFont,   
			fontSize = 22, align = "left"
		})
		lblWorkArea:setFillColor( 0 )
		scrPerfile:insert(lblWorkArea)
	end

end

-------------------------------------------------
-- Creacion de los togle buttons
-- @param item valor inicia de los elementos
-- @param posY2 coordenada y del elemento
-------------------------------------------------
function createToggleButtons(item, name, coordY, coordX )
	coordY = coordY - 25
	-- BG Component
	local bg0CheckAcco = display.newRect( coordX, coordY, 200, 50 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 0
	bg0CheckAcco:setFillColor( 89/255, 31/255, 103/255 )
	scrPerfile:insert(bg0CheckAcco)
	local bg0CheckAcco = display.newRect( coordX + 3, coordY + 3, 194, 44 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 0
	bg0CheckAcco:setFillColor( 129/255, 61/255, 153/255 )
	scrPerfile:insert(bg0CheckAcco)
		
	--label si/no
	local lblYes = display.newText({
		text = "Si", 
		x = coordX + 50, y = coordY + 25,
		width = 100,
		font = native.systemFont, 
		fontSize = 35, align = "center"
	})
	lblYes:setFillColor( 1 )
	scrPerfile:insert(lblYes)
	local lblNo = display.newText({
		text = "No", 
		x = coordX + 150, y = coordY + 25,
		width = 100,
		font = native.systemFont, 
		fontSize = 35, align = "center"
	})
	lblNo:setFillColor( 1 )
	scrPerfile:insert(lblNo)
	if name == "gender" then
		lblYes.text = "Hombre"
		lblYes.size = 24
		lblNo.text = "Mujer"
		lblNo.size = 24
	end
		
	local posXTB = coordX + 3
	local onOff = "No"
	--alojamiento
	if name == "gender" then
		if item.genero ~= nil and item.genero == 'Hombre' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	if name == "accommodation" then
		if item.alojamiento ~= nil and item.alojamiento == 'Sí' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--availability, accommodation, vehicle, food
	-- transporte
	if name == "vehicle" then
		if item.vehiculo ~= nil and item.vehiculo == 'Sí' then	
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--disponibilidad
	if name == "availability" then
		if item.diponibilidad ~= nil and item.diponibilidad == 'Siempre' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--comida
	if name == "food" then
		if item.comida ~= nil and item.comida == 'Sí' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--cuenta propia
	if name == "ownAccount" then
		if item.cuentaPropia ~= nil and item.cuentaPropia == 'Por cuenta propia' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--fumas
	if name == "smoke" then
		if item.fumas ~= nil and item.fumas == 'Sí' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--bebes
	if name == "drink" then
		if item.bebes ~= nil and item.bebes == 'Sí' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
	--psychrotrophic
	if name == "psychrotrophic" then
		if item.psicotropicos ~= nil and item.psicotropicos == 'Sí' then
			onOff = "Sí"
			posXTB = coordX + 103
		end
	end
		--button
	local toggleButtons = display.newRect( posXTB, coordY + 3, 97, 44 )
	toggleButtons.anchorY = 0
	toggleButtons.anchorX = 0
	toggleButtons.onOff = onOff
	toggleButtons:setFillColor( 89/255, 31/255, 103/255 )
	scrPerfile:insert(toggleButtons)
	toggleButtons.name = name
	toggleButtons:addEventListener( 'tap', moveToggleButtons )

end

-------------------------------------------------
-- Añade los elementos de las preferencias
-- @param name Nombre del elemento selecionado
-------------------------------------------------
function addElements(name)

	--posicion siguiente
	local num = #container + 1
	--container
	container[num] = display.newContainer( 600, 80 )
	scrElements:insert(container[num])
	container[num].anchorY = 0
	container[num]:translate( 300, posYE )
	local bg0OptionCombo = display.newRect( 0, 0, 600, 80 )
	bg0OptionCombo:setFillColor( 1 )
	bg0OptionCombo.name = name
	container[num]:insert( bg0OptionCombo )
	bg0OptionCombo:addEventListener( 'tap', noAction )
	--label nombre
	local lblNameOption = display.newText({
		text = name, 
		x = 0, y = 0,
		width = 500,
		font = native.systemFont, 
		fontSize = 30, align = "left"
	})
	lblNameOption:setFillColor( 0 )
	container[num]:insert(lblNameOption)
	--image para eliminar el elemento
	local deleteElements = display.newImage("img/delete.png")
	deleteElements:translate(260, 0)
	deleteElements.height = 50
	deleteElements.width = 50
	deleteElements.id = num
	container[num]:insert(deleteElements)
	deleteElements:addEventListener( 'tap', deleteElement )
	posYE = posYE + 83

end 

----------------------------------------------------
--elimina un elemento de la lista de preferencias
----------------------------------------------------
function deleteElement( event )
	local t = event.target.id
	container[t]:removeSelf()
	table.remove( container, t )
	table.remove( myElements, t )
	posYE = 0
	--reacomoda la lista
	for i=1,#container, 1 do
		container[i].y = posYE
		posYE = posYE + 83
		container[i][3].id = i
	end
	return true
end

--------------------------------------
-- Obtiene el resulado del combobox
--------------------------------------
function getOptionCombo( event )
	local t = event.target
	t.alpha = .5
	timeMarker = timer.performWithDelay( 100, function()
		t.alpha = 1
		hideOptionsCombo("")
		--asigna el nuevo elemento a la tabla y a la lista
		myElements[#myElements + 1] = t.name
		addElements(t.name)
		
	end, 1 )
	return true
end

--------------------------------------------------
-- Despliega la lista de opciones de las tablas
--------------------------------------------------
function showOptionsCombo( event )
	local t2 = event.target
	local setElements = {}
	--define que tabla se ocupara
	if t2.name == "hobbies" then
		setElements = hobbies
	elseif t2.name == "languages" then
		setElements = languages
	else
		setElements = sports
	end
	
	if not grpOptionsCombo then
		--grupo
		grpOptionsCombo = display.newGroup()
		grpOptionsLabel:insert(grpOptionsCombo)
		--bg Component
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
		--muestra la lista de opciones
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
		--esconde la lista de opciones
		hideOptionsCombo( event )
	end
	return true
end

------------------------------------------------
-- Destruye la lista de opciones del combobox
------------------------------------------------
function hideOptionsCombo( event )
	if grpOptionsCombo then
		grpOptionsCombo:removeSelf()
		grpOptionsCombo = nil
	end
	return true
end

----------------------------------------
-- Crea las opciones de las etiquetas
----------------------------------------
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
		--bg que despliega las opciones
		local bg1ComboBox = display.newRoundedRect( midW, h + 103, 600, 80, 10 )
		bg1ComboBox:setFillColor( 1 )
		bg1ComboBox.anchorY = 0
		bg1ComboBox.name = t.name
		grpOptionsLabel:insert( bg1ComboBox )
		bg1ComboBox:addEventListener( 'tap', showOptionsCombo )
		--label title
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
		--titulo del combobox
		posYE = 0
		if t.name == "hobbies" then
			myElements = myHobbies
		elseif t.name == "languages" then
			myElements = myLanguages
		else
			myElements = mySports
		end
		if not myElements then
			myElements = {}
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

------------------------------------
-- Creamos los textField
------------------------------------
function createTextField( item, name, coordY )
	--textUserName, textName, textLastName, textOriginCountry, textUserResidence, textEmailContact
	if name == "name" then
		--textField user name
		textName = native.newTextField( 485, coordY, 400 , 50 )
		textName.text = item.nombre
		textName.hasBackground = false
		textName.size = 25
		textName:resizeHeightToFitFont()
		textName:addEventListener( "userInput", userInputProfile )
		textName.name = "name"
		grpTextProfile:insert(textName)
	elseif name == "lastName" then
		--textField apellido
		textLastName = native.newTextField( 485, coordY, 400, 50 )
		textLastName.text = item.apellidos
		textLastName.hasBackground = false
		textLastName.size = 25
		textLastName:resizeHeightToFitFont()
		textLastName:addEventListener( "userInput", userInputProfile )
		textLastName.name = "lastName"
		grpTextProfile:insert(textLastName)
	elseif name == "originCountry" then
		--textField pais de origen
		textOriginCountry = native.newTextField( 500, coordY, 350, 50 )
		textOriginCountry.text = item.paisOrigen
		textOriginCountry.hasBackground = false
		textOriginCountry.size = 25
		textOriginCountry:resizeHeightToFitFont()
		textOriginCountry:addEventListener( "userInput", userInputProfile )
		textOriginCountry.name = "originCountry"
		grpTextProfile:insert(textOriginCountry)
	elseif name == "residence" then
		--textField residence
		textUserResidence = native.newTextField( 500, coordY, 400, 50 )
		textUserResidence.text = item.residencia
		textUserResidence.hasBackground = false
		textUserResidence.size = 25
		textUserResidence:resizeHeightToFitFont()
		textUserResidence:addEventListener( "userInput", userInputProfile )
		textUserResidence.name = "residence"
		grpTextProfile:insert(textUserResidence)
	elseif name == "emailContact" then
		--textField pais de origen
		textEmailContact = native.newTextField( 515, coordY, 350, 50 )
		textEmailContact.text = item.emailContacto
		textEmailContact.hasBackground = false
		textEmailContact.size = 25
		textEmailContact:resizeHeightToFitFont()
		textEmailContact:addEventListener( "userInput", userInputProfile )
		textEmailContact.name = "emailContact"
		grpTextProfile:insert(textEmailContact)
	elseif name == "pet" then
		--textField pais de origen
		textPet = native.newTextField( 515, coordY, 350, 50 )
		textPet.text = item.tipoMascota
		textPet.hasBackground = false
		textPet.size = 25
		textPet:resizeHeightToFitFont()
		textPet:addEventListener( "userInput", userInputProfile )
		textPet.name = "pet"
		grpTextProfile:insert(textPet)
	end
	
end

function createPreferencesItems( item )
	
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
        text = "Gustos y preferencias:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    scrPerfile:insert(lblTitle)
	local iconOpcion = {}
	local infoOpcion = {}
	local typeOpcion = {}
	local nameOption = {}
	local num = #infoOpcion + 1
	--idiomas
	infoOpcion[num] = "Idiomas: "
	iconOpcion[num] = 'icoFilterLanguage'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "language"
	if item.idiomas then
		myLanguages = item.idiomas
        for i=1, #item.idiomas do
            if i == 1 then
                infoOpcion[num] = item.idiomas[i]
            else
                infoOpcion[num] = infoOpcion[num] ..', '.. item.idiomas[i]
            end
        end
    else
		myLanguages = {}
        infoOpcion[num] = 'No cuenta con ningun idioma'
    end
	num = #infoOpcion + 1
	--nivel de estudio
	infoOpcion[num] = "Nivel de estudio: "
	iconOpcion[num] = 'iconSchool'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "race"
	num = #infoOpcion + 1
	if not item.nivelEstudio then
		item.nivelEstudio = "Ninguna"
	end
	--area laboral
	infoOpcion[num] = "Area laboral: "
	iconOpcion[num] = 'iconJob'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "workArea"
	num = #infoOpcion + 1
	if not item.areaLaboral then
		item.areaLaboral = "Ninguna"
	end
	--cuenta propia
	infoOpcion[num] = "Cuenta propia: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "ownAccount"
	num = #infoOpcion + 1
	if not item.cuentaPropia then
		item.cuentaPropia = "Por cuenta ajena"
	end
	ownAccount = item.cuentaPropia
	--mascota
	infoOpcion[num] = "¿mascota?: "
	iconOpcion[num] = 'iconPet'
	typeOpcion[num] = "textField"
	nameOption[num] = "pet"
	num = #infoOpcion + 1
	if not item.mascota then
		item.mascota = "No"
	end
	if not item.tipoMascota then
		item.tipoMascota = ""
	end
	--deporte
	infoOpcion[num] = "¿Practica deportes?: "
	iconOpcion[num] = 'iconSport'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "sport"
	
	if not item.deporte then
		item.deporte = "No"
	end
	if item.deportes then
		mySports = item.deportes
		for i=1, #item.deportes do
            if i == 1 then
                infoOpcion[num] = item.deportes[i]
            else
                infoOpcion[num] = infoOpcion[num] ..', '.. item.deportes[i]
            end
        end
    else
		mySports = {}
        infoOpcion[num] = 'No cuenta con ningun deporte'
    end
	num = #infoOpcion + 1
	--fumas
	infoOpcion[num] = "¿Fumas?: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "smoke"
	num = #infoOpcion + 1
	if not item.fumas then
		item.fumas = "No"
	end
	 smoke = item.fumas
	--bebes
	infoOpcion[num] = "¿Bebes?: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "drink"
	num = #infoOpcion + 1
	if not item.bebes then
		item.bebes = "No"
	end
	drink = item.bebes
	--psicotroficos
	infoOpcion[num] = "¿Psicotroficos?: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "psychrotrophic"
	num = #infoOpcion + 1
	if not item.psicotroficos then
		item.psicotroficos = "No"
	end
	psychrotrophic = item.psicotroficos
	-- Options
    posY = posY + 45
	
	bgComp1.height = (#infoOpcion * 80) + 70
	bgComp2.height = (#infoOpcion * 80) + 66
	
    for i=1, #infoOpcion do
        posY = posY + 75
        
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
		
		if nameOption[i] == "language" then
			local bgLangs = display.newRect( 420, posY, 550, 80 )
			-- bgLangs.anchorY = 0
			bgLangs:setFillColor( 1 )
			bgLangs.alpha = .02
			bgLangs.name = "languages"
			bgLangs.label = "Tus Idiomas"
			bgLangs.type = "create"
			scrPerfile:insert(bgLangs)
			bgLangs:addEventListener( 'tap', showOptionsLabels )
			
			lblLang = display.newText({
				text = infoOpcion[i], 
				x = 350, y = posY,
				width = 400,
				font = native.systemFont,   
				fontSize = 22, align = "left"
			})
			lblLang:setFillColor( 0 )
			scrPerfile:insert(lblLang)
		elseif nameOption[i] == "sport" then
			local bgSport= display.newRect( 420, posY, 550, 80 )
			-- bgLangs.anchorY = 0
			bgSport:setFillColor( 1 )
			bgSport.alpha = .02
			bgSport.name = "sport"
			bgSport.label = "Deportes que practicas"
			bgSport.type = "create"
			scrPerfile:insert(bgSport)
			bgSport:addEventListener( 'tap', showOptionsLabels )
			
			lblSport = display.newText({
				text = infoOpcion[i], 
				x = 350, y = posY,
				width = 400,
				font = native.systemFont,   
				fontSize = 22, align = "left"
			})
			lblSport:setFillColor( 0 )
			scrPerfile:insert(lblSport)
		else
			local lbl = display.newText({
				text = infoOpcion[i], 
				x = 350, y = posY,
				width = 400,
				font = native.systemFont,   
				fontSize = 22, align = "left"
			})
			lbl:setFillColor( 0 )
			scrPerfile:insert(lbl)
		
		end
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY, 350)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY, 350)
		end
    end
	
	posY = posY + 100
	
end

------------------------------------
function createTouristGuideItems( item )
	-------Generales-----------
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
        text = "Guia turistica:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    scrPerfile:insert(lblTitle)
	local iconOpcion = {}
	local infoOpcion = {}
	local typeOpcion = {}
	local nameOption = {}
	local num = #infoOpcion + 1
	--disponibilidad
	infoOpcion[num] = "Disponibilidad: "
	iconOpcion[num] = 'icoFilterCheckAvailble'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "availability"
	num = #infoOpcion + 1
	if not item.diponibilidad then
		item.diponibilidad = "Consultarme"
    end
	availability = item.diponibilidad
	--alojamiento
	infoOpcion[num] = "Alojamiento: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "accommodation"
	num = #infoOpcion + 1
	if not item.alojamiento then
		item.alojamiento = "No"
    end
	accommodation = item.alojamiento
	--vehiculo
	infoOpcion[num] = "Vehiculo: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "vehicle"
	num = #infoOpcion + 1
	if not item.vehiculo then
		item.vehiculo = "No"
    end
	vehicle = item.vehiculo
	--comida
	infoOpcion[num] = "Comida: "
	iconOpcion[num] = 'icoFilterCheck'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "food"
	num = #infoOpcion + 1
	if not item.comida then
		item.comida = "No"
    end
    food = item.comida
    -- Options
    posY = posY + 45
	
	bgComp1.height = (#infoOpcion * 80) + 70
	bgComp2.height = (#infoOpcion * 80) + 66
	
    for i=1, #infoOpcion do
        posY = posY + 75
        
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
		
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY, 350)
		end
    end
	
	posY = posY + 100
	--creamos los componentes de preferencias
	createPreferencesItems( item )
end

------------------------------------
-- Pinta la info general del usuario
------------------------------------
function createGeneralItems( item )
	-------Generales-----------
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
        text = "Generales:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    scrPerfile:insert(lblTitle)
	local iconOpcion = {}
	local infoOpcion = {}
	local typeOpcion = {}
	local nameOption = {}
	local num = #infoOpcion + 1
	--nombre
	infoOpcion[num] = "Nombre: "
	iconOpcion[num] = 'iconName'
	typeOpcion[num] = "textField"
	nameOption[num] = "name"
	num = #infoOpcion + 1
	if not item.nombre then
		item.nombre = ""
	end
	--apellidos
	infoOpcion[num] = "Apellidos: "
	iconOpcion[num] = 'iconName'
	typeOpcion[num] = "textField"
	nameOption[num] = "lastName"
	num = #infoOpcion + 1
	if not item.apellidos then
		item.apellidos = ""
	end
	--genero
	infoOpcion[num] = "Genero"
	iconOpcion[num] = 'icoFilterM'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "gender"
	num = #infoOpcion + 1
	if not item.genero then
		item.genero = "Hombre"
	end
	gender = item.genero
	
	--pais de origen
	infoOpcion[num] = "Pais de origen: "
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "textField"
	nameOption[num] = "originCountry"
	num = #infoOpcion + 1
	if not item.paisOrigen then
		item.paisOrigen = ""
	end
	--residencia
	infoOpcion[num] = "Residencia: "
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "textField"
	nameOption[num] = "residence"
	num = #infoOpcion + 1
	if not item.residencia then
		item.residencia = ""
	end
	--tiempo de residencia
	infoOpcion[num] = "Tiempo de residencia: "
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "residenceTime"
	num = #infoOpcion + 1
	if not item.tiempoResidencia then
		item.tiempoResidencia = "Seleccionar"
	end
	--email contacto
	infoOpcion[num] = "Email de contacto: "
	iconOpcion[num] = 'iconEmailContacto'
	typeOpcion[num] = "textField"
	nameOption[num] = "emailContact"
	num = #infoOpcion + 1
	if not item.emailContacto then
		item.emailContacto = ""
	end
    
    -- Options
    posY = posY + 45
	
	bgComp1.height = (#infoOpcion * 80) + 70
	bgComp2.height = (#infoOpcion * 80) + 66
	
    for i=1, #infoOpcion do
        posY = posY + 75
        
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = 350, y = posY,
            width = 400,
            font = native.systemFont,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY, 300)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY, 380)
		end
    end
	
	posY = posY + 100
	
	createTouristGuideItems( item )

end

------------------------------------
-- Pinta la info del usuario
-- permite editar su informacion
------------------------------------
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
	if item.hobbies then
		myHobbies = item.hobbies
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
		myHobbies = {}
        lblInts.text = 'Editar pasatiempos'
    end
	
	--creamos los componentes generales
	createGeneralItems( item )
	
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
    local bgA1 = display.newRoundedRect( midW - 190, 170, 250, 250, 10 )
    bgA1:setFillColor( 11/225, 163/225, 212/225 )
    scrPerfile:insert(bgA1)
    
    local bgA2 = display.newRect( midW - 190, 170, 235, 235 )
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
--------------------------------------------------------
-- Called immediately after scene has moved onscreen:
--------------------------------------------------------
function scene:show( event )
end
----------------
-- Hide scene
----------------
function scene:hide( event )
	native.setKeyboardFocus( nil )
	if grpTextProfile then
		grpTextProfile:removeSelf()
		grpTextProfile = nil
	end
end
---------------------
-- Destroy scene
---------------------
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene