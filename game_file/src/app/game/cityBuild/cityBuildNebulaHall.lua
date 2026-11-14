local cityBuildBaseEntity = include("cityBuildBaseEntity")
local buildLogic = include("buildLogic")
local cityBuildNebulaHall = class("cityBuildNebulaHall", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
local cityBuildConstDef = include("cityBuildConstDef")
local BUBBLE_ACTION_TAG = 994
function cityBuildNebulaHall:ctor()
	self.isFuncLocked = true
end
function cityBuildNebulaHall:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_NEBULA_PALACE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_UPDATE_LOGIN_REWARD", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.updateTechUpTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END", handler(self, self.updateTechUpTip))
end
function cityBuildNebulaHall:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_305"), i18n("buildDes_name_305")
	i18n("buildDes_name_305").x = 0
	;(nil).pos, i18n("buildDes_name_305").y = i18n("buildDes_name_305"), -100
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildNebulaHall:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_NEBULA_PALACE")
	self:updateView()
end
function cityBuildNebulaHall:updateView()
	local isLocked = self:getIsLocked()
	self.isFuncLocked = isLocked
	if isLocked then
		self:hideBuildLv()
		local queue = self:getQueue()
		if queue then
			local queueCtrl = SoraDGetCtrl("queueCtrl")
			queueCtrl:removeQueue(queue.qtype)
			_ENV = queueCtrl
			queueCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
			queueCtrl.buildIndex = self.buildIndex
			queueCtrl.buildEntity = self
			queueCtrl.isCancel = true
			SoraDSendMessage(queueCtrl)
			_ENV = queueCtrl
			queueCtrl.msg = "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK"
			queueCtrl.queueType = queue.qtype
			queueCtrl.optype = tostring(QUEUE_OPERATE_TYPE.CANCLE)
			queueCtrl.bid = BUILDID.NEBULA_PALACE
			SoraDSendMessage(queueCtrl)
		end
		self:setIsCanUpgrade(false)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(self)
	else
		self:udpateIsCanUpGrade()
		self:showBuildLv()
		self:updateLv()
	end
	self:updateIsLock()
	self:updateDailyReward()
	self:updateTechUpTip()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getKingdomRegionType()
	if isLocked and regionType ~= NEBULA_REGION_TYPE.HEGEMONY_REGION then
		self:hideBuildLock()
	end
end
function cityBuildNebulaHall:updateDailyReward()
	local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
	if loginRewardCtrl:getIsCanReceiveNebulaReward1() or loginRewardCtrl:getIsCanReceiveNebulaReward2() then
		SoraDDelayCallOnce("technologyCtrl_updateTotalTechnology", function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			;(nil).buildIndex = self.buildIndex
			;(nil).buildEntity = self
			;(nil).buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_REWARD
			SoraDSendMessage(nil)
		end, 1)
	else
		_ENV = "technologyCtrl_updateTotalTechnology"
		;("technologyCtrl_updateTotalTechnology").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;("technologyCtrl_updateTotalTechnology").buildIndex = self.buildIndex
		;("technologyCtrl_updateTotalTechnology").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_REWARD
		SoraDSendMessage("technologyCtrl_updateTotalTechnology")
	end
end
function cityBuildNebulaHall:updateTechUpTip()
	if self.isFuncLocked then
		return
	end
	self:stopActionByTag(BUBBLE_ACTION_TAG)
	_ENV = self
	self[1] = cca.delay(1.0)
	self[2] = cca.callFunc(handler(self, self.updateTechUpTipEx))
	self[3] = cca.callFunc(handler(self, self.updateTechUpTipEx))
	self[4] = cca.callFunc(handler(self, self.updateTechUpTipEx))
	self[5] = cca.callFunc(handler(self, self.updateTechUpTipEx))
	local action = cca.seq(self)
	action:setTag(BUBBLE_ACTION_TAG)
	self:runAction(action)
end
function cityBuildNebulaHall:updateTechUpTipEx()
	if self:getQueue() == nil then
		local technologyLocalData = include("technologyLocalData")
		local newbulaShow = technologyLocalData.getNebulaShow()
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		for i, v in ipairs(newbulaShow) do
			local blv = cityCtrl:getBuildMaxLv(v.lv.bid)
			if blv and blv >= v.lv.lv then
				for i = 1, 4 do
					local tid = v.technologyID[i]
					if tid ~= 0 and self:getIsTechCanUp(tid) then
						_ENV = self
						self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
						self.buildIndex = self.buildIndex
						self.buildEntity = self
						self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_UP
						SoraDSendMessage(self)
						return
					end
				end
			else
				break
			end
		end
	end
	_ENV = technologyLocalData.getNebulaShow()
	technologyLocalData.getNebulaShow().msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
	technologyLocalData.getNebulaShow().buildIndex = self.buildIndex
	technologyLocalData.getNebulaShow().buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_NEBULA_TECH_UP
	SoraDSendMessage((technologyLocalData.getNebulaShow()))
end
function cityBuildNebulaHall:getIsTechCanUp(tid)
	if tid ~= 0 then
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		local tableSingleData = technologyCtrl:getTechnoDataByID(tid, "nebula")
		if tableSingleData == nil or tableSingleData.currentLevel >= tableSingleData.maxLevel then
			return false
		end
		local singleDetails = technologyCtrl:getTechnologyDetails(tid, tableSingleData.currentLevel)
		if singleDetails.build then
			for i, v in ipairs(singleDetails.build) do
				if not v.isContentmented then
					return false
				end
			end
		end
		if singleDetails.starbuild then
			for i, v in ipairs(singleDetails.starbuild) do
				if not v.isContentmented then
					return false
				end
			end
		end
		if singleDetails.tech then
			for i, v in ipairs(singleDetails.tech) do
				if not v.isContentmented then
					return false
				end
			end
		end
		if singleDetails.resources then
			for i, v in ipairs(singleDetails.resources) do
				if not v.isContentmented then
					return false
				end
			end
		end
		if singleDetails.wartool then
			for i, v in ipairs(singleDetails.wartool) do
				if not v.isContentmented then
					return false
				end
			end
		end
		return true
	end
	return false
end
function cityBuildNebulaHall:updateLoginReward()
	local loginRewardCtrl = include("loginRewardCtrl")
	loginRewardCtrl:sendInitMsg()
end
return cityBuildNebulaHall
