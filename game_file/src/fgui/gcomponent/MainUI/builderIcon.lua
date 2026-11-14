local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local builderIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/builderIcon", builderIcon)
function builderIcon:onInit()
	self.queue = nil
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.builderTime:fixPos()
end
function builderIcon:onShow()
end
function builderIcon:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CREATE_BUILD", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_UPGRADE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILDER_OPEN", function(...)
		self:updateView()
		self:showChargeTime()
	end)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_DEMOLISH_BUILD", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_BUILDER_COLSE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.refreshBuildStarQueue))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.refreshBuildStarQueue))
end
function builderIcon:initData(queueType)
	self.queueType = queueType
	self.fields.builder:setQueueType(queueType)
	self:updateView()
end
function builderIcon:updateView()
	self.queue = queueCtrl:queryQueue(self.queueType)
	if self.queue then
		if self.queueType == gQueueTypeDef.garden_build_upgrade then
			local buildID = tonumber(self.queue.data.bid)
			self.fields.builder:setGardenBuild(buildID)
		elseif self.queueType == gQueueTypeDef.garden_technology then
			local queue = technologyCtrl:studyingTechnology(self.queueType)
			local tid = tonumber(queue.technologyID)
			self.fields.builder:setGardenBuild(tid)
		else
			local buildID = tonumber(self.queue.data.bid)
			self.fields.builder:setBuild(buildID)
		end
		self:setBuilderWork()
	else
		self:closeBuilder()
	end
end
function builderIcon:setModel(model)
	self.fields.builder:setControl1Index(model)
end
function builderIcon:refreshBuildStarQueue()
	if self.queueType == gQueueTypeDef.build_star_queue then
		self:updateView()
	elseif self.queueType == gQueueTypeDef.build_star_queue_privilege then
		self:updateView()
	end
end
function builderIcon:closeBuilder()
	self:setBuilderSleep()
	self:idleAnimation()
	if self.queueType == gQueueTypeDef.charge_build_queue then
		local buildchargequeue = cityCtrl:getCurCity():queryQueue(self.queueType)
		if buildchargequeue then
			print("队列开启")
			self:setBuilderActive(false)
		else
			print("队列关闭")
			self:setBuilderActive(true)
		end
	end
end
function builderIcon:idleAnimation()
	self:correctAnimation(false)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.builder:stopAllActions()
	self.fields.builder:setControl2Index(0)
	self.fields.builder:resetScale()
	self.showNoticeAction = nil
end
function builderIcon:setBuilderSleep()
	if self.showNoticeAction then
		self.fields.builderTime:setVisible(false)
		self.fields.builder:setControl2Index(0)
		self:stopAction(self.showNoticeAction)
		self.fields.builder:resetScale()
		self.showNoticeAction = nil
	end
end
function builderIcon:setBuilderFree()
	if SoraDIsGameGuide() ~= nil then
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		queueCtrl:speedUpQueueReq(tonumber(self.queueType), SPEEDUP_TYPE.FREE)
		return
	end
	self.fields.builder:setControl2Index(2)
	self:buildFreeAnimation()
end
function builderIcon:correctAnimation(isFree)
	self.fields.builder:correctAnimation(isFree)
end
function builderIcon:buildFreeAnimation()
	self:correctAnimation(true)
	if self.showNoticeAction then
		self:stopAction(self.showNoticeAction)
		self.fields.builderTime:setVisible(false)
		self.showNoticeAction = nil
	end
	_UPVALUE3_ = self.fields.builderTime
	self.fields.builderTime[1] = ffa.callFunc(function()
		local vip = lordInfoCtrl:getVip()
		if vip[2] then
			if vip[1] < VIP_LV10_LIMITED then
				self.fields.builderTime:setTimeTitle(i18n("common_text_846"))
			else
				self:stopAction(self.showNoticeAction)
				self.showNoticeAction = nil
				self.fields.builderTime:setVisible(false)
				return
			end
		else
			self.fields.builderTime:setTimeTitle(i18n("common_text_847"))
		end
		self.fields.builderTime:setTimeVisble(false)
		self.fields.builderTime:setVisible(true)
	end)
	self.fields.builderTime[2] = ffa.delay(5)
	self.fields.builderTime[3] = ffa.callFunc(function()
		self.fields.builderTime:setVisible(false)
	end)
	self.fields.builderTime[4] = ffa.delay(5)
	self.fields.builderTime[5] = ffa.delay(5)
	local sequenceLabel = ffa.seq(self.fields.builderTime)
	self.showNoticeAction = ffa.repeatForever(sequenceLabel)
	self:runAction(self.showNoticeAction)
