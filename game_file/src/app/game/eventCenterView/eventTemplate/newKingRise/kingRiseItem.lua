local gametop = gModuleMgr.getObject("gametop")
local newKingRisesCtrl = gametop.playertop_:getModule("newKingRisesCtrl")
local newKingRisesltCtrl = gModuleMgr.sharedMgr("newKingRisesltCtrl")
local publicRead = include("publicRead")
local colorRed = cc.c3b(190, 40, 40)
local colorYellow = cc.c3b(255, 190, 0)
local kingRiseItem = class("kingRiseItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("kingRiseItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function kingRiseItem:ctor()
	self:createUI()
	self.panel_content = SoraDGetChildByName(self, "panel_content")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.text_progress_title = SoraDGetChildByName(self, "text_progress_title")
	self.text_progress_value = SoraDGetChildByName(self, "text_progress_value")
	self.text_progress_total = SoraDGetChildByName(self, "text_progress_total")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.panel_content:setTouchEnabled(false)
	self.panel_content:setSwallowTouches(false)
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.btn_operate:setSwallowTouches(false)
	self.btn_operate:setTouchEnabled(true)
	self.tbInUse, _ENV, self.tbNotUse, _ENV = self.btn_operate.setTouchEnabled, self.btn_operate.setTouchEnabled, self.btn_operate.setTouchEnabled, self.btn_operate.setTouchEnabled
end
function kingRiseItem:setFlyTargetPos(targetPos)
	self.targetPos = targetPos
end
function kingRiseItem:createUI()
end
function kingRiseItem:reset()
	self.btn_operate:setTouchEnabled(true)
	SoraDSetNodeGray(self.btn_operate, false)
end
function kingRiseItem:init(data)
	self:reset()
	self.itemData = data
	local eventData = self.itemData.eventData
	local taskID = eventData.taskID
	local taskstatus = eventData.taskstatus
	local isShowBottomLine = data.isShowBottomLine
	self.text_progress_title:setString(i18n("common_text_3780"))
	self.text_progress_title:ignoreContentAdaptWithSize(true)
	self.text_progress_value:setString(SoraDConvertNumberWithUnit(eventData.curnum))
	self.text_progress_value:ignoreContentAdaptWithSize(true)
	self.text_progress_total:setString("/" .. SoraDConvertNumberWithUnit(eventData.conditionnum))
	self.text_progress_total:ignoreContentAdaptWithSize(true)
	if eventData.curnum < eventData.conditionnum then
		self.text_progress_value:setColor(colorRed)
	else
		self.text_progress_value:setColor(colorYellow)
	end
	local _ENV, nodeArray = self.text_progress_value.setColor, self.text_progress_value.setColor
	local _ENV, paddingArray = self.text_progress_value, self.text_progress_value
	local align = false
	if SoraDFIsRA() then
		newKingRisesltCtrl = SoraDFIsRA()
		colorYellow, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		colorYellow, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		colorYellow, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = false
	else
		newKingRisesltCtrl = SoraDFIsRA()
		colorYellow, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		colorYellow, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		colorYellow, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = true
	end
	SoraDAlignNodeArray(nodeArray, align, paddingArray)
	self.btn_operate:setVisible(true)
	if taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
		self.btn_operate:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTitleText(i18n("common_text_1146"))
	elseif taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE_DONE then
		self.btn_operate:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTouchEnabled(false)
		SoraDSetNodeGray(self.btn_operate, true)
		self.btn_operate:setTitleText(i18n("common_text_1892"))
	elseif taskstatus == gKingRisesTaskStatus.TASK_STATUS_DOING or taskstatus == gKingRisesTaskStatus.TASK_STATUS_TIME_OUT then
		self.btn_operate:loadTextures("btn_blue_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTitleText(i18n("common_text_477"))
		local condition = newKingRisesltCtrl:getTaskCondition(taskID)
		if condition then
			self.btn_operate:setVisible(true)
		else
			self.btn_operate:setVisible(false)
		end
		local activityStatus = newKingRisesCtrl:getActivityStatus()
		if activityStatus == gKingRisesActivityStatus.CALCULATE then
			self.btn_operate:setTouchEnabled(false)
			SoraDSetNodeGray(self.btn_operate, true)
		end
	end
	local taskDes = newKingRisesltCtrl:getTaskDes(taskID)
	self.text_title:setString(taskDes)
	self:recycleAll()
	local rewards = clone(newKingRisesltCtrl:queryTaskData(taskID).rewards)
	local showReward = newKingRisesltCtrl:queryTaskData(taskID).reward_show
	if showReward then
		rewards[#rewards + 1] = showReward[1]
		rewards[#rewards + 1] = showReward[2]
	end
	self:initRewards(rewards)
end
function kingRiseItem:recycleAll()
	for i, v in ipairs(self.tbInUse) do
		v:setVisible(false)
		table.insert(self.tbNotUse, v)
	end
	self.tbInUse, _ENV = ipairs(self.tbInUse)
end
function kingRiseItem:getItem()
	if #self.tbNotUse > 0 then
		local node = table.remove(self.tbNotUse)
		node:setVisible(true)
		return node
	else
		local itemSingle = include("commonItemAward").new()
		itemSingle:setBaseScale(1.0)
		itemSingle:setNewRiseModel()
		itemSingle:setScale(0.7)
		itemSingle:setOwnView(self.itemData.view)
		itemSingle:addTo(self.panel_content)
		return itemSingle
	end
end
function kingRiseItem:initRewards(rewards)
	local numColOfItem = 5
	local heightItem = 90
	local totalItemHeight = 130
	self.lastItem = nil
	for j = 1, #rewards / 2 do
		local itemId = rewards[2 * j - 1]
		local itemNum = rewards[2 * j]
		local itemSingle
		itemSingle = self:getItem()
		table.insert(self.tbInUse, itemSingle)
		local xIndex = j - (math.floor((j + numColOfItem - 1) / numColOfItem) - 1) * numColOfItem
		if SoraDFIsRA() then
			itemSingle:setPositionX(580 - (xIndex - 1) * 84)
		else
			itemSingle:setPositionX(60 + (xIndex - 1) * 84)
		end
		itemSingle:setPositionY(60)
		itemSingle:initData(itemId, itemNum)
		self.lastItem = itemSingle
	end
end
function kingRiseItem:setScroll(scroll)
	self.scroll = scroll
	for k, v in pairs(self.tbInUse) do
		v:setOwnScroll(self.scroll)
	end
end
function kingRiseItem:onClick_btn_operate(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		local eventData = self.itemData.eventData
		local taskstatus = eventData.taskstatus
		local taskID = eventData.taskID
		if taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
			newKingRisesCtrl:reqMissionCommit(taskID)
			self:showItemFlyToBox()
		elseif taskstatus == gKingRisesTaskStatus.TASK_STATUS_DOING or taskstatus == gKingRisesTaskStatus.TASK_STATUS_TIME_OUT then
			local qData = newKingRisesltCtrl:getTaskCondition(taskID)
			if qData then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local qtype = qData.questType
				dump(qData, "NewPlayerQuestSingle")
				mildGuideManager:starMildByNewPlayerQuestID(qtype, qData)
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
function kingRiseItem:showItemFlyToBox()
	if not self.targetPos then
		return
	end
	local effect = SoraDCreatAnimation("itemFlyToBox", nil, false)
	effect:setPosition(cc.p(0, 0))
	display.getRunningScene():addChild(effect, 1000)
	local nodeEffect_1 = SoraDGetChildByName(effect, "Node_Effect_ttt01_002")
	local ballEffect = SoraDGetChildByName(effect, "Node_BallEffect")
	local nodeWayEffect = SoraDGetChildByName(effect, "Node_WayEffect")
	local startPosition = self.lastItem:getParent():convertToWorldSpace(cc.p(self.lastItem:getPosition()))
	local posX = startPosition.x
	local posY = startPosition.y
	local offsetX = math.abs(self.targetPos.x - posX)
	local offsetY = math.abs(self.targetPos.y - posY)
	local angle = math.deg(math.atan(offsetY / offsetX))
	local G_dh_Tex_Way = SoraDGetChildByName(nodeWayEffect, "G_dh_Tex_Way")
	G_dh_Tex_Way:setScaleX((offsetX + offsetY) / 256)
	if not SoraDFIsRA() then
		G_dh_Tex_Way:setRotation(180 - angle)
		SoraDGetChildByName(nodeWayEffect, "et_Par_ttt_015"):setRotation(90 - angle)
	else
		G_dh_Tex_Way:setRotation(angle)
		SoraDGetChildByName(nodeWayEffect, "et_Par_ttt_015"):setRotation(0)
	end
	nodeWayEffect:setPosition(Linear_Interpolate(self.targetPos.x, posX, 0.5), Linear_Interpolate(self.targetPos.y, posY, 0.5))
	nodeEffect_1:setPosition(self.targetPos)
	ballEffect:setPosition(posX, posY)
	_UPVALUE1_ = posY
	posY[1] = cca.delay(1.5166666666666666)
	posY[2] = cca.callFunc(function()
		effect:removeSelf()
	end)
	posY[3] = cca.callFunc(function()
		effect:removeSelf()
	end)
	self:runAction(cca.seq(posY))
end
return kingRiseItem
