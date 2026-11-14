local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local heroBiographyRead = include("heroBiographyRead")
local baseComponent = require("fgui.base.baseComponent")
local list2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/list2", list2)
function list2:onInit()
	self.fields.Button_go:fixPos()
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRender))
end
function list2:onShow()
end
function list2:initData(param)
	self.fields.title:setString(param.title)
	self.fields.Text_subTitle:setString(param.pre)
	self.buffArray = heroBiographyRead.getStorySkillArray(param.index, param.stage, param.missionNum)
	local ret = heroBiographyCtrl:isHeroSuitCondition(param.index, param.missionNum, param.awake)
	self.fields.list:setNumItems(#self.buffArray)
	self.controllers.c1:setSelectedIndex(ret and 0 or 1)
end
function list2:onClickGo()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("newHeroListView")
end
function list2:onItemRender(index, target)
	target:setText(i18n(self.buffArray[index + 1].des))
	target:fixChildrenPos()
end
return list2
