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
local grpChat, grpTextField, grpBlocked

-- Variables
local posY 
local scrChatY
local scrChatH
local txtMessage
local poscList = 0
local lastDate = ""
local lastStatus = 0
local tmpList = {}
local lblDateTemp = {}
local itemsConfig = {}
local NoMessage
local contTemp = -1
local timer1
local checkBlue = {}
local chanelId = 0



---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

---------------------------------------------
-- Cargamos los elementos del los mensajes
-- @param items elementos de los chats 
---------------------------------------------
function setItemsMessages( items )
	for i = 1, #items, 1 do
		local item = items[i]
		local poscI = #tmpList + 1
		if item.changeDate == 1 then
			tmpList[poscI] = {date = item.fechaFormat, dateOnly = item.dateOnly}
			poscI = poscI + 1
		end
		tmpList[poscI] = {id = item.id, isMe = item.isMe, message = item.message, time = item.hora, isRead = item.status_message, senderId = item.sender_id } 
	end
	tools:setLoading( false, screen )
	buildChat(0)
end

------------------------------------------------------
-- Muestra un mensaje cuando no se encuentren chats
------------------------------------------------------
function notChatsMessages()
	tools:setLoading( false, screen )
	NoMessage = tools:NoMessages( true, scrChat, "No cuenta con mensajes en este momento" )
	messagesInRealTime()
end

------------------------------------------------------------
-- Muestra un mensaje cuando no exista conexion a internet
-- @param message mensaje a mostrar
------------------------------------------------------------
function noConnectionMessage(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false, screen )
	messagesInRealTime()
end

-----------------------
-- Envia el mensaje
-----------------------
function sentMessage()

	local function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
	componentActive = "blockChat"
	--verifica que ninguno este bloqueado
	if itemsConfig.blockMe == "open" and itemsConfig.blockYour == "open" then
		componentActive = false
		if trimString(txtMessage.text) ~= "" then
			local dateM = RestManager.getDate()
			local poscD = #lblDateTemp + 1
			--displaysInList("quivole carnal", poscD, dateM[2])
			if NoMessage then
				tools:NoMessages( false, scrChat, "" )
				NoMessage:removeSelf()
				NoMessage = nil
			end
			local settings = DBManager.getSettings()
			local itemTemp = {message = txtMessage.text, posc = poscD, fechaFormat = dateM[2], hora = "Cargando", sender_id = settings.idApp }
			displaysInList(itemTemp, true)
			local newMessageText = trimString(txtMessage.text)
			newMessageText = string.gsub( newMessageText, "/", '&#47;' )
			newMessageText = string.gsub( newMessageText, "\\", '&#92;' )
			newMessageText = string.gsub( newMessageText, "%%", '&#37;' )
			RestManager.sendChat( itemsConfig.channelId, newMessageText, poscD )
			txtMessage.text = ""
			native.setKeyboardFocus( nil )
		else
			native.setKeyboardFocus( nil )
		end
	--si lo esta muenstra un mensaje de aviso
	elseif itemsConfig.blockMe == "closed" then
		blockedChatMsg('desbloquea a ' .. itemsConfig.display_name .. ' par enviarle un mensaje', true, false)
	elseif itemsConfig.blockYour == "closed" then
		blockedChatMsg('No se puede mandar mensaje, ' .. itemsConfig.display_name .. ' lo ha bloqueado', true, false)
	end
	return true
end

function showNewMessages( items, last )
	for i = 1, #items, 1 do
		if #items > 0 then
			displaysInList(items[i], false )
		end
	end
	if last ~= '0' then
		checkMessages(last)
	end
	local resumeTime = timer.resume( timer1 )
end

--------------------------------------------------
-- Prepara los datos para pintarlo en el scroll
-- @param itemTemp informacion del mensaje
-- @param isMe indica si el mensaje es nuestro
--------------------------------------------------
function displaysInList(itemTemp, isMe)
	tmpList = nil
	tmpList = {}
	tmpList[1] = {id = itemTemp.id, isMe = isMe, message = itemTemp.message , time = itemTemp.hora, isRead = itemTemp.status_message, senderId = itemTemp.sender_id}
	--verifica la fecha en que se mando
	if lastDate ~= itemTemp.fechaFormat then
		local bgDate = display.newRoundedRect( midW, posY, 300, 40, 20 )
		bgDate.anchorY = 0
		bgDate:setFillColor( 220/255, 186/255, 218/255 )
		scrChat:insert(bgDate)
		local lblDate = display.newText({
			text = itemTemp.fechaFormat,     
			x = midW, y = posY + 20,
			font = native.systemFont,   
			fontSize = 20, align = "center"
		})
		lblDate:setFillColor( .1 )
		scrChat:insert(lblDate)
		posY = posY + 70
		lastDate = itemTemp.fechaFormat
	end
	
	if isMe == true then
		buildChat(itemTemp.posc)
	else
		if itemsConfig.channelId == itemTemp.channel_id then
			buildChat(0)
		end
	end
