local activity_9001594_Ctrl = SoraDGetCtrl("activity_9001594_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001594_RecordPanel = class("Activity_9001594_RecordPanel", baseFguiPanel)
function Activity_9001594_RecordPanel:ctor(...)
	Activity_9001594_RecordPanel.super.ctor(self, ...)
	print("Activity_9001594_RecordPanel:ctor", self.viewName)
	self.readTime = activity_9001594_Ctrl:getRecordReadTime()
end
function Activity_9001594_RecordPanel:onInit()
	print("=======Activity_9001594_RecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("datepalm_tree_text9"))
	self.fields.List1:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.List1:setVirtual()
	self.fields.List2:setItemRenderer(handler(self, self.onItem2Renderer))
	self.fields.List2:setVirtual()
	self.fields.Text_noData1:setString(i18n("datepalm_tree_text44"))
	self.fields.Text_noData2:setString(i18n("datepalm_tree_text44"))
	_ENV = i18n("datepalm_tree_text44")
	_ENV, _ENV, i18n("datepalm_tree_text44").defaultClick = i18n("datepalm_tree_text44")
	_ENV, i18n("datepalm_tree_text44")[1], i18n("datepalm_tree_text44").title = i18n("datepalm_tree_text44")
	i18n("datepalm_tree_text44").tabsetArray, i18n("datepalm_tree_text44")[2], i18n("datepalm_tree_text44").title = i18n("datepalm_tree_text44")
	i18n("datepalm_tree_text44").callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(i18n("datepalm_tree_text44"))
end
function Activity_9001594_RecordPanel:onShow()
	print("=======Activity_9001594_RecordPanel:onShow")
	self.records = activity_9001594_Ctrl:getRecords()
	self.fields.List1:setNumItems(#self.records)
	self.fields.Text_noData1:setVisible(#self.records <= 0)
	activity_9001594_Ctrl:reqGrouth()
end
function Activity_9001594_RecordPanel:onHide(...)
	self:setRecordReadTime()
end
function Activity_9001594_RecordPanel:onClickTab(tag)
	print("==Activity_9001594_RecordPanel:onClickTab==", tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	if tag ~= 1 then
		self:setRecordReadTime()
	end
end
function Activity_9001594_RecordPanel:onItem1Renderer(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
		local _fields = obj._fields
		_fields.Text_content:addEventListener(fgui.UIEventType.ClickLink, function(EventContext)
			if EventContext:getDataValue() == "name" then
				SoraDPlaySound()
				SoraDShowLoading(self)
				local uid = EventContext:getSender().uid
				activity_9001594_Ctrl:reqMembers(uid)
			end
		end)
		if SoraDFIsRA() then
			_fields.Image_new:setURL("img_common_new_ar.png")
		else
			_fields.Image_new:setURL("img_common_new_en.png")
		end
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local _fields = obj._fields
	local _controllers = obj._controllers
	local record = self.records[index + 1]
	local content = activity_9001594_Ctrl:getOneRecordStr(record)
	_fields.Text_content:setString(content)
	_fields.Text_content.uid = record.uid
	_fields.Text_time:setString(os.date([[
!%m-%d
%H:%M:%S]], record.time))
	if not self.readTime or record.time > self.readTime then
		_controllers.c_new:setSelectedIndex(1)
	else
		_controllers.c_new:setSelectedIndex(0)
	end
end
function Activity_9001594_RecordPanel:onItem2Renderer(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local _fields = fguiHelper.get_fields(obj)
	local grouth = self.grouths[index + 1]
	local content = activity_9001594_Ctrl:getOneGrouthStr(grouth)
	_fields.Text_content:setString(content)
	_fields.Text_time:setString(os.date([[
!%m-%d
%H:%M:%S]], grouth.time))
end
function Activity_9001594_RecordPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "grouth" then
		if not event.rspdata then
			_ENV = event.rspdata
		end
		self.grouths = event.rspdata
		self.fields.List2:setNumItems(#self.grouths)
		self.fields.Text_noData2:setVisible(#self.grouths <= 0)
		self.readTimeNew = serviceFunctions.systemTime()
	elseif key == "member" then
		if event.err == gErrDef.Err_None then
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001594_UPDATE"
			gErrDef.Err_None.key = "gotoOther"
			gErrDef.Err_None.member = event.member
			SoraDSendMessage(gErrDef.Err_None)
			self:closePanel()
		else
			SoraDCloseLoading(self)
		end
	end
end
function Activity_9001594_RecordPanel:setRecordReadTime(...)
	if self.readTimeNew then
		activity_9001594_Ctrl:setRecordReadTime(self.readTimeNew)
		self.readTimeNew = nil
		activity_9001594_Ctrl = activity_9001594_Ctrl
		activity_9001594_Ctrl.msg = "MESSAGE_ACTIVITY_9001594_UPDATE"
		activity_9001594_Ctrl.key = "recordRead"
		SoraDSendMessage(activity_9001594_Ctrl)
	end
end
return Activity_9001594_RecordPanel
