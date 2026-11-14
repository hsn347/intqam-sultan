local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = gametop.playertop_:getModule("partyCtrl")
local partyltCtrl = include("partyltCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local FAD = require_data("feastattribute", true)
local SCROLL_VIEW_WIDTH = 550
local SCROLL_VIEW_SPEED = 150
local partyCreateView = class("partyCreateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("partyCreateView")
	end
	return target
end)
function partyCreateView:ctor()
	self:initView()
	self:initEvent()
end
function partyCreateView:initView()
	self.rewardItemList, _ENV, self.table_addicon, _ENV, self.btnList, _ENV, self.castItemList, _ENV, self.material_needs, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true
	self.selectTabIndex = 4
	local root = self._ccsView
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_banquet")
	self.title:setTitle(i18n("feast_title_01"))
	partyltCtrl = i18n("feast_title_01")
	i18n("feast_title_01")[1] = "Top_Node"
	i18n("feast_title_01")[2] = "btn_Node"
	self.btn_Node = SoraDGetChildByFullPath(root, i18n("feast_title_01"))
	partyltCtrl = i18n("feast_title_01")
	i18n("feast_title_01")[1] = "Top_Node"
	i18n("feast_title_01")[2] = "scroll_reward"
	self.scroll = SoraDGetChildByFullPath(root, i18n("feast_title_01"))
	if display.height > 960 then
		self.scroll:setContentSize(cc.size(640, 840))
		self.scroll:setPositionY(-1000)
	end
	if math.floor(display.height) == 853 then
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 560))
		self.scroll:setPositionY(-720)
	end
	if device.isIphoneXMode() then
		self.scroll:setContentSize(cc.size(640, 1300))
		self.scroll:setPositionY(-1460)
	end
	self.source_item_node = SoraDGetChildByName(self.scroll, "source_item_node")
	self.icon_add = SoraDGetChildByName(self.source_item_node, "cast_add_icon")
	self.text_open_tip = SoraDGetChildByName(self.source_item_node, "text_open_tip")
	_ENV = cc.size(640, 1300)
	cc.size(640, 1300).feast = i18n(FAD.data[self.selectTabIndex].FeastName)
	self.text_open_tip:setString(i18n("feast_text_11", cc.size(640, 1300)))
	self.text_open_tips = SoraDGetChildByName(self.source_item_node, "text_open_tips")
	SoraDSetTextWidthHeight(self.text_open_tip, cc.size(600, 60))
	self.text_open_tip:setFontSize(18)
	self.text_tip_1 = SoraDGetChildByName(self.source_item_node, "text_tip")
	SoraDSetTextWidthHeight(self.text_tip_1, cc.size(600, 60))
	self.text_tip_1:setFontSize(18)
	self.feastTipsIndex = 1
	self.text_tip_1:setString(i18n("feast_roll_tips_03"))
	self.text_tip_2 = self.text_tip_1:clone()
	self.text_tip_2:setName("text_tips_2")
	self.text_tip_2:addTo(self.text_tip_1:getParent())
	self.defaultTitlePos = cc.p(self.text_tip_1:getPosition())
	self.reward_node = SoraDGetChildByName(self.scroll, "reward_node")
	self.single_reward_info = self.reward_node:getChildByName("reward_info_node")
	partyltCtrl = "reward_info_node"
	;("reward_info_node")[1] = "Top_Node"
	;("reward_info_node")[2] = "bg_down_part"
	self.down_part = SoraDGetChildByFullPath(root, "reward_info_node")
	self.text_open_lefttime = SoraDGetChildByName(self.down_part, "text_open_lefttime")
	self.btn_openparty = SoraDGetChildByName(self.down_part, "btn_openparty")
	self.btn_openparty:setTitleText(i18n("feast_btn_03"))
	self.down_part:setPositionY(-display.height)
	for i = 1, 4 do
		local btn = self.btn_Node:getChildByName("btn_tab_" .. i)
		local tabName = btn:getChildByName("text_tab_" .. i)
		SoraDSetTextWidthHeight(tabName, cc.size(100, 60))
		tabName:setString(i18n(FAD.data[5 - i].FeastName))
		self.btnList[i] = btn
		local singleItem = self.source_item_node:getChildByName("cast_item_" .. i)
		singleItem:setPosition(cc.p(-290 + 160 * (i - 1), -85))
		self.material_needs[i] = singleItem
		singleItem:setVisible(false)
	end
	for i = 1, 3 do
		local single_item = self.icon_add:clone()
		single_item:addTo(self.source_item_node)
		self.table_addicon[i] = single_item
	end
	for i = 1, self.selectTabIndex + 1 do
		local single_reward = self.single_reward_info:clone()
		single_reward:addTo(self.reward_node)
		self.castItemList[i] = single_reward
		self:initRardItemList(i)
	end
	self.text_open_lefttime:setString(i18n("feast_text_01") .. partyltCtrl.getLeftInviteNum())
	self.isJoinAlliance = allianceMgr:hasJoinAlliance()
	self:updateRewardList(self.selectTabIndex + 1)
	self:updatematerial()
	SoraDAddMessage(self, "MESSAGE_ITEM_MERGE_BACK", handler(self, self.updatematerial))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_OPENBACK", handler(self, self.updateOpenInfo))
