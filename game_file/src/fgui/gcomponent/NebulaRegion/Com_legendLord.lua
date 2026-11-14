local baseComponent = require("fgui.base.baseComponent")
local Com_legendLord = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaRegion/Com_legendLord", Com_legendLord)
local legendLordCtrl = SoraDGetCtrl("legendLordCtrl")
local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
function Com_legendLord:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.fields.Com_head:setHandle(handler(self, self.onTouchHeadBack))
	self.fields.Com_head:setSwallowTouches(true)
end
function Com_legendLord:onShow()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.onMsgUpdateKingInfo))
end
function Com_legendLord:getActivityID(...)
	return self.activityID
end
function Com_legendLord:updateView(activityID)
	local activityID = activityID or gActivityTimeActivityID.LEGEND_LORD
	self.activityID = activityID
	local legendLordActivityStatus = activityShowCtrl:getStateByID(activityID)
	self.controllers.c1:setSelectedIndex(0)
	if legendLordActivityStatus == gActivityState.PREPARE then
		self.text_time:setTimeLast(function(strTime)
			return i18n("common_text_608") .. strTime
		end)
		local timer = activityShowCtrl:getTimeInfoByID(activityID)
		if timer then
			self.controllers.c1:setSelectedIndex(1)
			local leftTime = timer.timerNode.timer:getRemainTime()
			self.text_time:beginTime(leftTime)
		else
			self:updateKingInfo(activityID)
		end
	elseif legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(activityID)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			self.text_time:setTimeLast(function(strTime)
				return i18n("common_text_2669") .. strTime
			end)
			local timer = activityShowCtrl:getTimeInfoByID(activityID)
			if timer then
				self.controllers.c1:setSelectedIndex(1)
				local leftTime = timer.timerNode.timer:getRemainTime()
				self.text_time:beginTime(leftTime)
			else
				self:updateKingInfo(activityID)
			end
		else
			self:updateKingInfo(activityID)
		end
	else
		self:updateKingInfo(activityID)
	end
end
function Com_legendLord:updateKingInfo(activityID)
	if activityID and worldMapDefine.isKingStarActivityID(activityID) then
		self.legendKingInfo = kingStarCtrl:getLegendKingInfo(activityID)
	else
		self.legendKingInfo = legendLordCtrl:getLegendKingInfo()
	end
	if self.legendKingInfo then
		self.playerInfo = self.legendKingInfo.playerInfo
	end
	if self.playerInfo then
		local allianceInfo = self.legendKingInfo.allianceInfo
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		local strInfo = ""
		if allianceInfo.abbr then
			_ENV = nil
			;(nil).abbr = allianceInfo.abbr
			;(nil).name = self.playerInfo.nickName
			strInfo = i18n("common_text_186", nil)
		else
			strInfo = self.playerInfo.nickName
		end
		strInfo = strInfo .. "#" .. kingdomInfo.kid
		self.controllers.c1:setSelectedIndex(2)
		_ENV = nil
		;(nil).name = strInfo
		self.fields.text_name:setString(i18n("legendaryking_text_07", nil))
		self.fields.Com_head:setHeadSprite(self.playerInfo.imageId, self.playerInfo.avatar)
		self.fields.Com_head:setSwallowTouches(true)
		self.kid = kingdomInfo.kid
		self.playerID = self.playerInfo.uid
	else
	end
end
function Com_legendLord:onMsgUpdateKingInfo(...)
	self:updateKingInfo(self.activityID)
end
function Com_legendLord:onTouchHeadBack()
	self.isHeadClicked = true
	self:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.isHeadClicked = false
	end)))
	_ENV = self
	self.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	self.playerID = self.playerID
	self.kid = self.kid
	SoraDSendMessage(self)
end
return Com_legendLord
