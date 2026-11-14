local baseProxy = require("fgui.base.baseProxy")
local flowerRecordViewProxy = class("flowerRecordViewProxy", baseProxy)
function flowerRecordViewProxy:onRegisterEvent()
	print("=======flowerRecordViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_FLOWER_HISTORY", handler(self, self.initData))
end
function flowerRecordViewProxy:initData()
	self.view:initData()
end
return flowerRecordViewProxy
