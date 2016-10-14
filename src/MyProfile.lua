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
local grpOptionsLabel, grpOptionsCombo, grpComboBox, grpOptionAvatar
local grpTextProfile = nil

-- Variables
local posY = 350
local textUserName, textName, textLastName, textOriginCountry, textUserResidence, textEmailContact
local toggleButtons = {}
local toggleBg = {}
local hobbies = {}
local myHobbies = {}
local languages = {}
local myLanguages = {}
local sports = {}
local mySports = {}
local residenceTimes = {}
local races = {}
local workAreas = {}
local genders = {}
local posYE = 0
local myElements = {}
local container = {}
local lblInts, lblLang, lblSport, lblResidenceTime, lblRace, lblWorkArea, lblGender
local btnSaveProfile
local gender, availability, accommodation, vehicle, food, ownAccount, pet, smoke, drink, psychrotrophic
local lblAge
local grpLoadMyProfile
local avatar

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

------------------------------------
-- carga los datos del usuario
------------------------------------
function getUserPerfil( item, after )
	--[[itemProfile = {id = item.id, userName = item.userName, image = item.image, edad = item.edad, genero = item.genero, alojamiento = item.alojamiento, 
	vehiculo = item.vehiculo, residencia = item.residencia, diponibilidad = item.diponibilidad, idiomas = item.idiomas, hobbies = item.hobbies, isMe = true}]]
	itemProfile = item
	if after == "show" then
		createProfileAvatar()
	else
		composer.gotoScene( "src.Home" )
	end
end

--------------------------------
-- Guarda la lista de hobbies
--------------------------------
function setList(hobbie, language, sport, residenceTime, race, workArea, gender )
	hobbies = hobbie
	languages = language
	sports = sport
	residenceTimes = residenceTime
	races = race
	workAreas = workArea
	genders = gender
end

--------------------------------
-- Guarda los datos del perfil
--------------------------------
function saveProfile()
	
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end

	btnSaveProfile:removeEventListener( 'tap', saveProfile )
	tools:setLoading(true,screen)
	for i=1, #myHobbies, 1 do
		myHobbies[i] = string.gsub( myHobbies[i], "/", '...' )
	end
	for i=1, #myLanguages, 1 do
		myLanguages[i] = string.gsub( myLanguages[i], "/", '...' )
	end
	for i=1, #mySports, 1 do
		mySports[i] = string.gsub( mySports[i], "/", '...' )
	end
	textUserName.text = trimString(textUserName.text)
	textName.text = trimString(textName.text)
	textLastName.text = trimString(textLastName.text)
	textOriginCountry.text = trimString(textOriginCountry.text)
	textUserResidence.text = trimString(textUserResidence.text)
	textEmailContact.text = trimString(textEmailContact.text)
	RestManager.saveProfile(
		textUserName.text, 
		myHobbies,
		textName.text,
		textLastName.text,
		lblGender.text,
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
		pet,
		mySports,
		smoke,
		drink,
		psychrotrophic,
		textUserResidence.id
	)
end

-------------------------------------------------------------
-- Muestra una alerta con los resulado de guardar un perfil 
-------------------------------------------------------------
function resultSaveProfile( isTrue, message)
	--[[grpTextProfile.x = intW
	NewAlert(true, message)
	timeMarker = timer.performWithDelay( 1000, function()
		NewAlert(false, message)
		grpTextProfile.x = 0
		tools:setLoading(false,scrPerfile)
		btnSaveProfile:addEventListener( 'tap', saveProfile )
	end, 1 )
	]]
	RestManager.getUsersById("save")
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

	local mask = graphics.newMask( "img/image-mask-mask3.png" )
	local avatar = display.newImage(item[1].image, system.TemporaryDirectory)
	avatar:translate( 69.5, posY)
	avatar.anchorX = 0
	avatar.height = 250
	avatar.width = 250
	scrPerfile:insert(avatar)
	avatar:setMask( mask )
	avatar.maskScaleY = 1.35
	avatar.maskScaleX = 1.35
	
end

