local gametop = gModuleMgr.getObject("gametop")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local armyltCtrl = include("armyltCtrl")
local landOfSoulRead = include("landOfSoulRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local heroicLandView = class("heroicLandView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroicLandView")
	end
	return target
end)
function heroicLandView:ctor()
	self:initControls()
	self:initProgressEffect()
	self:initShinningEffect()
end
function heroicLandView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self.tableArmy, _ENV, self.cureArmyList, _ENV = SoraDCloseLoading, SoraDCloseLoading, SoraDCloseLoading, SoraDCloseLoading
		local deadArmyList = landOfSoulCtrl:getDeadArmyList()
		local cureArmyList = landOfSoulCtrl:getCureArmyList()
		local blessArmyList = landOfSoulCtrl:getBlessArmyList()
		if next(blessArmyList) then
			self.blessPanel = SoraDSearchPanelFromManagerByName("summonSuccessfulBlessView")
			if self.blessPanel then
				self.blessPanel:initData(self.activityID)
				return
			end
			self.blessPanel = SoraDCreatePanel("summonSuccessfulBlessView")
			self.blessPanel:initData(self.activityID)
			self.blessPanel:show()
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
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function heroicLandView:initControls()
	self.cureArmyList, _ENV, self.tableArmy, _ENV, self.tableArmySingle, _ENV = nil, nil, nil, nil, nil, nil
	self.nowCount = 0
	SoraDGetAllChildFromWidget(self, self)
	self.orgHeight = self.Top_Size_ScrollView_go:getContentSize().height
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.progress_bar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_exp")
	self.progress_bar:setProgressImg("frame_ZJM_jz_jdt3.png")
	self.nodeTitle:setTitle(i18n("heroicSouls_text_1"))
	self.txtIns:setString(i18n("heroicSouls_text_11"))
	self.txtSummonDown:setString(i18n("worldboss_btn_02"))
	self.btnBuy:addTouchEventListener(handler(self, self.onCureClick))
	self.btnExp:addTouchEventListener(handler(self, self.insClickCallBack))
	self.btn_help_tip:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.txtRemainTime)
	self.txtRemainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.txtRemainTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH"
		SoraDSendMessage(nil)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.nodeTitle:setLocalZOrder(10)
	self.txtSummon:setString(i18n("heroicSouls_text_2"))
	self.const_max = include("constantRead").getConstValue("LEGENDARYKING_SOUL_MAX_NUM")
end
function heroicLandView:initShinningEffect()
	local effectLamp = SoraDCreatAnimation("Node_yhzd_02", nil, false)
	SoraDMixtureGLONEByParent(effectLamp)
	self.effectLamp = effectLamp
	effectLamp:setPosition(cc.p(320, self.nodeTitle:getPositionY() - 500))
	self.Top_Node:addChild(effectLamp, 1)
end
function heroicLandView:initProgressEffect()
	local effectProgress = SoraDCreatAnimation("Node_yhzd_03", nil, true)
	SoraDMixtureGLONEByParent(effectProgress)
	self.effectProgress = effectProgress
	self.panelCut = SoraDGetChildByName(self.effectProgress, "Panel_cut")
	self.shineProgress = SoraDGetChildByName(self.effectProgress, "et_chuanqijw_03")
	effectProgress:setPosition(cc.p(0, -5))
	self.progress_bar:addChild(effectProgress, 1)