end
function builderIcon:setBuilderActive(bActive)
	self.fields.builder:setGoldBuilderParticle(bActive)
end
function builderIcon:setBuilderWork()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.timer = SoradCreateTimer(self, handler(self, self.loadingBarUpdateListener))
	self:loadingBarUpdateListener(0)
	self:buildNotFreeAnimation()
	self.fields.builder:setControl2Index(1)
	self.controllers.c1:setSelectedIndex(1)
end
function builderIcon:loadingBarUpdateListener(curTime)
	if self.queue then
		local leftTime = self.queue.timerNode.timer:getRemainTime()
		self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
		local totaltime = self.queue.ottime or self.queue.totaltime
		self.fields.builder:setPercent((totaltime - leftTime) / totaltime)
		local freeSpeedUpTime
		if self.queueType == gQueueTypeDef.build_star_queue or self.queueType == gQueueTypeDef.build_star_queue_privilege then
			freeSpeedUpTime = buildLogic.getFreeStrongTime()
		elseif self.queueType == gQueueTypeDef.garden_technology or self.queueType == gQueueTypeDef.garden_build_upgrade then
			freeSpeedUpTime = 0
		else
			freeSpeedUpTime = buildLogic.getFreeSpeedUpTime(self.queue.data.lv)
		end
		if freeSpeedUpTime and leftTime <= freeSpeedUpTime and self.showNoticeAction == nil then
			self:setBuilderFree()
		end
		if leftTime <= 0 then
			self:setBuilderSleep()
		end
	else
		self:setBuilderSleep()
	end
end
function builderIcon:buildNotFreeAnimation()
	self:stopAllActions()
	self.showNoticeAction = nil
	local isNoramlQueue = self.queueType == gQueueTypeDef.free_build_queue or self.queueType == gQueueTypeDef.charge_build_queue or self.queueType == gQueueTypeDef.garden_build_upgrade
	self:correctAnimation(false, isNoramlQueue)
	self.fields.builder:runFlipAni(isNoramlQueue)
	if isNoramlQueue then
		self.fields.builder:runHammerAni()
	end
end
function builderIcon:showChargeTime()
	if not self.fields.builder:isGoldBuilder() then
		return
	end
	self:stopActionByTag(11)
	local buildchargequeue = cityCtrl:getCurCity():queryQueue(self.queueType)
	if buildchargequeue then
		self.fields.builderTime:setTimeTitle(i18n("common_text_844"))
		self.fields.builderTime:setTime(buildchargequeue.timerNode.timer:getRemainTime())
		self.fields.builderTime:setVisible(true)
		self.fields.builderTime:setTimeVisble(true)
		_ENV = self.fields.builderTime
		self.fields.builderTime[1] = ffa.delay(5)
		self.fields.builderTime[2] = ffa.callFunc(function()
			self.fields.builderTime:setVisible(false)
			self.fields.builderTime:setTimeVisble(false)
		end)
		self.fields.builderTime[3] = ffa.callFunc(function()
			self.fields.builderTime:setVisible(false)
			self.fields.builderTime:setTimeVisble(false)
		end)
		local showAct = ffa.seq(self.fields.builderTime)
		showAct:setTag(11)
		self:runAction(showAct)
	end
end
function builderIcon:getBuilderType()
	return self.queueType
