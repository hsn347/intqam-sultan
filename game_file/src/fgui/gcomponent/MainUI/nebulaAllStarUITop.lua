local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
local baseComponent = require("fgui.base.baseComponent")
local nebulaAllStarUITop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/nebulaAllStarUITop", nebulaAllStarUITop)
function nebulaAllStarUITop:onInit()
	self.rankType = RANK_TYPE.STAR_VALUE
	self.valueKey = nebulaAllStarRead.getRankTypeValueKey(self.rankType)
	self.PickPlunderMax = nebulaAllStarRead.getConstValue("PickPlunderMax", 2)
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_time:setTimeEndListener(function()
		self:updateTextTime()
	end)
	RANK_TYPE = nil
	;(nil).pos = ""
	self.fields.Text_pos:setString(i18n("NebulaAllstar_162", nil))
	self.fields.Text_pos2:addClickListener(handler(self, self.onClickBtnPos))
	self.fields.Com_occupyCamp = SoraDCreateTimerLabel(nil, self.fields.Com_occupyCamp)
	self.fields.Button_expand:addClickListener(handler(self, self.onClickBtnExpand))
	self.fields.Button_expand2:addClickListener(handler(self, self.onClickBtnExpand))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_rank:setString(i18n("common_text_2193"))
	_fields.Text_name:setString(i18n("common_text_2037"))
	_fields.Text_score:setString(i18n("common_text_1764"))
	_fields.Text_pos:setString(i18n("common_text_2588"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_troops:setItemRenderer(handler(self, self.onTroopstemRenderer))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Com_occupyCamp:fixChildrenPos()
		self.fields.Com_firstCamp:fixChildrenPos()
		self.fields.Button_expand2:fixChildrenPos()
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function nebulaAllStarUITop:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_WARDATA", handler(self, self.onMsgUpdateWarData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_WARDATA_NOTIFY", handler(self, self.onMsgWarDataNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_COLLECTING", handler(self, self.updateCampSpoliTroops))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SPOIL_DEL_MOVELINE", handler(self, self.updateCampSpoliTroops))
end
function nebulaAllStarUITop:onShow()
end
function nebulaAllStarUITop:initData(...)
	self:onMsgUpdateWarData()
end
function nebulaAllStarUITop:onMsgUpdateWarData(...)
	if not worldMapDefine.isInNebulaAllStar(true) then
		return
	end
	self:initTeamType()
	self:updateTextTime()
	self:updateRankFirstCamp()
	self:updateOccupyCamp()
	self:updateCampLeaderPos()
	self:updateCampSpoliTroops()
end
function nebulaAllStarUITop:initTeamType(...)
	if nebulaAllStarCtrl:getIsViewer() then
		self.fields.Button_expand:setVisible(false)
		self.fields.Button_expand2:setVisible(false)
	elseif nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam() then
		self.fields.Text_rank:setString(i18n("NebulaAllstar_110"))
		self.rankType = RANK_TYPE.STAR_VALUE
		self.valueKey = nebulaAllStarRead.getRankTypeValueKey(self.rankType)
	else
		self.fields.Text_rank:setString(i18n("NebulaAllstar_112"))
		self.rankType = RANK_TYPE.SUPPORT_VALUE
		self.valueKey = nebulaAllStarRead.getRankTypeValueKey(self.rankType)
	end
end
function nebulaAllStarUITop:onMsgWarDataNotify(target, event)
	if not worldMapDefine.isInNebulaAllStar(true) then
		return
	end
	local notifyType = event.notifyType
	if notifyType == "setCampOccupyPalaceSecs" then
		self:updateRankFirstCamp()
	elseif notifyType == "setWarBuildingOwner" then
		self:updateOccupyCamp()
	elseif notifyType == "setCampLeaderPos" then
		self:updateCampLeaderPos()
	end
end
function nebulaAllStarUITop:updateTextTime(...)
	local remainTime = nebulaAllStarCtrl:getWarTipRemainTime()
	if 0 < remainTime then
		self.fields.Text_time:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			return i18n("NebulaAllstar_11", nil)
		end)
		self.fields.Text_time:beginTime(remainTime)
		return
	end
	local remainTime = nebulaAllStarCtrl:getWarEndRemainTime()
	if 0 < remainTime then
		self.fields.Text_time:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			return i18n("NebulaAllstar_13", nil)
		end)
		self.fields.Text_time:beginTime(remainTime)
		return
	end
end
function nebulaAllStarUITop:updateOccupyTime(...)
end
function nebulaAllStarUITop:updateRankFirstCamp(firstCamp)
	if not firstCamp then
		local ret, camp = nebulaAllStarUtil.getRankFirstCampInfo()
		firstCamp = camp
	end
	if self.firstCamp == firstCamp then
		return
	end
	self.firstCamp = firstCamp
	local _fields = fguiHelper.get_fields(self.fields.Com_firstCamp)
	local showIcon = firstCamp and 0 < firstCamp
	if showIcon then
		local areaIcon = nebulaWarRead.getAreaIcon(firstCamp)
		_fields.icon:setURL(areaIcon)
		_fields.title:setString(i18n("NebulaAllstar_164"))
	else
		_fields.title2:setString(i18n("NebulaAllstar_164") .. i18n("hero_text_84"))
	end
	_fields.icon:setVisible(showIcon)
	_fields.title:setVisible(showIcon)
	_fields.title2:setVisible(not showIcon)
