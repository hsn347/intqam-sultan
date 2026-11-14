local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = gametop.playertop_:getModule("partyCtrl")
local partyltCtrl = include("partyltCtrl")
local timeCtrl = gametop.playertop_:getModule("timeCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local SCROLL_VIEW_WIDTH = 550
local SCROLL_VIEW_SPEED = 150
local PARTY_FEAST_REFRESH_TIME_CD = 5
local partyFeastListView = class("partyFeastListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("partyFeastListView")
	end
	return target
end)
function partyFeastListView:ctor()
	self:initView()
	self:initTime()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_SHOWREWARD", handler(self, self.receiveRewardCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_EVENT_TRIGGER", handler(self, self.updateFeastEventView))
end
function partyFeastListView:initView()
	self.tablePartyItem, _ENV, self.tableFeastItem, _ENV = nil, nil, nil, nil
	local root = self._ccsView
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.bg:setFillType(1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_banquet")
	self.partyCell = SoraDGetChildByName(self, "CCS_partyFeastCell_banquet")
	self.partyCell:setVisible(false)
	self.title:setTitle(i18n("feast_title_01"))
	self.btn_FAQ = SoraDGetChildByName(self, "btn_FAQ")
	self.ownerTitle = SoraDGetChildByName(self, "owner_info_text")
	self.owner_node = SoraDGetChildByName(self, "owner_node")
	self.feastListNode = SoraDGetChildByName(self, "feast_list_node")
	self.party_lefttime = SoraDGetChildByName(self, "party_lefttime")
	self.btn_text = SoraDGetChildByName(self, "btn_text")
	self.feastScroll = SoraDGetChildByName(self, "scroll")
	self.btn_down = SoraDGetChildByName(self, "btn_openparty")
	self.bgDownPart = SoraDGetChildByName(self, "bg_down_part")
	self.bgDownPart:setPositionY(-display.height)
	if display.height > 960 then
		self.feastScroll:setContentSize(cc.size(640, 830))
		self.feastScroll:setPositionY(-835)
	end
	if math.floor(display.height) == 853 then
		self.feastScroll:setContentSize(cc.size(640, 550))
		self.feastScroll:setPositionY(-550)
	end
	if device.isIphoneXMode() then
		self.feastScroll:setContentSize(cc.size(640, 990))
		self.feastScroll:setPositionY(-990)
	end
	self.btn_down:addTouchEventListener(handler(self, self.clickOpenInvite))
end
function partyFeastListView:initTime()
	self.party_lefttime = SoraDCreateTimerLabel(self, self.party_lefttime)
	self.party_lefttime:setTimeLast(function(ticket)
		return i18n("feast_text_19") .. ticket
	end)
	self.party_lefttime:setTimeEndListener(function()
		self:removeFromParent()
	end)
end
function partyFeastListView:initData(feastID)
	self.feastID = feastID
	self:update()
end
function partyFeastListView:update()
	self:updateFeastTitle()
	self:updateFeastScroll()
end
function partyFeastListView:updateFeastTitle()
	local feastData, isJoinOrOpen = partyltCtrl.getFeastInfoById(self.feastID)
	if feastData then
		local ownUUID = lordInfoCtrl:getLordInfo().base.uid
		if ownUUID ~= feastData.hostUid then
			isJoinOrOpen = false
		end
		self.isJoinOrOpen = isJoinOrOpen
		partyltCtrl = nil
		;(nil).name = feastData.nickName
		self.ownerTitle:setString(i18n("feast_text_04", nil))
		local feastIcon = self.owner_node:getChildByName("lord_head_icon")
		local feast_btn = self.owner_node:getChildByName("lord_btn")
		feast_btn:addTouchEventListener(handler(self, self.clickFeastIconBtn))
		feast_btn:setTouchEnabled(not isJoinOrOpen)
		SoraDGetHeadFromManager(feastIcon, feastData.headid, feastData.avatar, false)
		local time = feastData.endTime - timeCtrl:getServerTime()
		if 0 < time and not feastData.isEnd then
			self.party_lefttime:beginTime(time)
		end
		if self.isJoinOrOpen then
			self.btn_text:setString(i18n("common_text_189"))
		else
			local curNum = table.nums(feastData.uidListInfo)
			self.btn_text:setString(string.format("%d/%d\n", curNum, feastData.maxCount) .. i18n("feast_btn_04"))
		end
	end
end
function partyFeastListView:updateFeastScroll()
	local cellSizeW = 580
	local cellSizeH = 300
	local feastData = partyltCtrl.getFeastInfoById(self.feastID)
	if feastData then
		local feastSize = feastData.maxCount
		local scrollInner = self.feastScroll:getInnerContainer()
		local offsetY = scrollInner:getPositionY()
		local scrollMinH = self.feastScroll:getContentSize().height
		local scrollW = scrollInner:getContentSize().width
		local scrollH = math.max(scrollMinH, math.ceil(feastSize / 4) * cellSizeH + 10)
		local maxFeastNum = math.ceil(feastSize / 4)
		local feastBg = string.format("gejyh_zhuozi%02d.png", feastData.partyLv)
		for i, v in ipairs(self.tableFeastItem) do
			v:setVisible(false)
		end
		for i = 1, maxFeastNum do
			local cell = self.tableFeastItem[i]
			if not cell then
				cell = SoraDCreatAnimationEx("partyFeastCell", nil, true)
				cell:addTo(self.feastScroll)
				cell:setTag(i)
				SoraDMixtureGLONE(cell:getChildByName("animate_food"))
				for j = 1, 4 do
					partyFeastListView = cell:getChildByName("animate_food")
					cell:getChildByName("animate_food")[1] = "pos_node_" .. j
					cell:getChildByName("animate_food")[2] = "lord_btn"
					local btn = SoraDGetChildByFullPath(cell, cell:getChildByName("animate_food"))
					btn:addTouchEventListener(handlerEx(self, partyFeastListView.clickFeastCell, (i - 1) * 4 + j))
				end
				self.tableFeastItem[i] = cell
			end
			cell:setVisible(true)
			cell:setPosition(320, scrollH - i * 300 + 150)
			cell:getChildByName("dest_bg"):setSpriteFrame(feastBg)
			for j = 1, 4 do
				local lordPos = (i - 1) * 4 + j
				local posCell = cell:getChildByName("pos_node_" .. j)
				if feastSize < lordPos then
					posCell:setVisible(false)
				else
					posCell:setVisible(true)
					self:updateFeastCell(posCell)
				end
			end
		end
		for k, v in pairs(feastData.uidListInfo) do
			self:updateLordPos(v.location, v)
		end
		local offsetInnerY = scrollInner:getPositionY()
		local maxOffset = 0
		offsetInnerY = offsetInnerY - (scrollH - scrollInner:getContentSize().height)
		offsetInnerY = math.min(maxOffset, offsetInnerY)
		self.feastScroll:setInnerContainerSize(cc.size(scrollW, scrollH))
		self.feastScroll:getInnerContainer():setPositionY(offsetInnerY)
	end
end
function partyFeastListView:updateFeastCell(lordCell, info)
	local headIconNode = lordCell:getChildByName("lord_head_icon")
	local lordName = lordCell:getChildByName("lord_name")
	local lordNameBg = lordCell:getChildByName("lord_name_bg")
	local addIconNode = lordCell:getChildByName("lord_icon")
	local lordEvent = lordCell:getChildByName("lord_event")
	local isHasInfo = false
	if info then
		isHasInfo = true
		lordEvent:setVisible(info.sEvent == gSpecialEventType.EVENT_MATERIAL or info.sEvent == gSpecialEventType.EVENT_BANDIT)
	else
		lordEvent:setVisible(false)
	end
	addIconNode:setVisible(not isHasInfo)
	headIconNode:setVisible(isHasInfo)
	lordName:setVisible(isHasInfo)
	lordNameBg:setVisible(isHasInfo)
end
function partyFeastListView:updateLordPos(lordPos, info)
	local feastCell = self.tableFeastItem[math.ceil(lordPos / 4)]
	if not tolua.isnull(feastCell) then
		local index = lordPos % 4
		if index == 0 then
			index = 4
		end
		local posCell = feastCell:getChildByName("pos_node_" .. index)
		local lordName = posCell:getChildByName("lord_name")
		local headIconNode = posCell:getChildByName("lord_head_icon")
		local lordEvent = posCell:getChildByName("lord_event")
		if lordInfoCtrl:getBaseInfo().nickName == info.nickName then
			lordEvent:getChildByName("btn_up"):addTouchEventListener(handler(self, self.clickEventIconBtn))
			lordEvent:getChildByName("btn_up"):setTag(lordInfoCtrl:getLordInfo().base.uid)
		end
		if info then
			lordName:setString(info.nickName)
			SoraDGetHeadFromManager(headIconNode, info.headid, info.avatar, false)
		end
		self:updateFeastCell(posCell, info)
	end
end
function partyFeastListView:checkCommonSitState()
	if self.isJoinOrOpen then
		self.partySharePopView = SoraDCreatePanel("partySharePopView")
		self.partySharePopView:show()
		self.partySharePopView:initData(self, 0)
		return false
	end
	if 0 >= partyltCtrl.getLeftFeastNum() then
		SoraDShowMsgTip(i18n("feast_tips_02"))
		return false
	end
	if partyltCtrl.isAttendFeast(self.feastID) then
		SoraDShowMsgTip(i18n("feast_tips_16"))
		return false
	end
	return true
end
function partyFeastListView:clickEventIconBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local partyData = partyCtrl:getPartyData()
		local panel = SoraDCreatePanel("partyEventView")
		local index = 1
		for i, v in ipairs(partyData.myAttendPartyList) do
			if v.uidListInfo[tostring(target:getTag())] then
				index = i
				break
			end
		end
		panel:initData(partyData.myAttendPartyList[index].uidListInfo[tostring(target:getTag())], self.feastID)
		panel:show()
	end
end
function partyFeastListView:clickFeastCell(index, target, eventType)
	print("clickFeastCell", index, target, eventType, self.feastID)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cellInfo, uid = partyltCtrl.getFeastCellInfoByLocation(self.feastID, index)
		if cellInfo and lordInfoCtrl:getBaseInfo().nickName ~= cellInfo.nickName then
			local chatConst = include("chatConst")
			local chatFunctions = include("chatFunctions")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			lordInfoCtrl = gametop.playertop_
			gametop.playertop_[1] = chatConst.OpId.OpSendEmail
			local gametop.playertop_[2], menuData = chatConst.OpId.OpViewInfo, gametop.playertop_
			local bIsShield = chatFunctions.getIsShield(cellInfo.headid)
			if bIsShield == true then
				table.insert(menuData, chatConst.OpId.OpUnShield)
			elseif bIsShield == false then
				table.insert(menuData, chatConst.OpId.OpShield)
			end
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			_ENV = nil
			;(nil).playerId = uid
			;(nil).nickName = cellInfo.nickName
			;(nil).allianceAbbr = lordInfoCtrl:getLordInfo().abbr
			SoraDShowPlayerOperatePanel(cellInfo.nickName, menuData, nil)
			return
		end
		if not self:checkCommonSitState() then
			return
		end
		local skipCheck = partyltCtrl.isSkipRewardTipsCheck()
		if skipCheck then
			partyCtrl:sendAttendParty(self.feastID, index)
		else
			local feastData = partyltCtrl.getFeastInfoById(self.feastID)
			if not feastData then
				SoraDShowMsgTip(i18n("feast_tips_16"))
				return
			end
			local panel = SoraDCreatePanel("partyRewardTipsView")
			panel:initData(self.feastID, index)
			panel:show()
		end
	end
end
function partyFeastListView:clickOpenInvite(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self:checkCommonSitState() then
			return
		end
		local feastData = partyltCtrl.getFeastInfoById(self.feastID)
		if not feastData then
			SoraDShowMsgTip(i18n("feast_tips_16"))
			return
		end
		if not partyltCtrl.isFeastCanSit(self.feastID) then
			SoraDShowMsgTip(i18n("feast_tips_14"))
			return
		end
		local skipCheck = partyltCtrl.isSkipRewardTipsCheck()
		if skipCheck then
			partyCtrl:sendAttendParty(self.feastID)
		else
			local panel = SoraDCreatePanel("partyRewardTipsView")
			panel:initData(self.feastID)
			panel:show()
		end
	end
end
function partyFeastListView:clickFeastIconBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cellInfo = partyltCtrl.getFeastInfoById(self.feastID)
		if cellInfo then
			local chatConst = include("chatConst")
			local chatFunctions = include("chatFunctions")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			gametop = gametop.playertop_
			gametop.playertop_[1] = chatConst.OpId.OpSendEmail
			local gametop.playertop_[2], menuData = chatConst.OpId.OpViewInfo, gametop.playertop_
			local bIsShield = chatFunctions.getIsShield(cellInfo.headid)
			if bIsShield == true then
				table.insert(menuData, chatConst.OpId.OpUnShield)
			elseif bIsShield == false then
				table.insert(menuData, chatConst.OpId.OpShield)
			end
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			_ENV = nil
			;(nil).playerId = cellInfo.hostUid
			;(nil).nickName = cellInfo.nickName
			;(nil).allianceAbbr = lordInfoCtrl:getLordInfo().abbr
			SoraDShowPlayerOperatePanel(cellInfo.nickName, menuData, nil)
		end
	end
end
function partyFeastListView:receiveRewardCallBack(target, data)
	local panel = SoraDCreatePanel("partyRewardView")
	panel:initData(data.reward)
	panel:show()
end
function partyFeastListView:updateFeastEventView(target, data)
	local attendInfo = partyltCtrl.getFeastAttendInfo(self.feastID)
	if attendInfo then
		if attendInfo.sEvent == gSpecialEventType.EVENT_MATERIAL then
			local panel = SoraDCreatePanel("partyEventView")
			panel:initData(attendInfo, self.feastID, false)
			panel:show()
			print("ndddddddd: 材料事件")
			panel:setKeppCallback(function()
				self.partyPanel = SoraDSearchPanelFromManagerByName("partyView")
				if self.partyPanel ~= nil then
					SoraDRemoveAllAfterPanelFromManager(self.partyPanel, true)
				end
			end)
		elseif attendInfo.sEvent == gSpecialEventType.EVENT_BANDIT then
			local panel = SoraDCreatePanel("partyEventView")
			panel:initData(attendInfo, self.feastID, false)
			panel:show()
			print("ndddddddd: 强盗事件")
			panel:setKeppCallback(function()
				self.partyPanel = SoraDSearchPanelFromManagerByName("partyView")
				if self.partyPanel ~= nil then
					SoraDRemoveAllAfterPanelFromManager(self.partyPanel, true)
				end
			end)
		elseif attendInfo.sEvent == gSpecialEventType.EVENT_TIRED or attendInfo.sEvent == gSpecialEventType.NO_EVENT or attendInfo.sEvent > 3 then
			if not data.totalInfo.commonReward then
				local FARD = require_data("feast_attend_reward", true).data
				local feastData, isJoinOrOpen = partyltCtrl.getFeastInfoById(self.feastID)
				_UPVALUE2_ = false
				;(false)[1] = "id"
				;(false)[2] = "num"
				local rewardData = serviceFunctions.tableFormat(FARD[feastData.partyLv].Reward, false)
				data.totalInfo.commonReward = rewardData
				if not data.totalInfo.feastInfo then
					data.totalInfo.feastInfo = feastData
				end
			end
			local panel = SoraDCreatePanel("partyRewardView")
			panel:initData(data.totalInfo)
			panel:show()
			print("ndddddddd: 疲劳事件")
		end
	end
end
function partyFeastListView:getTitleTips()
	if not self.maxFeastTipsNum then
		local FTD = require_data("feast_tips")
		self.maxFeastTipsNum = table.nums(FTD.data)
		self.feastTipsIndex = 1
	end
	if self.feastTipsIndex > self.maxFeastTipsNum then
		self.feastTipsIndex = 1
	end
	local msg = i18n(string.format("feast_roll_tips_%02d", self.feastTipsIndex))
	self.feastTipsIndex = self.feastTipsIndex + 1
	return msg
end
function partyFeastListView:startMsgScrollHorizontal()
	self.partyTitleTips2:stopAllActions()
	self.partyTitleTips1:stopAllActions()
	local topSize = self.partyTitleTips1:getContentSize()
	local offset = math.max(topSize.width, SCROLL_VIEW_WIDTH)
	self.partyTitleTips2:setPosition(self.defaultTitlePos.x + offset, self.defaultTitlePos.y)
	self.partyTitleTips1:setPosition(self.defaultTitlePos)
	local _ENV, arrDownAni = self.partyTitleTips1.setPosition, self.partyTitleTips1.setPosition
	local time = offset / SCROLL_VIEW_SPEED
	table.insert(arrDownAni, cc.MoveBy:create(time, cc.p(-offset, 0)))
	table.insert(arrDownAni, cc.CallFunc:create(handler(self, self.showMsgAni)))
	self.partyTitleTips2:runAction(cc.Sequence:create(arrDownAni))
	self.partyTitleTips1:runAction(cc.MoveBy:create(time, cc.p(-offset, 0)))
	local tmp = self.partyTitleTips2
	self.partyTitleTips2 = self.partyTitleTips1
	self.partyTitleTips1 = tmp
end
function partyFeastListView:showMsgAni()
	local msg = self:getTitleTips()
	if msg then
		self.curMsg = msg
		self.partyTitleTips2:setString(msg)
		self:startMsgScrollHorizontal()
	else
		self.curMsg = nil
		self.partyTitleTips2:setString("")
		self.partyTitleTips1:setString("")
	end
end
return partyFeastListView
