local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local gametop = gModuleMgr.getObject("gametop")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local lifeWaterCtrl = gametop.playertop_:getModule("lifeWaterCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local WAIT_TIME = 3
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LifeSpringsViewPanel = class("LifeSpringsViewPanel", baseFguiPanel)
function LifeSpringsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("LifeSpringsViewPanel:ctor", self.viewName)
end
function LifeSpringsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LifeSpringsViewPanel:onInit()
	print("=======LifeSpringsViewPanel:onInit")
	self.fields.waterCount:fixChildrenPos()
	self.fields.nodeProSingle:fixChildrenPos()
	self.newCur, _ENV = self.fields.nodeProSingle.fixChildrenPos, self.fields.nodeProSingle.fixChildrenPos
	self.timer = nil
	self.tabelResurgenceData, _ENV, self.state = gLifeWaterActivityState.CLOSE, gLifeWaterActivityState.CLOSE, gLifeWaterActivityState.CLOSE
	self.fields.Com_title:initData(i18n("common_text_3459"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.waterFields = fguiHelper.get_fields(self.fields.water)
	self.waterAllFields = fguiHelper.get_fields(self.fields.waterall)
	self.waterFields.title:setString(i18n("common_text_2508"))
	self.waterAllFields.title:setString(i18n("common_text_3462"))
	self.waterFields.Text_tip:setString(i18n("awakeSkillCrit_text_06"))
	self.waterAllFields.Text_tip:setString(i18n("awakeSkillCrit_text_06"))
	self.fields.labelDes:setString(i18n("common_text_3461"))
	self.fields.nodeProSingle:setValue(0)
	self.fields.Button_dead:addClickEventListener(handler(self, self.btnClickCallBack))
	self.labelNotice = self.waterFields.desc
	self.labelAllNotice = self.waterAllFields.desc
	self.fields.waterCount:setIcon("3018.png")
	self.fields.waterCount:getChildByName("icon2"):setURL(include("publicRead").getIcon(312701))
	self.btnAdd = self.waterFields.button_cost
	self.btnAdd:setIcon("3018.png")
	self.btnAllAdd = self.waterAllFields.button_cost
	self.btnAllAdd:setIcon("3018.png")
	self.btnAdd:addClickEventListener(handler(self, self.btnResurgenceClickCallBack))
	self.btnAllAdd:addClickEventListener(handler(self, self.btnResurgenceClickCallBack))
	self.fields.Btn_switch:setString(i18n("common_text_4759"))
	self.fields.Btn_switch:addClickListener(handler(self, self.btnSwitchClick))
	_ENV = handler(self, self.btnSwitchClick)
	handler(self, self.btnSwitchClick).byUID = true
	local isShowed = SoraDConfigGet("Game:LifeSpringsView:switch~bool", handler(self, self.btnSwitchClick))
	self.fields.Btn_switch:setReddot(not isShowed)
	self.fields.nodeProSingle:fixChildrenPos()
	self.btnAdd:fixChildrenPos()
	self.btnAllAdd:fixChildrenPos()
	self.fields.waterCount:fixChildrenPos()
	self:suitView()
	self:updateView()
end
function LifeSpringsViewPanel:suitView()
end
function LifeSpringsViewPanel:onShow()
	print("=======LifeSpringsViewPanel:onShow")
	self:initRechargeTinyPageNode()
	if self.state == gLifeWaterActivityState.OPEN then
		guideCtrl:updateGuideModule(gGuideModule.NEW_REVIVE_TREE)
	end
end
function LifeSpringsViewPanel:initRechargeTinyPageNode()
	self.isADShow = include("rechargeADRead").isADOpen("lifeSpringsView")
	self.fields.labelTime:setY(self.isADShow and self.isADShow.ADType and 168 or 78)
	dump(self.isADShow, "self.isADShow")
	if self.isADShow and self.isADShow.ADType then
		self.fields.rechargeTinyNode:setVisible(true)
		self.fields.rechargeTinyNode:setMyGiftType(self.isADShow.menuID)
	else
		self.fields.rechargeTinyNode:setVisible(false)
	end
end
function LifeSpringsViewPanel:resurgenceBack(target, data)
	if data.err == gErrDef.Err_None then
		self.tabelResurgenceData = data.redata
	end
	self:updateView()
end
function LifeSpringsViewPanel:updateState()
	self.state = lifeWaterCtrl:getResurrectionState()
end
function LifeSpringsViewPanel:openTimer()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function LifeSpringsViewPanel:closeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.fields.labelTime:setTitle(i18n("common_text_699"))
end
function LifeSpringsViewPanel:updateView()
	self:updateState()
	local curTotalArmy = lifeWaterCtrl:getTotalArmy()
	local itemCount1 = backpackCtrl:getItemCount(301801)
	local itemCount2 = backpackCtrl:getItemCount(312701)
	local itemCount = itemCount1 + itemCount2
	self.fields.waterCount:setTitle(string.formatnumberthousands(itemCount1))
	self.fields.waterCount:getChildByName("title2"):setString(string.formatnumberthousands(itemCount2))
	if self.state == gLifeWaterActivityState.CLOSE then
		self:closeTimer()
		lifeWaterCtrl = string.formatnumberthousands(itemCount2)
		string.formatnumberthousands(itemCount2).h = TIME_LIMITED_24_HOURS
		self.labelNotice:setString(i18n("common_text_3460", string.formatnumberthousands(itemCount2)))
		lifeWaterCtrl = i18n("common_text_3460", string.formatnumberthousands(itemCount2))
		i18n("common_text_3460", string.formatnumberthousands(itemCount2)).h = TIME_LIMITED_24_HOURS
		self.labelAllNotice:setString(i18n("common_text_3460", i18n("common_text_3460", string.formatnumberthousands(itemCount2))))
		self.btnAdd:setTitle("???")
		self.btnAllAdd:setTitle("???")
	elseif self.state == gLifeWaterActivityState.OPEN then
		self:openTimer()
		local needItemData = lifeWaterCtrl:getResurrectionNeedItem()
		local armyRate = lifeWaterCtrl:getResurrectionRate()
		local resurrectionCount = lifeWaterCtrl:getNextResurrectionArmyCount()
		local unResurrectionCount = lifeWaterCtrl:getUnResurrectionArmyCount()
		local baseCount = lifeWaterCtrl:getResurrectionArmyBaseCount()
		local quickData = lifeWaterCtrl:getQuickResurrectionInfo()
		self.newCur.totalArmyCount = lifeWaterCtrl:getTotalArmy()
		self.newCur.resurrectionArmyCount = lifeWaterCtrl:getResurrectionArmyCount()
		self.newCur.curPro = 0
		if unResurrectionCount == 0 then
			self.labelNotice:setString(i18n("common_text_2504"))
		elseif unResurrectionCount <= resurrectionCount + baseCount then
			lifeWaterCtrl = i18n("common_text_2504")
			i18n("common_text_2504").count = string.formatnumberthousands(unResurrectionCount)
			self.labelNotice:setString(i18n("common_text_2618", i18n("common_text_2504")))
		else
			lifeWaterCtrl = i18n("common_text_2618", i18n("common_text_2504"))
			i18n("common_text_2618", i18n("common_text_2504")).count = string.formatnumberthousands(resurrectionCount + baseCount)
			i18n("common_text_2618", i18n("common_text_2504")).base = string.formatnumberthousands(baseCount)
			i18n("common_text_2618", i18n("common_text_2504")).army = tostring(armyRate * 100) .. "%"
			self.labelNotice:setString(i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))))
		end
		if unResurrectionCount == 0 then
			self.labelAllNotice:setString(i18n("common_text_2504"))
		elseif unResurrectionCount <= quickData.resurrectionCount then
			lifeWaterCtrl = i18n("common_text_2504")
			i18n("common_text_2504").count = string.formatnumberthousands(quickData.resurrectionCount)
			self.labelAllNotice:setString(i18n("common_text_2618", i18n("common_text_2504")))
		else
			lifeWaterCtrl = i18n("common_text_2618", i18n("common_text_2504"))
			i18n("common_text_2618", i18n("common_text_2504")).count = string.formatnumberthousands(quickData.resurrectionCount)
			i18n("common_text_2618", i18n("common_text_2504")).base = string.formatnumberthousands(quickData.basecount)
			i18n("common_text_2618", i18n("common_text_2504")).army = tostring(quickData.rate * 100) .. "%"
			self.labelAllNotice:setString(i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))))
		end
		lifeWaterCtrl = i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504")))
		i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))).member = string.formatnumberthousands(itemCount)
		i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))).total = string.formatnumberthousands(needItemData[1].count)
		self.btnAdd:setTitle(i18n("common_text_155", i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504")))))
		self.btnAdd:setTitleColor(itemCount < needItemData[1].count and display.COLOR_RED or cc.c3b(255, 251, 13))
		lifeWaterCtrl = 251
		;(251).member = string.formatnumberthousands(itemCount)
		;(251).total = string.formatnumberthousands(quickData.needGood)
		self.btnAllAdd:setTitle(i18n("common_text_155", 251))
		self.btnAllAdd:setTitleColor(itemCount >= quickData.needGood and cc.c3b(255, 255, 0) or display.COLOR_RED)
		if self.newCur.totalArmyCount > 0 then
			self.newCur.curPro = 100 * self.newCur.resurrectionArmyCount / self.newCur.totalArmyCount
		end
		self.fields.nodeProSingle:setMax(self.newCur.totalArmyCount)
		self.fields.nodeProSingle:setValue(self.newCur.resurrectionArmyCount)
		self.btnAdd:setTag(needItemData[1].count)
		self.btnAllAdd:setTag(quickData.needGood)
	end
	self:setBtnStatus()
	self.fields.Btn_switch:setVisible(worldMapDefine.kingWarStatus == gKingdomWarStatusType.inWar and lordInfoCtrl:isInSelfKid())
end
function LifeSpringsViewPanel:openTimeUp()
	local leftTime = lifeWaterCtrl:getOpenLefttime()
	if 0 < leftTime then
		lifeWaterCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.labelTime:setTitle(i18n("common_text_607", nil))
	else
		self.fields.labelTime:setTitle(i18n("common_text_699"))
	end
end
function LifeSpringsViewPanel:setBtnStatus()
	self.btnAllAdd:setBright(self.state == gLifeWaterActivityState.OPEN)
	self.btnAdd:setBright(self.state == gLifeWaterActivityState.OPEN)
end
function LifeSpringsViewPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.RESURGENCE_SPRINGS)
end
function LifeSpringsViewPanel:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	_UPVALUE2_ = nil
	;(nil)[1] = 11399
	;(nil)[2] = 11397
	for _, v in ipairs(nil) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function LifeSpringsViewPanel:jumpToGift()
	local giftData = self:getGiftInfo()
	if giftData then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = tonumber(giftData.ID)
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
			panel:show()
		end
	else
		SoraDShowMsgTip(i18n("common_text_2512"), "#3018.png")
	end
end
function LifeSpringsViewPanel:btnResurgenceClickCallBack(button, type)
	SoraDPlaySound()
	if self.state == gLifeWaterActivityState.OPEN then
		if table.nums(lifeWaterCtrl:getDeadArmy()) > 0 then
			local itemCount1 = backpackCtrl:getItemCount(301801)
			local itemCount2 = backpackCtrl:getItemCount(312701)
			local itemCount = itemCount1 + itemCount2
			local needItemData = lifeWaterCtrl:getResurrectionNeedItem()
			local needCount = button:getTag()
			if itemCount < needCount then
				self:jumpToGift()
			else
				if self.btnAllAdd == button then
					lifeWaterCtrl:reqQuickResurrection()
				else
					lifeWaterCtrl:reqResurrection()
				end
				self:updateView()
			end
		else
			SoraDShowMsgBox(i18n("common_text_2504"), i18n("common_text_204"))
		end
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").h = TIME_LIMITED_24_HOURS
		SoraDShowMsgTip(i18n("common_text_3460", i18n("common_text_204")), "#btn_life_water.png")
	end
end
function LifeSpringsViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	SoraDCreatePanel("lifeSpringsDeadArmyInfoView"):show()
end
function LifeSpringsViewPanel:btnSwitchClick()
	SoraDPlaySound()
	uiManager:show("LifeSpringsSwitchSetting")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:LifeSpringsView:switch~bool", true, nil)
	self.fields.Btn_switch:setReddot(false)
end
function LifeSpringsViewPanel:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return LifeSpringsViewPanel
