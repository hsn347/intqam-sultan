local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001661_RecordPanel = class("Activity_9001661_RecordPanel", baseFguiPanel)
function Activity_9001661_RecordPanel:ctor(...)
	Activity_9001661_RecordPanel.super.ctor(self, ...)
	print("Activity_9001661_RecordPanel:ctor", self.viewName)
	self.readTime = activity_9001661_Ctrl:getRecordReadTime()
end
function Activity_9001661_RecordPanel:onInit()
	print("=======Activity_9001661_RecordPanel:onInit")
	self.tag = 1
	self.fields.Panel_bg:setString(i18n("datepalm_tree_text9"))
	self.fields.Text_noData:setString(i18n("datepalm_tree_text44"))
	self.fields.Text_noData:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function Activity_9001661_RecordPanel:onShow()
	print("=======Activity_9001661_RecordPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	_ENV, self.tag[1], (nil).title = nil, nil, i18n("datepalm_tree_text10")
	;(nil).tabsetArray, self.tag[2], (nil).title = self.tag, nil, i18n("datepalm_tree_text11")
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(nil)
end
function Activity_9001661_RecordPanel:onClickTab(tag)
	self.tag = tag
	if tag == 1 then
		self.records = activity_9001661_Ctrl:getRecords()
		self.fields.List:setNumItems(#self.records)
		self.fields.Text_noData:setVisible(#self.records <= 0)
		self.readTimeNew = serviceFunctions.systemTime()
	else
		activity_9001661_Ctrl:reqBubbleGrangeGrouth()
		self:setRecordReadTime()
	end
end
function Activity_9001661_RecordPanel:onItemRenderer(index, obj)
	obj:initData(self.records[index + 1], self.tag)
end
function Activity_9001661_RecordPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "grouth" then
		if not event.rspdata then
			_ENV = event.rspdata
		end
		self.records = event.rspdata
		self.fields.List:setNumItems(#self.records)
		self.fields.Text_noData:setVisible(#self.records <= 0)
		self.readTimeNew = serviceFunctions.systemTime()
	elseif key == "member" then
		if event.err == gErrDef.Err_None then
			_ENV = nil
			;(nil).member = event.member
			;(nil).from = "record"
			uiManager:show("Activity_9001661_Main", nil)
			self:closePanel()
		else
			SoraDCloseLoading(self)
		end
	end
end
function Activity_9001661_RecordPanel:setRecordReadTime()
	if self.readTimeNew then
		activity_9001661_Ctrl:setRecordReadTime(self.readTimeNew)
		self.readTimeNew = nil
		activity_9001661_Ctrl = activity_9001661_Ctrl
		activity_9001661_Ctrl.msg = "MESSAGE_ACTIVITY_9001661_UPDATE"
		activity_9001661_Ctrl.key = "recordRead"
		SoraDSendMessage(activity_9001661_Ctrl)
	end
end
function Activity_9001661_RecordPanel:onHide(...)
	self:setRecordReadTime()
end
return Activity_9001661_RecordPanel
