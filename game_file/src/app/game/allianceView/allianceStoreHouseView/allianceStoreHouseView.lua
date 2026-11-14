local gametop = gModuleMgr.getObject("gametop")
local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local allianceStoreHouseView = class("allianceStoreHouseView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceStoreHouseView")
	end
	return target
end)
function allianceStoreHouseView:ctor()
	self:bindBtnClose()
	self.tabTag = 1
	self.tableSingle, _ENV, self.itemsData, _ENV, self.isInit = self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, true
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_storeHouse")
	self.ccs_title:setTitle(i18n("allitreas_title_01"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.Top_Node_btns = SoraDGetChildByName(self, "Top_Node_btns")
	self.Button_treasureList = SoraDGetChildByName(self, "Button_treasureList")
	self.Button_treasureList:setTitleText(i18n("allitreas_btn_01"))
	self.Button_treasureList:setTag(1)
	SoraDAutoSizeButtonText(self.Button_treasureList, cc.size(200, 70))
	self.Button_myTreasure = SoraDGetChildByName(self, "Button_myTreasure")
	self.Button_myTreasure:setTitleText(i18n("allitreas_btn_02"))
	self.Button_myTreasure:setTag(2)
	SoraDAutoSizeButtonText(self.Button_myTreasure, cc.size(200, 70))
	self.Button_helpList = SoraDGetChildByName(self, "Button_helpList")
	self.Button_helpList:setTitleText(i18n("allitreas_btn_03"))
	self.Button_helpList:setTag(3)
	SoraDAutoSizeButtonText(self.Button_helpList, cc.size(200, 70))
	self.Button_treasureList:addTouchEventListener(handler(self, self.onBtnClick))
	self.Button_myTreasure:addTouchEventListener(handler(self, self.onBtnClick))
	self.Button_helpList:addTouchEventListener(handler(self, self.onBtnClick))
	self.Button_FAQ = SoraDGetChildByName(self, "Button_FAQ")
	self.Button_FAQ:addTouchEventListener(handler(self, self.onBtnFAQClick))
	self.scroll = SoraDGetChildByName(self.Top_Node_btns, "Size_ScrollView_list")
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - 350))
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceStoreHouseSingle")
	self.Top_Node_bzList = SoraDGetChildByName(self, "Top_Node_bzList")
	self.Top_Node_mine = SoraDGetChildByName(self, "Top_Node_mine")
	self.Top_Node_helpList = SoraDGetChildByName(self, "Top_Node_helpList")
	self.Top_Node_bzList:setVisible(false)
	self.Top_Node_mine:setVisible(false)
	self.Top_Node_helpList:setVisible(false)
	self.Image_record = SoraDGetChildByName(self, "Image_record")
	self.Image_record:setScaleY(1.7)
	self.Image_41 = SoraDGetChildByName(self, "Image_41")
	self.Image_41:setScaleY(1.7)
	self.Text_join1hour = SoraDGetChildByName(self.Top_Node_btns, "Text_join1hour")
	self.Text_join1hour:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Top_Node_btns, "Text_time")
	self.Text_time:setVisible(false)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Bottom_Node:setVisible(false)
	local Button_record = SoraDGetChildByName(self.Bottom_Node, "Button_record")
	Button_record:setTitleText(i18n("common_text_836"))
	Button_record:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("allianceStoreHouseRecordView")
			local nType = 1
			if self.tabTag == 2 then
				nType = 1
			elseif self.tabTag == 3 then
				nType = 2
			end
			panel:setRecordType(nType)
			panel:show()
		end
	end)
	self:onBtnClick(self.Button_treasureList, ccui.TouchEventType.ended, true)
	self:refreshGreenPoint()
	SoraDPlaySound("uicontrol", 51)
end
function allianceStoreHouseView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_INIT_BACK", handler(self, self.showTreasureListView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH", handler(self, self.showTreasureListView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH", handler(self, self.showMyTreasureView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH", handler(self, self.showHelpListView))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.refreshGreenPoint))
end
function allianceStoreHouseView:gotoBtn(tag)
	if tag == 1 then
		self:onBtnClick(self.Button_treasureList, ccui.TouchEventType.ended, true)
	elseif tag == 2 then
		self:onBtnClick(self.Button_myTreasure, ccui.TouchEventType.ended, true)
	elseif tag == 3 then
		self:onBtnClick(self.Button_helpList, ccui.TouchEventType.ended, true)
	end
end
function allianceStoreHouseView:updateTabBtns()
	_UPVALUE3_ = nil
	;(nil)[1] = self.Button_treasureList
	;(nil)[2] = self.Button_myTreasure
	local (nil)[3], btns = self.Button_helpList, nil
	for k, v in pairs(btns) do
		if self.tabTag ~= k then
			v:setBright(false)
			v:setTitleColor(cc.c3b(144, 132, 97))
			v:setTouchEnabled(true)
		else
			v:setBright(true)
			v:setTitleColor(cc.c3b(255, 245, 176))
			v:setTouchEnabled(false)
		end
	end
end
function allianceStoreHouseView:initViewByTag()
	self.itemsData, _ENV = nil, nil
	if self.tabTag == 1 then
		if self.isInit then
			SoraDShowLoading(self)
			allianceTreasureCtrl:reqInitData()
			self.isInit = false
		else
			self:showTreasureListView()
		end
	elseif self.tabTag == 2 then
		self:showMyTreasureView()
	elseif self.tabTag == 3 then
		self:showHelpListView()
	end
end
function allianceStoreHouseView:onBtnClick(target, event, isNoSound)
	if event == ccui.TouchEventType.ended then
		if not isNoSound then
			SoraDPlaySound()
		end
		self.tabTag = target:getTag()
		self:updateTabBtns()
		self:initViewByTag()
		self.scroll:jumpToTop()
	end
end
function allianceStoreHouseView:refreshGreenPoint()
	local green_mine = self.Button_myTreasure:getChildByName("Sprite_green")
	local mine_num = green_mine:getChildByName("Text_num")
	local green_help = self.Button_helpList:getChildByName("Sprite_green")
	local help_num = green_help:getChildByName("Text_num")
	local mineNum = allianceTreasureCtrl:getDigRewardCount()
	local helpNum = allianceTreasureCtrl:getHelpRewardCount()
	if 0 < mineNum then
		green_mine:setVisible(true)
		mine_num:setString(mineNum)
	else
		green_mine:setVisible(false)
	end
	if 0 < helpNum then
		green_help:setVisible(true)
		help_num:setString(helpNum)
	else
		green_help:setVisible(false)
	end
