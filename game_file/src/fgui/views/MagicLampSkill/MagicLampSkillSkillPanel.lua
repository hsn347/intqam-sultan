local magicLampSkillRead = include("magicLampSkillRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillSkillPanel = class("MagicLampSkillSkillPanel", baseFguiPanel)
function MagicLampSkillSkillPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillSkillPanel:ctor", self.viewName)
	self.isHidePrePanel = true
end
function MagicLampSkillSkillPanel:onInit()
	print("=======MagicLampSkillSkillPanel:onInit")
	self.fields.Com_title:setString(i18n("jinn_skill_47"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickClose))
end
function MagicLampSkillSkillPanel:onShow()
	print("=======MagicLampSkillSkillPanel:onShow")
	local skillType = self.param.skillType
	local skillGroup = magicLampSkillRead.getSkillSkillGroup(skillType)
	local classLvMax = magicLampSkillRead.getSkillStageMax(skillType)
	local _ENV, ret = skillType, skillType
	for i, v in ipairs(skillGroup) do
		if v ~= 0 and classLvMax >= i - 1 then
			_ENV = nil
			;(nil).classLv = i - 1
			;(nil).skill = v
			;(nil).max = classLvMax
			table.insert(ret, nil)
		end
	end
	self.showList = ret
	self.fields.List_skill:setNumItems(#self.showList)
end
function MagicLampSkillSkillPanel:onSkillItemRenderer(index, obj)
	local data = self.showList[index + 1]
	local fields = fguiHelper.get_fields(obj)
	fields.Com_star:initData(data.classLv, data.max)
	fields.Text_des:setString(magicLampSkillRead.getSkillBuffDes(data.skill))
end
return MagicLampSkillSkillPanel
