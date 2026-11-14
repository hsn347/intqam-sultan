local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local MagicLampSkillExchangeChoosePanel = class("MagicLampSkillExchangeChoosePanel", baseFguiPanel)
function MagicLampSkillExchangeChoosePanel:ctor(...)
	self.isLRU = true
	MagicLampSkillExchangeChoosePanel.super.ctor(self, ...)
	print("MagicLampSkillExchangeChoosePanel:ctor", self.viewName)
end
function MagicLampSkillExchangeChoosePanel:onInit()
	print("=======MagicLampSkillExchangeChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("jinn_skill_1"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickEventListener(handler(self, self.onConfirmClick))
	self.fields.Button_comfirm:setTitle(i18n("treasure_crystal_btn_02"))
	self.fields.text_nodata:setString(i18n("jinn_text_06"))
end
function MagicLampSkillExchangeChoosePanel:endShow()
	print("=======MagicLampSkillExchangeChoosePanel:endShow")
	self:initData()
end
function MagicLampSkillExchangeChoosePanel:initData()
	self.quality = self.param.quality
	self.selectedId = self.param.selectedId
	self.exData = self.param.exData
	magicLampSkillCtrl = nil
	;(nil).quality = self.quality
	;(nil).classLv = 0
	local skillList = magicLampSkillCtrl:getSkillListFilter(nil)
	self.skillList, magicLampSkillCtrl = magicLampSkillCtrl, magicLampSkillCtrl
	dump(skillList, "skillList", 10)
	for _, v in ipairs(skillList) do
		local isExist = false
		for _, id in ipairs(self.exData) do
			if id == v.id then
				isExist = true
				break
			end
		end
		if not v.lock and not magicLampCtrl:getIsUsing(v.id) and v.lv == 1 and not isExist then
			table.insert(self.skillList, v)
		end
	end
	self.fields.list:setNumItems(#self.skillList)
	self.fields.Button_comfirm:setEnabled(self.selectedId ~= nil)
	self.fields.text_nodata:setVisible(#self.skillList == 0)
end
function MagicLampSkillExchangeChoosePanel:onItemRenderer(index, obj)
	local skillData = self.skillList[index + 1]
	obj:initData(skillData, self.selectedId == skillData.id)
	obj:setClickEventCallback(handler(self, self.onItemClick))
end
function MagicLampSkillExchangeChoosePanel:onItemClick(skillId)
	if self.selectedId == skillId then
		self.selectedId = nil
	else
		self.selectedId = skillId
	end
	self.fields.list:setNumItems(#self.skillList)
	self.fields.Button_comfirm:setEnabled(self.selectedId ~= nil)
end
function MagicLampSkillExchangeChoosePanel:onConfirmClick()
	SoraDPlaySound()
	if self.param.callback then
		self.param.callback(self.selectedId)
	end
	self:close()
end
return MagicLampSkillExchangeChoosePanel
