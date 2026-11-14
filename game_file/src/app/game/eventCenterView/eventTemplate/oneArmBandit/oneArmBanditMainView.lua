local gametop = gModuleMgr.getObject("gametop")
local oneArmBanditCtrl = gametop.playertop_:getModule("oneArmBanditCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local GridScrollView = include("GridScrollView")
local slotMachineRewardRead = include("slotMachineRewardRead")
ONEARMBANDIT_SLOT_STOP_TIME = ONEARMBANDIT_SLOT_STOP_TIME or 0.3
ONEARMBANDIT_SLOT_INTERVAL_TIME = ONEARMBANDIT_SLOT_INTERVAL_TIME or 0.3
ONEARMBANDIT_SLOT_RUN_TIME = ONEARMBANDIT_SLOT_RUN_TIME or 0.2
ONEARMBANDIT_SLOT_DELAY_RUN_TIME = ONEARMBANDIT_SLOT_DELAY_RUN_TIME or 0.2
ONEARMBANDIT_LAMP_NORMAL_TIME = ONEARMBANDIT_LAMP_NORMAL_TIME or 0.3
ONEARMBANDIT_LAMP_SLOT_TIME = ONEARMBANDIT_LAMP_SLOT_TIME or 0.2
ONEARMBANDIT_COIN_ITEMID = 809401
ONEARMBANDIT_COIN_NEED_1 = 1
ONEARMBANDIT_COIN_NEED_5 = 5
local oneArmBanditMainView = class("oneArmBanditMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("oneArmBanditMainView")
	end
	return target
end)
function oneArmBanditMainView:onExitPanel()
	oneArmBanditCtrl:sendReqInfo(false)
end
function oneArmBanditMainView:closePanel(...)
	SoraCollectgarbage(self.__cname)
	SoraDRemoveAllAfterPanelFromManager(self)
end
function oneArmBanditMainView:ctor()
	self.isHideCurrentSceneView = true
	self.columnList, backpackCtrl, self.isRunning = nil, nil, false
	self.curShowGold = 0
	self.selfCoin = backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID)
	self.slotType = 1
	self.delayRecord = nil
	self.delayjackpot = nil
	self.jackpotItem = nil
	self.slotMarks, backpackCtrl, self.poolLock = backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID), backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID), false
	self:initWidget()
	self:addMessage()
	oneArmBanditCtrl:sendReqInfo(true)
	SoraDShowLoading(self)
end
function oneArmBanditMainView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_ONEARMBANDIT_REQ_INFO_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.slotData = oneArmBanditCtrl:getSlotData()
		self:initData()
		self:doCheat()
	end)
	SoraDAddMessage(self, "MESSAGE_ONEARMBANDIT_SLOT_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.lastSlotData = oneArmBanditCtrl:getLastSlotData()
		self:stopAllActions()
		local delay = ONEARMBANDIT_SLOT_DELAY_RUN_TIME
		self = nil
		;(nil)[1] = cca.delay(delay)
		;(nil)[2] = cca.callFunc(function(...)
			self:stopSlot()
		end)
		;(nil)[3] = cca.callFunc(function(...)
			self:stopSlot()
		end)
		self:runAction(cca.seq(nil))
	end)
	SoraDAddMessage(self, "MESSAGE_ONEARMBANDIT_NOTIFY_BACK", function(target, data)
		if data.poolChange then
			if not self.poolLock then
				self.slotData = oneArmBanditCtrl:getSlotData()
				local showGold = self.slotData.prizePool
				self.BitmapFontLabel_gold:runScoreAnimation(self.curShowGold, showGold, 0.5)
				self.curShowGold = showGold
			end
			if self.jackpotItem then
				self.jackpotItem.refreshTime()
			end
			self.scroll:refreshData()
		end
		if data.addRecord then
			local record = data.record
			if gametop.playertop_:getPlayerID() == record.uid then
				self.delayRecord = record
			else
				oneArmBanditCtrl:addRecord(record)
				self.slotData = oneArmBanditCtrl:getSlotData()
				self:addRecordItem()
			end
		end
		if data.addjackpot then
			local jackpot = data.jackpot
			if gametop.playertop_:getPlayerID() == jackpot.uid then
				self.delayjackpot = jackpot
			else
				oneArmBanditCtrl:addJackpot(jackpot)
				self.slotData = oneArmBanditCtrl:getSlotData()
				self:addJackpot()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function()
		if not self.poolLock then
			self.selfCoin = backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID)
			self.Text_coin_num:setString(self.selfCoin)
		end
	end)
