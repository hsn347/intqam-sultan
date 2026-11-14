local GuideRunner = class("GuideRunner")
local guideCtrl
function GuideRunner:init()
	self:initData()
	self:initMessageListener()
end
function GuideRunner:destroy()
	SoraDRemoveMessageByTarget(self)
end
function GuideRunner:initData()
end
function GuideRunner:initMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYGUIDE_CONTINUE", handler(self, self.continueGuide))
	SoraDAddMessage(self, "MESSAGE_MAINCITYGUIDE_STEPBACK", handler(self, self.stepBack))
end
function GuideRunner:run(curGuideStepDatas, mainCityGuide)
	self.mainCityGuide = mainCityGuide
	self.guideStepDatas = curGuideStepDatas
	self.runIdx = 0
	self:continueGuide()
end
function GuideRunner:continueGuide()
	if self.runIdx == nil then
		return
	end
	self.runIdx = self.runIdx + 1
	local guideStepData = self.guideStepDatas[self.runIdx]
	if guideStepData == nil then
		self:guideEnd()
		return
	end
	if guideStepData.log then
		print("引导log:" .. guideStepData.log)
	end
	print("self.runIdx", self.runIdx)
	dump(guideStepData, "startGuide")
	self.mainCityGuide:setGuidingData(guideStepData)
	self.mainCityGuide[guideStepData.func](self.mainCityGuide, guideStepData.param)
	if self.runIdx == #self.guideStepDatas then
		self:guideEnd()
	end
end
function GuideRunner:stepBack()
	if self.runIdx == nil then
		return
	end
	self.runIdx = self.runIdx - 1
	self:continueGuide()
end
function GuideRunner:guideEnd()
	print("guideEnd ======= ")
end
return GuideRunner
