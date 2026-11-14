local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DeadlyHuntingPanel = class("DeadlyHuntingPanel", baseFguiPanel)
function DeadlyHuntingPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DeadlyHuntingPanel:ctor", self.viewName)
end
function DeadlyHuntingPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "MagicHerb"
	end
	return self._packageList
end
function DeadlyHuntingPanel:onInit()
	print("=======DeadlyHuntingPanel:onInit")
	_ENV = print
	print.id = gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY
	print.title = i18n("activity_name_9001397")
	local print.bg, data = "bg_activity_9001397.png", print
	self.activityID = data.id
	self.fields.Com_title:initData(data.title, handler(self, self.onClickClose))
	self.fields.Label_banner:setIcon(data.bg)
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function DeadlyHuntingPanel:initData()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	dump(self.taskList, "DeadlyHuntingPanel:initData")
	self.fields.List_exchange:setNumItems(table.nums(self.taskList))
end
function DeadlyHuntingPanel:onItemRenderer(index, object)
	object:initData(self.view, self.taskList[index + 1])
end
function DeadlyHuntingPanel:closeLoading()
	SoraDCloseLoading(self.view:displayObject())
	self.view:initData()
end
function DeadlyHuntingPanel:onShow()
	print("=======DeadlyHuntingPanel:onShow")
end
function DeadlyHuntingPanel:onHide()
	print("=======DeadlyHuntingPanel:onHide")
end
function DeadlyHuntingPanel:onDispose()
	print("=======DeadlyHuntingPanel:onDispose")
end
return DeadlyHuntingPanel
