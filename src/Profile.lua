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
local composer = require( "composer" )
RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function method()
    
end

--inicia un nuevo chats
function startConversation( event )
	RestManager.startConversation(event.target.id)
	return true
end

--crea la informacion e inicia la conversacion(chats)
function showNewConversation(item)
	local tmpList = {id = 0, photo = "mariana.jpeg", name = item.display_name, subject = "", channelId = item.channel_id,
			blockMe = item.blockMe, blockYour = item.blockYour, NoRead = 0}
	composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = tmpList } } )
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	local item = event.params.item
	screen = self.view
    screen.y = h
    
    local o = display.newRoundedRect( midW, midH + 30, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)   
    
    -- Avatar
    local bgA1 = display.newRoundedRect( midW - 190, 290, 270, 270, 10 )
    bgA1:setFillColor( 11/225, 163/225, 212/225 )
    screen:insert(bgA1)
    
    local bgA2 = display.newRect( midW - 190, 290, 240, 240 )
    bgA2:setFillColor( 0, 193/225, 1 )
    screen:insert(bgA2)
    
   -- local avatar = display.newImage("img/tmp/face01.png") item
   local avatar = display.newImage(item.image, system.TemporaryDirectory)
    avatar:translate(midW - 190, 290)
    avatar.height = 230
    avatar.width = 230
    screen:insert(avatar)
    
    -- Personal data
    local lblName = display.newText({
        text = item.userName, 
        x = 550, y = 300,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 35, align = "left"
    })
    lblName:setFillColor( 0 )
    screen:insert(lblName)
	if not item.edad then item.edad = "" else item.edad = item.edad .. " Años" end
    local lblAge= display.newText({
        text = item.edad, 
        x = 550, y = 350,
        width = 400,
        font = native.systemFont, 
        fontSize = 35, align = "left"
    })
    lblAge:setFillColor( 0 )
    screen:insert(lblAge)
    local lblInts = display.newText({
        text = "", 
        x = 550, y = 400,
        width = 400,
        font = native.systemFont, 
        fontSize = 25, align = "left"
    })
    lblInts:setFillColor( 0 )
    screen:insert(lblInts)
	
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
    
    -- Position
    local posY = 460
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY, 650, 460, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY, 646, 456, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY, 650, 70, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( .93 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, 650, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( .93 )
    screen:insert(bgTitleX)
    local lblTitle = display.newText({
        text = "DETALLE:", 
        x = 310, y = posY+35,
        width = 400,
        font = native.systemFontBold,   
        fontSize = 25, align = "left"
    })
    lblTitle:setFillColor( 0 )
    screen:insert(lblTitle)
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
            print("img/"..opt[i].icon..".png" )
            ico = display.newImage( screen, "img/"..opt[i].icon..".png" )
            ico:translate( 115, posY - 3 )
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
    end
    
    -- Search Button
    posY = posY + 110
    local btnActividad = display.newRoundedRect( midW, posY, 650, 80, 10 )
    btnActividad:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    screen:insert(btnActividad)
    local lblActividad = display.newText({
        text = "VER ACTIVIDAD", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblActividad:setFillColor( 1 )
    screen:insert(lblActividad)
    
    -- Search Button
    posY = posY + 100
    local btnResenias = display.newRoundedRect( midW, posY, 650, 80, 10 )
    btnResenias:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    screen:insert(btnResenias)
    local lblResenias = display.newText({
        text = "VER RESEÑAS", 
        x = midW, y = posY,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    lblResenias:setFillColor( 1 )
    screen:insert(lblResenias)
	
	if item.isMe == false then
		-- Btn Iniciar conversación
		posY = posY + 100
		local btnStartChat = display.newRoundedRect( midW, posY, 650, 80, 10 )
		btnStartChat.id = item.id
		btnStartChat:setFillColor( {
			type = 'gradient',
			color1 = { 129/255, 61/255, 153/255 }, 
			color2 = { 89/255, 31/255, 103/255 },
			direction = "bottom"
		} )
		screen:insert(btnStartChat)
		btnStartChat:addEventListener( 'tap', startConversation)
		local lblStartChat = display.newText({
			text = "INICIAR CONVERSACIÓN", 
			x = midW, y = posY,
			font = native.systemFontBold,   
			fontSize = 25, align = "center"
		})
		lblStartChat:setFillColor( 1 )
		screen:insert(lblStartChat)
	end
    
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