local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarGuessViewProxy = class("NebulaAllStarGuessViewProxy", baseProxy)
function NebulaAllStarGuessViewProxy:onRegisterEvent()
	print("=======NebulaAllStarGuessViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_QUIZRECORD_DATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_QUIZ_BET", handler(self, self.onMsgQuizBetBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_EXCHANGE_BACK", handler(self, self.exchangeBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_EXCHANGE_RECORD_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_QUIZ_COIN", handler(self, self.onMsgUpdateQuizCoin))
end
function NebulaAllStarGuessViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function NebulaAllStarGuessViewProxy:onMsgQuizBetBack(...)
	self.view:onMsgQuizBetBack(...)
end
function NebulaAllStarGuessViewProxy:exchangeBack(target, data)
	self.view:exchangeBack(target, data)
end
function NebulaAllStarGuessViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function NebulaAllStarGuessViewProxy:onMsgUpdateQuizCoin(...)
	self.view:onMsgUpdateQuizCoin(...)
end
return NebulaAllStarGuessViewProxy
