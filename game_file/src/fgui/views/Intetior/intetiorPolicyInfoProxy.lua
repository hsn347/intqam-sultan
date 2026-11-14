local baseProxy = require("fgui.base.baseProxy")
local intetiorPolicyInfoProxy = class("intetiorPolicyInfoProxy", baseProxy)
function intetiorPolicyInfoProxy:onRegisterEvent()
	print("=======intetiorPolicyInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_DATA_UPDATE", handler(self, self.updatePolicyData))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_DATA_UPDATE", handler(self, self.updatePolicyData))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA", handler(self, self.initSkillCostInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_EXECUTE_RSP", handler(self, self.rspDecreeOp))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_PROMISE_RSP", handler(self, self.rspPolicyPromiseOp))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_EXECUTE_RSP", handler(self, self.rspPolicyExecuteOp))
end
function intetiorPolicyInfoProxy:initSkillCostInfo()
	self.view:initSkillCostInfo()
end
function intetiorPolicyInfoProxy:updatePolicyData()
	self.view:updatePolicyData()
end
function intetiorPolicyInfoProxy:rspDecreeOp(target, data)
	SoraDCloseLoading(self.view)
	if data.err == gErrDef.Err_None then
		if self.view.skill:isSkillTargetPersonal() then
			SoraDShowMsgTip(i18n("parliament_text_129"))
		else
			SoraDShowMsgTip(i18n("parliament_text_130"))
		end
		self:reqSyncResource()
	else
		self:errHandle(data)
	end
	self.view:removeFromParent()
end
function intetiorPolicyInfoProxy:rspPolicyPromiseOp(target, data)
	SoraDCloseLoading(self.view)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data)
		self.view:removeFromParent()
	end
end
function intetiorPolicyInfoProxy:rspPolicyExecuteOp(target, data)
	SoraDCloseLoading(self.view)
	if data.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("parliament_text_131"))
		self:reqSyncResource()
	else
		self:errHandle(data)
	end
	self.view:removeFromParent()
end
function intetiorPolicyInfoProxy:reqSyncResource()
	local gametop = gModuleMgr.getObject("gametop")
	local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
	intetiorCtrl:reqParliamentTreasuryData()
end
function intetiorPolicyInfoProxy:errHandle(data)
	local err = data.err
	if err == gErrDef.Err_PARLIAMENT_TREASURY_RESOURCE_NOT_REACH then
		self:reqSyncResource()
	elseif err == gErrDef.Err_PARLIAMENT_CAN_NOT_EXECUTE_UPCOMING_KING_WAR then
		SoraDShowMsgTip(i18n("parliament_text_147"))
	end
	local msgNotice = include("msgNotice")
	msgNotice.rspNotice(data)
end
return intetiorPolicyInfoProxy
