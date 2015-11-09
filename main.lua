---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

display.setStatusBar( display.DarkStatusBar )
local composer = require( "composer" )
local DBManager = require('src.DBManager')
display.setDefault( "background", .91 )


local isUser = DBManager.setupSquema()
composer.gotoScene("src.Home")
