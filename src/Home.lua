---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local composer = require( "composer" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local isCard = false
local direction = 0
local grpCards = {}
local elemCards = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function firstCards()
    
    buildCard()
    
end

function buildCard()
    local idx = #grpCards + 1
    elemCards[idx] = {}
    grpCards[idx] = display.newGroup()
    screen:insert(grpCards[idx])
    
    elemCards[idx].f = display.newRect( midW, 172, 558, 558 )
    elemCards[idx].f.anchorY = 0
    elemCards[idx].f:setFillColor( 0, 193/225, 1 )
    grpCards[idx]:insert(elemCards[idx].f)
    
    elemCards[idx].a = display.newImage("img/tmp/hugo.jpg")
    elemCards[idx].a.anchorY = 0
    elemCards[idx].a:translate(midW, 176)
    grpCards[idx]:insert( elemCards[idx].a )
    
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" then
        print("yStart-"..event.yStart)
        print("xStart-"..event.xStart)
        if event.yStart > 140 and event.yStart < 820 then
            isCard = true
            direction = 0
        end
    elseif event.phase == "moved" and (isCard) then
        local x = (event.x - event.xStart)
        print("x: "..x)
        if direction == 0 then
            if x < -10 then
                direction = 1
            elseif x > 10 then
                direction = -1
            end
        elseif direction == 1 then
            elemCards[1].aR.width = 550 + (x * 2)
            elemCards[1].fR.width = 558 + (x * 2)
            elemCards[1].bgR.width = 608 + (x * 2.2)
        elseif direction == -1 then
            elemCards[1].aL.width = 550 - (x * 2)
            elemCards[1].fL.width = 558 - (x * 2)
            elemCards[1].bgL.width = 608 - (x * 2.2)
            
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        elemCards[1].aL.width = 550
        elemCards[1].fL.width = 558
        elemCards[1].bgL.width = 608
        
        elemCards[1].aR.width = 550
        elemCards[1].fR.width = 558
        elemCards[1].bgR.width = 608
        
        isCard = false
        direction = 0
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
    
    -- Content profile
    local bgCard = display.newRoundedRect( midW, 150, intW - 160, 700, 10 )
    bgCard.anchorY = 0
    bgCard:setFillColor( 11/225, 163/225, 212/225 )
    screen:insert(bgCard)
    -- Personal data
    local lblName = display.newText({
        text = "Ricardo Rodriguez", 
        x = 420, y = 760,
        width = 600,
        font = native.systemFontBold,   
        fontSize = 30, align = "left"
    })
    lblName:setFillColor( 1 )
    screen:insert(lblName)
    local lblAge= display.newText({
        text = "24 Años", 
        x = 420, y = 795,
        width = 600,
        font = native.systemFont, 
        fontSize = 28, align = "left"
    })
    lblAge:setFillColor( 1 )
    screen:insert(lblAge)
    local lblInts = display.newText({
        text = "Amante de la Musica", 
        x = 420, y = 820,
        width = 600,
        font = native.systemFont, 
        fontSize = 22, align = "left"
    })
    lblInts:setFillColor( 1 )
    screen:insert(lblInts)
    
    -- Buton
    local bgBtn = display.newRoundedRect( midW, 870, intW - 160, 70, 10 )
    bgBtn.anchorY = 0
    bgBtn:setFillColor({
        type = 'gradient',
        color1 = { 129/255, 61/255, 153/255 }, 
        color2 = { 89/255, 31/255, 103/255 },
        direction = "bottom"
    })
    screen:insert(bgBtn)
    
    -- Circles
    local circle1 = display.newRoundedRect( midW - 50, 905, 25, 25, 13 )
    circle1:setFillColor( 1 )
    screen:insert(circle1)
    local circle2 = display.newRoundedRect( midW, 905, 25, 25, 13 )
    circle2:setFillColor( 1 )
    screen:insert(circle2)
    local circle3 = display.newRoundedRect( midW + 50, 905, 25, 25, 13 )
    circle3:setFillColor( 1 )
    screen:insert(circle3)
    
    firstCards()
    --o:addEventListener( "touch", touchScreen )
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