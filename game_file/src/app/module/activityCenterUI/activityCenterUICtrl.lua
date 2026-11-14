local GameModule = include("GameModule")
local activityCenterUICtrl = class("activityCenterUICtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").NO_HAVE_NEW_FLAG = "0"
local ("msgCtrl").HAVE_NEW_FLAG, FLAG_TYPE = "1", "msgCtrl"
function activityCenterUICtrl:ctor(properties)
	activityCenterUICtrl.super.ctor(self, properties)
end
function activityCenterUICtrl:EnterGame()
	self.activityCenterUIData, msgCtrl = nil, nil
	msgCtrl.register(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_INIT, handler(self, self.initResp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_CLEAR_NEW, handler(self, self.clearNewResp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_CLEAR_NEW_LIST, handler(self, self.clearNewListResp))
end
function activityCenterUICtrl:resetData()
	self.activityCenterUIData = nil
	self.handle_notify = nil
end
function activityCenterUICtrl:Logout()
	self.activityCenterUIData, activityCenterUICtrl = nil, nil
	activityCenterUICtrl.super.Logout(self)
end
function activityCenterUICtrl:initClientData(data)
	if not data then
		return
	end
	self.activityCenterUIData = data
	self:registerNotify()
end
function activityCenterUICtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ACTIVITY_CENTER_UI, handler(self, self.notifyFun))
end
function activityCenterUICtrl:notifyFun(event)
	local content = event.data[1]
	dump(content, "activityCenterUICtrl:notifyFun")
	if content and content.index then
		local index = content.index
		if not self.activityCenterUIData then
			_ENV = self.activityCenterUIData
		end
		self.activityCenterUIData = self.activityCenterUIData
		self.activityCenterUIData[tostring(index)] = content.flag
		_ENV = tostring(index)
		tostring(index).msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		tostring(index).eid = index
		SoraDSendMessage((tostring(index)))
		if tostring(index) == "8001021" then
			_ENV = index
			index.msg = "MESSAGE_MAINCITYVIEW_SHOW_COMMUNITYCENTER_MSG"
			SoraDSendMessage(index)
		end
	end
end
function activityCenterUICtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_INIT)
end
function activityCenterUICtrl:sendClearNewMsg(index)
	if self:isHaveNewFlag(index) then
		if gActivityCenterUIEnum.FIVE_ANNIVERSARY == index then
			self:sendClearNewListMsg(index)
			return
		end
		local _ENV, data = self.sendClearNewListMsg, self.sendClearNewListMsg
		data.index = index
		serverproxy:Request(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_CLEAR_NEW, data)
	end
end
function activityCenterUICtrl:sendClearNewListMsg(index)
	if type(index) ~= "table" then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local group = activityShowCtrl:getActivityGroup(tonumber(index))
		local _ENV, indexList = activityShowCtrl, activityShowCtrl
		for id, v in pairs(group) do
			table.insert(indexList, id)
		end
		index = indexList
	end
	local _ENV, data = activityShowCtrl, SoraDGetCtrl("activityShowCtrl")
	data.indexList = index
	serverproxy:Request(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_CLEAR_NEW_LIST, data)
end
function activityCenterUICtrl:sendClearNewList2Msg(list)
	print("fhfhjjjajkak")
	local _ENV, data = print, print
	data.indexList = list
	serverproxy:Request(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_CENTER_UI_CLEAR_NEW_LIST, data)
end
function activityCenterUICtrl:initResp(ret)
end
function activityCenterUICtrl:clearNewResp(ret)
	dump(ret, "activityCenterUICtrl:clearNewResp")
	if ret and ret.data then
		local index = ret.data.index
		if index then
			if gActivityCenterUIEnum.LEGEND_HEGEMON == index then
				if self.activityCenterUIData[tostring(gActivityTimeActivityID.LEGEND_HEGEMON_6)] == FLAG_TYPE.HAVE_NEW_FLAG then
					self.activityCenterUIData[tostring(gActivityTimeActivityID.LEGEND_HEGEMON_6)] = FLAG_TYPE.NO_HAVE_NEW_FLAG
				end
			else
				self.activityCenterUIData[tostring(index)] = FLAG_TYPE.NO_HAVE_NEW_FLAG
			end
			_ENV = tostring(index)
			tostring(index).msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
			tostring(index).eid = index
			tostring(index).removeNew = true
			SoraDSendMessage((tostring(index)))
			_ENV = tostring(index)
			tostring(index).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			tostring(index).eventID = index
			SoraDSendMessage((tostring(index)))
			if index == gActivityCenterUIEnum.MAIN_CITY_BILLBOARD then
				_ENV = tostring(index)
				tostring(index).msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
				SoraDSendMessage((tostring(index)))
			end
		end
	end
end
function activityCenterUICtrl:clearNewListResp(ret)
	dump(ret, "activityCenterUICtrl:clearNewListResp")
	if ret and ret.data then
		local indexList = ret.data.indexList
		if indexList then
			for i, index in ipairs(indexList) do
				self.activityCenterUIData[tostring(index)] = FLAG_TYPE.NO_HAVE_NEW_FLAG
			end
			_ENV = ipairs(indexList)
			ipairs(indexList).msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
			SoraDSendMessage(ipairs(indexList))
			_ENV = ipairs(indexList)
			ipairs(indexList).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			SoraDSendMessage(ipairs(indexList))
		end
	end