end

---------------------------------------------------
-- Cambia la fecha del mensaje
-- @param item informacion del mensaje
-- @param poscD posicion del mensaje en la tabla
---------------------------------------------------
function changeDateOfMSG(item, poscD)
	lblDateTemp[poscD].text = item.hora
	for i=1, #checkBlue, 1 do
		if checkBlue[i].poscD == poscD then
			checkBlue[i].id = item.idMessage
		end
	end
	local titleScene = composer.getScene( "src.Messages" )
	if titleScene then
		movedChat(item, item.message, 0)
	end
end

---------------------------------------------------
-- Marca los mensajes leidos
-- @param last id del ultimo mensaje leido
---------------------------------------------------
function checkMessages(last)
	if last ~= 0 then
		local numCheck = 0
		for i=1, #checkBlue, 1 do
			if checkBlue[i].id == last then
				numCheck = i
				break
			end
		end
		if numCheck ~= 0 then
			for j=numCheck, 1, -1 do
				checkBlue[j].alpha = 1
				table.remove( checkBlue, j )
			end
		end
	end
end

----------------------------------
-- Regresa a la scena anterior
----------------------------------
function toBack()
    audio.play(fxTap)
    composer.gotoScene( "src.Home", { time = 400, effect = "slideRight" } )
end

----------------------------------
-- esconde el teclado cuando se le da click a un area vacia
----------------------------------
function hideKeyboard( event )
	native.setKeyboardFocus( nil )
	return true
end

--[[function hideKeyboardSlider( event )
	if ( event.phase == "ended" ) then
		print('hola')
		print(event.yStart)
		print(event.y)
    end
	return true
end]]

function scrollListener( event )
	if ( event.phase == "ended" ) then
		if event.y - event.yStart == 0 then
			native.setKeyboardFocus( nil )
		end
    end
end


------------------------------------------------------------------
-- Muestra un aviso si se desea bloquear o desbloquear el chat
------------------------------------------------------------------
function blockedChat( event )
	componentActive = "blockChat"
	if itemsConfig.blockMe == "closed" then
		blockedChatMsg('¿desea desbloquear a ' .. itemsConfig.display_name .. '? para enviarle mensajes', true, true)
	else
		blockedChatMsg('¿desea bloquear a ' .. itemsConfig.display_name .. '? ya no podras enviarle mensajes', true, true)
	end
end

---------------------------------------------------
-- Crea el aviso de chats bloqueado
-- @param message mensaje que muestra el bloqueo
-- @param isShow indica si esta activo el aviso
-- @param isBlock indica si esta o no bloqueado
---------------------------------------------------
function blockedChatMsg(message, isShow, isBlock)
	if isShow then
		grpBlocked = display.newGroup()
		
		local bgBlocked0 = display.newRect( midW, midH + h, intW, intH )
		bgBlocked0:setFillColor( 0, 0, 0, .5)
		grpBlocked:insert(bgBlocked0)
		bgBlocked0:addEventListener( 'tap', noAction )
		
		local bgBlocked1 = display.newRoundedRect( midW, midH + h, intW - 100, 300, 15 )
		bgBlocked1:setFillColor( 1 )
		grpBlocked:insert(bgBlocked1)
		
		local lblBlocked = display.newText({
			text = message,     
			x = midW, y = midH + h ,
			width = intW - 200, height = 200,
			font = native.systemFont,   
			fontSize = 30, align = "center"
		})
		lblBlocked:setFillColor( 0 )
		grpBlocked:insert(lblBlocked)
		
		local lblAccept = display.newText({
			text = "Aceptar",     
			x = midW, y = midH + h + 80 ,
			font = native.systemFontBold,   
			fontSize = 42, align = "center"
		})
		lblAccept:setFillColor( 129/255, 61/255, 153/255 )
		grpBlocked:insert(lblAccept)
		
		if isBlock then
			lblAccept.x = midW + 125
			lblAccept:addEventListener( 'tap', blocked )
			local lblCancel = display.newText({
				text = "Cancelar",     
				x = midW - 125, y = midH + h + 80 ,
				font = native.systemFontBold,   
				fontSize = 42, align = "center"
			})
			lblCancel:setFillColor( 129/255, 61/255, 153/255 )
			grpBlocked:insert(lblCancel)
			lblCancel:addEventListener( 'tap', blockedChatMsg )
		else
			lblAccept:addEventListener( 'tap', blockedChatMsg )
		end
		
	else
		componentActive = false
		if grpBlocked then
			grpBlocked:removeSelf()
			grpBlocked = nil
		end
	end
