local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001657_ApplyPanel = class("Activity_9001657_ApplyPanel", baseFguiPanel)
function Activity_9001657_ApplyPanel:ctor(...)
	Activity_9001657_ApplyPanel.super.ctor(self, ...)
	print("Activity_9001657_ApplyPanel:ctor", self.viewName)
	self.debug = true
	Activity_9001657_ApplyPanel = self.viewName
	self.viewName.byUID = true
	self.applyUserList, Activity_9001657_ApplyPanel, self.sort = SoraDConfigGet("Game:Activity_9001657_Apply:sort~integer", self.viewName) or 1, SoraDConfigGet("Game:Activity_9001657_Apply:sort~integer", self.viewName) or 1, SoraDConfigGet("Game:Activity_9001657_Apply:sort~integer", self.viewName) or 1
	self.isSelected = false
end
function Activity_9001657_ApplyPanel:onInit()
	print("=======Activity_9001657_ApplyPanel:onInit")
	self.fields.Com_title:initData(i18n("kingdom_merger_text23"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Check_tick:addClickListener(handler(self, self.onClickBtnTick))
	self.fields.Text_approved:setString(i18n("kingdom_merger_text24"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noApply:setString(i18n("kingdom_merger_text35"))
	self:initComboBoxApply()
	if not SoraDFIsRA() then
		_UPVALUE5_ = self
		self[1] = self.fields.Check_tick
		self[2] = self.fields.Text_approved
		self[3] = self.fields.ComboBox_apply
		self[4] = self.fields.Text_num
		self[5] = self.fields.Image_num
		for __, v in pairs(self) do
			v:fixPos()
		end
	end
end
function Activity_9001657_ApplyPanel:onShow()
	print("=======Activity_9001657_ApplyPanel:onShow")
	activity_9001657_Ctrl:reqApplyUserList()
	activity_9001657_Ctrl:reqInitData()
end
function Activity_9001657_ApplyPanel:onClickHelp()
	SoraDPlaySound()
	local numLimit = constantRead.getConstValue("KINGDOM_MERGER_PEOPLE_NUMBER", 0)
	_ENV = nil
	;(nil).var2 = numLimit
	local content = i18n("kingdom_merger_rule4", nil)
	_ENV = nil
	;(nil).title = i18n("Payment_activity_optimization_text_09")
	;(nil).content = content
	uiManager:show("RuleView", nil)
end
function Activity_9001657_ApplyPanel:initComboBoxApply(...)
	_ENV = nil
	;(nil)[1] = i18n("sort_time_name")
	local (nil)[2], config = i18n("sort_power_name"), nil
	_UPVALUE2_ = nil
	;(nil)[1] = "icon_kfqc_time.png"
	;(nil)[2] = "icon_kfqc_warpower.png"
	self.fields.ComboBox_apply:setIcons(nil)
	_ENV = "icon_kfqc_time.png"
	;("icon_kfqc_time.png").items = config
	;("icon_kfqc_time.png").changedCallback = handler(self, self.onComboBoxChanged)
	;("icon_kfqc_time.png").selectedIndex = self.sort - 1
	self:setComboBox(self.fields.ComboBox_apply, "icon_kfqc_time.png")
	local dropdown = self.fields.ComboBox_apply:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_apply:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.sort - 1)
	end)
end
function Activity_9001657_ApplyPanel:onComboBoxChanged()
	local index = self.fields.ComboBox_apply:getSelectedIndex()
	local newSort = index + 1
	print("==onComboBoxChanged==", newSort)
	if self.sort == newSort then
		return
	end
	self.sort = newSort
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Activity_9001657_Apply:sort~integer", self.sort, nil)
	self:sortList()
	self:filterList()
end
function Activity_9001657_ApplyPanel:sortList(...)
	if self.sort == 2 then
		_UPVALUE2_, _UPVALUE2_ = nil, nil
		_UPVALUE2_, (nil)[1] = "totalFc", "totalFc"
		_UPVALUE2_, (nil)[2] = "totalFc", ">"
		;("totalFc")[1] = "uid"
		;("totalFc")[2] = ">"
		;(nil)[1] = nil
		;(nil)[2] = "totalFc"
		serviceFunctions.sort(self.applyUserList, nil)
	else
		_UPVALUE2_, _UPVALUE2_ = nil, nil
		_UPVALUE2_, (nil)[1] = "time", "time"
		_UPVALUE2_, (nil)[2] = "time", ">"
		;("time")[1] = "uid"
		;("time")[2] = ">"
		;(nil)[1] = nil
		;(nil)[2] = "time"
		serviceFunctions.sort(self.applyUserList, nil)
	end
end
function Activity_9001657_ApplyPanel:onClickBtnTick(...)
	SoraDPlaySound()
	self.isSelected = self.fields.Check_tick:isSelected()
	self:filterList()
end
function Activity_9001657_ApplyPanel:filterList(...)
	if self.isSelected then
		local _ENV, ret = self.isSelected, self.isSelected
		for i, v in ipairs(self.applyUserList) do
			if v.state == gMergeServerApplyState.AGREED then
				table.insert(ret, v)
			end
		end
		self.applyUserShow = ret
	else
		self.applyUserShow = self.applyUserList
	end
	self.fields.List:setNumItems(#self.applyUserShow)
	self.fields.Text_noApply:setVisible(#self.applyUserShow <= 0)
end
function Activity_9001657_ApplyPanel:onItemRenderer(index, obj)
	local data = self.applyUserShow[index + 1]
	obj:initData(data)
end
function Activity_9001657_ApplyPanel:onMsgUpdateApplyList(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "agreedUserNum" then
		self:updateAgreedUserNum()
	elseif subMsg == "applyUserList" then
		self:updateApplyList()
	else
		self:updateApplyList()
		self:updateAgreedUserNum()
	end
end
function Activity_9001657_ApplyPanel:updateApplyList(...)
	local activity_9001657_Ctrl, ret
	local applyUserList = activity_9001657_Ctrl:getApplyUserList()
	for k, v in pairs(applyUserList) do
		v.uid = tonumber(k)
		table.insert(ret, v)
	end
	self.applyUserList = ret
	self:sortList()
	self:filterList()
end
function Activity_9001657_ApplyPanel:updateAgreedUserNum(...)
	local numMax = constantRead.getConstValue("KINGDOM_MERGER_PEOPLE_NUMBER", 0)
	local userNum = activity_9001657_Ctrl:getAgreedUserNum()
	local isEnough = numMax > userNum
	local userNumStr = tostring(userNum)
	if isEnough then
		constantRead = nil
		;(nil).color = "#00ff00"
		userNumStr = SoraDWrapHtmlTagByStyle(userNumStr, nil)
	else
		constantRead = nil
		;(nil).color = "#ff0000"
		userNumStr = SoraDWrapHtmlTagByStyle(userNumStr, nil)
	end
	constantRead = nil
	;(nil).num = userNumStr
	;(nil).max = numMax
	self.fields.Text_num:setString(i18n("kingdom_merger_text12", nil))
	local c_type = self.fields.Node_condition:getController("c_type")
	if isEnough then
		c_type:setSelectedIndex(0)
	else
		c_type:setSelectedIndex(1)
	end
end
return Activity_9001657_ApplyPanel
