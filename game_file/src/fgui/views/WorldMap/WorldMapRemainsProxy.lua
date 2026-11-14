local baseProxy = require("fgui.base.baseProxy")
local WorldMapRemainsProxy = class("WorldMapRemainsProxy", baseProxy)
function WorldMapRemainsProxy:onRegisterEvent()
	print("=======WorldMapRemainsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REMAINS_LOG", handler(self, self.updateLog))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REMAINS_DISAPPEAR", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RemainsInfo))
end
function WorldMapRemainsProxy:serverMessage_RemainsInfo(target, data)
	if not data then
		return
	end
	local remainsData = data.data.relics
	if remainsData then
		if remainsData.isSelfIn then
			self.view:initView(remainsData)
		else
			self.view:removeFromParent()
		end
	end
end
function WorldMapRemainsProxy:closeMe(target)
	self.view:removeFromParent()
end
function WorldMapRemainsProxy:updateLog(target, retData)
	dump(retData, "retData")
	if retData.data then
		for i, v in ipairs(retData.data) do
			table.insert(self.view.remainsData.log, v)
		end
	end
	self.view:updateScroll()
end
return WorldMapRemainsProxy
