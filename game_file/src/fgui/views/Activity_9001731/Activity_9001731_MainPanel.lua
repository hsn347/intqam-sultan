local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_MainPanel = class("Activity_9001731_MainPanel", baseFguiPanel)
function Activity_9001731_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_MainPanel.super.ctor(self, ...)
	print("Activity_9001731_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
	self.itemID = constantRead.getConstValue("LUDO_STAR_COST", 880601)
end
function Activity_9001731_MainPanel:onInit()
	print("=======Activity_9001731_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_task:setTitle(i18n("Ludo_test_003"))
	self.fields.Button_task:addClickListener(handler(self, self.onClick_Button_task))
	self.fields.Button_reward:setTitle(i18n("Ludo_test_004"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClick_Button_reward))
	self.fields.Button_invite:setTitle(i18n("Ludo_test_005"))
	self.fields.Button_invite:addClickListener(handler(self, self.onClick_Button_invite))
	self.fields.Button_match:setTitle(i18n("Ludo_test_006"))
	self.fields.Button_match:addClickListener(handler(self, self.onClick_Button_match))
	self.fields.Text_tip:setString(i18n("Ludo_test_007"))
	self.fields.Com_have:setAddCallBack(handler(self, self.onClick_Button_have))
end
function Activity_9001731_MainPanel:onComboBoxClick()
	SoraDPlaySound()
	self.times = tonumber(self.fields.ComboBox:getValue())
end
function Activity_9001731_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ludo_test_002")
	uiManager:show("RuleView", nil)
end
function Activity_9001731_MainPanel:endShow()
	print("=======Activity_9001731_MainPanel:endShow")
	self.tag = self.param and self.param.tag or 1
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("Ludo_test_006")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Ludo_test_032")
	self.activityID.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(self.activityID)
	self.fields.ComboBox:setIcon(publicRead.getIcon(self.itemID))
end
function Activity_9001731_MainPanel:initComboBox()
	local backpackCtrl, items
	local backpackCtrl, values
	self.times = 1
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	for i = 1, 5 do
		if i <= itemCount or i == 1 then
			table.insert(items, "x" .. i)
			table.insert(values, i)
		end
	end
	self.fields.ComboBox:getChild("title"):setAlign(0)
	backpackCtrl = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, nil)
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.times - 1)
	end)
end
function Activity_9001731_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001731_MainPanel:initView()
	self.fields.Com_have:initData(self.itemID)
	self.fields.Com_have:setTitleColor(backpackCtrl:getItemCount(self.itemID) > 0 and "#FFFFFF" or "#E02B2B")
	self.fields.Com_pass:initData()
	self:updateRedNum()
	self:initComboBox()
end
function Activity_9001731_MainPanel:updateRedNum()
	local itemNum = activity_9001731_Ctrl:getItemRedNum()
	local taskNum = activity_9001731_Ctrl:getTaskRewardNum() + activity_9001731_Ctrl:getStageRewardNum()
	local passNum = activity_9001731_Ctrl:getPassRedNum()
	self.fields.Com_title:setBtnRedDot(1, 0 < itemNum + taskNum, itemNum + taskNum)
	self.fields.Com_title:setBtnRedDot(2, 0 < passNum)
	self.fields.Button_task:setReddot(0 < taskNum, taskNum)
	self.fields.Button_match:setReddot(0 < itemNum)
end
function Activity_9001731_MainPanel:onClick_Button_task(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001731_Task")
end
function Activity_9001731_MainPanel:onClick_Button_reward(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001731_RewardPre")
end
function Activity_9001731_MainPanel:onClick_Button_have(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001731_ItemGet")
end
function Activity_9001731_MainPanel:onClick_Button_invite(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).model = 1
	uiManager:show("Activity_9001731_Game", nil)
end
function Activity_9001731_MainPanel:onClick_Button_match(context)
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) < self.times then
		uiManager:show("Activity_9001731_ItemGet")
		return
	end
	_ENV = nil
	;(nil).model = 2
	;(nil).count = self.times
	uiManager:show("Activity_9001731_Game", nil)
end
return Activity_9001731_MainPanel
