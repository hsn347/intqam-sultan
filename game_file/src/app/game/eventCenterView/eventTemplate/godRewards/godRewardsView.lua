local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local godRewardsCtrl = SoraDGetCtrl("godRewardsCtrl")
local godRewardsRead = include("godRewardsRead")
local godRewardsView = class("godRewardsView", function(target)
	return target or SoraDCreateBasePanel("godRewardsView")
end)
function godRewardsView:ctor()
	self.titleNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_GodRewards")
	self.titleNode:setTitle(i18n("activity_name_33"))
	self.titleNode:setBtnHelpClickCallBack(handler(self, self.btnClickQuestion))
	self.activityDay = SoraDGetChildByName(self, "Text_remainDay")
	self.activityTime = SoraDGetChildByName(self, "Text_remainTime")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("godRewardsSingle")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.nodeLookLog = SoraDGetChildByName(self.topNode, "Node_Look")
	self.textRewardLog = SoraDGetChildByName(self.nodeLookLog, "Text_BoxName")
	self.btnLookLog = SoraDGetChildByName(self.nodeLookLog, "Button_Look")
	self.btnLookLog:addTouchEventListener(handler(self, self.btnClickLookLog))
	self.btnLookLog:ignoreContentAdaptWithSize(false)
	self.textRewardLog:setString(i18n("graft_title_03"))
	self.textBoxNum = SoraDGetChildByName(self.nodeLookLog, "Text_NumBox")
	self.nodeBoxBig = SoraDGetChildByName(self, "Node_Box_Big")
	self.btnGoShopBig = SoraDGetChildByName(self.nodeBoxBig, "Button_GoShop")
	self.btnGoShopBig:setTag(godRewardsRead.getItemIDByIndex(3))
	self.btnGoShopBig:addTouchEventListener(handler(self, self.btnClickUpBox))
	SoraDGetChildByName(self.nodeBoxBig, "Text_Button"):setString(i18n("common_text_282"))
	self.nodeBoxSmall = SoraDGetChildByName(self, "Node_Box_Small")
	self.btnGoShopSmall = SoraDGetChildByName(self.nodeBoxSmall, "Button_GoShop")
	self.btnGoShopSmall:setTag(godRewardsRead.getItemIDByIndex(2))
	self.btnGoShopSmall:addTouchEventListener(handler(self, self.btnClickUpBox))
	SoraDGetChildByName(self.nodeBoxSmall, "Text_Button"):setString(i18n("common_text_282"))
	self.boxItemBig = SoraDGetChildByName(self.nodeBoxBig, "Node_Item")
	self.boxItemBigButton = SoraDGetChildByName(self.boxItemBig, "Button_item")
	self.boxItemBigButton:addTouchEventListener(handler(self, self.btnClickLookReward))
	self.boxItemSmall = SoraDGetChildByName(self.nodeBoxSmall, "Node_Item")
	self.redIcon = SoraDGetChildByName(self.nodeBoxSmall, "FirstTip_red")
	_ENV = handler(self, self.btnClickLookReward)
	handler(self, self.btnClickLookReward).byUID = true
	self.redIcon:setVisible(not SoraDConfigGet("Game:godRewardsView:redTip~bool", handler(self, self.btnClickLookReward)))
	self.boxItemSmallButton = SoraDGetChildByName(self.boxItemSmall, "Button_item")
	self.boxItemSmallButton:addTouchEventListener(handler(self, self.btnClickLookReward))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("graft_text_02"))
	SoraDSetTextWidthHeight(self.textTips, cc.size(590, 26))
	self.itemExample = SoraDGetChildByName(self, "Image_item")
	self:initData()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.UPGRADE_REWARD_ACTIVITY)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	if eventTime then
		self.activityTime:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(SoraDGetChildByName(self, "Node_timer"), 10, SoraDFIsRA())
	self.centerIcon = sp.SkeletonAnimation:create("spine/pingbuqingyun.skel", "spine/pingbuqingyun.atlas", 1.2)
	self.centerIcon:setVisible(false)
	self.centerIcon:setPosition(-95, -420)
	self.topNode:addChild(self.centerIcon, -1)
	self.centerIcon:setAnimation(0, "animation", true)
	local cssFileName = "godRewardsView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
