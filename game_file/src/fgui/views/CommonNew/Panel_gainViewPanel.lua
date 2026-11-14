local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Panel_gainViewPanel = class("Panel_gainViewPanel", baseFguiPanel)
function Panel_gainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Panel_gainViewPanel:ctor", self.viewName)
end
function Panel_gainViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Panel_gainViewPanel:onInit()
	print("=======Panel_gainViewPanel:onInit")
	self.fields.Panel_bg:setString(self.param.title or i18n("Weapon_Rune_tips_074"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onBtnClick))
end
function Panel_gainViewPanel:onShow()
	print("=======Panel_gainViewPanel:onShow")
	if not self.param.awardList then
		_ENV = self.param.awardList
	end
	self.awardList = self.param.awardList
	self.fields.List:setNumItems(#self.awardList)
	if self.param.btnStatus then
		if self.param.btnStatus == gBtnTargetStatusDef.GOT or self.param.btnStatus == gBtnTargetStatusDef.GO then
			self.fields.Button_ok:setEnabled(false)
		else
			self.fields.Button_ok:setEnabled(true)
		end
	end
	if self.param.btnStr then
		self.fields.Button_ok:setString(self.param.btnStr)
	else
		self.fields.Button_ok:setString(i18n("common_text_204"))
	end
end
function Panel_gainViewPanel:onItemRederer(index, obj)
	obj:initData(self.awardList[index + 1], index + 1)
end
function Panel_gainViewPanel:onBtnClick()
	SoraDPlaySound()
	if self.param.handle then
		self.param.handle()
	end
	self:close()
end
return Panel_gainViewPanel