end
function allianceStoreHouseView:showTreasureListView(target, data)
	SoraDCloseLoading(self)
	if self.tabTag ~= 1 then
		return
	end
	local isAct = false
	local isFree
	if data and data.msg == "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH" then
		if data.isRefresh then
			isAct = true
		end
		if data.forceFree then
			isFree = true
		end
	end
	self.Top_Node_bzList:setVisible(true)
	self.Top_Node_mine:setVisible(false)
	self.Top_Node_helpList:setVisible(false)
	self.Bottom_Node:setVisible(false)
	local Node_tips = SoraDGetChildByName(self.Top_Node_bzList, "Node_tips")
	local Node_none = SoraDGetChildByName(self.Top_Node_bzList, "Node_none")
	local Bottom_node = SoraDGetChildByName(self.Top_Node_bzList, "Bottom_node")
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		Node_tips:setVisible(false)
		Node_none:setVisible(false)
		self.scroll:setVisible(false)
		Bottom_node:setVisible(false)
		self.Text_join1hour:setVisible(true)
		self.Text_join1hour:setString(i18n("allitreas_text_23"))
		self.Text_time:setVisible(true)
		self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
		self.Text_time:beginTime(left1hourTime)
	else
		self.Text_join1hour:setVisible(false)
		self.Text_time:setVisible(false)
		Bottom_node:setVisible(true)
		local chance = allianceTreasureCtrl:getLeftChance()
		Node_tips:setVisible(true)
		local Node_chance = SoraDGetChildByName(Node_tips, "Node_chance")
		local Text_chance = SoraDGetChildByName(Node_chance, "Text_chance")
		_ENV = i18n("allitreas_text_23")
		i18n("allitreas_text_23").num = chance
		Text_chance:setString(i18n("allitreas_text_08", i18n("allitreas_text_23")))
		local Text_freeTip = SoraDGetChildByName(Node_chance, "Text_freeTip")
		if 0 < chance then
			local isDigging = allianceTreasureCtrl:isDigging()
			if isDigging then
				local leftTime = allianceTreasureCtrl:getNextFreeTime()
				if 0 < leftTime then
					_ENV = i18n("allitreas_text_08", i18n("allitreas_text_23"))
					i18n("allitreas_text_08", i18n("allitreas_text_23")).time = SoraDConvertSecondToString(leftTime)
					Text_freeTip:setString(i18n("allitreas_text_10", i18n("allitreas_text_08", i18n("allitreas_text_23"))))
				else
					Text_freeTip:setString(i18n("allitreas_text_09"))
				end
				if self.nextAutoTimer == nil and 0 < leftTime then
					self.nextAutoTimer = SoradCreateTimer(self, function(dt)
						if leftTime <= 0 then
							SoraDManagerRemoveTimer(self, self.nextAutoTimer)
							self.nextAutoTimer = nil
							Text_freeTip:setString(i18n("allitreas_text_09"))
							leftTime = Text_freeTip
							Text_freeTip.msg = "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH"
							Text_freeTip.forceFree = true
							SoraDSendMessage(Text_freeTip)
						else
							leftTime = i18n("allitreas_text_09")
							i18n("allitreas_text_09").time = SoraDConvertSecondToString(leftTime)
							Text_freeTip:setString(i18n("allitreas_text_10", i18n("allitreas_text_09")))
						end
					end)
				end
			else
				if self.nextAutoTimer then
					SoraDManagerRemoveTimer(self, self.nextAutoTimer)
					self.nextAutoTimer = nil
				end
				Text_freeTip:setString(i18n("allitreas_text_09"))
			end
		else
			if self.nextAutoTimer then
				SoraDManagerRemoveTimer(self, self.nextAutoTimer)
				self.nextAutoTimer = nil
			end
			Text_freeTip:setString("")
		end
		SoraDToCenter(Node_chance, 5)
		local Text_tips = SoraDGetChildByName(Node_tips, "Text_tips")
		Text_tips:setString(i18n("allitreas_text_11"))
		Bottom_node:setPositionY(-self.Top_Node_bzList:getPositionY())
		local Text_autoFreshTime = SoraDGetChildByName(Bottom_node, "Text_autoFreshTime")
		local nextAutoTime = allianceTreasureCtrl:getNextAutoRefreshTime()
		Text_autoFreshTime:setVisible(0 < nextAutoTime)
		if 0 < nextAutoTime and self.autoTimer == nil then
			_ENV = i18n("allitreas_text_11")
			i18n("allitreas_text_11").time = SoraDConvertSecondToString(nextAutoTime)
			Text_autoFreshTime:setString(i18n("allitreas_text_12", i18n("allitreas_text_11")))
			self.autoTimer = SoradCreateTimer(self, function(dt)
				if nextAutoTime <= 0 then
					SoraDManagerRemoveTimer(self, self.autoTimer)
					self.autoTimer = nil
					Text_autoFreshTime:setVisible(false)
				else
					nextAutoTime = nil
					;(nil).time = SoraDConvertSecondToString(nextAutoTime)
					Text_autoFreshTime:setString(i18n("allitreas_text_12", nil))
				end
			end)
		end
		local Button_fresh = SoraDGetChildByName(Bottom_node, "Button_fresh")
		local Node_info = SoraDGetChildByName(Button_fresh, "Node_info")
		local Node_gold = SoraDGetChildByName(Button_fresh, "Node_gold")
		local refreshGold = allianceTreasureCtrl:getRefreshCostGold()
		if 0 < chance then
			Button_fresh:setBright(true)
			Button_fresh:setTouchEnabled(true)
			if 0 < refreshGold then
				Node_info:setVisible(true)
				Button_fresh:setTitleText("")
				local Text_refresh = SoraDGetChildByName(Node_info, "Text_refresh")
				Text_refresh:setString(i18n("allitreas_btn_06"))
				local Text_gold = SoraDGetChildByName(Node_info, "Text_gold")
				Text_gold:setString(refreshGold)
				SoraDToCenter(Node_gold)
			else
				Node_info:setVisible(false)
				Button_fresh:setTitleText(i18n("allitreas_btn_06"))
			end
		else
			Button_fresh:setTitleText(i18n("allitreas_btn_06"))
			Node_info:setVisible(false)
			Button_fresh:setBright(false)
			Button_fresh:setTouchEnabled(false)
		end
		Button_fresh:addTouchEventListener(handler(self, self.onBtnRefreshClick))
		local btnStatus, digGold = allianceTreasureCtrl:getDigBtnStatus()
		if isFree then
			btnStatus = gTreasureBtnStatus.FREE
			isFree = nil
		end
		_ENV = gTreasureBtnStatus
		_ENV = handler(self, self.onBtnRefreshClick)
		handler(self, self.onBtnRefreshClick).text = i18n("allitreas_btn_04")
		handler(self, self.onBtnRefreshClick).showStyle = 1
		gTreasureBtnStatus[gTreasureBtnStatus.FREE], handler(self, self.onBtnRefreshClick).handle = handler(self, self.onBtnRefreshClick)
		_ENV = handler(self, self.onBtnRefreshClick)
		handler(self, self.onBtnRefreshClick).text = i18n("allitreas_btn_05")
		handler(self, self.onBtnRefreshClick).showStyle = 2
		handler(self, self.onBtnRefreshClick).gold = digGold
		gTreasureBtnStatus[gTreasureBtnStatus.COST_GOLD], handler(self, self.onBtnRefreshClick).handle = handler(self, self.onBtnRefreshClick)
		_ENV = handler(self, self.onBtnRefreshClick)
		handler(self, self.onBtnRefreshClick).text = i18n("allitreas_btn_05")
		gTreasureBtnStatus[gTreasureBtnStatus.UNDIG], handler(self, self.onBtnRefreshClick).showStyle = handler(self, self.onBtnRefreshClick)
		local btnVarConfig = gTreasureBtnStatus
		local refreshSingles = function()
			self.tableSingle, self, self.itemsData = allianceTreasureCtrl:getTreasureList(), allianceTreasureCtrl:getTreasureList(), allianceTreasureCtrl:getTreasureList()
			if table.nums(self.itemsData) > 0 then
				Node_none:setVisible(false)
				self.scroll:setVisible(true)
				local num = table.nums(self.itemsData)
				for k, v in ipairs(self.itemsData) do
					self = nil
					;(nil).data = v
					;(nil).tipText = v.openTime
					;(nil).btnStyle = btnVarConfig[btnStatus].showStyle
					;(nil).text = btnVarConfig[btnStatus].text
					;(nil).gold = btnVarConfig[btnStatus].gold
					local (nil).handle, data = btnVarConfig[btnStatus].handle, nil
					self = nil
					;(nil).style = 1
					self.tableSingle[k], (nil).data = nil, data
				end
				self:updateScrollView()
				if isAct then
					for k, v in ipairs(self.scroll:getAllChildren()) do
						if v.point then
							v.point:doShowAction()
						end
					end
				end
			else
				Node_none:setVisible(true)
				self.scroll:setVisible(false)
				local Center_box = SoraDGetChildByName(Node_none, "Center_box")
				Center_box:setPositionY(-self.Top_Node_bzList:getPositionY() / 2 + 40)
				local Text_noTreasure = SoraDGetChildByName(Center_box, "Text_noTreasure")
				Text_noTreasure:setString(i18n("allitreas_text_27"))
			end
		end
		_UPVALUE2_ = i18n("allitreas_btn_05")
		i18n("allitreas_btn_05")[1] = cca.callFunc(function()
			if next(self.scroll:getAllChildren()) then
				for k, v in ipairs(self.scroll:getAllChildren()) do
					if v.point then
						v.point:doFilpAction()
					end
				end
			end
		end)
		i18n("allitreas_btn_05")[2] = cca.delay(0.3333333333333333)
		i18n("allitreas_btn_05")[3] = cca.callFunc(refreshSingles)
		i18n("allitreas_btn_05")[4] = cca.callFunc(refreshSingles)
		local seqRefresh = cca.seq((i18n("allitreas_btn_05")))
		seqRefresh:setTag(999)
		if #self.scroll:getAllChildren() > 0 and isAct then
			self:stopActionByTag(999)
			self:runAction(seqRefresh)
		else
			refreshSingles()
		end
	end
