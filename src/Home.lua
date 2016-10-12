---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------- OBJETOS Y VARIABLES ----------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local composer = require( "composer" )
local RestManager = require('src.resources.RestManager')


-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local topCmp, bottomCmp, profiles, grpBtnDetail, grpLoad, grpLoad2
local container

-- Variables
local isCard = false
local direction = 0
local avaL = {}
local avaR = {}
local detail = {}
local borders = {}
local idxA, countA
local lblName, lblInts, lblAge
local loadUsers = {}
local btnViewProfile
local lblTitle
local limitCard = 5
local totalCard = 0
local isReady = true
local counter = 0
local isFirstI = true
local grpHome

---------------------------------- FUNCIONES ----------------------------------

-------------------------------------
-- Asignamos total de tarjetas
------------------------------------
function setTotalCard(total)
    totalCard = tonumber(total)
end 

-------------------------------------
-- Creamos primera tanda de tarjetas
------------------------------------
function getFirstCards(items)
	tools:setLoadingPerson(false,grpLoad)
	tools:setLoading(false,grpLoad2)
	bottomCmp.alpha = 1
	container.alpha = 1
	for i = 1, #items, 1 do
		table.insert( loadUsers, items[i] )
	end
	
    -- loadUsers = items
	if #loadUsers > 0 then
		if #avaL == 0 then
			idxA = 1
		end
		countA = #items
    
		for i = 1, countA, 1 do
			buildCard(items[i])
		end
		if isFirstI then
            isFirstI = false
			setInfo(1)
			avaL[1].alpha = 1
			avaR[1].alpha = 1
			btnViewProfile:addEventListener( 'tap', showProfiles )
            screen:addEventListener( "touch", touchScreen )
		end
        
        if #loadUsers == 5 and #loadUsers < totalCard then
            getProfile()
        end
	else
		HomeError( "No se encontro usuarios")
	end
end

----------------------------------------------------------
-- Muestra un mensaje si ocurre error al mostrar la info
-- @param message mensaje que se muestra 
----------------------------------------------------------
function HomeError( message )
    btnViewProfile.alpha = 0
    
	tools:setLoadingPerson(false,grpLoad)
	tools:setLoading(false,grpLoad)
	local bgavatarDefault = display.newRect( midW, 60, 700, 700 )
	bgavatarDefault.anchorY = 0
	bgavatarDefault:setFillColor( 1 )
	topCmp:insert(bgavatarDefault)
		
	local avatarDefault = display.newImage( "img/avatar.png" )
	avatarDefault:translate( midW, 450 )
	topCmp:insert(avatarDefault)
	bottomCmp.alpha = 1
	container.alpha = 1
	lblName.text = message
end

-------------------------------------
-- Muestra imagenes y mascaras
-- @param item registro que incluye el nombre de la imagen
------------------------------------
function buildCard(item)

	local grpImage = display.newGroup()
	grpImage.alpha = 0
	grpImage.y = midH
	grpImage.x = midW
	local img = display.newImage( item.image, system.TemporaryDirectory )
	grpImage:insert(img)
	local imgWidth = img.contentWidth 
	local imgHeight = img.contentHeight
	print(imgWidth)
	if imgWidth < 600 then
		img.width = 600
		print("entro")
	end
	if imgHeight < 600 then
		img.height = 600
	end
	
	if imgWidth < 600 or imgHeight < 600 then
		--item.image = "a" .. item.image
		--grpImage.alpha = 1
		--display.save( grpImage, { filename=item.image , baseDir=system.TemporaryDirectory, isFullResolution=false, backgroundColor={0, 0, 0, 0} } )
	end
	grpImage:removeSelf()
	grpImage = nil

    local idx = #avaL + 1
	local imgS = nil
	if imgWidth < 600 or imgHeight < 600 then 
		imgWidth = math.round( imgWidth/2 ) - 1
		imgS = graphics.newImageSheet(  item.image, system.TemporaryDirectory, { width = imgWidth, height = imgHeight, numFrames = 2 })
	elseif imgWidth > 600 or imgHeight > 600 then
		imgWidth = math.round( imgWidth/2 )
		imgS = graphics.newImageSheet(  item.image, system.TemporaryDirectory, { width = imgWidth, height = imgHeight, numFrames = 2 })
	else
		imgS = graphics.newImageSheet( item.image, system.TemporaryDirectory, { width = 300, height = 600, numFrames = 2 })
	end
    
    avaL[idx] = display.newRect( midW, 60, 300, 600 )
    avaL[idx].alpha = 0
    avaL[idx].anchorY = 0
    avaL[idx].anchorX = 1
	avaL[idx].id = item.id
    avaL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    profiles:insert(avaL[idx])
    
    avaR[idx] = display.newRect( midW, 60, 300, 600 )
    avaR[idx].alpha = 0
    avaR[idx].anchorY = 0
    avaR[idx].anchorX = 0
	avaR[idx].id = item.id
    avaR[idx].fill = { type = "image", sheet = imgS, frame = 2 }
    profiles:insert(avaR[idx])
    