end
function oneArmBanditMainView:initWidget()
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.BitmapFontLabel_gold = SoraDGetChildByName(self.Top_Node, "BitmapFontLabel_gold")
	self.BitmapFontLabel_gold = SoraDCreateScoreLabel(self.BitmapFontLabel_gold, true)
	self.BitmapFontLabel_gold:setString(string.formatnumberthousands(self.curShowGold))
	GridScrollView = string.formatnumberthousands(self.curShowGold)
	string.formatnumberthousands(self.curShowGold)[1] = "Node_effect_up"
	self.Node_effect_up = SoraDGetChildByFullPath(self.Top_Node, string.formatnumberthousands(self.curShowGold))
	GridScrollView = string.formatnumberthousands(self.curShowGold)
	string.formatnumberthousands(self.curShowGold)[1] = "Node_effect_down"
	self.Node_effect_down = SoraDGetChildByFullPath(self.Top_Node, string.formatnumberthousands(self.curShowGold))
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_oab")
	self.ccs_title:setTitle(i18n("slot_machine_text_01"))
	GridScrollView = i18n("slot_machine_text_01")
	i18n("slot_machine_text_01")[1] = "Button_help"
	self.btnHelp = SoraDGetChildByFullPath(self.ccs_title, i18n("slot_machine_text_01"))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpCallback))
	_UPVALUE2_ = handler(self, self.btnHelpCallback)
	handler(self, self.btnHelpCallback)[1] = "Node_coin"
	handler(self, self.btnHelpCallback)[2] = "Button_coin"
	self.Button_coin = SoraDGetChildByFullPath(self.ccs_title, handler(self, self.btnHelpCallback))
	self.Button_coin:addTouchEventListener(handler(self, self.btnCoinCallback))
	_UPVALUE2_ = handler(self, self.btnCoinCallback)
	handler(self, self.btnCoinCallback)[1] = "Node_coin"
	handler(self, self.btnCoinCallback)[2] = "Text_coin_num"
	self.Text_coin_num = SoraDGetChildByFullPath(self.ccs_title, handler(self, self.btnCoinCallback))
	self.Text_coin_num:setString(self.selfCoin)
	GridScrollView = self.selfCoin
	self.selfCoin[1] = "Panel_show_cut"
	self.Panel_show = SoraDGetChildByFullPath(self.Top_Node, self.selfCoin)
	GridScrollView = self.selfCoin
	self.selfCoin[1] = "Image_show_up"
	local Image_show_up = SoraDGetChildByFullPath(self.Panel_show, self.selfCoin)
	Image_show_up:setLocalZOrder(10)
	_UPVALUE2_ = 10
	;(10)[1] = "Node_button"
	;(10)[2] = "Image_btn_l_1"
	self.Image_btn_l_1 = SoraDGetChildByFullPath(self.Top_Node, 10)
	self.Image_btn_l_1:setVisible(false)
	_UPVALUE2_ = false
	;(false)[1] = "Node_button"
	;(false)[2] = "Image_btn_l_2"
	self.Image_btn_l_2 = SoraDGetChildByFullPath(self.Top_Node, false)
	self.Image_btn_l_2:setTouchEnabled(true)
	self.Image_btn_l_2:addTouchEventListener(handler(self, self.btnSoltLeftCallback))
	_UPVALUE2_ = handler(self, self.btnSoltLeftCallback)
	handler(self, self.btnSoltLeftCallback)[1] = "Node_button"
	handler(self, self.btnSoltLeftCallback)[2] = "Text_coin_num_l"
	SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnSoltLeftCallback)):setString(ONEARMBANDIT_COIN_NEED_1)
	_UPVALUE2_ = ONEARMBANDIT_COIN_NEED_1
	ONEARMBANDIT_COIN_NEED_1[1] = "Node_button"
	ONEARMBANDIT_COIN_NEED_1[2] = "Text_coin_num_l_0"
	local labCoinDes = SoraDGetChildByFullPath(self.Top_Node, ONEARMBANDIT_COIN_NEED_1)
	labCoinDes:setString(i18n("slot_machine_text_12"))
	if labCoinDes:getContentSize().width > 130 then
		labCoinDes:setScale(130 / labCoinDes:getContentSize().width)
	end
	_UPVALUE2_ = 130 / labCoinDes:getContentSize().width
	;(130 / labCoinDes:getContentSize().width)[1] = "Node_button"
	;(130 / labCoinDes:getContentSize().width)[2] = "Image_btn_r_1"
	self.Image_btn_r_1 = SoraDGetChildByFullPath(self.Top_Node, 130 / labCoinDes:getContentSize().width)
	self.Image_btn_r_1:setVisible(false)
	_UPVALUE2_ = false
	;(false)[1] = "Node_button"
	;(false)[2] = "Image_btn_r_2"
	self.Image_btn_r_2 = SoraDGetChildByFullPath(self.Top_Node, false)
	self.Image_btn_r_2:setTouchEnabled(true)
	self.Image_btn_r_2:addTouchEventListener(handler(self, self.btnSoltRightCallback))
	_UPVALUE2_ = handler(self, self.btnSoltRightCallback)
	handler(self, self.btnSoltRightCallback)[1] = "Node_button"
	handler(self, self.btnSoltRightCallback)[2] = "Text_coin_num_r"
	SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnSoltRightCallback)):setString(ONEARMBANDIT_COIN_NEED_5)
	_UPVALUE2_ = ONEARMBANDIT_COIN_NEED_5
	ONEARMBANDIT_COIN_NEED_5[1] = "Node_button"
	ONEARMBANDIT_COIN_NEED_5[2] = "Text_coin_num_r_0"
	local labCoinDes = SoraDGetChildByFullPath(self.Top_Node, ONEARMBANDIT_COIN_NEED_5)
	labCoinDes:setString(i18n("slot_machine_text_12"))
	if labCoinDes:getContentSize().width > 130 then
		labCoinDes:setScale(130 / labCoinDes:getContentSize().width)
	end
	_UPVALUE2_ = 130 / labCoinDes:getContentSize().width
	;(130 / labCoinDes:getContentSize().width)[1] = "Node_record"
	;(130 / labCoinDes:getContentSize().width)[2] = "Sprite_record_r"
	local Sprite_record_r = SoraDGetChildByFullPath(self.Top_Node, 130 / labCoinDes:getContentSize().width)
	_UPVALUE2_ = "Node_record"
	;("Node_record")[1] = "Node_record"
	;("Node_record")[2] = "Sprite_record_l"
	local Sprite_record_l = SoraDGetChildByFullPath(self.Top_Node, "Node_record")
	_UPVALUE2_ = "Node_record"
	;("Node_record")[1] = "Node_record"
	;("Node_record")[2] = "Text_record"
	local Text_record = SoraDGetChildByFullPath(self.Top_Node, "Node_record")
	Text_record:setString(i18n("slot_machine_text_11"))
	_UPVALUE2_ = i18n("slot_machine_text_11")
	i18n("slot_machine_text_11")[1] = "Node_record"
	i18n("slot_machine_text_11")[2] = "Text_no_record"
	self.Text_no_record = SoraDGetChildByFullPath(self.Top_Node, i18n("slot_machine_text_11"))
	self.Text_no_record:setString(i18n("common_text_1464"))
	self.Text_no_record:setVisible(false)
	_UPVALUE2_ = false
	;(false)[1] = "Node_record"
	;(false)[2] = "Button_rank"
	self.Button_rank = SoraDGetChildByFullPath(self.Top_Node, false)
	self.Button_rank:addTouchEventListener(handler(self, self.btnRankCallback))
	Sprite_record_r:setPositionX(display.cx + Text_record:getContentSize().width / 2 + 30)
	Sprite_record_l:setPositionX(display.cx - Text_record:getContentSize().width / 2 - 30)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.pannel_item = SoraDGetChildByName(self, "pannel_item")
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll_records")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Top_Size_scroll_records"
	;("Top_Size_scroll_records").col = 1
	;("Top_Size_scroll_records").left = 30
	self.scroll:init("Top_Size_scroll_records", 0, handler(self, self.createCell), handler(self, self.updateCell))
	self:initSingleColumn()
	self:createRunLamp()
	self:setSlotEffect()
