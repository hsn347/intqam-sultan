local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local guideConfig = include("guideConfig")
local msgCtrl = include("msgCtrl")
local _ENV, REQ = "msgCtrl", "msgCtrl"
local _ENV, RSP
local guideCtrl = class("guideCtrl", gameModule)
function guideCtrl:setGuideData(data)
	if data then
		if data.status then
			self.guideModuleStatus = data.status
			dump(self.guideModuleStatus, "self.guideModuleStatus")
		end
		if data.performingStep then
			self.performingStep = data.performingStep
			dump(self.performingStep, "self.performingStep")
		end
	end
end
function guideCtrl:CompleteGuideStep(step, guideStep)
	local guideStep = guideStep ~= nil and guideStep or guideConfig.transformGuideStep(step)
	if guideStep and self.performingStep[guideStep] then
		self.performingStep[guideStep] = nil
		self.sendingStep = guideStep
		local nextGuideStep = guideConfig.getNextGuideStep(guideStep)
		if nextGuideStep then
			self.performingStep[nextGuideStep] = true
		else
			local guideModule = guideConfig.getGuideModule(guideStep)
			if guideModule then
				self.guideModuleStatus[guideModule] = gGuideStepStatus.COMPLETE
				self:updateNewGuide()
			end
		end
		REQ.reqCompleteGuide(guideStep)
		return true
	end
end
function guideCtrl:getCurForceGuideStep()
	local step, stepPriority
	for guideStep, _ in pairs(self.performingStep) do
		local guideModule = guideConfig.getGuideModule(guideStep)
		if self:isGuideNotCompleted(guideModule) and guideConfig.isForceToGuide(guideStep) then
			if not step then
				step = guideStep
				stepPriority = guideConfig.getGuidePriority(step)
			else
				local curStepPriority = guideConfig.getGuidePriority(guideStep)
				if stepPriority > curStepPriority then
					step = guideStep
					stepPriority = curStepPriority
				end
			end
		end
	end
	step = step and guideConfig.getViewStep(step)
	return step
end
function guideCtrl:getCurMainCityGuideStep()
	if self:isGuideNotCompleted(gGuideModule.MAIN_CITY_GUIDE) then
		for i, v in ipairs(gMainCityGuideModule) do
			if self.performingStep[v] then
				return v
			end
		end
	end
	return nil
end
function guideCtrl:updateNewGuide()
	print("==== guideCtrl:updateNewGuide")
	print(debug.traceback(10))
	local step = self:getCurForceGuideStep()
	if step == nil and self:getCurMainCityGuideStep() == nil and SoraDIsGameGuide() == nil and not SoraDCurrentTopPanelFromManager() and SoraDCurrentSceneShowView("mainCityView") then
		local newPlayerTaskCtrl = SoraDGetCtrl("newPlayerTaskCtrl")
		newPlayerTaskCtrl:updateGuideChapterReward()
	end
	if step then
		_ENV = newPlayerTaskCtrl.updateGuideChapterReward
		newPlayerTaskCtrl.updateGuideChapterReward.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		newPlayerTaskCtrl.updateGuideChapterReward.step = step
		SoraDSendMessage(newPlayerTaskCtrl.updateGuideChapterReward)
		return step
	else
		return nil
	end
end
function guideCtrl:isGuideNotCompleted(guideModule)
	if guideModule then
		local status = self.guideModuleStatus[guideModule]
		if status ~= gGuideStepStatus.COMPLETE then
			return true
		end
	end
end
function guideCtrl:isGuideOpen(guideModule)
	if guideModule then
		local status = self.guideModuleStatus[guideModule]
		if status == gGuideStepStatus.OPEN then
			return true
		end
	end
end
function guideCtrl:getStepByGuideModule(guideModule, trigger)
	local step
	print("getStepByGuideModule", guideModule)
	if self:isGuideNotCompleted(guideModule) then
		local guideStep = self:getNotCompletedGuideStep(guideModule)
		if guideStep then
			print("step###===", guideStep)
			step = guideConfig.getViewStep(guideStep, trigger)
		end
	end
	return step
end
function guideCtrl:getNotCompletedGuideStep(guideModule)
	if not self:isGuideNotCompleted(guideModule) then
		return
	end
	local begintStep = guideConfig.getGuideBeginStep(guideModule)
	local step = begintStep
	local loopLimit = 100
	local loopCount = 0
	while step and not self.performingStep[step] do
		step = guideConfig.getNextGuideStep(step)
		loopCount = loopCount + 1
		if loopLimit < loopCount then
			break
		end
	end
	return step
