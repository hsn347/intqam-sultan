local baseProxy = require("fgui.base.baseProxy")
local intetiorResourceRecordProxy = class("intetiorResourceRecordProxy", baseProxy)
_ENV, intetiorResourceRecordProxy.onRegisterEvent = function(self)
	print("=======intetiorResourceRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.msgCallBack2))
end, function(self)
	print("=======intetiorResourceRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.msgCallBack2))
end
;(function(self)
	print("=======intetiorResourceRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.msgCallBack2))
end).REWARD_VIEW_TYPE_DOATE = 1
local (function(self)
	print("=======intetiorResourceRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.msgCallBack2))
end).REWARD_VIEW_TYPE_TRICK, REWARD_VIEW_TYPE = 2, function(self)
	print("=======intetiorResourceRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.msgCallBack2))
end
function intetiorResourceRecordProxy:msgCallBack1(target, data)
	SoraDCloseLoading(self.view)
	if self.view.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_DOATE then
		self.view:initScrollData(data)
	end
end
function intetiorResourceRecordProxy:msgCallBack2(target, data)
	SoraDCloseLoading(self.view)
	if self.view.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_TRICK then
		self.view:initScrollData(data)
	end
end
return intetiorResourceRecordProxy
