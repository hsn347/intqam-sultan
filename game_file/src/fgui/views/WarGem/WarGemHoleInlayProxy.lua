local baseProxy = require("fgui.base.baseProxy")
local WarGemHoleInlayProxy = class("WarGemHoleInlayProxy", baseProxy)
function WarGemHoleInlayProxy:onRegisterEvent()
	print("=======WarGemHoleInlayProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DISMOUNT_RSP", handler(self, self.onGemStatusChange))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REPLACE_RSP", handler(self, self.onGemStatusChange))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_MOUNT_RSP", handler(self, self.onGemStatusChange))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA", handler(self, self.onGemStatusChange))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onUpdateGemBag))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.onUpdateRes))
end
function WarGemHoleInlayProxy:onGemStatusChange(target, data)
	local err = data.err
	SoraDCloseLoading(self.view:displayObject())
	if err == gErrDef.Err_None then
		self:removeView(self.view)
	end
end
function WarGemHoleInlayProxy:onUpdateRes(target, data)
	dump(data.reslist, "onUpdateRes====", 10)
	if data.reslist and data.reslist[tostring(gIDDef.MITHRIL)] then
		self.view:updateCost()
	end
end
function WarGemHoleInlayProxy:onUpdateGemBag()
	self.view:updateList()
end
return WarGemHoleInlayProxy
