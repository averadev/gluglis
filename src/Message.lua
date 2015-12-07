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
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, scrChat
local scene = composer.newScene()
local grpChat

-- Variables
local h = display.topStatusBarContentHeight
local txtMessage
local posY 
local lblDateTemp = {}
local lastDate = ""
local tmpList = {}
local scrChatY
local scrChatH
local btn1 = 1

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setItemsMessages( items )
	
	for i = 1, #items, 1 do
		local item = items[i]
		local poscI = #tmpList + 1
		if item.changeDate == 1 then
			tmpList[poscI] = {date = item.fechaFormat, dateOnly = item.dateOnly}
			poscI = poscI + 1
		end
		tmpList[poscI] = {isMe = item.isMe, message = item.message, time = item.hora} 
	end
	buildChat(0)
end

--mensaje no hay mensaje
function notChatsMessages()
	tools:setLoading( false,screen )
	tools:NoMessages( true, scrChat, "No cuenta con mensajes en este momento" )
end

--mensaje de no hay conexion
function noConnectionMessage(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false,screen )	
end

--envia el mensaje
function sentMessage()
	
	local fieldOffset, fieldTrans
	fieldOffset = intH/3
	if string.sub(system.getInfo("model"),1,4) == "iPad" then
		--fieldOffset = intH/4
	end
	fieldTrans = 200
	
	--[[if btn1 == 1 then
		scrChat.height = scrChatH - fieldOffset
		transition.to( scrChat, { time=fieldTrans, y=(scrChat.height - 215)} )
		btn1 = 0
	else
		scrChat.height = scrChatH - fieldOffset
		transition.to( scrChat, { time=fieldTrans, y=(scrChat.height - 215)} )
	end]]
	
	if txtMessage.text ~= "" then
		local dateM = RestManager.getDate()
		local poscD = #lblDateTemp + 1
		--displaysInList("quivole carnal", poscD, dateM[2])
		displaysInList(txtMessage.text, poscD, dateM[2])
		RestManager.sendChat( txtMessage.channelId, txtMessage.text, poscD, dateM[1] )
		--RestManager.sendChat(txtMessage.channelId, "quivole carnal", poscC, dateM[1])
		
		--scrChat:setScrollHeight( posY + fieldOffset )
		--grpChat.y = 225
	end
	return true
end

function displaysInList(message, poscD, dateM2)

	tmpList = nil
	tmpList = {}
	tmpList[1] = {isMe = true, message = message , time = "cargando"}

	if lastDate ~= dateM2 then
		
		local bgDate = display.newRoundedRect( midW, posY, 300, 40, 20 )
		bgDate.anchorY = 0
		bgDate:setFillColor( 220/255, 186/255, 218/255 )
		scrChat:insert(bgDate)
            
		local lblDate = display.newText({
			text = dateM2,     
			x = midW, y = posY + 20,
			font = native.systemFont,   
			fontSize = 20, align = "center"
		})
		lblDate:setFillColor( .1 )
		scrChat:insert(lblDate)
            
		posY = posY + 70
		
		lastDate = dateM2
	end
	
	buildChat(poscD)
	
end

function changeDateOfMSG(item, poscD)
	lblDateTemp[poscD].text = item.hora
end

function toBack()
    audio.play(fxTap)
    composer.gotoScene( "src.Messages", { time = 400, effect = "slideRight" } )
end

function onTxtFocus( event )

	local fieldOffset, fieldTrans
	fieldOffset = intH/3
	if string.sub(system.getInfo("model"),1,4) == "iPad" then
		--fieldOffset = intH/4
	end
	fieldTrans = 200
	
	local navGroupY = scrChat.y
	
	transition.to( scrChat, { time=fieldTrans, y=(navGroupY - fieldOffset)} )

	if ( event.phase == "began" ) then

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    elseif ( event.phase == "editing" ) then
		
    end
end

