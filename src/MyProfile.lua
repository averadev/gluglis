---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local widget = require( "widget" )
require( 'src.components.DatePicker' )
local composer = require( "composer" )
RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local scrPerfile, scrElements, scrCombo
local grpOptionsLabel, grpOptionsCombo, grpComboBox, grpOptionAvatar, grpOptionSave, grpAvatar
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
local maskA
local maskHeight

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- carga los datos del usuario
-- @params item elementos del perfil
-- @params after indica la accion a realizar despues de carga la informacion
---------------------------------------------------------------------------------
function getUserPerfil( item, after )
	itemProfile = item
	if after == "show" then
		createProfileAvatar()
	else
		composer.gotoScene( "src.Home" )
	end
end

--------------------------------
-- Guarda la lista de hobbies
-- @params hobbie, lenguaje, deporte, tiempo de residencia, carrera, tiempo trabajando, genero
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

------------------------------------------
-- Obtiene la fecha dada del datePicker
-- @params date1 Fecha en formato
-- @params date2  Fecha en formato
------------------------------------------
function getBirthDate(date1, date2)
	lblAge.text = date1
	lblAge.date = date2
end

--------------------------------
-- Guarda los datos del perfil
--------------------------------
function saveProfile()
	
	-- Quita los espacios en blanco del principio y final
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end

	--deshabilitar el evento de saveProfile
	btnSaveProfile:removeEventListener( 'tap', saveProfile )
	tools:setLoading(true,screen)
	--carga las listas en tablas
	for i=1, #myHobbies, 1 do
		myHobbies[i] = string.gsub( myHobbies[i], "/", '...' )
	end
	for i=1, #myLanguages, 1 do
		myLanguages[i] = string.gsub( myLanguages[i], "/", '...' )
	end
	for i=1, #mySports, 1 do
		mySports[i] = string.gsub( mySports[i], "/", '...' )
	end
	--llamado del metodo trim
	textUserName.text = trimString(textUserName.text)
	textName.text = trimString(textName.text)
	textLastName.text = trimString(textLastName.text)
	textOriginCountry.text = trimString(textOriginCountry.text)
	textUserResidence.text = trimString(textUserResidence.text)
	--save data
	RestManager.saveProfile(
		textUserName.text, 
		lblAge.date,
		myHobbies,
		textName.text,
		textLastName.text,
		lblGender.text,
		textOriginCountry.text,
		textUserResidence.text,
		lblResidenceTime.text,
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
-- carga los datos del perfil
-------------------------------------------------------------
function resultSaveProfile( isTrue, message)
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

------------------------------------------------------
-- Muestra el datePicker para fecha de cumpleaños
------------------------------------------------------
function showDatePicker()
	buildPicker(lblAge.date, grpTextProfile)
end

------------------------------------------------------------------------------
-- Pinta la imagen del usuario en caso de no encontrarse al crear la scena
-- @param imageA nombre de la imagen
------------------------------------------------------------------------------
function setImagePerfil( imageA )

	if grpAvatar then
		grpAvatar:removeSelf()
		grpAvatar = nil
	end
	
	grpAvatar = display.newGroup()
	scrPerfile:insert(grpAvatar)
	
	posY = 150
	
	maskA = graphics.newMask( "img/image-mask-mask3.png" )
	avatar = display.newImage(imageA, system.TemporaryDirectory)
	avatar:translate( 69, posY)
	avatar.anchorX = 0
	avatar.height = 250
	avatar.width = 250
	avatar.name = imageA
	grpAvatar:insert(avatar)
	avatar:setMask( maskA )
	avatar.maskScaleY = 1.35
	avatar.maskScaleX = 1.35
		
	local bgShowPhoto = display.newRoundedRect( midW - 190, posY, 250, 250, 125 )
	bgShowPhoto:setFillColor( 1 )
	bgShowPhoto.alpha = .01
	bgShowPhoto.image = imageA
	grpAvatar:insert(bgShowPhoto)
	bgShowPhoto:addEventListener( 'tap', showAvatar )
		
	local bgChangePhoto = display.newImage( 'img/circle-94.png' )
	bgChangePhoto:translate( midW - 115, posY + 100)
	bgChangePhoto.anchorX = 0
	bgChangePhoto:addEventListener( 'tap', optionPictureAvatar )
	grpAvatar:insert(bgChangePhoto)
		
	local imgChangePhoto = display.newImage("img/camera-4-64.png")
	imgChangePhoto:translate(midW - 68, 249)
	imgChangePhoto.alpha = .8
	grpAvatar:insert(imgChangePhoto)
	
	tools:setLoading(false,grpLoadMyProfile)
	
end

------------------------------------------------------------
-- elimina la imagen actual cuando se actualiza una nueva
------------------------------------------------------------
function deleteAvatarMyProfile()
	if avatar then
		avatar:setMask( nil )
		maskA = nil
		avatar:removeSelf()
		avatar = nil
	end
end

------------------------------------------------------------
-- actualiza la foto de perfil
------------------------------------------------------------
function saveAvatar( event )

	tools:setLoading(true,grpLoadMyProfile)
	
	settings = DBManager.getSettings()
	nameImage = settings.idApp
	
	deleteAvatarMyProfile()
	--elimina la foto de perfil actual del resources
	local img = nameImage .. "png"
	local path = system.pathForFile( img, system.TemporaryDirectory )
	local fhd = io.open( path )
	if fhd then
		fhd:close()
			
		local lfs = require "lfs"
		local doc_path = system.pathForFile( "", system.TemporaryDirectory )
		local destDir = system.TemporaryDirectory  -- where the file is stored
		local img = nameImage .. "png"
			
		for file in lfs.dir(doc_path) do
			-- file is the current file or directory name
			local file_attr = lfs.attributes( system.pathForFile( file, destDir  ) )
			-- Elimina despues de 2 semanas
			if file == img then		
				os.remove( system.pathForFile( file, destDir  ) ) 
			end
		end
	end
	
	local t = event.target
	
	hideOptionSaveAvatar()
	
	if ( t.name == "cut" ) then
		display.save( avatarMask, { filename = nameImage .. ".png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,0} } )
	else
		display.save( avatarFull, { filename = nameImage .. ".png", baseDir=system.TemporaryDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,0} } )
	end
	
	hideoptionAvatar()

	RestManager.savePhoto(nameImage)
	
	return true
end

------------------------------------------------------------
-- Muestra opciones de como se guardara la imagen
------------------------------------------------------------
function optionSaveAvatar()

	componentActive = "PictureAvatar"
	
	if grpOptionSave then
		grpOptionSave:removeSelf()
		grpOptionSave = nil
	end
	
	if grpOptionAvatar then
		grpOptionAvatar.alpha = 0
	end
	
	grpOptionSave = display.newGroup()

	if grpTextProfile then
		grpTextProfile.x = intW
	end
	
	local bg0 = display.newRect( midW, midH + h + 135, intW, intH )
	bg0:setFillColor( 245/255 )
	grpOptionSave:insert( bg0 )
	bg0:addEventListener( 'tap', hideOptionSaveAvatar )
	
	local posY = 250 + h 
	local option = { "cut", "full" }
	local optionLabel = { language.MpCropSave, language.MpSaveUntrimmed }
	local optionIcon = { "img/cut.png", "img/full.png" }
	
	for i = 1, #option, 1 do
		local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpOptionSave:insert(line)
		
		local btnOption = display.newRect( midW, posY, intW, 200 )
		btnOption.anchorY = 0
		btnOption:setFillColor( 1)
		grpOptionSave:insert(btnOption)
		btnOption.name = option[i]
		grpOptionSave:insert( btnOption )
		btnOption:addEventListener( 'tap', saveAvatar )
		
		local iconOption = display.newImage(optionIcon[i])
		iconOption.anchorX = 0
		iconOption:translate(100, posY + 100)
		grpOptionSave:insert( iconOption )
		
		local lblOption = display.newText({
			text = optionLabel[i], 
			x = 500, y = posY + 65 + 33,
			width = 490,
			font = fontFamilyBold,   
			fontSize = 36, align = "left"
		})
		lblOption:setFillColor( 0 )
		grpOptionSave:insert(lblOption)
		
		posY = posY + 200

		local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpOptionSave:insert(line)
		
		posY = posY + 75
	end
	
	local line = display.newLine( 0, intH - 176 , intW, intH - 176 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpOptionSave:insert(line)
	
	local btnCancel = display.newRect( midW, intH - 175, intW, 150 )
	btnCancel.anchorY = 0
	btnCancel:setFillColor( 226/255 )
    grpOptionSave:insert(btnCancel)
	btnCancel:addEventListener( 'tap', hideOptionSaveAvatar )
	
	local lblCancel = display.newText({
        text = language.MpCancel,
        x = midW, y = intH - 95,
        font = fontFamilyBold,   
        fontSize = 38, align = "left"
    })
    lblCancel:setFillColor( 85/255 )
    grpOptionSave:insert(lblCancel)
	
	local line = display.newLine( 0, intH - 26 , intW, intH - 26 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpOptionSave:insert(line)
	
	return true
	
end

------------------------------------------------------------
-- esconde la opcion de como se guarda la imagen
------------------------------------------------------------
function hideOptionSaveAvatar()
	componentActive = false
	if grpOptionSave then
		grpOptionSave:removeSelf()
		grpOptionSave = nil
	end
	grpTextProfile.x = 0
	grpAvatar.x = 0
	return true
end

------------------------------------------------------------
-- permite mover el cuadro para recortar imagen
------------------------------------------------------------
function moveMasckAvatar( event )
	
	if ( event.phase == "began" ) then
        differenceX = event.x - avatarMask.maskX
		differenceY = event.y - avatarMask.maskY
		maxY = ( avatarFull.height / 2 ) - ( 552 / 2 ) -- 552 = tamaño de la mascara
		maxX = ( avatarFull.width / 2 ) - ( 550 / 2 ) -- 550 = tamaño de la mascara
	elseif ( event.phase == "moved" ) then
		newPositionX = event.x - differenceX
		newPositionY = event.y - differenceY
		if newPositionY >= -( maxY ) and  newPositionY <= ( maxY ) then
			avatarMask.maskY = newPositionY
		end
		if newPositionX >= -( maxX ) and  newPositionX <= ( maxX ) then
			avatarMask.maskX = newPositionX
		end
	elseif ( event.phase == "ended" ) then
		newPositionX = event.x - differenceX
		newPositionY = event.y - differenceY
		if newPositionY >= -( maxY ) and  newPositionY <= ( maxY ) then
			avatarMask.maskY = newPositionY
		end
		if newPositionX >= -( maxX ) and  newPositionX <= ( maxX ) then
			avatarMask.maskX = newPositionX
		end
    end
	return true
	
end

------------------------------------------------------------
-- Muestra la imagen de perfil ampliada
------------------------------------------------------------
function showAvatar( event )

	bgOptionAvatar()
	
	local t = event.target
	--image
	
	local path = system.pathForFile( t.image, system.TemporaryDirectory )
	local fhd = io.open( path )
	--verifica si existe la imagen
	if fhd then
	
		fhd:close()
		local bg1 = display.newRect( midW, midH + h, intW, intH )
		bg1:setFillColor( 0/255, 174/255, 239/255 )
		grpOptionAvatar:insert( bg1 )
		bg1:addEventListener( 'tap', hideoptionAvatar )
		
		avatarFull = display.newImage( t.image, system.TemporaryDirectory )
		avatarFull:translate(midW, midH + h)
		grpOptionAvatar:insert(avatarFull)
		local desiredHigh = ( (intW - 100) * avatarFull.height ) / avatarFull.width 
		avatarFull.height = desiredHigh
		avatarFull.width = intW-100
		
		bg1.height = desiredHigh  + 8
		bg1.width = intW-100  + 8
			
		local iconExitAvatarFull = display.newImage("img/close.png")
		iconExitAvatarFull:translate(intW - 50, bg1.y - bg1.height/2)
		iconExitAvatarFull.height = 64
		iconExitAvatarFull.width = 64
		grpOptionAvatar:insert(iconExitAvatarFull)
	end

end

------------------------------------------------------------
-- fondo donde se muestra la imagen de perfil
------------------------------------------------------------
function bgOptionAvatar()
	
	componentActive = "OptionAvatar"
	if grpOptionAvatar then
		grpOptionAvatar:removeSelf()
		grpOptionAvatar = nil
	end
	grpTextProfile.x = intW
	grpOptionAvatar = display.newGroup()
	
	local bg0 = display.newRect( midW, midH + h, intW, intH )
	bg0:setFillColor( 0 )
	bg0.alpha = .7
	grpOptionAvatar:insert( bg0 )
	bg0:addEventListener( 'tap', hideoptionAvatar )
	
end

------------------------------------------------------------------
-- Muestra la nueva imagen de perfil cuando se ha actualizado
------------------------------------------------------------------
function showNewAvatar( event )

	hideOptionSaveAvatar()

	bgOptionAvatar()
	
	local nameImage
	for k, v in string.gmatch(avatar.name, "(%w+).(%w+)") do
		nameImage = k
	end
	
	local path = system.pathForFile( "newAvatar.jpg", system.TemporaryDirectory )
	local fhd = io.open( path )
	--verifica si existe la imagen
	if fhd then
		fhd:close()
	
		avatarFull = display.newImage("newAvatar.jpg", system.TemporaryDirectory)
		avatarFull:translate(midW, 0 + h)
		grpOptionAvatar:insert(avatarFull)
		
		avatarFull:addEventListener('touch', moveMasckAvatar)
		avatarFull:addEventListener( 'tap', noAction )
		
		--rediseña el tamaño de la imagen
		local heightBgAvatar = intH - 150 - h
		local resizeWidth = 0
		local resizeHeight = 0
		local anchorY = .5
		local pocsY = midH
		if ( avatarFull.height > heightBgAvatar ) then
			resizeWidth = ( heightBgAvatar * avatarFull.width ) / avatarFull.height
			resizeHeight = heightBgAvatar
			anchorY = 0
			pocsY = 0
			
		elseif ( avatarFull.width > intW ) then
			resizeHeight = ( intW * avatarFull.height ) / avatarFull.width
			resizeWidth = intW
		else
			if avatarFull.height > avatarFull.width then
			elseif avatarFull.width > avatarFull.height then
			else
			end
			resizeHeight = avatarFull.height
			resizeWidth = avatarFull.width
		end
		
		avatarFull.height = resizeHeight
		avatarFull.width = resizeWidth
		avatarFull.anchorY = anchorY
		avatarFull.y = pocsY
			
		local bg1 = display.newRect( midW, midH + h, intW, intH )
		bg1:setFillColor( 1 )
		bg1.alpha = .5
		grpOptionAvatar:insert( bg1 )
		bg1.height = resizeHeight
		bg1.width = resizeWidth
		bg1.anchorY = anchorY
		bg1.y = pocsY
		
		--mascara
		local maskA = graphics.newMask( "img/maskPhoto3.png" )
		avatarMask = display.newImage("newAvatar.jpg", system.TemporaryDirectory)
		avatarMask:translate(midW, 0 + h)
		grpOptionAvatar:insert(avatarMask)
		avatarMask.posY = avatarMask.y
		avatarMask:setMask( maskA )
		avatarMask.height = resizeHeight
		avatarMask.width = resizeWidth
		avatarMask.anchorY = anchorY
		avatarMask.y = pocsY
		avatarMask.maskScaleX, avatarMask.maskScaleY = 1.5, 1.5
		
		--btn save
		local bgSaveAvatar = display.newRect( midW, intH - 60, intW, 120 )
		bgSaveAvatar.id = nameImage
		bgSaveAvatar:setFillColor( .73 )
		grpOptionAvatar:insert(bgSaveAvatar)
		
		local btnCancelSaveAvatar = display.newRect( 0, intH - 60, midW - 1, 120 )
		btnCancelSaveAvatar.anchorX = 0
		btnCancelSaveAvatar.id = nameImage
		btnCancelSaveAvatar:setFillColor( 0/255, 174/255, 239/255 )
		grpOptionAvatar:insert(btnCancelSaveAvatar)
		
		local lblCancelSaveAvatar = display.newText({
			text = language.MpCancel, 
			x = 0, y = intH - 60,
			width = midW,
			font = fontFamilyBold, 
			fontSize = 28, align = "center"
		})
		lblCancelSaveAvatar:setFillColor( 1 )
		lblCancelSaveAvatar.anchorX = 0
		grpOptionAvatar:insert(lblCancelSaveAvatar)
		
		local btnSaveAvatar = display.newRect( midW + 1, intH - 60, midW - 1, 120 )
		btnSaveAvatar.anchorX = 0
		btnSaveAvatar.id = nameImage
		btnSaveAvatar:setFillColor( 0/255, 174/255, 239/255 )
		grpOptionAvatar:insert(btnSaveAvatar)
		btnSaveAvatar:addEventListener( 'tap', optionSaveAvatar )
		
		local lblSaveAvatar = display.newText({
			text = language.MpSave, 
			x = midW, y = intH - 60,
			width = midW,
			font = fontFamilyBold, 
			fontSize = 28, align = "center"
		})
		lblSaveAvatar:setFillColor( 1 )
		lblSaveAvatar.anchorX = 0
		grpOptionAvatar:insert(lblSaveAvatar)
		
	end
	
end

------------------------------------------------------------
-- Activa la camara del telefono
------------------------------------------------------------
function takePicture()
	local function onComplete( event )
		local json = require("json")
		if ( event.completed ) then
			showNewAvatar( "newPhoto" )
		end
	end
	namePhoto = "newAvatar.jpg"
	
	if media.hasSource( media.Camera ) then
		media.capturePhoto({ 
			listener=onComplete,
			destination = {
				baseDir = system.TemporaryDirectory,
				filename = namePhoto,
				type = "image"
			}
		})
	else
		native.showAlert( "Gluglis", "This device does not have a camera.", { "OK" } )
	end

end

------------------------------------------------------------
-- Muestra las fotos de la libreria
------------------------------------------------------------
function libraryPicture()
	local function onComplete( event )
		if ( event.completed ) then
			showNewAvatar( "newPhoto" )
		else
			
		end
	end
	
	namePhoto = "newAvatar.jpg"
	if media.hasSource( media.PhotoLibrary ) then
		media.selectPhoto({
			mediaSource = media.PhotoLibrary,
			listener = onComplete,
			destination = { baseDir=system.TemporaryDirectory, filename = namePhoto } 
		})
		
	else
		native.showAlert( "Gluglis", "This device does not have a photo library.", { "OK" } )
	end
end

------------------------------------------------------------------------------
-- Indica si se quiere tomar una foto o subir del album
------------------------------------------------------------------------------
function selectOptionAvatar( event )
	local t = event.target
	if( t.name == "selectPhoto" ) then
		takePicture()
	elseif( t.name == "capturePhoto" ) then
		libraryPicture()
	end
	return true
end

------------------------------------------------------------------------------
-- muestra las opciones de foto de perfil
-- ver o editar
------------------------------------------------------------------------------
function optionPictureAvatar( event )

	componentActive = "PictureAvatar"
	
	if grpOptionSave then
		grpOptionSave:removeSelf()
		grpOptionSave = nil
	end
	
	grpOptionSave = display.newGroup()

	grpTextProfile.x = intW
	grpAvatar.x = intW
	
	local bg0 = display.newRect( midW, midH + h + 135, intW, intH )
	bg0:setFillColor( 245/255 )
	grpOptionSave:insert( bg0 )
	bg0:addEventListener( 'tap', hideOptionSaveAvatar )
	
	local posY = 250 + h 
	local option = { "selectPhoto", "capturePhoto" }
	local optionLabel = { language.MpTakePhoto, language.MpUploadPhoto }
	local optionIcon = { "img/photo.png", "img/up.png" }
	local optionSub = { language.MpTakePhotoSub, language.MpUploadPhotoSub }
	
	for i = 1, #option, 1 do
		local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpOptionSave:insert(line)
		
		local btnOption = display.newRect( midW, posY, intW, 200 )
		btnOption.anchorY = 0
		btnOption:setFillColor( 1)
		grpOptionSave:insert(btnOption)
		btnOption.name = option[i]
		grpOptionSave:insert( btnOption )
		btnOption:addEventListener( 'tap', selectOptionAvatar )
		
		local iconOption = display.newImage(optionIcon[i])
		iconOption.anchorX = 0
		iconOption:translate(100, posY + 100)
		grpOptionSave:insert( iconOption )
		
		local lblOption = display.newText({
			text = optionLabel[i], 
			x = 500, y = posY + 65,
			width = 490,
			font = fontFamilyBold,   
			fontSize = 36, align = "left"
		})
		lblOption:setFillColor( 0 )
		grpOptionSave:insert(lblOption)
		
		local lblSubOption = display.newText({
			text = optionSub[i], 
			x = 500, y = posY + 130,
			width = 490,
			font = fontFamilyRegular,   
			fontSize = 26, align = "left"
		})
		lblSubOption:setFillColor( 0 )
		grpOptionSave:insert(lblSubOption)
		
		posY = posY + 200

		local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpOptionSave:insert(line)
		
		posY = posY + 75
	end
	
	local line = display.newLine( 0, intH - 176 , intW, intH - 176 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpOptionSave:insert(line)
	
	local btnCancel = display.newRect( midW, intH - 175, intW, 150 )
	btnCancel.anchorY = 0
	btnCancel:setFillColor( 226/255 )
    grpOptionSave:insert(btnCancel)
	btnCancel:addEventListener( 'tap', hideOptionSaveAvatar )
	
	local lblCancel = display.newText({
        text = language.MpCancel,
        x = midW, y = intH - 95,
        font = fontFamilyBold,   
        fontSize = 38, align = "left"
    })
    lblCancel:setFillColor( 85/255 )
    grpOptionSave:insert(lblCancel)
	
	local line = display.newLine( 0, intH - 26 , intW, intH - 26 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpOptionSave:insert(line)
	
	return true
	
end

-------------------------------------
-- Esconde la opcion de subir foto
-------------------------------------
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
function getCityProfile(item)
	if( #item > 0 ) then
		textUserResidence.text = item[1].description
		textUserResidence.city = item[1].description
		textUserResidence.id = item[1].place_id
	end
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
		if t.name == "residence" then
			textName.x = intW - 65
			textLastName.x = intW - 65
			textOriginCountry.x = intW - 65
		end
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
-- Mueve el toggleButton
----------------------------
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

-------------------------------------
-- Muestra los cambo box de perfil
-------------------------------------
function showComboBoxMP( event )
	
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
	bg0:addEventListener( 'tap', hideComboBoxProfile )
	local bg1 = display.newRect( midW, midH + h, 606, midH )
	bg1:setFillColor( 1 )
	grpComboBox:insert( bg1 )
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
	--identifica que elemento Cargará
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
	--pinta los elementos del cambo
	for i = 1, #setElements, 1 do
		local container2 = display.newContainer( 600, 100 )
		scrCombo:insert(container2)
		container2.anchorY = 0
		container2:translate( 300, posY )
		local bg0OptionCombo = display.newRect( 0, 0, 600, 100 )
		bg0OptionCombo:setFillColor( 1 )
		bg0OptionCombo.name = t.name
		bg0OptionCombo.option = setElements[i].name
		container2:insert( bg0OptionCombo )
		bg0OptionCombo:addEventListener( 'tap', selectOptionCombo )
		
		--label nombre
		local lblNameOption = display.newText({
			text = setElements[i].name, 
			x = 0, y = 0,
			width = 500,
			font = fontFamilyRegular, 
			fontSize = 32, align = "left"
		})
		lblNameOption:setFillColor( 0 )
		container2:insert(lblNameOption)
		posY = posY + 106
	end
end

---------------------------------------------------------------------------
-- Asiagna la opcion seleccionada a los label
-- @params event.target.name identifica a que label pertenece la opcion
---------------------------------------------------------------------------
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
	hideComboBoxProfile( "" )
	return true
end

-------------------------------------
-- Esconde el combobox
-------------------------------------
function hideComboBoxProfile( event )
	componentActive = false
	if grpComboBox then
		grpComboBox:removeSelf()
		grpComboBox = nil
	end
	if grpTextProfile then
		
	end
	grpTextProfile.x = 0
	return true
end

----------------------------------------------------------------------------------
-- Creacion de los comboBox
-- @param item valor inicia de los elementos
-- @param name nombre del elemento 
-- @param coordY, coordX coordenadas en y y x de la posición del elemento
----------------------------------------------------------------------------------
function createComboBox(item, name, coordY, coordX )

	coordY = coordY - 25
	-- BG Component
	local bg0CheckAcco = display.newRect( intW - 65, coordY + 25, 400, 90 )
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco:setFillColor( 1 )
	bg0CheckAcco.name = name
	scrPerfile:insert(bg0CheckAcco)
	bg0CheckAcco:addEventListener( 'tap', showComboBoxMP )
	local triangle = display.newImage("img/down.png")
	triangle:translate(coordX + 295, coordY + 25)
	triangle.height = 48
	triangle.width = 48
	scrPerfile:insert(triangle)
	if name == "gender" then
		lblGender = display.newText({
			text = item.genero, 
			x = coordX + 75, y = coordY + 25,
			width = 375,
			font = fontFamilyBold,   
			fontSize = 26, align = "right"
		})
		lblGender:setFillColor( 0 )
		scrPerfile:insert(lblGender)
	elseif name == "residenceTime" then
		lblResidenceTime = display.newText({
			text = item.tiempoResidencia, 
			x = coordX + 75, y = coordY + 25,
			width = 375,
			font = fontFamilyBold,   
			fontSize = 26, align = "right"
		})
		lblResidenceTime:setFillColor( 0 )
		scrPerfile:insert(lblResidenceTime)
	elseif name == "race" then
		lblRace = display.newText({
			text = item.nivelEstudio, 
			x = coordX + 75, y = coordY + 25,
			width = 375,
			font = fontFamilyBold,   
			fontSize = 26, align = "right"
		})
		lblRace:setFillColor( 0 )
		scrPerfile:insert(lblRace)
	elseif name == "workArea" then
		lblWorkArea = display.newText({
			text = item.areaLaboral, 
			x = coordX + 75, y = coordY + 25,
			width = 375,
			font = fontFamilyBold,   
			fontSize = 26, align = "right"
		})
		lblWorkArea:setFillColor( 0 )
		scrPerfile:insert(lblWorkArea)
	end

end

-------------------------------------------------
-- Creacion de los togle buttons
-- @param item valor inicia de los elementos
-- @param name nombre del elemento 
-- @param coordY, coordX coordenadas en y y x de la posición del elemento
-------------------------------------------------
function createToggleButtons(item, name, coordY, coordX )
	local num = #toggleButtons + 1
	coordY = coordY - 25
	-- BG Component
	local bg0CheckAcco = display.newRoundedRect( coordX, coordY + 25, 140, 70, 35 )
	bg0CheckAcco.anchorX = 1
	bg0CheckAcco.name = name
	bg0CheckAcco:setFillColor( 0/255, 174/255, 239/255 )
	bg0CheckAcco:addEventListener( 'tap', moveToggleButtons )
	scrPerfile:insert(bg0CheckAcco)
	bg0CheckAcco.pocsX = coordX
	bg0CheckAcco.num = num
	
	local posXTB = coordX - 75
	local onOff = "No"
	--genero
	if name == "gender" then
		if item.genero ~= nil and item.genero == 'Hombre' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
	--alojamiento
	if name == "accommodation" then
		if item.alojamiento ~= nil and item.alojamiento == 'Sí' then
			onOff = "Sí"
			posXTB = coordX - 4
		end
	end
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
			text = language.MpOk, 
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

----------------------------------------
-- Destruye las opciones de las etiquetas
----------------------------------------
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
-- @param item valor inicia de los elementos
-- @param name nombre del elemento 
-- @param coordY, coordX coordenadas en y y x de la posición del elemento
------------------------------------
function createTextField( item, name, coordY )
	local bgTextField = display.newRect( intW - 65, coordY + 30, 400, 2 )
	bgTextField.anchorX = 1
	bgTextField:setFillColor( 240/255 )
	scrPerfile:insert(bgTextField)
	if name == "name" then
		--textField user name
		textName = native.newTextField(  intW - 65, coordY, 400 , 90 )
		textName.anchorX = 1
		textName.text = item.nombre
		textName.hasBackground = false
		textName.size = 35
		textName:addEventListener( "userInput", userInputProfile )
		textName.name = "name"
		textName.align = "right"
		grpTextProfile:insert(textName)
	elseif name == "lastName" then
		--textField apellido
		textLastName = native.newTextField( intW - 65, coordY, 400 , 90 )
		textLastName.anchorX = 1
		textLastName.text = item.apellidos
		textLastName.hasBackground = false
		textLastName.size = 35
		textLastName.align = "right"
		textLastName:addEventListener( "userInput", userInputProfile )
		textLastName.name = "lastName"
		grpTextProfile:insert(textLastName)
	elseif name == "originCountry" then
		--textField pais de origen
		textOriginCountry = native.newTextField( intW - 65, coordY, 400 , 90 )
		textOriginCountry.anchorX = 1
		textOriginCountry.text = item.paisOrigen
		textOriginCountry.hasBackground = false
		textOriginCountry.size = 35
		textOriginCountry:addEventListener( "userInput", userInputProfile )
		textOriginCountry.name = "originCountry"
		textOriginCountry.align = "right"
		grpTextProfile:insert(textOriginCountry)
	elseif name == "residence" then
		--textField residence
		textUserResidence = native.newTextField( intW - 65, coordY, 400 , 90 )
		textUserResidence.anchorX = 1
		textUserResidence.text = item.residencia
		textUserResidence.hasBackground = false
		textUserResidence.size = 35
		textUserResidence:addEventListener( "userInput", userInputProfile )
		textUserResidence.name = "residence"
		textUserResidence.align = "right"
		textUserResidence.city = item.residencia
		if item.residenciaId then
			textUserResidence.id = item.residenciaId
		else
			textUserResidence.id = 0
		end
		grpTextProfile:insert(textUserResidence)
	elseif name == "emailContact" then
		--textField pais de origen
		textEmailContact = native.newTextField( intW - 65, coordY, 400 , 90 )
		textEmailContact.anchorX = 1
		textEmailContact.text = item.userEmail
		textEmailContact.hasBackground = false
		textEmailContact.size = 35
		textEmailContact.align = "right"
		textEmailContact:addEventListener( "userInput", userInputProfile )
		textEmailContact.name = "emailContact"
		grpTextProfile:insert(textEmailContact)
	end
end

----------------------------------------------
-- Crea los campos de opcion Preferencia
-- @params item la informacion del usuario
----------------------------------------------
function createPreferencesItems( item )
	
	---------- Preferences -----------
    -- BG Component
	local line = display.newLine( 0, posY - 2 , intW, posY - 2 )
	line:setStrokeColor( 240/255 )
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
	infoOpcion[num] = language.MpLanguages
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
	infoOpcion[num] = language.MpHobbies
	iconOpcion[num] = 'icoFilterLanguage'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "hobbies"
	if item.hobbies then
		myHobbies = item.hobbies
    else
		myHobbies = {}
    end
	num = #infoOpcion + 1
	
	--nivel de estudio
	infoOpcion[num] = language.MpLevelOfEducation
	iconOpcion[num] = 'iconSchool'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "race"
	num = #infoOpcion + 1
	if not item.nivelEstudio then
		item.nivelEstudio = language.MpAny
	end
	--area laboral
	infoOpcion[num] = language.MpWorkingArea
	iconOpcion[num] = 'iconJob'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "workArea"
	num = #infoOpcion + 1
	if not item.areaLaboral then
		item.areaLaboral = language.MpAny
	end
	--cuenta propia
	infoOpcion[num] = language.MpFreelance
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "ownAccount"
	num = #infoOpcion + 1
	if not item.cuentaPropia then
		item.cuentaPropia = language.MpEmployee
	end
	ownAccount = item.cuentaPropia
	--mascota
	infoOpcion[num] = language.MpPets
	iconOpcion[num] = 'iconPet'
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "pet"
	num = #infoOpcion + 1
	if not item.mascota then
		item.mascota = language.MpNo
	end
	pet = item.mascota
	--deporte
	infoOpcion[num] = language.MpSportYouPlay
	iconOpcion[num] = 'iconSport'
	typeOpcion[num] = "multiComboBox"
	nameOption[num] = "sport"
	
	if not item.deporte then
		item.deporte = language.MpNo
	end
	if item.deportes then
		mySports = item.deportes
    else
		mySports = {}
    end
	num = #infoOpcion + 1
	--fumas
	infoOpcion[num] = language.MpYouSmok
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "smoke"
	num = #infoOpcion + 1
	if not item.fumas then
		item.fumas = language.MpNo
	end
	 smoke = item.fumas
	--bebes
	infoOpcion[num] = language.MpYouDrinkAlcohol
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "drink"
	num = #infoOpcion + 1
	if not item.bebes then
		item.bebes = language.MpNo
	end
	drink = item.bebes
	--psicotroficos
	infoOpcion[num] = language.MpYouPsychotropicDrugs
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "psychrotrophic"
	num = #infoOpcion + 1
	if not item.psicotroficos then
		item.psicotroficos = language.MpNo
	end
	psychrotrophic = item.psicotroficos
	
	-- Options
    for i=1, #infoOpcion do
		local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 28, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		-- MultiComboBox
		if nameOption[i] == "language" then
			local languageText = language.MpNoLanguage
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
			bgLangs.label = language.MpOtherLanguages
			bgLangs.type = "create"
			scrPerfile:insert(bgLangs)
			bgLangs:addEventListener( 'tap', showOptionsLabels )
			
			lblLang = display.newText({
				text = languageText, 
				x = 465 , y = posY + 50,
				width = 360,
				font = fontFamilyBold,   
				fontSize = 26, align = "right"
			})
			lblLang:setFillColor( 0 )
			scrPerfile:insert(lblLang)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 90, posY + 55)
			triangle.height = 48
			triangle.width = 48
			scrPerfile:insert(triangle)
			
		elseif nameOption[i] == "sport" then
			local sportText = language.MpNoSport
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
			bgSport.label = language.MpSportThatYouPlay
			bgSport.type = "create"
			scrPerfile:insert(bgSport)
			bgSport:addEventListener( 'tap', showOptionsLabels )
			
			lblSport = display.newText({
				text = sportText, 
				x = 465, y = posY + 50,
				width = 360,
				font = fontFamilyBold,   
				fontSize = 26, align = "right"
			})
			lblSport:setFillColor( 0 )
			scrPerfile:insert(lblSport)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 90, posY + 55)
			triangle.height = 48
			triangle.width = 48
			scrPerfile:insert(triangle)
			
		elseif nameOption[i] == "hobbies" then
			
			local hobbiesText = language.MpEditHobbies
			if item.hobbies then
				for i=1, #item.hobbies do
					if i == 1 then
						hobbiesText = item.hobbies[i]
					else
						hobbiesText = hobbiesText ..', '.. item.hobbies[i]
					end
				end
			end
		
			local bgInts= display.newRect( intW - 55, posY + 50, 400, 80 )
			bgInts.anchorX = 1
			bgInts:setFillColor( 1 )
			bgInts.alpha = .02
			bgInts.name = "hobbies"
			bgInts.label = language.MpYourHobbies
			bgInts.type = "create"
			scrPerfile:insert(bgInts)
			bgInts:addEventListener( 'tap', showOptionsLabels )
			
			lblInts = display.newText({
				text = hobbiesText, 
				x = 465, y = posY + 50,
				width = 360,
				font = fontFamilyBold,   
				fontSize = 26, align = "right"
			})
			lblInts:setFillColor( 0 )
			scrPerfile:insert(lblInts)
			
			local triangle = display.newImage("img/down.png")
			triangle:translate(intW - 90, posY + 55)
			triangle.height = 48
			triangle.width = 48
			scrPerfile:insert(triangle)
		
		end
		
		--componentes
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY + 50)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY + 50, intW - 65)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY + 50, 380)
		end
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 240/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 240/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	
end

------------------------------------------------
-- Crea los campos de opcion Guia de turista
-- @params item la informacion del usuario
------------------------------------------------
function createTouristGuideItems( item )
	-------Generales-----------
    -- BG Component
	local line = display.newLine( 0, posY - 2 , intW, posY - 2 )
	line:setStrokeColor( 240/255 )
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
	
	--alojamiento
	infoOpcion[num] = language.MpAccommodation
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "accommodation"
	num = #infoOpcion + 1
	if not item.alojamiento then
		item.alojamiento = "No"
    end
	accommodation = item.alojamiento
	--vehiculo
	infoOpcion[num] = language.MpVehicle
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "vehicle"
	num = #infoOpcion + 1
	if not item.vehiculo then
		item.vehiculo = "No"
    end
	vehicle = item.vehiculo
	--comida
	infoOpcion[num] = language.MpFood
	iconOpcion[num] = ''
	typeOpcion[num] = "toggleButton"
	nameOption[num] = "food"
	num = #infoOpcion + 1
	if not item.comida then
		item.comida = "No"
    end
    food = item.comida
	
    -- Options
    for i=1, #infoOpcion do
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 28, align = "left"
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
		line:setStrokeColor( 240/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 240/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	--creamos los componentes de preferencias
	createPreferencesItems( item )
end

----------------------------------------------
-- Pinta la info general del usuario
-- @params item la informacion del usuario
----------------------------------------------
function createGeneralItems( item )
	-------Generales-----------
    -- BG Component
	posY = 350
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 240/255 )
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
	infoOpcion[num] = language.MpName
	iconOpcion[num] = 'iconName'
	typeOpcion[num] = "textField"
	nameOption[num] = "name"
	num = #infoOpcion + 1
	if not item.nombre then
		item.nombre = ""
	end
	--apellidos
	infoOpcion[num] = language.MpLastName
	iconOpcion[num] = 'iconName'
	typeOpcion[num] = "textField"
	nameOption[num] = "lastName"
	num = #infoOpcion + 1
	if not item.apellidos then
		item.apellidos = ""
	end
	--genero
	infoOpcion[num] = language.MpGender
	iconOpcion[num] = 'icoFilterM'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "gender"
	num = #infoOpcion + 1
	if not item.genero then
		item.genero = language.MpSelect
	elseif item.genero == "" then
		item.genero = language.MpSelect
	end
	gender = item.genero
	
	--pais de origen
	infoOpcion[num] = language.MpCountryOrigin
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "textField"
	nameOption[num] = "originCountry"
	num = #infoOpcion + 1
	if not item.paisOrigen then
		item.paisOrigen = ""
	end
	--residencia
	infoOpcion[num] = language.MpResidence
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "textField"
	nameOption[num] = "residence"
	num = #infoOpcion + 1
	if not item.residencia then
		item.residencia = ""
	end
	--tiempo de residencia
	infoOpcion[num] = language.MpTimeLiving
	iconOpcion[num] = 'icoFilterCity'
	typeOpcion[num] = "comboBox"
	nameOption[num] = "residenceTime"
	num = #infoOpcion + 1
	if not item.tiempoResidencia then
		item.tiempoResidencia = language.MpSelect
	elseif item.tiempoResidencia == "" then
		item.tiempoResidencia = language.MpSelect
	end
	--email contacto
	infoOpcion[num] = language.MpEmail
	iconOpcion[num] = 'iconEmailContacto'
	typeOpcion[num] = "label"
	if not item.userEmail then
		item.userEmail = ""
	end
	nameOption[num] = item.userEmail
	num = #infoOpcion + 1
    
    -- Options
    for i=1, #infoOpcion do
		
		local lbl = display.newText({
            text = infoOpcion[i], 
            x = midW + 65, y = posY + 50,
            width = intW,
            font = fontFamilyLight,   
            fontSize = 28, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		if typeOpcion[i] == "textField" then
			createTextField(item, nameOption[i], posY + 50)
		elseif typeOpcion[i] == "toggleButton" then
			createToggleButtons(item, nameOption[i], posY + 50, intW - 65)
		elseif typeOpcion[i] == "comboBox" then
			createComboBox(item, nameOption[i], posY + 50, 380)
		elseif typeOpcion[i] == "label" then
			lblLabel1 = display.newText({
				text = nameOption[i], 
				x = 390 + 115, y = posY + 50,
				width = 375,
				font = fontFamilyBold,   
				fontSize = 26, align = "right"
			})
			lblLabel1:setFillColor( 0 )
			scrPerfile:insert(lblLabel1)
		end
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 240/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
		
    end
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 240/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	-- crea los elementos de guia de turista
	createTouristGuideItems( item )
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
	-- TextField user name
	textUserName = native.newTextField( 550, posY, 400, 90 )
	textUserName.text = item.userName
	textUserName.hasBackground = false
	textUserName.size = 35
	textUserName:addEventListener( "userInput", userInputProfile )
	grpTextProfile:insert(textUserName)
	
	-- Fecha de nacimiento
    local edad = ""
	if not item.nacimiento then 
        edad = language.MpDateOfBirth
		lblDate = "0000-00-00"
    else 
        edad = item.nacimiento
		lblDate = item.nacimiento
		
		local dates = {}
		dates[1] = 0
		dates[2] = 0
		for Ye, Mi, Da in string.gmatch( edad, "(%w+)-(%w+)-(%w+)" ) do
			local datesArray = {day = Da,month = Mi,year = Ye}
			dates[3] = datesArray
		end
		
		edad = dates[3].day .. "/" .. dates[3].month .. "/" .. dates[3].year
		
    end
	
	local bglblAge = display.newRect( 550, 180, 400, 70 )
	bglblAge:setFillColor( 1 )
	bglblAge.alpha = .02
	scrPerfile:insert(bglblAge)
	bglblAge:addEventListener( 'tap', showDatePicker )
	
    lblAge = display.newText({
        text = edad, 
        x = 550, y = 180,
        width = 400,
        font = fontFamilyRegular, 
        fontSize = 34, align = "left"
    })
    lblAge:setFillColor( 0 )
	lblAge.date = lblDate
    scrPerfile:insert(lblAge)
	-- BG Component
	
	--creamos los componentes generales
	createGeneralItems( item )
	
end

----------------------------------
-- Pinta la imagen de avatar
----------------------------------
function createProfileAvatar()
	tools:setLoading(false,grpLoadMyProfile)
	-- Avatar
	item = itemProfile
    posY = 0
	-- bg
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
    bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	-- Verifica si existe la imagen actual del usuario
	local path = system.pathForFile( item.image, system.TemporaryDirectory )
	local fhd = io.open( path )
	--verifica si existe la imagen
	if fhd then
		fhd:close()
		posY = posY + 150
		grpAvatar = display.newGroup()
		scrPerfile:insert(grpAvatar)
		
		bgA1 = display.newImage( "img/circle-256.png" )
		bgA1.anchorX = 0
		bgA1:translate( 65, posY )
		grpAvatar:insert(bgA1)
		
		maskA = graphics.newMask( "img/image-mask-mask3.png" )
		avatar = display.newImage(item.image, system.TemporaryDirectory)
		avatar:translate( 69, posY)
		avatar.anchorX = 0
		avatar.height = 250
		avatar.width = 250
		avatar.name = item.image
		grpAvatar:insert(avatar)
		avatar:setMask( maskA )
		avatar.maskScaleY = 1.35
		avatar.maskScaleX = 1.35
		
		-- evento para mostrar la imagen full del usuario
		local bgShowPhoto = display.newRoundedRect( midW - 190, posY, 250, 250, 125 )
		bgShowPhoto:setFillColor( 1 )
		bgShowPhoto.alpha = .01
		bgShowPhoto.image = item.image
		grpAvatar:insert(bgShowPhoto)
		bgShowPhoto:addEventListener( 'tap', showAvatar )
		
		-- Permite cambiar la imagen
		local imgChangePhoto = display.newImage("img/gg_camara-01.png")
		imgChangePhoto:translate(midW - 68, 249)
		imgChangePhoto.alpha = .8
		grpAvatar:insert(imgChangePhoto)
		imgChangePhoto:addEventListener( 'tap', optionPictureAvatar )
		
		imgChangePhoto.height = 94
		imgChangePhoto.width = 94
	else
		local items = {}
		items[1] = item
		RestManager.getImagePerfile(items)
	end
	
	posY = posY + 150
	
	local line = display.newLine( 0, posY , intW, posY )
	line:setStrokeColor( 240/255 )
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
			text = language.MpSaveChanges, 
			x = midW, y = posY,
			font = fontFamilyBold,   
			fontSize = 30, align = "center"
		})
		lblSaveProfile:setFillColor( 1 )
		scrPerfile:insert(lblSaveProfile)
    end
	
	scrPerfile:setScrollHeight(posY + 100)

end



---------------------------------------------------------------------------------
-- ScrollView listener
-- Esconde los textField dependiendo de la posicion de ellos en el scroll
---------------------------------------------------------------------------------
function scrListen( event )
	local x, y = scrPerfile:getContentPosition()
	if textUserName  then
		if y < -80 and textUserName.x == 550 then
			textUserName.x = 1000
		elseif y >= -80 and textUserName.x == 1000 then
			textUserName.x = 550
		end
	end
	if textName then
		if y < -408.5 and textName.x == 703 then
			textName.x = intW * 2
		elseif y >= -408.5 and textName.x == intW * 2 then
			textName.x = 703
		end
	end
	if textLastName  then
		if y < -500 and textLastName.x == 703 then
			textLastName.x = intW * 2
		elseif y >= -500 and textLastName.x == intW * 2 then
			textLastName.x = 703
		end
	end
	if textOriginCountry  then
		if y < -700 and textOriginCountry.x == 703 then
			textOriginCountry.x = intW * 2
		elseif y >= -700 and textOriginCountry.x == intW * 2 then
			textOriginCountry.x = 703
		end
	end
	if textUserResidence  then
		if y < -800 and textUserResidence.x == 703 then
			textUserResidence.x = intW * 2
		elseif y >= -800 and textUserResidence.x == intW * 2 then
			textUserResidence.x = 703
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


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

---------------------------------------------
-- Se crea la scena con los datos del perfil
---------------------------------------------
function scene:create( event )
	screen = self.view
	
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
	tools:setLoading(true,grpLoadMyProfile)
	if not itemProfile then
		RestManager.getUsersById("show")
	else
		createProfileAvatar()
	end
	
	tools:toFront()
end	
--------------------------------------------------------
-- Called immediately after scene has moved onscreen:
--------------------------------------------------------
function scene:show( event )
	bubble()
end

---------------------------------------
-- Hide scene
-- destruye los grupos existentes
---------------------------------------
function scene:hide( event )
	native.setKeyboardFocus( nil )
	local phase = event.phase
	if phase == "will" then
		if grpTextProfile then
			grpTextProfile:removeSelf()
			grpTextProfile = nil
		end
		if grpOptionSave then
			grpOptionSave:removeSelf()
			grpOptionSave = nil
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