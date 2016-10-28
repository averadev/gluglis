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
local facebook = require("plugin.facebook.v4")
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')


-- Grupos y Contenedores
local screen
local scene = composer.newScene()
local grpMenu, grpLoadMenu, grpLogOut

-- Variables

---------------------------------- FUNCIONES ----------------------------------

-------------------------------------
-- Asignamos total de tarjetas
------------------------------------

function gotoMyProfle()
	composer.removeScene( "src.MyProfile" )
	composer.gotoScene("src.MyProfile", { time = 400, effect = "fade", params = { item = itemProfile } } )
	return true
end


function gotoSearch()
	composer.removeScene( "src.Filter" )
	composer.gotoScene( "src.Filter", { time = 400, effect = "fade" } )
	return true
end

function logOut()
	tools:setLoading(true,grpLoadMenu)
	itemProfile = nil
	RestManager.clearUser()
	return true
end

function resultCleanUser()
	tools:setLoading(false,grpLoadMenu)
	local message = "Sesión Cerrada \ncon exito"
	if not isReadOnly then
		messageLogOut(true,message )
	end
	timeMarker = timer.performWithDelay( 1000, function()
		--if isTrue == true then	
		DBManager.clearUser()
		facebook.logout()
		messageLogOut(false, message)
		composer.removeScene( "src.LoginSplash" )
		composer.gotoScene( "src.LoginSplash", { time = 400, effect = "fade" } )
		--end
		
	end, 1 )
end

function messageLogOut(isOpen, message)
	if isOpen then
		if grpLogOut then
			grpLogOut:removeSelf()
			grpLogOut = nil
		end
		
		grpLogOut = display.newGroup()
		
		local bg0 = display.newRect( midW, midH + h, intW, intH )
		bg0:setFillColor( .95 )
		bg0.alpha = .3
		grpLogOut:insert( bg0 )
		bg0:addEventListener( 'tap', noAction )
		
		local bg1 = display.newRect( midW, midH + h + 135, intW, intH )
		bg1:setFillColor( 245/255 )
		grpLogOut:insert( bg1 )
		bg1:addEventListener( 'tap', noAction )
		
		local iconMessage = display.newImage("img/cerrada.png")
		--iconMessage.anchorX = 0
		iconMessage:translate(midW, intH / 3 )
		grpLogOut:insert( iconMessage )
		
		local iconMessage0 = display.newImage("img/circulo-cerrada.png")
		--iconMessage.anchorX = 0
		iconMessage0:translate(midW, intH / 3 )
		grpLogOut:insert( iconMessage0 )
		
		local lblMessage = display.newText({
			text = message, 
			x = midW, y = intH / 3 + 200,
			font = fontFamilyLight,   
			fontSize = 34, align = "center"
		})
		lblMessage:setFillColor( 166/255, 164/255, 156/255 )
		grpLogOut:insert(lblMessage)
		
		--cerrada
		
	else
		if grpLogOut then
			grpLogOut:removeSelf()
			grpLogOut = nil
		end
	end
	--if grpLogOut 
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
	
	grpMenu = display.newGroup()
	screen:insert(grpMenu)
	
	grpLoadMenu = display.newGroup()
	screen:insert(grpLoadMenu)
	--grpLoadMenu.y = 650 + h
	
	local posY = 190 + h 
	
	local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	grpMenu:insert(line)
	
	local btnSearch = display.newRect( midW, posY, intW, 200 )
	btnSearch.anchorY = 0
	btnSearch:setFillColor( 1 )
    grpMenu:insert(btnSearch)
	btnSearch:addEventListener( 'tap', gotoSearch )
	
	local iconSearch = display.newImage("img/buscar.png")
	iconSearch.anchorX = 0
    iconSearch:translate(100, posY + 100)
    grpMenu:insert( iconSearch )
	
	local lblSearch = display.newText({
        text = "Buscar Gluglers", 
        x = 500, y = posY + 65,
        width = 490,
        font = fontFamilyBold,   
        fontSize = 46, align = "left"
    })
    lblSearch:setFillColor( 0 )
    grpMenu:insert(lblSearch)
	
	local lblSubSearch = display.newText({
        text = "Conoce usuarios Gluglis \ndonde quiera que vayas.", 
        x = 500, y = posY + 130,
        width = 490,
        font = fontFamilyRegular,   
        fontSize = 26, align = "left"
    })
    lblSubSearch:setFillColor( 0 )
    grpMenu:insert(lblSubSearch)
	
	posY = posY + 200
	
	local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
	line:setStrokeColor( 227/255 )
	line.strokeWidth = 3
	grpMenu:insert(line)
	
	---------------------
	
	posY = posY + 75
	
	if not isReadOnly then
	
		local line = display.newLine( 0, posY - 1 , intW, posY - 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpMenu:insert(line)
		
		local btnEdit = display.newRect( midW, posY, intW, 200 )
		btnEdit.anchorY = 0
		btnEdit:setFillColor( 1 )
		grpMenu:insert(btnEdit)
		btnEdit:addEventListener( 'tap', gotoMyProfle )
		
		local iconEdit = display.newImage("img/editar.png")
		iconEdit.anchorX = 0
		iconEdit:translate(100, posY + 100)
		grpMenu:insert( iconEdit )
		
		local lblEdit = display.newText({
			text = "Editar Perfil", 
			x = 500, y = posY + 65,
			width = 490,
			font = fontFamilyBold,   
			fontSize = 46, align = "left"
		})
		lblEdit:setFillColor( 0 )
		grpMenu:insert(lblEdit)
		
		local lblSubEdit = display.newText({
			text = "Editar tu perfil personal.", 
			x = 500, y = posY + 120,
			width = 490,
			font = fontFamilyRegular,   
			fontSize = 26, align = "left"
		})
		lblSubEdit:setFillColor( 0 )
		grpMenu:insert(lblSubEdit)
		
		posY = posY + 200
	
		local line = display.newLine( 0, posY + 1 , intW, posY + 1 )
		line:setStrokeColor( 227/255 )
		line.strokeWidth = 3
		grpMenu:insert(line)
	
	end
	
	
	
	local line = display.newLine( 0, intH - 176 , intW, intH - 176 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpMenu:insert(line)
	
	local btnLogout = display.newRect( midW, intH - 175, intW, 150 )
	btnLogout.anchorY = 0
	btnLogout:setFillColor( 226/255 )
    grpMenu:insert(btnLogout)
	btnLogout:addEventListener( 'tap', logOut )
	
	txtLogout = "Registrarse"
	
	if not isReadOnly then
		txtLogout = "Cerrar Sesión"
	end
	
	local lblLogoutt = display.newText({
        text = txtLogout, 
        x = midW, y = intH - 95,
        font = fontFamilyBold,   
        fontSize = 38, align = "left"
    })
    lblLogoutt:setFillColor( 85/255 )
    grpMenu:insert(lblLogoutt)
	
	local line = display.newLine( 0, intH - 26 , intW, intH - 26 )
	line:setStrokeColor( 216/255 )
	line.strokeWidth = 3
	grpMenu:insert(line)
	
end	

-------------------------------------
-- Se llama al mostrarse la escena
-- @param event objeto evento
------------------------------------
function scene:show( event )
	bubble()
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