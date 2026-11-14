local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local landOfSoulRead = include("landOfSoulRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRebornPanel = class("NebulaEmperorRebornPanel", baseFguiPanel)
function NebulaEmperorRebornPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorRebornPanel:ctor", self.viewName)
	self.cureArmyList, _ENV, self.tableArmy, _ENV = print, print, print, print
end
function NebulaEmperorRebornPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarEnergyCube"
	end
	return self._packageList
end
function NebulaEmperorRebornPanel:onInit()
	print("=======NebulaEmperorRebornPanel:onInit")
	self.fields.Com_title:initData(i18n("nebulaemperor_text_21"), handler(self, self.onClickClose), handler(self, self.onClick_btn_help_tip))
	local Label_time = self.fields.Com_title:getLabelTime()
	Label_time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_EMPEROR_SUMMON_ITEM"
		SoraDSendMessage(nil)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.fields.List_army:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_army:setVirtual()
	self.fields.btnExp:addClickListener(handler(self, self.insClickCallBack))
	self.fields.btnBuy:addClickListener(handler(self, self.onCureClick))
	self.fields.Button_gift:addClickListener(handler(self, self.onClickBtnGift))
end
function NebulaEmperorRebornPanel:onShow()
	print("=======NebulaEmperorRebornPanel:onShow")
	self:initData(self.param.armyList, self.param.activityID)
end
function NebulaEmperorRebornPanel:initData(armyList, activityID)
	self.activityID = activityID
	local remainTime = self:getSoulRemainTime(self.activityID)
	if 0 < remainTime then
		self.fields.Com_title:initSpecialActivityTime(remainTime)
	end
	self:updateItemCount()
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local item1 = gBadgeItemID.NEBULA_POWER
		local item2 = gBadgeItemID.TIME_LIMIT_NEBULA_POWER
		local icon1 = itemDesRead.getIcon(item1)
		local icon2 = itemDesRead.getIcon(item2)
		self.fields.Com_item1:setIcon(icon1)
		self.fields.Com_item2:setIcon(icon2)
		self.fields.txtSummon:setString(i18n("nebulaemperor_text_120"))
		self.fields.txtIns:setString(i18n("nebulaemperor_text_121"))
		self.fields.btnBuy:setString(i18n("nebulaemperor_text_124"))
		self.const_max = include("nebulaEmperorRead").getConstValue("reviveMaxNum", 0)
		self.fields.btnBuy:setCostIcon(icon1)
	end
	local curBless = self:getBlessValue()
	self.fields.bar:setMax(self.const_max)
	self.fields.bar:setValue(curBless)
	local armyIDList = self:getDeadArmyIDList()
	for i, v in ipairs(armyIDList) do
		local haveCount = armyList[tostring(v)] or 0
		if 0 < haveCount then
			_ENV = i18n("nebulaemperor_text_124")
			i18n("nebulaemperor_text_124").armyid = v
			i18n("nebulaemperor_text_124").armycount = haveCount
			i18n("nebulaemperor_text_124").curCount = 0
			table.insert(self.tableArmy, i18n("nebulaemperor_text_124"))
		end
	end
	self.fields.List_army:setNumItems(#self.tableArmy)
end
function NebulaEmperorRebornPanel:canCureSoldiersNum(armyId, armyCount)
	local _ENV, curArmyList
	curArmyList[tostring(armyId)] = armyCount
	local needSoulPower = 0
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		needSoulPower = nebulaEmperorCtrl:getRestoreNeedSoulNum(curArmyList)
	else
		needSoulPower = landOfSoulCtrl:getRestoreNeedSoulNum(curArmyList, self.activityID)
	end
	return needSoulPower
end
function NebulaEmperorRebornPanel:singleSliderChange(target, data)
	self.needSoulPower = 0
	for i, v in ipairs(self.tableArmy) do
		if v.armyid == data.armyid then
			v.curCount = data.armycount
			if 0 < v.curCount then
				self.cureArmyList[tostring(v.armyid)] = v.curCount
			else
				self.cureArmyList[tostring(v.armyid)] = nil
			end
		end
		self.needSoulPower = self.needSoulPower + self:canCureSoldiersNum(v.armyid, v.curCount)
	end
	self.needSoulPower = math.ceil(self.needSoulPower)
	local addBless = 0
	local curBless = self:getBlessValue()
	local totalBless = curBless + self.needSoulPower
	if self.activityID == gActivityTimeActivityID.LEGEND_LORD or self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
		addBless = landOfSoulRead:getNeedBless(self.needSoulPower)
		_ENV = self
		self.num = addBless
		self.fields.txtmdl:setString(i18n("heroicSouls_text_7", self))
	elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local reviveBless = include("nebulaEmperorRead").getConstValue("reviveBless", 1)
		addBless = self.needSoulPower * reviveBless
		_ENV = i18n("heroicSouls_text_7", self)
		i18n("heroicSouls_text_7", self).num = addBless
		self.fields.txtmdl:setString(i18n("nebulaemperor_text_123", i18n("heroicSouls_text_7", self)))
	else
		addBless = landOfSoulRead:getNeedBlessHegemon(self.needSoulPower)
		_ENV = i18n("nebulaemperor_text_123", i18n("heroicSouls_text_7", self))
		i18n("nebulaemperor_text_123", i18n("heroicSouls_text_7", self)).num = addBless
		self.fields.txtmdl:setString(i18n("heroicSouls_text_17", i18n("nebulaemperor_text_123", i18n("heroicSouls_text_7", self))))
	end
	if totalBless >= self.const_max then
		self.needSoulPower = self.const_max - curBless
	end
	self.fields.btnBuy:setCostNum(self.needSoulPower, self.ownSoulPower, true)
	self.fields.btnBuy:setEnabled(self.needSoulPower > 0)
end
function NebulaEmperorRebornPanel:onCureClick(...)
	SoraDPlaySound()
	if self.ownSoulPower < self.needSoulPower and self.ownSoulPower < self.const_max then
		local kingStr = ""
		if self.activityID == gActivityTimeActivityID.LEGEND_LORD or self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
			kingStr = i18n("heroicSouls_text_4")
		elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
			kingStr = i18n("nebulaemperor_text_125")
		else
			kingStr = i18n("heroicSouls_text_18")
		end
		SoraDShowMsgBox(kingStr, i18n("common_text_054"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				if self.activityID == gActivityTimeActivityID.LEGEND_LORD or self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
					if GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
					if GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				elseif GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeID = 13912
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, 13912)
					panel:show()
				end
			end
		end)
		return
	end
	local addBless = landOfSoulRead:getNeedBless(self.needSoulPower)
	local curBless = self:getBlessValue()
	local remainBless = self.const_max - curBless
	if remainBless <= 0 then
		remainBless = 0
	end
	if addBless >= self.const_max then
		_ENV = nil
		;(nil).num = remainBless
		SoraDShowMsgBox(i18n("heroicSouls_text_8", nil), i18n("common_text_054"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				self:reqInvolkeDeadArmy(self.activityID, self.cureArmyList)
				SoraDShowLoading(self:displayObject())
			end
		end)
	else
		self:reqInvolkeDeadArmy(self.activityID, self.cureArmyList)
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaEmperorRebornPanel:insClickCallBack(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.LEGEND_LORD then
		_ENV = "heroicSouls_text_6"
		;("heroicSouls_text_6").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("heroicSouls_text_6"), "heroicSouls_text_6")
	elseif self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
		_ENV = "kingstarbattle_text_57"
		;("kingstarbattle_text_57").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("kingstarbattle_text_57"), "kingstarbattle_text_57")
	elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		_ENV = "nebulaemperor_text_122"
		;("nebulaemperor_text_122").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("nebulaemperor_text_122"), "nebulaemperor_text_122")
	else
		_ENV = "heroicSouls_text_16"
		;("heroicSouls_text_16").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("heroicSouls_text_16"), "heroicSouls_text_16")
	end
