Menu = {}
function Menu:new()
    -- Variables
    local self = display.newGroup()
    local widget = require( "widget" )
    local h = display.topStatusBarContentHeight
    local intW, intH  = display.contentWidth, display.contentHeight
    local midW, midH  = intW / 2, intH / 2
    local fxTap = audio.loadSound( "fx/click.wav")
    local Menu
    
    -- Bloquea cierre de menu
    function blockTap()
        return true;
    end
    
    -- Cambia pantalla
    function changeScreen(event)
        local t = event.target
        t.alpha = 1
        audio.play(fxTap)
        timer.performWithDelay(200, function() 
            t.alpha = .01
            if t.screen ~= "" then
                local storyboard = require( "storyboard" )
                storyboard.gotoScene("src."..t.screen, { time = 400, effect = "slideLeft" } )
            end
        end)
        
        showMenu()
        return true
    end
    
    -- Creamos la pantalla del menu
    function self:builScreen()
        Menu =  menu
        self.anchorY = 0
        self.y = h
        self.x = -400
        
        local minScr = 260 -- Pantalla pequeña
        if intH > 840 then
            minScr = 300 -- Pantalla alta
        end
        
        -- Background
        local background = display.newRect(200, midH, 400, intH )
        background:setFillColor( .32 )
        background:addEventListener( 'tap', blockTap)
        self:insert(background)
        
        
        -- Border Right
        local borderRight = display.newRect( 398, midH, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        self:insert(borderRight)
    end

    return self
end