end

-------------------------------------
-- Muestra la informacion del perfil
-- @param event datos del boton
------------------------------------
function showProfiles( event )
	event.target.item.isMe = false
	composer.removeScene( "src.Profile" )
	composer.gotoScene( "src.Profile", { time = 400, effect = "fade", params = { item = event.target.item }})
	return true
end

------------------------------------------------
-- Muestra detalles cuando la pantalla es chica
-- @param event datos del boton
------------------------------------------------
function showDetail( event )
	if event.target.flag == 0 then
		if (intH < 1100) then
			topCmp.y = -900
		else
			topCmp.y = -830
		end
		grpBtnDetail.y = midH - 100 + h
		bottomCmp.alpha = 1
		event.target.flag = 1
		lblTitle.text = "MENOS INFORMACIÓN"
		--screen:removeEventListener( "touch", touchScreen )
	else
		bottomCmp.alpha = 0
		topCmp.y =  -500
		grpBtnDetail.y = 800 + h
		event.target.flag = 0
		lblTitle.text = "MÁS INFORMACIÓN"
		--screen:addEventListener( "touch", touchScreen )
	end
end

-------------------------------------
-- Asigna informacion del usuario actual
-- @param idx posicion del registro
------------------------------------
function setInfo(idx)
    -- Hide Icons
    for i=3, 4 do
        detail[i].icon.alpha = 0
        detail[i].icon2.alpha = 0
    end
    -- Set info
    lblName.text = loadUsers[idx].userName 
    if loadUsers[idx].edad then 
        lblName.text = lblName.text .." # "..  loadUsers[idx].edad.." años"
		--lblAge.text = loadUsers[idx].edad.." años"
	else
		--lblAge.text = "Edad no registrada"
    end
	 if loadUsers[idx].residencia then 
        --lblName.text = lblName.text .." # "..  loadUsers[idx].edad.." años"
		lblInts.text = loadUsers[idx].residencia
	else
		lblInts.text = "Residencia no registrada"
    end
	
	-- Hobbies
    --[[if loadUsers[idx].hobbies then
        local max = 3
        if #loadUsers[idx].hobbies < max then 
            max = #loadUsers[idx].hobbies 
        end
        for i=1, max do
            if i == 1 then
                lblInts.text = loadUsers[idx].hobbies[i]
            else
                lblInts.text = lblInts.text..', '..loadUsers[idx].hobbies[i]
            end
        end
        if #loadUsers[idx].hobbies > max then 
            lblInts.text = lblInts.text..'...'
        end
    else
        lblInts.text = ''
    end
	-- Idiomas
	if loadUsers[idx].idiomas then
		local max = 3
		if #loadUsers[idx].idiomas < max then 
            max = #loadUsers[idx].idiomas 
        end
        for i=1, max do
            if i == 1 then
                lblInts.text = lblInts.text .. ' # ' .. loadUsers[idx].idiomas[i]
            else
                lblInts.text = lblInts.text..', '..loadUsers[idx].idiomas[i]
            end
        end
		if #loadUsers[idx].idiomas > max then 
            lblInts.text = lblInts.text..'...'
        end
    else
        lblInts.text = ''
    end]]
	
	btnViewProfile.item = loadUsers[idx]
    --
    --Cuenta con vehiculo propio
    
end


