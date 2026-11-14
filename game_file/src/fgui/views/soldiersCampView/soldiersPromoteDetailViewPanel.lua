local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local armyDesRead = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local armyLogic = include("armyLogic")
local resDesRead = include("resDesRead")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersPromoteDetailViewPanel = class("soldiersPromoteDetailViewPanel", baseFguiPanel)
function soldiersPromoteDetailViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("soldiersPromoteDetailViewPanel:ctor", self.viewName)
end
function soldiersPromoteDetailViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function soldiersPromoteDetailViewPanel:onInit()
	print("=======soldiersPromoteDetailViewPanel:onInit")
	self.proSoldier, _ENV = print, print
	self.needResList, _ENV, self.resNeedList, _ENV, self.promoteCount = print, print, print, print, 1
	self.fields.Panel_bg:setString(i18n("arms_promotion_title_01"))
	self.fields.List_res:setAlignCenter(true)
	self.fields.List_res:setItemRenderer(handler(self, self.onResRender))
	self.fields.Button_Wear:setString(i18n("Soldiers_armor_text_26"))
	self.fields.Button_Wear:setVisible(false)
	self.fields.Button_Wear:addClickListener(handler(self, self.btnWearClickCallBack))
	self.fields.Button_info:addClickListener(handler(self, self.btnInfoClickCallBack))
	self.fields.Text_tool:setVisible(false)
	self.fields.Button_tip:setVisible(false)
	self.fields.Button_tip:addClickListener(handler(self, self.btnTipClickCallBack))
	self.fields.Button_tool:setVisible(false)
	self.fields.Button_tool:addClickListener(handler(self, self.btnToolClickCallBack))
	self.fields.Button_promote:setString(i18n("arms_promotion_btn_01"))
	self.fields.Button_promote:addClickListener(handler(self, self.btnPromoteClickCallBack))
	self.fields.Button_atOnce:setString(i18n("arms_promotion_btn_02"))
	self.fields.Button_atOnce:addClickListener(handler(self, self.btnPromoteAtonceClickCallBack))
	self.fields.slider:setSliderCallBack(handler(self, self.trainSoldierSlider))
	self.armorIndex = 1
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightClick))
	self.fields.Com_source:fixPos()
	self.fields.Com_target:fixPos()
	self.fields.jh:fix()
	self.fields.Button_info:fixPos()
	self.fields.Com_infoSource:fixPos()
	self.fields.Com_infoTarget:fixPos()
	self.fields.Button_atOnce:fixPos()
	self.fields.Button_promote:fixPos()
	self.fields.Text_tool:fixPos()
	self.fields.Button_tip:fixPos()
	self.fields.slider:setInpuBoxFixPos()
	self.fields.slider:fixPos()
	self.fields.Button_tool:fixPos()
end
function soldiersPromoteDetailViewPanel:onShow()
	print("=======soldiersPromoteDetailViewPanel:onShow")
	self.curSoldier = self.param.armyData
	self.curArmorId = self.param.armorId
	self:initData()
	self:updateLRBtns()
end
function soldiersPromoteDetailViewPanel:onResRender(index, obj)
	obj:initData(self.resNeedList[index + 1], self.needResList, self)
end
function soldiersPromoteDetailViewPanel:initData()
	self.bid = armyltCtrl.armyAttr(self.curSoldier.armyid, ARMY_ATTR.BARRACK_ID)
	self.armyType = armyltCtrl.armyAttr(self.curSoldier.armyid, ARMY_ATTR.ARMY_TYPE)
	local _armorId, _armorIdList = armorSystemRead:getArmorIdByArmyId(self.curSoldier.armyid, true, true)
	local armyltCtrl, armorIdList = self.curSoldier.armyid, self.curSoldier.armyid
	for _, armorId in ipairs(_armorIdList) do
		local cfg = armorSystemRead:getArmorRefSoldierInfo(armorId)
		armyltCtrl = armorId
		armorId.isArmorID = true
		armorId.armorID = armorId
		local isUnlock = SoraDIsBrave8Level(armorId)
		if cfg.newLv == 14 then
			armyltCtrl = nil
			;(nil).isArmorID = true
			;(nil).armorID = armorId
			isUnlock = SoraDIsGildedArmorOpen(nil)
		end
		if isUnlock then
			table.insert(armorIdList, armorId)
		end
	end
	if 1 < #armorIdList then
		table.sort(armorIdList, function(a, b)
			return b < a
		end)
	end
	local armorId = self.curArmorId or armorIdList[1]
	if armorId then
		local cfg = armorSystemRead:getArmorRefSoldierInfo(armorId)
		local ret = cfg.newLv == 14 and armyCtrl:getGildedframeInfo(self.bid) or armyCtrl:getWarframeInfo(self.bid)
		local lv = ret[tostring(self.armyType)].lv
		local armyid = ret[tostring(self.armyType)].armyid
		self.armorId = armorId
		self.armorIdList = armorIdList
		self.proSoldier.lv = lv
		self.proSoldier.armyid = armyid
		self:initWarframeView()
	else
		local ret = armyCtrl:getTrainMaxLvByBid(self.bid)
		local lv = ret[tostring(self.armyType)].lv
		local armyid = ret[tostring(self.armyType)].armyid
		self.proSoldier.lv = lv
		self.proSoldier.armyid = armyid
		self:initView()
	end
	self:updateArmyDetail()
