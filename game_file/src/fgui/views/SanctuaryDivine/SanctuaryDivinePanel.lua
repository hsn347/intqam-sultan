local divineProtectionRead = include("divineProtectionRead")
local constantRead = include("constantRead")
local magicLampSkillShelterCtrl = SoraDGetCtrl("magicLampSkillShelterCtrl")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SanctuaryDivinePanel = class("SanctuaryDivinePanel", baseFguiPanel)
function SanctuaryDivinePanel:ctor(...)
	self.super.ctor(self, ...)
	print("SanctuaryDivinePanel:ctor", self.viewName)
end
function SanctuaryDivinePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampMaigcPower"
	end
	return self._packageList
end
function SanctuaryDivinePanel:onInit()
	print("=======SanctuaryDivinePanel:onInit")
	self.activityID = gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY
	self.poolID = constantRead.getConstValue("DIVINE_PROTECTION_POOLID", 1)
	self.poolCfg = divineProtectionRead.getPoolCfg(self.poolID)
	self.costItemID = self.poolCfg.drwaCost1[1]
	print("self.costItemID=====", self.costItemID)
	dump(self.poolCfg, "self.poolCfg====")
	self.getSTimes = self.poolCfg.circulateIndex1
	self.drawReward = self.poolCfg.drawReward[1]
	self.isFree = false
	self.fields.Com_title:initData(i18n("activity_name_9001480"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID, handler(self, self.checkFree))
	self.fields.Btn_preAward:setString(i18n("Magic_draw_text_10"))
	self.fields.Btn_preAward:addClickListener(handler(self, self.onPreAwardClick))
	self.fields.Com_stage:init()
	self.fields.Com_cards:initParent(self)
	self.fields.skip:setString(i18n("Canyon_Treasur_text_27"))
	self.fields.skip:addClickListener(handler(self, self.onSkipClick))
	self.fields.Btn_drawOne:setString(i18n("divine_protection_03"))
	self.fields.Btn_drawOne:addClickListener(handler(self, self.onDrawOneClick))
	_ENV = handler(self, self.onDrawOneClick)
	handler(self, self.onDrawOneClick).var = publicRead.getName(self.drawReward)
	self.fields.Text_tipFive:setString(i18n("divine_protection_06", handler(self, self.onDrawOneClick)))
	_ENV = i18n("divine_protection_06", handler(self, self.onDrawOneClick))
	i18n("divine_protection_06", handler(self, self.onDrawOneClick)).num = 5
	self.fields.Btn_drawFive:setString(i18n("divine_protection_04", i18n("divine_protection_06", handler(self, self.onDrawOneClick))))
	self.fields.Btn_drawFive:addClickListener(handler(self, self.onDrawFiveClick))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.label_timer)
	self.text_time:setTimeEndListener(handler(self, self.updateView))
	self.text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("Magic_draw_text_06", nil)
	end)
	self.fields.Com_moli:addClickListener(handler(self, self.onMoliClick))
	self.fields.Com_record:fixPos()
	self.fields.Com_moli:fixPos()
	self.fields.Btn_drawOne:fixPos()
	self.fields.Btn_drawFive:fixPos()
	self.fields.Btn_preAward:fixPos()
	self.fields.skip:fixPos()
	self.fields.Text_tipFive:fixPos()
	self.fields.label_timer:fixPos()
end
function SanctuaryDivinePanel:onShow()
	print("=======SanctuaryDivinePanel:onShow")
	self.max = magicLampSkillCtrl:getSkillStorageMax()
	self:updateView()
	_ENV = nil
	;(nil).byUID = true
	local isSkip = SoraDConfigGet("Game:SanctuaryDivine:isSkip~bool", nil) or false
	print("isSkip====", isSkip)
	self.fields.skip:setSelected(isSkip)
