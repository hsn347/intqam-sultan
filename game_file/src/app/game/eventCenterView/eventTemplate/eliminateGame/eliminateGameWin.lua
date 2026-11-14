local publicRead = include("publicRead")
local eliminateGameCommon = include("eliminateGameCommon")
local gametop = gModuleMgr.getObject("gametop")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local EliminateGameWin = class("eliminateGameWin", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eliminateGameWin")
	end
	return target
end)
function EliminateGameWin:ctor()
	self.baseclose = self.close
	function self.close()
		print("overrided ")
	end
	local centerNode = SoraDGetChildByName(self, "Center_Node")
	local exitBtn = SoraDGetChildByName(self, "exitBtn")
	local retryBtn = SoraDGetChildByName(self, "retryBtn")
	local shareBtn = SoraDGetChildByName(self, "shareBtn")
	self.shareBtn = shareBtn
	local title = SoraDGetChildByName(self, "title")
	local totalStep = SoraDGetChildByName(self, "totalStep")
	local totalDouble = SoraDGetChildByName(self, "totalDouble")
	self.panelRewards = SoraDGetChildByName(self, "panel_rewards")
	title:setString(i18n("common_text_316"))
	totalStep:setString(i18n("common_text_2539") .. ":" .. siegeCombatCtrl:getTotalUseStep())
	totalDouble:setString(i18n("common_text_2540") .. ":" .. siegeCombatCtrl:getTotalUseDouble())
	shareBtn:setTitleText(i18n("common_text_533"))
	shareBtn:setPressedActionEnabled(true)
	shareBtn:addTouchEventListener(handler(self, self.onShareBtn))
	local sharePicBtn = include("commonShareButton").createSnapshootButton(5)
	sharePicBtn:setPosition(shareBtn:getPositionX() - SoraDFSign(175), shareBtn:getPositionY())
	sharePicBtn:addTo(shareBtn:getParent(), shareBtn:getLocalZOrder())
	exitBtn:setTitleText(i18n("notice_0168"))
	retryBtn:setTitleText(i18n("common_text_2541"))
	exitBtn:addTouchEventListener(handler(self, self.onExitBtn))
	retryBtn:addTouchEventListener(handler(self, self.onRetryBtn))
	self:setBackGround(178.5)
	self.isHidePrePanel = false
	self.sendFinish = true
	self.sendFinishAlliance = true
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_SHARE", self.onShareBack)
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_SHARE_ALLIANCE", self.onShareAllianceBack)
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_SHOW_ITEMINFO", handler(self, self.openItemInfo))
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_CLOSE_ITEMINFO", handler(self, self.closeItemInfo))
end
function EliminateGameWin:sortItem(data)
	_ENV = nil
	;(nil)["frame_item_base_01.png"] = 1
	;(nil)["frame_item_base_02.png"] = 2
	;(nil)["frame_item_base_03.png"] = 3
	;(nil)["frame_item_base_04.png"] = 4
	;(nil)["frame_item_base_05.png"] = 5
	local (nil)["frame_item_base_06.png"], values = 6, nil
	table.sort(data, function(a, b)
		return values[publicRead.getBg(a.id)] > values[publicRead.getBg(b.id)]
	end)
end
function EliminateGameWin:initData(data, exitCb, retryCb)
	self.exitCb = exitCb
	self.retryCb = retryCb
	self:sortItem(data)
	local items = data
	for i = 1, #items do
		items[i].itemid = items[i].id
		items[i].itemnum = items[i].count
	end
	local itemsNum = #items
	local row = math.floor(itemsNum / 4)
	local fmodRow = math.fmod(itemsNum, 4)
	if fmodRow ~= 0 then
		row = row + 1
	end
	self.panelRewards:setLayoutType(ccui.LayoutType.VERTICAL)
	local unitWidth = 100
	local unitHeight = 100
	local boxWidth = 4 * unitWidth
	local boxHeight = unitHeight
	local iIndex = 0
	for i = 1, row do
		local vLayout = ccui.VBox:create()
		vLayout:setContentSize(cc.size(boxWidth, boxHeight))
		local numPerRow = 1
		if itemsNum >= i * 4 then
			numPerRow = 4
		else
			numPerRow = fmodRow
		end
		local hLayout = ccui.HBox:create()
		hLayout:setContentSize(cc.size(numPerRow * unitWidth, unitHeight))
		for j = 1, numPerRow do
			local reawrdData = items[iIndex + 1]
			local itemBoxNode = self:getRewardItem(reawrdData)
			hLayout:addChild(itemBoxNode)
			local lp1 = ccui.LayoutParameter:create()
			itemBoxNode:setLayoutParameter(lp1)
			itemBoxNode:setPosition(cc.p((j - 1) * 100 + 10, 0))
			hLayout:setSwallowTouches(false)
			iIndex = iIndex + 1
			itemBoxNode:setName("rewardItem_" .. iIndex)
		end
		local lp1 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp1)
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		vLayout:addChild(hLayout)
		vLayout:setSwallowTouches(false)
		local lp2 = ccui.LinearLayoutParameter:create()
		vLayout:setLayoutParameter(lp2)
		lp2:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp2:setMargin(ccui.LinearGravity.centerHorizontal)
		self.panelRewards:addChild(vLayout)
		if iIndex == itemsNum then
			break
		end
	end
