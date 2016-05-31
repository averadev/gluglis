---------------------------------------------------------------------------------
-- Gluglis
-- Alberto Vera Espitia
-- GeekBucket 2015
---------------------------------------------------------------------------------

-- Mediciones de pantalla
intW = display.contentWidth
intH = display.contentHeight
midW = display.contentCenterX
midH = display.contentCenterY
hm3 = intH / 3
h = display.topStatusBarContentHeight
--token de notificaciones
playerId = 0
--info del usuario
itemProfile = nil
--si no existen datos de session
isReadOnly = false
--bg del componente de ciudad
bgCompCity = nil
--indica si algun componente esta activo en la scena
componentActive = false
timeZone = ""
typeSearch = "welcome"
if ( system.getInfo( "environment" ) == "simulator" ) then
    timeZone = "-0500"
else
	timeZone = os.date( "%z" )
end
