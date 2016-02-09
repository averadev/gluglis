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

-- Variables
local posY = 350

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
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

----------------------------------------
--- Pinta los datos de otros usuarios
----------------------------------------
function infoProfile( item )

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
	local num = #infoOpcion + 1
	--nombre y apellido
	if item.nombre then
		infoOpcion[num] = item.nombre
		if item.apellidos then
			infoOpcion[num] = infoOpcion[num] .." " .. item.apellidos 
		end
		iconOpcion[num] = 'icoFilterCity'
		num = #infoOpcion + 1
	end
	--genero
	if item.genero then
		infoOpcion[num] = item.genero 
		iconOpcion[num] = 'icoFilterM'
		if item.genero == "Hombre" then
			iconOpcion[num] = 'icoFilterH'
		end
		num = #infoOpcion + 1
	end
	--pais de origen
	if item.paisOrigen then
		infoOpcion[num] = "Es de " .. item.paisOrigen 
		iconOpcion[num] = 'icoFilterCity'
		num = #infoOpcion + 1
	end
	--residencia
	if not item.residencia then 
		infoOpcion[num] = "Ciudad no disponible"
	else
		infoOpcion[num] = "Vive en " .. item.residencia
	end
	iconOpcion[num] = 'icoFilterCity'
	num = #infoOpcion + 1
	--tiempo de residencia
	if item.residencia then
		if item.tiempoResidencia then
			infoOpcion[num] = "Desde hace " .. item.tiempoResidencia 
			iconOpcion[num] = 'icoFilterCity'
			num = #infoOpcion + 1
		end
	end
	if item.emailContacto then
		infoOpcion[num] = item.emailContacto 
		iconOpcion[num] = 'icoFilterCity'
		num = #infoOpcion + 1
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
    end
	
	posY = posY + 75
	
	------- guia turistica -----------
	-- BG Component
	local bgComp1 = display.newRoundedRect( midW, posY, 650, 382, 10 )
	bgComp1.anchorY = 0
	bgComp1:setFillColor( .88 )
	scrPerfile:insert(bgComp1)
	local bgComp2 = display.newRoundedRect( midW, posY, 646, 378, 10 )
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
	--disponibilidad
    if item.diponibilidad and item.diponibilidad == 'Siempre' then
        infoOpcion[1] = 'Disponible'
		iconOpcion[1] = "icoFilterCheckAvailble"
    else 
         infoOpcion[1] = 'No disponible'
		 iconOpcion[1] = "icoFilterUnCheck"
    end
	--alojamiento
	if item.alojamiento and item.alojamiento == 'Sí' then
		infoOpcion[2] = 'Ofrece alojamiento'
		iconOpcion[2] = "icoFilterCheck"
    else 
		infoOpcion[2] = 'No ofrece alojamiento'
		iconOpcion[2] = "icoFilterUnCheck"
    end
	-- transporte
    if item.vehiculo and item.vehiculo == 'Sí' then
        infoOpcion[3] = 'Cuenta con vehiculo propio'
		iconOpcion[3] = "icoFilterCheck"
    else 
        infoOpcion[3] = 'No cuenta con vehiculo propio'
		iconOpcion[3] = "icoFilterUnCheck"
    end
	--comida
    if item.comida and item.comida == 'Sí' then
        infoOpcion[4] = 'Ofrece comida'
		iconOpcion[4] = "icoFilterCheckAvailble"
    else 
         infoOpcion[4] = 'No ofrece comida'
		 iconOpcion[4] = "icoFilterUnCheck"
    end
	
	posY = posY + 45
	
	for i=1, #infoOpcion do
        posY = posY + 75
        
        local ico
        if iconOpcion[i] ~= '' then
           -- print("img/"..opt[i].icon..".png" )
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
    end
	
	posY = posY + 75
	
	------- gustos y preferencias -----------
	-- BG Component
	local bgComp1 = display.newRoundedRect( midW, posY, 650, 382, 10 )
	bgComp1.anchorY = 0
	bgComp1:setFillColor( .88 )
	scrPerfile:insert(bgComp1)
	local bgComp2 = display.newRoundedRect( midW, posY, 646, 378, 10 )
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
	local num = #infoOpcion + 1
	--idioma
	if item.idiomas then
        for i=1, #item.idiomas do
            if i == 1 then
                infoOpcion[num] = item.idiomas[i]
            else
                infoOpcion[num] = infoOpcion[num] ..', '.. item.idiomas[i]
            end
        end
    else
        infoOpcion[num] = 'No cuenta con ningun idioma'
    end
	iconOpcion[num] = 'icoFilterLanguage'
	--nivel de estudio
	if item.nivelEstudio then
		infoOpcion[num] = "Nivel de estudio: " .. item.nivelEstudio
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--formacion profesional
	if item.formacionProfesional then
		infoOpcion[num] = "Formacion profesional: " .. item.formacionProfesional 
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--area laboral
	if item.areaLaboral then
		infoOpcion[num] = "Area laboral: " .. item.areaLaboral 
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--cuenta propia
	if item.cuentaPropia then
		infoOpcion[num] = item.cuentaPropia 
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--mascota
	if item.mascota then
		if item.mascota == "Sí" then
			infoOpcion[num] = "Tiene mascota" 
			if item.tipoMascota then
				infoOpcion[num] = "Tiene " .. item.tipoMascota
			end
		else
			infoOpcion[num] = "No tiene mascota" 
		end
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--deporte
	if item.deporte then
		if item.deporte == "Sí" then
			infoOpcion[num] = "Practica deporte" 
			if item.tipoDeporte then
				infoOpcion[num] = "Practica "
				for i=1, #item.idiomas do
					if i == 1 then
						infoOpcion[num] = infoOpcion[num] .. item.idiomas[i]
					else
						infoOpcion[num] = infoOpcion[num] ..', '.. item.idiomas[i]
					end
				end
			end
		else
			infoOpcion[num] = "No practica ningun deporte" 
		end
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--fumas
	if item.fumas then
		infoOpcion[num] = "Fumas: " .. item.fumas
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--bebes
	if item.bebes then
		infoOpcion[num] = "Bebes: " .. item.bebes
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	--psicotroficos
	if item.psicotropicos then
		infoOpcion[num] = "Psicotropicos: " .. item.psicotropicos
		iconOpcion[num] = 'icoFilterCheck'
		num = #infoOpcion + 1
	end
	
	 -- Options
    posY = posY + 45
	bgComp1.height = (#infoOpcion * 78) + 70
	bgComp2.height = (#infoOpcion * 78) + 66
	for i=1, #infoOpcion do
        posY = posY + 75
        
        local ico
        if iconOpcion[i] ~= '' then
           -- print("img/"..opt[i].icon..".png" )
            ico = display.newImage( "img/"..iconOpcion[i]..".png" )
            ico:translate( 115, posY - 3 )
			scrPerfile:insert(ico)
        end
        local lbl = display.newText({
            text = infoOpcion[i], 
            x = 425, y = posY,
            width = 550,
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
	
	
	infoProfile( item )
	
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
	
	scrPerfile:setScrollHeight(posY + 100)
    
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