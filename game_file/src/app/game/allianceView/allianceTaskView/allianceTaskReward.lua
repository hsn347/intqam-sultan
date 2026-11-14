local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local effectUI = include("effectUI")
local allianceTaskReward = class("allianceTaskReward", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskReward")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskReward:ctor()
	self.Size_Image_bg = SoraDGetChildByName(self, "Size_Image_bg")
	self.Size_Image_bg:setFillType(1)
	self.ScrollView_node = SoraDGetChildByName(self, "ScrollView_node")
	self.Top_Size_Image_leftBorder = SoraDGetChildByName(self, "Top_Size_Image_leftBorder")
	self.Top_Size_Image_rightBorder = SoraDGetChildByName(self, "Top_Size_Image_rightBorder")
	self.Top_Node_head = SoraDGetChildByName(self, "Top_Node_head")
	self.frame_recharge_continue_cloth_02_1 = SoraDGetChildByName(self, "frame_recharge_continue_cloth_02_1")
	self.frame_recharge_continue_cloth_02_2 = SoraDGetChildByName(self, "frame_recharge_continue_cloth_02_2")
	self.Image_king_bg = SoraDGetChildByName(self, "Image_king_bg")
	self.frame_king_11_3 = SoraDGetChildByName(self, "frame_king_11_3")
	self.frame_king_11_5 = SoraDGetChildByName(self, "frame_king_11_5")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.BottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.btn_award = SoraDGetChildByName(self, "btn_award")
	self.frame_lace_base_L = SoraDGetChildByName(self, "frame_lace_base_L")
	self.frame_lace_base_R = SoraDGetChildByName(self, "frame_lace_base_R")
	self.Panel_single = SoraDGetChildByName(self, "Panel_single")
	self.item_single = SoraDGetChildByName(self, "item_single")
	self.btn_award:addTouchEventListener(handler(self, self.onClick_btn_award))
	self.btn_award:setTitleText(i18n("common_text_1146"))
	self.selTable, _ENV = self.btn_award.setTitleText, self.btn_award.setTitleText
	self.heightPanel = 180
	self.widthPanel = 630
	self.commonFramTitle_node:setTitle(i18n("common_text_3143"))
	self:init()
	SoraDCreateFireEffectNode(self.frame_lace_base_L, self.frame_lace_base_R)
end
function allianceTaskReward:init(data)
	local dis = display.height - 960
	local scrollSize = self.ScrollView_node:getContentSize()
	if dis ~= 0 then
		self.ScrollView_node:setContentSize(cc.size(scrollSize.width, scrollSize.height + dis))
	else
	end
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local matchlev = userMissionData.matchlev
	local alliancemissionInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	local score = alliancemissionInfo.score
	local stageRank = mobilizationltCtrl:getActivitStage(score, matchlev)
	print("玩家当前对应任务等级  = ", stageRank)
	self.activityStatus = playerMobilizationCtrl:getActivityStatus().status
	print("self.activityStatus = ", self.activityStatus)
	self.mobiAliStatus = playerMobilizationCtrl:getUserMobiAliStatus()
	print("self.mobiAliStatus = ", self.mobiAliStatus)
	if self.activityStatus == gMobilizationActivityStatus.ACTIVITY_CALCULATE then
		local userStatus = playerMobilizationCtrl:getUserMobiAliStatus()
		if userStatus == gMobilizationAliStatus.STATUS_NORMAL then
			local mainCityFunctions = include("mainCityFunctions")
			local lv = mainCityFunctions:getCastleLv()
			if lv < CASTLE_LV15_LIMITED then
			else
				self.BottomNode:setPositionY(0)
				local ssize = self.ScrollView_node:getContentSize()
				self.ScrollView_node:setContentSize(cc.size(ssize.width, ssize.height - 82))
			end
		elseif userStatus == gMobilizationAliStatus.STATUS_NOT_JOIN_WHEN_START then
		elseif userStatus == gMobilizationAliStatus.STATUS_ALLIANCE_UNORGANIZED then
		elseif userStatus == gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE then
		else
			if userStatus == gMobilizationAliStatus.STATUS_NOT_CASTLE_NOTENOUGH then
			else
			end
		end
	else
	end
	self.selTable = playerMobilizationCtrl:getSelectInfo()
	self.Panel_single:removeFromParent()
	self.ScrollView_node:addChild(self.Panel_single)
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local awardListInfoAll = userMissionData.awardListInfo
	local stageRank = mobilizationltCtrl:getActivitStage(score, matchlev)
	self.stageRank = stageRank
	print("玩家当前任务阶级：", stageRank)
	local _ENV, awardListInfo = print, print
	for i, v in ipairs(awardListInfoAll) do
		awardListInfo[i] = clone(awardListInfoAll[i])
	end
	local awardInfo = userMissionData.awardInfo
	self.awardInfo = awardInfo
	if next(awardInfo) ~= nil then
		print("玩家已经领取了奖励")
		self.isClaimed = true
		self.btn_award:setColor(cc.c3b(125, 125, 125))
		self.btn_award:setTouchEnabled(false)
		self.btn_award:setTitleText(i18n("common_text_1892"))
	else
		print("玩家还没领取奖励----")
		self.isClaimed = false
	end
	if self.stageRank == 0 then
		self.BottomNode:setPositionY(-81)
		self.btn_award:setVisible(false)
		local ssize = self.ScrollView_node:getContentSize()
		self.ScrollView_node:setContentSize(cc.size(ssize.width, ssize.height + 82))
	end
	dump(self.selTable, "玩家的选择", 10)
	_ENV = self.selTable
	self.Panel_single.tblItemNodes, self.selTable[1] = self.selTable, self.item_single
	for i = 1, 2 do
		local itemNode = self.item_single:clone()
		self.Panel_single:addChild(itemNode)
		table.insert(self.Panel_single.tblItemNodes, itemNode)
	end
	for i, v in ipairs(self.Panel_single.tblItemNodes) do
		v:setTag(i)
		v:setName("item_" .. i)
		if SoraDFIsRA() then
			v:setPositionX(630 - (183.33333333333334 * (i - 1) + 130))
		else
			v:setPositionX(183.33333333333334 * (i - 1) + 130)
		end
	end
	local numOfPanel = #awardListInfo
	_ENV, self.numAward = ipairs(self.Panel_single.tblItemNodes)
	self.tblPanels, ipairs(self.Panel_single.tblItemNodes)[1] = ipairs(self.Panel_single.tblItemNodes)
	for i = 2, numOfPanel do
		local panelNode = self.Panel_single:clone()
		self.ScrollView_node:addChild(panelNode)
		table.insert(self.tblPanels, panelNode)
		panelNode.tblItemNodes, _ENV = table.insert, table.insert
		for i = 1, 3 do
			table.insert(panelNode.tblItemNodes, panelNode:getChildByName("item_" .. i))
		end
	end
	local newScrollH = numOfPanel * self.heightPanel + 100
	local scrollInner = self.ScrollView_node:getInnerContainer()
	local scrollH = self.ScrollView_node:getContentSize().height
	if newScrollH < scrollH then
		newScrollH = scrollH
	end
	print("newScrollH = ", newScrollH)
	self.ScrollView_node:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, newScrollH))
	for i, v in ipairs(self.tblPanels) do
		v.stage = i
		v:setPositionY(newScrollH - (i - 1) * self.heightPanel)
		v:setPositionX(320)
		self:initPanle(v, awardListInfo[i], i)
	end
	self.ScrollView_node:scrollToTop(0.01, false)
