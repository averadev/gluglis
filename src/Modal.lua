
require('src.Globals')
local Sprites = require('src.Sprites')
local DBManager = require('src.DBManager')

---------------------------------------------------------------------------------
-- PARTNER
---------------------------------------------------------------------------------
Modal = {}
function Modal:new()
    -- Variables
    local fxError = audio.loadSound( "fx/error.wav")
    local fxSave = audio.loadSound( "fx/save.wav")
    local grpModal = display.newGroup()
    local txtClave, txtNombre, lblMessage, loading, tableDB, actionDB
    
    function saveRow(event)
        local t = event.target
        lblMessage.text = ""
        t.alpha = 0
        
        local item = { 
            key = "PRY03", --txtClave.text,
            name = "Nombre nuevo" --txtNombre.text
        }
        item.key = item.key:upper()
        item.name = item.name:upper()

        if item.key == '' or item.name == '' then
            audio.play(fxError)
            lblMessage.text = "*Error: Los campos son obligatorios"
        elseif actionDB == 'insert' then
            local msg = DBManager.insertRow(tableDB, item)
            if msg == "ERROR" then
                audio.play(fxError)
                lblMessage.text = "*Error: La Clave ya existe"
            end
        else
            item.id = txtClave.id
            local msg = DBManager.updateRow(tableDB, item)
            if msg == "ERROR" then
                audio.play(fxError)
                lblMessage.text = "*Error: La nueva Clave ya existe"
            end
        end
        
        if lblMessage.text == "" then
            audio.play(fxSave)
            grpModal:removeSelf()
            grpModal = nil
        end
        -- Return button
        t.alpha = 1
        return true;
    end
    
    function deleteRow(event)
        
    end
    
    function grpModal:closeWindow(event)
        if grpModal then
            grpModal:removeSelf()
            grpModal = nil
        end
    end
    
    -- Creamos la pantalla del menu
    function grpModal:saveRow(current, action, item)
        tableDB = current
        actionDB = action
        local title = ""
        if tableDB == 'project' and actionDB == 'insert' then
            title = "AGREGAR NUEVO PROYECTO"
        elseif tableDB == 'project' and actionDB == 'update' then
            title = "MODIFICAR PROYECTO: "..item.key
        end
        
        local bgModal = display.newRect( midW, midH, intW, intH )
        bgModal.alpha = .5
        bgModal:setFillColor( 0 )
        bgModal:addEventListener( 'tap', bgBlock)
        grpModal:insert(bgModal)

        local bg = display.newRoundedRect( midW, hm3, 500, 400, 10 )
        bg:setFillColor( 1 )
        grpModal:insert(bg)

        local lineTop = display.newRect( midW, hm3 - 140, 500, 2 )
        lineTop:setFillColor( .7 )
        grpModal:insert(lineTop)

        local txtTitle = display.newText({
            text = title,     
            x = midW, y = hm3 - 170,
            font = "Lato Light",   
            fontSize = 20, align = "center"
        })
        txtTitle:setFillColor( .1 )
        grpModal:insert(txtTitle)

        -- Campos
        local lblClave = display.newText({
            text = "Clave:",     
            x = midW - 130, y = hm3 - 80,
            width = 150, font = "Lato Light",   
            fontSize = 20, align = "left"
        })
        lblClave:setFillColor( .1 )
        grpModal:insert(lblClave)

        txtClave = native.newTextField( midW - 110, hm3 - 80, 150, 60 )
        txtClave.anchorX = 0
        txtClave.hasBackground = false
        --txtClave:addEventListener( "userInput", onTxtFocus )
        grpModal:insert(txtClave)

        local line1 = display.newLine( midW - 103, hm3 - 70, midW - 100, hm3 - 60, midW + 30, hm3 - 60, midW + 33, hm3 - 70 )
        line1:setStrokeColor( 0, .5, 0, .4 )
        line1.strokeWidth = 2
        grpModal:insert(line1)

        local lblNombre = display.newText({
            text = "Nombre:",     
            x = midW - 130, y = hm3 + 20,
            width = 150, font = "Lato Light",   
            fontSize = 20, align = "left"
        })
        lblNombre:setFillColor( .1 )
        grpModal:insert(lblNombre)

        txtNombre = native.newTextField( midW - 110, hm3 + 20, 300, 60 )
        txtNombre.anchorX = 0
        txtNombre.hasBackground = false
        --txtNombre:addEventListener( "userInput", onTxtFocus )
        grpModal:insert(txtNombre)

        local line2 = display.newLine( midW - 103, hm3 + 30, midW - 100, hm3 + 40, midW + 180, hm3 + 40, midW + 183, hm3 + 30 )
        line2:setStrokeColor( 0, .5, 0, .4 )
        line2.strokeWidth = 2
        grpModal:insert(line2)
        
        lblMessage = display.newText({
            text = "",
            x = midW - 30, y = hm3 + 90,
            width = 350, font = "Lato Light",   
            fontSize = 20, align = "left"
        })
        lblMessage:setFillColor( .7, 0, 0 )
        grpModal:insert(lblMessage)

        -- Botones
        local iconClose = display.newImage("img/iconClose.png")
        iconClose:translate(midW + 220, hm3 - 170, 45)
        iconClose:addEventListener( 'tap', closeModal)
        grpModal:insert( iconClose )

        local btnAceptar1 = display.newRoundedRect( midW + 160, hm3 + 150, 150, 50, 5 )
        btnAceptar1:setFillColor( 178/255, 216/255, 255/255 )
        btnAceptar1:addEventListener( 'tap', saveRow)
        grpModal:insert(btnAceptar1)

        local btnAceptar2 = display.newRoundedRect( midW + 160, hm3 + 150, 144, 44, 5 )
        btnAceptar2.alpha = .8
        btnAceptar2:setFillColor( 1 )
        grpModal:insert(btnAceptar2)

        local txtAceptar = display.newText({
            text = "ACEPTAR",     
            x = midW + 160, y = hm3 + 150,
            font = "Lato Light",   
            fontSize = 20, align = "center"
        })
        txtAceptar:setFillColor( .1 )
        grpModal:insert(txtAceptar)
        
        if item then
            txtClave.id = item.id
            txtClave.text = item.key
            txtNombre.text = item.name
            txtAceptar.text = "MODIFICAR"
            
            local btnEliminar1 = display.newRoundedRect( midW - 160, hm3 + 150, 150, 50, 5 )
            btnEliminar1:setFillColor( 255/255, 178/255, 178/255 )
            btnEliminar1:addEventListener( 'tap', saveRow)
            grpModal:insert(btnEliminar1)

            local btnEliminar2 = display.newRoundedRect( midW - 160, hm3 + 150, 144, 44, 5 )
            btnEliminar2.alpha = .8
            btnEliminar2:setFillColor( 1 )
            grpModal:insert(btnEliminar2)

            local txtEliminar = display.newText({
                text = "ELIMINAR",     
                x = midW - 160, y = hm3 + 150,
                font = "Lato Light",   
                fontSize = 20, align = "center"
            })
            txtEliminar:setFillColor( .1 )
            grpModal:insert(txtEliminar)
        end
        
        
    end

    return grpModal
end