function saveAvatar( event )

	local nameImage
	for k, v in string.gmatch(avatar.name, "(%w+).(%w+)") do
		nameImage = k
		--t[k] = v
	end

	RestManager.savePhoto(nameImage)
	
	--display.save( avatarMask, { filename="entireGroup.png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,0} } )
	
	print("holaaaa")
	
	return true
end

function moveMasckAvatar( event )

	--[[if ( event.phase == "began" ) then
        differenceX = event.x - avatarMask.maskX
		differenceY = event.y - avatarMask.maskY
	elseif ( event.phase == "moved" ) then
		newPositionX = event.x - differenceX
		newPositionY = event.y - differenceY
		avatarMask.maskX = newPositionX
		avatarMask.maskY = newPositionY
	--avatarMask.maskY = event.y
		avatarMask.maskScaleX = 1
	
	elseif ( event.phase == "ended" ) then
    end]]

	--event.target.maskX = -10
	
	--avatarMask.y = 300
	
	if ( event.phase == "began" ) then
        differenceX = event.x - avatarMask.maskX
		differenceY = event.y - avatarMask.y
		--print(avatarMask.maskY)
		--print(event.y)
		--print(avatarMask.y)
	elseif ( event.phase == "moved" ) then
		avatarMask.y = event.y -400
		--newPositionX = event.x - differenceX
		--newPositionY = event.y - differenceY
		--avatarMask.y = newPositionY
		print(event.target.y)
		
		--avatarMask.maskY = newPositionY
		--avatarMask.maskX = newPositionX
		--avatarMask.maskY = newPositionY
	--avatarMask.maskY = event.y
		--avatarMask.maskScaleX = 1
	
	elseif ( event.phase == "ended" ) then
		--newPositionY = event.y - differenceY
		--avatarMask.y = newPositionY
		--avatarMask.y = event.y -400
    end
	
	return true
end

function showAvatar( typeP )
	
	componentActive = true
	if grpOptionAvatar then
		grpOptionAvatar:removeSelf()
		grpOptionAvatar = nil
	end
	grpTextProfile.x = intW
	grpOptionAvatar = display.newGroup()
	
	local bg0 = display.newRect( midW, midH + h, intW, intH )
	bg0:setFillColor( 0 )
	bg0.alpha = .8
	grpOptionAvatar:insert( bg0 )
	bg0:addEventListener( 'tap', hideoptionAvatar )
	
	if( typeP == "myPhoto" ) then
		local path = system.pathForFile( avatar.name, system.TemporaryDirectory )
		local fhd = io.open( path )
		--verifica si existe la imagen
		if fhd then
			avatarFull = display.newImage(avatar.name, system.TemporaryDirectory)
			avatarFull:translate(midW, midH)
			grpOptionAvatar:insert(avatarFull)
			local desiredHigh = ( (intW - 100) * avatarFull.height ) / avatarFull.width 
			avatarFull.height = desiredHigh
			avatarFull.width = intW-100
			
			local iconExitAvatarFull = display.newImage("img/delete.png")
			iconExitAvatarFull:translate(intW - 50, avatarFull.y - midH/1.5)
			grpOptionAvatar:insert(iconExitAvatarFull)
			
		end
	elseif( typeP == "newPhoto") then
	
		local nameImage
		for k, v in string.gmatch(avatar.name, "(%w+).(%w+)") do
			nameImage = k
			--t[k] = v
		end
	
		local path = system.pathForFile( "tempFotos/" .. nameImage .. ".jpg", system.TemporaryDirectory )
		local fhd = io.open( path )
		--verifica si existe la imagen
		
		if fhd then
		
			avatarFull = display.newImage("tempFotos/" .. nameImage .. ".jpg", system.TemporaryDirectory)
			avatarFull:translate(midW, midH  + h)
			grpOptionAvatar:insert(avatarFull)
			avatarFull:addEventListener( 'tap', noAction )
			
			local desiredHigh = ( (intW - 100) * avatarFull.height ) / avatarFull.width 
			avatarFull.height = desiredHigh
			--local desiredHigh  = 600
			avatarFull.height = desiredHigh
			avatarFull.width = intW-100
			
			btnSaveAvatar = display.newRoundedRect( midW, intH - 200, 650, 110, 10 )
			btnSaveAvatar.id = nameImage
			btnSaveAvatar:setFillColor( {
				type = 'gradient',
				color1 = { 129/255, 61/255, 153/255 }, 
				color2 = { 89/255, 31/255, 103/255 },
				direction = "bottom"
			} )
			grpOptionAvatar:insert(btnSaveAvatar)
			btnSaveAvatar:addEventListener( 'tap', saveAvatar )
		
			--[[local scrNewPhoto = widget.newScrollView({
				top = h + 100,
				left = 50,
				width = intW - 100,
				height = intH - 200,
				horizontalScrollDisabled = true,
				backgroundColor = { .96 },
				listener = moveMasckAvatar
			})
			grpOptionAvatar:insert(scrNewPhoto)
			scrNewPhoto:addEventListener( 'tap', noAction )
			
			local iconExitAvatarFull = display.newImage("img/x-mark-3-64.png")
			iconExitAvatarFull:translate(intW - 50, h + 100)
			grpOptionAvatar:insert(iconExitAvatarFull)
			
			avatarFull = display.newImage("tempFotos/" .. nameImage .. ".jpg", system.TemporaryDirectory)
			avatarFull:translate(midW - 50, midH - 100)
			scrNewPhoto:insert(avatarFull)
			--avatarFull:addEventListener('touch', moveMasckAvatar)
			avatarFull:addEventListener( 'tap', noAction )
			--avatarFull:setMask( mask )
			avatarFull.alpha = .5
			
			local desiredHigh = ( (intW - 100) * avatarFull.height ) / avatarFull.width 
			avatarFull.height = desiredHigh
			--local desiredHigh  = 600
			avatarFull.height = desiredHigh
			avatarFull.width = intW-100
		
			print(scrNewPhoto.top)
			print(desiredHigh)
		
			local mask = graphics.newMask( "img/maskPhoto2.png" )
			avatarMask = display.newImage("tempFotos/" .. nameImage .. ".jpg", system.TemporaryDirectory)
			avatarMask.anchorY = 0
			avatarMask:translate(midW, h + 99)
			avatarMask.height = desiredHigh
			avatarMask.width = intW-100
			grpOptionAvatar:insert(avatarMask)
		
			local posyMask = desiredHigh / 3.74
			avatarMask.maskY = - posyMask
			scrNewPhoto:setScrollHeight( desiredHigh + ((intH - 449) - posyMask) )]]
			--[[
			posY = intH - 200
			
			btnSaveAvatar = display.newRoundedRect( midW, posY, 650, 110, 10 )
			btnSaveAvatar.id = nameImage
			btnSaveAvatar:setFillColor( {
				type = 'gradient',
				color1 = { 129/255, 61/255, 153/255 }, 
				color2 = { 89/255, 31/255, 103/255 },
				direction = "bottom"
			} )
			grpOptionAvatar:insert(btnSaveAvatar)
			btnSaveAvatar:addEventListener( 'tap', saveAvatar )]]
			
			--local desiredHigh = ( (intW - 400) * avatarFull.height ) / avatarFull.width 
			--avatarFull.height = desiredHigh
			--local desiredHigh  = 600
			--avatarFull.height = desiredHigh
			--avatarFull.width = intW-100
		
			--[[local bg1 = display.newRoundedRect( midW, midH + h, intW - 80, intH, 15 )
			bg1:setFillColor( 1 )
			bg1.anchorY = 0
			grpOptionAvatar:insert( bg1 )
			--bg1:addEventListener( 'tap', hideoptionAvatar )
		
			avatarFull = display.newImage("tempFotos/" .. nameImage .. ".jpg", system.TemporaryDirectory)
			avatarFull:translate(midW, midH - 100)
			grpOptionAvatar:insert(avatarFull)
			--local desiredHigh = ( (intW - 400) * avatarFull.height ) / avatarFull.width 
			--avatarFull.height = desiredHigh
			local desiredHigh  = 600
			avatarFull.height = desiredHigh
			avatarFull.width = intW-100
			
			local posY = (desiredHigh + avatarFull.height) - 100
			btnSaveAvatar = display.newRoundedRect( midW, posY, 650, 110, 10 )
			btnSaveAvatar.id = nameImage
			btnSaveAvatar:setFillColor( {
				type = 'gradient',
				color1 = { 129/255, 61/255, 153/255 }, 
				color2 = { 89/255, 31/255, 103/255 },
				direction = "bottom"
			} )
			grpOptionAvatar:insert(btnSaveAvatar)
			btnSaveAvatar:addEventListener( 'tap', saveAvatar )
			
			bg1.y = (avatarFull.y / 2) + 15
			--bg1.height = avatarFull.height + btnSaveAvatar.height + 50
			bg1.height = avatarFull.height + 50
			
			local lblSaveAvatar = display.newText({
				text = "Editar", 
				x = midW, y = posY,
				font = native.systemFontBold,   
				fontSize = 36, align = "center"
			})
			lblSaveAvatar:setFillColor( 1 )
			grpOptionAvatar:insert(lblSaveAvatar)
			
			local iconExitAvatarFull = display.newImage("img/delete.png")
			iconExitAvatarFull:translate(intW - 50, bg1.y)
			grpOptionAvatar:insert(iconExitAvatarFull)]]
			
		end
		
	end
	
end

function mysplitPoint(s)
    
	return t
end

function takePicture()

	local function onComplete( event )
		--local photo = event.target
		--[[photo.height = 150
		photo.width = 200
		photo.x = 100
		photo.y = intH/2.04
		photo.alpha = 0]]
		--event.target.alpha = 0
		
		showAvatar( "newPhoto" )
		
	end
	
	local namePhoto
	
	local namePhoto
	for k, v in string.gmatch(avatar.name, "(%w+).(%w+)") do
		namePhoto = k
		--t[k] = v
	end
	
	namePhoto = namePhoto .. ".jpg"
	
	if media.hasSource( media.Camera ) then
		media.capturePhoto({ 
			listener=onComplete,
			destination = {
				baseDir = system.TemporaryDirectory,
				filename = "tempFotos/" .. namePhoto,
				type = "image"
			}
		})
	else
		native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
	end

end

------------------------------------------------------------------------------
-- seleciona la opcion de ver o editar perfil
-- @param item nombre de la imagen
------------------------------------------------------------------------------
function selectOptionAvatar( event )
	if( event.target.type == "Editar Foto" ) then
		
		
		takePicture()
		--showAvatar( "newPhoto" )
		
	elseif( event.target.type == "Ver Foto" ) then
		showAvatar( "myPhoto" )
	end
	return true
end

------------------------------------------------------------------------------
-- muestra las opciones de foto de perfil
-- ver o editar
------------------------------------------------------------------------------
function optionAvatar( event )
	componentActive = true
	if grpOptionAvatar then
		grpOptionAvatar:removeSelf()
		grpOptionAvatar = nil
	end
	grpTextProfile.x = intW
	grpOptionAvatar = display.newGroup()
	
	local bg0 = display.newRect( midW, midH + h, intW, intH )
	bg0:setFillColor( 0 )
	bg0.alpha = .8
	grpOptionAvatar:insert( bg0 )
	bg0:addEventListener( 'tap', hideoptionAvatar )
	local bg1 = display.newRoundedRect( midW, midH/2 + h - 2, 606, 310, 10 )
	bg1.anchorY = 0
	bg1:setFillColor( .7 )
	grpOptionAvatar:insert( bg1 )
	
	local posY = midH/2 + h
	
	local option = {"Editar Foto", "Ver Foto"}
	local optionIcon = {"edit-2-85", "eye-3-85"}
	for i = 1, #option, 1 do
		local container3 = display.newContainer( 606, 150 )
		grpOptionAvatar:insert(container3)
		container3.anchorY = 0
		container3:translate( midW, posY )
		
		local bg0Option = display.newRoundedRect( 0, 0, 600, 150, 5 )
		bg0Option:setFillColor( 1 )
		bg0Option.type = option[i]
		container3:insert( bg0Option )
		bg0Option:addEventListener( 'tap', selectOptionAvatar )
		
		local iconOption = display.newImage("img/" .. optionIcon[i] .. ".png")
		iconOption:translate(-230, 0)
		container3:insert(iconOption)
		
		--label nombre
		local lblNameOption = display.newText({
			text = option[i], 
			x = 0, y = 0,
			width = 500,
			font = native.systemFont, 
			fontSize = 50, align = "center"
		})
		lblNameOption:setFillColor( 129/255, 61/255, 153/255 )
		container3:insert(lblNameOption)
		posY = posY + 155
	end
	
	bg1.height = #option * 156
	
	return true
	
end

function hideoptionAvatar( event )
	componentActive = false
	if grpOptionAvatar then
		grpOptionAvatar:removeSelf()
		grpOptionAvatar = nil
	end
	grpTextProfile.x = 0
	return true
end

-----------------------------------
-- Obtiene la ciudad selecionada
-----------------------------------
function getCityProfile(city, id)
	textUserResidence.text = city
	textUserResidence.city = city
	textUserResidence.id = id
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
		--native.setKeyboardFocus(nil)
		if t.name == "residence" then
			textName.x = intW - 65
			textLastName.x = intW - 65
			textOriginCountry.x = intW - 65
		end
		--native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
		if t.name == "residence" then
			textName.x = intH
			textLastName.x = intH
			textOriginCountry.x = intH
			local itemOption = {posY = 745, posX = 500, height = 340, width = 410}
			textUserResidence.city = ""
			textUserResidence.id = 0
			RestManager.getCity(t.text, "residence", scrPerfile, itemOption)
		end
    end
	if ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
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
        t:setFillColor( .7 )
		transition.to( toggleButtons[t.num], { x = t.pocsX - 75, time = 200})
	else
		t.onOff = "Sí"
        t:setFillColor( 0/255, 174/255, 239/255 )
		transition.to( toggleButtons[t.num], { x = t.pocsX - 4, time = 200})
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
	elseif t.name == "pet" then
		pet = t.onOff 
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
	componentActive = "comboBox"
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
		y = midH + h,
		x = midW,
		width = 600,
		height = midH - 10,
		horizontalScrollDisabled = true,
		backgroundColor = { .96 }
	})
	grpComboBox:insert(scrCombo)
	local setElements = {}
	if t.name == "gender" then
		setElements = genders
	elseif t.name == "residenceTime" then
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
		local bg0OptionCombo = display.newRoundedRect( 0, 0, 580, 80, 5 )
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
		posY = posY + 90
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
	elseif t.name == "gender" then
		lblGender.text = t.option
	end
	hideComboBox( "" )
	return true