-------------------------------------
-- Listener para el flip del avatar
-- @param event objeto evento
------------------------------------
function touchScreen(event)
    if event.phase == "began" then
        if event.yStart > 140 and event.yStart < 820 and isReady then
            isReady = false
            isCard = true
            direction = 0
        end
    elseif event.phase == "moved" and (isCard) then
		
        local x = (event.x - event.xStart)
        local xM = (x * 1.5)
        if direction == 0 then
            if x < -10 and idxA < #loadUsers then
                direction = 1
                avaR[idxA+1]:toBack()
                avaR[idxA+1].alpha = 1
                avaR[idxA+1].width = 300
            elseif x > 10 and idxA > 1 then
                direction = -1
                avaL[idxA-1]:toBack()
                avaL[idxA-1].alpha = 1
                avaL[idxA-1].width = 300
            end
        elseif direction == 1 and x <= 0 and xM >= -600 then
            if xM > -300 then
                if avaR[idxA].alpha == 0 then
                    avaL[idxA+1].alpha = 0
                    avaR[idxA].alpha = 1
                    avaR[idxA].width = 0
                end
                -- Move current to left
                avaR[idxA].width = 300 + xM
            else
                if avaL[idxA+1].alpha == 0 then
                    avaR[idxA].alpha = 0
                    avaL[idxA+1]:toFront()
                    avaL[idxA+1].alpha = 1
                    avaL[idxA+1].width = 0
                end
                -- Move new to left
                avaL[idxA+1].width = (xM*-1)-300
            end
        elseif direction == -1 and x >= 0 then
            if xM < 300 then
                if avaL[idxA].alpha == 0 then
                    avaR[idxA-1].alpha = 0
                    avaL[idxA].alpha = 1
                    avaL[idxA].width = 0
                end
                -- Move current to left
                avaL[idxA].width = 300 - xM
            elseif xM < 600 then
                if avaR[idxA-1].alpha == 0 then
                    avaL[idxA].alpha = 0
                    avaR[idxA-1]:toFront()
                    avaR[idxA-1].alpha = 1
                    avaR[idxA-1].width = 0
                end
                -- Move new to left
                avaR[idxA-1].width = xM - 300
            end
            
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local xM = ((event.x - event.xStart) * 3)
        -- To Rigth
        if direction == 1 and xM >= -600 then
            avaR[idxA].alpha = 1
            avaL[idxA+1].alpha = 0
            transition.to( avaR[idxA], { width = 300, time = 200, onComplete=function()
                avaR[idxA+1].alpha = 0
                isReady = true
            end})
        elseif direction == 1 and xM < -600 then
            if idxA % 5 == 0 and #loadUsers < totalCard then
                getProfile()
            end
			avaR[idxA].alpha = 0
            avaL[idxA+1].alpha = 1
            setInfo(idxA+1)
            transition.to( avaL[idxA+1], { width = 300, time = 200, onComplete=function()
                avaL[idxA].alpha = 0
                avaR[idxA].alpha = 0
                idxA = idxA + 1
                isReady = true
            end})
        -- To Left
        elseif direction == -1 and xM <= 600 then
            avaL[idxA].alpha = 1
            avaR[idxA-1].alpha = 0
            transition.to( avaL[idxA], { width = 300, time = 200, onComplete=function()
                avaR[idxA-1].alpha = 0
                isReady = true
            end})
        elseif direction == -1 and xM > 600 then
            avaL[idxA].alpha = 0
            avaR[idxA-1].alpha = 1
            setInfo(idxA-1)
            transition.to( avaR[idxA-1], { width = 300, time = 200, onComplete=function()
                avaL[idxA].alpha = 0
                avaR[idxA].alpha = 0
                idxA = idxA - 1
                isReady = true
            end})
        else
            isReady = true
        end
        
        isCard = false
        direction = 0
    end
end

