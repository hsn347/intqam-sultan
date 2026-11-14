local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local AwardPreviewSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/AwardPreviewSub", AwardPreviewSub)
function AwardPreviewSub:onInit()
	self.fields.Text_High:setString(i18n("MarvelousWorkmanship_17"))
	self.fields.Text_Middle:setString(i18n("MarvelousWorkmanship_16"))
	self.fields.Text_Normal:setString(i18n("MarvelousWorkmanship_15"))
	self.fields.List_normal:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.List_Middle:setItemRenderer(handler(self, self.onMiddleItemRenderer))
	self.fields.List_High:setItemRenderer(handler(self, self.onHighItemRenderer))
end
function AwardPreviewSub:onShow()
	local award1, award2, award3 = extremelySkillfulRead.getAllAwardByIndex(ExtremelySkillfulCtrl:getGroupIndex())
	_ENV = ExtremelySkillfulCtrl:getGroupIndex()
	ExtremelySkillfulCtrl:getGroupIndex()[1] = "id"
	ExtremelySkillfulCtrl:getGroupIndex()[2] = "count"
	self.normalAward = serviceFunctions.tableFormat(award1, ExtremelySkillfulCtrl:getGroupIndex())
	_ENV = ExtremelySkillfulCtrl:getGroupIndex()
	ExtremelySkillfulCtrl:getGroupIndex()[1] = "id"
	ExtremelySkillfulCtrl:getGroupIndex()[2] = "count"
	self.middleAward = serviceFunctions.tableFormat(award2, ExtremelySkillfulCtrl:getGroupIndex())
	_ENV = ExtremelySkillfulCtrl:getGroupIndex()
	ExtremelySkillfulCtrl:getGroupIndex()[1] = "id"
	ExtremelySkillfulCtrl:getGroupIndex()[2] = "count"
	self.highAward = serviceFunctions.tableFormat(award3, ExtremelySkillfulCtrl:getGroupIndex())
	self.fields.List_normal:setNumItems(#self.normalAward)
	self.fields.List_normal:resizeToFit(#self.normalAward)
	self.fields.List_Middle:setNumItems(#self.middleAward)
	self.fields.List_Middle:resizeToFit(#self.middleAward)
	self.fields.List_High:setNumItems(#self.highAward)
	self.fields.List_High:resizeToFit(#self.highAward)
end
function AwardPreviewSub:onNormalItemRenderer(index, obj)
	local item = self.normalAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
function AwardPreviewSub:onMiddleItemRenderer(index, obj)
	local item = self.middleAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
function AwardPreviewSub:onHighItemRenderer(index, obj)
	local item = self.highAward[index + 1]
	obj:initData(item.id, item.count, index + 1)
end
return AwardPreviewSub
