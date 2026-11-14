local activity_9001487_Ctrl = SoraDGetCtrl("activity_9001487_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001487_MainPanel = class("Activity_9001487_MainPanel", baseFguiPanel)
function Activity_9001487_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001487_MainPanel:ctor", self.viewName)
end
function Activity_9001487_MainPanel:onInit()
	print("=======Activity_9001487_MainPanel:onInit")
	self.activityID = self.proxy.param and self.proxy.param.activityID or gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1
	self.proxy:setActivityID(self.activityID)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Button_reward:setString(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Button_go:setString(i18n("back_recharge_text02"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	local n3 = self.fields.Button_go:getChild("n3")
	n3:setAllFrameName("dh_chongzhisc_%.2d.png", 1)
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function Activity_9001487_MainPanel:onShow()
	print("=======Activity_9001487_MainPanel:onShow")
	self:updateCumuDayData()
	self.fields.List_task:setNumItems(#self.rechargeList)
end
function Activity_9001487_MainPanel:onClickBtnReward()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001487_Reward", nil)
end
function Activity_9001487_MainPanel:onClickBtnGo(...)
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function Activity_9001487_MainPanel:onTaskItemRenderer(index, obj)
	if not obj.fields then
		obj.c1 = obj:getController("c1")
		obj.fields = fguiHelper.get_fields(obj)
		local fields = obj.fields
		fields.Button_get:setString(i18n("common_text_1146"))
		fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
		fields.Text_get:setString(i18n("common_text_1892"))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		function obj:updateState(data)
			if data.receiveState == gGreatArmorStatue.ALREADY_RECEIVE then
				self.c1:setSelectedIndex(2)
			elseif data.receiveState == gGreatArmorStatue.CAN_RECEIVE then
				self.c1:setSelectedIndex(1)
			else
				self.c1:setSelectedIndex(0)
				local cfg = data.cfg
				_ENV = nil
				;(nil).member = "$" .. data.total
				_ENV, _ENV, (nil).total = cfg.amount, "$" .. cfg.amount, "$" .. cfg.amount
				;("$" .. cfg.amount).member, cfg.amount.color = cfg.amount, "#ff0000"
				local showStr = i18n_html("common_text_155", nil, "$" .. cfg.amount)
				self.fields.Text_value:setString(showStr)
			end
		end
	end
	local fields = obj.fields
	local data = self.rechargeList[index + 1]
	local cfg = data.cfg
	_ENV = i18n("common_text_1892")
	i18n("common_text_1892").num = "$" .. cfg.amount
	fields.Text_des:setString(i18n("great_armor_01", i18n("common_text_1892")))
	_UPVALUE2_ = i18n("great_armor_01", i18n("common_text_1892"))
	i18n("great_armor_01", i18n("common_text_1892"))[1] = "id"
	i18n("great_armor_01", i18n("common_text_1892"))[2] = "count"
	local rewards = serviceFunctions.tableFormat(cfg.reward, i18n("great_armor_01", i18n("common_text_1892")))
	fields.List_reward:setItemRenderer(function(_index, _obj)
		local _data = rewards[_index + 1]
		_obj:initData(_data.id, _data.count)
	end)
	fields.List_reward:setNumItems(#rewards)
	fields.Button_get:setTag(index)
	obj:updateState(data)
end
function Activity_9001487_MainPanel:onClickBtnGet(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local data = self.rechargeList[index + 1]
	local cfg = data.cfg
	_ENV = nil
	;(nil).objIdx = index + 1
	activity_9001487_Ctrl:reqReceive(self.activityID, cfg.Index, nil)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001487_MainPanel:updateClaim(clientData)
	SoraDCloseLoading(self:displayObject())
	local objIdx = clientData.objIdx
	local data = self.rechargeList[objIdx]
	if data then
		data.receiveState = gGreatArmorStatue.ALREADY_RECEIVE
		local obj = self.fields.List_task:getChildAt(objIdx - 1)
		obj:updateState(data)
	end
end
function Activity_9001487_MainPanel:updateCumuDayData(...)
	self.rechargeList = activity_9001487_Ctrl:getCurDayRechargeList(self.activityID)
	for i, data in ipairs(self.rechargeList) do
		local cfg = data.cfg
		local total = activity_9001487_Ctrl:getDayRechargeRecord(self.activityID, cfg.days)
		data.total = total
		local receiveState = activity_9001487_Ctrl:getReceiveState(self.activityID, cfg.Index)
		data.receiveState = receiveState
	end
end
function Activity_9001487_MainPanel:onMsgUpdateCumuDayData(...)
	self:updateCumuDayData()
	self.fields.List_task:setNumItems(#self.rechargeList)
end
return Activity_9001487_MainPanel