function getProfile()
    print("Load Images "..#loadUsers)
	--screen:removeEventListener( "touch", touchScreen )
	tools:setLoading(true,grpLoad2)
	--RestManager.getUsersByFilter(limitCard)
	if typeSearch == "welcome" then
        RestManager.getUsersByCity(limitCard)
	else
		RestManager.getUsersByFilter(limitCard)
	end
	limitCard = limitCard + 5
	
end


------------------------------------------
-- Mostramos el detalle en recuadro fijo
------------------------------------------
function showInfoDisplay()
    -- Position
    local posY = 860 + h
    
    -- BG Component
    local bgComp1 = display.newRoundedRect( midW, posY+50, 720, 340, 10 )
    bgComp1.anchorY = 0
    bgComp1:setFillColor( .88 )
    screen:insert(bgComp1)
    local bgComp2 = display.newRoundedRect( midW, posY+50, 716, 336, 10 )
    bgComp2.anchorY = 0
    bgComp2:setFillColor( 1 )
    screen:insert(bgComp2)
    
    -- Title
    local bgTitle = display.newRoundedRect( midW, posY+50, 720, 20, 10 )
    bgTitle.anchorY = 0
    bgTitle:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(bgTitle)
    local bgTitleX = display.newRect( midW, posY+60, 720, 10 )
    bgTitleX.anchorY = 0
    bgTitleX:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(bgTitleX)
    
	--btn perfil
	btnViewProfile = display.newRoundedRect( midW, posY, 720, 70, 10 )
    btnViewProfile.anchorY = 0
	btnViewProfile.id = 0
    btnViewProfile:setFillColor( 68/255, 14/255, 98/255 )
    screen:insert(btnViewProfile)
	--btnViewProfile:addEventListener( 'tap', showProfiles )
	local lblViewProfile = display.newText({
        text = "Ver perfil",
        x = midW, y = posY + 32,
        font = native.systemFontBold,
        fontSize = 32, align = "left"
    })
    lblViewProfile:setFillColor( 1 )
    screen:insert(lblViewProfile)
	
end

-----------------------------------------------
-- Mostramos el detalle en recuadro dinamico
-----------------------------------------------
function showInfoButton()

	local posY = 920 + h
	---  FIX FULL  ---
    local opt = {
        {icon = 'icoFilterCity'}, 
        {icon = 'icoFilterLanguage'}, 
        {icon = 'icoFilterCheck', icon2= 'icoFilterUnCheck'}, 
        {icon = 'icoFilterCheckAvailble', icon2= 'icoFilterUnCheck'}} 
    for i=1, 4 do
       --[[]] detail[i] = {}
        detail[i].icon = display.newImage( "img/"..opt[i].icon..".png" )
        detail[i].icon:translate( -100, 0 )
        bottomCmp:insert(detail[i].icon)
        if opt[i].icon2 then
            detail[i].icon2 = display.newImage( "img/"..opt[i].icon2..".png" )
            detail[i].icon:translate( -100, 0 )
            bottomCmp:insert(detail[i].icon2)
        end
        detail[i].lbl = display.newText({
            text = "", 
            x = 0, y = 0,
            width = 0,
            font = native.systemFont
        })
        detail[i].alpha = 0
        bottomCmp:insert(detail[i].lbl)
    end
    ---  ------ ---
    
	--btn perfil
	btnViewProfile = display.newRect( midW, intH - 130, intW, 120 )
    btnViewProfile.anchorY = 0
	btnViewProfile.id = 0
    btnViewProfile:setFillColor( 0/255, 174/255, 239/255 )
    bottomCmp:insert(btnViewProfile)
	local lblViewProfile = display.newText({
        text = "VER PERFIL",
        x = midW, y = intH - 70,
        font = native.systemFontBold,
        fontSize = 32, align = "left"
    })
    lblViewProfile:setFillColor( 1 )
    bottomCmp:insert(lblViewProfile)
	
end

-- Limpiamos imagenes con 7 dias de descarga
function clearTempDir()
    local lfs = require "lfs"
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )
    local destDir = system.TemporaryDirectory  -- where the file is stored
    local lastTwoWeeks = os.time() - 1209600
	
    for file in lfs.dir(doc_path) do
        -- file is the current file or directory name
        local file_attr = lfs.attributes( system.pathForFile( file, destDir  ) )
        -- Elimina despues de 2 semanas
        if file_attr.modification < lastTwoWeeks then
           os.remove( system.pathForFile( file, destDir  ) ) 
        end
    end
end

function buildHome()
	
end

---------------------------------- DEFAULT SCENE METHODS ----------------------------------

