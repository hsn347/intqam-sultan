local baseProxy = require("fgui.base.baseProxy")
local gameSearchProxy = class("gameSearchProxy", baseProxy)
function gameSearchProxy:onRegisterEvent()
	print("=======gameSearchProxy:onRegisterEvent", self.viewName)
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SEARCH_ALLIANCE", handler(self, self.msgAliianceBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SEARCH_LORD", handler(self, self.msgPlayerBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function gameSearchProxy:msgAliianceBack(target, data)
	SoraDCloseLoading(self.view)
	if data.data then
		self.view.allianceDataList, _ENV = self.view, self.view
		for i, v in ipairs(data.data) do
			table.insert(self.view.allianceDataList, v)
		end
		self.view.isAllianceMax = data.isMax
	end
	self.view:updateScrollWithData()
end
function gameSearchProxy:msgPlayerBack(target, data)
	SoraDCloseLoading(self.view)
	dump(data, "msgPlayerBack")
	if data.data then
		self.view.lordDataList, _ENV = data, data
		for i, v in ipairs(data.data) do
			table.insert(self.view.lordDataList, v)
		end
		self.view.isLordMax = data.isMax
	end
	self.view:updateScrollWithData()
end
function gameSearchProxy:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.viewName then
			SoraDOpenLordView(data.lord)
		end
	end
end
return gameSearchProxy
