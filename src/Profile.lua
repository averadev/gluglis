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
local composer = require( "composer" )
local json = require("json")
RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local scrPerfile, scrElements

-- Variables
local posY = 350

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

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
	tools:setLoading(true,screen)
	RestManager.startConversation(event.target.id)
	return true
end

----------------------------------------------------------
-- crea la informacion e inicia la conversacion(chats)
-- @param item informacion del perfil
----------------------------------------------------------
function showNewConversation(item)
	tools:setLoading(false,screen)
	local tmpList = {id = 0, image = item.image, image2 = item.image2, name = item.display_name, subject = "", channelId = item.channel_id,
		blockMe = item.blockMe, blockYour = item.blockYour, NoRead = 0, identifier = item.identifier, recipientId = item.id}
	composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = tmpList } } )
end

------------------------------------------------------------------------------
-- Pinta la imagen del usuario en caso de no encontrarse al crear la scena
-- @param item nombre de la imagen
------------------------------------------------------------------------------
function setImagePerfil( item )
	local mask = graphics.newMask( "img/image-mask-mask3.png" )
	local avatar = display.newImage(item.image, system.TemporaryDirectory)
	avatar:translate( 69.5, posY)
	avatar.anchorX = 0
	avatar.height = 250
	avatar.width = 250
	scrPerfile:insert(avatar)
	avatar:setMask( mask )
	avatar.maskScaleY = 1.35
	avatar.maskScaleX = 1.35
end