end
function allianceTaskReward:initPanle(panel, data, stage)
	local Text_name = SoraDGetChildByName(panel, "Text_name")
	local Text_tip = SoraDGetChildByName(panel, "Text_tip")
	_ENV = nil
	;(nil).section = stage
	Text_name:setString(i18n("common_text_622", nil))
	Text_tip:setString(i18n("common_text_3583"))
	panel.awardData = data
	for i, itemData in ipairs(data) do
		self:initItem(panel.tblItemNodes[i], itemData, i)
	end
end
function allianceTaskReward:initItem(item, data, iIndex)
	local alliancemissionInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	local score = alliancemissionInfo.score
	local matchlev = userMissionData.matchlev
	local stageRank = mobilizationltCtrl:getActivitStage(score, matchlev)
	local itemId = data.reward[1]
	local itemNum = data.reward[2]
	item.index = data.index
	item.stage = data.stage
	item.iIndex = iIndex
	item.itemId = itemId
	local Image_quality = SoraDGetChildByName(item, "Image_quality")
	local Image_num = SoraDGetChildByName(item, "Image_num")
	local Image_item = SoraDGetChildByName(item, "Image_item")
	local Text_num = SoraDGetChildByName(item, "Text_num")
	local Button_show = SoraDGetChildByName(item, "Button_show")
	Button_show.index = data.index
	Button_show.stage = data.stage
	Button_show.iIndex = iIndex
	Button_show.itemId = itemId
	local Text_item_tip = SoraDGetChildByName(item, "Text_item_tip")
	local Image_glow = SoraDGetChildByName(item, "Image_glow")
	if stageRank >= item.stage and self.selTable[item.stage] == item.index then
		Image_glow:setVisible(true)
	else
		Image_glow:setVisible(false)
	end
	Image_quality:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
	Image_item:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
	Text_num:setString(itemNum)
	local isShowGood = mobilizationltCtrl:isNeedShowGood(itemId)
	print("stageRank = ", stageRank, ", item.stage = ", item.stage)
	if item.stage == stageRank + 1 then
		if 1 < item.stage then
			_UPVALUE6_ = stageRank + 1
			;(stageRank + 1)[1] = Image_quality
			;(stageRank + 1)[2] = Image_num
			;(stageRank + 1)[3] = Image_item
			;(stageRank + 1)[4] = Text_num
			;(stageRank + 1)[5] = Image_glow
			;(stageRank + 1)[6] = Text_item_tip
			SoraDSetArrayGray(stageRank + 1, true)
			Button_show.isGray = true
			item.isGray = true
			item.isLock = true
		end
	elseif item.stage > stageRank + 1 then
		_UPVALUE6_ = stageRank + 1
		;(stageRank + 1)[1] = Image_quality
		;(stageRank + 1)[2] = Image_num
		;(stageRank + 1)[3] = Image_item
		;(stageRank + 1)[4] = Text_num
		;(stageRank + 1)[5] = Image_glow
		;(stageRank + 1)[6] = Text_item_tip
		SoraDSetArrayGray(stageRank + 1, true)
		Button_show.isGray = true
		item.isGray = true
		item.isLock = true
		Button_show.isLock = true
	end
	Button_show:addTouchEventListener(handler(self, self.onClick_Button_show))
	if isShowGood then
		self:addItemEffect(item)
	end
