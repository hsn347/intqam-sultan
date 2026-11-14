local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local endlessTrialsBossList = class("endlessTrialsBossList", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("endlessTrialsBossList")
	end
	return target
end)
function endlessTrialsBossList:ctor()
	self:initWidget()
	local protalInfo = endlessTrialsCtrl:getProtalInfo()
	if protalInfo and next(protalInfo) then
		self:initData()
	end
	endlessTrialsCtrl:reqBossInfo()
end
function endlessTrialsBossList:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALSVIEW_REFRESH", handler(self, self.initData))
end
function endlessTrialsBossList:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Endless_trial_text_06"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCCS("endlessTrialsBossSingle")
	self.scrollUp = SoraDGetChildByName(self, "ScrollView_up")
	self.scrollUp = SoraDCreatePanelByCloneNode(self.scrollUp, "commonAutoScrollList")
	self.scrollUp:setSingleCCS("endlessTrialsBossSingle")
	self.scrollUp:setSwallowTouches(false)
	self.scroll:setBounceEnabled(false)
	self.scrollUp:setBounceEnabled(false)
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.scaleActTarget)
	effect:setPosition(0, -164)
	effect:setScaleY(self.ccs_bg:getSize().height / 635)
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeEndListener(handler(self, self.refreshTime))
	self:refreshTime()
end
function endlessTrialsBossList:initData()
	local list = endlessTrialsCtrl:getMountainConfig()
	endlessTrialsCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).isDown = true
	self.scroll:updateScrollView(cc.size(537, 225), list, 1, nil)
	endlessTrialsCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).isUp = true
	self.scrollUp:updateScrollView(cc.size(537, 225), list, 1, nil)
end
function endlessTrialsBossList:refreshTime(...)
	local leftTime = endlessTrialsCtrl:getNextRefreshTime()
	if leftTime then
		self.Text_time:setTimeLast(function(ticket)
			return i18n("Endless_trial_text_07") .. ticket
		end)
		self.Text_time:beginTime(leftTime)
	else
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("common_text_607", nil)
		end)
		leftTime = endlessTrialsCtrl:getActivityRemainTime()
		self.Text_time:beginTime(leftTime)
	end
end
return endlessTrialsBossList
