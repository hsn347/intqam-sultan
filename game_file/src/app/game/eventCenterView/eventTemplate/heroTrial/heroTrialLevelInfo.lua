include("worldMapDefine")
local htPointMgr = include("htPointMgr")
local heroTrialCommon = include("heroTrialCommon")
local heroTrialltCtrl = include("heroTrialltCtrl")
local htBattleMgr = include("htBattleMgr")
local gametop = gModuleMgr.getObject("gametop")
local heroTrialCtrl = gametop.playertop_:getModule("heroTrialCtrl")
local publicRead = include("publicRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroTrialLevelInfo = class("heroTrialLevelInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialLevelInfo")
	end
	return target
end)
function heroTrialLevelInfo:ctor()
	self.battleNode = SoraDGetChildByName(self, "battleNode")
	self.beginBtn = SoraDGetChildByName(self, "Button_attack")
	self.detailBtn = SoraDGetChildByName(self, "Button_detail")
	self.autoBtn = SoraDGetChildByName(self, "Button_autoAttack")
	self.imageMonster = SoraDGetChildByName(self, "Image_monster")
	self.text_Name = SoraDGetChildByName(self, "Text_monterName")
	self.text_talk = SoraDGetChildByName(self, "Text_monterTalk")
	local rewardTip = SoraDGetChildByName(self, "rewardTip")
	local detailTitle = SoraDGetChildByName(self, "detailTitle")
	rewardTip:setString(i18n("common_text_488"))
	self.beginBtn:setTitleText(i18n("common_text_1774"))
	self.autoBtn:setTitleText(i18n("common_text_1766"))
	detailTitle:setString(i18n("common_text_1773"))
	self.reward, _ENV = detailTitle.setString, detailTitle.setString
	for i = 1, 5 do
		self.reward[i], _ENV = i18n("common_text_1773")
		self.reward[i].node = SoraDGetChildByName(self, "reward" .. i)
		self.reward[i].icon = SoraDGetChildByName(self.reward[i].node, "rewardIcon" .. i)
		self.reward[i].name = SoraDGetChildByName(self.reward[i].node, "rewardName" .. i)
	end
	self.beginBtn:addTouchEventListener(handler(self, self.onBegin))
	self.detailBtn:addTouchEventListener(handler(self, self.onDetail))
	self:addTouchEventListener(handler(self, self.onClose))
	self:updateAutoVip()
	self:setBackGround(229.5)
	_UPVALUE9_, self.isHidePrePanel = self.setBackGround, false
	_UPVALUE4_, self.normalTalk, self.setBackGround[1] = self.setBackGround, self.setBackGround, i18n("common_text_1727")
	_UPVALUE4_, self.normalTalk, self.setBackGround[2] = self.setBackGround, self.setBackGround, i18n("common_text_1728")
	_UPVALUE4_, self.normalTalk, self.setBackGround[3] = self.setBackGround, self.setBackGround, i18n("common_text_1729")
	_UPVALUE4_, self.normalTalk, self.setBackGround[4] = self.setBackGround, self.setBackGround, i18n("common_text_1730")
	_UPVALUE4_, self.normalTalk, self.setBackGround[5] = self.setBackGround, self.setBackGround, i18n("common_text_1731")
	_UPVALUE4_, self.normalTalk, self.setBackGround[6] = self.setBackGround, self.setBackGround, i18n("common_text_1732")
	_UPVALUE4_, self.normalTalk, self.setBackGround[7] = self.setBackGround, self.setBackGround, i18n("common_text_1733")
	_UPVALUE4_, self.normalTalk, self.setBackGround[8] = self.setBackGround, self.setBackGround, i18n("common_text_1734")
	_UPVALUE4_, self.normalTalk, self.setBackGround[9] = self.setBackGround, self.setBackGround, i18n("common_text_1735")
	_UPVALUE4_, self.normalTalk, self.setBackGround[10] = self.setBackGround, self.setBackGround, i18n("common_text_1736")
	_UPVALUE4_, self.normalTalk, self.setBackGround[11] = self.setBackGround, self.setBackGround, i18n("common_text_1736")
	self.bossTalk, self.setBackGround[1] = self.setBackGround, i18n("common_text_1737")
	self.bossTalk, self.setBackGround[2] = self.setBackGround, i18n("common_text_1738")
	self.bossTalk, self.setBackGround[3] = self.setBackGround, i18n("common_text_1739")
	self.bossTalk, self.setBackGround[4] = self.setBackGround, i18n("common_text_1740")
	self.bossTalk, self.setBackGround[5] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[6] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[7] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[8] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[9] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[10] = self.setBackGround, i18n("common_text_1741")
	self.bossTalk, self.setBackGround[11] = self.setBackGround, i18n("common_text_1741")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_RSP", self.handleRsp)
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", self.updateAutoVip)
end
function heroTrialLevelInfo:initData(canAttack, enemyData, levelId, bustName, beginTile, endTile, mapId)
	if not canAttack then
		local y = self.detailBtn:getPositionY()
		self.detailBtn:setPositionY(y)
		self.battleNode:setVisible(false)
	end
	self.enemyData = enemyData
	self.bustName = bustName
	self.levelId = levelId
	self.mapId = mapId
	self.beginTile = beginTile
	self.endTile = endTile
	self:upateInfo()