-------------------------------------
-- Se llama antes de mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:create( event )
	screen = self.view
    screen.y = h
    local isH = (intH - h) >  1270
	
	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )
	
    local o = display.newRoundedRect( midW, midH + h, intW+8, intH, 20 )
    o.fill = { type="image", filename="img/fillPattern.png" }
    o.fill.scaleX = .2
    o.fill.scaleY = .2
    screen:insert(o)
	
	display.setDefault( "textureWrapX", "clampToEdge" )
	display.setDefault( "textureWrapY", "clampToEdge" )
    
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	local lastY = 90 + h 
	
	grpHome = display.newGroup()
	screen:insert(grpHome)
	--grpHome.y = h
	
	container = display.newContainer( intW, 900 )
	container:translate( midW , lastY + 75)
	container.anchorY = 0
    screen:insert(container)
	
	container.alpha = 0
	
    topCmp = display.newGroup()
    container:insert(topCmp)
	topCmp.x = - 384
	topCmp.y = - 500
	
    -- Content profile
	
	local bgCard0 = display.newRect( midW, 102, intW, 515 )
    bgCard0.anchorY = 0
    bgCard0:setFillColor( 11/225, 163/225, 212/225 )
    topCmp:insert(bgCard0)
	
    local bgCard = display.newRoundedRect( midW, 52, 615, 615, 20 )
    bgCard.anchorY = 0
    bgCard:setFillColor( 11/225, 163/225, 212/225 )
    topCmp:insert(bgCard)
    
    bgAvatar = display.newRect( midW, 60, 600, 600 )
    bgAvatar.anchorY = 0
    bgAvatar:setFillColor( 0, 193/225, 1 )
    topCmp:insert(bgAvatar)
    
    local tmpAvatar = display.newImage("img/avatar.png")
    tmpAvatar.anchorY = 0
    tmpAvatar.alpha = .5
    tmpAvatar:translate(midW, 197)
    topCmp:insert( tmpAvatar )
    
    profiles = display.newGroup()
    topCmp:insert(profiles)
    
    -- Personal data
    lblName = display.newText({
        text = "", 
        x = 420, y = 710,
        width = 680,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( 0 )
    topCmp:insert(lblName)
	
	--[[lblAge = display.newText({
        text = "", 
        x = 420, y = 760,
        width = 680,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblAge:setFillColor( 0 )
    topCmp:insert(lblAge)]]
	
    lblInts = display.newText({
        text = "", 
        x = 420, y = 760,
        width = 680,
        font = native.systemFont, 
        fontSize = 28, align = "left"
    })
    lblInts:setFillColor( 0 )
    topCmp:insert(lblInts)
    
	bottomCmp = display.newGroup()
	screen:insert(bottomCmp)
	bottomCmp.alpha = 0
	showInfoButton()
	grpLoad = display.newGroup()
	screen:insert(grpLoad)
	grpLoad.y = 650 + h
	tools:setLoadingPerson(true,grpLoad)
	clearTempDir()
    
	grpLoad2 = display.newGroup()
    grpLoad2.cards = true
	screen:insert(grpLoad2)
	grpLoad2.y = 840 + h
	grpLoad2.x = midW - 80
    
	--RestManager.getUsersById()
	if typeSearch == "welcome" then
		RestManager.getUsersByCity(0)
	else
		RestManager.getUsersByFilter(0)
	end
    --
	limitCard = 5
	if isReadOnly == false then
		timeMarker = timer.performWithDelay( 1000, function( event )
			if playerId ~= 0 then
				timer.cancel( event.source ) 
				--RestManager.updatePlayerId()
			end
		end, -1)
	end
	
	tools:toFront()
end	

-------------------------------------
-- Se llama al mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:show( event )

	--[[local prevScene = composer.getSceneName( "previous" )
	if prevScene == "src.MyProfile" then
		--RestManager.getUsersById()
	end]]
	
end

function makeTimeStamp( dateString )
   local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d%d)%:?(%d%d)"
   local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern)
   local timestamp = os.time(
      { year=year, month=month, day=day, hour=hour, min=minute, sec=seconds }
   )
   local offset = 0
   if ( tzoffset ) then
      if ( tzoffset == "+" or tzoffset == "-" ) then  -- We have a timezone
         offset = offsethour * 60 + offsetmin
         if ( tzoffset == "-" ) then
            offset = offset * -1
         end
         timestamp = timestamp + offset
      end
   end
   return timestamp
end
 

-------------------------------------
-- Se llama al cambiar la escena
-- @param event objeto evento
------------------------------------
function scene:hide( event )
	
end

-------------------------------------
-- Se llama al destruirse la escena
-- @param event objeto evento
------------------------------------
function scene:destroy( event )
end

-- Listeners de la Escena
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene