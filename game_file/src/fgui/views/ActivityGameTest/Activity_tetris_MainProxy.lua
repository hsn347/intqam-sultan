local baseProxy = require("fgui.base.baseProxy")
local Activity_tetris_MainProxy = class("Activity_tetris_MainProxy", baseProxy)
function Activity_tetris_MainProxy:onRegisterEvent()
	print("=======Activity_tetris_MainProxy:onRegisterEvent")
end
return Activity_tetris_MainProxy
