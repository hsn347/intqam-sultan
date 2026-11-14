local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001609_Ctrl = SoraDGetCtrl("activity_9001609_Ctrl")
local activity_9001609_Read = include("activity_9001609_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001609 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001609/Com_Activity_9001609", Com_Activity_9001609)
function Com_Activity_9001609:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_RECALL_FRIENDS
	self.taskList, _ENV, self.backerList, _ENV, self.tag = gActivityTimeActivityID.HONOR_BACK_RECALL_FRIENDS, gActivityTimeActivityID.HONOR_BACK_RECALL_FRIENDS, gActivityTimeActivityID.HONOR_BACK_RECALL_FRIENDS, gActivityTimeActivityID.HONOR_BACK_RECALL_FRIENDS, 1
	self.fields.Text_tip:setString(i18n("recallfriends_text_08"))
	self.fields.Lab_title:setString(i18n("friend_back_text04"))
	self.fields.Text_none:setString(i18n("friend_back_text05"))
	self.fields.List_backer:setVirtual()
	self.fields.List_backer:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Btn_help:fixPos()
end
function Com_Activity_9001609:onShow()
	self.fields.Com_bg:setGradientColor()
	self.fields.timer:initCommonActivityTime(self.activityID)
	self.isBacker = activity_9001609_Ctrl:isBacker()
	self.controllers.c1:setSelectedIndex(self.isBacker and 1 or 0)
	self:initData()
end
function Com_Activity_9001609:onListRenderer(index, obj)
	obj:initData(self.backerList[index + 1])
end
function Com_Activity_9001609:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], index + 1)
end
function Com_Activity_9001609:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001609_UPDATE", handler(self, self.initData))
end
function Com_Activity_9001609:initData()
	if self.isBacker then
		self.fields.Com_bp:initData()
	else
		_ENV = nil
		_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
		;(nil).title = i18n("friend_back_text04")
		_ENV, self.tag[1], (nil).tag = nil, nil, 1
		;(nil).title = i18n("recallfriends_text_07")
		;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
		;(nil).callback = handler(self, self.onTabClick)
		self.fields.com_Tab:initView(nil)
	end
end
function Com_Activity_9001609:onTabClick(tag)
	self.tag = tag
	self.controllers.c2:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self.backerList = activity_9001609_Ctrl:getBackers()
		self.fields.List_backer:setNumItems(#self.backerList)
		self.fields.Text_none:setVisible(#self.backerList == 0)
	else
		self.taskList = activity_9001609_Read.getTaskConfig()
		self.fields.List_reward:setNumItems(#self.taskList)
	end
end
function Com_Activity_9001609:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("recallfriends_text_16")
	uiManager:show("RuleView", nil)
end
return Com_Activity_9001609
