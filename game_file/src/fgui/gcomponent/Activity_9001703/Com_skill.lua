local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_skill", Com_skill)
function Com_skill:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.nbg:fix()
	self.fields.Text_val:fixPos()
	self.fields.up:fixPos()
end
function Com_skill:onShow()
end
function Com_skill:initData(basicId)
	local skillName, png = activity_9001703_Read.getBasicSkillNamePng(basicId)
	self.fields.title:setString(skillName)
	self.fields.icon:setURL(png)
	local lv = activity_9001703_Ctrl:getBaseSkillLv(basicId)
	local maxLv = activity_9001703_Read.getBasicSkillMaxLv(basicId)
	local effect, effectStr = activity_9001703_Ctrl:getBaseSkillVal(basicId)
	self.fields.Text_val:setString(effectStr)
	if lv < maxLv then
		local cfgNext = activity_9001703_Read.getBasicSkillData(basicId, lv + 1)
		local coinNum = activity_9001703_Ctrl:getCoinNum()
		self.fields.up:setVisible(coinNum >= cfgNext.cost)
	else
		self.fields.up:setVisible(false)
	end
end
function Com_skill:btnClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001703_Ready")
end
return Com_skill
