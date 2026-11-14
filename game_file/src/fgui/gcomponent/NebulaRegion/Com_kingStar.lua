local baseComponent = require("fgui.base.baseComponent")
local Com_kingStar = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaRegion/Com_kingStar", Com_kingStar)
local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
function Com_kingStar:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.fields.Com_head:setHandle(handler(self, self.onTouchHeadBack))
	self.fields.Com_head:setSwallowTouches(true)
end
function Com_kingStar:onShow()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.onMsgUpdateKingInfo))
end
function Com_kingStar:getActivityID(...)
	return self.activityID
end
function Com_kingStar:updateView(activityID)
	local activityID = activityID or gActivityTimeActivityID.KING_STAR_BATTLE
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
			end
		else
			self:updateKingInfo()
		end
	else
		self:updateKingInfo()
	end
end
function Com_kingStar:updateKingInfo()
	self.legendKingInfo = kingStarCtrl:getLegendKingInfo(self.activityID)
	if self.legendKingInfo then
		self.playerInfo = self.legendKingInfo.playerInfo
	end
	if self.playerInfo then
		local allianceInfo = self.legendKingInfo.allianceInfo
		local kingdomInfo = self.legendKingInfo.kingdomInfo
		local strInfo = ""
		if allianceInfo.abbr then
			kingStarCtrl = nil
			;(nil).abbr = allianceInfo.abbr
			;(nil).name = self.playerInfo.nickName
			strInfo = i18n("common_text_186", nil)
		else
			strInfo = self.playerInfo.nickName
		end
		strInfo = strInfo .. "#" .. kingdomInfo.kid
		self.controllers.c1:setSelectedIndex(2)
		kingStarCtrl = nil
		;(nil).name = strInfo
		self.fields.text_name:setString(i18n("kingstarbattle_text_79", nil))
		self.fields.Com_head:setHeadSprite(self.playerInfo.imageId, self.playerInfo.avatar)
		self.fields.Com_head:setSwallowTouches(true)
		self.kid = kingdomInfo.kid
		self.playerID = self.playerInfo.uid
	else
	end
end
function Com_kingStar:onMsgUpdateKingInfo(...)
	self:updateKingInfo()
end
function Com_kingStar:onTouchHeadBack()
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
return Com_kingStar
