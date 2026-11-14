local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local gametop = gModuleMgr.getObject("gametop")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ResurgenceTreeViewPanel = class("ResurgenceTreeViewPanel", baseFguiPanel)
function ResurgenceTreeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("ResurgenceTreeViewPanel:ctor", self.viewName)
end
function ResurgenceTreeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ResurgenceTreeViewPanel:onInit()
	self.fields.waterCount:fixChildrenPos()
	self.fields.nodeProSingle:fixChildrenPos()
	self.newCur, _ENV = self.fields.nodeProSingle.fixChildrenPos, self.fields.nodeProSingle.fixChildrenPos
	self.timer = nil
	self.tabelResurgenceData, _ENV, self.state = gResurrectionActivityState.CLOSE, gResurrectionActivityState.CLOSE, gResurrectionActivityState.CLOSE
	print("=======ResurgenceTreeViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2499"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.waterFields = fguiHelper.get_fields(self.fields.water)
	self.waterAllFields = fguiHelper.get_fields(self.fields.waterall)
	self.waterFields.title:setString(i18n("common_text_2502"))
	self.waterAllFields.title:setString(i18n("common_text_2723"))
	self.waterFields.Text_tip:setString(i18n("awakeSkillCrit_text_06"))
	self.waterAllFields.Text_tip:setString(i18n("awakeSkillCrit_text_06"))
	self.fields.labelDes:setString(i18n("common_text_2500"))
	self.fields.nodeProSingle:setValue(0)
	self.fields.Button_dead:addClickEventListener(handler(self, self.btnClickCallBack))
	self.labelNotice = self.waterFields.desc
	self.labelAllNotice = self.waterAllFields.desc
	self.fields.waterCount:setIcon("3013.png")
	self.fields.waterCount:getChildByName("icon2"):setURL(include("publicRead").getIcon(312801))
	self.btnAdd = self.waterFields.button_cost
	self.btnAdd:setIcon("3013.png")
	self.btnAllAdd = self.waterAllFields.button_cost
	self.btnAllAdd:setIcon("3013.png")
	self.btnAdd:addClickEventListener(handler(self, self.btnResurgenceClickCallBack))
	self.btnAllAdd:addClickEventListener(handler(self, self.btnResurgenceClickCallBack))
	self.fields.Btn_switch:setString(i18n("common_text_4759"))
	self.fields.Btn_switch:addClickListener(handler(self, self.btnSwitchClick))
	self.fields.Btn_switch:setVisible(false)
	_ENV = false
	;(false).byUID = true
	local isShowed = SoraDConfigGet("Game:kingdomBattle:hospitalSwitch~bool", false)
	self.fields.Btn_switch:setReddot(not isShowed)
	self.fields.Button_shop:addClickListener(handler(self, self.btnShopClick))
	self.fields.Button_shop:fixPos()
	self.fields.nodeProSingle:fixChildrenPos()
	self.btnAdd:fixChildrenPos()
	self.btnAllAdd:fixChildrenPos()
	self.fields.waterCount:fixChildrenPos()
	self:suitView()
	self:updateView()
end
function ResurgenceTreeViewPanel:onShow()
	print("=======ResurgenceTreeViewPanel:onShow")
end
function ResurgenceTreeViewPanel:suitView()
end
function ResurgenceTreeViewPanel:updateState()
	self.state = resurrectionCtrl:getResurrectionState()
end
function ResurgenceTreeViewPanel:openTimer()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function ResurgenceTreeViewPanel:closeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.fields.labelTime:setString(i18n("common_text_699"))
end
function ResurgenceTreeViewPanel:resurgenceBack(target, data)
	if data and data.err == gErrDef.Err_None then
		self.tabelResurgenceData = data.redata
	end
	self:updateView()
end
function ResurgenceTreeViewPanel:updateView(target, data)
	self:updateState()
	local itemCount1 = backpackCtrl:getItemCount(301301)
	local itemCount2 = backpackCtrl:getItemCount(312801)
	local itemCount = itemCount1 + itemCount2
	self.fields.waterCount:setTitle(string.formatnumberthousands(itemCount1))
	self.fields.waterCount:getChildByName("title2"):setString(string.formatnumberthousands(itemCount2))
	if self.state == gResurrectionActivityState.CLOSE then
		self:closeTimer()
		backpackCtrl = string.formatnumberthousands(itemCount2)
		string.formatnumberthousands(itemCount2).h = TIME_LIMITED_72_HOURS
		self.labelNotice:setString(i18n("common_text_2503", string.formatnumberthousands(itemCount2)))
		backpackCtrl = i18n("common_text_2503", string.formatnumberthousands(itemCount2))
		i18n("common_text_2503", string.formatnumberthousands(itemCount2)).h = TIME_LIMITED_72_HOURS
		self.labelAllNotice:setString(i18n("common_text_2503", i18n("common_text_2503", string.formatnumberthousands(itemCount2))))
		self.btnAdd:setTitle("???")
		self.btnAllAdd:setTitle("???")
	elseif self.state == gResurrectionActivityState.OPEN then
		self:openTimer()
		local needItemData = resurrectionCtrl:getResurrectionNeedItem()
		local armyRate = resurrectionCtrl:getResurrectionRate()
		local resurrectionCount = resurrectionCtrl:getNextResurrectionArmyCount()
		local unResurrectionCount = resurrectionCtrl:getUnResurrectionArmyCount()
		local baseCount = resurrectionCtrl:getResurrectionArmyBaseCount()
		local quickData = resurrectionCtrl:getQuickResurrectionInfo()
		self.newCur.totalArmyCount = resurrectionCtrl:getTotalArmy()
		self.newCur.resurrectionArmyCount = resurrectionCtrl:getResurrectionArmyCount()
		self.newCur.curPro = 0
		if unResurrectionCount == 0 then
			self.labelNotice:setString(i18n("common_text_2504"))
		elseif unResurrectionCount <= resurrectionCount + baseCount then
			backpackCtrl = i18n("common_text_2504")
			i18n("common_text_2504").count = string.formatnumberthousands(unResurrectionCount)
			self.labelNotice:setString(i18n("common_text_2618", i18n("common_text_2504")))
		else
			backpackCtrl = i18n("common_text_2618", i18n("common_text_2504"))
			i18n("common_text_2618", i18n("common_text_2504")).count = string.formatnumberthousands(resurrectionCount + baseCount)
			i18n("common_text_2618", i18n("common_text_2504")).base = string.formatnumberthousands(baseCount)
			i18n("common_text_2618", i18n("common_text_2504")).army = tostring(armyRate * 100) .. "%"
			self.labelNotice:setString(i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))))
		end
		if unResurrectionCount == 0 then
			self.labelAllNotice:setString(i18n("common_text_2504"))
		elseif unResurrectionCount <= quickData.resurrectionCount then
			backpackCtrl = i18n("common_text_2504")
			i18n("common_text_2504").count = string.formatnumberthousands(quickData.resurrectionCount)
			self.labelAllNotice:setString(i18n("common_text_2618", i18n("common_text_2504")))
		else
			backpackCtrl = i18n("common_text_2618", i18n("common_text_2504"))
			i18n("common_text_2618", i18n("common_text_2504")).count = string.formatnumberthousands(quickData.resurrectionCount)
			i18n("common_text_2618", i18n("common_text_2504")).base = string.formatnumberthousands(quickData.basecount)
			i18n("common_text_2618", i18n("common_text_2504")).army = tostring(quickData.rate * 100) .. "%"
			self.labelAllNotice:setString(i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))))
		end
		backpackCtrl = i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504")))
		i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))).member = string.formatnumberthousands(itemCount)
		i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504"))).total = string.formatnumberthousands(needItemData[1].count)
		self.btnAdd:setTitle(i18n("common_text_155", i18n("common_text_2501", i18n("common_text_2618", i18n("common_text_2504")))))
		self.btnAdd:setTitleColor(itemCount < needItemData[1].count and display.COLOR_RED or cc.c3b(255, 255, 0))
		backpackCtrl = 255
		;(255).member = string.formatnumberthousands(itemCount)
		;(255).total = string.formatnumberthousands(quickData.needGood)
		self.btnAllAdd:setTitle(i18n("common_text_155", 255))
		self.btnAllAdd:setTitleColor(itemCount >= quickData.needGood and cc.c3b(255, 255, 0) or display.COLOR_RED)
		self.fields.nodeProSingle:setMax(self.newCur.totalArmyCount)
		self.fields.nodeProSingle:setValue(self.newCur.resurrectionArmyCount)
		self.btnAdd:setTag(needItemData[1].count)
		self.btnAllAdd:setTag(quickData.needGood)
	end
	self:stateEffect()
	local battleState = conquestWarCtrl:getConquestWarState()
	self.fields.Btn_switch:setVisible(battleState == gConquestWarState.OPENING)
