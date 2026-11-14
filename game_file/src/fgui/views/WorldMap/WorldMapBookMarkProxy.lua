local baseProxy = require("fgui.base.baseProxy")
local WorldMapBookMarkProxy = class("WorldMapBookMarkProxy", baseProxy)
function WorldMapBookMarkProxy:onRegisterEvent()
	print("=======WorldMapBookMarkProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EDIT_COLLECTMAP_SUCCESS", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_DELETE_COLLECTMAP_SUCCESS", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ALLIANCE_MARK_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_CAMP_MARK_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_MARK", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function()
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end)
end
function WorldMapBookMarkProxy:msgCallBack(target, data)
	self.view:initData(true)
	self.view:refreshTable()
	self.view:updateScroll()
	if data.msg == "MESSAGE_SERVER_DELETE_COLLECTMAP_SUCCESS" then
		SoraDShowMsgTip(i18n("common_text_633"))
	elseif data.msg == "MESSAGE_SERVER_EDIT_COLLECTMAP_SUCCESS" then
		SoraDShowMsgTip(i18n("common_text_634"))
	else
		SoraDRemoveAllAfterPanelFromManager(self.view, true)
	end
end
return WorldMapBookMarkProxy
