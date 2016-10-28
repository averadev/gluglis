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
local fxTap = audio.loadSound( "fx/click.wav")
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, scrMs
local scene = composer.newScene()
--local itemsMessage

-- Variables
local tmpList = {}
local ListChats = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-----------------------------
-- Carga los elementos 
------------------------------
function setItemsListMessages( items )
	for i = 1, #items, 1 do
		tmpList[i] = {id = items[i].idMessage, image = items[i].image, image2 = items[i].image2, name = items[i].display_name, subject = items[i].message, channelId = items[i].channel_id,
			blockMe = items[i].blockMe, blockYour = items[i].blockYour, NoRead = items[i].NoRead, identifier = items[i].identifier, recipientId = items[i].id }
	end
	buildListMsg(100,tmpList)
	tools:setLoading( false,screen )
end

--------------------------------------------------------
-- Muestra una alert cuando no se encuentran mensajes
---------------------------------------------------------
function notListMessages()
	tools:setLoading( false,screen )
	tools:NoMessages( true, scrMs, "No cuenta con mensajes en este momento" )
end

-------------------------------------
--mensaje no hay conexion
-------------------------------------
function noConnectionMessages(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false,screen )
end

-------------------------------------------------
-- Llama a la scena del los mensajes por canal
-------------------------------------------------
function tapMessage(event)
    local t = event.target
    t:setFillColor( 89/255, 31/255, 103/255 )
    timer.performWithDelay(200, function() t:setFillColor( 1 ) end, 1)
    audio.play(fxTap)
    composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = t.item } } )
end

----------------------------------
-- Cambia la posicion del chat
----------------------------------
function movedChat( item, message, numChat )
	local posc = 100
	local thereChannel = false
	for i = 1, #ListChats do
		if ListChats[i].channelId == item.channel_id then
			thereChannel = true
			ListChats[i].y = 100
			local child = ListChats[i]
			child = child[6]
			child.text = message
			createNotBubble( ListChats[i].posc, numChat )
		else
			posc = posc + 160
			ListChats[i].y = posc
		end
	end
	if thereChannel == false then
		local tempList = {}
		tempList[1] = {id = item.idMessage, image = item.image, image2 = item.image2, name = item.display_name, subject = item.message, channelId = item.channel_id,
			blockMe = item.blockMe, blockYour = item.blockYour, NoRead = item.NoRead, identifier = item.identifier}
		buildListMsg(100,tempList)
	end
	return true
end 

------------------------------------------------------------------
-- Crea o destruye las borbujas de numeros de mensajes sin leer
------------------------------------------------------------------
function createNotBubble(poscC, numChat)
	local child = ListChats[poscC]
	if numChat == 0 then
		if child[7] then
			child[8]:removeSelf()
			child[8] = nil
			child[7]:removeSelf()
			child[7] = nil
		end
	else
		if child[8] then
			child[8].text = numChat
		else
			local notBubble = display.newCircle( midW - 60, 0, 25 )
			notBubble:setFillColor(129/255, 61/255, 153/255)
			notBubble.strokeWidth = 2
			notBubble:setStrokeColor(.8)
			ListChats[poscC]:insert(notBubble)
			
			local txtNoBubble = display.newText( {
				x = midW - 60, y = 0,
				text = numChat, font = native.systemFont, fontSize = 26,
			})
			txtNoBubble:setFillColor( 0 )
			ListChats[poscC]:insert(txtNoBubble)
		end
	end
end