end
function oneArmBanditMainView:createRunLamp(...)
	local runLamp = SoraDCreatePanel("oneArmBanditRunLamp")
	self.runLamp = runLamp
	runLamp:addTo(self.Top_Node)
	self.runLamp:runLampNormal()
end
function oneArmBanditMainView:btnHelpCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	SoraDRemoveAllAfterPanelFromManager(self, true)
	SoraDCreatePanel("oneArmBanditRuleDesPopView"):show()
end
function oneArmBanditMainView:btnCoinCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	SoraDRemoveAllAfterPanelFromManager(self, true)
	_ENV = nil
	_ENV, (nil).itemType = gItemType.LUCKY_COIN, gItemType.LUCKY_COIN
	;(nil).troopData, gItemType.LUCKY_COIN.itemID = gItemType.LUCKY_COIN, ONEARMBANDIT_COIN_ITEMID
	uiManager:show("PropBuyView", nil)
end
function oneArmBanditMainView:btnSoltLeftCallback(button, type)
	if type == ccui.TouchEventType.ended then
		self.Image_btn_l_1:setVisible(false)
		SoraDPlaySound()
		if self.isRunning then
			return
		end
		if not self:checkInActivityTime() then
			SoraDShowMsgTip(i18n("common_text_1859"))
			return
		end
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if self.selfCoin < ONEARMBANDIT_COIN_NEED_1 then
			local panel = SoraDCreatePanel("oneArmBanditBuyPopView")
			_ENV = i18n("common_text_1859")
			i18n("common_text_1859").slotType = 1
			i18n("common_text_1859").selfCoin = self.selfCoin
			i18n("common_text_1859").handle = handler(self, self.sendReqSolt)
			panel:initData(i18n("common_text_1859"))
			panel:show()
		else
			self:sendReqSolt(1, false)
		end
	elseif type == ccui.TouchEventType.canceled then
		self.Image_btn_l_1:setVisible(false)
	else
		self.Image_btn_l_1:setVisible(true)
	end
