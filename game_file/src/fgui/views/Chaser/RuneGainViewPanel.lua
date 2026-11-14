local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneGainViewPanel = class("RuneGainViewPanel", baseFguiPanel)
function RuneGainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneGainViewPanel:ctor", self.viewName)
end
function RuneGainViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneGainViewPanel:onInit()
	print("=======RuneGainViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Weapon_Rune_tips_074"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_ok:setString(self.param.okStr or i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onBtnClick))
	self.fields.Text_base:setString(i18n("Weapon_Rune_tips_080"))
	self.fields.Text_back:setString(i18n("Weapon_Rune_tips_081"))
end
function RuneGainViewPanel:onShow()
	print("=======RuneGainViewPanel:onShow")
	if not self.param.base then
		_ENV = self.param.base
	end
	self.base = self.param.base
	self.fields.Single_base:initData(self.base, 1)
	if not self.param.awardList then
		_ENV = self.param.awardList
	end
	self.awardList = self.param.awardList
	self.fields.List:setNumItems(#self.awardList)
end
function RuneGainViewPanel:onItemRederer(index, obj)
	obj:initData(self.awardList[index + 1], index + 1)
end
function RuneGainViewPanel:onBtnClick()
	SoraDPlaySound()
	self:close()
end
return RuneGainViewPanel
