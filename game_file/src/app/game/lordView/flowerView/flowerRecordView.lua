local gametop = gModuleMgr.getObject("gametop")
local flowerSysCtrl = gametop.playertop_:getModule("flowerSysCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local flowerRecordView = class("flowerRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("flowerRecordView")
	end
	return target
end)
function flowerRecordView:ctor()
	self.tableHistory, _ENV, self.history, _ENV = nil, nil, nil, nil
	self.nodeTimeH = 26
	self.nodeSingleH = 72
	self.gaptH = 7
	self.gapsH = 3
	self.msgType = 1
	self.title = SoraDGetChildByName(self, "Text_title")
	self.title:setString(i18n("common_text_2305"))
	self.frame_lace_l = SoraDGetChildByName(self, "frame_lace_l")
	self.frame_lace_r = SoraDGetChildByName(self, "frame_lace_r")
	self.frame_lace_l:setPositionX(-self.title:getContentSize().width / 2 - 25)
	self.frame_lace_r:setPositionX(self.title:getContentSize().width / 2 + 25)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_record")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
	self.emptyTips = SoraDGetChildByName(self, "empty_tips")
	self.emptyTips:setString(i18n("common_text_1060"))
	SoraDGetChildByName(self, "Image_18"):setFillType(1)
	self.Image_sent = SoraDGetChildByName(self, "Image_sent")
	self.Image_got = SoraDGetChildByName(self, "Image_got")
	self.Button_sent = SoraDGetChildByName(self, "Button_sent")
	self.Button_sent:setTitleText(i18n("flowers_give_1"))
	self.Button_sent:addTouchEventListener(handler(self, self.btnSentClick))
	self.Button_got = SoraDGetChildByName(self, "Button_got")
	self.Button_got:setTitleText(i18n("flowers_receive_1"))
	self.Button_got:addTouchEventListener(handler(self, self.btnGotClick))
	self.curBtn = self.Button_got
	self:btnGotClick(self.Button_got, ccui.TouchEventType.ended, true)
end
function flowerRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_FLOWER_HISTORY", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
end
function flowerRecordView:switchBtns()
	self.Image_got:setVisible(self.curBtn == self.Button_got)
	self.Image_sent:setVisible(self.curBtn == self.Button_sent)
	self.Button_sent:setTitleColor(self.curBtn == self.Button_sent and cc.c3b(93, 51, 13) or cc.c3b(118, 72, 31))
	self.Button_got:setTitleColor(self.curBtn == self.Button_got and cc.c3b(93, 51, 13) or cc.c3b(118, 72, 31))
end
function flowerRecordView:btnSentClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.msgType = 2
		flowerSysCtrl:sendHistory(self.msgType)
		SoraDShowLoading(self)
		self.curBtn = self.Button_sent
		self:switchBtns()
	end
