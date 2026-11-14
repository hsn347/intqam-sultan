local activity_9001616_Ctrl = SoraDGetCtrl("activity_9001616_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001616_RecordPanel = class("Activity_9001616_RecordPanel", baseFguiPanel)
function Activity_9001616_RecordPanel:ctor(...)
	Activity_9001616_RecordPanel.super.ctor(self, ...)
	print("Activity_9001616_RecordPanel:ctor", self.viewName)
	self.bossType = gBossType.gholdEmergenceBoss
	self.removeAfterSec = worldMapDefine.getWorldBossRemoveAfterSec(self.bossType)
	local bossName = worldMapDefine.getWorldBossName(self.bossType)
	self.bossName = i18n(bossName)
	self.bossImage = worldMapDefine.getWorldBossImage(self.bossType)
end
function Activity_9001616_RecordPanel:onInit()
	print("=======Activity_9001616_RecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("sunmmon_ghoul_text9"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("common_text_927"))
end
function Activity_9001616_RecordPanel:onShow()
	print("=======Activity_9001616_RecordPanel:onShow")
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		SoraDShowLoading(self)
		activity_9001616_Ctrl:reqGetRecord()
	end
end
function Activity_9001616_RecordPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		_fields.Text_name:setString(self.bossName)
		_fields.Load_icon:setURL(self.bossImage)
		_fields.Text_pos:addClickListener(handler(self, self.onClickBtnGo))
		_fields.Text_time1 = SoraDCreateTimerLabel(obj, _fields.Text_time1)
		_fields.Text_time1:setTimeLast(function(timeStr)
			return i18n("common_text_1663") .. timeStr
		end)
		_fields.Text_state1:setString(i18n("activity_text_05"))
		_fields.Button_go:setString(i18n("sunmmon_ghoul_text8"))
		_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
		_fields.Text_state2:setString(i18n("sunmmon_ghoul_text7"))
		_fields.Text_state3:setString(i18n("lost_ruins_text_09"))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local data = self.recordList[index + 1]
	_ENV = i18n("lost_ruins_text_09")
	i18n("lost_ruins_text_09").x = data.x
	i18n("lost_ruins_text_09").y = data.y
	local posStr = i18n("common_text_2155", i18n("lost_ruins_text_09"))
	_ENV = i18n("lost_ruins_text_09")
	i18n("lost_ruins_text_09").u = true
	_fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(posStr, i18n("lost_ruins_text_09")))
	_fields.Text_pos:setTag(index)
	_fields.Text_time:setString(os.date("!%Y-%m-%d %H:%M:%S", data.time))
	_fields.Button_go:setTag(index)
	local state = data.state
	local c_state = obj:getController("c_state")
	c_state:setSelectedIndex(state - 1)
	if state == 1 then
		local remainTime = data.time + self.removeAfterSec - serviceFunctions.systemTime()
		if 0 < remainTime then
			_fields.Text_time1:beginTime(remainTime)
		end
	else
		_fields.Text_time1:endTime()
	end
end
function Activity_9001616_RecordPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local data = self.recordList[index + 1]
	SoraDGotoWorldMapPoint(cc.p(data.x, data.y), true)
	SoraDRemoveAllPanelFromManager()
end
function Activity_9001616_RecordPanel:onMsgUpdateData(target, event)
	if event.key ~= "record" then
		return
	end
	SoraDCloseLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local selfUid = gametop.playertop_:getPlayerID()
	if not event.recordList then
		local _ENV, recordList = event.recordList, event.recordList
	end
	for __, v in ipairs(recordList) do
		v.isSelf = selfUid == v.uid
	end
	table.sort(recordList, function(a, b)
		if a.state ~= b.state then
			return a.state < b.state
		end
		if a.state == 1 then
			if a.isSelf ~= b.isSelf then
				return a.isSelf
			end
			return a.time < b.time
		else
			return a.time > b.time
		end
	end)
	self.recordList = recordList
	self.fields.List:setNumItems(#self.recordList)
	self.fields.Text_noData:setVisible(#self.recordList <= 0)
end
return Activity_9001616_RecordPanel
