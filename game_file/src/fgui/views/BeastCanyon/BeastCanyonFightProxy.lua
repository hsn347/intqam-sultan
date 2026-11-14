local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonFightProxy = class("BeastCanyonFightProxy", baseProxy)
function BeastCanyonFightProxy:onRegisterEvent()
	print("=======BeastCanyonFightProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001547_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.onDownloadSuccess))
end
function BeastCanyonFightProxy:msgCallBack(target, data)
	if data.subMsg == "sweep" then
		self.view:updateChallenge()
	elseif data.subMsg == "challenge" then
		self.view:updateChallenge()
		self.view:updateView(true, data.reward)
	elseif data.subMsg == "buyTimes" then
		SoraDCloseLoading()
		self.view:updateChallenge()
	elseif data.subMsg == "addBox" then
		self.view:addBoxReward(data.index)
	end
end
function BeastCanyonFightProxy:onDownloadSuccess(target, data)
	self.view:onDownloadSuccess(data.key)
end
return BeastCanyonFightProxy