end
function oneArmBanditMainView:btnSoltRightCallback(button, type)
	if type == ccui.TouchEventType.ended then
		self.Image_btn_r_1:setVisible(false)
		SoraDPlaySound()
		if self.isRunning then
			return
		end
		if not self:checkInActivityTime() then
			SoraDShowMsgTip(i18n("common_text_1859"))
			return
		end
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if self.selfCoin < ONEARMBANDIT_COIN_NEED_5 then
			local panel = SoraDCreatePanel("oneArmBanditBuyPopView")
			_ENV = i18n("common_text_1859")
			i18n("common_text_1859").slotType = 2
			i18n("common_text_1859").selfCoin = self.selfCoin
			i18n("common_text_1859").handle = handler(self, self.sendReqSolt)
			panel:initData(i18n("common_text_1859"))
			panel:show()
		else
			self:sendReqSolt(2, false)
		end
	elseif type == ccui.TouchEventType.canceled then
		self.Image_btn_r_1:setVisible(false)
	else
		self.Image_btn_r_1:setVisible(true)
	end
end
function oneArmBanditMainView:btnRankCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	SoraDRemoveAllAfterPanelFromManager(self, true)
	SoraDCreatePanel("oneArmBanditRankPopView"):show()
end
function oneArmBanditMainView:sendReqSolt(slotType, useGold)
	self.slotType = slotType
	SoraDShowLoading(self)
	oneArmBanditCtrl:sendReqSlot(slotType)
	self:runSlot()
	self.poolLock = true
	local needCoin = 0
	if slotType == 1 then
		needCoin = ONEARMBANDIT_COIN_NEED_1
	elseif slotType == 2 then
		needCoin = ONEARMBANDIT_COIN_NEED_5
	end
	self.selfCoin = math.max(0, self.selfCoin - needCoin)
	self.Text_coin_num:setString(self.selfCoin)
