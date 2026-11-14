local windTowerMainWidget = class("windTowerMainWidget", function(target)
	if target == nil then
		return SoraDCreateBasePanel("windTowerMainWidget")
	end
	return target
end)
function windTowerMainWidget:ctor()
	self.nodeLostRuins = SoraDGetChildByName(self, "Node_LostRuins")
	self.lostRuinsTaskIcon = SoraDGetChildByName(self.nodeLostRuins, "Image_TaskIcon")
	self.lostRuinsProgress = SoraDGetChildByName(self.nodeLostRuins, "Text_Progress")
	_G.SoraDChangeTextToHtml(self.lostRuinsProgress)
	self.lostRuinsTime = SoraDGetChildByName(self.nodeLostRuins, "Text_LeftTime")
	self.lostRuinsTime = SoraDCreateTimerLabel(self, self.lostRuinsTime)
	self.lostRuinsGetAwardBtn = SoraDGetChildByName(self.nodeLostRuins, "Button_LostGetAward")
	self.lostRuinsGetAwardBtn:addTouchEventListener(handler(self, self.btnLostRuinsGetAward))
	self.lostRuinsGetAwardBtn:setTitleText(i18n("common_text_1146"))
	self.textLostTaskStatus = SoraDGetChildByName(self.lostRuinsGetAwardBtn, "Text_LostTaskStatus")
	self.textLostTaskStatus:setString(i18n("common_text_2601"))
end
function windTowerMainWidget:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WIND_TOWER_REFRESH", handler(self, self.updateWindTowerNode))
end
function windTowerMainWidget:initData()
	self:updateWindTowerNode()
end
function windTowerMainWidget:updateWindTowerNode()
	local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
	local questInfo = windTowerCtrl:getRunningQuestInfo()
	print("updateWindTowerNode", _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOST_RUINS_ACTIVITY), windTowerCtrl:isRunningQuest())
	if _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WIND_TOWER_ACTIVITY, false) and next(questInfo) then
		self.nodeLostRuins:setVisible(true)
		if questInfo.finish then
			self.lostRuinsProgress:setVisible(false)
			self.textLostTaskStatus:setVisible(true)
			self.lostRuinsGetAwardBtn:setVisible(true)
			self.lostRuinsTime:getParent():setVisible(false)
		else
			self.lostRuinsProgress:setVisible(true)
			self.textLostTaskStatus:setVisible(false)
			self.lostRuinsGetAwardBtn:setVisible(false)
			self.lostRuinsTime:getParent():setVisible(true)
			self.lostRuinsTime:setTimeUpdateListener(function(leftTime)
				if leftTime <= 300 then
					self.lostRuinsTime:setColor(cc.c3b(254, 1, 1))
				else
					self.lostRuinsTime:setColor(display.COLOR_WHITE)
				end
			end)
			local leftTime = math.max(0, questInfo.endtime - serviceFunctions.systemTime())
			self.lostRuinsTime:beginTime(leftTime)
			local eventQuestRead = include("eventQuestRead")
			local progress = windTowerCtrl:getQuestProgress(questInfo.questId)
			local aim = eventQuestRead.getAim(questInfo.questId)
			print("updateWindTowerNode", questInfo.questId, progress, leftTime)
			_ENV = leftTime
			leftTime.member = progress
			_ENV, _ENV, leftTime.total = windTowerCtrl:isRunningQuest()
			windTowerCtrl:isRunningQuest().member, windTowerCtrl:isRunningQuest().color = windTowerCtrl:isRunningQuest()
			self.lostRuinsProgress:setString(_G.i18n_html("common_text_155", leftTime, windTowerCtrl:isRunningQuest()))
		end
	else
		self.nodeLostRuins:setVisible(false)
	end
end
function windTowerMainWidget:btnLostRuinsGetAward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 19)
		local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
		windTowerCtrl:reqWindTowerReward()
	end
end
return windTowerMainWidget