end
function partyCreateView:initEvent()
	SoraDGetChildByName(self, "btn_FAQ"):addTouchEventListener(handler(self, partyCreateView.clickFAQBtn))
	for i = 1, 4 do
		local btn = self.material_needs[i]:getChildByName("lord_btn")
		btn:addTouchEventListener(handlerEx(self, self.clickCastItem, i))
		self.btnList[i]:addTouchEventListener(handlerEx(self, partyCreateView.clickChangeTabBtn, i))
	end
	self.btn_openparty:addTouchEventListener(handler(self, partyCreateView.clickOpenPartyBtn))
end
function partyCreateView:initRardItemList(index)
	local _ENV, itemList
	for i = 1, 6 do
		local singleItem = include("itemSingleView").new()
		singleItem:setRechargeUse(true)
		singleItem:sendParentToButton(self)
		singleItem:setScale(0.6)
		singleItem:setVisible(false)
		singleItem:addTo(self.castItemList[index])
		itemList[i] = singleItem
	end
	self.rewardItemList[index] = itemList
end
function partyCreateView:updatematerial()
	local selectData = FAD.data[self.selectTabIndex]
	self.isItemEnough = true
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local num = math.floor(#selectData.FeastNeed / 2)
	gametop, FAD = nil, #selectData.FeastNeed / 2
	_UPVALUE3_, (#selectData.FeastNeed / 2)[1], (nil)[1] = nil, nil, 0
	_UPVALUE5_, (#selectData.FeastNeed / 2)[2], (nil)[1] = nil, nil, -80
	_UPVALUE5_, (#selectData.FeastNeed / 2)[2], (nil)[2] = nil, nil, 0
	_UPVALUE5_, (#selectData.FeastNeed / 2)[2], (nil)[3] = nil, nil, 80
	_UPVALUE7_, (#selectData.FeastNeed / 2)[3], (nil)[1] = nil, nil, -160
	_UPVALUE7_, (#selectData.FeastNeed / 2)[3], (nil)[2] = nil, nil, -80
	_UPVALUE7_, (#selectData.FeastNeed / 2)[3], (nil)[3] = nil, nil, 0
	_UPVALUE7_, (#selectData.FeastNeed / 2)[3], (nil)[4] = nil, nil, 80
	_UPVALUE7_, (#selectData.FeastNeed / 2)[3], (nil)[5] = nil, nil, 160
	;(#selectData.FeastNeed / 2)[4], (nil)[1] = nil, -240
	;(#selectData.FeastNeed / 2)[4], (nil)[2] = nil, -160
	;(#selectData.FeastNeed / 2)[4], (nil)[3] = nil, -80
	;(#selectData.FeastNeed / 2)[4], (nil)[4] = nil, 0
	;(#selectData.FeastNeed / 2)[4], (nil)[5] = nil, 80
	;(#selectData.FeastNeed / 2)[4], (nil)[6] = nil, 160
	;(#selectData.FeastNeed / 2)[4], (nil)[7] = nil, 240
	local confPos = #selectData.FeastNeed / 2
	for i = 1, 4 do
		if num < i then
			self.material_needs[i]:setVisible(false)
		else
			local index = (i - 1) * 2 + 1
			local castItemID = selectData.FeastNeed[index]
			local needNum = selectData.FeastNeed[index + 1]
			local info
			if castItemID and needNum then
				FAD = nil
				;(nil).itemID = castItemID
				info, (nil).maxNum = nil, needNum
				info.num = backpackCtrl:getItemCount(castItemID) or 0
				if info.num < info.maxNum then
					self.isItemEnough = false
				end
			end
			self:updateItemNode(self.material_needs[i], info)
			self.material_needs[i]:setPositionX(confPos[self.selectTabIndex][index])
		end
	end
	for i = 1, 3 do
		if i > num - 1 then
			self.table_addicon[i]:setVisible(false)
		else
			self.table_addicon[i]:setVisible(true)
			self.table_addicon[i]:setPosition(cc.p(confPos[self.selectTabIndex][i * 2], -85))
		end
	end
	FAD = self.table_addicon[i].setPosition
	self.table_addicon[i].setPosition.feast = i18n(FAD.data[self.selectTabIndex].FeastName)
	self.text_open_tip:setString(i18n("feast_text_11", self.table_addicon[i].setPosition))
end
function partyCreateView:updateOpenInfo()
	self:updatematerial()
	self.text_open_lefttime:setString(i18n("feast_text_01") .. partyltCtrl.getLeftInviteNum())
end
function partyCreateView:updateItemNode(node, info)
	if not node then
		return
	end
	if info then
		node:setVisible(true)
		local iconBg = node:getChildByName("lord_bg")
		local iconImage = node:getChildByName("lord_icon")
		local textNum = node:getChildByName("Text_num")
		iconImage:setSpriteFrame(itemDesRead.getIcon(info.itemID))
		iconBg:setSpriteFrame(itemDesRead.getBg(info.itemID))
		if textNum then
			if info.num then
				textNum:setString(string.format("%d/%d", info.num, info.maxNum))
				textNum:setVisible(true)
				if info.num < info.maxNum then
					textNum:setColor(display.COLOR_RED)
				else
					textNum:setColor(display.COLOR_GREEN)
				end
			else
				textNum:setVisible(false)
			end
		end
	else
		node:setVisible(false)
	end
end
function partyCreateView:updateRewardList(num)
	local feast_reward_info = require_data("feast_set_reward", true)
	local selectData = FAD.data[self.selectTabIndex]
	local _ENV, sectionTable = self.selectTabIndex, self.selectTabIndex
	for i, v in ipairs(feast_reward_info.data) do
		if v.FeastLevel == self.selectTabIndex then
			table.insert(sectionTable, v)
		end
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollW = scrollInner:getContentSize().width
	local scrollMinH = self.scroll:getContentSize().height
	local scrollH = math.max(self.scroll:getContentSize().height, 285 + num * 152)
	self.source_item_node:setPositionY(scrollH + 5)
	self.reward_node:setPositionY(scrollH - 280)
	local first_item_height = self.reward_node:getPositionY()
	for i, v in ipairs(self.castItemList) do
		v:setVisible(false)
	end
	for i = 1, num do
		self.castItemList[i]:setVisible(true)
		local human_num = self.castItemList[i]:getChildByName("human_number")
		local section = sectionTable[i].Section
		if section[2] ~= section[1] then
			human_num:setString(section[1] .. "~" .. section[2])
		else
			human_num:setString(section[1])
		end
		self.castItemList[i]:setVisible(true)
		self.castItemList[i]:setPosition(0, 0 - 152 * (i - 1))
		local rewardInfo = sectionTable[i].Reward
		self:initcastItem(rewardInfo, i)
	end
	offsetY = math.min(0, math.max(scrollMinH - scrollH, offsetY - (scrollH - scrollInner:getContentSize().height)))
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
	scrollInner:setPositionY(offsetY)
	local partytime = selectData.FeastTime / 3600
	local maxnum = selectData.Max
	local pointsreward = sectionTable[self.selectTabIndex].Point
	_ENV = cc.size(scrollW, scrollH)
	cc.size(scrollW, scrollH).time = partytime
	cc.size(scrollW, scrollH).num = maxnum
	cc.size(scrollW, scrollH).point = pointsreward
	self.text_open_tips:setString(string.format(i18n("feast_text_46", cc.size(scrollW, scrollH))))
end
function partyCreateView:initcastItem(rewardInfo, index)
	local num = #rewardInfo / 2
	local first = (640 - num * 95 - (num - 1) * 5) / 2 - 320
	local itemList = self.rewardItemList[index]
	for i = 1, 6 do
		if i > num then
			itemList[i]:setVisible(false)
		else
			itemList[i]:setButtonTag(rewardInfo[(i - 1) * 2 + 1])
			itemList[i]:setVisible(true)
			_ENV = itemList[i].setVisible
			itemList[i].setVisible.id = rewardInfo[(i - 1) * 2 + 1]
			local itemList[i].setVisible.count, info = rewardInfo[i * 2], itemList[i].setVisible
			_ENV = nil
			;(nil).itemData = info
			itemList[i]:initData(nil)
			itemList[i]:setPosition(cc.p(first + 100 * (i - 1), -55))
		end
	end
end
function partyCreateView:clickChangeTabBtn(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		for i = 1, 4 do
			if index == i then
				self.btnList[i]:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
				self.btnList[i]:setTouchEnabled(false)
				self.btnList[i]:setBright(false)
				self.selectTabIndex = 5 - index
				self:updatematerial()
				self:updateRewardList(self.selectTabIndex + 1)
			else
				self.btnList[i]:loadTextureNormal("btn_alliance_unchoose.png", ccui.TextureResType.plistType)
				self.btnList[i]:setTouchEnabled(true)
				self.btnList[i]:setBright(true)
			end
		end
	end
end
function partyCreateView:clickOpenPartyBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if partyltCtrl.getLeftInviteNum() <= 0 then
			SoraDShowMsgTip(i18n("feast_text_32"))
			return
		end
		if not self.isItemEnough then
			SoraDShowMsgTip(i18n("feast_tips_08"))
			return
		end
		local partyInfo = partyCtrl:getPartyData()
		if partyInfo.myOpenParty then
			SoraDShowMsgTip(i18n("feast_tips_03"))
			return
		end
		if partyInfo.myAttendParty and partyInfo.myAttendParty.sEvent ~= gSpecialEventType.NO_EVENT then
			SoraDShowMsgTip(i18n("feast_tips_04"))
			return
		end
		self:showShareBox()
	end
end
function partyCreateView:showShareBox()
	self.partySharePopView = SoraDCreatePanel("partySharePopView")
	self.partySharePopView:show()
	self.partySharePopView:initData(self, self.selectTabIndex)
end
function partyCreateView:clickCastItem(i, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local selectData = FAD.data[self.selectTabIndex]
		local index = (i - 1) * 2 + 1
		local castItemID = selectData.FeastNeed[index]
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local materials = backpackltCtrl:getMaterialOfMergeItem(castItemID)
		if materials then
			_ENV = nil
			;(nil).itemID = materials[1].id
			uiManager:show("itemCompoundView", nil)
		end
	end
end
function partyCreateView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PARTY_ACTIVITY)
	end
end
function partyCreateView:getTitleTips()
	local FTD = require_data("feast_tips")
	self.maxFeastTipsNum = #FTD.data
	if self.feastTipsIndex > self.maxFeastTipsNum then
		self.feastTipsIndex = 1
	end
	local msg = i18n(string.format("feast_roll_tips_%02d", self.feastTipsIndex))
	if self.feastTipsIndex == 4 then
		self.feastTipsIndex = self.feastTipsIndex + 2
	else
		self.feastTipsIndex = self.feastTipsIndex + 1
	end
	return msg
end
function partyCreateView:startMsgScrollHorizontal()
	self.text_tip_1:stopAllActions()
	self.text_tip_2:stopAllActions()
	local topSize = self.text_tip_1:getContentSize()
	local offset = topSize.width / 2 + SCROLL_VIEW_WIDTH
	self.text_tip_2:setPosition(self.defaultTitlePos.x + offset, self.defaultTitlePos.y)
	local SCROLL_VIEW_WIDTH, arrDownAni = self.text_tip_2.setPosition, self.text_tip_2.setPosition
	local time = offset / SCROLL_VIEW_SPEED
	table.insert(arrDownAni, cc.MoveBy:create(time, cc.p(-offset, 0)))
	table.insert(arrDownAni, cc.CallFunc:create(handler(self, self.showMsgAni)))
	self.text_tip_2:runAction(cc.Sequence:create(arrDownAni))
	self.text_tip_1:runAction(cc.MoveBy:create(time, cc.p(-offset, 0)))
	local tmp = self.text_tip_2
	self.text_tip_2 = self.text_tip_1
	self.text_tip_1 = tmp
end
function partyCreateView:showMsgAni()
	local msg = self:getTitleTips()
	if msg then
		self.curMsg = msg
		self.text_tip_2:setString(msg)
		self:startMsgScrollHorizontal()
	else
		self.curMsg = nil
		self.text_tip_2:setString("")
		self.text_tip_1:setString("")
	end
end
return partyCreateView
