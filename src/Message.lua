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
local screen, scrChat
local scene = composer.newScene()
local noMessage, noConectionMSG

-- Variables
local h = display.topStatusBarContentHeight


--[[local tmpList = {
    {date = "10 de Noviembre del 2015"},
    {isMe = false, message = "Hola soy de Bogota, pronte ire de vacaciones y me gustaria conocer gente del lugar para salir y conocer el sitio.", time = "4:32 PM"},
    {isMe = true, message = "Hola claro que si, cuando tienes pensado venir a Cancun?", time = "4:36 PM"},
    {isMe = false, message = "El 15 de diciembre estare llegando, estare 4 dias en tu ciudad y despues ira a Chiapas.", time = "4:37 PM"}, 
    {isMe = true, message = "Perfecto!, podemos organizar algo, algunos amigos en esas fechas organizan posadas, talvez podamos ir a alguna", time = "4:37 PM"},
    {isMe = false, message = "Me encantaria, nos ponemos deacuerdo ok?", time = "4:38 PM"},
    {isMe = true, message = "Claro que si, estamos al pendiente ;)", time = "4:40 PM"},
    
    {date = "11 de Noviembre del 2015"},
    {isMe = false, message = "Hola Richi, aun no resuelvo el hospedaje, conoceras algun hotel economico?", time = "2:11 PM"},
    {isMe = true, message = "Hola, si hay varias opciones economicas e interesantes", time = "2:12 PM"},
    {isMe = true, message = "En otras ocaciones cuando vienen amigos suelen hospedarse en el EcoBoutique Uay Balam, maneja cosotos razonables y la atención es muy buena", time = "2:15 PM"},
    {isMe = false, message = "Perfecto hablare para solicitar información", time = "2:15 PM"},
    {isMe = true, message = "Claro, si tienes alguna duda, o necesitas algo no dudes en contactarme", time = "2:16 PM"},
    {isMe = false, message = "Ok!, muchas gracias :)", time = "2:16 PM"},
}]]

local tmpList = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setItemsMessages( items )

	--print(tmpList[10].message)
	
	for i = 1, #items, 1 do
		local item = items[i]
		local poscI = #tmpList + 1
		if item.changeDate == 1 then
			tmpList[poscI] = {date = item.fechaFormat}
			poscI = poscI + 1
		end
		tmpList[poscI] = {isMe = item.isMe, message = item.message, time = item.hora} 
	end
	buildChat()
	
end

function notChatsMessages()
	tools:setLoading( false,screen )
	noMessage = display.newGroup()
	scrChat:insert(noMessage)
	
	local titleNoMessages = display.newText({
		text = "No cuenta con mensajes en este momento",     
		x = midW, y = midH - 250,
		font = native.systemFont, width = intW - 50, 
		fontSize = 34, align = "center"
	})
	titleNoMessages:setFillColor( 0 )
	noMessage:insert( titleNoMessages )
	
    local btnNewMessage = display.newRoundedRect( midW, 100, 650, 100, 10 )
    btnNewMessage:setFillColor( {
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    } )
    noMessage:insert(btnNewMessage)
	btnNewMessage.alpha = .5
	
	local lblNewMessage = display.newText({
        text = "Bloquear", 
        x = midW, y = 100,
        font = native.systemFontBold,   
        fontSize = 34, align = "center"
    })
    lblNewMessage:setFillColor( 1 )
    noMessage:insert(lblNewMessage)
	
end

function noConnectionMessage(message)
	
	if noConectionMSG then
		noConectionMSG:removeSelf()
		noConectionMSG = nil
	end

	tools:setLoading( false,screen )
	noConectionMSG = display.newGroup()
	screen:insert(noConectionMSG)
	
	local bgNoConection = display.newRect( midW, 45 + h, display.contentWidth, 80 )
    bgNoConection:setFillColor( 236/255, 151/255, 31/255, .7 )
    noConectionMSG:insert(bgNoConection)
	
	local lblNoConection = display.newText({
        text = message, 
        x = midW, y = 45 + h,
        font = native.systemFont,   
        fontSize = 34, align = "center"
    })
    lblNoConection:setFillColor( 1 )
    noConectionMSG:insert(lblNoConection)
	
	
end

function toBack()
    audio.play(fxTap)
    composer.gotoScene( "src.Messages", { time = 400, effect = "slideRight" } )
end