end
function allianceTaskReward:addItemEffect(item)
	local scale = 0.5
	self.glow1, self.glow2 = effectUI.getItemEffect()
	self.glow1:addTo(item)
	self.glow1:setPosition(cc.p(48, 49))
	self.glow1:setLocalZOrder(-1)
	self.glow1:setScale(1.4 * scale)
	self.glow2:addTo(item)
	self.glow2:setPosition(cc.p(48, 49))
	self.glow2:setLocalZOrder(1)
	self.glow2:setScale(1.4 * scale)
end
function allianceTaskReward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_GET_AWARD_BACK", handler(self, self.sMsgGetAwardBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ACTIVITY_CLOSE", handler(self, self.sMsgActivityClose))
end
function allianceTaskReward:sMsgActivityClose(target, data)
	SoraDRemoveAllPanelFromManager()
end
function allianceTaskReward:getFirstUnSel()
	local unSelStage = -1
	for i = 1, self.stageRank do
		local index = self.selTable[i]
		if not index then
			unSelStage = i
			return unSelStage
		end
	end
	return unSelStage
end
function allianceTaskReward:onClick_btn_award(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local firstUnSel = self:getFirstUnSel()
		print("firstUnSel = ", firstUnSel)
		if firstUnSel ~= -1 then
			SoraDShowMsgTip(i18n("common_text_3585"))
			self:jumpToStage(firstUnSel)
			return
		end
		self.isAwardGet = false
		if self.isAwardGet then
			return
		end
		local selRet = self.selTable
		dump(selRet, "请求领取-----奖励")
		SoraDShowLoading(self)
		playerMobilizationCtrl:reqGetStageAward(selRet)
	end
end
function allianceTaskReward:jumpToStage(stage)
	self:stopAllActions()
	local stagePosY = self.tblPanels[stage]:getPositionY() - 100
	local scrollPercent = 100 * (1 - stagePosY / (self.ScrollView_node:getInnerContainerSize().height - self.ScrollView_node:getContentSize().height))
	scrollPercent = math.min(100, math.max(0, scrollPercent))
	local scrollH = self.ScrollView_node:getContentSize().height
	if math.abs(stagePosY + self.ScrollView_node:getInnerContainer():getPositionY()) < 0.5 * scrollH then
		self.ScrollView_node:scrollToPercentVertical(scrollPercent, 0.2, true)
	else
		_UPVALUE2_ = 0.2
		;(0.2)[1] = cca.callFunc(function(...)
			self.ScrollView_node:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
		end)
		;(0.2)[2] = cca.delay(0.3)
		;(0.2)[3] = cca.callFunc(function(...)
			self.ScrollView_node:scrollToPercentVertical(scrollPercent, 0.1, true)
		end)
		;(0.2)[4] = cca.callFunc(function(...)
			self.ScrollView_node:scrollToPercentVertical(scrollPercent, 0.1, true)
		end)
		self:runAction(cca.seq(0.2))
	end
end
function allianceTaskReward:onClick_Button_show(sender, event)
	if event == ccui.TouchEventType.began then
		if not sender.isLock then
			playerMobilizationCtrl = nil
			;(nil)[1] = cca.delay(0.3)
			;(nil)[2] = cca.callFunc(function()
				self:openItemInfo(sender.itemId, sender)
			end)
			;(nil)[3] = cca.callFunc(function()
				self:openItemInfo(sender.itemId, sender)
			end)
			;(nil)[4] = cca.callFunc(function()
				self:openItemInfo(sender.itemId, sender)
			end)
			;(nil)[5] = cca.callFunc(function()
				self:openItemInfo(sender.itemId, sender)
			end)
			sender:runAction(cca.seq(nil))
		end
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		sender:stopAllActions()
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sender:stopAllActions()
		self:closeItemInfo()
		if self.activityStatus ~= gMobilizationActivityStatus.ACTIVITY_CALCULATE then
			SoraDShowMsgTip(i18n("common_text_3581"))
			return
		end
		if sender.isGray == true then
			return
		end
		if self.isClaimed then
			return
		end
		if self.mobiAliStatus == gMobilizationAliStatus.STATUS_NOT_CASTLE_NOTENOUGH then
			return
		end
		dump(sender, "sender = ")
		dump(event)
		print("stage = ", sender.stage, "iIndex = ", sender.iIndex, ", index = ", sender.index)
		local alliancemissionInfo = playerMobilizationCtrl:getAllianceMobiInfo()
		local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local score = alliancemissionInfo.score
		local matchlev = userMissionData.matchlev
		local stageRank = mobilizationltCtrl:getActivitStage(score, matchlev)
		if stageRank < sender.stage then
			return
		end
		self.selTable[sender.stage] = sender.index
		self:selStage(sender.stage, sender.iIndex)
		dump(self.selTable, "当前选中列表")
	end
end
function allianceTaskReward:selStage(stage, iIndex)
	local panelStage = self.tblPanels[stage]
	for i, v in ipairs(panelStage.tblItemNodes) do
		local glow = SoraDGetChildByName(v, "Image_glow")
		if i ~= iIndex then
			glow:setVisible(false)
		else
			glow:setVisible(true)
		end
	end
end
function allianceTaskReward:sendSelTable()
	local selRet = self.selTable
	if selRet then
		playerMobilizationCtrl:selectInfo(selRet)
	end
end
function allianceTaskReward:onExitPanel()
	self:sendSelTable()
end
function allianceTaskReward:openItemInfo(id, sender)
	_UPVALUE0_ = nil
	;(nil).id = id
	;(nil).item = sender
	self:openItemInfoMsg(nil)
end
function allianceTaskReward:closeItemInfo()
	self:closeItemInfoMsg()
end
function allianceTaskReward:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function allianceTaskReward:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function allianceTaskReward:sMsgGetAwardBack(target, data)
	local err = data.err
	SoraDCloseLoading(self)
	if err == gErrDef.Err_None then
		self.isClaimed = true
		self.btn_award:setTouchEnabled(false)
		self.btn_award:setColor(cc.c3b(125, 125, 125))
		self.btn_award:setTitleText(i18n("common_text_1892"))
	else
		SoraDShowMsgTip(i18n("notice_0038"))
	end
end
return allianceTaskReward
