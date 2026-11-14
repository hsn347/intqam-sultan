local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local activityTimeRead = include("activityTimeRead")
local _ENV, _ENV, activityFuncMap = nil, "activityTimeRead", "activityTimeRead"
;(nil)[gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597] = true
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001666] = true
local _ENV, (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001705], groupActivityConfig = gActivityTimeActivityID.NORMAL_ACTIVITY_9001705, true, nil
local _ENV, gActivityTimeActivityID.NORMAL_ACTIVITY_9001705[gActivityTimeActivityID.NORMAL_ACTIVITY_9001665], groupActivity2Config = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665, true, gActivityTimeActivityID.NORMAL_ACTIVITY_9001705
function gActivityTimeActivityID.NORMAL_ACTIVITY_9001665:openFunc()
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] then
		_ENV = nil
		;(nil).command = "szfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	if groupActivity2Config[self.activityID] then
		local input = self.fields.input:getText()
		if input ~= "" then
			param = param .. "," .. input
		end
		_ENV = nil
		;(nil).command = "szfzhd2"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",240,1"
	end
	_ENV = nil
	;(nil).command = "sztyhd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
function gActivityTimeActivityID.NORMAL_ACTIVITY_9001665:changeFunc()
	local param = tostring(self.activityID)
	_ENV = nil
	;(nil).command = "qhhdzt"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
activityFuncMap.default, gActivityTimeActivityID.NORMAL_ACTIVITY_9001665.closeFunc = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665, function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
function _ENV(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
activityFuncMap[gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY], (function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).openFunc = function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end, "szjrd"
function _ENV(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
;(function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).openFunc = "kqzymrt"
;(function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).changeFunc = "zymrtqhzt"
activityFuncMap[gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY], (function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).closeFunc = function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end, "gbzymrt"
function _ENV(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
;(function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).openFunc = "kqysrq"
activityFuncMap[gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY], (function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).closeFunc = function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end, "gbysrq"
function _ENV(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
activityFuncMap[gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY], (function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).openFunc = function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end, "kqhtxb"
function _ENV(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end
activityFuncMap[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708], (function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end).openFunc = function(self)
	local param = tostring(self.activityID)
	if groupActivityConfig[self.activityID] or groupActivity2Config[self.activityID] then
		_ENV = nil
		;(nil).command = "gbfzhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local input = self.fields.input:getText()
	if input ~= "" then
		param = param .. "," .. input
	else
		param = param .. ",10"
	end
	_ENV = nil
	;(nil).command = "jshd"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
end, "kqymfchd"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatActivityDetailPanel = class("CheatActivityDetailPanel", baseFguiPanel)
function CheatActivityDetailPanel:ctor(...)
	CheatActivityDetailPanel.super.ctor(self, ...)
	print("CheatActivityDetailPanel:ctor", self.viewName)
end
function CheatActivityDetailPanel:onInit()
	print("=======CheatActivityDetailPanel:onInit")
	self.activityID = self.param.activityID
	local activityName = activityTimeRead.getActivityShowName(self.activityID)
	self.fields.Panel_bg:setString(self.activityID .. "-" .. activityName)
	self.fields.Com_page = self.fields.Com_page:getChild("content")
	self:initActivityPage(self.fields.Com_page, self.activityID)
	local _fields = fguiHelper.get_fields(self.fields.Label_input)
	self.fields.input = _fields.input
	_fields.input:setPrompt("可输入额外参数(持续时间,奖励组等)")
	_UPVALUE4_ = _fields.input.setPrompt
	_fields.input.setPrompt[1] = "开启活动"
	_fields.input.setPrompt[2] = "切换活动状态"
	_fields.input.setPrompt[3] = "结束活动"
	local _fields.input.setPrompt[4], config = "打开活动", _fields.input.setPrompt
	self.cfgList = config
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#self.cfgList)
end
function CheatActivityDetailPanel:onShow()
	print("=======CheatActivityDetailPanel:onShow")
end
function CheatActivityDetailPanel:initActivityPage(obj, activityID)
	local self = obj
	local cfg = activityTimeRead.getNormalEventConfig(activityID)
	activityTimeRead = activityID
	activityID.eventName = cfg.name
	local activityID.pageBg, data = cfg.bg, activityID
	self.fields.Text_name:setString(data.eventName)
	self.fields.Image_bg:setURL(data.pageBg)
	self:setTouchEnabled(false)
end
function CheatActivityDetailPanel:onItemRenderer(index, obj)
	local cfg = self.cfgList[index + 1]
	obj:setString(cfg)
	obj:addClickListener(handler(self, self.onClickBtn))
	obj:setTag(index)
end
function CheatActivityDetailPanel:onClickBtn(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag() + 1
	if index == 1 or index == 2 or index == 3 then
		self:doActivityFunc(index)
	elseif index == 4 then
		clientEventMgr.singleClickEvent(self.activityID)
	end
end
function CheatActivityDetailPanel:doActivityFunc(index)
	_UPVALUE3_ = nil
	;(nil)[1] = "openFunc"
	;(nil)[2] = "changeFunc"
	local (nil)[3], config = "closeFunc", nil
	local funcKey = config[index]
	local cfg = activityFuncMap[self.activityID]
	local func = cfg and cfg[funcKey] or activityFuncMap.default[funcKey]
	if not func then
		return
	end
	if type(func) == "string" then
		local param = self.fields.input:getText()
		if param == "" then
			param = nil
		end
		activityFuncMap = nil
		;(nil).command = func
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
	else
		func(self)
	end
end
return CheatActivityDetailPanel
