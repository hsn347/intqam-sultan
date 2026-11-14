local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillPanel = class("RoaringFlame_SkillPanel", baseFguiPanel)
function RoaringFlame_SkillPanel:ctor(...)
	RoaringFlame_SkillPanel.super.ctor(self, ...)
	print("RoaringFlame_SkillPanel:ctor", self.viewName)
end
function RoaringFlame_SkillPanel:onInit()
	print("=======RoaringFlame_SkillPanel:onInit")
	self.fields.Com_title:initData(i18n("common_title_03"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("flames_dunes_text111"))
	self.fields.Button_book:setString(i18n("atlantiswar_skill_text_003"))
	self.fields.Button_book:addClickListener(handler(self, self.onClickBtnBook))
	self.skillList, _ENV = self.fields.Button_book.addClickListener, self.fields.Button_book.addClickListener
	for i = 1, 5 do
		local Com_skillSingle = self.fields["Com_skillSingle" .. i]
		table.insert(self.skillList, Com_skillSingle)
		Com_skillSingle:fixPos()
	end
end
function RoaringFlame_SkillPanel:onShow()
	print("=======RoaringFlame_SkillPanel:onShow")
	self:initData()
end
function RoaringFlame_SkillPanel:initData(...)
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	self.isPrivilegeLock = roaringFlameWarCtrl:getIsPrivilegeLock() or false
	for i, item in ipairs(self.skillList) do
		roaringFlameWarCtrl = nil
		;(nil).index = i
		;(nil).skillSlot = self.skillSlot[tostring(i)]
		;(nil).isPrivilegeLock = self.isPrivilegeLock
		item:initData(nil)
	end
end
function RoaringFlame_SkillPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule13")
	;(nil).content = i18n("flames_dunes_second_rule14")
	uiManager:show("RuleView", nil)
end
function RoaringFlame_SkillPanel:onClickBtnBook(...)
	SoraDPlaySound()
	uiManager:show("RoaringFlame_SkillBook")
end
function RoaringFlame_SkillPanel:onMessageSkillLottery(target, event)
	local index = event.index
	self.candidateSkill = roaringFlameWarCtrl:getCandidateSkill()
	if self.candidateSkill[tostring(index)] then
		return
	end
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	self.skillList[index]:showChangeSkillEffect()
end
function RoaringFlame_SkillPanel:onMessageSkillReplace(target, event)
	local index = event.index
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	roaringFlameWarCtrl = nil
	;(nil).index = index
	;(nil).skillSlot = self.skillSlot[tostring(index)]
	self.skillList[index]:initData(nil)
end
function RoaringFlame_SkillPanel:onMessageSkillSelect(target, event)
	local index = event.index
	self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
	roaringFlameWarCtrl = nil
	;(nil).index = index
	;(nil).skillSlot = self.skillSlot[tostring(index)]
	self.skillList[index]:initData(nil)
end
return RoaringFlame_SkillPanel