end

function hideComboBox( event )
	componentActive = false
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
	--intW - 65, coordY, 400 , 90
	--[[local bg0CheckAcco = display.newRect( intW - 65, coordY, 400, 90 )
	bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco:setFillColor( 129/255, 61/255, 153/255 )
	scrPerfile:insert(bg0CheckAcco)]]
	local bg0CheckAcco = display.newRect( intW - 65, coordY + 25, 400, 90 )
	--bg0CheckAcco.anchorY = 0
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco:setFillColor( 1 )
	bg0CheckAcco.name = name
	scrPerfile:insert(bg0CheckAcco)
	bg0CheckAcco:addEventListener( 'tap', showComboBox )
	local triangle = display.newImage("img/down.png")
	triangle:translate(coordX + 290, coordY + 25)
	scrPerfile:insert(triangle)
	if name == "gender" then
		lblGender = display.newText({
			text = item.genero, 
			x = coordX + 125, y = coordY + 25,
			width = 380, --height = 30,
			font = fontFamilyBold,   
			fontSize = 26, align = "left"
		})
		lblGender:setFillColor( 0 )
		scrPerfile:insert(lblGender)
	elseif name == "residenceTime" then
		lblResidenceTime = display.newText({
			text = item.tiempoResidencia, 
			x = coordX + 125, y = coordY + 25,
			width = 380, --height = 30,
			font = fontFamilyBold,   
			fontSize = 26, align = "left"
		})
		lblResidenceTime:setFillColor( 0 )
		scrPerfile:insert(lblResidenceTime)
	elseif name == "race" then
		lblRace = display.newText({
			text = item.nivelEstudio, 
			x = coordX + 125, y = coordY + 25,
			width = 380, --height = 30,
			font = fontFamilyBold,   
			fontSize = 26, align = "left"
		})
		lblRace:setFillColor( 0 )
		scrPerfile:insert(lblRace)
	elseif name == "workArea" then
		lblWorkArea = display.newText({
			text = item.areaLaboral, 
			x = coordX + 125, y = coordY + 25,
			width = 380, --height = 30,
			font = fontFamilyBold,   
			fontSize = 26, align = "left"
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
	local num = #toggleButtons + 1
	coordY = coordY - 25
	-- BG Component
	--[[toggleBg[num] = display.newRoundedRect( coordX, coordY + 25, 140, 70, 35 )
	--toggleBg[num].anchorY = 0
	toggleBg[num].anchorX = 1
	toggleBg[num]:setFillColor( 0/255, 174/255, 239/255 )
	scrPerfile:insert(toggleBg[num])]]
	local bg0CheckAcco = display.newRoundedRect( coordX, coordY + 25, 140, 70, 35 )
	--toggleBg[num].anchorY = 0
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco.name = name
	bg0CheckAcco:setFillColor( 0/255, 174/255, 239/255 )
	bg0CheckAcco:addEventListener( 'tap', moveToggleButtons )
	scrPerfile:insert(bg0CheckAcco)
	bg0CheckAcco.pocsX = coordX
	bg0CheckAcco.num = num
		
	--label si/no
	--[[local lblYes = display.newText({
		text = "Si", 
		x = coordX + 50, y = coordY + 25,
		width = 100,
		font = native.systemFont, 
		fontSize = 35, align = "center"
	})
	lblYes:setFillColor( 1 )
	scrPerfile:insert(lblYes)
	local lblNo = display.newText({
		text = " ", 
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
	end]]
	print(name)
	local posXTB = coordX - 75
	local onOff = "No"
	--alojamiento
	if name == "gender" then
		if item.genero ~= nil and item.genero == 'Hombre' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	if name == "accommodation" then
		if item.alojamiento ~= nil and item.alojamiento == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--availability, accommodation, vehicle, food
	-- transporte
	if name == "vehicle" then
		if item.vehiculo ~= nil and item.vehiculo == 'Sí' then	
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--disponibilidad
	if name == "availability" then
		if item.diponibilidad ~= nil and item.diponibilidad == 'Siempre' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--comida
	if name == "food" then
		if item.comida ~= nil and item.comida == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--cuenta propia
	if name == "ownAccount" then
		if item.cuentaPropia ~= nil and item.cuentaPropia == 'Por cuenta propia' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	-- mascota
	if name == "pet" then
		if item.mascota ~= nil and item.mascota == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--fumas
	if name == "smoke" then
		if item.fumas ~= nil and item.fumas == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--bebes
	if name == "drink" then
		if item.bebes ~= nil and item.bebes == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--psychrotrophic
	if name == "psychrotrophic" then
		if item.psicotropicos ~= nil and item.psicotropicos == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	bg0CheckAcco.onOff = onOff
		--button
	toggleButtons[num] = display.newRoundedRect( posXTB, coordY + 25, 60, 60, 30 )
	toggleButtons[num].anchorX = 1
	toggleButtons[num]:setFillColor( 1 )
	scrPerfile:insert(toggleButtons[num])
	if onOff == "No" then
        bg0CheckAcco:setFillColor( .7 )
    end
	

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
	local bg0OptionCombo = display.newRoundedRect( 0, 0, 600, 80, 5 )
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
	deleteElements.id = num
	container[num]:insert(deleteElements)
	deleteElements:addEventListener( 'tap', deleteElement )
	posYE = posYE + 90

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
			backgroundColor = { .96 },
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
				local bg0OptionCombo = display.newRoundedRect( 300, posYTemp, 580, 80, 5 )
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
		
				posYTemp = posYTemp + 90
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
		componentActive = "multiComboBox"
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
		local bg1 = display.newRoundedRect( midW, midH + 10, 650, (intH/2) + 260, 10 )
		bg1:setFillColor( .96 )
		grpOptionsLabel:insert( bg1 )
		bg1:addEventListener( 'tap', hideOptionsCombo )
		local bg0ComboBox = display.newRoundedRect( midW, midH - (midH/2) - 60, 606, 86, 10 )
		bg0ComboBox:setFillColor( .96 )
		grpOptionsLabel:insert( bg0ComboBox )
		bg0ComboBox:addEventListener( 'tap', noAction )
		--bg que despliega las opciones
		local bg1ComboBox = display.newRoundedRect( midW, midH - (midH/2) - 60, 600, 80, 10 )
		bg1ComboBox:setFillColor( 1 )
		bg1ComboBox.name = t.name
		grpOptionsLabel:insert( bg1ComboBox )
		bg1ComboBox:addEventListener( 'tap', showOptionsCombo )
		--label title
		local lblTitleCombo = display.newText({
			text = t.label, 
			x = midW, y = midH - (midH/2) - 60,
			width = 550,
			font = native.systemFont, 
			fontSize = 32, align = "left"
		})
		lblTitleCombo:setFillColor( 0 )
		grpOptionsLabel:insert(lblTitleCombo)
		local triangle = display.newImage("img/triangleDown.png")
		triangle:translate(650, midH - (midH/2) - 60)
		grpOptionsLabel:insert(triangle)
		--elementos selecionados
		local bg0Elemets = display.newRoundedRect( midW, midH, 606, midH + 6, 10 )
		bg0Elemets:setFillColor( .96 )
		grpOptionsLabel:insert( bg0Elemets )
		
		--scrollview
		scrElements = widget.newScrollView({
			left = 84,
			width = 600,
			height = midH,
			horizontalScrollDisabled = true,
			backgroundColor = { .96 },
		})
        scrElements.y = midH
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
		local btnAceptOption = display.newRoundedRect( midW, midH + (midH/2) + 75, 650, 80, 0 )
		btnAceptOption:setFillColor( 0/255, 174/255, 239/255 )
		grpOptionsLabel:insert(btnAceptOption)
		btnAceptOption.name = t.name
		btnAceptOption:addEventListener( 'tap', savePreferences )
		local lblStartChat = display.newText({
			text = "Aceptar", 
			x = midW, y = midH + (midH/2) + 75,
			font = fontFamilyBold,   
			fontSize = 32, align = "center"
		})
		lblStartChat:setFillColor( 1 )
		grpOptionsLabel:insert(lblStartChat)
		
	elseif t.type == "destroy" then
		componentActive = false
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

function hideOptionsLabels()
	componentActive = false
	if grpOptionsLabel then
		grpOptionsLabel:removeSelf()
		grpOptionsLabel = nil
	end
	grpTextProfile.x = 0
	container = nil
	container = {}
end

------------------------------------
-- Creamos los textField
------------------------------------
function createTextField( item, name, coordY )
	--textUserName, textName, textLastName, textOriginCountry, textUserResidence, textEmailContact
	local bgTextField = display.newRect( intW - 65, coordY + 30, 400, 2 )
	bgTextField.anchorX = 1
	bgTextField:setFillColor( .6 )
	scrPerfile:insert(bgTextField)
	if name == "name" then
		--textField user name
		--485
		textName = native.newTextField(  intW - 65, coordY, 400 , 90 )
		textName.anchorX = 1
		textName.text = item.nombre
		textName.hasBackground = false
		textName.size = 45
		--textName:resizeHeightToFitFont()
		textName:addEventListener( "userInput", userInputProfile )
		textName.name = "name"
		grpTextProfile:insert(textName)
	elseif name == "lastName" then
		--textField apellido
		--[[local bgTextField = display.newRect( 485, coordY + 18, 400, 2 )
		bgTextField:setFillColor( .6 )
		scrPerfile:insert(bgTextField)]]
		textLastName = native.newTextField( intW - 65, coordY, 400 , 90 )
		textLastName.anchorX = 1
		textLastName.text = item.apellidos
		textLastName.hasBackground = false
		textLastName.size = 45
		--textLastName:resizeHeightToFitFont()
		textLastName:addEventListener( "userInput", userInputProfile )
		textLastName.name = "lastName"
		grpTextProfile:insert(textLastName)
	elseif name == "originCountry" then
		--textField pais de origen
		--[[local bgTextField = display.newRect( 500, coordY + 18, 350, 2 )
		bgTextField:setFillColor( .6 )
		scrPerfile:insert(bgTextField)]]
		textOriginCountry = native.newTextField( intW - 65, coordY, 400 , 90 )
		textOriginCountry.anchorX = 1
		textOriginCountry.text = item.paisOrigen
		textOriginCountry.hasBackground = false
		textOriginCountry.size = 45
		--textOriginCountry:resizeHeightToFitFont()
		textOriginCountry:addEventListener( "userInput", userInputProfile )
		textOriginCountry.name = "originCountry"
		grpTextProfile:insert(textOriginCountry)
	elseif name == "residence" then
		--[[local bgTextField = display.newRect( 500, coordY + 18, 400, 2 )
		bgTextField:setFillColor( .6 )
		scrPerfile:insert(bgTextField)]]
		--textField residence
		textUserResidence = native.newTextField( intW - 65, coordY, 400 , 90 )
		textUserResidence.anchorX = 1
		textUserResidence.text = item.residencia
		textUserResidence.hasBackground = false
		textUserResidence.size = 45
		--textUserResidence:resizeHeightToFitFont()
		textUserResidence:addEventListener( "userInput", userInputProfile )
		textUserResidence.name = "residence"
		textUserResidence.city = item.residencia
		textUserResidence.id = item.residenciaId
		grpTextProfile:insert(textUserResidence)
	elseif name == "emailContact" then
		--[[local bgTextField = display.newRect( 515, coordY + 18, 350, 2 )
		bgTextField:setFillColor( .6 )
		scrPerfile:insert(bgTextField)]]
		--textField pais de origen
		textEmailContact = native.newTextField( intW - 65, coordY, 400 , 90 )
		textEmailContact.anchorX = 1
		textEmailContact.text = item.emailContacto
		textEmailContact.hasBackground = false
		textEmailContact.size = 45
		--textEmailContact:resizeHeightToFitFont()
		textEmailContact:addEventListener( "userInput", userInputProfile )
		textEmailContact.name = "emailContact"
		grpTextProfile:insert(textEmailContact)
	end
	
end

function createPreferencesItems( item )
	
	---------- Preferences -----------
    -- BG Component
	local line = display.newLine( 0, posY - 2 , intW, posY - 2 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
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
    else
		myLanguages = {}
    end
	local num = #infoOpcion + 1
	--idiomas
	infoOpcion[num] = "Hobbies: "
	iconOpcion[num] = 'icoFilterLanguage'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "hobbies"
	if item.hobbies then
		myHobbies = item.hobbies
    else
		myHobbies = {}
    end
	 --[[local bgInts = display.newRect( 550, 210, 410, 80 )
    
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
	]]
	
	
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
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "ownAccount"
	num = #infoOpcion + 1
	if not item.cuentaPropia then
		item.cuentaPropia = "Por cuenta ajena"
	end
	ownAccount = item.cuentaPropia
	--mascota
	infoOpcion[num] = "mascota: "
	iconOpcion[num] = 'iconPet'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "pet"
	num = #infoOpcion + 1
	if not item.mascota then
		item.mascota = "No"
	end
	pet = item.mascota
	--deporte
	infoOpcion[num] = "Practica deportes: "
	iconOpcion[num] = 'iconSport'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "sport"
	
	if not item.deporte then
		item.deporte = "No"
	end
	if item.deportes then
		mySports = item.deportes
    else
		mySports = {}
    end
	num = #infoOpcion + 1
	--fumas
	infoOpcion[num] = "¿Fumas?: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "smoke"
	num = #infoOpcion + 1
	if not item.fumas then
		item.fumas = "No"
	end
	 smoke = item.fumas
	--bebes
	infoOpcion[num] = "¿Bebes?: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "drink"
	num = #infoOpcion + 1
	if not item.bebes then
		item.bebes = "No"
	end
	drink = item.bebes
	--psicotroficos
	infoOpcion[num] = "¿Psicotropicos?: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "psychrotrophic"
	num = #infoOpcion + 1
	if not item.psicotroficos then
		item.psicotroficos = "No"
	end
	psychrotrophic = item.psicotroficos
	-- Options
	
	--[[bgComp1.height = (#infoOpcion * 80) + 70
	bgComp2.height = (#infoOpcion * 80) + 66]]
	
    for i=1, #infoOpcion do
        
        --[[local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end]]
		
		local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if nameOption[i] == "language" then
			local languageText = "No cuenta con ningun idioma"
			if item.idiomas then
				for i=1, #item.idiomas do
					if i == 1 then
						languageText= item.idiomas[i]
					else
						languageText = languageText ..', '.. item.idiomas[i]
					end
				end
			end
		
			local bgLangs = display.newRect( intW - 55, posY + 50, 400, 80 )
			bgLangs.anchorX = 1
			bgLangs:setFillColor( 1 )
			bgLangs.alpha = .02
			bgLangs.name = "languages"
			bgLangs.label = "Tus Idiomas"
			bgLangs.type = "create"
			scrPerfile:insert(bgLangs)
			bgLangs:addEventListener( 'tap', showOptionsLabels )
			
			lblLang = display.newText({
				text = languageText, 
				x = intW - 50, y = posY + 50,
				width = 390,
				font = fontFamilyBold,   
				fontSize = 22, align = "left"
			})
			lblLang:setFillColor( 0 )
			lblLang.anchorX = 1
			scrPerfile:insert(lblLang)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 97, posY + 55)
			scrPerfile:insert(triangle)
			
		elseif nameOption[i] == "sport" then
			local sportText = "No cuenta con ningun deporte"
			if item.deportes then
				for i=1, #item.deportes do
					if i == 1 then
						sportText = item.deportes[i]
					else
						sportText = sportText ..', '.. item.deportes[i]
					end
				end
			end
		
			local bgSport= display.newRect( intW - 55, posY + 50, 400, 80 )
			bgSport.anchorX = 1
			bgSport:setFillColor( 1 )
			bgSport.alpha = .02
			bgSport.name = "sport"
			bgSport.label = "Deportes que practicas"
			bgSport.type = "create"
			scrPerfile:insert(bgSport)
			bgSport:addEventListener( 'tap', showOptionsLabels )
			
			lblSport = display.newText({
				text = sportText, 
				x = intW - 50, y = posY + 50,
				width = 390,
				font = fontFamilyBold,   
				fontSize = 22, align = "left"
			})
			lblSport:setFillColor( 0 )
			lblSport.anchorX = 1
			scrPerfile:insert(lblSport)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 97, posY + 55)
			scrPerfile:insert(triangle)
			
		elseif nameOption[i] == "hobbies" then
			
			if item.deportes then
				for i=1, #item.deportes do
					if i == 1 then
						sportText = item.deportes[i]
					else
						sportText = sportText ..', '.. item.deportes[i]
					end
				end
			end
			local hobbiesText = "Editar pasatiempos"
			if item.hobbies then
				for i=1, #item.deportes do
					if i == 1 then
						hobbiesText = item.deportes[i]
					else
						hobbiesText = hobbiesText ..', '.. item.deportes[i]
					end
				end
			end
		
			local bgInts= display.newRect( intW - 55, posY + 50, 400, 80 )
			bgInts.anchorX = 1
			bgInts:setFillColor( 1 )
			bgInts.alpha = .02
			bgInts.name = "hobbies"
			bgInts.label = "Tus hobbies"
			bgInts.type = "create"
			scrPerfile:insert(bgInts)
			bgInts:addEventListener( 'tap', showOptionsLabels )
			
			lblInts = display.newText({
				text = hobbiesText, 
				x = intW - 50, y = posY + 50,
				width = 390,
				font = fontFamilyBold,   
				fontSize = 22, align = "left"
			})
			lblInts:setFillColor( 0 )
			lblInts.anchorX = 1
			scrPerfile:insert(lblInts)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 97, posY + 55)
			scrPerfile:insert(triangle)
		
		end
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY + 50)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY + 50, intW - 65)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY + 50, 380)
		end
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	
end

------------------------------------
function createTouristGuideItems( item )
	-------Generales-----------
    -- BG Component
	local line = display.newLine( 0, posY - 2 , intW, posY - 2 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	local iconOpcion = {}
	local infoOpcion = {}
	local typeOpcion = {}
	local nameOption = {}
	local num = #infoOpcion + 1
	--disponibilidad
	infoOpcion[num] = "Disponibilidad: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "availability"
	num = #infoOpcion + 1
	if not item.diponibilidad then
		item.diponibilidad = "Consultarme"
    end
	availability = item.diponibilidad
	--alojamiento
	infoOpcion[num] = "Alojamiento: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "accommodation"
	num = #infoOpcion + 1
	if not item.alojamiento then
		item.alojamiento = "No"
    end
	accommodation = item.alojamiento
	--vehiculo
	infoOpcion[num] = "Vehiculo: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "vehicle"
	num = #infoOpcion + 1
	if not item.vehiculo then
		item.vehiculo = "No"
    end
	vehicle = item.vehiculo
	--comida
	infoOpcion[num] = "Comida: "
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "food"
	num = #infoOpcion + 1
	if not item.comida then
		item.comida = "No"
    end
    food = item.comida
    -- Options
   -- posY = posY + 45
	
	--[[bgComp1.height = (#infoOpcion * 80) + 70
	bgComp2.height = (#infoOpcion * 80) + 66]]
	
    for i=1, #infoOpcion do
        
        --[[local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end]]
		
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY + 50)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY + 50, intW - 65)
		end
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	--creamos los componentes de preferencias
	createPreferencesItems( item )
end

------------------------------------
-- Pinta la info general del usuario
------------------------------------
function createGeneralItems( item )
	-------Generales-----------
    -- BG Component
	posY = 350
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
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
	typeOpcion[num] = "comboBox"
	nameOption[num] = "gender"
	num = #infoOpcion + 1
	if not item.genero then
		item.genero = "Seleccionar"
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
    for i=1, #infoOpcion do
        
        --[[local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end]]
		
		local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY + 50)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY + 50, intW - 65)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY + 50, 380)
		end
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	createTouristGuideItems( item )
end

-------------
-- 
-------------
function birthdate( event )
	print('hola')
end

------------------------------------
-- Pinta la info del usuario
-- permite editar su informacion
------------------------------------
function MyProfile( item )
	
	grpTextProfile = display.newGroup()
	scrPerfile:insert(grpTextProfile)
	
	posY = 90
	
	local bgTextField = display.newRect( 550, posY + 33, 400, 2 )
	bgTextField:setFillColor( .6 )
	scrPerfile:insert(bgTextField)
	--textField user name
	textUserName = native.newTextField( 550, posY, 400, 90 )
	textUserName.text = item.userName
	textUserName.hasBackground = false
	textUserName.size = 45
	--textUserName:resizeHeightToFitFont()
	textUserName:addEventListener( "userInput", userInputProfile )
	grpTextProfile:insert(textUserName)
	
    local edad = ""
	if not item.edad then 
        edad = "Seleccione una fecha de nacimiento" 
    else 
        edad = item.edad .. " Años" 
    end
    lblAge= display.newText({
        text = edad, 
        x = 550, y = 180,
        width = 400,
        font = fontFamilyRegular, 
        fontSize = 34, align = "left"
    })
    lblAge:setFillColor( 0 )
    scrPerfile:insert(lblAge)
	--lblAge:addElements( 'tap', birthdate )
	-- BG Component
	
	--creamos los componentes generales
	createGeneralItems( item )
	
end

function createProfileAvatar()
	tools:setLoading(false,grpLoadMyProfile)
	
	item = itemProfile
	-- Avatar
    posY = 0
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
    bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	posY = posY + 150
	
	bgA1 = display.newImage( "img/circle-256.png" )
	bgA1.anchorX = 0
	bgA1:translate( 65, posY )
	scrPerfile:insert(bgA1)
	
	local path = system.pathForFile( item.image, system.TemporaryDirectory )
	local fhd = io.open( path )
	--verifica si existe la imagen
	if fhd then
	
		local mask = graphics.newMask( "img/image-mask-mask3.png" )
		local avatar = display.newImage(item.image, system.TemporaryDirectory)
		avatar:translate( 69, posY)
		avatar.anchorX = 0
		avatar.height = 250
		avatar.width = 250
		scrPerfile:insert(avatar)
		avatar:setMask( mask )
		avatar.maskScaleY = 1.35
		avatar.maskScaleX = 1.35
		
		--[[local ChangePhoto = display.newRect( midW - 190, 170, 235, 235 )
		ChangePhoto:setFillColor( 1 )
		ChangePhoto.alpha = .1
		scrPerfile:insert(ChangePhoto)
		ChangePhoto:addEventListener( 'tap', optionAvatar )
		
		local bgChangePhoto = display.newRect( midW - 190, 247, 225, 80 )
		bgChangePhoto:setFillColor( 1 )
		bgChangePhoto.alpha = .8
		scrPerfile:insert(bgChangePhoto)
		
		local imgChangePhoto = display.newImage("img/camera-slr-64.png")
		imgChangePhoto:translate(midW - 107, 255)
		imgChangePhoto.alpha = .8
		scrPerfile:insert(imgChangePhoto)
		
		local lblChangePhoto = display.newText({
			text = "Editar", 
			x = midW - 230, y = 255,
			font = native.systemFont,   
			fontSize = 32, align = "left"
		})
		lblChangePhoto:setFillColor( 129/255, 61/255, 153/255 )
		scrPerfile:insert(lblChangePhoto)]]
		
	else
		local items = {}
		items[1] = item
		RestManager.getImagePerfile(items)
	end
	
	posY = posY + 150
	
	local line = display.newLine( 0, posY , intW, posY )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	if not isReadOnly then
		MyProfile( item )
		-- Btn Iniciar conversación
		posY = posY + 50
		btnSaveProfile = display.newRect( midW, posY, intW, 120 )
		btnSaveProfile.id = item.id
		btnSaveProfile:setFillColor( 0/255, 174/255, 239/255 )
		scrPerfile:insert(btnSaveProfile)
		btnSaveProfile:addEventListener( 'tap', saveProfile )
		local lblSaveProfile = display.newText({
			text = "Guardar Cambios", 
			x = midW, y = posY,
			font = fontFamilyBold,   
			fontSize = 32, align = "center"
		})
		lblSaveProfile:setFillColor( 1 )
		scrPerfile:insert(lblSaveProfile)
    end
	
	scrPerfile:setScrollHeight(posY + 100)

end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
-- ScrollView listener
function scrListen( event )
	local x, y = scrPerfile:getContentPosition()
	if textUserName  then
	   -- print(y)
		if y < -80 and textUserName.x == 550 then
			textUserName.x = 1000
		elseif y >= -80 and textUserName.x == 1000 then
			textUserName.x = 550
		end
	end
	if textName then
		if y < -460 and textName.x == 485 then
			textName.x = 1000
		elseif y >= -460 and textName.x == 1000 then
			textName.x = intW - 65
		end
	end
	if textLastName  then
		if y < -540 and textLastName.x == 485 then
			textLastName.x = 1000
		elseif y >= -540 and textLastName.x == 1000 then
			textLastName.x = intW - 65
		end
	end
	if textOriginCountry  then
		if y < -680 and textOriginCountry.x == 500 then
			textOriginCountry.x = 1000
		elseif y >= -680 and textOriginCountry.x == 1000 then
			textOriginCountry.x = intW - 65
		end
	end
	if textUserResidence  then
		if y < -750 and textUserResidence.x == 500 then
			textUserResidence.x = 1000
		elseif y >= -750 and textUserResidence.x == 1000 then
			textUserResidence.x = intW - 65
		end
	end
	if textEmailContact  then
		if y < -910 and textEmailContact.x == 515 then
			textEmailContact.x = 1000
		elseif y >= -910 and textEmailContact.x == 1000 then
			textEmailContact.x = intW - 65
		end
	end
    
    return true
end

---------------------------------------------
-- Se crea la scena con los datos del perfil
---------------------------------------------
function scene:create( event )
	--local item = event.params.item
	screen = self.view
    --screen.y = h
	
	local o = display.newRect( midW, midH + h, intW+8, intH )
	o:setFillColor( 245/255 )
    screen:insert(o)
	o:addEventListener( 'tap', closeAll )
	
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
        listener = scrListen
    })
	screen:insert(scrPerfile)
	
	
	grpLoadMyProfile = display.newGroup()
	screen:insert(grpLoadMyProfile)
	grpLoadMyProfile.y = 650 + h
	tools:setLoading(true,grpLoadMyProfile)
	if not itemProfile then
		RestManager.getUsersById("show")
	else
		createProfileAvatar()
	end
	
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
	local phase = event.phase
	if phase == "will" then
		if grpTextProfile then
			grpTextProfile:removeSelf()
			grpTextProfile = nil
		end
		
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