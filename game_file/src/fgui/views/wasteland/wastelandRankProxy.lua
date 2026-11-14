local baseProxy = require("fgui.base.baseProxy")
local wastelandRankProxy = class("wastelandRankProxy", baseProxy)
function wastelandRankProxy:onRegisterEvent()
	print("=======wastelandRankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WASTELAND_REFRESH_RANK", handler(self, self.refreshRankData))
end
function wastelandRankProxy:refreshRankData(target, event)
	self.view:refreshRankData(target, event)
end
function wastelandRankProxy:getDefaultClick(...)
	local defaultClick = 2
	local proxy = uiManager:getProxy("wasteland")
	if proxy:getShowRankRed() then
		self:setDefaultClick(defaultClick)
		return defaultClick
	end
	local _defaultClick = SoraDConfigGet("Game:wastelandRank:defaultClick~integer")
	if _defaultClick then
		return _defaultClick
	end
	return defaultClick
end
function wastelandRankProxy:setDefaultClick(defaultClick)
	SoraDConfigSet("Game:wastelandRank:defaultClick~integer", defaultClick)
end
return wastelandRankProxy
