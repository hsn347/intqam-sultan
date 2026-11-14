local allianceMgr = SoraDGetCtrl("allianceMgr")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
local constantRead = include("constantRead")
local activity_9001625_Read = include("activity_9001625_Read")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapFeastViewPanel = class("WorldMapFeastViewPanel", baseFguiPanel)
function WorldMapFeastViewPanel:ctor(...)
	WorldMapFeastViewPanel.super.ctor(self, ...)
	print("WorldMapFeastViewPanel:ctor", self.viewName)
end
function WorldMapFeastViewPanel:onInit()
	print("=======WorldMapFeastViewPanel:onInit")
	self.fields.Image_boss:setURL("activity_9001625_build_bg.png")
	self.fields.Text_reward:setString(i18n("gathering_activity_text7"))
	self.fields.Button_go:setString(i18n("btn_toDinner"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.Button_back:setString(i18n("common_text_006"))
	self.fields.Button_back:addClickListener(handler(self, self.onClickBtnBack))
	self.fields.Text_over:setString(i18n("activity_feast_toDinner_complete_desc"))
	self.fields.Text_time_last = SoraDCreateTimerLabel(self, self.fields.Text_time_last)
	self.fields.Text_time_last:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).var1 = timeStr
		return i18n("activity_feast_duration_name", nil)
	end)
	self.fields.Text_time_last:setTimeEndListener(function()
		SoraDRemoveAllPrePanelFromManager(self)
	end)
	self.fields.Text_progress = SoraDCreateTimerLabel(self, self.fields.Text_progress)
	self.fields.Text_progress:setTimeLast(function(timeStr, time)
		self.fields.bar:setValue(time)
		self = time
		time.var1 = timeStr
		return i18n("activity_feast_toDinner_name2", time)
	end)
	self.fields.Text_progress:setTimeEndListener(function()
		self.fields.Button_go:setVisible(false)
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local awardTime = activity_9001625_Ctrl:getFeastAwardTime()
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).var1 = awardTime / 60
	self.fields.Text_time_need:setString(i18n("activity_feast_needTime_name", handler(self, self.onItemRenderer)))
end
function WorldMapFeastViewPanel:onShow()
	print("=======WorldMapFeastViewPanel:onShow")
end
function WorldMapFeastViewPanel:initData(data, instanceID)
	if not data then
		return
	end
	dump(data, "==WorldMapFeastViewPanel:initData==")
	self.instanceID = instanceID
	self.data = data
	local feastId = data.objId
	_ENV = nil
	;(nil).var1 = feastId
	self.fields.Text_name:setString(i18n("activity_feastLv_name", nil))
	_ENV = i18n("activity_feastLv_name", nil)
	i18n("activity_feastLv_name", nil).var1 = data.allianceAbbr
	self.fields.Text_alliance:setString(i18n("activity_feast_alliance_name", i18n("activity_feastLv_name", nil)))
	self.rewardList = activity_9001625_Read.getFeastRewardById(feastId)
	local itemNum = #self.rewardList
	self.fields.List:setNumItems(itemNum)
	self.fields.List:scrollToView(0)
	local lastRemainTime = activity_9001625_Ctrl:getRemainTime(data)
	if 0 < lastRemainTime then
		self.fields.Text_time_last:beginTime(lastRemainTime)
	end
	self:updateFeastState()
end
function WorldMapFeastViewPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.item:initData(data.id, data.count)
	_fields.title:setString(publicRead.getName(data.id))
end
function WorldMapFeastViewPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	if selfLeagueID ~= self.data.aid then
		SoraDShowMsgTip(i18n("tips_feast_toDinnerUnion_limit"))
		return
	end
	local hasMyQueue = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.feast2024)
	if hasMyQueue then
		SoraDShowMsgTip(i18n("tips_feast_toDinnerNum_limit"))
		return
	end
	local feastId = self.data.objId
	if activity_9001625_Ctrl:getSelfDataFeasts(feastId) then
		SoraDShowMsgTip(i18n("tips_feast_toDinnerTimes_limit"))
		return
	end
	local awardTime = activity_9001625_Ctrl:getFeastAwardTime()
	if awardTime >= activity_9001625_Ctrl:getRemainTime(self.data) then
		SoraDShowMsgTip(i18n("tips_feast_toDinnerTime_limit"))
		return
	end
	if SoraDEnoughTroops() then
		_ENV = SoraDEnoughTroops()
		SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing
		SoraDEnoughTroops().toPoint = include("mapSyncUtilClient").serverTOClientPos(cc.p(self.data.x, self.data.y))
		local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
		worldMapFunction.gotoDispatch(armyData, true)
		_ENV = armyData
		armyData.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(armyData)
	end
	self:closePanel()
end
function WorldMapFeastViewPanel:onClickBtnBack(...)
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("activity_feast_back_sure_desc"), i18n("common_text_204"), i18n("common_text_185"), function(type)
		if type == MSGBOX_CALLBACK_YES then
			local __, queueId = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.feast2024)
			if queueId then
				kingdomMapCtrl:reqBackQueueById(queueId)
			end
			SoraDRemoveAllPrePanelFromManager(self)
		end
	end)
end
function WorldMapFeastViewPanel:getFeastQueue()
	local hasMyQueue, queueId = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.feast2024)
	if hasMyQueue then
		local queue = kingdomMapCtrl:getQueueByID(queueId)
		if queue and queue:isWorking() then
			return queue
		end
	end
end
function WorldMapFeastViewPanel:updateFeastState(...)
	local feastId = self.data.objId
	if activity_9001625_Ctrl:getSelfDataFeasts(feastId) then
		self.controllers.c_state:setSelectedIndex(2)
	else
		local queue = self:getFeastQueue()
		if queue then
			self.controllers.c_state:setSelectedIndex(1)
			self.fields.bar:setMax(queue:getStatusTotalTime())
			self.fields.Text_progress:beginTime(queue:getStatusRemainTime())
		else
			self.controllers.c_state:setSelectedIndex(0)
		end
	end
end
function WorldMapFeastViewPanel:onMsgMapEventListInfoNew(target, event)
	dump(event, "==WorldMapFeastViewPanel:onMsgMapEventListInfoNew==", 10)
	local queue = event.data
	if queue and queue:getQueueType() == gMapMoveLineServerType.feast2024 then
		self:updateFeastState()
	end
end
function WorldMapFeastViewPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "feasts" then
		self:updateFeastState()
	end
end
return WorldMapFeastViewPanel