end
function ResurgenceTreeViewPanel:openTimeUp()
	local leftTime = resurrectionCtrl:getOpenLefttime()
	if 0 < leftTime then
		resurrectionCtrl = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.labelTime:setString(i18n("common_text_607", nil))
	else
		self.fields.labelTime:setString(i18n("common_text_699"))
	end
end
function ResurgenceTreeViewPanel:stateEffect()
	if self.state == gResurrectionActivityState.CLOSE then
		self.btnAdd:setBright(false)
		self.btnAllAdd:setBright(false)
	elseif self.state == gResurrectionActivityState.OPEN then
		self.btnAllAdd:setBright(true)
		self.btnAdd:setBright(true)
	end
end
function ResurgenceTreeViewPanel:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.RESURGENCE_TREE)
	end
end
function ResurgenceTreeViewPanel:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	if IsArClient then
		_UPVALUE3_ = IsArClient
		IsArClient[1] = 10005
		IsArClient[2] = 11071
		IsArClient[3] = 11917
		if IsArClient then
			goto lbl_18
		end
	end
	_UPVALUE2_ = IsArClient
	IsArClient[1] = 10005
	local IsArClient[2], tbl = 11917, IsArClient
	::lbl_18::
	for _, v in ipairs(tbl) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function ResurgenceTreeViewPanel:jumpToGift()
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
		SoraDShowMsgTip(i18n("common_text_2512"), "#3013.png")
	end