end
function heroicLandView:initData(armyList, activityID)
	self.activityID = activityID
	local armyIDList = landOfSoulCtrl:getDeadArmyIDList()
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
	local remainTime = landOfSoulCtrl:getSoulRemainTime(self.activityID)
	if 0 < remainTime then
		self.txtRemainTime:setString(SoraDConvertSecondToString(remainTime))
		self.txtRemainTime:beginTime(remainTime)
	end
	for i, v in ipairs(armyIDList) do
		local haveCount = armyList[tostring(v)] or 0
		if 0 < haveCount then
			landOfSoulCtrl = SoraDConvertSecondToString(remainTime)
			SoraDConvertSecondToString(remainTime).armyid = v
			SoraDConvertSecondToString(remainTime).armycount = haveCount
			SoraDConvertSecondToString(remainTime).curCount = 0
			table.insert(self.tableArmy, SoraDConvertSecondToString(remainTime))
		end
		self.nowCount = self.nowCount + haveCount
	end
	_UPVALUE6_ = (for generator)
	ipairs(armyIDList)[1] = gActivityTimeActivityID.LEGEND_HEGEMON_1
	ipairs(armyIDList)[2] = gActivityTimeActivityID.LEGEND_HEGEMON_2
	ipairs(armyIDList)[3] = gActivityTimeActivityID.LEGEND_HEGEMON_3
	ipairs(armyIDList)[4] = gActivityTimeActivityID.LEGEND_HEGEMON_4
	ipairs(armyIDList)[5] = gActivityTimeActivityID.LEGEND_HEGEMON_5
	local ipairs(armyIDList)[6], hegemonActivityArray = gActivityTimeActivityID.LEGEND_HEGEMON_6, ipairs(armyIDList)
	local curBless = landOfSoulCtrl:getBlessValue()
	if SoraDisInList(activityID, hegemonActivityArray) then
		self.Top_Size_ScrollView_go:setContentSize(cc.size(640, self.orgHeight - 50))
		self.ownSoulPower = backpackCtrl:getItemCount(725101) + backpackCtrl:getItemCount(311401)
		self.Image_102:setContentSize(cc.size(640, 190))
		self.Node_Up:setPositionY(50)
		self.Node_ItemInfo:setVisible(true)
		self.Text_Num_1:setString(string.formatnumberthousands(backpackCtrl:getItemCount(725101)))
		self.Text_Num_2:setString(string.formatnumberthousands(backpackCtrl:getItemCount(311401)))
		self.Image_Icon_1:loadTexture("7251.png", ccui.TextureResType.plistType)
		self.Image_Icon_2:loadTexture("3114.png", ccui.TextureResType.plistType)
		self.const_max = include("constantRead").getConstValue("LEGENDHEGEMON_SOUL_MAX_NUM")
		self.Sprite_97:setSpriteFrame("icon_hegemon_land.png")
		self.txtIns:setString(i18n("heroicSouls_text_15"))
		self.txtSummon:setString(i18n("heroicSouls_text_14"))
		local remainTime = landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
		if 0 < remainTime then
			self.txtRemainTime:setString(SoraDConvertSecondToString(remainTime))
			self.txtRemainTime:beginTime(remainTime)
		end
	elseif self.activityID ~= gActivityTimeActivityID.LEGEND_LORD and not worldMapDefine.isKingStarActivityID(self.activityID) then
		self.ownSoulPower = backpackCtrl:getItemCount(725101)
		self.const_max = include("constantRead").getConstValue("LEGENDHEGEMON_SOUL_MAX_NUM")
		self.txtSummon:setString(i18n("heroicSouls_text_14"))
		local remainTime = landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
		if 0 < remainTime then
			self.txtRemainTime:setString(SoraDConvertSecondToString(remainTime))
			self.txtRemainTime:beginTime(remainTime)
		end
		self.txtIns:setString(i18n("heroicSouls_text_15"))
		self.Top_Size_ScrollView_go:setContentSize(cc.size(640, self.orgHeight))
		self.Sprite_97:setSpriteFrame("icon_hegemon_land.png")
		self.Image_102:setContentSize(cc.size(640, 140))
		self.Node_Up:setPositionY(0)
		self.Node_ItemInfo:setVisible(false)
	else
		landOfSoulCtrl = landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
		landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)[gActivityTimeActivityID.KING_STAR_BATTLE] = "KINGSTAR_SOUL_MAX_NUM_MANDARIN"
		landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)[gActivityTimeActivityID.LEGEND_LORD_9001646] = "KINGSTAR_SOUL_MAX_NUM_DIAMOND"
		local landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)[gActivityTimeActivityID.LEGEND_LORD_9001647], config = "KINGSTAR_SOUL_MAX_NUM_PLATINUM", landOfSoulCtrl:getSoulRemainTime(gActivityCenterUIEnum.LEGEND_HEGEMON)
		local constKey = config[self.activityID]
		if constKey then
			local const_max = include("constantRead").getConstValue(constKey)
			if const_max then
				self.const_max = const_max
			end
		end
		self.Top_Size_ScrollView_go:setContentSize(cc.size(640, self.orgHeight - 50))
		landOfSoulCtrl = self.Top_Size_ScrollView_go.setContentSize
		landOfSoulCtrl = cc.size(640, self.orgHeight - 50)
		self.Top_Size_ScrollView_go.setContentSize[gActivityTimeActivityID.KING_STAR_BATTLE], cc.size(640, self.orgHeight - 50).id = cc.size(640, self.orgHeight - 50)
		landOfSoulCtrl = cc.size(640, self.orgHeight - 50)
		self.Top_Size_ScrollView_go.setContentSize[gActivityTimeActivityID.LEGEND_LORD_9001646], cc.size(640, self.orgHeight - 50).id = cc.size(640, self.orgHeight - 50)
		landOfSoulCtrl = cc.size(640, self.orgHeight - 50)
		self.Top_Size_ScrollView_go.setContentSize[gActivityTimeActivityID.LEGEND_LORD_9001647], cc.size(640, self.orgHeight - 50).id = cc.size(640, self.orgHeight - 50)
		local itemActCfg = self.Top_Size_ScrollView_go.setContentSize
		if worldMapDefine.isKingStarActivityID(self.activityID) then
			self.ownSoulPower = backpackCtrl:getItemCount(723001) + backpackCtrl:getItemCount(itemActCfg[self.activityID].id)
			self.Text_Num_1:setString(string.formatnumberthousands(backpackCtrl:getItemCount(itemActCfg[self.activityID].id)))
		else
			self.ownSoulPower = backpackCtrl:getItemCount(723001) + backpackCtrl:getItemCount(311301)
			self.Text_Num_1:setString(string.formatnumberthousands(backpackCtrl:getItemCount(311301)))
		end
		self.Image_102:setContentSize(cc.size(640, 190))
		self.Node_Up:setPositionY(50)
		self.Node_ItemInfo:setVisible(true)
		self.Text_Num_2:setString(string.formatnumberthousands(backpackCtrl:getItemCount(723001)))
		self.Image_Icon_1:loadTexture("3113.png", ccui.TextureResType.plistType)
		self.Image_Icon_2:loadTexture("7230.png", ccui.TextureResType.plistType)
	end
	if worldMapDefine.isKingStarActivityID(self.activityID) then
		self.txtSummon:setString(i18n("kingstarbattle_text_56"))
	end
	self.btnExp:setPositionX(self.txtIns:getPositionX() - SoraDFSign(self.txtIns:getContentSize().width / 2) - SoraDFSign(30))
	landOfSoulCtrl = 30
	;(30).member = curBless
	;(30).total = self.const_max
	self.text_progress:setString(i18n("common_text_155", 30))
	landOfSoulCtrl = i18n("common_text_155", 30)
	i18n("common_text_155", 30).maxValue = self.const_max
	i18n("common_text_155", 30).curValue = curBless
	self.progress_bar:setProgressDate(i18n("common_text_155", 30))
	self.panelCut:setContentSize(cc.size(curBless / self.const_max * 434, 40))
	self.shineProgress:setVisible(0 < curBless)
	self.panelCut:setVisible(0 < curBless)
	self.shineProgress:setPositionX(self.panelCut:getPositionX() + self.panelCut:getContentSize().width)
	if SoraDFIsRA() then
		self.shineProgress:setPositionX(-self.panelCut:getPositionX() - self.panelCut:getContentSize().width)
	end
	landOfSoulCtrl = self.panelCut
	self.panelCut.num = 0
	self.txtmdl:setString(i18n("heroicSouls_text_7", self.panelCut))
	self:initScroll()
