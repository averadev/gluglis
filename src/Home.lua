---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.Globals')
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
    
    elemCards[idx].bgL = display.newRoundedRect( midW, 150, intW - 160, 700, 10 )
    elemCards[idx].bgL.anchorY = 0
    elemCards[idx].bgL:setFillColor( 11/225, 163/225, 212/225 )
    grpCards[idx]:insert(elemCards[idx].bgL)
    local maskbgl = graphics.newMask( "img/maskbgl.jpg" )
    elemCards[idx].bgL:setMask( maskbgl )
    
    elemCards[idx].bgR = display.newRoundedRect( midW, 150, intW - 160, 700, 10 )
    elemCards[idx].bgR.anchorY = 0
    elemCards[idx].bgR:setFillColor( 11/225, 163/225, 212/225 )
    grpCards[idx]:insert(elemCards[idx].bgR)
    local maskbgr = graphics.newMask( "img/maskbgr.jpg" )
    elemCards[idx].bgR:setMask( maskbgr )
    
    elemCards[idx].fL = display.newRect( midW, 172, 558, 558 )
    elemCards[idx].fL.anchorY = 0
    elemCards[idx].fL:setFillColor( 0, 193/225, 1 )
    grpCards[idx]:insert(elemCards[idx].fL)
    local maskfl = graphics.newMask( "img/maskfl.jpg" )
    elemCards[idx].fL:setMask( maskfl )
    
    elemCards[idx].fR = display.newRect( midW, 172, 558, 558 )
    elemCards[idx].fR.anchorY = 0
    elemCards[idx].fR:setFillColor( 0, 193/225, 1 )
    grpCards[idx]:insert(elemCards[idx].fR)
    local maskfr = graphics.newMask( "img/maskfr.jpg" )
    elemCards[idx].fR:setMask( maskfr )
    
    elemCards[idx].aL = display.newImage("img/tmp/face01.png")
    elemCards[idx].aL.anchorY = 0
    elemCards[idx].aL:translate(midW, 176)
    grpCards[idx]:insert( elemCards[idx].aL )
    local maskal = graphics.newMask( "img/maskal.jpg" )
    elemCards[idx].aL:setMask( maskal )
    
    elemCards[idx].aR = display.newImage("img/tmp/face01.png")
    elemCards[idx].aR.anchorY = 0
    elemCards[idx].aR:translate(midW, 176)
    grpCards[idx]:insert( elemCards[idx].aR )
    local maskar = graphics.newMask( "img/maskar.jpg" )
    elemCards[idx].aR:setMask( maskar )
    
    
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
    
    local bg = display.newRect( 0, 0, intW, intH )
    bg.anchorX = 0
    bg.anchorY = 0
    bg:setFillColor( 1 )
    screen:insert(bg)
	
    tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    local bgBtn = display.newRoundedRect( midW, 870, intW - 160, 70, 10 )
    bgBtn.anchorY = 0
    bgBtn:setFillColor( 129/225, 61/225, 153/225 )
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
    bg:addEventListener( "touch", touchScreen )
    
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