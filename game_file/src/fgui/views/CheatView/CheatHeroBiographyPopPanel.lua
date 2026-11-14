local heroBiographyRead = include("heroBiographyRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatHeroBiographyPopPanel = class("CheatHeroBiographyPopPanel", baseFguiPanel)
function CheatHeroBiographyPopPanel:ctor(...)
	CheatHeroBiographyPopPanel.super.ctor(self, ...)
	print("CheatHeroBiographyPopPanel:ctor", self.viewName)
end
function CheatHeroBiographyPopPanel:onInit()
	print("=======CheatHeroBiographyPopPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onSkillItemRender))
end
function CheatHeroBiographyPopPanel:onSkillItemRender(index, obj)
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_id"):setString(self.mergeArray[index + 1].skillID)
	obj:getChild("Text_buff"):setAlign(0)
	obj:getChild("Text_buff"):setString(i18n(self.mergeArray[index + 1].des))
end
function CheatHeroBiographyPopPanel:onShow()
	print("=======CheatHeroBiographyPopPanel:onShow")
	self.index = self.param and self.param.index or 1
	if not self.param or not self.param.indexList then
		_ENV = self.param.indexList
	end
	self.indexList = self.param.indexList
	self.fields.Panel_bg:setString("列传" .. self.index .. "--" .. i18n(heroBiographyRead.getBiographyName(self.index)))
	self.array, self.mergeArray = heroBiographyRead.getStorySkillShowArray(self.index, true)
	self.fields.List:setNumItems(#self.mergeArray)
end
return CheatHeroBiographyPopPanel
