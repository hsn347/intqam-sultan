local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillPop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_skillPop", Com_skillPop)
function Com_skillPop:onInit()
	self.fields.Button_up:addClickListener(handler(self, self.btnUpClick))
	self.fields.nbg:fix()
	self.fields.Text_val:fixPos()
	self.fields.up:fixPos()
	self.fields.Com_preview:fixPos()
end
function Com_skillPop:onShow()
end
function Com_skillPop:initData(basicId)
	self.basicId = basicId
	local skillName, png = activity_9001703_Read.getBasicSkillNamePng(basicId)
	self.fields.title:setString(skillName)
	self.fields.icon:setURL(png)
	local lv = activity_9001703_Ctrl:getBaseSkillLv(basicId)
	local maxLv = activity_9001703_Read.getBasicSkillMaxLv(basicId)
	self.isMax = lv >= maxLv
	local cfgNext = activity_9001703_Read.getBasicSkillData(basicId, lv + 1)
	local effect, effectStr = activity_9001703_Ctrl:getBaseSkillVal(basicId)
	self.fields.Text_val:setString(effectStr)
	local balloonCoin = activity_9001703_Ctrl:getCoinNum()
	self.fields.Button_up:initData(cfgNext.cost, balloonCoin, self.isMax)
	self.fields.Button_up:setEnabled(not self.isMax)
	if not self.isMax then
		self.isEnoughCoin = balloonCoin >= cfgNext.cost
		self.fields.up:setVisible(self.isEnoughCoin)
		self.fields.Com_preview:setVisible(self.isEnoughCoin)
		self.fields.Text_val:setVisible(not self.isEnoughCoin)
		if self.isEnoughCoin then
			local fromVal = effect
			local toVal = cfgNext.basicEffect
			if self.basicId == 3 then
				fromVal = fromVal .. "%"
				toVal = toVal .. "%"
			end
			self.fields.Com_preview:initData(fromVal, toVal)
		end
	else
		self.fields.up:setVisible(false)
		self.fields.Com_preview:setVisible(false)
		self.fields.Text_val:setVisible(true)
	end
end
function Com_skillPop:btnUpClick()
	SoraDPlaySound()
	if not self.isEnoughCoin then
		SoraDShowMsgTip(i18n("balloon_hunter_016"))
		return
	end
	activity_9001703_Ctrl:reqUpgradeSkill(self.basicId)
end
return Com_skillPop
