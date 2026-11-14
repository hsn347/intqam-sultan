local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001661_MapPanel = class("Activity_9001661_MapPanel", baseFguiPanel)
function Activity_9001661_MapPanel:ctor(...)
	Activity_9001661_MapPanel.super.ctor(self, ...)
	print("Activity_9001661_MapPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BUBBLE_GRANGE_ACTIVITY
end
function Activity_9001661_MapPanel:onInit()
	print("=======Activity_9001661_MapPanel:onInit")
	self.mapTable = nil
	self.memebers = nil
	self.fields.Com_title:initData(i18n("bubble_farm_text1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("bubble_farm_text10"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function Activity_9001661_MapPanel:onShow()
	print("=======Activity_9001661_MapPanel:onShow")
	self:setMyInfo()
	activity_9001661_Ctrl:reqBubbleGrangeTable()
	activity_9001661_Ctrl:reqBubbleGrangeMembers()
end
function Activity_9001661_MapPanel:setMyInfo()
	self.fields.Com_myInfo:initData()
end
function Activity_9001661_MapPanel:initBoard()
	self.fields.Map:initMap(self, self.mapTable, self.memebers)
end
function Activity_9001661_MapPanel:onMsgUpdateData(target, data)
	if data and data.key == "table" then
		self.mapTable = activity_9001661_Ctrl:getMapInfo(data.map)
	end
	if data and data.key == "members" then
		self.memebers = data.memebers
	end
	if data and data.key == "assist" then
		self:setMyInfo()
		activity_9001661_Ctrl:reqBubbleGrangeMembers()
	end
	if data and data.key == "initData" then
		self:setMyInfo()
		activity_9001661_Ctrl:reqBubbleGrangeTable()
		activity_9001661_Ctrl:reqBubbleGrangeMembers()
	end
	if self.mapTable and self.memebers then
		self:initBoard()
	end
end
function Activity_9001661_MapPanel:onMsgJump(target, data)
	self.fields.Map:jumpToUid(data.uid)
end
function Activity_9001661_MapPanel:btnSearchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).memebers = self.memebers
	;(nil).mapTable = self.mapTable
	uiManager:show("Activity_9001661_Search", nil)
end
function Activity_9001661_MapPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("bubble_farm_rule1")
	uiManager:show("RuleView", nil)
end
return Activity_9001661_MapPanel
