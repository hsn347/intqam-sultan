local baseProxy = require("fgui.base.baseProxy")
local BuildCreateProxy = class("BuildCreateProxy", baseProxy)
function BuildCreateProxy:onRegisterEvent()
	print("=======BuildCreateProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.onMsgBuildQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_CREATE_POINT", handler(self, self.onMsgBuildCreatePoint))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_CREATE_POINT_HIDE", handler(self, self.onMsgBuildCreatePointHide))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_END", handler(self, self.onMsgBuildCreatePointHide))
end
function BuildCreateProxy:updateView(...)
	self.view:updateView(...)
end
function BuildCreateProxy:onMsgBuildQueueCallback(...)
	self.view:onMsgBuildQueueCallback(...)
end
function BuildCreateProxy:onMsgBuildCreatePoint(...)
	self.view:onMsgBuildCreatePoint(...)
end
function BuildCreateProxy:onMsgBuildCreatePointHide(...)
	self.view:onMsgBuildCreatePointHide(...)
end
return BuildCreateProxy
