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
		tmpList[poscI] = {id = item.id, isMe = item.isMe, message = item.message, time = item.hora, isRead = item.status_message} 
	end
	buildChat(0)
end

function utf8_decode(utf8)
 
   local unicode = ""
   local mod = math.mod
 
   local pos = 1
   while pos < string.len(utf8)+1 do
 
      local v = 1
      local c = string.byte(utf8,pos)
      local n = 0
 
      if c < 128 then v = c
      elseif c < 192 then v = c
      elseif c < 224 then v = mod(c, 32) n = 2
      elseif c < 240 then v = mod(c, 16) n = 3
      elseif c < 248 then v = mod(c,  8) n = 4
      elseif c < 252 then v = mod(c,  4) n = 5
      elseif c < 254 then v = mod(c,  2) n = 6
      else v = c end
      
      for i = 2, n do
         pos = pos + 1
         c = string.byte(utf8,pos)
         v = v * 64 + mod(c, 64)
      end
 
      pos = pos + 1
      if v < 255 then unicode = unicode..string.char(v) end
 
   end
 
   return unicode
end

------------------------------------------------------
-- Muestra un mensaje cuando no se encuentren chats
------------------------------------------------------
function notChatsMessages()
	tools:setLoading( false,screen )
	NoMessage = tools:NoMessages( true, scrChat, "No cuenta con mensajes en este momento" )
end

------------------------------------------------------------
-- Muestra un mensaje cuando no exista conexion a internet
-- @param message mensaje a mostrar
------------------------------------------------------------
function noConnectionMessage(message)
	tools:noConnection( true, screen, message )
	tools:setLoading( false,screen )	
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
			local itemTemp = {message = txtMessage.text, posc = poscD, fechaFormat = dateM[2], hora = "Cargando"}
			displaysInList(itemTemp, true)
			local newMessageText = trimString(txtMessage.text)
			newMessageText = string.gsub( newMessageText, "/", '&#47;' )
			newMessageText = string.gsub( newMessageText, "\\", '&#92;' )
			newMessageText = string.gsub( newMessageText, "%%", '&#37;' )
			RestManager.sendChat( itemsConfig.channelId, newMessageText, poscD )
			txtMessage.text = ""
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
	tmpList[1] = {id = itemTemp.id, isMe = isMe, message = itemTemp.message , time = itemTemp.hora, isRead = itemTemp.status_message}
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
	local numCheck = 0
	for i=1, #checkBlue, 1 do
		if checkBlue[i].id == last then
			numCheck = i
			break
		end
	end
	for i=numCheck, 1, -1 do
		checkBlue[i].alpha = 1
		table.remove( checkBlue, i )
	end
end

----------------------------------
-- Regresa a la scena anterior
----------------------------------
function toBack()
    audio.play(fxTap)
    composer.gotoScene( "src.Messages", { time = 400, effect = "slideRight" } )
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
		sentMessage()
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
            local bgDate = display.newRoundedRect( midW, posY, 350, 40, 20 )
            bgDate.anchorY = 0
            bgDate:setFillColor( 220/255, 186/255, 218/255 )
            grpChat:insert(bgDate)
            
            local lblDate = display.newText({
                text = i.date,     
                x = midW, y = posY + 20,
                font = "Lato-Regular",   
                fontSize = 25, align = "center"
            })
            lblDate:setFillColor( .1 )
            grpChat:insert(lblDate)
            
            posY = posY + 70
		--muestra los mensajes
        else
            local bgM0 = display.newRoundedRect( 20, posY, 502, 80, 20 )
            bgM0.anchorX = 0
            bgM0.anchorY = 0
            bgM0.alpha = .2
            bgM0:setFillColor( .3 )
            grpChat:insert(bgM0)
            
            local bgM = display.newRoundedRect( 20, posY, 500, 77, 20 )
            bgM.anchorX = 0
            bgM.anchorY = 0
            bgM:setFillColor( 1 )
            grpChat:insert(bgM)
            
            local lblM = display.newText({
                text = i.message,     
                x = 40, y = posY + 10,
                font = "Lato-Regular",   
                fontSize = 30, align = "left"
            })
            lblM.anchorX = 0
            lblM.anchorY = 0
            lblM:setFillColor( .1 )
            grpChat:insert(lblM)
            
			--ajusta el tamaño del background
            if lblM.contentWidth > 450 then
                lblM:removeSelf()
                
                lblM = display.newText({
                    text = i.message, 
                    width = 450,
                    x = 40, y = posY + 10,
                    font = "Lato-Regular",   
                    fontSize = 30, align = "left"
                })
                lblM.anchorX = 0
                lblM.anchorY = 0
                lblM:setFillColor( .1 )
                grpChat:insert(lblM)
                
                if i.isMe then
                    lblM.x = 270
                end
                bgM.height = lblM.contentHeight + 41
                bgM0.height = lblM.contentHeight + 42
            else
                bgM.width = lblM.contentWidth + 40
                bgM0.width = lblM.contentWidth + 42
				if lblM.contentWidth < 60 then
					 bgM.width = 140
					 bgM0.width = 142
				end
                lblM.anchorX = 0
                if i.isMe then
                    lblM.anchorX = 1
                    lblM.x = intW - 40
                end
            end
			
            --muestra un cargando mientra se confirma el mensaje v9
			
			if poscD ~= 0 then
				lblDateTemp[poscD] = display.newText({
					text = "Cargando",
					x = lblM.x, y = posY + lblM.contentHeight + 20,
					font = "Lato-Regular",   
					fontSize = 18, align = "left"
				})
				lblDateTemp[poscD].anchorX = lblM.anchorX
				lblDateTemp[poscD]:setFillColor( .5 )
				grpChat:insert(lblDateTemp[poscD])
				if lblM.anchorX == 1 then
					lblDateTemp[poscD].anchorX = 0
					lblDateTemp[poscD].x = intW - bgM.width
				end
			--muestra la hora en que se envio el mensaje
			else
				local lblTime = display.newText({
					text = i.time,
					x = lblM.x, y = posY + lblM.contentHeight + 20,
					font = "Lato-Regular",   
					fontSize = 18, align = "left"
				})
				lblTime.anchorX = lblM.anchorX
				lblTime:setFillColor( .5 )
				grpChat:insert(lblTime)
				if lblM.anchorX == 1 then
					lblTime.anchorX = 0
					lblTime.x = intW - bgM.width
				end
			end
			if i.isMe == true then
				if i.isRead == '1' or i.isRead == 1 then
					local iconCheckBlue = display.newImage("img/icoFilterCheck.png")
					iconCheckBlue:translate(728, posY + lblM.contentHeight + 20)
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
function setImagePerfilMessage(item)
	local avatar = display.newImage(item.photo, system.TemporaryDirectory)
	avatar:translate(150, 50 + h)
	avatar.width = 80
	avatar.height = 80
	screen:insert( avatar )
	local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
	avatar:setMask( maskCircle80 )