end

-----------------------------------
--bloquea o desbloquea el chats
-----------------------------------
function blocked( event )
	event.target:removeEventListener( "tap", blocked )
	RestManager.blokedChat(itemsConfig.channelId, itemsConfig.blockMe)
end

---------------------------------------------
-- deshabilita los eventos tap no deseados
-- deshabilita el traspaso del componentes
---------------------------------------------
function noAction( event )
	return true
end

----------------------------------------------------
-- Cambia el estatus del bloqueo personal
-- @param status indica si se bloquea o debloquea
----------------------------------------------------
function changeStatusBlock(status)
	itemsConfig.blockMe = status
	blockedChatMsg("", false, false)
end

---------------------------------------------
-- Elimina la burbuja de mensajes no leidos
---------------------------------------------
function deleteNotBubble()
	if unreadChats > 0 then
		unreadChats = unreadChats - 1
	end
	local titleScene = composer.getScene( "src.Messages" )
	if titleScene then
		createNotBubble( poscList, 0 )
	end
	messagesInRealTime()
end

-----------------------------------
--envento input del textbox
-----------------------------------
function onTxtFocus( event )
	local fieldOffset, fieldTrans
	fieldOffset = intH/3 + 100
	fieldTrans = 200
	if ( event.phase == "began" ) then
    elseif ( event.phase == "ended") then
		native.setKeyboardFocus( nil )
	elseif (event.phase == "submitted" ) then
		-- Envia el mensaje 
		--sentMessage()
		native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
    end
end

