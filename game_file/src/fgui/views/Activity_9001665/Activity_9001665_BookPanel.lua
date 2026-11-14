local activity_9001665_Read = include("activity_9001665_Read")
local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001665_BookPanel = class("Activity_9001665_BookPanel", baseFguiPanel)
function Activity_9001665_BookPanel:ctor(...)
	self.isLRU = true
	Activity_9001665_BookPanel.super.ctor(self, ...)
	print("Activity_9001665_BookPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665_BOOK
end
function Activity_9001665_BookPanel:onInit()
	print("=======Activity_9001665_BookPanel:onInit")
	self.fields.listBook:setVirtual()
	self.fields.listBook:setItemRenderer(handler(self, self.itemRenderer_listBook))
	self.fields.Com_title:initData(i18n("fishingmaster_text_24"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_star:fixPos()
	_ENV = i18n("fishingmaster_text_24")
	_ENV, _ENV, i18n("fishingmaster_text_24").defaultClick = activity_9001665_Ctrl, activity_9001665_Ctrl:getSeason(), activity_9001665_Ctrl:getSeason()
	activity_9001665_Ctrl.title = i18n("fishingmaster_text_29")
	_ENV, activity_9001665_Ctrl:getSeason()[1], activity_9001665_Ctrl.tag = activity_9001665_Ctrl, activity_9001665_Ctrl, 1
	activity_9001665_Ctrl.title = i18n("fishingmaster_text_30")
	_ENV, activity_9001665_Ctrl:getSeason()[2], activity_9001665_Ctrl.tag = activity_9001665_Ctrl, activity_9001665_Ctrl, 2
	activity_9001665_Ctrl.title = i18n("fishingmaster_text_31")
	_ENV, activity_9001665_Ctrl:getSeason()[3], activity_9001665_Ctrl.tag = activity_9001665_Ctrl, activity_9001665_Ctrl, 3
	activity_9001665_Ctrl.title = i18n("fishingmaster_text_32")
	i18n("fishingmaster_text_24").tabsetArray, activity_9001665_Ctrl:getSeason()[4], activity_9001665_Ctrl.tag = activity_9001665_Ctrl:getSeason(), activity_9001665_Ctrl, 4
	i18n("fishingmaster_text_24").callback = handler(self, self.onTabClick)
	i18n("fishingmaster_text_24").isAutoSize = false
	self.fields.com_Tab:initView((i18n("fishingmaster_text_24")))
	self.controllers.ctrlLen:setSelectedIndex(self.fields.book:getPositionY() + self.fields.book:getHeight() > display.height and 0 or 1)
end
function Activity_9001665_BookPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("fishingmaster_text_33")
	uiManager:show("RuleView", nil)
end
function Activity_9001665_BookPanel:endShow()
	print("=======Activity_9001665_BookPanel:endShow")
	self:initData()
end
function Activity_9001665_BookPanel:itemRenderer_listBook(index, obj)
	local data = self.fishs[index + 1]
	obj:initData(data)
end
function Activity_9001665_BookPanel:onTabClick(tag)
	self:updateList(tag)
end
function Activity_9001665_BookPanel:initData()
	self.stageData = activity_9001665_Ctrl:getBookStageData()
	activity_9001665_Ctrl = nil
	;(nil).stageMax = #self.stageData
	;(nil).activityID = self.activityID
	self.fields.Com_boxList:initData(nil)
	activity_9001665_Ctrl = nil
	;(nil).stageData = self.stageData
	;(nil).score = activity_9001665_Ctrl:getStar()
	self.fields.Com_boxList:updateData(nil)
	self.fields.Com_star:initOther("ui://Activity_9001665/frame_9001665_xx", activity_9001665_Ctrl:getStar(), true)
	self.fields.com_Tab:setTabIndex(activity_9001665_Ctrl:getSeason(), true)
end
function Activity_9001665_BookPanel:updateList(season)
	self.fishs = activity_9001665_Ctrl:getSeasonFishs(season)
	table.sort(self.fishs, function(a, b)
		if a.cfg.star == b.cfg.star then
			return a.cfg.fishID < b.cfg.fishID
		else
			return a.cfg.star > b.cfg.star
		end
	end)
	self.fields.listBook:setNumItems(#self.fishs)
end
function Activity_9001665_BookPanel:updateView()
	self.stageData = activity_9001665_Ctrl:getBookStageData()
	activity_9001665_Ctrl = nil
	;(nil).stageData = self.stageData
	;(nil).score = activity_9001665_Ctrl:getStar()
	self.fields.Com_boxList:updateData(nil)
	self.fields.com_Tab:setTabIndex(self.fields.com_Tab.curTab, true)
end
return Activity_9001665_BookPanel
