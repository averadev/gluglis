
local mediaRes = display.pixelWidth  / 768

application = {
	content = {
		width = display.pixelWidth / mediaRes,
        height = display.pixelHeight / mediaRes
	},
    notification = {
        iphone = {
            types = { "badge", "sound", "alert" }
        }
    }
}