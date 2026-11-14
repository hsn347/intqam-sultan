local baseProxy = require("fgui.base.baseProxy")
local DesertMeteoriteExploringProxy = class("DesertMeteoriteExploringProxy", baseProxy)
function DesertMeteoriteExploringProxy:onRegisterEvent()
	print("=======DesertMeteoriteExploringProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_DesertMeteoriteInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_DESERT_METEORITE_LOG", handler(self, self.updateLog))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REMAINS_DISAPPEAR", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_REFRESH", handler(self, self.onUpdateActivity))
end
function DesertMeteoriteExploringProxy:onUpdateActivity()
	self.view:updateView()
end
function DesertMeteoriteExploringProxy:serverMessage_DesertMeteoriteInfo(target, data)
	if not data then
		return
	end
	local remainsData = data.data.relics
	if remainsData then
		if remainsData.isSelfIn then
			self.view:initView(remainsData)
		else
			self.view:close()
		end
	end
end
function DesertMeteoriteExploringProxy:updateLog(target, msgData)
	if msgData.data then
		self.view:addLog(msgData.data)
	end
end
function DesertMeteoriteExploringProxy:closeMe()
	self.view:close()
end
return DesertMeteoriteExploringProxy
