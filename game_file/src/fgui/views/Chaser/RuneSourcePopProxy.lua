local baseProxy = require("fgui.base.baseProxy")
local RuneSourcePopProxy = class("RuneSourcePopProxy", baseProxy)
function RuneSourcePopProxy:onRegisterEvent()
	print("=======RuneSourcePopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initView))
end
function RuneSourcePopProxy:initView()
	self.view:initView()
end
return RuneSourcePopProxy