----------------------------------------------------
-- Contruye el los mensajes del chats
-- @param poscD posicion del mensaje en la tabla
----------------------------------------------------
function buildChat(poscD)

	for z = 1, #tmpList do
	
		local i = tmpList[z]
		-- muestra la fecha
        if i.date then
			lastDate = i.date
            local bgDate = display.newRect( midW, posY, intW, 2 )
            bgDate.anchorY = 0
            bgDate:setFillColor( 191/255, 190/255, 180/255 )
            grpChat:insert(bgDate)
            
            local lblDate = display.newText({
                text = i.date,     
                x = midW, y = posY + 30,
                font = fontFamilyLight,   
                fontSize = 25, align = "center"
            })
            lblDate:setFillColor( .1 )
            grpChat:insert(lblDate)
            
            posY = posY + 70
		--muestra los mensajes
        else
			
			local image = i.senderId .. ".png"
		local avatar = nil
			local path = system.pathForFile( image, system.TemporaryDirectory )
			local fhd = io.open( path )
			if fhd then
				fhd:close()
				avatar = display.newImage(image, system.TemporaryDirectory)
				avatar:translate(10, posY)
				avatar.anchorX = 0
				avatar.anchorY = 0
				avatar.width = 80
				avatar.height = 80
				grpChat:insert( avatar )
				local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
				avatar:setMask( maskCircle80 )
			else
				
			end
			
			local bgM0 = display.newRoundedRect( 100, posY, 502, 85, 5 )
            bgM0.anchorX = 0
            bgM0.anchorY = 0
            bgM0.alpha = .2
            bgM0:setFillColor( .3 )
            grpChat:insert(bgM0)
			
			local bgM = display.newRoundedRect( 100, posY, 500, 82, 5 )
            bgM.anchorX = 0
            bgM.anchorY = 0
            bgM:setFillColor( 68/255, 14/255, 98/255 )
            grpChat:insert(bgM)
			
			local lblM = display.newText({
                text = i.message,     
                x = 120, y = posY + 10,
                font = fontFamilyRegular,   
                fontSize = 30, align = "left"
            })
            lblM.anchorX = 0
            lblM.anchorY = 0
            lblM:setFillColor( 1 )
			--lblM:setFillColor( .1 )
            grpChat:insert(lblM)
			
			if lblM.contentWidth > 450 then
                lblM:removeSelf()
                
                lblM = display.newText({
                    text = i.message, 
                    width = 450,
                    x = 120, y = posY + 10,
                    font = fontFamilyRegular,   
                    fontSize = 30, align = "left"
                })
                lblM.anchorX = 0
                lblM.anchorY = 0
                lblM:setFillColor( 1 )
                grpChat:insert(lblM)
                
                if i.isMe then
                    --lblM.x = 270
					lblM.anchorX = 1
                    lblM.x = intW - 120
					lblM:setFillColor( 68/255, 14/255, 98/255 )
                end
                --bgM.height = lblM.contentHeight + 46
                --bgM0.height = lblM.contentHeight + 48
				bgM.height = lblM.contentHeight + 46
                bgM0.height = lblM.contentHeight + 48
            else
                bgM.width = lblM.contentWidth + 46
                bgM0.width = lblM.contentWidth + 48
				if lblM.contentWidth < 60 then
					 bgM.width = 146
					 bgM0.width = 148
				end
                lblM.anchorX = 0
                if i.isMe then
                    lblM.anchorX = 1
                    lblM.x = intW - 120
					lblM:setFillColor( 68/255, 14/255, 98/255 )
                end
            end
			
			--muestra un cargando mientra se confirma el mensaje v9
			local lblTime = nil
			if poscD ~= 0 then
				lblDateTemp[poscD] = display.newText({
					text = "Cargando",
					x = lblM.x, y = posY + lblM.contentHeight + 20,
					font = fontFamilyLight,   
					fontSize = 18, align = "left"
				})
				lblDateTemp[poscD].anchorX = lblM.anchorX
				lblDateTemp[poscD]:setFillColor( .5 )
				grpChat:insert(lblDateTemp[poscD])
				if lblM.anchorX == 1 then
					lblDateTemp[poscD].anchorX = 0
					lblDateTemp[poscD].x = intW - bgM.width
				end
				lblDateTemp[poscD].anchorX = 1
				lblDateTemp[poscD].x = intW - 130
			--muestra la hora en que se envio el mensaje
			else
				lblTime = display.newText({
					text = i.time,
					x = lblM.x, y = posY + lblM.height + 25,
					font = fontFamilyLight,   
					fontSize = 18, align = "left"
				})
				lblTime.anchorX = lblM.anchorX
				lblTime:setFillColor( .87 )
				grpChat:insert(lblTime)
				if lblM.anchorX == 1 then
					lblTime.anchorX = 1
					lblTime.x = intW - 130
				end
			end
			
			if i.isMe == true then
				if i.isRead == '1' or i.isRead == 1 then
					local iconCheckBlue = display.newImage("img/icoFilterCheck.png")
					iconCheckBlue:translate(intW - 115, posY + lblM.contentHeight + 20)
					grpChat:insert( iconCheckBlue )
				else
					local num = #checkBlue + 1
					checkBlue[num] = display.newImage("img/icoFilterCheck.png")
					checkBlue[num]:translate(728, posY + lblM.contentHeight + 20)
					grpChat:insert( checkBlue[num] )
					checkBlue[num].alpha = 0
					if i.id then
						checkBlue[num].id = i.id
					else
						checkBlue[num].id = 0
						checkBlue[num].poscD = poscD
					end
				end
			end
			
			--cambia la posicion del mensaje si es del usuario
            if i.isMe then
                bgM0.x = intW - 100
                bgM.x = intW - 100
                bgM0.anchorX = 1
                bgM.anchorX = 1
                bgM0.alpha = .3
                bgM:setFillColor( 1 )
				if lblTime then
					lblTime:setFillColor( .5 )
				end
				if avatar then
					avatar.anchorX = 1
					avatar.x = intW - 10
				end
            end
            
            posY = posY + bgM.height + 30
            if z < #tmpList then
                if tmpList[z+1].isMe == i.isMe then 
                    posY = posY - 20
                end
            end
			
			--posY = posY + 200
		
		end
		
		if i.isRead == '0' and i.isMe == false then
			lastStatus = i.id
		end
	
	end
	
	local point = display.newRect( 1, posY + 30, 1, 1 )
	grpChat:insert(point)
	if scrChat.height <= posY + 30 then
		scrChat:setScrollHeight( posY )
		scrChat:scrollTo( "bottom", { time=0 } )
	end
	if lastStatus ~= 0 then
		RestManager.changeStatusMessages(itemsConfig.channelId, lastStatus)
	else
		messagesInRealTime()
	end