end
function builderIcon:onBtnClick()
	if self.queueType == gQueueTypeDef.garden_technology or self.queueType == gQueueTypeDef.garden_build_upgrade then
		self:onClickGardenBuilder()
		return
	end
	if self.queueType == gQueueTypeDef.charge_build_queue then
		SoraDPlaySound("uicontrol", 16)
	else
		SoraDPlaySound("uicontrol", 15)
	end
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	if self.queue then
		if self.fields.builder:getControl2Index() == 2 then
			queueCtrl:speedUpQueueReq(tonumber(self.queueType), SPEEDUP_TYPE.FREE)
		end
		_ENV = queueCtrl
		queueCtrl.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		queueCtrl.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_NO_HAND
		queueCtrl.bid = tonumber(self.queue.data.bid)
		queueCtrl.iid = tonumber(self.queue.data.iid)
		queueCtrl.delay = 0.3
		SoraDSendMessage(queueCtrl)
	elseif self.queueType == gQueueTypeDef.charge_build_queue then
		local buildchargequeue = cityCtrl:getCurCity():queryQueue(self.queueType)
		if buildchargequeue then
			self:showChargeTime()
			buildLogic.builderIsLeisure()
		else
			if not rechargeActivityCtrl:getMonthActivityList() then
				local _ENV, monthData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
			end
			local itemId = 500501
			local itemCount = backpackCtrl:getItemCount(itemId)
			local style = 1
			if next(monthData) then
				style = 0 < itemCount and 1 or 2
			else
				style = 0 < itemCount and 3 or 4
			end
			_ENV = 3
			;(3)[1] = i18n("building_worker_text_01")
			_ENV = nil
			;(nil).var1 = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
			;(nil).var2 = BUILDER_WORK_TIME
			;(3)[2] = i18n("building_worker_text_02", nil)
			;(3)[3] = i18n("building_worker_text_03")
			_ENV = nil
			;(nil).var1 = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
			;(nil).var2 = BUILDER_WORK_TIME
			local (3)[4], msgTb = i18n("building_worker_text_04", nil), 3
			_ENV = BUILDER_WORK_TIME
			BUILDER_WORK_TIME.style = style
			BUILDER_WORK_TIME.msg = msgTb[style]
			uiManager:show("BuilderActivePop", BUILDER_WORK_TIME)
		end
	elseif self.queueType == gQueueTypeDef.build_star_queue or self.queueType == gQueueTypeDef.build_star_queue_privilege then
		buildLogic.starBuilderIsLeisure()
	else
		buildLogic.builderIsLeisure()
	end
end
function builderIcon:onClickGardenBuilder()
	SoraDPlaySound("uicontrol", 15)
	if self.queue then
		if self.queueType == gQueueTypeDef.garden_build_upgrade then
			local buildID = tonumber(self.queue.data.bid)
			local iid = tonumber(self.queue.data.iid)
			_ENV = nil
			;(nil).msg = "MESSAGE_MANOR_BUILD_JUMP"
			;(nil).buildID = buildID
			;(nil).iid = iid
			;(nil).showFinger = true
			SoraDSendMessage(nil)
		elseif self.queueType == gQueueTypeDef.garden_technology then
			_ENV = gQueueTypeDef.garden_technology
			gQueueTypeDef.garden_technology.msg = "MESSAGE_MANOR_BUILD_JUMP"
			gQueueTypeDef.garden_technology.buildID = MANOR_BUILD_ID.SMART_PALACE
			gQueueTypeDef.garden_technology.showFinger = true
			SoraDSendMessage(gQueueTypeDef.garden_technology)
		end
	elseif self.queueType == gQueueTypeDef.garden_build_upgrade then
		SoraDShowMsgTip(i18n("garden_text_25"))
	elseif self.queueType == gQueueTypeDef.garden_technology then
		SoraDShowMsgTip(i18n("garden_text_26"))
		_ENV = i18n("garden_text_26")
		i18n("garden_text_26").msg = "MESSAGE_MANOR_BUILD_JUMP"
		i18n("garden_text_26").buildID = MANOR_BUILD_ID.SMART_PALACE
		i18n("garden_text_26").opType = 21
		SoraDSendMessage(i18n("garden_text_26"))
	end
end
return builderIcon
