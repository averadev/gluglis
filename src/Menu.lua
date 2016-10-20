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
local grpMenu

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
	itemProfile = nil
	RestManager.clearUser()
	return true
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