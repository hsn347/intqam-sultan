local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulGainAwardPanel = class("ExtremelySkillfulGainAwardPanel", baseFguiPanel)
function ExtremelySkillfulGainAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulGainAwardPanel:ctor", self.viewName)
end
function ExtremelySkillfulGainAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulGainAwardPanel:onInit()
	print("=======ExtremelySkillfulGainAwardPanel:onInit")
	self.fields.Title:setString(i18n("Battle_Towers_14"))
	self.fields.Scroll_Award:setItemRenderer(handler(self, self.onItemRederer))
	self.param = self.proxy.param
	self.fields.Scroll_Award:setNumItems(#self.param)
	self.fields.Scroll_Award:resizeToFit(#self.param, 200)
end
function ExtremelySkillfulGainAwardPanel:onShow()
	print("=======ExtremelySkillfulGainAwardPanel:onShow")
end
function ExtremelySkillfulGainAwardPanel:onItemRederer(index, object)
	object:initData(self.param[index + 1].reward, self.param[index + 1].title, self.param[index + 1].index)
end
return ExtremelySkillfulGainAwardPanel
