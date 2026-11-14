local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local RomanRewardPreviewProxy = class("RomanRewardPreviewProxy", baseProxy)
function RomanRewardPreviewProxy:onRegisterEvent()
	print("=======RomanRewardPreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_INFOREQUEST", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ROMAN_POINT_UPDATE", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_MEMBERRANK", handler(self, self.setStageData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_ALLIANCERANK", handler(self, self.setTotalData))
	SoraDAddMessage(self, "MESSAGE_ROMAN_SCROLL_TO_BOTTOM", handler(self, self.allianceScollEnd))
end
function RomanRewardPreviewProxy:initData()
	if self.view then
		self.view:initData()
	end
end
function RomanRewardPreviewProxy:refreshData()
	romeActivityCtrl:reqMemScoreAndAllScore()
	if self and self.view then
		self.view:initData()
	end
end
function RomanRewardPreviewProxy:setStageData(target, data)
	self.view:setStageData(target, data)
end
function RomanRewardPreviewProxy:setTotalData(target, data)
	self.view:setTotalData(target, data)
end
function RomanRewardPreviewProxy:allianceScollEnd(target, data)
	self.view:allianceScollEnd(data.show)
end
return RomanRewardPreviewProxy
