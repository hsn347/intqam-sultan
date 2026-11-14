local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildTrainHall = class("cityBuildTrainHall", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildTrainHall:ctor()
	print("create trainHall!!")
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_TrainHall)
	self.bid = BUILDID.HERO_TRAIN_GROUND
end
function cityBuildTrainHall:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_TRAIN_HALL_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_TRAINSUCCESS", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_STOPSUCCESS", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_GAINSUCCESS", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_NOTIFY", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_SPEEDSUCCESS", handler(self, self.msgUpdateView))
end
function cityBuildTrainHall:onAfterInitWithBuildCell()
	self:updateView()
end
function cityBuildTrainHall:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_123"), i18n("buildDes_name_123")
	i18n("buildDes_name_123").x = 0
	;(nil).pos, i18n("buildDes_name_123").y = i18n("buildDes_name_123"), -70
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildTrainHall:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildTrainHall:updateView()
	print("cityBuildTrainHall:updateView()------")
	self:updateIsLock()
	self:checkHasTraning()
	self:checkHasReward()
	self:checkHasCanTrain()
end
function cityBuildTrainHall:checkHasTraning()
	local gametop = gModuleMgr.getObject("gametop")
	local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
	local isHaveTraining = heroTrainGroundCtrl:isHaveTrainning()
	print("isHaveTraining=", isHaveTraining)
	if isHaveTraining then
		print("cityBuildTrainHall:checkHasTraning(): 添加训练特效")
		self:showEffect()
	else
		print("cityBuildTrainHall:checkHasTraning(): 删除特效")
		self:hideEffect()
	end
end
function cityBuildTrainHall:showEffect()
	if self.et_node then
		self.et_node:setVisible(true)
		return
	end
	_ENV, _ENV = self.et_node, self.et_node.setVisible
	self.et_node.plist = "et_diaoxiang_02.plist"
	_ENV, self.et_node.setVisible[1], self.et_node.scale = self.et_node, self.et_node, 0.68
	_ENV, self.et_node.plist = true, "et_mijinggezi_01.plist"
	;(true).x = 1.1
	_ENV, self.et_node.setVisible[2], self.et_node.scale, (true).y = self.et_node, self.et_node, true, 1.3
	self.et_node.setVisible[3], self.et_node.plist = self.et_node, "et_mijinggezi_03.plist"
	local param = self.et_node.setVisible
	self.et_node = SoraDCreateEffectNode(param)
	self.et_node:addTo(self, 3)
end
function cityBuildTrainHall:hideEffect()
	if self.et_node then
		self.et_node:setVisible(false)
	end
end
function cityBuildTrainHall:checkHasReward()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	if self:getIsCanSpeedUpFree() then
		return
	elseif self:getIsNeedReqHelp() then
		return
	end
	local hasReward = self:hasReward()
	if hasReward then
		print("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取")
		_ENV = "cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取"
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取").msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取").buildIndex = self.buildIndex
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取").buildEntity = self
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HERO_REWARD
		SoraDSendMessage("cityBuildTrainHall:checkHasReward():建筑顶上需要添加有奖励可以领取")
	else
		print("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取")
		_ENV = "cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取"
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取").buildIndex = self.buildIndex
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取").buildEntity = self
		;("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HERO_REWARD
		SoraDSendMessage("cityBuildTrainHall:checkHasReward():建筑顶上需要删除奖励可以领取")
	end
end
function cityBuildTrainHall:checkHasCanTrain()
	local hasCanTrain = self:hasCanTrain()
	if hasCanTrain then
		self:showZAnimation()
	else
		self:hideZAnimation()
	end
end
function cityBuildTrainHall:isCustomIdle()
	local isIdle = true
	if self:getIsLocked() then
		isIdle = false
	end
	if isIdle and self:hasReward() then
		isIdle = false
	end
	return isIdle
end
function cityBuildTrainHall:hasTraining()
	local gametop = gModuleMgr.getObject("gametop")
	local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
	return heroTrainGroundCtrl:isHaveTrainning()
end
function cityBuildTrainHall:hasReward()
	local gametop = gModuleMgr.getObject("gametop")
	local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
	local hasReward, hasCanTrain = heroTrainGroundCtrl:isExclamationOrisZZZ()
	print("hasReward, hasCanTrain = ", hasReward, hasCanTrain)
	return hasReward
end
function cityBuildTrainHall:hasCanTrain()
	local gametop = gModuleMgr.getObject("gametop")
	local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
	local hasReward, hasCanTrain = heroTrainGroundCtrl:isExclamationOrisZZZ()
	return hasCanTrain
end
return cityBuildTrainHall
