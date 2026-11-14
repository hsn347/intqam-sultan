local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuddySystem/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Button_no:addClickListener(handler(self, self.onNoClick))
	self.fields.Button_yes:addClickListener(handler(self, self.onYesClick))
	self:fixChildrenPos()
end
function Com_list:onShow()
end
function Com_list:initData(data, mode)
	self.data = data
	self.mode = mode
	self.controllers.c1:setSelectedIndex(mode)
	self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	if self.data.allianceAbbr and self.data.allianceAbbr ~= "" then
		_ENV = nil
		;(nil).abbr = self.data.allianceAbbr
		;(nil).name = self.data.name or ""
		self.fields.Text_name:setString(string.format("%s #%d", i18n("common_text_186", nil), self.data.oriKid or self.data.sourceKid))
	else
		self.fields.Text_name:setString(string.format("%s #%d", self.data.name or "", self.data.oriKid or self.data.sourceKid))
	end
	local tiemTab = os.date("*t", self.data.t)
	local str_date = string.format("%.4d-%.2d-%.2d", tiemTab.year, tiemTab.month, tiemTab.day)
	self.fields.Text_time:setString(str_date)
	if self.mode == 1 then
		self.fields.Text_text:setString(self.data.text)
	end
end
function Com_list:onYesClick()
	SoraDPlaySound()
	if contactCtrl:isOwnFriendMaxLimit() then
		SoraDShowMsgTip(i18n("friend_text_06"))
	else
		contactCtrl:reqAcceptFriendInvite(self.data.uid)
	end
end
function Com_list:onNoClick()
	SoraDPlaySound()
	if self.mode == 1 then
		contactCtrl:reqRejectFriendInvite(self.data.uid)
	else
		contactCtrl:reqCancelSendFriendInvite(self.data.uid)
	end
end
return Com_list
