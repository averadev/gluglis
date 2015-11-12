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
require('src.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, scrMs
local scene = composer.newScene()

-- Variables
local tmpList = {
    {id = 1, photo = "mariana.jpeg", name = 'Mariana Gomez',    subject = 'Hola!, me gustaría contactarte, soy de Vene...'},
    {id = 2, photo = "marcos.jpg", name = 'Marcos Jimenez',   subject = 'Oye amigo, como te fue en tu viaje en Hola?...'},
    {id = 3, photo = "andrew.jpg", name = 'Andrew Patterson', subject = 'Hola Ricardo!, te envie un presente por men...'},
    {id = 4, photo = "janine.jpg", name = 'Janine Smith',     subject = 'Hola Guapo, voy de visita a tu ciudad y me ...'},
    {id = 5, photo = "victoria.jpg", name = 'Victoria Beckham', subject = 'Hey Ricardito, hace tiempo que no te he vis...'}
}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function tapMessage(event)
    local t = event.target
    t:setFillColor( 89/255, 31/255, 103/255 )
    timer.performWithDelay(200, function() t:setFillColor( 1 ) end, 1)
    audio.play(fxTap)
    composer.removeScene( "src.Message" )
    composer.gotoScene( "src.Message", { time = 400, effect = "slideLeft", params = { item = t.item } } )
end

function buildListMsg()
    local posY = -50
    for i = 1, #tmpList do
        -- Bg
        posY = posY + 150
        local bg0 = display.newRect( midW, posY, intW, 148 )
        bg0:setFillColor( .5 )
        bg0.alpha = .05
        scrMs:insert(bg0)
        local bg = display.newRect( midW, posY, intW, 140 )
        bg:setFillColor( 1 )
        bg.item = tmpList[i]
        bg:addEventListener( 'tap', tapMessage)
        scrMs:insert(bg)
        -- Image
        local avatar = display.newImage("img/tmp/"..tmpList[i].photo)
        avatar:translate(90, posY)
        avatar.width = 130
        avatar.height = 130
        scrMs:insert( avatar )
        
        local maskMA = display.newImage("img/maskCircle130.png")
        maskMA:translate(90, posY)
        scrMs:insert( maskMA )
        -- Name
        local lblName = display.newText({
            text = tmpList[i].name,     
            x = midW + 90, y = posY - 20,
            width = 600,
            font = native.systemFontBold,   
            fontSize = 35, align = "left"
        })
        lblName:setFillColor( 0 )
        scrMs:insert(lblName)
        -- Subject
        local lblSubject = display.newText({
            text = tmpList[i].subject,     
            x = midW + 90, y = posY + 20,
            width = 600,
            font = native.systemFont,   
            fontSize = 25, align = "left"
        })
        lblSubject:setFillColor( .3 )
        scrMs:insert(lblSubject)
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
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
    
    scrMs = widget.newScrollView
    {
        top = 150,
        left = 0,
        width = intW,
        height = intH - 150,
        scrollWidth = 600,
        scrollHeight = 800,
        hideBackground = true
    }
    screen:insert(scrMs)   
    
    buildListMsg()
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