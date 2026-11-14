local baseProxy = require("fgui.base.baseProxy")
local LuckyWretchPopProxy = class("LuckyWretchPopProxy", baseProxy)
function LuckyWretchPopProxy:onRegisterEvent()
	print("=======LuckyWretchPopProxy:onRegisterEvent")
end
return LuckyWretchPopProxy