end
function godRewardsView:initData(target, data)
	SoraDCloseLoading(self)
	local giftID = 0
	giftID, self.itemID = godRewardsCtrl:getPrivilegeLevel()
	print(" godRewardsView:initDa", self.itemID, giftID, publicRead.getIcon(self.itemID))
	self.btnGoShopBig:setVisible(giftID == 0)
	self.btnGoShopSmall:setVisible(giftID == 0)
	SoraDGetChildByName(self.nodeBoxSmall, "Text_Button"):setVisible(giftID == 0)
	SoraDGetChildByName(self.nodeBoxBig, "Text_Button"):setVisible(giftID == 0)
	self.btnLookLog:loadTextureNormal(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.boxItemBigButton:setTag(godRewardsRead.getItemIDByIndex(3))
	local smallItemID = godRewardsRead.getItemIDByIndex(2)
	self.boxItemSmallButton:setTag(smallItemID)
	SoraDGetChildByName(self.boxItemSmall, "Image_icon"):loadTexture(publicRead.getIcon(smallItemID), ccui.TextureResType.plistType)
	SoraDGetChildByName(self.nodeBoxSmall, "Particle_10"):setPositionY(tonumber(smallItemID) == 729801 and 46 or 22)
	self.taskList = godRewardsCtrl:getTaskInfo()
	if data and data.taskID then
		self:showBoxAddTips(data.taskID)
	else
		_ENV = godRewardsRead.getItemIDByIndex(3)
		godRewardsRead.getItemIDByIndex(3).scroll = self.scroll
		godRewardsRead.getItemIDByIndex(3).view = self
		self.scroll:updateScrollView(cc.size(640, 120), self.taskList, 1, godRewardsRead.getItemIDByIndex(3))
	end
	self.showLight = false
	self.textBoxNum:setString(self:getBoxNums())
end
function godRewardsView:showBoxAddTips(taskID)
	local tmp, count = godRewardsRead.getAwardByTaskID(taskID)
	self.itemList = serviceFunctions.table_copy_table(tmp)
	table.insert(self.itemList, self.itemID)
	table.insert(self.itemList, count)
	_UPVALUE2_ = count
	count[1] = "id"
	count[2] = "count"
	self.tablePackItem, godRewardsRead, self.itemList = serviceFunctions.tableFormat(self.itemList, count), serviceFunctions.tableFormat(self.itemList, count), serviceFunctions.tableFormat(self.itemList, count)
	local godRewardsRead, tempTable = serviceFunctions.tableFormat(self.itemList, count), serviceFunctions.tableFormat(self.itemList, count)
	local posY = -500
	for i, v in ipairs(self.itemList) do
		table.insert(tempTable, v)
		if #tempTable == 4 then
			for index, value in ipairs(tempTable) do
				godRewardsRead = nil
				;(nil).x = -200 + (index * 2 - 1) * 50
				value.pos, (nil).y = nil, posY + math.ceil(#self.itemList / 4) * 100 - i / 4 * 100
				table.insert(self.tablePackItem, value)
			end
			tempTable, godRewardsRead = ipairs(tempTable)
		end
	end
	if next(tempTable) ~= nil then
		for i, v in ipairs(tempTable) do
			godRewardsRead = ipairs(tempTable)
			ipairs(tempTable).x = -#tempTable * 100 / 2 + (i * 2 - 1) * 50
			v.pos, ipairs(tempTable).y = ipairs(tempTable)
			table.insert(self.tablePackItem, v)
		end
	end
	godRewardsRead = table.insert
	table.insert.scroll = self.scroll
	table.insert.view = self
	table.insert.showLight = self.showLight
	self.scroll:updateScrollView(cc.size(640, 120), self.taskList, 1, table.insert)
	for i, v in ipairs(self.tablePackItem) do
		local item = include("commonItemAward").new()
		item:setScale(0.1)
		item:setPosition(0, posY - 100)
		item:addTo(self.topNode)
		item:initData(v.id, v.count)
		_UPVALUE2_ = item.initData
		_ENV = v.count
		v.count[1] = cc.EaseExponentialIn:create(cca.moveTo(0.5, self.nodeLookLog:getPositionX(), self.nodeLookLog:getPositionY()))
		v.count[2] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[3] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[4] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[5] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		v.count[7] = cc.EaseExponentialIn:create(cca.scaleTo(0.8, 0.1))
		item.initData[1] = cca.delay(0.6)
		item.initData[2] = cca.spawn(v.count)
		item.initData[3] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[4] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[5] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[6] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[7] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[8] = cca.callFunc(function()
			item:removeFromParent()
		end)
		item.initData[9] = cca.callFunc(function()
			item:removeFromParent()
		end)
		local item.initData[10], action = cca.callFunc(function()
			item:removeFromParent()
		end)
		_ENV = cca.callFunc(function()
			item:removeFromParent()
		end)
		cca.callFunc(function()
			item:removeFromParent()
		end)[1] = cc.MoveTo:create(0.5, v.pos)
		cca.callFunc(function()
			item:removeFromParent()
		end)[2] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[3] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[4] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[5] = cca.scaleTo(0.5, 0.9)
		cca.callFunc(function()
			item:removeFromParent()
		end)[6] = cca.scaleTo(0.5, 0.9)
		godRewardsRead = cca.callFunc(function()
			item:removeFromParent()
		end)
		cca.callFunc(function()
			item:removeFromParent()
		end).easing = "BACKOUT"
		transition.execute(item, cca.spawn(cca.callFunc(function()
			item:removeFromParent()
		end)), cca.callFunc(function()
			item:removeFromParent()
		end))
		local seq = cca.seq(action)
		item:runAction(seq)
	end
	self:showWaggleEffect()
end
function godRewardsView:showWaggleEffect()
	self.btnLookLog:stopAllActions()
	_UPVALUE6_ = self.btnLookLog
	self.btnLookLog[1] = cca.delay(2)
	self.btnLookLog[2] = cca.rotateTo(0.25, 10)
	self.btnLookLog[3] = cca.rotateTo(0.21666666666666667, -10)
	self.btnLookLog[4] = cca.rotateTo(0.2, 8)
	self.btnLookLog[5] = cca.rotateTo(0.16666666666666666, -5)
	self.btnLookLog[6] = cca.rotateTo(0.15, 2)
	self.btnLookLog[7] = cca.rotateTo(0.15, 0)
	self.btnLookLog[8] = cca.rotateTo(0.15, 0)
	self.btnLookLog[9] = cca.rotateTo(0.15, 0)
	local seq = cca.seq(self.btnLookLog)
	self.btnLookLog:runAction(seq)
end
function godRewardsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_GODREWARDS_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_GODREWARDS_GRAFT_PRIVILEGE_GIFT", handler(self, self.shopSuccessCallBack))
end
function godRewardsView:shopSuccessCallBack(target, data)
	SoraDCloseLoading(self)
	SoraDShowMsgTip(i18n("graft_text_04"))
	self.showLight = true
	self:initData()
end
function godRewardsView:setMixtureGLONE(parent)
	local children = parent:getChildren()
	for _, v in pairs(children) do
		SoraDMixtureGLONE(v)
	end
end
function godRewardsView:btnClickQuestion(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("graft_text_03"))
	end
end
function godRewardsView:btnClickLookReward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).itemID = button:getTag()
		uiManager:show("CommonItemShowBox", nil)
	end
end
function godRewardsView:btnClickUpBox(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local itemID = button:getTag()
		if itemID == godRewardsRead.getItemIDByIndex(2) then
			self.redIcon:setVisible(false)
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:godRewardsView:redTip~bool", true, nil)
		end
		local panel = SoraDCreatePanel("godRewardsUpPopView")
		panel:initData(itemID)
		panel:show()
	end
end
function godRewardsView:btnClickLookLog(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("godRewardsLog")
		panel:show()
	end
end
function godRewardsView:getChildInfoByID(questID)
	local children = self.scroll:getChildren()
	for i, v in ipairs(children) do
		if v.data.questID == questID then
			return v
		end
	end
end
function godRewardsView:getBoxNums()
	local count = 0
	local activityData = godRewardsCtrl:getActivityData()
	for i, v in pairs(activityData) do
		if v.receive then
			local extraAward, num = godRewardsRead.getAwardByTaskID(tonumber(i))
			count = num + count
		end
	end
	return count
end
function godRewardsView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UPGRADE_REWARD_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return godRewardsView
