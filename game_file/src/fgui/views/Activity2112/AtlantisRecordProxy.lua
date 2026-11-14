local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local AtlantisRecordProxy = class("AtlantisRecordProxy", baseProxy)
function AtlantisRecordProxy:onRegisterEvent()
	print("=======AtlantisRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDLORD_MAPVIEW_CLOSE", handler(self, self.msgCloseBigWorldView))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_TITLE_REFRESH", handler(self, self.msgRefreshTitle))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_BRIEF_REFRESH", handler(self, self.msgRefreshBrief))
end
function AtlantisRecordProxy:msgCallBack(target, data)
	if data.key == "reqHistoryRsp" then
		if tonumber(data.err) ~= 0 then
			return
		end
		if not data.rspdata then
			_ENV = data.rspdata
		end
		self.historyInfo = data.rspdata
		self.view:refreshView(self.historyInfo)
	end
end
function AtlantisRecordProxy:msgCloseBigWorldView(target, data)
	SoraDRemoveAllPanelFromManager()
end
function AtlantisRecordProxy:msgRefreshTitle(target, data)
	self.view:refreshSelfTitle()
end
function AtlantisRecordProxy:msgRefreshBrief(target, data)
	self.view:refreshBrief(target, data)
end
return AtlantisRecordProxy