end
function allianceStoreHouseView:showMyTreasureView()
	SoraDCloseLoading(self)
	if self.tabTag ~= 2 then
		return
	end
	self.Top_Node_bzList:setVisible(false)
	self.Top_Node_mine:setVisible(true)
	self.Top_Node_helpList:setVisible(false)
	self.Bottom_Node:setVisible(true)
	local Text_mineTips = SoraDGetChildByName(self.Top_Node_mine, "Text_mineTips")
	local Node_none = SoraDGetChildByName(self.Top_Node_mine, "Node_none")
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		Text_mineTips:setVisible(false)
		self.Text_time:setVisible(false)
		Node_none:setVisible(false)
		self.scroll:setVisible(false)
		self.Text_join1hour:setVisible(true)
		self.Text_join1hour:setString(i18n("allitreas_text_23"))
	else
		Text_mineTips:setVisible(true)
		self.Text_join1hour:setVisible(false)
		Text_mineTips:setString(i18n("allitreas_text_13"))
		self.tableSingle, _ENV, self.itemsData = allianceTreasureCtrl:getDigList(), allianceTreasureCtrl:getDigList(), allianceTreasureCtrl:getDigList()
		if 0 < table.nums(self.itemsData) then
			Node_none:setVisible(false)
			self.scroll:setVisible(true)
			local num = table.nums(self.itemsData)
			_ENV = self.itemsData
			_ENV = i18n("allitreas_text_13")
			i18n("allitreas_text_13").text = i18n("allitreas_btn_07")
			i18n("allitreas_text_13").showStyle = 1
			self.itemsData[gTreasureDigStatus.CALL_HELP], i18n("allitreas_text_13").handle = i18n("allitreas_text_13")
			_ENV = i18n("allitreas_text_13")
			i18n("allitreas_text_13").text = i18n("allitreas_btn_07")
			self.itemsData[gTreasureDigStatus.CALLED_HELP], i18n("allitreas_text_13").showStyle = i18n("allitreas_text_13")
			_ENV = i18n("allitreas_text_13")
			i18n("allitreas_text_13").text = i18n("allitreas_btn_07")
			self.itemsData[gTreasureDigStatus.BE_HELPED], i18n("allitreas_text_13").showStyle = i18n("allitreas_text_13")
			_ENV = i18n("allitreas_text_13")
			i18n("allitreas_text_13").text = i18n("common_text_854")
			i18n("allitreas_text_13").showStyle = 1
			i18n("allitreas_text_13").isReward = true
			self.itemsData[gTreasureDigStatus.REWARD], i18n("allitreas_text_13").handle = i18n("allitreas_text_13")
			local btnVarConfig = self.itemsData
			for k, v in ipairs(self.itemsData) do
				local btnStatus, time = allianceTreasureCtrl:getDigedBtnStatus(v.index)
				_ENV = v.index
				v.index.data = v
				v.index.tipText = v.openTime
				v.index.btnStyle = btnVarConfig[btnStatus].showStyle
				v.index.text = btnVarConfig[btnStatus].text
				v.index.gold = 0
				v.index.isReward = btnVarConfig[btnStatus].isReward
				v.index.handle = btnVarConfig[btnStatus].handle
				v.index.status = btnStatus
				v.index.time = time
				local v.index.assistNickName, data = v.assistNickName, v.index
				_ENV = i18n("allitreas_text_13")
				i18n("allitreas_text_13").style = 2
				self.tableSingle[k], i18n("allitreas_text_13").data = i18n("allitreas_text_13")
			end
			self:updateScrollView()
		else
			Node_none:setVisible(true)
			self.scroll:setVisible(false)
			local Center_box = SoraDGetChildByName(Node_none, "Center_box")
			Center_box:setPositionY(-self.Top_Node_bzList:getPositionY() / 2 + 40)
			local Text_noTreasure = SoraDGetChildByName(Center_box, "Text_noTreasure")
			Text_noTreasure:setString(i18n("allitreas_text_25"))
			local Button_find = SoraDGetChildByName(Node_none, "Button_find")
			Button_find:setTitleText(i18n("allitreas_btn_08"))
			Button_find:addTouchEventListener(function(target, event)
				if event == ccui.TouchEventType.ended then
					self:onBtnClick(self.Button_treasureList, ccui.TouchEventType.ended)
				end
			end)
		end
	end
