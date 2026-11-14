local baseProxy = require("fgui.base.baseProxy")
local intetiorPolicyRecordProxy = class("intetiorPolicyRecordProxy", baseProxy)
_ENV, intetiorPolicyRecordProxy.onRegisterEvent = function(self)
	print("=======intetiorPolicyRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_RECORD", handler(self, self.msgCallBack2))
end, function(self)
	print("=======intetiorPolicyRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_RECORD", handler(self, self.msgCallBack2))
end
;(function(self)
	print("=======intetiorPolicyRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_RECORD", handler(self, self.msgCallBack2))
end).REWARD_VIEW_TYPE_BASE = 1
local (function(self)
	print("=======intetiorPolicyRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_RECORD", handler(self, self.msgCallBack2))
end).REWARD_VIEW_TYPE_ORDER, REWARD_VIEW_TYPE = 2, function(self)
	print("=======intetiorPolicyRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_RECORD", handler(self, self.msgCallBack1))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_RECORD", handler(self, self.msgCallBack2))
end
function intetiorPolicyRecordProxy:msgCallBack1(target, data)
	SoraDCloseLoading(self.view)
	if self.view.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_BASE then
		self.view:initScrollData(data)
	end
end
function intetiorPolicyRecordProxy:msgCallBack2(target, data)
	SoraDCloseLoading(self.view)
	if self.view.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ORDER then
		self.view:initScrollData(data)
	end
end
return intetiorPolicyRecordProxy
