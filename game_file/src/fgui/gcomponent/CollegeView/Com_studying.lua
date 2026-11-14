local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_studying = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_studying", Com_studying)
function Com_studying:onInit()
	self.fields.Button_detail:setString(i18n("common_text_059"))
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_studying:onShow()
end
function Com_studying:initData(data, queue)
	self.techID = data.technologyID
	self.queue = queue
	self.fields.Text_name:setString(collegeDesRead.getName(self.techID))
	self.fields.Image_techBg:setSpriteFrame(collegeDesRead.getBg(self.techID))
	self.fields.Image_icon:setSpriteFrame(collegeDesRead.getIcon(self.techID))
	self.fields.bar:setMax(self.queue.totaltime)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	self.fields.Text_time:beginTime(leftTime)
end
function Com_studying:timeUpdate(time)
	self.fields.bar:setValue(self.queue.totaltime - time)
end
function Com_studying:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("collegeDetailsView", nil)
end
return Com_studying
