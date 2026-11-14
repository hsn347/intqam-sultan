local magicLampSkillRead = include("magicLampSkillRead")
local magicLampRead = include("magicLampRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatJinnChoosePanel = class("CheatJinnChoosePanel", baseFguiPanel)
function CheatJinnChoosePanel:ctor(...)
	self.isLRU = true
	CheatJinnChoosePanel.super.ctor(self, ...)
	print("CheatJinnChoosePanel:ctor", self.viewName)
end
function CheatJinnChoosePanel:onInit()
	print("=======CheatJinnChoosePanel:onInit")
	self.fields.Text_name:setString("神力名")
	self.fields.Text_id:setString("神力ID")
	self.fields.Panel_bg:setString("选择神力")
	self.fields.List:setItemRenderer(handler(self, self.onJinnRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseJinn))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder("神力名或神力ID")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatJinnChoosePanel:onJinnRenderer(index, obj)
	local cfg = self.jinnShowList[index + 1]
	obj:getChild("Text_ID"):setString(cfg.type)
	obj:getChild("Text_name"):setString(magicLampSkillRead.getSkillName(cfg.type))
end
function CheatJinnChoosePanel:onChooseJinn()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(true)
end
function CheatJinnChoosePanel:endShow()
	print("=======CheatJinnChoosePanel:endShow")
	self.index = self.param.index
	self.jinnType = self.param.jinnType
	self.fields.Btn_ok:setEnabled(false)
	self.jinnSkillList = magicLampSkillRead.getJinnSkillCfg()
	self.jinnShowList = self.jinnSkillList
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.jinnShowList)
	self.fields.List:jumpToTop()
end
function CheatJinnChoosePanel:btnClick()
	SoraDPlaySound()
	local skillType = self.jinnShowList[self.selIndex].type
	local blessCfg = magicLampRead.getBigBlessList(self.jinnType)
	local bless
	if self.index > 4 then
		blessCfg = magicLampRead.getJinnGalaxyCfgs(self.jinnType)
	else
		bless = blessCfg[self.index].BlessID
	end
	_ENV = blessCfg[self.index]
	blessCfg[self.index].skillType = skillType
	blessCfg[self.index].id = self.jinnType * 10 + self.index
	blessCfg[self.index].lock = false
	blessCfg[self.index].lv = magicLampSkillRead.getSkillLvMax(skillType)
	blessCfg[self.index].classLv = magicLampSkillRead.getSkillStageMax(skillType)
	local blessCfg[self.index].bless, skillData = bless, blessCfg[self.index]
	_ENV = skillType
	skillType.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_JINN"
	skillType.jinnType = self.jinnType
	skillType.index = self.index
	skillType.skillData = skillData
	SoraDSendMessage(skillType)
	self:close()
end
function CheatJinnChoosePanel:btnSearchClick()
	SoraDPlaySound()
	local text = self.input:getText()
	local skillID = tonumber(text)
	local _ENV, suitArray = text, text
	if skillID then
		for _, v in ipairs(self.jinnSkillList) do
			if string.find(tostring(v.type), tostring(skillID)) then
				table.insert(suitArray, v)
			end
		end
	else
		for _, v in ipairs(self.jinnSkillList) do
			local name = magicLampSkillRead.getSkillName(v.type)
			if string.find(name, text) then
				table.insert(suitArray, v)
			end
		end
	end
	if 0 < #suitArray then
		self.jinnShowList = suitArray
		self.fields.List:SelectNone()
		self.fields.List:setNumItems(#self.jinnShowList)
		self.fields.List:jumpToTop()
	else
		SoraDShowMsgTip("未搜索到匹配结果！")
	end
end
return CheatJinnChoosePanel