end
function EliminateGameWin:getRewardItem(reawrdData)
	local eliminateGameRewardItem = include("eliminateGameRewardItem")
	local itemNode = eliminateGameRewardItem.new()
	itemNode:initWithData(reawrdData)
	itemNode:setScale(90 / itemNode:getItemWidth())
	itemNode:setCascadeOpacityEnabled(true)
	return itemNode
end
function EliminateGameWin:onShareBtn(sender, type)
	if type == ccui.TouchEventType.ended then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local playerAlliance = allianceMgr:getAlliance()
		if playerAlliance ~= nil then
			_ENV, _ENV = self.confirmShare, self
			self.confirmShare.normal = "btn_green_small_01.png"
			self.confirmShare.pressed = ""
			self.noStyle, self.confirmShare.cancel = self.confirmShare, ""
			SoraDShowMsgBox(i18n("common_text_1485"), i18n("common_text_1487"), i18n("common_text_1486"), handler(self, self.confirmShare), self)
		else
			SoraDShowMsgBox(i18n("common_text_1485"), i18n("common_text_1486"), nil, handler(self, self.confirmShare))
		end
	end
end
function EliminateGameWin:confirmShare(event)
	if event == MSGBOX_CALLBACK_YES then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local playerAlliance = allianceMgr:getAlliance()
		if playerAlliance ~= nil then
			print("分享到联盟")
			if self.hasSharedAlliance then
				SoraDShowMsgTip(i18n("common_text_2550"))
			elseif self.sendFinishAlliance then
				self.sendFinishAlliance = false
				siegeCombatCtrl:sendAllianceShare()
				self.shareBtn:setEnabled(false)
				self.shareBtn:setBright(false)
			end
		else
			print("分享到世界")
			if self.hasShared then
				SoraDShowMsgTip(i18n("common_text_2550"))
			elseif self.sendFinish then
				self.sendFinish = false
				siegeCombatCtrl:sendShare()
				self.shareBtn:setEnabled(false)
				self.shareBtn:setBright(false)
			end
		end
	elseif event == MSGBOX_CALLBACK_NO then
		print("分享到世界")
		if self.hasShared then
			SoraDShowMsgTip(i18n("common_text_2550"))
		elseif self.sendFinish then
			self.sendFinish = false
			siegeCombatCtrl:sendShare()
			self.shareBtn:setEnabled(false)
			self.shareBtn:setBright(false)
		end
	else
		print("取消分享")
	end
end
function EliminateGameWin:onShareBack(data)
	if data.errCode == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	else
		SoraDShowMsgTip(i18n("common_text_2126"))
	end
	self.hasShared = true
	self.sendFinish = true
end
function EliminateGameWin:onShareAllianceBack(data)
	if data.errCode == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("notice_0103"))
	else
		SoraDShowMsgTip(i18n("common_text_2549"))
	end
	self.hasSharedAlliance = true
	self.sendFinishAlliance = true
end
function EliminateGameWin:onExitBtn(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.exitCb()
		self:baseclose(sender, type)
	end
end
function EliminateGameWin:onRetryBtn(sender, type)
	if type == ccui.TouchEventType.ended then
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SIEGE_COMBAT)
		if eventState ~= gActivityState.OPEN then
			SoraDShowMsgTip(i18n("common_text_1859"))
			return
		end
		eliminateGameCommon.restartGame(function()
			self.retryCb()
			self:baseclose(sender, type)
		end)
	end
end
function EliminateGameWin:openItemInfo(target, data)
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
function EliminateGameWin:closeItemInfo(target, data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return EliminateGameWin