end
function activityCenterUICtrl:isHaveNewFlag(index)
	if self.activityCenterUIData then
		if gActivityCenterUIEnum.LEGEND_HEGEMON == index then
			local isNew = false
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			if self.activityCenterUIData[tostring(gActivityTimeActivityID.LEGEND_HEGEMON_6)] == FLAG_TYPE.HAVE_NEW_FLAG and activityShowCtrl:isActivityOpen(gActivityTimeActivityID.LEGEND_HEGEMON_6) then
				isNew = true
			end
			return isNew
		end
		if gActivityTimeActivityID.VALUE_REBATE_ACTIVITY == index then
			local isNew = false
			if self.activityCenterUIData[tostring(gActivityTimeActivityID.VALUE_REBATE_ACTIVITY)] == FLAG_TYPE.HAVE_NEW_FLAG then
				isNew = true
			end
			return isNew
		end
		_UPVALUE5_ = isNew
		;(true)[1] = gActivityCenterUIEnum.COMMUNITY_CENTER_1
		;(true)[2] = gActivityCenterUIEnum.COMMUNITY_CENTER_2
		;(true)[3] = gActivityCenterUIEnum.COMMUNITY_CENTER_3
		;(true)[4] = gActivityCenterUIEnum.COMMUNITY_CENTER_4
		local (true)[5], idList = gActivityCenterUIEnum.COMMUNITY_CENTER_5, true
		if tonumber(index) == gActivityTimeActivityID.COMMUNITY_CENTER then
			local h5ActivityCtrl = SoraDGetCtrl("h5ActivityCtrl")
			local communityData = h5ActivityCtrl:getCommunityCenterData()
			if next(communityData) then
				for i, v in ipairs(communityData.info) do
					if v.newFlag then
						return true
					end
				end
			end
		end
		_ENV = h5ActivityCtrl
		SoraDGetCtrl("h5ActivityCtrl")[gActivityCenterUIEnum.FIVE_ANNIVERSARY] = true
		SoraDGetCtrl("h5ActivityCtrl")[gActivityCenterUIEnum.SULTAN_BACK] = true
		local SoraDGetCtrl("h5ActivityCtrl")[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY], groupIDMap = true, SoraDGetCtrl("h5ActivityCtrl")
		if groupIDMap[tonumber(index)] then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local group = activityShowCtrl:getActivityGroup(tonumber(index))
			for id, v in pairs(group) do
				if self:isHaveNewFlag(id) then
					return true
				end
			end
		end
		if tonumber(index) == gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY and SoraDGetCastleLv() >= CASTLE_LV110_LIMITED then
			local shiftingstarsRead = include("shiftingstarsRead")
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY) and shiftingstarsRead.getActsNewFlag() then
				return true
			end
		end
		if tonumber(index) == gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			local anniversaryRead = include("anniversaryRead")
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY) and anniversaryRead.getActsNewFlagEX() then
				return true
			end
		end
		if self.activityCenterUIData[tostring(index)] == FLAG_TYPE.HAVE_NEW_FLAG then
			if tonumber(index) == gActivityCenterUIEnum.STRONGEST_LORD then
				local activityCtrl = gametop.playertop_:getModule("activityCtrl")
				if gActivityState.OPEN == activityCtrl.activityState then
					return true
				end
			elseif tonumber(index) == gActivityCenterUIEnum.ROME_ACTIVITY then
				local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
				if gRomeActivityState.OPEN == romeActivityCtrl.activityState then
					return true
				end
			elseif tonumber(index) == gActivityCenterUIEnum.HERO_TRIAL then
				return false
			elseif tonumber(index) == gActivityCenterUIEnum.KINGDOM_BATTLE then
				local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
				if conquestWarCtrl:getConquestWarState() ~= gConquestWarState.LOCK then
					return true
				end
			elseif tonumber(index) == gActivityCenterUIEnum.LEGEND_LORD then
				local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
				local param = activityShowCtrl:getParamByID(index)
				if param and param.curState == ACTIVITY_STATE.ACTIVE then
					return true
				end
			elseif tonumber(index) == gActivityCenterUIEnum.KING_STAR_BATTLE then
				local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
				local param = activityShowCtrl:getParamByID(index)
				if param and param.curState == ACTIVITY_STATE.ACTIVE then
					return true
				end
			elseif tonumber(index) == gActivityTimeActivityID.PYRAMID_BATTLE_PBL then
				return true
			elseif tonumber(index) == gActivityCenterUIEnum.MAIN_CITY_BILLBOARD then
				return true
			else
				for i, v in ipairs(idList) do
					if v == index then
						return true
					end
				end
				local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
				if activityShowCtrl:isActivityOpen(index) then
					return true
				end
			end
		end
	end
	return false
end
return activityCenterUICtrl