end
function oneArmBanditMainView:initSingleColumn()
	local singleW = 108
	local size = self.Panel_show:getContentSize()
	for i = 1, 5 do
		local singleColumn = SoraDCreatePanel("oneArmBanditSingleList")
		singleColumn:addTo(self.Panel_show, 5)
		singleColumn:setPosition(cc.p(size.width / 2 + (i - 3) * singleW, -40))
		singleColumn:setColumn(i)
		self[string.format("singleColumn_%d", i)] = singleColumn
		table.insert(self.columnList, singleColumn)
	end
end
function oneArmBanditMainView:initData(data)
	local showGold = self.slotData.prizePool or 0
	self.BitmapFontLabel_gold:setString(string.formatnumberthousands(showGold))
	self.curShowGold = showGold
	self:addJackpot()
	self:initScroll()
end
function oneArmBanditMainView:addJackpot()
	local info = self.slotData.jackpot
	if info and next(info) then
		if not self.jackpotItem then
			local item = self:createRecordItem()
			self.jackpotItem = item
			item:addTo(self.Bottom_Node)
			item:setPosition(50, 8)
			self.Bottom_Node:setVisible(true)
			self:setJackpotEffect()
			local sSize = self.scroll:getContentSize()
			self.scroll:setContentSize(cc.size(sSize.width, sSize.height - 89))
		end
		_ENV = self.scroll:getContentSize()
		self.scroll:getContentSize().itemType = 1
		self.scroll:getContentSize().info = info
		self.jackpotItem.initData((self.scroll:getContentSize()))
	end