end
function flowerRecordView:btnGotClick(button, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		self.msgType = 1
		flowerSysCtrl:sendHistory(self.msgType)
		SoraDShowLoading(self)
		self.curBtn = self.Button_got
		self:switchBtns()
	end
end
function flowerRecordView:getTimeNode()
	local timeNode = self.Node_time:clone()
	timeNode:setVisible(true)
	function timeNode.setTimeStr(text)
		local Text_time = SoraDGetChildByName(timeNode, "Text_time")
		Text_time:setString(text)
	end
	return timeNode
end
function flowerRecordView:getSingleNode()
	local singleNode = self.Node_single:clone()
	singleNode:setVisible(true)
	function singleNode.setData(data)
		local Text_time = SoraDGetChildByName(singleNode, "Text_time")
		Text_time:setString(data.str_time)
		local Text_name = SoraDGetChildByName(singleNode, "Text_name")
		local name = ""
		if self.msgType == 1 then
			name = data.sndName or data.name
		else
			name = data.revName or data.name
		end
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(name) then
			name = "******"
		end
		local goodType = backpackltCtrl:getItemType(data.flowerID)
		local sourceKid = lordInfoCtrl:getSourceKid()
		if sourceKid and sourceKid <= 0 then
			sourceKid = gametop.playertop_:getKingdomID()
		end
		if goodType == gItemType.ROSE then
			if self.msgType == 1 then
				if data.sndKID ~= sourceKid then
					name = name .. "#" .. data.sndKID or name
				end
			else
				name = sourceKid ~= data.revKID and name .. "#" .. data.revKID or name
			end
		end
		Text_name:setString(name)
		Text_name.uid = self.msgType == 1 and data.sndUID or data.revUID
		Text_name.kid = self.msgType == 1 and data.sndKID or data.revKID
		Text_name:setTouchEnabled(true)
		Text_name:setSwallowTouches(false)
		Text_name:setTouchScaleChangeEnabled(true)
		Text_name:addTouchEventListener(handler(self, self.onPlayerClick))
		local reward = SoraDGetExtendChildFromCCSByName(singleNode, "CCS_commonItemAward_item")
		reward:setScale(0.6)
		reward:setBaseScale(1)
		reward:setScroll(self.scroll)
		reward:initData(data.flowerID, data.flowerNum)
	end
	return singleNode
end
function flowerRecordView:initData()
	self.scroll:removeAllChildren()
	self.tableHistory, flowerSysCtrl = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	self.history = flowerSysCtrl:getHistoryData()
	local scrollH = self.scroll:getContentSize().height
	if self.history and next(self.history) then
		table.sort(self.history, function(a, b)
			return a.date > b.date
		end)
		local index = 1
		local preDate, curDate
		for k, v in ipairs(self.history) do
			local tiemTab = os.date("*t", v.date)
			local str_time = tiemTab.hour .. ":" .. tiemTab.min .. ":" .. tiemTab.sec
			local str_date = tiemTab.year .. "-" .. tiemTab.month .. "-" .. tiemTab.day
			v.str_time = str_time
			v.str_data = str_date
			curDate = str_date
			if preDate and curDate and preDate ~= curDate then
				index = index + 1
			end
			if not self.tableHistory[index] then
				self.tableHistory[index], flowerSysCtrl = tiemTab.month, tiemTab.month
			end
			self.tableHistory[index].str_date = str_date
			if not self.tableHistory[index].data then
				self.tableHistory[index].data, flowerSysCtrl = tiemTab.month, tiemTab.month
			end
			table.insert(self.tableHistory[index].data, v)
			preDate = str_date
		end
		scrollH = math.max(self.scroll:getContentSize().height, #self.tableHistory * (self.nodeTimeH + self.gaptH) + #self.history * (self.nodeSingleH + self.gapsH))
		self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	end
	local loadPosY = scrollH
	for k, v in ipairs(self.tableHistory) do
		local timeNode = self:getTimeNode()
		timeNode.setTimeStr(v.str_date)
		timeNode:setPosition(self.scroll:getContentSize().width / 2, loadPosY - self.nodeTimeH / 2)
		timeNode:addTo(self.scroll)
		loadPosY = loadPosY - self.nodeTimeH - self.gaptH
		for ki, data in ipairs(v.data) do
			local tmpPosY = loadPosY
			ki = ki < 8 and 0 or ki - 8
			if k < 8 then
				local singleNode = self:getSingleNode()
				singleNode.setData(data)
				singleNode:setPosition(self.scroll:getContentSize().width / 2, tmpPosY - self.nodeSingleH / 2)
				singleNode:addTo(self.scroll)
			else
				_ENV = self.scroll
				self.scroll[1] = cca.delay(ki * 0.1)
				self.scroll[2] = cca.callFunc(function()
					local singleNode = self:getSingleNode()
					singleNode.setData(data)
					singleNode:setPosition(self.scroll:getContentSize().width / 2, tmpPosY - self.nodeSingleH / 2)
					singleNode:addTo(self.scroll)
				end)
				self.scroll[3] = cca.callFunc(function()
					local singleNode = self:getSingleNode()
					singleNode.setData(data)
					singleNode:setPosition(self.scroll:getContentSize().width / 2, tmpPosY - self.nodeSingleH / 2)
					singleNode:addTo(self.scroll)
				end)
				self:runAction(cca.seq(self.scroll))
			end
			loadPosY = loadPosY - self.nodeSingleH - self.gapsH
		end
	end
	self.emptyTips:setVisible(#self.tableHistory == 0)
end
function flowerRecordView:onPlayerClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initPlayer))
		local kid = target.kid or gametop.playertop_:getKingdomID()
		_ENV = handler(self, self.initPlayer)
		handler(self, self.initPlayer).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(target.uid, kid, handler(self, self.initPlayer))
	end
end
function flowerRecordView:initPlayer(target, data)
	local lordInfo = data.lord
	if not lordInfo then
		return
	end
	SoraDOpenLordView(lordInfo)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
end
return flowerRecordView
