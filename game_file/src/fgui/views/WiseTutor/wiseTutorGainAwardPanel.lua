local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorGainAwardPanel = class("wiseTutorGainAwardPanel", basePanel)
function wiseTutorGainAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorGainAwardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function wiseTutorGainAwardPanel:onInit()
	self.fields.Title:setString(i18n("Battle_Towers_14"))
	self.fields.Scroll_Award:setItemRenderer(handler(self, self.onItemRederer))
	self.param = self.proxy.param
	self.fields.Scroll_Award:setNumItems(#self.param)
	self.fields.Scroll_Award:resizeToFit(#self.param, 200)
end
function wiseTutorGainAwardPanel:onShow()
end
function wiseTutorGainAwardPanel:onItemRederer(index, object)
	object:initData(self.param[index + 1].reward, self.param[index + 1].isSpecial, self.param.normalTitle, self.param.specialTitle)
end
return wiseTutorGainAwardPanel