-----------------------------------------
--- Pinta los datos de otros usuarios
-- @param item informacion del perfil
-----------------------------------------
function infoProfile( item )
	posY = 80
	-- informacion personal
    local lblName = display.newText({
        text = item.userName, 
        x = 550, y = posY,
        width = 400,
        font = fontFamilyBold,   
        fontSize = 38, align = "left"
    })
    lblName:setFillColor( 0 )
    scrPerfile:insert(lblName)
	
	posY = posY + 50
	-- Edad
	local edad = ""
	if not item.edad then edad = "" else edad = item.edad .. language.PYears end
    local lblAge= display.newText({
        text = edad, 
        x = 550, y = posY,
        width = 400,
        font = fontFamilyBold, 
        fontSize = 33, align = "left"
    })
    lblAge:setFillColor( 0 )
    scrPerfile:insert(lblAge)
	
	posY = posY + 45
	-- Genero
	if item.genero then
		local lblGender= display.newText({
			text = item.genero, 
			x = 550, y = posY,
			width = 400,
			font = fontFamilyRegular, 
			fontSize = 25, align = "left"
		})
		lblGender:setFillColor( 0 )
		scrPerfile:insert(lblGender)
	end
	
	posY = posY + 55
	
	-- Residencia
	local Residence = ""
	if not item.residencia then 
		Residence = language.PCityNotAvailable
	else
		Residence = language.PILiveIn .. item.residencia
	end

	local lblResidence = display.newText({
		text = Residence, 
		x = 550, y = posY,
		width = 400,
		font = fontFamilyRegular, 
		fontSize = 25, align = "left"
	})
	lblResidence:setFillColor( 0 )
	scrPerfile:insert(lblResidence)
	
	posY = 350
	
	local iconOpcion = {}
	local infoOpcion = {}
	
	--------Generales-----------
	
	local line0 = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line0:setStrokeColor( 227/255 )
	line0.strokeWidth = 3
	scrPerfile:insert(line0)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	-- Elimina los espacios en blanco al final y al inicio
	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
	
	local num = #infoOpcion + 1
	--nombre y apellido
	if item.nombre then
		local nameTxt = trimString(item.nombre)
		if #nameTxt > 0 then
			infoOpcion[num] = item.nombre
			if item.apellidos then
				infoOpcion[num] = infoOpcion[num] .." " .. item.apellidos 
			end
			if infoOpcion[num] == " " then infoOpcion[num] = language.PUnknown end
			iconOpcion[num] = 'GG_Generico'
			num = #infoOpcion + 1
		end
	end
	
	--pais de origen
	if item.paisOrigen then
		local CountryTxt = trimString(item.paisOrigen)
		if #CountryTxt > 0 then
			infoOpcion[num] = language.PIAmFrom .. item.paisOrigen 
			iconOpcion[num] = 'GG_Generico'
			num = #infoOpcion + 1
		end
	end
	
	--tiempo de residencia
	if item.residencia then
		local residentTxt = trimString(item.residencia)
		if #residentTxt > 0 then
			if item.tiempoResidencia and item.tiempoResidencia ~= "" then
				infoOpcion[num] = language.PSince .. item.tiempoResidencia 
				iconOpcion[num] = 'GG_Generico'
				num = #infoOpcion + 1
			end
		end
	end
	
	for i=1, #infoOpcion do
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico.anchorX = 0
            ico:translate( 65, posY + 50 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = 340, y = posY + 50,
            width = 400,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	if bgA0.height == 0 then
		line.alpha = 0
		line0.alpha = 0
	else
		posY = posY + 50
	end
	
	------- guia turistica -----------
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	local iconOpcion = {}
	local labelOpcion = {}
	local infoOpcion = {}
	--alojamiento
	local num = #infoOpcion + 1
	labelOpcion[num] = language.POffersAccommodation
	if item.alojamiento and item.alojamiento == 'Sí' then
		infoOpcion[num] = language.PYes
		iconOpcion[num] = "GG_Generico"
    else 
		infoOpcion[num] = language.PNo
		iconOpcion[num] = "GG_Generico"
    end
	num = num + 1
	-- transporte
	labelOpcion[num] = language.PCar
    if item.vehiculo and item.vehiculo == 'Sí' then
    	infoOpcion[num] = language.PYes
		iconOpcion[num] = "GG_Generico"
    else 
		infoOpcion[num] = language.PNo
		iconOpcion[num] = "GG_Generico"
    end
	num = num + 1
	--comida
	labelOpcion[num] = language.PFood
	if item.comida and item.comida == 'Sí' then
    	infoOpcion[num] = language.PYes
		iconOpcion[num] = "GG_Generico"
    else 
		infoOpcion[num] = language.PNo
		iconOpcion[num] = "GG_Generico"
    end
	
	for i=1, #infoOpcion do
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico.anchorX = 0
            ico:translate( 65, posY + 50 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = labelOpcion[i], 
            x = 340, y = posY + 50,
            width = 400,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		local lbl1 = display.newText({
            text = infoOpcion[i], 
            x = midW - 65, y = posY + 50,
            width = intW,
            font = fontFamilyBold,   
            fontSize = 22, align = "right"
        })
        lbl1:setFillColor( 0 )
        scrPerfile:insert(lbl1)
		
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
    end
	
	bgA0.height = #infoOpcion * 100
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	
	------- gustos y preferencias -----------
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	local bgA0 = display.newRect( midW, posY, intW, 300 )
	bgA0.anchorY = 0
	bgA0:setFillColor( 1 )
    scrPerfile:insert(bgA0)
	
	local iconOpcion = {}
	local labelOpcion = {}
	local infoOpcion = {}
	
	local num = #infoOpcion + 1
	--idioma
	if item.idiomas then
        for i=1, #item.idiomas do
            if i == 1 then
                infoOpcion[num] = item.idiomas[i]
            else
                infoOpcion[num] = infoOpcion[num] ..', '.. item.idiomas[i]
            end
			iconOpcion[num] = 'GG_Generico'
        end
    else
        infoOpcion[num] = language.PAny
		iconOpcion[num] = 'GG_Generico'
    end
	labelOpcion[num] = language.PLanguages
	num = #infoOpcion + 1
	
	--hobbies
	if item.hobbies then
		local hob = ""
        local max = 4
        if #item.hobbies < max then 
            max = #item.hobbies 
        end
        for i=1, max do
            if i == 1 then
                hob = item.hobbies[i]
            else
                hob = hob ..', '..item.hobbies[i]
            end
        end
        if #item.hobbies > max then 
            hob = hob ..'...'
        end
		infoOpcion[num] = hob
		iconOpcion[num] = 'GG_Generico'
    else
        infoOpcion[num] = language.PAny
		iconOpcion[num] = 'GG_Generico'
    end
	labelOpcion[num] = language.PHobbies
	num = #infoOpcion + 1
	
	--nivel de estudio
	if item.nivelEstudio then
		labelOpcion[num] = language.PLevelOfEducation
		infoOpcion[num] = item.nivelEstudio
		iconOpcion[num] = 'GG_Generico'
		num = #infoOpcion + 1
	end
	--formacion profesional
	if item.formacionProfesional then
		labelOpcion[num] = language.PProfessionalTraining
		infoOpcion[num] = item.formacionProfesional
		iconOpcion[num] = 'GG_Generico'
		num = #infoOpcion + 1
	end
	--area laboral
	
	if item.areaLaboral then
		labelOpcion[num] = language.PWorkingArea
		infoOpcion[num] = item.areaLaboral 
		iconOpcion[num] = 'GG_Generico'
		num = #infoOpcion + 1
	end
	
	--cuenta propia
	labelOpcion[num] = language.PFreelance
	if item.cuentaPropia then
        for i=1, #item.cuentaPropia do
            if i == 1 then
				if item.cuentaPropia[i] == "Por cuenta propia" then
					infoOpcion[num] = language.PFreelance
				else
					infoOpcion[num] = language.PEmployee
				end
            end
        end
		iconOpcion[num] = 'GG_Generico'
    else
        infoOpcion[num] = language.PEmployee
		iconOpcion[num] = 'GG_Generico'
    end
	num = #infoOpcion + 1
	
	--mascota
	if item.mascota then
		labelOpcion[num] = language.PPets 
		if item.mascota == "Sí" then
			infoOpcion[num] = "Si" 
			if item.tipoMascota then
				infoOpcion[num] = language.PHas  .. item.tipoMascota
			end
			iconOpcion[num] = 'GG_Generico'
		else
			infoOpcion[num] = "No" 
			iconOpcion[num] = 'GG_Generico'
		end
		num = #infoOpcion + 1
	end
	
	--deportes
	if item.deportes then
		local hob = ""
        local max = 4
        if #item.deportes < max then 
            max = #item.deportes 
        end
        for i=1, max do
            if i == 1 then
                hob = item.deportes[i]
            else
                hob = hob ..', '..item.deportes[i]
            end
        end
        if #item.deportes > max then 
            hob = hob ..'...'
        end
		infoOpcion[num] = hob
		iconOpcion[num] = 'GG_Generico'
    else
        infoOpcion[num] = language.PAny
		iconOpcion[num] = 'GG_Generico'
    end
	labelOpcion[num] = language.PSports 
	num = #infoOpcion + 1
	
	--fumas
	if item.fumas then
		iconOpcion[num] = 'GG_Generico'
		labelOpcion[num] = language.PYouSmoke 
		if item.fumas == "No" then
			infoOpcion[num] = language.PNo 
		else
			infoOpcion[num] = language.PYes 
		end
		num = #infoOpcion + 1
	end
	
	--bebes
	if item.bebes then
		labelOpcion[num] = language.PYouDrinkAlcohol
		if item.bebes == "No" then
			iconOpcion[num] = 'GG_Generico'
			infoOpcion[num] = language.PNo 
		else
			iconOpcion[num] = 'GG_Generico'
			infoOpcion[num] = language.PYes
		end
		num = #infoOpcion + 1
	end
	
	--psicotroficos
	if item.psicotropicos then
		labelOpcion[num] = language.PYouPsychotropicDrugs
		if item.psicotropicos == "No" then
			iconOpcion[num] = 'GG_Generico'
			infoOpcion[num] = language.PNo
		else
			iconOpcion[num] = 'GG_Generico'
			infoOpcion[num] = language.PYes
		end
		num = #infoOpcion + 1
	end
	
	--pinta las opciones
	for i=1, #infoOpcion do
        local ico
        if iconOpcion[i] ~= '' then
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico.anchorX = 0
            ico:translate( 65, posY + 50 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = labelOpcion[i], 
            x = 340, y = posY + 50,
            width = 400,
            font = fontFamilyLight,   
            fontSize = 22, align = "left"
        })
        lbl:setFillColor( 0 )
        scrPerfile:insert(lbl)
		
		local lbl1 = display.newText({
            text = infoOpcion[i], 
            x = midW + 185 - 65, y = posY + 50,
            width = 400,
            font = fontFamilyBold,   
            fontSize = 22, align = "right"
        })
        lbl1:setFillColor( 0 )
        scrPerfile:insert(lbl1)
		posY = posY + 100
		
		local line = display.newLine( 0, posY, intW, posY )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 2
		scrPerfile:insert(line)
    end
	bgA0.height = #infoOpcion * 100
	local line = display.newLine( 0, posY - 1 , intW, posY + 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	scrPerfile:insert(line)
	
	posY = posY + 50
	return posY
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
	
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 0 )
	o:setFillColor( 245/255 )
    screen:insert(o)
	o:addEventListener( 'tap', closeAll )
	
	--tools
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)

	--scrollview
	scrPerfile = widget.newScrollView({
        top = 93 + h,
        left = 0,
        width = intW,
        height = intH-(100+h),
        hideBackground = true,
		horizontalScrollDisabled = true,
    })
	screen:insert(scrPerfile)
	
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
		avatar:translate( 69.5, posY)
		avatar.anchorX = 0
		avatar.height = 250
		avatar.width = 250
		scrPerfile:insert(avatar)
		avatar:setMask( mask )
		avatar.maskScaleY = 1.35
		avatar.maskScaleX = 1.35
	-- si no la descarga
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
	
	posY = infoProfile( item )
	
	if isReadOnly then
		posY = posY + 120
		local lblReadOnly = display.newText( {
			text = language.PLikeToStart .. item.userName .. "?",     
			x = midW, y = posY, width = 600,
			font = fontFamilyLight, fontSize = 26, align = "center"
		})
		lblReadOnly:setFillColor( 85/255, 85/255, 85/255 )
		scrPerfile:insert(lblReadOnly)
			
		posY = posY + 100
        
		local rctFree = display.newRect( midW, posY, intW, 120 )
		rctFree:setFillColor( 0/255, 174/255, 239/255 )
		rctFree.screen = "LoginSplash"
		rctFree:addEventListener( 'tap', toScreen)
		scrPerfile:insert(rctFree)
        
		local lblSign = display.newText( {
			text = language.PSignUpNow,     
			x = midW, y = posY, width = 600,
			font = fontFamilyBold, fontSize = 32, align = "center"
		})
		lblSign:setFillColor( 1 )
		scrPerfile:insert(lblSign)
	else
		-- Btn Iniciar conversación
		posY = posY + 120
		local btnStartChat = display.newRect( midW, posY, intW, 120 )
		btnStartChat.id = item.id
		btnStartChat:setFillColor( 0/255, 174/255, 239/255 )
		scrPerfile:insert(btnStartChat)
		btnStartChat:addEventListener( 'tap', startConversation)
		local lblStartChat = display.newText({
			text = language.pConversationWith,
			x = midW, y = posY,
			font = fontFamilyBold,   
			fontSize = 25, align = "center"
		})
		lblStartChat:setFillColor( 1 )
		scrPerfile:insert(lblStartChat)
	end
	
	scrPerfile:setScrollHeight(posY + 100)
	
	tools:toFront()
    
end	
--------------------------------------------------------
-- Called immediately after scene has moved onscreen:
--------------------------------------------------------
function scene:show( event )
	bubble()
end
----------------
-- Hide scene
----------------
function scene:hide( event )
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