end

-----------------------------------
-- Muestra la imagen del usuario
-----------------------------------
function setImagePerfilMessage()
	--obtiene los mensajes del canal
	RestManager.getChatMessages(itemsConfig.channelId)
end

function messagesInRealTime()
	if not timer1 then
		timer1 = timer.performWithDelay( 300, function()
			local result = timer.pause( timer1 )
			RestManager.getMessagesByChannel(chanelId)
		end, -1  )
	end
end

function toolMessage(item)
	
	--[[local bgH = display.newRect( midW, 50 + h, display.contentWidth, 100 )
    bgH:setFillColor( 1 )
    screen:insert(bgH)]]
	
	local bgH0 = display.newRect( midW, 84 + h, display.contentWidth, 10 )
	bgH0.anchorY = 0
	bgH0:setFillColor( 103/255, 67/255, 123/255 )
	screen:insert( bgH0 )
		
	local bgH = display.newRect( midW, h, display.contentWidth, 90 )
	bgH.anchorY = 0
	bgH:setFillColor( 68/255, 14/255, 98/255 )
	screen:insert( bgH )
	
	-- back
	local bgIcoBack = display.newRect( (intW/3)/2, h, intW/3, 90 )
	bgIcoBack.anchorY = 0
	bgIcoBack:setFillColor( 68/255, 14/255, 98/255 )
	bgIcoBack.screen = 'Messages'
	bgIcoBack.alpha = .01
	bgIcoBack:addEventListener( 'tap', toScreen)
	screen:insert( bgIcoBack )
		
	local icoBack = display.newImage("img/Regresar-icono.png")
	icoBack:translate(60, 45 + h)
	icoBack.isReturn = 1
	screen:insert( icoBack )
			
	local lblIcoBack  = display.newText({
		text = "Regresar", 
		x = 130, y = 45 + h,
		font = fontFamilyLight,   
		fontSize = 24, align = "left"
	})
	lblIcoBack:setFillColor( 1 )
	screen:insert(lblIcoBack)
	
	--name contact
	local bgName = display.newRect( midW, h, intW/3, 90 )
	bgName.anchorY = 0
	bgName:setFillColor( 45/255, 10/255, 65/255 )
	--bgIcoHome.screen = 'Welcome'
	--bgIcoHome:addEventListener( 'tap', toScreen)
	screen:insert( bgName )
	
	local lblName  = display.newText({
		text = item.name, 
		x = midW, y = 45 + h,
		width = intW/3,
		font = fontFamilyBold,   
		fontSize = 24, align = "center"
	})
	lblName:setFillColor( 1 )
	screen:insert(lblName)
	
	--block
	--local bgIcoBlock = display.newRect( intW - (intW/3)/2, h, intW/3, 90 )
	local btnBlock = display.newRect( 640, h, intW/3, 90 )
	btnBlock.anchorY = 0
	btnBlock:setFillColor( 0/255, 174/255, 239/255 )
	screen:insert( btnBlock )
	btnBlock:addEventListener( 'tap', blockedChat )
	
	local lblIcoBlock  = display.newText({
		text = "BLOQUEAR", 
		x = 640, y = 45 + h,
		width = intW/3,
		font = fontFamilyBold,   
		fontSize = 24, align = "center"
	})
	lblIcoBlock:setFillColor( 1 )
	screen:insert(lblIcoBlock)
				
	--[[local iconHome = display.newImage("img/home.png")
	iconHome:translate(midW, 40 + h)
	screen:insert( iconHome )]]
	
	
	
    --[[local bgHBtn = display.newRect( intW - 55, 50 + h, 130, 100 )
    bgHBtn:setFillColor( .95 )
    screen:insert(bgHBtn)
    -- Back button
	local btnBack = display.newImage("img/icoBack.png")
	btnBack:translate(50, 50 + h)
    btnBack:addEventListener( 'tap', toBack)
    screen:insert( btnBack )
    -- Image
	local path = system.pathForFile( item.image, system.TemporaryDirectory )
	local fhd = io.open( path )
	if fhd then
		local avatar = display.newImage(item.image, system.TemporaryDirectory)
		avatar:translate(150, 50 + h)
		avatar.width = 80
		avatar.height = 80
		screen:insert( avatar )
		local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
		avatar:setMask( maskCircle80 )
	else
		item.image = item.image
		local items = {}
		items[1] = item
		RestManager.getImagePerfilMessage(items)
	end
	--btn bloquear
	local btnBlock = display.newImage("img/cancel-icon-2.png")
    btnBlock:translate(intW - 55, 50 + h)
    btnBlock.width = 70
    btnBlock.height = 70
    screen:insert( btnBlock )
    btnBlock:addEventListener( 'tap', blockedChat )
    -- Name
    local lblName = display.newText({
        text = item.name,     
        x = midW + 130, y = 55 + h,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( .3 )
    screen:insert(lblName)]]
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
    local item = event.params.item
	chanelId = item.channelId
	poscList = item.posc
	screen = self.view
	--toolbar
    tools = Tools:new()
    --screen.y = h
    grpTextField = display.newGroup()
	screen:insert( grpTextField )
    local bg = display.newRect( midW, midH + h, intW, intH, 20 )
    bg:setFillColor( 1 )
    screen:insert(bg)
	--background
    local o = display.newRect( midW, midH + h, intW+8, intH )
	o:setFillColor( 245/255 )
    screen:insert(o)
	
	--o:addEventListener( 'tap', hideKeyboard )
	--o:addEventListener( 'touch', hideKeyboardSlider )
	--bg component
	
	toolMessage(item)
	
	--scrollView
	scrChat = widget.newScrollView{
        top = 95 + h,
        left = 0,
        width = intW,
        height = intH - 185 - h,
        scrollWidth = 600,
        scrollHeight = 800,
		--backgroundColor = { 0.8, 0.8, 0.8 },
        hideBackground = true,
		listener = scrollListener
    }
    screen:insert(scrChat)  
	grpChat = display.newGroup()
	scrChat:insert( grpChat )
	
	tools:setLoading(true,screen)
	
	--scrChat:addEventListener( 'tap', hideKeyboard )
	--bg enviar
    local bgSendField = display.newRect( midW, intH - 45, intW, 90 )
    bgSendField:setFillColor( 68/255, 14/255, 98/255 )
    grpTextField:insert(bgSendField)
    local bgSend = display.newRect( intW - 75, intH - 45, 150, 90 )
    bgSend:setFillColor( 0/255, 174/255, 239/255 )
	bgSend:addEventListener( 'tap', sentMessage )
    grpTextField:insert(bgSend)
    --label enviar
    local lblSend = display.newText({
        text = "ENVIAR",     
        x = intW - 75, y = intH - 45, width = 150,
        font = fontFamilyLight,   
        fontSize = 30, align = "center"
    })
    lblSend:setFillColor( 1 )
    grpTextField:insert(lblSend)
   
	txtMessage = native.newTextField( midW - 75, intH - 42, intW - 200, 80 )
    txtMessage.inputType = "default"
    txtMessage:addEventListener( "userInput", onTxtFocus )
	txtMessage:setReturnKey( "default" )
	txtMessage.size = 32
	txtMessage.hasBackground = false
	txtMessage:setTextColor( 1 )
	txtMessage.placeholder = "Escribir"
	--txtMessage:resizeHeightToFitFont()
	grpTextField:insert( txtMessage )
	--txtMessage.text = "§♫→↨☺☻♥♦♣♠•◘○↨$▼"
	posY = 30
	scrChatY = scrChat.y
	scrChatH = scrChat.height
	itemsConfig = {blockYour = item.blockYour, blockMe = item.blockMe, channelId = item.channelId, display_name = item.name } 
	
	--verifica si existe los avatares de loss usuarios
	local settings = DBManager.getSettings()
	local contI = 0
	local imgExist = { settings.idApp .. ".png", item.recipientId .. ".png" }
	
	for i = 1, #imgExist, 1 do
		local path = system.pathForFile( imgExist[i], system.TemporaryDirectory )
		local fhd = io.open( path )
		if not fhd then
			contI = contI + 1
		else
			fhd:close()
		end
	end
	
	if ( contI > 0 ) then
		--descarga las imagenes en caso de no existir
		RestManager.getImagePerfilMessage( item.recipientId )
	else
		--obtiene los mensajes del canal
		RestManager.getChatMessages(item.channelId)
	end
	
	grpTextField:toFront()

end
	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	if grpChats then
		grpChats.alpha = 0
	end
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus( nil )
	if timer1 then
		timer.cancel( timer1 ) 
	end
	if grpTextField then
		grpTextField:removeSelf()
		grpTextField = nil
	end
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene