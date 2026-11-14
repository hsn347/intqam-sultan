local baseComponent = require("fgui.base.baseComponent")
local newServerReturnltCtrl = include("newServerReturnltCtrl")
local revivalRoadCtrl = SoraDGetCtrl("revivalRoadCtrl")
local Com_revivalRoad = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_revivalRoad", Com_revivalRoad)
function Com_revivalRoad:onInit()
	self.tag = 1
	self.activityID = gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY
	self.fields.List_RevivalRoad:setItemRenderer(handler(self, self.onItemRenderer))
	self.taskTypeList = newServerReturnltCtrl.getRevivalRoadTaskList(revivalRoadCtrl:getCurWeek())
end
function Com_revivalRoad:onShow()
	self:initActivityTime()
	revivalRoadCtrl:reqRoadToReviveInit()
	local revivalRoadCtrl, tabsetArray = revivalRoadCtrl.reqRoadToReviveInit, revivalRoadCtrl.reqRoadToReviveInit
	for i, v in ipairs(self.taskTypeList) do
		revivalRoadCtrl = nil
		;(nil).title = i18n(v.questDes)
		;(nil).tag = i
		table.insert(tabsetArray, nil)
	end
	revivalRoadCtrl = ipairs(self.taskTypeList)
	ipairs(self.taskTypeList).defaultClick = self.tag
	ipairs(self.taskTypeList).tabsetArray = tabsetArray
	ipairs(self.taskTypeList).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(ipairs(self.taskTypeList))
	self:updateTabRed()
end
function Com_revivalRoad:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_REVIVAL_ROAD_REFRESH", handler(self, self.onUpdateView))
end
function Com_revivalRoad:initActivityTime()
	local curWeek = revivalRoadCtrl:getCurWeek()
	self.fields.Label_time_event:setTimeLast(function(strTime)
		_ENV = #self.taskTypeList
		_ENV, _ENV, (#self.taskTypeList).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html(curWeek == #self.taskTypeList and "common_text_4415" or "hero_ceremony_text_07", #self.taskTypeList, nil)
	end)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	dump(timer, "timer")
	if timer then
		local totaltime = 604800
		local starTime = timer.starttime + (curWeek - 1) * totaltime
		local curTime = serviceFunctions.systemTime()
		local passTime = curTime - starTime
		self.fields.Label_time_event:beginTime(totaltime - passTime)
	else
		self.fields.Label_time_event:setString(i18n("Anchor_text_21"))
	end
end
function Com_revivalRoad:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.onClickGetAward), nil)
end
function Com_revivalRoad:onClickTab(tag)
	self.tag = tag
	self.taskList = revivalRoadCtrl:getTaskList(self.taskTypeList[self.tag].questId)
	self.fields.List_RevivalRoad:setNumItems(#self.taskList)
	self.fields.List_RevivalRoad:scrollToView(0)
end
function Com_revivalRoad:onClickGetAward(taskID)
	SoraDShowLoading()
	revivalRoadCtrl:reqRoadToReviveReward(taskID)
end
function Com_revivalRoad:updateTabRed()
	for i, v in ipairs(self.taskTypeList) do
		local isVisible, num = revivalRoadCtrl:getReceiveStatusAndNumByQuests(v.questId)
		self.fields.com_Tab:setBtnRedDot(i, isVisible, num)
	end
end
function Com_revivalRoad:onUpdateTask(target, data)
	dump(data, "Com_revivalRoad:onUpdateTask")
	if data.activityID == self.activityID then
		SoraDCloseLoading()
		self.taskList = revivalRoadCtrl:getTaskList(self.taskTypeList[self.tag].questId)
		self.fields.List_RevivalRoad:setNumItems(#self.taskList)
		self:updateTabRed()
	end
end
function Com_revivalRoad:onUpdateView(target, data)
	dump(data, "Com_revivalRoad:onUpdateView")
	self.taskTypeList = newServerReturnltCtrl.getRevivalRoadTaskList(revivalRoadCtrl:getCurWeek())
	self:initActivityTime()
	self.fields.com_Tab:setTabIndex(1, true)
	self:updateTabRed()
end
return Com_revivalRoad