end
function nebulaAllStarUITop:updateOccupyCamp(...)
	local occupyCamp = nebulaAllStarUtil.getPalaceOwnerCamp()
	self.occupyCamp = occupyCamp
	local _fields = fguiHelper.get_fields(self.fields.Com_occupyCamp)
	local showIcon = occupyCamp and 0 < occupyCamp
	if showIcon then
		local areaIcon = nebulaWarRead.getAreaIcon(occupyCamp)
		_fields.icon:setURL(areaIcon)
		_fields.title:setString(i18n("NebulaAllstar_163"))
	else
		_fields.title2:setString(i18n("NebulaAllstar_163") .. i18n("hero_text_84"))
	end
	_fields.icon:setVisible(showIcon)
	_fields.title:setVisible(showIcon)
	_fields.title2:setVisible(not showIcon)
	self:updateFirstOccupySecs()
end
function nebulaAllStarUITop:updateFirstOccupySecs(...)
	if not (self.occupyCamp and self.firstCamp) or self.occupyCamp == self.firstCamp then
		self.fields.Com_occupyCamp:endTime()
		return
	end
	local campInfo1 = nebulaAllStarCtrl:getCampInfoByCamp(self.firstCamp)
	local firstOccupySecs = campInfo1.occupyPalaceSecs or 0
	local campInfo2 = nebulaAllStarCtrl:getCampInfoByCamp(self.occupyCamp)
	local curOccupySecs = campInfo2.occupyPalaceSecs or 0
	local owner = nebulaAllStarUtil.getPalaceOwner()
	local occupyTime = serviceFunctions.systemTime() - owner.beginOccupyTime
	curOccupySecs = curOccupySecs + math.max(0, occupyTime)
	self.fields.Com_occupyCamp:setTimeUpdateListener(function(timeStr, time)
		print("==curOccupySecs, firstOccupySecs==", curOccupySecs, firstOccupySecs)
		if curOccupySecs < firstOccupySecs then
			return
		end
		local dirty = false
		if curOccupySecs > firstOccupySecs then
			dirty = true
		elseif curOccupySecs == firstOccupySecs then
			local ret, camp = nebulaAllStarUtil.getRankFirstCampInfo()
			if camp == self.occupyCamp then
				dirty = true
			end
		end
		if dirty then
			self.fields.Com_occupyCamp:endTime()
			self:updateRankFirstCamp(self.occupyCamp)
			return
		end
	end)
	self.fields.Com_occupyCamp:beginTime(curOccupySecs - 1, true)
end
function nebulaAllStarUITop:updateCampLeaderPos(...)
	local pos = nebulaAllStarCtrl:getCampLeaderPos()
	if pos and pos.x > 0 then
		local posStr = string.format("%d,%d", pos.x - 1, pos.y - 1)
		nebulaAllStarCtrl = nil
		;(nil).u = true
		;(nil).color = "#4CE61A"
		self.fields.Text_pos2:setString(SoraDWrapHtmlTagByStyle(posStr, nil))
		self.fields.Text_pos2.pos = pos
	else
		self.fields.Text_pos2:setString(i18n("hero_text_84"))
		self.fields.Text_pos2.pos = nil
	end
end
function nebulaAllStarUITop:updateCampSpoliTroops()
	if not nebulaAllStarCtrl:getIsViewer() then
		self.fields.List_troops:setVisible(false)
		return
	end
	self.fields.List_troops:setVisible(true)
	self.spoliQueueData = nebulaAllStarCtrl:getCollectSpoilQueueData()
	self.fields.List_troops:setNumItems(math.max(self.PickPlunderMax, table.nums(self.spoliQueueData)))
end
function nebulaAllStarUITop:onClickBtnExpand()
	SoraDPlaySound()
	if self.fields.Button_expand:isSelected() then
		nebulaAllStarCtrl:reqRankData(self.rankType, 1, 5, "nebulaAllStarUITop")
	end
end
function nebulaAllStarUITop:onMsgGetPlayerRank(target, event)
	if event.from ~= "nebulaAllStarUITop" then
		return
	end
	if not event.rspdata.rankList then
		_UPVALUE0_ = event.rspdata.rankList
	end
	self.rankList = event.rspdata.rankList
	self.fields.List_rank:setNumItems(#self.rankList)
end
function nebulaAllStarUITop:onRankItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		obj.c_rank = obj:getController("c_rank")
		_fields.Text_pos:addClickListener(handler(self, self.onClickBtnPos))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local rank = index + 1
	local data = self.rankList[rank]
	if 1 <= rank and rank <= 3 then
		obj.c_rank:setSelectedIndex(rank - 1)
	else
		obj.c_rank:setSelectedIndex(3)
		_fields.Text_rank:setString(rank)
	end
	local areaIcon = nebulaWarRead.getAreaIcon(data.camp)
	_fields.Load_region:setURL(areaIcon)
	_fields.Text_name:setString(data.nickName)
	_fields.Text_score:setString(string.formatnumberthousands(data[self.valueKey] or 0))
	if data.x and 0 < data.x then
		local posStr = string.format("%d,%d", data.x - 1, data.y - 1)
		_ENV = string.formatnumberthousands(data[self.valueKey] or 0)
		string.formatnumberthousands(data[self.valueKey] or 0).u = true
		string.formatnumberthousands(data[self.valueKey] or 0).color = "#4CE61A"
		_fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(posStr, string.formatnumberthousands(data[self.valueKey] or 0)))
		_fields.Text_pos.pos = cc.p(data.x, data.y)
	else
		_fields.Text_pos:setString(i18n("hero_text_84"))
		_fields.Text_pos.pos = nil
	end
end
function nebulaAllStarUITop:onTroopstemRenderer(index, obj)
	obj:initData(self.spoliQueueData[index + 1], self)
end
function nebulaAllStarUITop:onClickBtnPos(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender.pos then
		SoraDGotoWorldMapPoint(sender.pos, true)
	end
end
return nebulaAllStarUITop