end
function oneArmBanditMainView:initScroll()
	self.recordTotal = math.min(50, #self.slotData.winners)
	if self.recordTotal <= 0 then
		self.Text_no_record:setVisible(true)
		return
	else
		self.Text_no_record:setVisible(false)
	end
	self.Text_no_record:setVisible(false)
	self.scroll:updateNum(self.recordTotal)
end
function oneArmBanditMainView:createCell()
	local cell = self:createRecordItem()
	return cell
end
function oneArmBanditMainView:updateCell(panel, i)
	local recordIndex = self.recordTotal - i + 1
	local info = self.slotData.winners[recordIndex]
	_UPVALUE0_ = nil
	;(nil).itemType = 2
	;(nil).index = i
	;(nil).info = info
	panel.initData(nil)
end
function oneArmBanditMainView:createRecordItem()
	local item = self.pannel_item:clone()
	gametop = nil
	;(nil)[1] = "img_item_bg"
	item.imgBg = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "Image_head"
	item.imgHead = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_item_name"
	item.labName = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_item_time"
	item.labTime = SoraDGetChildByFullPath(item, nil)
	gametop = nil
	;(nil)[1] = "text_gold_num"
	item.labGold = SoraDGetChildByFullPath(item, nil)
	function item.initData(data)
		if data.index then
			item.index = data.index
			if item.index % 2 == 0 then
				item.imgBg:setVisible(false)
			else
				item.imgBg:setVisible(true)
			end
		end
		if data.itemType then
			local itemType = data.itemType
			if itemType == 1 then
				item.labName:setColor(cc.c3b(200, 155, 100))
				item.labTime:setColor(cc.c3b(175, 175, 175))
				item.imgBg:setVisible(false)
			else
				item.labName:setColor(cc.c3b(200, 170, 150))
				item.labTime:setColor(cc.c3b(175, 175, 175))
			end
		end
		local info = data.info
		if not info then
			return
		end
		item.info = info
		if info.uid and info.uid == gametop.playertop_:getPlayerID() then
			item.labName:setColor(cc.c3b(220, 145, 90))
			item.labTime:setColor(cc.c3b(255, 210, 70))
		end
		if info.kid and info.name then
			local suffix
			if info.abbr and info.abbr ~= "" then
				item = cc.c3b(255, 210, 70)
				cc.c3b(255, 210, 70).abbr = info.abbr
				cc.c3b(255, 210, 70).name = info.name
				suffix = i18n("common_text_186", cc.c3b(255, 210, 70))
			else
				suffix = info.name
			end
			local str = string.format("%s#%d", suffix, info.kid)
			item.labName:setString(str)
		end
		if info.gold then
			item.labGold:setString(string.formatnumberthousands(info.gold))
		end
		if info.imageId and info.avatar then
			SoraDGetHeadFromManager(item.imgHead, info.imageId, info.avatar)
		end
		item.refreshTime()
	end
	function item.refreshTime()
		if item.info and item.info.time then
			local second = serviceFunctions.systemTime() - item.info.time
			second = math.max(0, second)
			item.labTime:setString(SoraDConverSecondToDate(second, false, true))
		end
	end
	return item
end
function oneArmBanditMainView:addRecordItem(count)
	count = count or 1
	self.recordTotal = math.min(50, self.recordTotal + count)
	self.Text_no_record:setVisible(false)
	self.scroll:updateNum(self.recordTotal)
end
function oneArmBanditMainView:runSlot(...)
	self.isRunning = true
	for i, v in ipairs(self.columnList) do
		v:runSlot()
	end
	self.runLamp:runLampSlot()
	for i, v in ipairs(self.effect_spList) do
		v:setVisible(false)
	end
end
function oneArmBanditMainView:stopSlot(...)
	if not self.isRunning then
		return
	end
	local results, marks = slotMachineRewardRead.getFinalShowList(self.lastSlotData.id)
	self.slotMarks = marks
	local delay = ONEARMBANDIT_SLOT_INTERVAL_TIME
	for i, v in ipairs(self.columnList) do
		v:setFinalShow(results[i])
		v:setHandle(handler(self, self.stopColumnCallback))
		_ENV = handler(self, self.stopColumnCallback)
		handler(self, self.stopColumnCallback)[1] = cca.delay(i * delay)
		handler(self, self.stopColumnCallback)[2] = cca.callFunc(function(...)
			v:stopSlot()
		end)
		handler(self, self.stopColumnCallback)[3] = cca.callFunc(function(...)
			v:stopSlot()
		end)
		v:runAction(cca.seq(handler(self, self.stopColumnCallback)))
	end
end
function oneArmBanditMainView:stopColumnCallback(column)
	SoraDPlaySound("slotmachine", 1)
	local mark = self.slotMarks[column]
	if mark then
		if mark == 2 then
			if column == 5 then
				for i, v in ipairs(self.effect_spList) do
					v:setVisible(true)
				end
			end
		elseif 3 <= column then
			local count = 0
			for i = 1, column do
				if self.slotMarks[i] then
					count = count + 1
				end
			end
			if 3 <= count then
				for i = 1, column do
					if self.slotMarks[i] then
						self.effect_spList[i]:setVisible(true)
					end
				end
			end
		end
	end
	if column == 5 then
		self:showReardsView()
	end
end
function oneArmBanditMainView:showReardsView(...)
	if self.delayRecord then
		oneArmBanditCtrl:addRecord(self.delayRecord)
		self.slotData = oneArmBanditCtrl:getSlotData()
		self:addRecordItem()
		self.delayRecord = nil
		self.scroll:scrollToIndex(1)
	end
	if self.delayjackpot then
		oneArmBanditCtrl:addJackpot(self.delayjackpot)
		self.slotData = oneArmBanditCtrl:getSlotData()
		self:addJackpot()
		self.delayjackpot = nil
	end
	self.runLamp:runLampNormal()
	if self.poolLock then
		self.poolLock = false
		self.slotData = oneArmBanditCtrl:getSlotData()
		local showGold = self.slotData.prizePool
		self.BitmapFontLabel_gold:runScoreAnimation(self.curShowGold, showGold, 0.5)
		self.curShowGold = showGold
		self.selfCoin = backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID)
		self.Text_coin_num:setString(self.selfCoin)
	end
	local showType = slotMachineRewardRead.getShowType(self.lastSlotData.id)
	if showType == 1 then
		self:setShowEffect()
	end
	backpackCtrl = showGold
	showGold[1] = cca.delay(0.8)
	showGold[2] = cca.callFunc(function(...)
		self.isRunning = false
		local data = self.lastSlotData
		local panel = SoraDCreatePanel("oneArmBanditRewardPopView")
		self = nil
		;(nil).data = data
		;(nil).handle = function()
			if self.slotType == 1 then
				self:btnSoltLeftCallback(nil, ccui.TouchEventType.ended)
			else
				self:btnSoltRightCallback(nil, ccui.TouchEventType.ended)
			end
		end
		panel:initData(nil)
		panel:show()
	end)
	showGold[3] = cca.callFunc(function(...)
		self.isRunning = false
		local data = self.lastSlotData
		local panel = SoraDCreatePanel("oneArmBanditRewardPopView")
		self = nil
		;(nil).data = data
		;(nil).handle = function()
			if self.slotType == 1 then
				self:btnSoltLeftCallback(nil, ccui.TouchEventType.ended)
			else
				self:btnSoltRightCallback(nil, ccui.TouchEventType.ended)
			end
		end
		panel:initData(nil)
		panel:show()
	end)
	self:runAction(cca.seq(showGold))
