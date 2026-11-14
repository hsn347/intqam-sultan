local baseProxy = require("fgui.base.baseProxy")
local heroAwakeTimesPopProxy = class("heroAwakeTimesPopProxy", baseProxy)
function heroAwakeTimesPopProxy:onRegisterEvent()
	print("=======heroAwakeTimesPopProxy:onRegisterEvent")
end
return heroAwakeTimesPopProxy