---------------------------------
-- Crea la lista de mensajes
---------------------------------
function buildListMsg(posc, item )
    local posY = posc
    for i = 1, #item do
		local poscC = #ListChats + 1
		item[i].posc = poscC
		ListChats[poscC] = display.newContainer( intW, 148 )
        ListChats[poscC].x = midW
        ListChats[poscC].y = posY
		ListChats[poscC].posc = poscC
		ListChats[poscC].channelId = item[i].channelId
        scrMs:insert( ListChats[poscC] )
        -- Bg
        posY = posY + 150
        local bg0 = display.newRect( 0, 0, intW, 148 )
        bg0:setFillColor( .5 )
        bg0.alpha = .05
        ListChats[poscC]:insert(bg0)
        local bg = display.newRect( 0, 0, intW, 140 )
        bg:setFillColor( 1 )
        bg.item = item[i]
        bg:addEventListener( 'tap', tapMessage)
        ListChats[poscC]:insert(bg)
        -- Image
        local avatar = display.newImage( item[i].image, system.TemporaryDirectory )
        avatar:translate(-294, 0)
        avatar.width = 130
        avatar.height = 130
        ListChats[poscC]:insert( avatar )
        
        local maskMA = display.newImage("img/maskCircle130.png")
        maskMA:translate(-294, 0)
        ListChats[poscC]:insert( maskMA )
        -- Name
        local lblName = display.newText({
            text = item[i].name,     
            x = 100, y = - 20,
            width = 600,
            font = native.systemFontBold,   
            fontSize = 35, align = "left"
        })
        lblName:setFillColor( 0 )
        ListChats[poscC]:insert(lblName)
        -- Subject
		local subject = item[i].subject
		--print(#item[i].subject)
		if ( #item[i].subject > 75 ) then
			subject = subject:sub( 1,75 ) .. "..."
		end
        local lblSubject = display.newText({
            text = subject,     
            x = 90, y = 45,
            width = 580, height = 80,
            font = fontFamilyLight,   
            fontSize = 25, align = "left"
        })
        lblSubject:setFillColor( .3 )
        ListChats[poscC]:insert(lblSubject)
		
		if  item[i].NoRead ~= '0' then
			local notBubble = display.newCircle( midW - 60, 0, 25 )
			notBubble:setFillColor(129/255, 61/255, 153/255)
			notBubble.strokeWidth = 2
			notBubble:setStrokeColor(.8)
			ListChats[poscC]:insert(notBubble)
			
			local txtNoBubble = display.newText( {
				x = midW - 60, y = 0,
				text = item[i].NoRead, font = native.systemFont, fontSize = 26,
			})
			txtNoBubble:setFillColor( 0 )
			--txtNoBubble:toFront()
			ListChats[poscC]:insert(txtNoBubble)
		end
    end
	scrMs:setScrollHeight(posY + 100)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
	--background
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 0 )
	o:setFillColor( 245/255 )
	screen:insert(o)
	--toolbar
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)   
	tools:setLoading( true,screen )
    --scrollView
	scrMs = widget.newScrollView
    {
        top = 150,
        left = 0,
        width = intW,
        height = intH - 150,
        scrollWidth = 600,
        scrollHeight = 800,
		hideBackground = true,
    }
    screen:insert(scrMs)
	--bloquea el chat si el usuario no esta loqueado
	if isReadOnly then
		
		local iconReadOnly = display.newImage( "img/lock.png" )
		iconReadOnly:translate( 384, midH - 350)
        iconReadOnly.alpha = .5
		scrMs:insert(iconReadOnly)

		local lblReadOnly = display.newText( {
			text = "CONSULTA AQUI LA LISTA DE TODAS LAS PERSONAS QUE QUIEREN CONTACTAR CONTIGO.",     
			x = midW, y = midH - 150, width = 600,
			font = "Lato-Regular", fontSize = 26, align = "center"
		})
		lblReadOnly:setFillColor( 85/255, 85/255, 85/255 )
		scrMs:insert(lblReadOnly)
        
        local rctFree = display.newRoundedRect( midW, midH, 350, 100, 5 )
        rctFree:setFillColor( .2, .6 ,0 )
		rctFree.screen = "LoginSplash"
        rctFree:addEventListener( 'tap', toScreen)
        scrMs:insert(rctFree)
        
        local lblSign = display.newText( {
			text = "¡Registrate ahora!",     
			x = midW, y = midH, width = 600,
			fontSize = 36, align = "center"
		})
		lblSign:setFillColor( 1 )
		scrMs:insert(lblSign)
		
		tools:setLoading( false, screen )
		
	else
		--muestra los mensajes
		RestManager.getListMessageChat()
	end
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide scene
function scene:hide( event )
	tools:noConnection( false, screen, "" )
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene