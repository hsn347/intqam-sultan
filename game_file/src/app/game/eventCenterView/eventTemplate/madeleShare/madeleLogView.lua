local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local madeleLogView = class("madeleLogView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("flowerRecordView")
	end
	return target
end)
function madeleLogView:onEnterPanel()
	SoraDShowLoading(self)
	self.mergeItem = 817701
end
function madeleLogView:ctor()
	self.tableHistory, _ENV, self.history, _ENV = nil, nil, nil, nil
	self.nodeTimeH = 26
	self.nodeSingleH = 72
	self.gaptH = 7
	self.gapsH = 3
	self.title = SoraDGetChildByName(self, "Text_title")
	self.title:setString(i18n("madeleine_feast_title_03"))
	SoraDGetChildByName(self, "Image_14"):setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_record")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
end
function madeleLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MADELE_LOG_SUCCESS", function(target, data)
		SoraDCloseLoading(self)
		if data.data and table.nums(data.data) > 0 then
			self:initData(data.data)
		else
			local text = ccui.Text:create(i18n("common_text_927"), "", 20)
			text:addTo(SoraDGetChildByName(self, "Center_Node"))
			text:setPosition(0, 0)
		end
	end)
end
function madeleLogView:getTimeNode()
	local timeNode = self.Node_time:clone()
	timeNode:setVisible(true)
	function timeNode.setTimeStr(text)
		local Text_time = SoraDGetChildByName(timeNode, "Text_time")
		Text_time:setString(text)
	end
	return timeNode
end
function madeleLogView:getSingleNode()
	local singleNode = self.Node_single:clone()
	singleNode:setVisible(true)
	function singleNode.setData(data)
		local Text_time = SoraDGetChildByName(singleNode, "Text_time")
		Text_time:setString(data.str_time)
		local Text_name = SoraDGetChildByName(singleNode, "Text_name")
		local name = data.nickName .. "#" .. data.kid
		local sourceKid = lordInfoCtrl:getSourceKid()
		Text_name:setString(name)
		SoraDDrawTextUnderLine(Text_name, cc.c4b(84, 30, 10, 255), 3.0)
		Text_name.uid = data.uid
		Text_name.kid = data.kid
		Text_name:setTouchEnabled(true)
		Text_name:setSwallowTouches(false)
		Text_name:setTouchScaleChangeEnabled(true)
		Text_name:addTouchEventListener(handler(self, self.onPlayerClick))
		local reward = SoraDGetExtendChildFromCCSByName(singleNode, "CCS_commonItemAward_item")
		reward:setScale(0.6)
		reward:setBaseScale(1)
		reward:setScroll(self.scroll)
		reward:setOwnView(self)
		reward:initData(self.mergeItem, data.count)
	end
	return singleNode
end
function madeleLogView:initData(data)
	self.history = data
	local scrollH = self.scroll:getContentSize().height
	if self.history and next(self.history) then
		table.sort(self.history, function(a, b)
			return a.time > b.time
		end)
		local index = 1
		local preDate, curDate
		for k, v in ipairs(self.history) do
			local tiemTab = os.date("*t", v.time)
			local str_time = string.format("%02d:%02d:%02d", tiemTab.hour, tiemTab.min, tiemTab.sec)
			local str_date = string.format("%04d-%02d-%02d", tiemTab.year, tiemTab.month, tiemTab.day)
			v.str_time = str_time
			v.str_data = str_date
			curDate = str_date
			if preDate and curDate and preDate ~= curDate then
				index = index + 1
			end
			if not self.tableHistory[index] then
				self.tableHistory[index], _ENV = tiemTab.year, tiemTab.year
			end
			self.tableHistory[index].str_date = str_date
			if not self.tableHistory[index].data then
				self.tableHistory[index].data, _ENV = tiemTab.year, tiemTab.year
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
			local singleNode = self:getSingleNode()
			singleNode.setData(data)
			singleNode:setPosition(self.scroll:getContentSize().width / 2, loadPosY - self.nodeSingleH / 2)
			singleNode:addTo(self.scroll)
			loadPosY = loadPosY - self.nodeSingleH - self.gapsH
		end
	end
end
function madeleLogView:onPlayerClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initPlayer))
		local kid = target.kid or gametop.playertop_:getKingdomID()
		_ENV = handler(self, self.initPlayer)
		handler(self, self.initPlayer).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(target.uid, kid, handler(self, self.initPlayer))
	end
end
function madeleLogView:initPlayer(target, data)
	local lordInfo = data.lord
	if not lordInfo then
		return
	end
	SoraDOpenLordView(lordInfo)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
end
return madeleLogView
