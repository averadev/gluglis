---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
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
local limitCard = 5
local totalCard = 0
local isReady = true
local isFirstI = true
local grpHome
local lastY = 0
local iniY = 220
local endY = 980

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
	tools:setLoading(false,grpLoad2)
	bottomCmp.alpha = 1
	topCmp.alpha = 1
	--container.alpha = 1
	for i = 1, #items, 1 do
		table.insert( loadUsers, items[i] )
	end
	
	--cargamos los usuarios
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
		HomeError( language.HNoUserFound )
	end
end

----------------------------------------------------------
-- Muestra un mensaje si ocurre error al mostrar la info
-- @param message texto de informacion que se mostrara
----------------------------------------------------------
function HomeError( message )
    btnViewProfile.alpha = 0
	tools:setLoading(false,grpLoad)
	
	if topCmp then
		topCmp:removeSelf()
		topCmp = nil
	end
	
	topCmp = display.newGroup()
	topCmp.y = intH / 4
	
	grpHome:insert(topCmp)
    --container:insert(topCmp)
	--topCmp.x = - 384
	--topCmp.y = - 500
		
	local imgNoResultHome = display.newImage( "img/Vector Smart Object2-01.png" )
	imgNoResultHome:translate( midW, 360 )
	topCmp:insert(imgNoResultHome)
	bottomCmp.alpha = 1
	--container.alpha = 1
	topCmp.alpha = 1
	
	local lblnoResultHome = display.newText({
        text = language.HNoResultHome, 
        x = midW, y = 620,
        font = fontFamilyLight,   
        fontSize = 30, align = "center"
    })
    lblnoResultHome:setFillColor( 100/255 )
    topCmp:insert(lblnoResultHome)
	
end

-------------------------------------
-- Muestra imagenes y mascaras
-- @param item registro que incluye el nombre de la imagen
------------------------------------
function buildCard(item)

	--obtiene el tamaño de las imagenes
	local grpImage = display.newGroup()
	grpImage.alpha = 0
	grpImage.y = midH
	grpImage.x = midW
	local img = display.newImage( item.image, system.TemporaryDirectory )
	grpImage:insert(img)
	local imgWidth = img.contentWidth 
	local imgHeight = img.contentHeight
	if imgWidth < 600 then
		img.width = 600
	end
	if imgHeight < 600 then
		img.height = 600
	end
	
	grpImage:removeSelf()
	grpImage = nil

    local idx = #avaL + 1
	local imgS = nil
	
	--ajusta el tamaño de la mascara
	local WidthSheet = imgWidth/2
	local integralPart, fractionalPart = math.modf( WidthSheet )
	if ( fractionalPart == 0 ) then
		imgWidth = math.round( imgWidth/2 )
	else
		imgWidth = math.round( imgWidth/2 ) - 1
	end
	
	--monta la mascara
	imgS = graphics.newImageSheet(  item.image, system.TemporaryDirectory, { width = imgWidth, height = imgHeight, numFrames = 2 })
    
    avaL[idx] = display.newRect( midW, 60, 360, 720 )
    avaL[idx].alpha = 0
    avaL[idx].anchorY = 0
    avaL[idx].anchorX = 1
	avaL[idx].id = item.id
    avaL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    profiles:insert(avaL[idx])
    
    avaR[idx] = display.newRect( midW, 60, 360, 720 )
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


-------------------------------------
-- Asigna informacion del usuario actual
-- @param idx posicion del registro
------------------------------------
function setInfo(idx)
	--name
    lblName.text = loadUsers[idx].userName
	--# edad
    if loadUsers[idx].edad then 
        lblName.text = lblName.text .." # "..  loadUsers[idx].edad.. " " .. language.HYears
    end
	--residencia actual
	if loadUsers[idx].residencia then 
		lblInts.text = loadUsers[idx].residencia
	else
		lblInts.text = language.HUnregisteredResidence
    end
	btnViewProfile.item = loadUsers[idx]
end


-------------------------------------
-- Listener para el flip del avatar
-- @param event objeto evento
------------------------------------
function touchScreen(event)
    if event.phase == "began" then
		print(event.yStart)
		--local iniY = 220
		--local endY = 980
        if event.yStart > iniY and event.yStart < endY and isReady then
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
                avaR[idxA+1].width = 360
            elseif x > 10 and idxA > 1 then
                direction = -1
                avaL[idxA-1]:toBack()
                avaL[idxA-1].alpha = 1
                avaL[idxA-1].width = 360
            end
        elseif direction == 1 and x <= 0 and xM >= -720 then
            if xM > -360 then
                if avaR[idxA].alpha == 0 then
                    avaL[idxA+1].alpha = 0
                    avaR[idxA].alpha = 1
                    avaR[idxA].width = 0
                end
                -- Move current to left
                avaR[idxA].width = 360 + xM
            else
                if avaL[idxA+1].alpha == 0 then
                    avaR[idxA].alpha = 0
                    avaL[idxA+1]:toFront()
                    avaL[idxA+1].alpha = 1
                    avaL[idxA+1].width = 0
                end
                -- Move new to left
                avaL[idxA+1].width = (xM*-1)-360
            end
        elseif direction == -1 and x >= 0 then
            if xM < 360 then
                if avaL[idxA].alpha == 0 then
                    avaR[idxA-1].alpha = 0
                    avaL[idxA].alpha = 1
                    avaL[idxA].width = 0
                end
                -- Move current to left
                avaL[idxA].width = 360 - xM
            elseif xM < 720 then
                if avaR[idxA-1].alpha == 0 then
                    avaL[idxA].alpha = 0
                    avaR[idxA-1]:toFront()
                    avaR[idxA-1].alpha = 1
                    avaR[idxA-1].width = 0
                end
                -- Move new to left
                avaR[idxA-1].width = xM - 360
            end
            
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local xM = ((event.x - event.xStart) * 3)
        -- To Rigth
        if direction == 1 and xM >= -720 then
            avaR[idxA].alpha = 1
            avaL[idxA+1].alpha = 0
            transition.to( avaR[idxA], { width = 360, time = 200, onComplete=function()
                avaR[idxA+1].alpha = 0
                isReady = true
            end})
        elseif direction == 1 and xM < -720 then
            if idxA % 5 == 0 and #loadUsers < totalCard then
                getProfile()
            end
			avaR[idxA].alpha = 0
            avaL[idxA+1].alpha = 1
            setInfo(idxA+1)
            transition.to( avaL[idxA+1], { width = 360, time = 200, onComplete=function()
                avaL[idxA].alpha = 0
                avaR[idxA].alpha = 0
                idxA = idxA + 1
                isReady = true
            end})
        -- To Left
        elseif direction == -1 and xM <= 720 then
            avaL[idxA].alpha = 1
            avaR[idxA-1].alpha = 0
            transition.to( avaL[idxA], { width = 360, time = 200, onComplete=function()
                avaR[idxA-1].alpha = 0
                isReady = true
            end})
        elseif direction == -1 and xM > 720 then
            avaL[idxA].alpha = 0
            avaR[idxA-1].alpha = 1
            setInfo(idxA-1)
            transition.to( avaR[idxA-1], { width = 360, time = 200, onComplete=function()
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

-----------------------------------------------
-- obtiene la lista de usuarios
-- typeSearch tipo de filtro que se uso
-- limitCard funciona como un paginador
-----------------------------------------------
function getProfile()
	tools:setLoading(true,grpLoad2)
	if typeSearch == "welcome" then
        RestManager.getUsersByCity(limitCard)
		limitCard = limitCard + 5
	else
		RestManager.getUsersByFilter(limitCard)
		limitCard = limitCard + 5
	end
	
end

-----------------------------------------------
-- Mostramos los detalles de los perfiles
-----------------------------------------------
function showInfoButton()
    lastY = lastY + 30
	--btn perfil
	btnViewProfile = display.newRect( midW, lastY, intW, 120 )
    btnViewProfile.anchorY = 0
	btnViewProfile.id = 0
    btnViewProfile:setFillColor( 0/255, 174/255, 239/255 )
    topCmp:insert(btnViewProfile)
	local lblViewProfile = display.newText({
        text = language.HSeeProfile,
        x = midW, y = lastY + 60,
        font = fontFamilyBold,
        fontSize = 32, align = "left"
    })
    lblViewProfile:setFillColor( 1 )
    topCmp:insert(lblViewProfile)
	
	--local poscY = container.height - 90 - h
	--local poscY = 200 - 90 - h
	
	--topCmp.y =  - (poscY / 2)
	--topCmp.y = 400
	
	posY = ( intH - topCmp.height )
	topCmp.y =  posY / 2
	
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

---------------------------------- DEFAULT SCENE METHODS ----------------------------------

-------------------------------------
-- Se llama antes de mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:create( event )
	screen = self.view
    screen.y = h
    local isH = (intH - h) >  1270
	
    local o = display.newRect( midW, midH + h, intW+8, intH )
	o:setFillColor( 245/255 )
    screen:insert(o)
    
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
	
	lastY = midH + 90 + h
	
	grpHome = display.newGroup()
	screen:insert(grpHome)
	
	--[[container = display.newContainer( intW, intH )
	container:translate( midW , lastY)
    screen:insert(container)
	container.alpha = 0]]
	
    --[[topCmp = display.newGroup()
    container:insert(topCmp)
	topCmp.x = - midW
	topCmp.y = - midH]]
	
	topCmp = display.newGroup()
    screen:insert(topCmp)
	topCmp.alpha = 0
	--topCmp.x = - midW
	--topCmp.y =  midH
	
	--topCmp.y = 400
	
    -- Content profile
	
	print(topCmp.y)
	
	local bgCard0 = display.newRect( midW, 75, intW, 700 )
    bgCard0.anchorY = 0
    bgCard0:setFillColor( 0/255, 174/255, 239/255 )
    topCmp:insert(bgCard0)
	
    local bgCard = display.newRect( midW, 52, 740, 740 )
    bgCard.anchorY = 0
	bgCard:setFillColor( 0/255, 174/255, 239/255 )
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
	
	--local iniY = 220
	--local endY = 980
    
    profiles = display.newGroup()
    topCmp:insert(profiles)
	
	lastY = 820
    
    -- Personal data
    lblName = display.newText({
        text = "", 
        x = 420, y = lastY,
        width = 680,
        font = fontFamilyBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( 0 )
    topCmp:insert(lblName)
	
	lastY = lastY + 40
	
    lblInts = display.newText({
        text = "", 
        x = 420, y = lastY,
        width = 680,
        font = fontFamilyRegular, 
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
	tools:setLoading(true,grpLoad)
	clearTempDir()
    
	grpLoad2 = display.newGroup()
    grpLoad2.cards = true
	screen:insert(grpLoad2)
	
	--identifica si muestra la lista de usuario o los demos
	if not isReadOnly then
		if typeSearch == "welcome" then
			RestManager.getUsersByCity(0)
			limitCard = 5
		else
			RestManager.getUsersByFilter(0)
			limitCard = 10
		end
	else
		RestManager.getUsersDemo(0)
	end
    
	posY = ( intH - topCmp.height )
	topCmp.y =  posY / 2
	
	iniY = topCmp.y  + 50
	endY = topCmp.y + 780
	
	tools:toFront()
end	

-------------------------------------
-- Se llama al mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:show( event )
	-- borbuja de mensajes
	bubble()
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