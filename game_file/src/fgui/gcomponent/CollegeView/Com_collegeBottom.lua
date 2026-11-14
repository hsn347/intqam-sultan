local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_collegeBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_collegeBottom", Com_collegeBottom)
function Com_collegeBottom:onInit()
	self.fields.Lab_title:setString(i18n("Technology_text_01"))
	self.fields.Text_noRecommend:setString(i18n("Technology_text_02"))
	self.fields.Text_noRecommend:setVisible(false)
	self.fields.Text_luckyDes:setVisible(false)
	self.fields.Text_luckyDes = SoraDCreateTimerLabel(self, self.fields.Text_luckyDes)
	self.fields.com_recommend1:fixPos()
	self.fields.com_recommend2:fixPos()
end
function Com_collegeBottom:onShow()
end
function Com_collegeBottom:setControllers(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Com_collegeBottom:initRecommendData()
	self.recommendData = technologyCtrl:getRecommendTech()
	self.fields.Text_noRecommend:setVisible(false)
	if #self.recommendData == 2 then
		self.fields.com_recommend1:setVisible(true)
		self.fields.com_recommend1:initData(self.recommendData[1])
		self.fields.com_recommend2:setVisible(true)
		self.fields.com_recommend2:initData(self.recommendData[2])
		self.fields.nline:setVisible(true)
	elseif #self.recommendData == 1 then
		self.fields.com_recommend1:setVisible(true)
		self.fields.com_recommend1:initData(self.recommendData[1])
		self.fields.com_recommend2:setVisible(false)
		self.fields.nline:setVisible(true)
	else
		self.fields.com_recommend1:setVisible(false)
		self.fields.com_recommend2:setVisible(false)
		self.fields.Text_noRecommend:setVisible(true)
		self.fields.nline:setVisible(false)
	end
end
function Com_collegeBottom:setStudyingQueue(tableStuding, queue)
	self.fields.com_studying:initData(tableStuding, queue)
end
function Com_collegeBottom:refreshWaitQueue()
	local isPrivilege = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.TECHNOLOGY_QUEUE)
	self.fields.com_waiting:setVisible(isPrivilege and true or false)
	if isPrivilege then
		local waitQueue = waitQueueCtrl:getWaitQueueData(gQueueTypeDef.technology_upgrade_queue)
		if waitQueue then
			self.fields.com_waiting:initData(waitQueue.technologyId)
		else
			self.fields.com_waiting:initData()
		end
	end
end
function Com_collegeBottom:updateLuckyBless()
	self.luckyData = luckyBlessCtrl:getLuckyData()
	if self.luckyData.curEffectType == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH then
		self.fields.Text_luckyDes:setVisible(true)
		self.fields.Text_luckyDes:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).num = string.format("%d%%", self.luckyData.discount / 10)
			;(nil).time = strTime
			return i18n("lucky_text_19", nil)
		end)
		local leftTime = luckyBlessCtrl:getRealTime()
		self.fields.Text_luckyDes:beginTime(leftTime)
	else
		self.fields.Text_luckyDes:endTime()
		self.fields.Text_luckyDes:setVisible(false)
	end
end
return Com_collegeBottom