end
function ResurgenceTreeViewPanel:btnResurgenceClickCallBack(button, type)
	SoraDPlaySound()
	if self.state == gResurrectionActivityState.OPEN then
		if table.nums(resurrectionCtrl:getDeadArmy()) > 0 then
			local itemCount1 = backpackCtrl:getItemCount(301301)
			local itemCount2 = backpackCtrl:getItemCount(312801)
			local itemCount = itemCount1 + itemCount2
			local needItemData = resurrectionCtrl:getResurrectionNeedItem()
			local needCount = button:getTag()
			if itemCount < needCount then
				self:jumpToGift()
			else
				if self.btnAllAdd == button then
					resurrectionCtrl:reqQuickResurrection()
				else
					resurrectionCtrl:reqResurrection()
				end
				self:updateView()
			end
		else
			SoraDShowMsgBox(i18n("common_text_2504"), i18n("common_text_204"))
		end
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").h = TIME_LIMITED_72_HOURS
		SoraDShowMsgTip(i18n("common_text_2503", i18n("common_text_204")), "#btn_rechareactivity_27.png")
	end
end
function ResurgenceTreeViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	SoraDCreatePanel("resurgenceDeadArmyInfoView"):show()
end
function ResurgenceTreeViewPanel:btnShopClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001553, true) then
		local commonExchangeUtil = include("commonExchangeUtil")
		commonExchangeUtil.openView(gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001553)
	end
end
function ResurgenceTreeViewPanel:btnSwitchClick()
	SoraDPlaySound()
	uiManager:show("kingdomBattleHospitalSwitch")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:kingdomBattle:hospitalSwitch~bool", true, nil)
	self.fields.Btn_switch:setReddot(false)
end
return ResurgenceTreeViewPanel
