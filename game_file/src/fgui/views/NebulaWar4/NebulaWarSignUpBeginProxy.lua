local nebulaWarUtil = include("nebulaWarUtil")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarSignUpBeginProxy = class("NebulaWarSignUpBeginProxy", baseProxy)
function NebulaWarSignUpBeginProxy:onRegisterEvent()
	print("=======NebulaWarSignUpBeginProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_SIGN_UP_UPDATE", handler(self, self.onMsgUpdateSignUp))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.onMsgStateChange))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
end
function NebulaWarSignUpBeginProxy:onMsgUpdateSignUp(target, event)
	SoraDCloseLoading(self.view:displayObject())
	local num = event.num
	if num then
		self.view:updateSignUpNum(num)
	end
	self.view:updateBtnState()
end
function NebulaWarSignUpBeginProxy:onMsgStateChange(...)
	if not nebulaWarUtil.checkSuperTeamSignUpState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarSignUpBeginProxy:onMsgTeamInfoNotify(target, event)
	local notifyType = event.notifyType
	if notifyType == "UPDATE_SETTING" then
		if event.key == "signUp" then
			self.view:updateBtnState()
		end
	elseif notifyType == "UPDATE_LEADER" then
		self.view:updateBtnState()
	end
end
return NebulaWarSignUpBeginProxy
