local baseProxy = require("fgui.base.baseProxy")
local WarGemComposeProxy = class("WarGemComposeProxy", baseProxy)
function WarGemComposeProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_MERGE_RSP", handler(self, self.onGemMerge))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onGemBag))
end
function WarGemComposeProxy:onGemMerge(target, data)
	print("onGemMerge")
	SoraDCloseLoading()
	self.view:onGemMerge(target, data)
end
function WarGemComposeProxy:onGemBag(target, data)
	print("onGemBag")
	if SoraDCurrentTopPanelFromManager() ~= self.view then
		self.view:updateView()
	end
end
return WarGemComposeProxy
