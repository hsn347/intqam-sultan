local baseProxy = require("fgui.base.baseProxy")
local merchanteViewProxy = class("merchanteViewProxy", baseProxy)
function merchanteViewProxy:onRegisterEvent()
	print("=======merchanteViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateResource))
	SoraDAddMessage(self, "MESSAGE_STORES_PURCHASE", handler(self, self.getData))
	SoraDAddMessage(self, "MESSAGE_STORES_REFRESH", handler(self, self.refreshAllAct))
	SoraDAddMessage(self, "MESSAGE_STORES_ALLREFRESH", handler(self, self.refreshAll))
end
function merchanteViewProxy:updateResource()
	self.view:updateResource()
end
function merchanteViewProxy:getData(target, data)
	self.view:getData(target, data)
end
function merchanteViewProxy:refreshAllAct()
	self.view:refreshAll(true)
end
function merchanteViewProxy:refreshAll()
	self.view:refreshAll()
end
return merchanteViewProxy
