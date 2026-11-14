local godRewardsRead = include("godRewardsRead")
local itemDesRead = include("itemDesRead")
local godRewardsCtrl = SoraDGetCtrl("godRewardsCtrl")
local godRewardsLog = class("godRewardsLog", function(target)
	return target or SoraDCreateTouchPanel("godRewardsLog")
end)
function godRewardsLog:ctor(properties)
	self.textName = SoraDGetChildByName(self, "Text_name")
	self.textTitleInfo = SoraDGetChildByName(self, "Text_TitleInfo")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.scroll:setIsRight(SoraDFIsRA())
	self.nodeItem = SoraDGetChildByName(self, "Node_Item")
	self.nodeItem = include("commonItemAward").new(self.nodeItem)
	self.nodeItem:setOwnView(self)
	self.nodeItem:setRealScale(1.4)
	self.textBoxName = SoraDGetChildByName(self, "Text_BoxName")
	self.btnLook = SoraDGetChildByName(self, "Button_Look")
	self.btnLook:setTouchEnabled(true)
	self.btnLook:addTouchEventListener(handler(self, self.btnLookClick))
	self.textName:setString(i18n("graft_title_04"))
	self.textTitleInfo:setString(i18n("graft_text_06"))
	self:initData()
end
function godRewardsLog:createScrollSingle()
	local single = display.newNode()
	local item = SoraDCreatePanel("commonItemAward")
	item:setName("item")
	item:addTo(single)
	item:setPosition(45, 45)
	item:setScale(0.85)
	item:setOwnView(self)
	return single
end
function godRewardsLog:refreshScrollSingle(single, data)
	local item = single:getChildByName("item")
	item:initData(data.id, data.count)
end
function godRewardsLog:initData()
	_, self.itemID = godRewardsCtrl:getPrivilegeLevel()
	self.textBoxName:setString(itemDesRead.getName(self.itemID))
	self.nodeItem:initData(self.itemID, 1)
	self.totalTbl, _ENV = self.nodeItem.initData, self.nodeItem.initData
	self:getRewardList()
	_ENV = itemDesRead.getName(self.itemID)
	itemDesRead.getName(self.itemID).scroll = self.scroll
	itemDesRead.getName(self.itemID).view = self
	self.scroll:updateScrollView(cc.size(100, 100), self.totalTbl, 5, itemDesRead.getName(self.itemID))
end
function godRewardsLog:btnLookClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonItemShowBox", nil)
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function godRewardsLog:getRewardList()
	local count = 0
	local activityData = godRewardsCtrl:getActivityData()
	for i, v in pairs(activityData) do
		if v.receive then
			local extraAward, num = godRewardsRead.getAwardByTaskID(tonumber(i))
			count = num + count
			if next(extraAward) then
				godRewardsRead = tonumber(i)
				tonumber(i)[1] = "id"
				tonumber(i)[2] = "count"
				local extraAward = serviceFunctions.tableFormat(extraAward, tonumber(i))
				for _, value in ipairs(extraAward) do
					self:insertAward(value)
				end
			end
		end
	end
	if 0 < count then
		godRewardsCtrl = pairs(activityData)
		pairs(activityData).id = self.itemID
		pairs(activityData).count = count
		table.insert(self.totalTbl, pairs(activityData))
	end
end
function godRewardsLog:insertAward(reward)
	for i, v in ipairs(self.totalTbl) do
		if v.id == reward.id then
			v.count = v.count + reward.count
			return
		end
	end
	table.insert(self.totalTbl, reward)
end
return godRewardsLog