end
function allianceStoreHouseView:showHelpListView()
	SoraDCloseLoading(self)
	if self.tabTag ~= 3 then
		return
	end
	self.Top_Node_bzList:setVisible(false)
	self.Top_Node_mine:setVisible(false)
	self.Top_Node_helpList:setVisible(true)
	self.Bottom_Node:setVisible(true)
	local Node_tips = SoraDGetChildByName(self.Top_Node_helpList, "Node_tips")
	local Node_none = SoraDGetChildByName(self.Top_Node_helpList, "Node_none")
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		Node_tips:setVisible(false)
		self.Text_time:setVisible(false)
		Node_none:setVisible(false)
		self.scroll:setVisible(false)
		self.Text_join1hour:setVisible(true)
		self.Text_join1hour:setString(i18n("allitreas_text_22"))
	else
		Node_tips:setVisible(true)
		self.Text_join1hour:setVisible(false)
		local helpCount = allianceTreasureCtrl:getHelpCount()
		local Text_chance = SoraDGetChildByName(Node_tips, "Text_chance")
		_ENV = i18n("allitreas_text_22")
		i18n("allitreas_text_22").num = helpCount
		Text_chance:setString(i18n("allitreas_text_18", i18n("allitreas_text_22")))
		local Text_tips = SoraDGetChildByName(Node_tips, "Text_tips")
		Text_tips:setString(i18n("allitreas_text_31"))
		self.tableSingle, _ENV, self.itemsData = allianceTreasureCtrl:getHelpList(), allianceTreasureCtrl:getHelpList(), allianceTreasureCtrl:getHelpList()
		if next(self.itemsData) then
			Node_none:setVisible(false)
			self.scroll:setVisible(true)
			local num = table.nums(self.itemsData)
			_ENV = self.itemsData
			_ENV = i18n("allitreas_text_31")
			i18n("allitreas_text_31").text = i18n("common_text_854")
			i18n("allitreas_text_31").showStyle = 1
			i18n("allitreas_text_31").isReward = true
			self.itemsData[gTreasureHelpStatus.REWARD], i18n("allitreas_text_31").handle = i18n("allitreas_text_31")
			_ENV = i18n("allitreas_text_31")
			i18n("allitreas_text_31").text = i18n("common_text_037")
			i18n("allitreas_text_31").showStyle = 1
			self.itemsData[gTreasureHelpStatus.CAN_HELP], i18n("allitreas_text_31").handle = i18n("allitreas_text_31")
			_ENV = i18n("allitreas_text_31")
			i18n("allitreas_text_31").text = i18n("common_text_037")
			self.itemsData[gTreasureHelpStatus.CANNOT_HELP], i18n("allitreas_text_31").showStyle = i18n("allitreas_text_31")
			_ENV = i18n("allitreas_text_31")
			i18n("allitreas_text_31").text = i18n("common_text_018")
			i18n("allitreas_text_31").showStyle = 2
			i18n("allitreas_text_31").isReward = true
			self.itemsData[gTreasureHelpStatus.HELPED], i18n("allitreas_text_31").handle = i18n("allitreas_text_31")
			local btnVarConfig = self.itemsData
			for k, v in ipairs(self.itemsData) do
				local btnStatus, gold, openLeftTime, openTime = allianceTreasureCtrl:getHelpDigStatus(v.ownUid, v.index)
				local configData = btnVarConfig[btnStatus]
				_ENV = i18n("allitreas_text_31")
				i18n("allitreas_text_31").curTime = openLeftTime
				local i18n("allitreas_text_31").totalTime, timeData = openTime, i18n("allitreas_text_31")
				local time = v.openTime
				if btnStatus == gTreasureHelpStatus.HELPED then
					time = openLeftTime
				end
				_ENV = gTreasureHelpStatus.HELPED
				gTreasureHelpStatus.HELPED.data = v
				gTreasureHelpStatus.HELPED.btnStyle = configData.showStyle
				gTreasureHelpStatus.HELPED.text = configData.text
				gTreasureHelpStatus.HELPED.gold = gold
				gTreasureHelpStatus.HELPED.isReward = configData.isReward
				gTreasureHelpStatus.HELPED.timeData = timeData
				gTreasureHelpStatus.HELPED.ownUid = v.ownUid
				gTreasureHelpStatus.HELPED.avatar = v.avatar
				gTreasureHelpStatus.HELPED.headID = v.iconID
				gTreasureHelpStatus.HELPED.name = v.nickName
				gTreasureHelpStatus.HELPED.handle = btnVarConfig[btnStatus].handle
				gTreasureHelpStatus.HELPED.status = btnStatus
				local gTreasureHelpStatus.HELPED.time, data = time, gTreasureHelpStatus.HELPED
				_ENV = i18n("allitreas_text_31")
				i18n("allitreas_text_31").style = 3
				self.tableSingle[k], i18n("allitreas_text_31").data = i18n("allitreas_text_31")
			end
			self:updateScrollView()
		else
			Node_none:setVisible(true)
			self.scroll:setVisible(false)
			local Center_box = SoraDGetChildByName(Node_none, "Center_box")
			Center_box:setPositionY(-self.Top_Node_helpList:getPositionY() / 2 + 40)
			local Text_noTreasure = SoraDGetChildByName(Center_box, "Text_noTreasure")
			Text_noTreasure:setString(i18n("allitreas_text_26"))
			local Button_find = SoraDGetChildByName(Node_none, "Button_find")
			Button_find:setTitleText(i18n("allitreas_btn_08"))
			Button_find:addTouchEventListener(function(target, event)
				if event == ccui.TouchEventType.ended then
					self:onBtnClick(self.Button_treasureList, ccui.TouchEventType.ended)
				end
			end)
		end
	end