end
function heroicLandView:initScroll()
	self.Top_Size_ScrollView_go:removeAllChildren()
	self.tableArmySingle, _ENV = self.Top_Size_ScrollView_go.removeAllChildren, self.Top_Size_ScrollView_go.removeAllChildren
	local scrollH = math.max(self.Top_Size_ScrollView_go:getContentSize().height, 130 * #self.tableArmy)
	for i, v in ipairs(self.tableArmy) do
		local panel = SoraDCreatePanel("worldDispatchArmySingle")
		panel:initData(v)
		panel:setSliderChangeBack(handler(self, self.singleSliderChange))
		panel:setPosition(cc.p(0, scrollH - 5 - (i - 1) * 130))
		panel:setScroll(self.Top_Size_ScrollView_go)
		panel:addTo(self.Top_Size_ScrollView_go)
		table.insert(self.tableArmySingle, panel)
	end
	self.Top_Size_ScrollView_go:setInnerContainerSize(cc.size(640, scrollH))
	self.Top_Size_ScrollView_go:jumpToTop()
	self:bindData()
end
function heroicLandView:bindData()
	for i, v in ipairs(self.tableArmy) do
		self.tableArmySingle[i]:setCurVal(v.curCount)
	end
end
function heroicLandView:canCureSoldiersNum(armyId, armyLv, armyCount)
	local needSoulPower = 0
	local _ENV, curArmyList
	if not curArmyList[tostring(armyId)] then
		curArmyList[tostring(armyId)], _ENV = armyId, armyId
		curArmyList[tostring(armyId)] = armyCount
	end
	needSoulPower = landOfSoulCtrl:getRestoreNeedSoulNum(curArmyList, self.activityID)
	return needSoulPower
end
function heroicLandView:singleSliderChange(target, data)
	self.curCount = 0
	self.needSoulPower = 0
	for i, v in ipairs(self.tableArmy) do
		local armyLv = v.armyid % 100
		if v.armyid == data.armyid then
			v.curCount = data.armycount
			if v.curCount > 0 then
				self.cureArmyList[tostring(v.armyid)] = v.curCount
			else
				self.cureArmyList[tostring(v.armyid)] = nil
			end
		end
		self.needSoulPower = self.needSoulPower + self:canCureSoldiersNum(v.armyid, armyLv, v.curCount)
		self.curCount = self.curCount + v.curCount
	end
	self.needSoulPower = math.ceil(self.needSoulPower)
	local addBless = landOfSoulRead:getNeedBless(self.needSoulPower)
	local curBless = landOfSoulCtrl:getBlessValue()
	local totalBless = curBless + self.needSoulPower
	_ENV = v.curCount
	v.curCount.num = addBless
	self.txtmdl:setString(i18n("heroicSouls_text_7", v.curCount))
	if self.activityID ~= gActivityTimeActivityID.LEGEND_LORD and not worldMapDefine.isKingStarActivityID(self.activityID) then
		addBless = landOfSoulRead:getNeedBlessHegemon(self.needSoulPower)
		_ENV = i18n("heroicSouls_text_7", v.curCount)
		i18n("heroicSouls_text_7", v.curCount).num = addBless
		self.txtmdl:setString(i18n("heroicSouls_text_17", i18n("heroicSouls_text_7", v.curCount)))
	end
	self.txtSoulPower:setString(self.needSoulPower)
	if totalBless >= self.const_max then
		self.needSoulPower = self.const_max - curBless
		self.txtSoulPower:setString(self.const_max - curBless)
	end
	self.txtSoulPower:setColor(self.needSoulPower <= self.ownSoulPower and cc.c3b(255, 255, 255) or cc.c3b(255, 0, 0))
	if self.ownSoulPower >= self.const_max then
		self.txtSoulPower:setColor(cc.c3b(255, 255, 255))
	end
	self.btnBuy:setEnabled(0 < self.needSoulPower)
	self.btnBuy:setBright(0 < self.needSoulPower)
end
function heroicLandView:onCureClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.ownSoulPower < self.needSoulPower and self.ownSoulPower < self.const_max then
			local kingStr = i18n("heroicSouls_text_4")
			if self.activityID ~= gActivityTimeActivityID.LEGEND_LORD and not worldMapDefine.isKingStarActivityID(self.activityID) then
				kingStr = i18n("heroicSouls_text_18")
			end
			SoraDShowMsgBox(kingStr, i18n("common_text_054"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					if self.activityID ~= gActivityTimeActivityID.LEGEND_LORD and not worldMapDefine.isKingStarActivityID(self.activityID) then
						if GLOBAL_GAME_RECHARGE_MODE then
							_ENV = nil
							;(nil).rechargeID = 13912
							uiManager:show("rechargeView", nil)
						else
							local panel = SoraDCreatePanel("rechargeView")
							panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, 13912)
							panel:show()
						end
					else
						_UPVALUE5_ = SoraDCreatePanel("rechargeView")
						SoraDCreatePanel("rechargeView")[1] = 13849
						SoraDCreatePanel("rechargeView")[2] = 13850
						SoraDCreatePanel("rechargeView")[3] = 13851
						SoraDCreatePanel("rechargeView")[4] = 13852
						local SoraDCreatePanel("rechargeView")[5], rechargeIDList = 13853, SoraDCreatePanel("rechargeView")
						if GLOBAL_GAME_RECHARGE_MODE then
							_ENV = 13852
							;(13852).rechargeIDList = rechargeIDList
							uiManager:show("rechargeView", 13852)
						else
							local panel = SoraDCreatePanel("rechargeView")
							panel:jumpToLimitNodeByList(5, rechargeIDList)
							panel:show()
						end
					end
				end
			end)
			return
		end
		local addBless = landOfSoulRead:getNeedBless(self.needSoulPower)
		local curBless = landOfSoulCtrl:getBlessValue()
		local remainBless = self.const_max - curBless
		if remainBless <= 0 then
			remainBless = 0
		end
		if addBless >= self.const_max then
			_ENV = nil
			;(nil).num = remainBless
			SoraDShowMsgBox(i18n("heroicSouls_text_8", nil), i18n("common_text_054"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					landOfSoulCtrl:reqInvolkeDeadArmy(self.activityID, self.cureArmyList)
					SoraDShowLoading(self)
				end
			end)
		else
			landOfSoulCtrl:reqInvolkeDeadArmy(self.activityID, self.cureArmyList)
			SoraDShowLoading(self)
		end
	end
end
function heroicLandView:insClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.activityID == gActivityTimeActivityID.LEGEND_LORD then
			_ENV = "heroicSouls_text_6"
			;("heroicSouls_text_6").float = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("heroicSouls_text_6"), "heroicSouls_text_6")
		elseif worldMapDefine.isKingStarActivityID(self.activityID) then
			_ENV = "kingstarbattle_text_57"
			;("kingstarbattle_text_57").float = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("kingstarbattle_text_57"), "kingstarbattle_text_57")
		else
			_ENV = "heroicSouls_text_16"
			;("heroicSouls_text_16").float = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("heroicSouls_text_16"), "heroicSouls_text_16")
		end
	end
end
function heroicLandView:onClick_btn_help_tip(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.activityID == gActivityTimeActivityID.LEGEND_LORD then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LEGEND_KING_LAND)
		elseif worldMapDefine.isKingStarActivityID(self.activityID) then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.KING_STAR_LAND)
		elseif IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LEGEND_HEGEMON_LAND)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HEGEMON_LORD_ROS)
		end
	end
end
function heroicLandView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return heroicLandView
