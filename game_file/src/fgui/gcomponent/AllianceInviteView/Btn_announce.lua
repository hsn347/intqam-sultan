local memberMgr = SoraDGetCtrl("memberMgr")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local Btn_announce = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceInviteView/Btn_announce", Btn_announce)
function Btn_announce:onInit()
	self.fields.Text_announce:setString(i18n("common_text_201"))
	self.fields.Text_gold:setString(gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_announce:onShow()
end
function Btn_announce:btnClick()
	SoraDPlaySound()
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank < gAllianceRank.R4 then
		SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_204"))
	else
		SoraDShowMsgBox(i18n("common_text_855"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				allianceMgr:reqNoticeInvite()
			end
		end)
	end
end
return Btn_announce