end
function oneArmBanditMainView:checkInActivityTime(...)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local time = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.SLOT_MACHINE) - serviceFunctions.systemTime()
	if time and 20 < time then
		return true
	else
		return false
	end
end
function oneArmBanditMainView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.SLOT_MACHINE)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function oneArmBanditMainView:setSlotEffect(...)
	local effectNode = SoraDCreatAnimation("laohuji_down")
	effectNode:setPosition(cc.p(320, -570))
	self.Node_effect_down:addChild(effectNode)
	local effectNode = SoraDCreatAnimation("laohuji_up")
	self.effectNode_up = effectNode
	effectNode:setPosition(cc.p(320, -570))
	self.Node_effect_up:addChild(effectNode)
	local effect_spList = SoraDGetChildsArrayByName(effectNode, "Sprite_", 5, 1)
	self.effect_spList = effect_spList
end
function oneArmBanditMainView:setShowEffect(...)
	if self.effectNode_show then
		self.effectNode_show:removeFromParent()
		self.effectNode_show = nil
	end
	local effectNode = SoraDCreatAnimation("laohuji_show")
	effectNode:setPosition(cc.p(320, -570))
	self.effectNode_show = effectNode
	self.Top_Node:addChild(effectNode)
end
function oneArmBanditMainView:setJackpotEffect(...)
	local effectNode = SoraDCreatAnimation("laohujidejiang")
	effectNode:setPosition(cc.p(320, 569))
	self.Bottom_Node:addChild(effectNode)
	local sp = SoraDGetChildByName(effectNode, "et_laohuji_02_11")
	if sp:isOpacityModifyRGB() then
		sp:setBlendFunc(gl.ONE, gl.ONE)
	else
		sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
end
function oneArmBanditMainView:setCheatSlotID(id)
	local data = slotMachineRewardRead.getRewardByID(id)
	if data then
		self.cheatID = id
	end
end
function oneArmBanditMainView:doCheat(...)
	if not self.cheatID then
		return
	end
	SoraDShowLoading(self)
	local cheatCtrl = gametop.playertop_:getModule("cheatCtrl")
	_ENV = nil
	;(nil).num = self.cheatID
	cheatCtrl:reqCheat(gCheatTypeDef.SET_SLOT_WIN_TYPE, nil)
	self:sendReqSolt(math.floor(self.cheatID / 100))
	self.cheatID = nil
end
return oneArmBanditMainView