end
function NebulaEmperorRebornPanel:onClick_btn_help_tip(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.LEGEND_LORD then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LEGEND_KING_LAND)
	elseif self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.KING_STAR_LAND)
	elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		nebulaEmperorUtil.showSingleFAQ()
	elseif IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LEGEND_HEGEMON_LAND)
	else
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HEGEMON_LORD_ROS)
	end
end
function NebulaEmperorRebornPanel:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function NebulaEmperorRebornPanel:getBlessValue(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		return nebulaEmperorCtrl:getBlessValue()
	else
		return landOfSoulCtrl:getBlessValue()
	end
end
function NebulaEmperorRebornPanel:getDeadArmyIDList(...)
	local _ENV, armyIDList
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		armyIDList = nebulaEmperorCtrl:getDeadArmyIDList()
	else
		armyIDList = landOfSoulCtrl:getDeadArmyIDList()
	end
	table.sort(armyIDList, function(army1, army2)
		local armyID1 = army1 % 1000
		local armyID2 = army2 % 1000
		local armyLv1 = armyID1 % 100
		local armyLv2 = armyID2 % 100
		if armyLv1 == armyLv2 then
			return armyID1 < armyID2
		else
			return armyLv1 > armyLv2
		end
	end)
	return armyIDList
end
function NebulaEmperorRebornPanel:getSoulRemainTime(activityID)
	if activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		return nebulaEmperorCtrl:getSoulRemainTime()
	else
		return landOfSoulCtrl:getSoulRemainTime(activityID)
	end
end
function NebulaEmperorRebornPanel:reqInvolkeDeadArmy(activityID, armyList)
	if activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		nebulaEmperorCtrl:reqSummonArmy(armyList)
	else
		landOfSoulCtrl:reqInvolkeDeadArmy(activityID, armyList)
	end
end
function NebulaEmperorRebornPanel:onItemRederer(index, obj)
	local data = self.tableArmy[index + 1]
	obj:setSliderChangeBack(handler(self, self.singleSliderChange))
	obj:initData(data)
end
function NebulaEmperorRebornPanel:onClickBtnGift(...)
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function NebulaEmperorRebornPanel:onMsgHeroicLandRefresh(target, event)
	SoraDCloseLoading(self:displayObject())
	self.tableArmy, _ENV, self.cureArmyList, _ENV = SoraDCloseLoading, SoraDCloseLoading, SoraDCloseLoading, SoraDCloseLoading
	local deadArmyList, cureArmyList, blessArmyList
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		deadArmyList = nebulaEmperorCtrl:getDeadArmyList()
		cureArmyList = nebulaEmperorCtrl:getCureArmyList()
		blessArmyList = nebulaEmperorCtrl:getBlessArmyList()
	else
		deadArmyList = landOfSoulCtrl:getDeadArmyList()
		cureArmyList = landOfSoulCtrl:getCureArmyList()
		blessArmyList = landOfSoulCtrl:getBlessArmyList()
	end
	dump(blessArmyList, "weqlkrjwlkrjwe")
	if next(blessArmyList) then
		_ENV = self:displayObject()
		self:displayObject().activityID = self.activityID
		uiManager:show("NebulaEmperorRebornBless", self:displayObject())
	else
		self.summonPanel = SoraDSearchPanelFromManagerByName("summonSuccessfulView")
		if self.summonPanel then
			self.summonPanel:initData(cureArmyList, self.activityID)
			return
		end
		self.summonPanel = SoraDCreatePanel("summonSuccessfulView")
		self.summonPanel:initData(cureArmyList, self.activityID)
		self.summonPanel:show()
	end
	if next(deadArmyList) then
		self:initData(deadArmyList, self.activityID)
	else
		self:removeFromParent()
	end
end
function NebulaEmperorRebornPanel:onMsgUpdateItemCount(...)
	self:updateItemCount()
	self.fields.btnBuy:setCostNum(self.needSoulPower, self.ownSoulPower, true)
end
function NebulaEmperorRebornPanel:updateItemCount(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local item1 = gBadgeItemID.NEBULA_POWER
		local item2 = gBadgeItemID.TIME_LIMIT_NEBULA_POWER
		local itemCount1 = backpackCtrl:getItemCount(item1)
		local itemCount2 = backpackCtrl:getItemCount(item2)
		self.ownSoulPower = itemCount1 + itemCount2
		self.fields.Com_item1:setString(string.formatnumberthousands(itemCount1))
		self.fields.Com_item2:setString(string.formatnumberthousands(itemCount2))
	end
end
return NebulaEmperorRebornPanel