end
function allianceStoreHouseView:updateScrollView()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 235), self.tableSingle, 1, nil)
end
function allianceStoreHouseView:onBtnFAQClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_TREASURE)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_TREASURE)
		end
	end
end
function allianceStoreHouseView:onBtnRefreshClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local refreshGold = allianceTreasureCtrl:getRefreshCostGold()
		if SoraDEnoughGold(refreshGold) then
			if refreshGold == ALLIANCE_TREASURE_GOLD_REFRESH then
				_ENV = nil
				;(nil).num = refreshGold
				SoraDShowMsgBox(i18n("allitreas_text_29", nil), i18n("common_text_204"), nil, function(event)
					if event == MSGBOX_CALLBACK_YES then
						SoraDShowLoading(self)
						allianceTreasureCtrl:reqReFresh()
					end
				end)
			else
				SoraDShowLoading(self)
				allianceTreasureCtrl:reqReFresh()
			end
		end
	end
end
function allianceStoreHouseView:onBtnDigClick(data)
	local index = data.data.index
	local num = allianceTreasureCtrl:getDigRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_01"))
	else
		local btnStatus, digGold = allianceTreasureCtrl:getDigBtnStatus()
		if 0 < digGold then
			if SoraDEnoughGold(digGold) then
				allianceTreasureCtrl = i18n("alliance_treasure_tip_01")
				i18n("alliance_treasure_tip_01").num = digGold
				SoraDShowMsgBox(i18n("allitreas_text_30", i18n("alliance_treasure_tip_01")), i18n("common_text_204"), nil, function(event)
					if event == MSGBOX_CALLBACK_YES then
						SoraDShowLoading(self)
						allianceTreasureCtrl:reqDig(index)
					end
				end)
			end
		else
			SoraDShowLoading(self)
			allianceTreasureCtrl:reqDig(index)
		end
	end