end
function soldiersPromoteDetailViewPanel:updateLRBtns()
	if not self.param.armorId and self.armorId and SoraDIsGildedArmorOpen() then
		self.fields.Button_left:setVisible(self.armorIndex == 2)
		self.fields.Button_right:setVisible(self.armorIndex == 1 and 1 < #self.armorIdList)
	else
		self.fields.Button_left:setVisible(false)
		self.fields.Button_right:setVisible(false)
	end
end
function soldiersPromoteDetailViewPanel:updateArmyShow()
	self.fields.Com_source:initData(self.curSoldier.armyid, self.promoteCount)
	self.fields.Com_target:initData(self.proSoldier.armyid, self.promoteCount, true)
end
function soldiersPromoteDetailViewPanel:updateArmyDetail()
	self.fields.Com_infoSource:initData(self.curSoldier.armyid)
	self.fields.Com_infoTarget:initData(self.proSoldier.armyid, true, self.curSoldier.armyid)
end
function soldiersPromoteDetailViewPanel:updateTool()
	local toolAddInfo = armyCtrl:getSingleAddInfo()
	local barrackID = armyltCtrl.armyAttr(self.curSoldier.armyid, ARMY_ATTR.BARRACK_ID)
	local isShowTool = false
	if toolAddInfo and next(toolAddInfo) then
		isShowTool = toolAddInfo.itemCount > 0 and barrackID ~= BUILDID.ELITE_PALACE
		armyCtrl = nil
		;(nil).addCount = toolAddInfo.addCount
		armyCtrl = nil
		;(nil).itemCount = toolAddInfo.itemCount
		self.fields.Text_tool:setString(i18n("common_text_3529", nil) .. " " .. i18n("common_text_3528", nil))
	end
	self.fields.Text_tool:setVisible(isShowTool)
	self.fields.Button_tip:setVisible(isShowTool)
	local itemList = backpackltCtrl:getItemArray(gItemType.SINGLE_TRAIN_ADD_COUNT)
	local isHaveTool = false
	for k, v in ipairs(itemList) do
		local itemCount = backpackCtrl:getItemCount(v)
		if 0 < itemCount then
			isHaveTool = true
			break
		end
	end
	local ret = isHaveTool and barrackID ~= BUILDID.ELITE_PALACE
	self.fields.Button_tool:setVisible(ret)
	self.fields.slider:setPositionX(ret and (SoraDFIsRA() and self.view:getWidth() / 2 + 20 or self.view:getWidth() / 2 - 20) or self.view:getWidth() / 2)
end
function soldiersPromoteDetailViewPanel:updateResource()
	if armyCtrl:isCanWearWarframe(self.curSoldier.armyid) or armyCtrl:isCanWearGilded(self.curSoldier.armyid) then
		armyCtrl, armyCtrl = armyCtrl, armyCtrl:isCanWearGilded(self.curSoldier.armyid)
		armyCtrl.resid = self.armorId
		armyCtrl.rescount = self.promoteCount
		armyCtrl.curcount = armorSystemCtrl:getArmorNumByID(self.armorId)
		armyCtrl.isArmor = true
		armyCtrl.noDiscount = true
		armyCtrl, armyCtrl:isCanWearGilded(self.curSoldier.armyid)[1], armyCtrl.handle = armyCtrl, armyCtrl, handler(self, self.goWarFrameForge)
		armyCtrl.resid = self.curSoldier.armyid
		armyCtrl.rescount = self.promoteCount
		armyCtrl.curcount = armyCtrl:getArmyCountByLv(armyltCtrl.getArmyTypeAndLv(self.curSoldier.armyid))
		armyCtrl.isArmor = true
		armyCtrl.noDiscount = true
		self.resNeedList, armyCtrl:isCanWearGilded(self.curSoldier.armyid)[2], armyCtrl.handle = armyCtrl:isCanWearGilded(self.curSoldier.armyid), armyCtrl, handler(self, self.goSoldiersCamp)
		local isEnough = true
		for k, v in ipairs(self.resNeedList) do
			if v.rescount > v.curcount then
				isEnough = false
				break
			end
		end
		self.fields.Button_Wear:setTitleColor(isEnough and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	else
		self.resNeedList = armyLogic.getPromptResCanBuy(self.curSoldier.armyid, self.proSoldier.armyid, self.promoteCount)
		for k, v in ipairs(self.resNeedList) do
			if v.resid == gIDDef.ELITE_POINT then
				v.curcount = include("elitePalaceAPI"):getElitePoint()
			else
				v.curcount = cityCtrl:getResCount(v.resid)
			end
		end
	end
	self.fields.List_res:setNumItems(#self.resNeedList)
end
function soldiersPromoteDetailViewPanel:updateBtns()
	local time = armyLogic.getPromptTime(self.curSoldier.armyid, self.proSoldier.armyid, self.promoteCount)
	self.fields.Button_promote:setCostTitle(SoraDConvertSecondToString(time))
	self.atonceGold = armyLogic.getPromptGold(self.needResList, time)
	self.fields.Button_atOnce:setCostTitle(string.formatnumberthousands(self.atonceGold))
end
function soldiersPromoteDetailViewPanel:updateData(data)
	self.curSoldier = data
	self:initData()
end
function soldiersPromoteDetailViewPanel:trainSoldierSlider(num)
	self.promoteCount = num
	self:updateView()
end
function soldiersPromoteDetailViewPanel:updateView()
	if self.isWarframePromote then
		self:updateResource()
		self:updateArmyShow()
		return
	end
	self:updateTool()
	self.resNeedList = armyLogic.getPromptResCanBuy(self.curSoldier.armyid, self.proSoldier.armyid, self.promoteCount)
	for k, v in ipairs(self.resNeedList) do
		if v.resid == gIDDef.ELITE_POINT then
			v.curcount = include("elitePalaceAPI"):getElitePoint()
		else
			v.curcount = cityCtrl:getResCount(v.resid)
		end
	end
	self.needResList, armyLogic = ipairs(self.resNeedList)
	self.isShortElite = false
	for k, v in ipairs(self.resNeedList) do
		local isNotEnough = false
		local curcount = 0
		if v.resid == gIDDef.ELITE_POINT then
			curcount = include("elitePalaceAPI"):getElitePoint()
			isNotEnough = curcount < v.rescount
			self.isShortElite = isNotEnough
		else
			isNotEnough = cityCtrl:getResCount(v.resid) < v.rescount
			curcount = cityCtrl:getResCount(v.resid)
		end
		armyLogic = cityCtrl:getResCount(v.resid)
		cityCtrl:getResCount(v.resid).resid = v.resid
		cityCtrl:getResCount(v.resid).curcount = curcount
		local cityCtrl:getResCount(v.resid).rescount, needResSingle = v.rescount, cityCtrl:getResCount(v.resid)
		if v.resid ~= gIDDef.ELITE_POINT then
			table.insert(self.needResList, needResSingle)
		end
	end
	self.isShortRes = false
	local curBlessType = luckyBlessCtrl:getCurEffectType()
	local useDiscount = curBlessType and curBlessType == gLuckyBlessActivityEffectType.TRAIN_SOLDIERS
	for k, v in ipairs(self.needResList) do
		local needCount = v.rescount
		if useDiscount then
			needCount = luckyBlessCtrl:getResult(v.rescount)
			v.rescount = needCount
		end
		if needCount > v.curcount then
			self.isShortRes = true
		end
	end
	self.fields.List_res:setNumItems(#self.resNeedList)
	self:updateArmyShow()
	self:updateResource()
	self:updateBtns()
end
function soldiersPromoteDetailViewPanel:initView()
	self.promoteCount = armyLogic.getMaxPromoteCount(self.curSoldier.armyid)
	local buildID = armyltCtrl.getArmyAttrAndSp(self.curSoldier.armyid, ARMY_ATTR.BARRACK_ID)
	local canTrainMax = armyLogic.getMaxTrainCount(buildID)
	local ownCount = self.curSoldier.armycount or armyCtrl:getArmyCount(self.curSoldier.armyid, ARMY_OPTYPE.NORMAL_ARMY)
	local max = math.min(canTrainMax.total, ownCount)
	if buildID == BUILDID.ELITE_PALACE then
		local _, elitePoint = armyLogic.getPromptResCanBuy(self.curSoldier.armyid, self.proSoldier.armyid, 1)
		if elitePoint then
			max = math.min(canTrainMax.add + canTrainMax.base, ownCount)
			local ownElitePoint = include("elitePalaceAPI"):getElitePoint()
			self.promoteCount = math.min(max, math.floor(ownElitePoint / elitePoint))
		end
	end
	armyLogic = include("elitePalaceAPI"):getElitePoint()
	include("elitePalaceAPI"):getElitePoint().maxValue = max
	include("elitePalaceAPI"):getElitePoint().minValue = 1
	include("elitePalaceAPI"):getElitePoint().curValue = self.promoteCount
	self.fields.slider:initData((include("elitePalaceAPI"):getElitePoint()))
	local enable = not worldMapDefine.isInWarForbidSoldier(true)
	self.fields.Button_promote:setEnabled(enable)
	self.fields.Button_atOnce:setEnabled(enable)
end
function soldiersPromoteDetailViewPanel:initWarframeView()
	self.fields.Panel_bg:setString(i18n("Soldiers_armor_text_34"))
	self.isWarframePromote = true
	if not self.armorId then
		return
	end
	local armorNum = armorSystemCtrl:getArmorNumByID(self.armorId)
	local armyNum = armorSystemCtrl:getArmyNumByArmorId(self.armorId)
	self.promoteCount = math.min(armorNum, armyNum)
	_ENV = armyNum
	armyNum.maxValue = math.min(include("constantRead").getConstValue("ARMOR_WEAR_LIMIT_NUM"), math.max(armorNum, armyNum))
	armyNum.minValue = 1
	armyNum.curValue = self.promoteCount
	self.fields.slider:initData(armyNum)
	self:updateArmyShow()
	self.fields.Button_promote:setVisible(false)
	self.fields.Button_atOnce:setVisible(false)
	self.fields.Button_Wear:setVisible(true)
end
function soldiersPromoteDetailViewPanel:btnWearClickCallBack()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	if self.promoteCount > armyCtrl:getArmyCountByLv(armyltCtrl.getArmyTypeAndLv(self.curSoldier.armyid)) then
		local buildID = armyltCtrl.getArmyAttrAndSp(self.curSoldier.armyid, ARMY_ATTR.BARRACK_ID)
		_ENV = armyltCtrl.getArmyTypeAndLv(self.curSoldier.armyid)
		armyltCtrl.getArmyTypeAndLv(self.curSoldier.armyid).name = armyDesRead.getName(self.curSoldier.armyid)
		local msgBoxPanel = SoraDShowMsgBox(i18n("Soldiers_armor_text_35", armyltCtrl.getArmyTypeAndLv(self.curSoldier.armyid)), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).bid = buildID
				;(nil).toIndex = 12
				uiManager:show("soldiersCampView", nil)
				SoraDRemoveAllPrePanelFromManager(self)
			end
		end)
	elseif armorSystemCtrl:getArmorNumByID(self.armorId) == 0 or armorSystemCtrl:getArmorNumByID(self.armorId) < self.promoteCount then
		_ENV = i18n("common_text_204")
		i18n("common_text_204").name = i18n(armorSystemRead:getProperty(self.armorId, "name"))
		local msgBoxPanel = SoraDShowMsgBox(i18n("Soldiers_armor_text_36", (i18n("common_text_204"))), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				if SoraDSearchPanelFromManagerByName("warframeForgDetail") then
					self:close()
				else
					local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
					_ENV = nil
					;(nil).key = "OpWarframeForg"
					mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, nil)
					SoraDRemoveAllPrePanelFromManager(self)
				end
			end
		end)
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").num = self.promoteCount
		i18n("common_text_204").armorId = self.armorId
		i18n("common_text_204").level = 12
		armorSystemCtrl:reqArmorSystemWearArmor((i18n("common_text_204")))
	end
end
function soldiersPromoteDetailViewPanel:btnPromoteClickCallBack()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	local armyCount = armyCtrl:getArmyCount(self.curSoldier.armyid, ARMY_OPTYPE.NORMAL_ARMY)
	local sliderValue = self.fields.slider:getSliderCurValue()
	if armyCount < sliderValue then
		SoraDShowMsgTip(i18n("arms_promotion_text_03"))
	elseif self.isShortElite then
		SoraDShowMsgTip(i18n("arms_promotion_text_06"), resDesRead.getIcon(gIDDef.ELITE_POINT, true))
	elseif self.isShortRes then
		local _ENV, shortList = self.isShortRes, self.isShortRes
		for k, v in ipairs(self.needResList) do
			if v.curcount < v.rescount then
				local _ENV, data = v.curcount, v.curcount
				data.resid = v.resid
				data.rescount = v.rescount
				data.curcount = v.curcount
				data.rescount = data.rescount - data.curcount
				table.insert(shortList, data)
			end
		end
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(shortList) then
			uiManager:show("CommonQuicklyadd")
			return
		end
		local resCostGold = armyLogic.getPromptGold(self.needResList)
		_ENV, _ENV = table.insert, v.curcount
		table.insert.resToGold = resCostGold
		v.curcount.needResData, table.insert.retCostRes = table.insert, shortList
		v.curcount.viewType = RESBUYVIEW_TYPE.PROMOTE_ARMY
		function v.curcount.handle()
			armyCtrl:promoteArmyReq(self.curSoldier.armyid, sliderValue, OPERATE_MODE.GOLD_REPLACE)
			self:close()
		end
		uiManager:show("buildCreateResBuy", v.curcount)
	else
		armyCtrl:promoteArmyReq(self.curSoldier.armyid, sliderValue, OPERATE_MODE.NORMAL)
		self:close()
	end
end
function soldiersPromoteDetailViewPanel:btnPromoteAtonceClickCallBack()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	local armyCount = armyCtrl:getArmyCount(self.curSoldier.armyid, ARMY_OPTYPE.NORMAL_ARMY)
	local sliderValue = self.fields.slider:getSliderCurValue()
	if armyCount < sliderValue then
		SoraDShowMsgTip(i18n("arms_promotion_text_03"))
	elseif self.isShortElite then
		SoraDShowMsgTip(i18n("arms_promotion_text_06"), resDesRead.getIcon(gIDDef.ELITE_POINT, true))
	elseif SoraDEnoughGold(self.atonceGold) then
		local promoteImmediately = function()
			armyCtrl:promoteArmyReq(self.curSoldier.armyid, sliderValue, OPERATE_MODE.IMMEDIATELY)
			if armyCount - sliderValue <= 0 then
				self:close()
			else
				armyCtrl = self.curSoldier.armyid
				self.curSoldier.armyid.armyid = self.curSoldier.armyid
				self.curSoldier.armyid.armycount = armyCount - sliderValue
				self:updateData(self.curSoldier.armyid)
			end
		end
		local dailyRemindManager = include("dailyRemindManager")
		local ctype = dailyRemindManager.REMIND_TYPE.troopFlagView
		if dailyRemindManager.checkNeedRemind(ctype) then
			SoraDShowBuyBox(i18n("common_text_4371"), self.atonceGold, self.fields.Button_atOnce:getText(), function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					dailyRemindManager.addRemindToManager(ctype)
					promoteImmediately()
				end
			end)
		else
			promoteImmediately()
		end
	end
end
function soldiersPromoteDetailViewPanel:btnInfoClickCallBack()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("soldier_text_17"))
end
function soldiersPromoteDetailViewPanel:btnTipClickCallBack()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_4353"))
end
function soldiersPromoteDetailViewPanel:btnToolClickCallBack()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("trainArmyLimitView")
	panel:initData(gItemType.SINGLE_TRAIN_ADD_COUNT)
	panel:show()
end
function soldiersPromoteDetailViewPanel:goWarFrameForge()
	if SoraDSearchPanelFromManagerByName("warframeForgDetail") then
		self:close()
	else
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).key = "OpWarframeForg"
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, nil)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function soldiersPromoteDetailViewPanel:goSoldiersCamp()
	local buildID = armyltCtrl.getArmyAttrAndSp(self.curSoldier.armyid, ARMY_ATTR.BARRACK_ID)
	armyltCtrl = nil
	;(nil).bid = buildID
	;(nil).toIndex = 12
	uiManager:show("soldiersCampView", nil)
end
function soldiersPromoteDetailViewPanel:btnLeftClick()
	SoraDPlaySound()
	self.armorIndex = self.armorIndex - 1
	if self.armorIndex < 1 then
		self.armorIndex = 2
	end
	self.curArmorId = self.armorIdList[self.armorIndex]
	self:initData()
	self:updateLRBtns()
end
function soldiersPromoteDetailViewPanel:btnRightClick()
	SoraDPlaySound()
	self.armorIndex = self.armorIndex + 1
	if self.armorIndex > 2 then
		self.armorIndex = 1
	end
	self.curArmorId = self.armorIdList[self.armorIndex]
	self:initData()
	self:updateLRBtns()
end
return soldiersPromoteDetailViewPanel
