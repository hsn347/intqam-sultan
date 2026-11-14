local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local tradeBoardViewPanel = class("tradeBoardViewPanel", baseFguiPanel)
function tradeBoardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("tradeBoardViewPanel:ctor", self.viewName)
end
function tradeBoardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function tradeBoardViewPanel:onInit()
	print("=======tradeBoardViewPanel:onInit")
	self.activityID1 = gActivityTimeActivityID.SALESROOM_ACTIVITY
	self.activityID2 = gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY
	self.newTradeList, _ENV, self.tradeList, _ENV, self.tag = gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, 1
	self.isInit1 = true
	self.isInit2 = true
	self.dataByClassify, _ENV, self.salesRoomData, _ENV, self.menuTag = gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, 1
	self.resType = 1
	self.isOnlyShowTrade = false
	self.fields.Com_title:initData(i18n("common_text_2768"), handler(self, self.onClickClose))
	self.fields.Text_resting:setString(i18n("common_text_2847"))
	self.fields.Text_resting:setVisible(false)
	self.fields.Text_returnGoldTip:setString(i18n("common_text_2810"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Button_record:addClickListener(handler(self, self.btnRecordClick))
	self.fields.List_trade:setVirtual()
	self.fields.List_trade:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tips:setString(i18n("auction_text_28"))
	self.fields.Text_tick:setString(i18n("common_text_4781"))
	self.fields.Com_nextTurn:setVisible(false)
	self.fields.Check_tick:setVisible(false)
	self.fields.Text_tick:setVisible(false)
	self.fields.List_newTrade:setVirtual()
	self.fields.List_newTrade:setItemRenderer(handler(self, self.onNewItemRenderer))
	self.fields.Com_diamond:addClickListener(handler(self, self.btnDiamondClick))
	self.fields.Text_leftTime = SoraDCreateTimerLabel(self, self.fields.Text_leftTime)
	self.fields.List_res:setItemRenderer(handler(self, self.onResRenderer))
	self.fields.Check_tick:setSelected(self.isOnlyShowTrade)
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
	self.fields.Button_help:fixPos()
	self.fields.Text_time:fixPos()
	self.fields.Button_record:fixPos()
	self.fields.Text_returnGoldTip:fixPos()
	self.fields.Icon_gold:fixPos()
	self.fields.Text_returnGold:fixPos()
	self.fields.Text_activityTime:fixPos()
	self.fields.Text_leftTime:fixPos()
	self.fields.Check_tick:fixPos()
	self.fields.Text_tick:fixPos()
end
function tradeBoardViewPanel:onShow()
	print("=======tradeBoardViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	self.uid = lordInfoCtrl:getLordInfo().base.uid
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("auction_title_01")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("activity_name_174")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickBtns)
	self.fields.Tab_title:initView(nil)
	self.hint = salesRoomAgCtrl:getHint() or false
	self:refreshRedPoint()
	_ENV, _ENV = self, self.refreshRedPoint
	self.tag = 1
	_ENV, self.refreshRedPoint[1], self.png = self, self, "icon_ycdy_all.png"
	self.tag = 2
	salesRoomAgCtrl, self.png = nil, "icon_middle_wood.png"
	_ENV, self.refreshRedPoint[2], self.resType, (nil)[1] = self, self, nil, gIDDef.WOOD
	_ENV, self.refreshRedPoint[2], self.resType, (nil)[2] = self, self, nil, gIDDef.WOOD_SAFE
	self.tag = 3
	salesRoomAgCtrl, self.png = nil, "icon_middle_food.png"
	_ENV, self.refreshRedPoint[3], self.resType, (nil)[1] = self, self, nil, gIDDef.FOOD
	_ENV, self.refreshRedPoint[3], self.resType, (nil)[2] = self, self, nil, gIDDef.FOOD_SAFE
	self.tag = 4
	salesRoomAgCtrl, self.png = nil, "icon_middle_iron.png"
	_ENV, self.refreshRedPoint[4], self.resType, (nil)[1] = self, self, nil, gIDDef.IRON
	_ENV, self.refreshRedPoint[4], self.resType, (nil)[2] = self, self, nil, gIDDef.IRON_SAFE
	self.tag = 5
	salesRoomAgCtrl, self.png = nil, "icon_middle_silver.png"
	_ENV, self.refreshRedPoint[5], self.resType, (nil)[1] = self, self, nil, gIDDef.MITHRIL
	_ENV, self.refreshRedPoint[5], self.resType, (nil)[2] = self, self, nil, gIDDef.MITHRIL_SAFE
	self.tag = 6
	salesRoomAgCtrl, self.png = nil, "icon_middle_crystal.png"
	self.resCfg, self.refreshRedPoint[6], self.resType, (nil)[1] = self.refreshRedPoint, self, nil, gIDDef.CRYSTAL
	self.resCfg, self.refreshRedPoint[6], self.resType, (nil)[2] = self.refreshRedPoint, self, nil, gIDDef.CRYSTAL_SAFE
	self.fields.List_res:setNumItems(#self.resCfg)
	_ENV = #self.resCfg
	_ENV, _ENV, (#self.resCfg).defaultClick = gIDDef.CRYSTAL_SAFE, self.menuTag, self.menuTag
	gIDDef.CRYSTAL_SAFE.title = i18n("common_text_635")
	_ENV, self.menuTag[1], gIDDef.CRYSTAL_SAFE.tag = gIDDef.CRYSTAL_SAFE, gIDDef.CRYSTAL_SAFE, 1
	gIDDef.CRYSTAL_SAFE.title = i18n("recharge_label_001")
	_ENV, self.menuTag[2], gIDDef.CRYSTAL_SAFE.tag = gIDDef.CRYSTAL_SAFE, gIDDef.CRYSTAL_SAFE, 2
	gIDDef.CRYSTAL_SAFE.title = i18n("common_text_018")
	_ENV, self.menuTag[3], gIDDef.CRYSTAL_SAFE.tag = gIDDef.CRYSTAL_SAFE, gIDDef.CRYSTAL_SAFE, 3
	gIDDef.CRYSTAL_SAFE.title = i18n("common_text_311")
	_ENV, self.menuTag[4], gIDDef.CRYSTAL_SAFE.tag = gIDDef.CRYSTAL_SAFE, gIDDef.CRYSTAL_SAFE, 4
	gIDDef.CRYSTAL_SAFE.title = i18n("common_text_312")
	;(#self.resCfg).tabsetArray, self.menuTag[5], gIDDef.CRYSTAL_SAFE.tag = self.menuTag, gIDDef.CRYSTAL_SAFE, 5
	;(#self.resCfg).callback = handler(self, self.onClickMenuBtns)
	self.fields.Tab_menu:initView(#self.resCfg)
end
function tradeBoardViewPanel:onClickMenuBtns(tag)
	self.menuTag = tag
	local isTabRes = self.menuTag == 2
	self.controllers.c2:setSelectedIndex(isTabRes and 1 or 0)
	self:updataScroll(true)
end
function tradeBoardViewPanel:updateResIndex(target, data)
	self.resType = data.index
	self.fields.List_res:setNumItems(#self.resCfg)
	self:updataScroll(true)
end
function tradeBoardViewPanel:updataScroll(needJump)
	local targetData
	if self.status == 1 then
		if self.menuTag == 1 then
			targetData = self.salesRoomData
		else
			local _ENV, ret = self.menuTag, self.menuTag
			for i, v in ipairs(self.salesRoomData) do
				if not ret[v.classify] then
					_ENV = ret[v.classify]
				end
				ret[v.classify] = ret[v.classify]
				table.insert(ret[v.classify], v)
			end
			self.dataByClassify = ret
			targetData = self.dataByClassify[self.menuTag - 1]
		end
	end
	self.fields.Text_resting:setVisible(false)
	if targetData and next(targetData) then
		local selfUid = gModuleMgr.getObject("gametop").playertop_:getPlayerID()
		table.sort(targetData, function(a, b)
			return a.shopID < b.shopID
		end)
		local _ENV, sortData = table.sort, table.sort
		if not self.isOnlyShowTrade then
			for k, v in ipairs(targetData) do
				if v._ownuid and v._ownuid ~= selfUid and v._uidlist[tostring(selfUid)] then
					if self.menuTag == 2 then
						local result = backpackltCtrl:getResult(v.item[1])
						if self.resType == 1 or SoraDisInList(result[1].id, self.resCfg[self.resType].resType) then
							table.insert(sortData, v)
						end
					else
						table.insert(sortData, v)
					end
				end
			end
		end
		if not self.isOnlyShowTrade then
			for k, v in ipairs(targetData) do
				if not v._ownuid or v._ownuid and v._ownuid ~= selfUid and not v._uidlist[tostring(selfUid)] then
					if self.menuTag == 2 then
						local result = backpackltCtrl:getResult(v.item[1])
						if self.resType == 1 or SoraDisInList(result[1].id, self.resCfg[self.resType].resType) then
							table.insert(sortData, v)
						end
					else
						table.insert(sortData, v)
					end
				end
			end
		end
		for k, v in ipairs(targetData) do
			if v._ownuid and v._ownuid == selfUid and v._uidlist[tostring(selfUid)] then
				if self.menuTag == 2 then
					local result = backpackltCtrl:getResult(v.item[1])
					if self.resType == 1 or SoraDisInList(result[1].id, self.resCfg[self.resType].resType) then
						table.insert(sortData, v)
					end
				else
					table.insert(sortData, v)
				end
			end
		end
		self.newTradeList = sortData
		self.fields.List_newTrade:setNumItems(#self.newTradeList)
		if #self.newTradeList == 0 and self.isOnlyShowTrade then
			self.fields.Text_resting:setVisible(true)
			self.fields.Text_resting:setString(i18n("common_text_4800"))
		end
		if needJump then
			self.fields.List_newTrade:jumpToTop()
		end
	else
		self.newTradeList, _ENV = gModuleMgr.getObject("gametop").playertop_:getPlayerID(), gModuleMgr.getObject("gametop").playertop_:getPlayerID()
		self.fields.List_newTrade:setNumItems(#self.newTradeList)
		if self.status == 1 then
			self.fields.Text_resting:setVisible(true)
			self.fields.Text_resting:setString(i18n("auction_text_32"))
		elseif #self.newTradeList == 0 and self.isOnlyShowTrade then
			self.fields.Text_resting:setVisible(true)
			self.fields.Text_resting:setString(i18n("common_text_4800"))
		end
	end
end
function tradeBoardViewPanel:onClickBtns(tag)
	self.tag = tag
	if self.tag == 1 then
		if self.isInit1 then
			salesRoomAgCtrl:sendInitMsg()
			self.isInit1 = false
		else
			self:initTradeBoardView()
		end
	elseif self.isInit2 then
		salesRoomAgCtrl:sendNewInitMsg()
		self.isInit2 = false
	else
		self:initNewTradeBoardView()
	end
end
function tradeBoardViewPanel:refreshRedPoint()
	local hint = salesRoomAgCtrl:getHint() or false
	self.fields.Tab_title:setBtnRedDot(2, hint)
	if self.hint then
		self.hint = hint
	end
	if self.hint then
		SoraDShowMsgBox(i18n("auction_text_35"))
		salesRoomAgCtrl:sendClearHintMsg()
	end
end
function tradeBoardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tradeList[index + 1], self.uid)
end
function tradeBoardViewPanel:onNewItemRenderer(index, obj)
	obj:initData(self.newTradeList[index + 1], self.uid)
end
function tradeBoardViewPanel:onResRenderer(index, obj)
	obj:initData(self.resCfg[index + 1], self.resType)
end
function tradeBoardViewPanel:initTradeBoardView()
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Button_record:setString(i18n("common_text_3368"))
	local timeTbl = salesRoomAgCtrl:getTimeAndStatus()
	if timeTbl == nil then
		return
	end
	local timeTick = math.max(0, timeTbl.time - serviceFunctions.systemTime())
	local langStr = "common_text_2818"
	if gSalesRoomStatus.WILL_END_STATUS == timeTbl.status then
		langStr = "common_text_607"
		self.fields.Text_resting:setVisible(false)
	elseif gSalesRoomStatus.WILL_BEGIN_STATUS == timeTbl.status then
		langStr = "common_text_2818"
		self.fields.Text_resting:setVisible(true)
	end
	self.fields.Text_time:setTimeLast(function(_tick)
		_ENV = nil
		;(nil).time = _tick
		return i18n(langStr, nil)
	end)
	self.fields.Text_time:beginTime(timeTick)
	self.fields.Text_returnGold:setString(salesRoomAgCtrl:getNotReceiveGold() or 0)
	self.tradeList = salesRoomAgCtrl:getAllItemsInfo()
	table.sort(self.tradeList, function(a, b)
		if a.ownUid and b.ownUid then
			return a.shopID < b.shopID
		elseif a.ownUid and not b.ownUid then
			return true
		elseif not a.ownUid and b.ownUid then
			return false
		else
			return a.shopID < b.shopID
		end
	end)
	self.fields.List_trade:setNumItems(#self.tradeList)
end
function tradeBoardViewPanel:initNewTradeBoardView()
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Button_record:setString(i18n("auction_text_33"))
	self:refreshBoreNum()
	if activityShowCtrl:isActivityOpen(self.activityID2) then
		local activityData = activityShowCtrl:getActivityData(self.activityID2)
		self.fields.Text_resting:setVisible(false)
		local begintime = os.date("!%Y-%m-%d", activityData.begintime)
		local endtime = os.date("!%Y-%m-%d", activityData.endtime)
		_ENV = i18n("auction_text_33")
		i18n("auction_text_33").time = string.format("%s----%s", begintime, endtime)
		self.fields.Text_activityTime:setString(i18n("common_text_1694", i18n("auction_text_33")))
		self.salesRoomData = salesRoomAgCtrl:getSalesRoomData()
		local activityData = activityShowCtrl:getActivityData(self.activityID2)
		local timestamp
		local timestr = ""
		self.status = self.salesRoomData[1] and self.salesRoomData[1]._status or 0
		if self.status == 1 then
			for i, v in ipairs(self.salesRoomData) do
				timestamp = timestamp or v._etime
				if v._etime and timestamp < v._etime then
					timestamp = v._etime
				end
			end
			self.fields.Tab_menu:setVisible(true)
		elseif self.status == 0 then
			for i, v in ipairs(self.salesRoomData) do
				timestamp = timestamp or v._btime
				if v._btime and timestamp > v._btime then
					timestamp = v._btime
				end
			end
			self.fields.Tab_menu:setVisible(false)
		else
			self.fields.Tab_menu:setVisible(false)
		end
		self.fields.Com_nextTurn:setVisible(false)
		self.fields.Check_tick:setVisible(true)
		self.fields.Text_tick:setVisible(true)
		self.fields.Text_leftTime:setVisible(true)
		print("timestamp,self.status=======", timestamp, self.status)
		if timestamp == nil then
			timestamp = activityData.endtime
			timestr = "auction_text_04"
			self.fields.Com_nextTurn:setVisible(true)
			self.fields.Check_tick:setVisible(false)
			self.fields.Text_tick:setVisible(false)
		elseif self.status == 1 then
			timestr = "auction_text_05"
		else
			timestr = "auction_text_03"
			self.fields.Text_leftTime:setVisible(false)
			self.fields.Com_nextTurn:setVisible(true)
			self.fields.Check_tick:setVisible(false)
			self.fields.Text_tick:setVisible(false)
		end
		local lefttime = timestamp - serviceFunctions.systemTime()
		if self.fields.Text_leftTime:isVisible() then
			self.fields.Text_leftTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n(timestr, nil)
			end)
			self.fields.Text_leftTime:beginTime(lefttime)
		end
		if self.fields.Com_nextTurn:isVisible() then
			self.fields.Com_nextTurn:initData(lefttime)
		end
		self:onClickMenuBtns(self.menuTag)
	else
		self.fields.Text_activityTime:setVisible(false)
		self.fields.Text_leftTime:setVisible(false)
		self.fields.Text_resting:setString(i18n("devilvalley_text_08") .. i18n("common_text_1036"))
		self.fields.Text_resting:setVisible(true)
		self.fields.Tab_menu:setVisible(false)
		self.fields.Com_nextTurn:setVisible(false)
		self.fields.Check_tick:setVisible(false)
		self.fields.Text_tick:setVisible(false)
	end
end
function tradeBoardViewPanel:updateNewTradeBoard()
	self:refreshBoreNum()
	self.fields.List_newTrade:setNumItems(#self.newTradeList)
end
function tradeBoardViewPanel:refreshBoreNum()
	local boreNum = salesRoomAgCtrl:getBoreNum()
	self.fields.Com_diamond:setString(string.formatnumberthousands(boreNum))
end
function tradeBoardViewPanel:closeMe()
	self:close()
end
function tradeBoardViewPanel:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID1) and not clientEventMgr.judgeIsOpen(self.activityID2) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	elseif clientEventMgr.judgeIsOpen(self.activityID2) and self.tag == 1 then
		self.fields.Tab_title:setDefaultClick(2, 2)
	elseif clientEventMgr.judgeIsOpen(self.activityID1) and self.tag == 2 then
		self.fields.Tab_title:setDefaultClick(1, 1)
	end
end
function tradeBoardViewPanel:btnTickClick()
	SoraDPlaySound()
	self.isOnlyShowTrade = not self.isOnlyShowTrade
	self.fields.Check_tick:setSelected(self.isOnlyShowTrade)
	self:updataScroll(true)
end
function tradeBoardViewPanel:btnRecordClick()
	SoraDPlaySound()
	if self.tag == 1 then
		uiManager:show("tradeBoardMoneyView")
	elseif clientEventMgr.judgeIsOpen(self.activityID2, true) then
		salesRoomAgCtrl:sendNewSuccessLogMsg()
		uiManager:show("newTradeBoardSelfRecord")
	end
end
function tradeBoardViewPanel:btnHelpClick()
	SoraDPlaySound()
	if self.tag == 1 then
		_ENV = nil
		;(nil).content = i18n("common_text_2829")
		;(nil).title = i18n("common_text_2768")
		uiManager:show("RuleView", nil)
	else
		_ENV = nil
		;(nil).content = i18n("auction_text_01")
		;(nil).title = i18n("activity_name_174")
		uiManager:show("RuleView", nil)
	end
end
function tradeBoardViewPanel:getGiftInfo()
	_UPVALUE3_ = nil
	;(nil)[1] = 13508
	;(nil)[2] = 13509
	local (nil)[3], giftIDList = 13510, nil
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i, v in ipairs(giftIDList) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function tradeBoardViewPanel:btnDiamondClick()
	SoraDPlaySound()
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
		SoraDShowMsgTip(i18n("HeroVault_text_03"))
	end
end
return tradeBoardViewPanel