end

function messagesInRealTime()
	timer1 = timer.performWithDelay( 300, function()
		local result = timer.pause( timer1 )
		RestManager.getMessagesByChannel(chanelId)
	end, -1  )
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
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
    local o = display.newRect( midW, midH + h, intW, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
	--bg component
    local bgH = display.newRect( midW, 50 + h, display.contentWidth, 100 )
    bgH:setFillColor( 1 )
    screen:insert(bgH)
    local bgHBtn = display.newRect( intW - 55, 50 + h, 130, 100 )
    bgHBtn:setFillColor( .95 )
    screen:insert(bgHBtn)
    -- Back button
	local btnBack = display.newImage("img/icoBack.png")
	btnBack:translate(50, 50 + h)
    btnBack:addEventListener( 'tap', toBack)
    screen:insert( btnBack )
    -- Image
	local path = system.pathForFile( item.photo, system.TemporaryDirectory )
	local fhd = io.open( path )
	if fhd then
		local avatar = display.newImage(item.photo, system.TemporaryDirectory)
		avatar:translate(150, 50 + h)
		avatar.width = 80
		avatar.height = 80
		screen:insert( avatar )
		local maskCircle80 = graphics.newMask( "img/maskCircle80.png" )
		avatar:setMask( maskCircle80 )
	else
		item.image = item.photo
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
    screen:insert(lblName)
	--scrollView
	scrChat = widget.newScrollView{
        top = 130 + h,
        left = 0,
        width = intW,
        height = intH - 220 - h,
        scrollWidth = 600,
        scrollHeight = 800,
        hideBackground = true
    }
    screen:insert(scrChat)  
	grpChat = display.newGroup()
	scrChat:insert( grpChat )
	--bg enviar
    local bgSendField = display.newRect( midW, intH - 45, intW, 90 )
    bgSendField:setFillColor( .84 )
    grpTextField:insert(bgSendField)
    local bgSend = display.newRect( intW - 75, intH - 45, 150, 90 )
    bgSend:setFillColor( 68/255, 14/255, 98/255 )
	bgSend:addEventListener( 'tap', sentMessage )
    grpTextField:insert(bgSend)
    --label enviar
    local lblSend = display.newText({
        text = "ENVIAR",     
        x = intW - 75, y = intH - 45, width = 150,
        font = "Lato-Regular",   
        fontSize = 30, align = "center"
    })
    lblSend:setFillColor( 1 )
    grpTextField:insert(lblSend)
    --local bgField = display.newRoundedRect(  midW - 75, intH - 45, intW - 190, 60, 20 )
    --bgField:setFillColor( 1 )
    --grpTextField:insert(bgField)
	--textField enviar
	txtMessage = native.newTextField( midW - 75, intH - 45, intW - 200, 60 )
    txtMessage.inputType = "default"
    txtMessage:addEventListener( "userInput", onTxtFocus )
	txtMessage:setReturnKey( "send" )
	txtMessage.size = 30
	txtMessage:resizeHeightToFitFont()
	grpTextField:insert( txtMessage )
	txtMessage.text = "§♫→↨☺☻♥♦♣♠•◘○↨$▼"
	posY = 30
	scrChatY = scrChat.y
	scrChatH = scrChat.height
	itemsConfig = {blockYour = item.blockYour, blockMe = item.blockMe, channelId = item.channelId, display_name = item.name } 
	RestManager.getChatMessages(item.channelId)
	grpTextField:toFront()
	--scrChat:setScrollHeight( posY + 300 )
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide scene
function scene:hide( event )
	native.setKeyboardFocus( nil )
	timer.cancel( timer1 ) 
end

-- Destroy scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene