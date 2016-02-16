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