function buildChat(poscD)
    for z = 1, #tmpList do
        local i = tmpList[z]
        if i.date then
			lastDate = i.date
            local bgDate = display.newRoundedRect( midW, posY, 300, 40, 20 )
            bgDate.anchorY = 0
            bgDate:setFillColor( 220/255, 186/255, 218/255 )
            grpChat:insert(bgDate)
            
            local lblDate = display.newText({
                text = i.date,     
                x = midW, y = posY + 20,
                font = native.systemFont,   
                fontSize = 20, align = "center"
            })
            lblDate:setFillColor( .1 )
            grpChat:insert(lblDate)
            
            posY = posY + 70
        else
            
            local bgM0 = display.newRoundedRect( 20, posY, 502, 51, 10 )
            bgM0.anchorX = 0
            bgM0.anchorY = 0
            bgM0.alpha = .2
            bgM0:setFillColor( .3 )
            grpChat:insert(bgM0)
            
            local bgM = display.newRoundedRect( 20, posY, 500, 50, 10 )
            bgM.anchorX = 0
            bgM.anchorY = 0
            bgM:setFillColor( 1 )
            grpChat:insert(bgM)
            
            local lblM = display.newText({
                text = i.message,     
                x = 40, y = posY + 10,
                font = native.systemFont,   
                fontSize = 20, align = "left"
            })
            lblM.anchorX = 0
            lblM.anchorY = 0
            lblM:setFillColor( .1 )
            grpChat:insert(lblM)
            
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
                grpChat:insert(lblM)
                
                if i.isMe then
                    lblM.x = 270
                end
                
                bgM.height = lblM.contentHeight + 30
                bgM0.height = lblM.contentHeight + 31
            else
                bgM.width = lblM.contentWidth + 40
                bgM0.width = lblM.contentWidth + 42
				if lblM.contentWidth < 80 then
					 bgM.width = 80
				end
                lblM.anchorX = 0
                if i.isMe then
                    lblM.anchorX = 1
                    lblM.x = intW - 40
                end
            end
            
			if poscD ~= 0 then
				lblDateTemp[poscD] = display.newText({
					text = "Cargando",
					x = lblM.x, y = posY + lblM.contentHeight + 15,
					font = native.systemFont,   
					fontSize = 12, align = "left"
				})
				lblDateTemp[poscD].anchorX = lblM.anchorX
				lblDateTemp[poscD]:setFillColor( .5 )
				grpChat:insert(lblDateTemp[poscD])
				if lblM.anchorX == 1 then
					lblDateTemp[poscD].anchorX = 0
					lblDateTemp[poscD].x = intW - bgM.width
				end
			else
				local lblTime = display.newText({
					text = i.time,
					x = lblM.x, y = posY + lblM.contentHeight + 15,
					font = native.systemFont,   
					fontSize = 12, align = "left"
				})
				lblTime.anchorX = lblM.anchorX
				lblTime:setFillColor( .5 )
				grpChat:insert(lblTime)
				if lblM.anchorX == 1 then
					lblTime.anchorX = 0
					lblTime.x = intW - bgM.width
				end
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
    grpChat:insert(point)
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
    
    local o = display.newRoundedRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	    
    local bgH = display.newRoundedRect( midW, 40 + h, display.contentWidth, 80, 20 )
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
        top = 130,
        left = 0,
        width = intW,
        height = intH - 220,
        scrollWidth = 600,
        scrollHeight = 800,
        --hideBackground = true	
		backgroundColor = { 0.8, 0.8, 0.8 }
    }
    screen:insert(scrChat)  
	grpChat = display.newGroup()
	scrChat:insert( grpChat )
    
    local bgM0 = display.newRoundedRect( midW, intH - 45, intW - 35, 75, 10 )
    bgM0:setFillColor( .8 )
    screen:insert(bgM0)

   local bgM = display.newRoundedRect( midW, intH - 45, intW - 40, 70, 10 )
    bgM:setFillColor( 1 )
    screen:insert(bgM)
    
     local icoSend = display.newImage("img/icoSend.png")
    icoSend:translate(intW - 60, intH - 45)
    screen:insert(icoSend)
	icoSend:addEventListener( 'tap', sentMessage )
	
	txtMessage = native.newTextField( midW - 35, intH - 45, intW - 140, 70 )
    --txtMessage.method = "signin"
    txtMessage.inputType = "default"
    txtMessage.hasBackground = false
	txtMessage.channelId = item.channelId
    txtMessage:addEventListener( "userInput", onTxtFocus )
	screen:insert( txtMessage )
	
	posY = 30
	scrChatY = scrChat.y
	scrChatH = scrChat.height
	
	RestManager.getChatMessages(item.channelId);
    
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