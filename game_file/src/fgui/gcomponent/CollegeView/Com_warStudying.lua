local queueCtrl = SoraDGetCtrl("queueCtrl")
local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_warStudying = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_warStudying", Com_warStudying)
function Com_warStudying:onInit()
	self.queueType = gQueueTypeDef.war_tech_research
	self.fields.Button_speedup:setString(i18n("common_text_018"))
	self.fields.Button_speedup:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self:fixChildrenPos()
	self.fields.n11:fix()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_warStudying:onShow()
end
function Com_warStudying:initData(data, studyingType, btnStr)
	self.techID = data.technologyID
	self.studyingType = studyingType
	self.queue = queueCtrl:queryQueue(self.queueType)
	if btnStr then
		self.fields.Button_speedup:setString(btnStr)
	end
	self.fields.com_tech:initData(self.techID, nil, self.queueType)
	self.fields.Text_techName:setString(collegeDesRead.getName(self.techID))
	self.fields.Text_techDes:setString(collegeDesRead.getDes(self.techID))
	self.fields.bar:setMax(self.queue.totaltime)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	self.fields.Text_time:beginTime(leftTime)
end
function Com_warStudying:timeUpdate(time)
	self.fields.bar:setValue(self.queue.totaltime - time)
end
function Com_warStudying:btnClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	;(nil).techType = self.studyingType
	;(nil).queueType = self.queueType
	uiManager:show("collegeDetailsView", nil)
end
return Com_warStudying
