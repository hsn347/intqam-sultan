local buildLogic = include("buildLogic")
local armyLogic = include("armyLogic")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local heroTrainGroundCtrl = SoraDGetCtrl("heroTrainGroundCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_timeSpeed = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://commonSpeedUpByItemBox/Com_timeSpeed", Com_timeSpeed)
function Com_timeSpeed:onInit()
	self.goldPay = 0
	self.isFree = false
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(handler(self, self.updateView))
	self.Text_time:setTimeEndListener(handler(self, self.closeView))
	self.fields.Btn_cost:addClickListener(handler(self, self.onCostBack))
	self.fields.Btn_cancel:setString(i18n("common_text_386"))
	self.fields.Btn_cancel:addClickListener(handler(self, self.onCancelBack))
	self.fields.Btn_cost:fixPos()
	self.fields.Btn_cancel:fixPos()
end
function Com_timeSpeed:onShow()
end
function Com_timeSpeed:initData(parent, _type, itemType, queue, speed, position)
	self.type = _type
	self.itemType = itemType
	self.queue = queue
	self.position = position
	self.parent = parent
	local leftTime = 0
	self.totalTime = 0
	if self.position then
		local _cur, _total = heroTrainGroundCtrl:getPositionTrainTime(self.position)
		leftTime = _cur
		self.totalTime = _total
		self.controllers.c1:setSelectedIndex(1)
	else
		self.totalTime = self.queue.ottime or self.queue.totaltime
		leftTime = self.queue.timerNode.timer:getRemainTime()
		self.controllers.c1:setSelectedIndex(0)
	end
	if self.type == gQueueTypeDef.radiance_war_hostpital_queue then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
	if speed then
		self.fields.Btn_cost:setString(speed)
	end
	self.fields.Bar_timer:fixPos()
	self.fields.Bar_timer:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Text_time:fixPos()
	self.fields.Bar_timer:setMax(self.totalTime)
	self.Text_time:beginTime(math.ceil(leftTime))
	self:checkFreeTime()
end
function Com_timeSpeed:updateView(time)
	self.Text_time:setString(SoraDConvertSecondToString(time))
	self.goldPay = serviceFunctions.timeConvertToGold(time, armyLogic.isArmyQueueType(self.type))
	self.fields.Btn_cost:setCostTitle(string.formatnumberthousands(math.floor(self.goldPay)))
	self.fields.Bar_timer:setValue(self.totalTime - time)
	self:checkFreeTime()
end
function Com_timeSpeed:closeView()
	_ENV = nil
	;(nil).msg = "MESSAGE_ITEM_SPEED_UP_BACK"
	;(nil).isTimeEnd = true
	SoraDSendMessage(nil)
end
function Com_timeSpeed:checkFreeTime()
	if self.itemType == gAbbrSpeedUpType.BUILD_UPGRADE then
		if self.type == gQueueTypeDef.garden_build_upgrade then
			return
		end
		local freeSpeedUpTime = buildLogic.getFreeSpeedUpTime(self.queue.data.lv)
		local leftTime = self.queue.timerNode.timer:getRemainTime()
		if self:checkIsUpgradeStar() then
			freeSpeedUpTime = buildLogic.getFreeStrongTime()
		end
		self.isFree = leftTime <= freeSpeedUpTime
		if self.isFree then
			self.fields.Btn_cost:setFree()
		end
	elseif self.itemType == gAbbrSpeedUpType.TECH then
		local freeSpeedUpTime = technologyCtrl:getFreeSpeedUpTime(self.type)
		local leftTime = self.queue.timerNode.timer:getRemainTime()
		self.isFree = freeSpeedUpTime >= leftTime
		if self.isFree then
			self.fields.Btn_cost:setFree()
		end
	end
end
function Com_timeSpeed:isFreeModel()
	return self.isFree
end
function Com_timeSpeed:checkIsUpgradeStar()
	if self.type == gQueueTypeDef.build_star_queue or self.type == gQueueTypeDef.build_star_queue_privilege or self.type == gQueueTypeDef.glorious_upgrade then
		return true
	end
end
function Com_timeSpeed:onCostBack()
	SoraDPlaySound()
	if not self.fields.Btn_cost:isBright() then
		local cdQueue = armyCtrl:getHostpitalPyramidWarCDQueueTime()
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(cdQueue)
		SoraDShowMsgTip(i18n("common_text_3251", nil))
	elseif self.isFree then
		queueCtrl:speedUpQueueReq(tonumber(self.queue.qtype), SPEEDUP_TYPE.FREE)
	else
		SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"))
	end
end
function Com_timeSpeed:onCancelBack()
	SoraDPlaySound()
	if self.itemType == gAbbrSpeedUpType.CURE_WAR then
		local radianceWarUtil = include("radianceWarUtil")
		radianceWarUtil.cancelWarHospitalCure()
	end
	self.parent:close()
end
return Com_timeSpeed