end
function allianceStoreHouseView:onBtnCallHelpClick(data)
	SoraDShowLoading(self)
	local index = data.data.index
	allianceTreasureCtrl:reqCallHelp(index)
end
function allianceStoreHouseView:onBtnHelpOtherClick(data)
	local num = allianceTreasureCtrl:getHelpRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_02"))
	else
		SoraDShowLoading(self)
		allianceTreasureCtrl:reqHelpAlies(data.data.ownUid, data.data.index)
	end
end
function allianceStoreHouseView:onBtnHelpOtherByGoldClick(data)
	local num = allianceTreasureCtrl:getHelpRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_02"))
	else
		local btnStatus, gold, openLeftTime, openTime = allianceTreasureCtrl:getHelpDigStatus(data.data.ownUid, data.data.index)
		local realGold = math.floor(gold * openLeftTime / openTime)
		if realGold <= 0 then
			realGold = 1
		end
		if SoraDEnoughGold(realGold) then
			allianceTreasureCtrl = i18n("alliance_treasure_tip_02")
			i18n("alliance_treasure_tip_02").num = realGold
			local panel = SoraDShowMsgBox(i18n("allitreas_text_28", i18n("alliance_treasure_tip_02")), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					allianceTreasureCtrl:reqHelpAliesByGold(data.data.ownUid, data.data.index)
				end
			end)
			_ENV = nil
			;(nil).num = realGold
			allianceTreasureCtrl, (nil)[1] = "allitreas_text_28", "allitreas_text_28"
			;("allitreas_text_28").gold = gold
			;("allitreas_text_28").curTime = openLeftTime
			;("allitreas_text_28").totalTime = openTime
			panel:setTimerText(nil, "allitreas_text_28")
		end
	end
end
function allianceStoreHouseView:onBtnReceiveClick(data)
	SoraDShowLoading(self)
	local receiveType = 1
	if self.tabTag == 3 then
		receiveType = 2
	end
	allianceTreasureCtrl:reqReceive(receiveType, data.data.ownUid, data.data.index)
end
return allianceStoreHouseView