end
function heroTrialLevelInfo:handleRsp(data)
	if data.rsp.subcmd == gCmd.REQ_HT_OPEN_TRIAL and data.rsp.data.mapID == self.mapId and self.canOpenTrial and data.rsp.err == gErrDef.Err_None then
		self:openDispatch()
	end
end
function heroTrialLevelInfo:checkOpenTrial()
	local title = i18n("common_text_1742")
	if htBattleMgr.trialStatus then
		title = i18n("common_text_1836")
	end
	SoraDShowMsgBox(title, i18n("common_text_054"), i18n("common_text_185"), function(type, sender)
		if type == MSGBOX_CALLBACK_YES then
			local armyIDList = armyCtrl:getArmyIDList()
			local count = 0
			for i, v in ipairs(armyIDList) do
				count = count + armyCtrl:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY)
			end
			if 0 < count then
				heroTrialCtrl:openTrial(self.mapId)
				self.canOpenTrial = true
			else
				SoraDShowMsgBox(i18n("common_text_1744"), i18n("common_text_054"))
			end
		end
	end)
end
function heroTrialLevelInfo:upateInfo()
	local num = heroTrialCommon.convertLevelToNum(self.levelId)
	heroTrialCommon = nil
	;(nil).level = num
	self.text_Name:setString(i18n("common_text_1769", nil))
	if num % 10 == 0 then
		self.text_talk:setString(self.bossTalk[math.random(#self.bossTalk)])
	else
		self.text_talk:setString(self.normalTalk[math.random(#self.normalTalk)])
	end
	heroTrialCommon, heroTrialCommon = self.text_talk, self.text_talk.setString
	self.text_talk.name = i18n("common_text_1823")
	heroTrialCommon, self.text_talk.setString[1403008], self.text_talk.icon = self.text_talk, self.text_talk, "2991.png"
	self.text_talk.name = i18n("common_text_1824")
	heroTrialCommon, self.text_talk.setString[1403009], self.text_talk.icon = self.text_talk, self.text_talk, "2990.png"
	self.text_talk.name = i18n("common_text_3521")
	self.text_talk.setString[1407128], self.text_talk.icon = self.text_talk, "2990.png"
	local customItem = self.text_talk.setString
	local itemDesRead = include("itemDesRead")
	local rewardList = heroTrialltCtrl.getRewardOfStage(self.levelId)
	local heroTrialCommon, nodeList = self.levelId, self.levelId
	local itemIcon, itemName
	for i = 1, 5 do
		self.reward[i].node:setVisible(false)
	end
	for i, v in ipairs(rewardList) do
		if self.reward[i] then
			self.reward[i].node:setVisible(true)
			nodeList[i] = self.reward[i].node
			if customItem[v.id] then
				itemIcon = customItem[v.id].icon
				itemName = customItem[v.id].name
			elseif itemDesRead.config[v.id] then
				itemIcon = itemDesRead.getIcon(v.id)
				itemName = itemDesRead.getName(v.id)
			elseif false == SoraDJudgeResOrItem(v.id) then
				itemIcon = publicRead.getIcon(v.id)
				itemName = publicRead.getName(v.id)
			end
			if itemIcon and itemName then
				self.reward[i].icon:setSpriteFrame(itemIcon)
				self.reward[i].name:setString(itemName)
			end
		end
	end
	util.layoutHorizontal(nodeList, 0)
	self.imageMonster:setSpriteFrame(self.bustName)
end
function heroTrialLevelInfo:openDispatch()
	local dispatchPanel = include("heroTrialDispatchArmy").new()
	dispatchPanel:initData(self.isAuto, self.beginTile, self.endTile)
	dispatchPanel:show()
	self:close(nil, ccui.TouchEventType.ended)
end
function heroTrialLevelInfo:onBegin(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isAuto = false
		if not heroTrialCommon.isTrialStarted(self.mapId) then
			if htPointMgr.isPointEnough(heroTrialltCtrl.getCostPointOfTrial()) then
				self:checkOpenTrial()
			else
				local itemId = 800301
				local itemCount = backpackCtrl:getItemCount(itemId)
				if 0 < itemCount then
					_ENV, _ENV = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().id = itemId
					heroTrialltCtrl.getCostPointOfTrial().itemData, heroTrialltCtrl.getCostPointOfTrial().count = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().msg = i18n("common_text_3420")
					uiManager:show("newItemSingleUse", heroTrialltCtrl.getCostPointOfTrial())
				else
					_ENV = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().point = HEROTRIAL_COST_POINTS
					SoraDShowMsgTip(i18n("common_text_1743", heroTrialltCtrl.getCostPointOfTrial()))
				end
			end
		else
			self:openDispatch()
		end
	end
end
function heroTrialLevelInfo:onDetail(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroTrialLevelDetail")
		panel:initData(self.enemyData)
		panel:show()
	end
end
function heroTrialLevelInfo:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 1)
		self:close(sender, type)
	end
end
function heroTrialLevelInfo:onAuto(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isAuto = true
		if not heroTrialCommon.isTrialStarted(self.mapId) then
			if htPointMgr.isPointEnough(heroTrialltCtrl.getCostPointOfTrial()) then
				self:checkOpenTrial()
			else
				local itemId = 800301
				local itemCount = backpackCtrl:getItemCount(itemId)
				if 0 < itemCount then
					_ENV, _ENV = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().id = itemId
					heroTrialltCtrl.getCostPointOfTrial().itemData, heroTrialltCtrl.getCostPointOfTrial().count = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().msg = i18n("common_text_3420")
					uiManager:show("newItemSingleUse", heroTrialltCtrl.getCostPointOfTrial())
				else
					_ENV = heroTrialltCtrl.getCostPointOfTrial()
					heroTrialltCtrl.getCostPointOfTrial().point = HEROTRIAL_COST_POINTS
					SoraDShowMsgTip(i18n("common_text_1743", heroTrialltCtrl.getCostPointOfTrial()))
				end
			end
		else
			self:openDispatch()
		end
	end
end
function heroTrialLevelInfo:updateAutoVip()
	local vipDetail = lordInfoCtrl:getVipDetails()
	local vip_limited = IsArClient and _G.VIP_LV5_LIMITED or _G.VIP_LV4_LIMITED
	if not vipDetail.isActivated or not (vip_limited <= vipDetail.level) then
		self.autoBtn:addTouchEventListener(function(sender, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				SoraDShowMsgBox(i18n("common_text_1837"), i18n("common_text_449"), i18n("common_text_1838"), handler(self, self.openVipView))
			end
		end)
	else
		self.autoBtn:addTouchEventListener(handler(self, self.onAuto))
	end
end
function heroTrialLevelInfo:openVipView(type)
	if type == MSGBOX_CALLBACK_YES then
		uiManager:show("vipCenterView")
	end
end
function heroTrialLevelInfo:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_attack" then
		return self.beginBtn
	end
	return SoraDGetChildByName(self, itemName)
end
return heroTrialLevelInfo
