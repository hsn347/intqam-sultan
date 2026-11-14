local wiseTutorRead = include("wiseTutorRead")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local wiseTutorBuffSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/wiseTutorBuffSub", wiseTutorBuffSub)
function wiseTutorBuffSub:onInit()
	self.fields.Text_1:setString(i18n("common_text_4488"))
	self.fields.Text_2:setString(i18n("Battle_Towers_24"))
	self.fields.Text_3:setString(i18n("Battle_Towers_25"))
	self.fields.Text_1:fixPos()
	self.fields.Text_2:fixPos()
	self.fields.Text_3:fixPos()
	self.fields.n14:fixPos()
	self.fields.n15:fixPos()
	self.fields.Text_Tips:setString(i18n("Battle_Towers_33"))
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	self.buffList = wiseTutorRead.getBuffList()
	self.fields.Scroll_Buff:setNumItems(#self.buffList)
	self.fields.Scroll_Buff:resizeToFit(#self.buffList)
end
function wiseTutorBuffSub:onShow()
	self.curLv = SoraDGetCastleLv()
	print("wiseTutorBuffPanel", self.curLv, self.buffList[#self.buffList].CastleLv)
	self.controllers.c1:setSelectedIndex(self.curLv > self.buffList[#self.buffList].CastleLv and 1 or 0)
end
function wiseTutorBuffSub:onItemRenderer(index, target)
	local lvMin = self.buffList[index] and self.buffList[index].CastleLv + 1 or 1
	local lvMax = self.buffList[index + 1].CastleLv
	target:initData(lvMin, lvMax, self.buffList[index + 1].PrivilegeEffect, index)
end
return wiseTutorBuffSub