end
function guideCtrl:updateGuideModule(guideModule, withoutForce, trigger)
	if not withoutForce and self:getCurForceGuideStep() then
		print("self:getCurForceGuideStep()")
		return
	end
	local step = self:getStepByGuideModule(guideModule, trigger)
	print("step====", guideModule, step)
	if step then
		_ENV = print
		local print.guideModule, otherData = guideModule, print
		_ENV = guideModule
		guideModule.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		guideModule.step = step
		guideModule.otherData = otherData
		SoraDSendMessage(guideModule)
		return step
	end
	return nil
end
function guideCtrl:isDiscountStoreGuideOpening()
	if gGuideStepStatus.COMPLETE ~= self.guideModuleStatus[gGuideModule.DISCOUNT_STORE_GUIDE] then
		return true
	end
	return false
end
function guideCtrl:isStep(guideStep)
	if guideStep and self.performingStep[guideStep] then
		return true
	end
end
function guideCtrl:testCompleteGuide(guideStep)
	REQ.reqCompleteGuide(guideStep)
end
function guideCtrl:setSkipFirstFight(needSkip)
	self.isSkipFirstFight = needSkip
end
function REQ.reqInitGuideData()
	serverproxy:Request(gCmd.CMD_GUIDE_MODULE, gCmd.REQ_GUIDE_INITDATA)
end
function REQ.reqCompleteGuide(guideStep)
	local serverproxy, data
	data.guideStep = guideStep
	serverproxy:Request(gCmd.CMD_GUIDE_MODULE, gCmd.REQ_COMPLETE_GUIDE_STEP, data)
end
function RSP:initGuideDataRsp(content)
	self:setGuideData(content.data)
end
function RSP:completeGuideStepRsp(content)
	self:setGuideData(content.data)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYGUIDE_STEPEND"
	self.data = content.data
	self.guideStep = self.sendingStep
	SoraDSendMessage(self)
end
function RSP:guideUpdateDataRsp(content)
	local notifylist = content.data
	for i, notifyData in ipairs(notifylist) do
		local guideModule = notifyData.guideModule
		local guideData = notifyData.guideData
		local notifyType = notifyData.notifyType
		self:setGuideData(guideData)
		if "newGuideModule" == notifyType and gGuideModule.USE_ITEM_GUIDE ~= guideModule and gGuideModule.LORD_SKILL_GUIDE ~= guideModule then
			self:updateNewGuide()
		end
	end
end
function guideCtrl:checkGuide(guideModule)
	if not self:isGuideNotCompleted(guideModule) then
		return
	end
	if guideModule == gGuideModule.GLORIOUS_STATUE_GUIDE and SoraDGetBuildStarLv() >= 56 and SoraDCheckNoGuideNoPanelAndInMianCity() then
		self:updateGuideModule(guideModule)
	end
end
function guideCtrl:checkAllGuide(...)
	_UPVALUE1_ = nil
	local (nil)[1], guideModules = gGuideModule.GLORIOUS_STATUE_GUIDE, nil
	for __, guideModule in ipairs(guideModules) do
		self:checkGuide(guideModule)
	end
end
function guideCtrl:ctor(properties)
	guideCtrl.super.ctor(self, properties)
	self.performingStep, guideCtrl, self.guideModuleStatus, guideCtrl = guideCtrl.super.ctor, guideCtrl.super.ctor, guideCtrl.super.ctor, guideCtrl.super.ctor
end
function guideCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GUIDE_MODULE, gCmd.REQ_GUIDE_INITDATA, handler(self, RSP.initGuideDataRsp))
	msgCtrl.register(gCmd.CMD_GUIDE_MODULE, gCmd.REQ_COMPLETE_GUIDE_STEP, handler(self, RSP.completeGuideStepRsp))
end
function guideCtrl:resetData()
	self.performingStep, _UPVALUE0_, self.guideModuleStatus, _UPVALUE0_ = nil, nil, nil, nil
	self.isSkipFirstFight = nil
end
function guideCtrl:Logout()
	guideCtrl.super.Logout(self)
	self:resetData()
end
function guideCtrl:dump(description)
	print(description)
	print("\n")
end
function guideCtrl:initClientData(data)
	self:setGuideData(data)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.GUIDE, handler(self, RSP.guideUpdateDataRsp))
end
return guideCtrl
