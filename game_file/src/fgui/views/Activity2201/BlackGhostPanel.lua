local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BlackGhostPanel = class("BlackGhostPanel", baseFguiPanel)
function BlackGhostPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("BlackGhostPanel:ctor", self.viewName)
end
function BlackGhostPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "MagicHerb"
	end
	return self._packageList
end
function BlackGhostPanel:onInit()
	print("=======BlackGhostPanel:onInit")
	_ENV = print
	print.id = gActivityTimeActivityID.BLACK_GHOST_ACTIVITY
	print.title = i18n("activity_name_9001403")
	local print.bg, data = "bg_activity_9001403.png", print
	self.activityID = data.id
	self.fields.Com_title:initData(data.title, handler(self, self.onClickClose))
	self.fields.Label_banner:setIcon(data.bg)
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function BlackGhostPanel:initData()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	dump(self.taskList, "BlackGhostPanel:initData")
	self.fields.List_exchange:setNumItems(table.nums(self.taskList))
end
function BlackGhostPanel:onItemRenderer(index, object)
	object:initData(self.view, self.taskList[index + 1])
end
function BlackGhostPanel:closeLoading()
	SoraDCloseLoading(self.view:displayObject())
	self.view:initData()
end
function BlackGhostPanel:onShow()
	print("=======BlackGhostPanel:onShow")
end
function BlackGhostPanel:onHide()
	print("=======BlackGhostPanel:onHide")
end
function BlackGhostPanel:onDispose()
	print("=======BlackGhostPanel:onDispose")
end
return BlackGhostPanel
