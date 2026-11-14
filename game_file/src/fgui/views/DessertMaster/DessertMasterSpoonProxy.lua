local baseProxy = require("fgui.base.baseProxy")
local DessertMasterSpoonProxy = class("DessertMasterSpoonProxy", baseProxy)
function DessertMasterSpoonProxy:onRegisterEvent()
	print("=======DessertMasterSpoonProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", handler(self, self.initData))
end
function DessertMasterSpoonProxy:initData()
	if self.view then
		self.view:updateView()
	end
end
function DessertMasterSpoonProxy:onRemoveView()
	print("=======DessertMasterSpoonProxy:onRemoveView")
end
return DessertMasterSpoonProxy