end
function SanctuaryDivinePanel:updateView()
	local totalTimes = magicLampSkillShelterCtrl:getTotalTimes()
	self.getSTimes = not magicLampSkillShelterCtrl:isFirstN() and self.poolCfg.firstIndex or self.poolCfg.circulateIndex1
	magicLampSkillShelterCtrl = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", self.getSTimes - magicLampSkillShelterCtrl:getToSTimes())
	self.fields.Text_atlast:setString(i18n("divine_protection_01", nil))
	self.fields.Com_record:initData(totalTimes)
	self.fields.Com_have:initData(self.costItemID)
	self.itemCount = backpackCtrl:getItemCount(self.costItemID)
	self.fields.Com_have:updateNum(self.itemCount)
	self:checkFree()
	self.fields.Btn_drawOne:setReddot(self.isFree or self.itemCount > 0)
	self.fields.Btn_drawFive:setCost(self.costItemID, 5)
	self.fields.Btn_drawFive:setReddot(self.itemCount >= 5)
	self.fields.Com_stage:updateData()
	local skillList = magicLampSkillCtrl:getSkillList()
	self.curNum = #skillList
	magicLampSkillShelterCtrl = i18n("divine_protection_01", nil)
	i18n("divine_protection_01", nil).num = self.curNum
	i18n("divine_protection_01", nil).max = self.max
	self.fields.Com_moli:setTitle(i18n("jinn_skill_8", i18n("divine_protection_01", nil)))
	self:updateFreeTime()
end
function SanctuaryDivinePanel:drawBack(target, data)
	uiManager:show("MagicLampMaigcPowerGain", data.data):setOwnerKey(self)
end
function SanctuaryDivinePanel:updateFreeTime()
	self.lastFreeTime = magicLampSkillShelterCtrl:getLastFreeTime() + self.poolCfg.freeTime - serviceFunctions.systemTime()
	print("self.lastFreeTime====", self.lastFreeTime)
	self.text_time:setVisible(self.lastFreeTime > 0)
	self.text_time:removeTime()
	if self.lastFreeTime > 0 then
		self.text_time:beginTime(self.lastFreeTime)
	end
end
function SanctuaryDivinePanel:checkFree()
	self.isFree = magicLampSkillShelterCtrl:checkFree(self.poolCfg.freeTime)
	self.fields.Btn_drawOne:setCost(self.costItemID, self.isFree and 0 or 1)
end
function SanctuaryDivinePanel:onPreAwardClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).magicPoolID = self.poolID
	;(nil).isPreView = true
	uiManager:show("MagicLampMagicPowerPreview", nil):setOwnerKey(self)
end
function SanctuaryDivinePanel:onSkipClick()
	SoraDPlaySound()
	print("self.isSkip====222", self.fields.skip:isSelected())
	_ENV = self.fields.skip
	self.fields.skip.byUID = true
	SoraDConfigSet("Game:SanctuaryDivine:isSkip~bool", self.fields.skip:isSelected(), self.fields.skip)
end
function SanctuaryDivinePanel:onDrawOneClick()
	SoraDPlaySound()
	if self.max < self.curNum + 1 then
		SoraDShowMsgTip(i18n("Magic_draw_text_08"))
		return
	end
	if not self.isFree and 1 > self.itemCount then
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		magicLampSkillShelterCtrl:sendDraw(self.poolID, 1, self.isFree, self.fields.skip:isSelected())
	end
end
function SanctuaryDivinePanel:onDrawFiveClick()
	SoraDPlaySound()
	if self.max < self.curNum + 5 then
		SoraDShowMsgTip(i18n("Magic_draw_text_08"))
		return
	end
	if 5 > self.itemCount then
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		magicLampSkillShelterCtrl:sendDraw(self.poolID, 5, false, self.fields.skip:isSelected())
	end
end
function SanctuaryDivinePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("divine_protection_07")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SanctuaryDivinePanel:onMoliClick()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("MagicLampSkillMain")
end
return SanctuaryDivinePanel