function buildChat()
    local posY = 30
    for z = 1, #tmpList do
        local i = tmpList[z]
        if i.date then
            local bgDate = display.newRoundedRect( midW, posY, 300, 40, 20 )
            bgDate.anchorY = 0
            bgDate:setFillColor( 220/255, 186/255, 218/255 )
            scrChat:insert(bgDate)
            
            local lblDate = display.newText({
                text = i.date,     
                x = midW, y = posY + 20,
                font = native.systemFont,   
                fontSize = 20, align = "center"
            })
            lblDate:setFillColor( .1 )
            scrChat:insert(lblDate)
            
            posY = posY + 70
        else
            
            local bgM0 = display.newRoundedRect( 20, posY, 502, 51, 10 )
            bgM0.anchorX = 0
            bgM0.anchorY = 0
            bgM0.alpha = .2
            bgM0:setFillColor( .3 )
            scrChat:insert(bgM0)
            
            local bgM = display.newRoundedRect( 20, posY, 500, 50, 10 )
            bgM.anchorX = 0
            bgM.anchorY = 0
            bgM:setFillColor( 1 )
			--bgM:setFillColor( .5 )
            scrChat:insert(bgM)
            
            local lblM = display.newText({
                text = i.message,     
                x = 40, y = posY + 10,
                font = native.systemFont,   
                fontSize = 20, align = "left"
            })
            lblM.anchorX = 0
            lblM.anchorY = 0
            lblM:setFillColor( .1 )
            scrChat:insert(lblM)
            
            if lblM.contentWidth > 450 then
                lblM:removeSelf()
                
                lblM = display.newText({
                    text = i.message, 
                    width = 450,
                    x = 40, y = posY + 10,
                    font = native.systemFont,   
                    fontSize = 20, align = "left"
                })
                lblM.anchorX = 0
                lblM.anchorY = 0
                lblM:setFillColor( .1 )
                scrChat:insert(lblM)
                
                if i.isMe then
                    lblM.x = 270
                end
                
                bgM.height = lblM.contentHeight + 30
                bgM0.height = lblM.contentHeight + 31
            else
                bgM.width = lblM.contentWidth + 40
                bgM0.width = lblM.contentWidth + 42
                lblM.anchorX = 0
                if i.isMe then
                    lblM.anchorX = 1
                    lblM.x = intW - 40
                end
            end
            
            local lblTime = display.newText({
                text = i.time,
                x = lblM.x, y = posY + lblM.contentHeight + 15,
                font = native.systemFont,   
                fontSize = 12, align = "left"
            })
            lblTime.anchorX = lblM.anchorX
            lblTime:setFillColor( .5 )
            scrChat:insert(lblTime)
            if lblM.anchorX == 1 then
                lblTime.anchorX = 0
                lblTime.x = intW - bgM.width
            end
            
            if i.isMe then
                bgM0.x = intW - 20
                bgM.x = intW - 20
                bgM0.anchorX = 1
                bgM.anchorX = 1
                bgM0.alpha = .3
                bgM:setFillColor( 178/255, 255/255, 178/255 )
            end
            
            posY = posY + bgM.height + 30
            if z < #tmpList then
                if tmpList[z+1].isMe == i.isMe then 
                    posY = posY - 20
                end
            end
        end
    end
    local point = display.newRect( 1, posY + 30, 1, 1 )
    scrChat:insert(point)
	print(scrChat.height)
	if scrChat.height <= posY + 30 then
		scrChat:scrollTo( "bottom", { time=0 } )
	end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
    local item = event.params.item
	screen = self.view
    screen.y = h
    print("h:"..h)
    
    local o = display.newRoundedRect( midW, midH + 30, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	    
    local bgH = display.newRoundedRect( midW, 40 + 30, display.contentWidth, 80, 20 )
    bgH:setFillColor( .95 )
    screen:insert(bgH)
    local bgH2 = display.newRect( midW, 100, display.contentWidth, 60 )
    bgH2:setFillColor( .95 )
    screen:insert(bgH2)
    
    -- Back button
    local btnBack = display.newImage("img/icoBack.png")
    btnBack:translate(50, 75)
    btnBack:addEventListener( 'tap', toBack)
    screen:insert( btnBack )

    -- Image
    local avatar = display.newImage("img/tmp/"..item.photo)
    avatar:translate(150, 75)
    avatar.width = 80
    avatar.height = 80
    screen:insert( avatar )
    local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
    avatar:setMask( maskCircle80 )
    
    -- Name
    local lblName = display.newText({
        text = item.name,     
        x = midW + 130, y = 75,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( .3 )
    screen:insert(lblName)
    
    scrChat = widget.newScrollView
    {
        top = 120,
        left = 0,
        width = intW,
        height = intH - 210,
        scrollWidth = 600,
        scrollHeight = 800,
        --hideBackground = true	
		backgroundColor = { 0.8, 0.8, 0.8 }
    }
	
    screen:insert(scrChat)   
    
    local bgM0 = display.newRoundedRect( midW, intH - 45, intW - 35, 75, 10 )
    bgM0:setFillColor( .8 )
    screen:insert(bgM0)

    local bgM = display.newRoundedRect( midW, intH - 45, intW - 40, 70, 10 )
    bgM:setFillColor( 1 )
    screen:insert(bgM)
    
    local icoSend = display.newImage("img/icoSend.png")
    icoSend:translate(intW - 60, intH - 45)
    screen:insert(icoSend)
	
	txtMessage = native.newTextField( midW - 35, intH - 45, intW - 140, 70 )
    --txtMessage.method = "signin"
    txtMessage.inputType = "default"
    txtMessage.hasBackground = false
    --txtMessage:addEventListener( "userInput", onTxtFocus )
	screen:insert( txtMessage )
	
	RestManager.getChatMessages(item.channelId);
    
    --buildChat()
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