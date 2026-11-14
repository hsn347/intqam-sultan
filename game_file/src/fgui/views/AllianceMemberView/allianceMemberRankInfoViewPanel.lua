local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMemberRankInfoViewPanel = class("allianceMemberRankInfoViewPanel", baseFguiPanel)
function allianceMemberRankInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMemberRankInfoViewPanel:ctor", self.viewName)
end
function allianceMemberRankInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMemberRankInfoViewPanel:onInit()
	print("=======allianceMemberRankInfoViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_206"), handler(self, self.onClickClose))
	for r = 1, 6 do
		self.fields["R" .. r]:fixPos()
	end
end
function allianceMemberRankInfoViewPanel:onShow()
	print("=======allianceMemberRankInfoViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function allianceMemberRankInfoViewPanel:initData()
	self.fields.Com_info:initData()
end
function allianceMemberRankInfoViewPanel:onClickClose()
	if self.fields.Com_info:isInEditMode() then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_2472"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				self:close()
			end
		end)
	else
		SoraDPlaySound("uicontrol", 1)
		self:close()
	end
end
return allianceMemberRankInfoViewPanel
