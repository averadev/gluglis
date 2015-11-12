---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

display.setStatusBar( display.TranslucentStatusBar )
local composer = require( "composer" )
local DBManager = require('src.DBManager')
display.setDefault( "background", 0 )
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

local isUser = DBManager.setupSquema()
composer.gotoScene("src.Login")
