local heroBiographyRead = include("heroBiographyRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTaskPanel = class("HeroTaskPanel", baseFguiPanel)
function HeroTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroTaskPanel:ctor", self.viewName)
end
function HeroTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroTaskPanel:onInit()
	print("=======HeroTaskPanel:onInit")
	self.type = self.proxy.param.type
	self.heroID = self.proxy.param.heroID
	self.index = self.proxy.param.index
	self.controllers.c1:setSelectedIndex(self.type)
	if self.type == 0 then
		self.fields.title:setString(i18n("Biography_text_11"))
	else
		self.fields.title:setString(i18n("hero_text_118"))
	end
	self.fields.Button_Close:addClickListener(handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function HeroTaskPanel:onShow()
	print("=======HeroTaskPanel:onShow")
	if self.index then
		local storyDes = heroBiographyRead.getStoryDes(self.index)
		self.fields.Text_Story:setString(storyDes)
	elseif self.heroID then
		self:updateList()
	end
end
function HeroTaskPanel:updateList()
	self.taskList = heroBiographyCtrl:getHeroTaskList(self.heroID)
	self.fields.List:setNumItems(#self.taskList)
end
function HeroTaskPanel:onItemRederer(index, target)
	target:initData(self.taskList[index + 1], self.heroID)
end
return HeroTaskPanel
