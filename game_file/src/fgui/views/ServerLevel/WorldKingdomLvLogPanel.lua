local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldKingdomLvLogPanel = class("WorldKingdomLvLogPanel", baseFguiPanel)
function WorldKingdomLvLogPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldKingdomLvLogPanel:ctor", self.viewName)
end
function WorldKingdomLvLogPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldKingdomLvLogPanel:onInit()
	print("=======WorldKingdomLvLogPanel:onInit")
	self.fields.Text_No_Log:setString(i18n("common_text_1464"))
	self:setMultiple()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function WorldKingdomLvLogPanel:onShow()
	print("=======WorldKingdomLvLogPanel:onShow")
	self:init(self.proxy.param)
end
function WorldKingdomLvLogPanel:onItemRender(index, target)
	target:initData(self.itemsData[index + 1])
end
function WorldKingdomLvLogPanel:init(data)
	self.logType = data.logType
	self.isActOpen = data.isActOpen
	self.isTower = data.isTower
	if self.logType == gKingdomLevelLogType.LOG_EVENTS then
		self.itemsData = self:getEventDatas()
		self.fields.List:setNumItems(#self.itemsData)
		self.fields.Panel_bg:setString(i18n("common_text_3954"))
	else
		SoraDShowLoading(self)
		kingdomLevelDataModuleAPI:getKingdomLevelExpInfo()
		self.fields.Panel_bg:setString(i18n("common_text_4047"))
	end
	if self.isActOpen then
		self.fields.img_num_buff:setVisible(true)
		if self.fields.buff_tip then
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomLevelCtrl = gametop.playertop_:getModule("kingdomLevelCtrl")
			_ENV = i18n("common_text_4047")
			i18n("common_text_4047").Percent = kingdomLevelCtrl:getMultiple() * 100
			self.fields.buff_tip:setString(i18n("common_text_4192", i18n("common_text_4047")))
		end
	else
		self.fields.img_num_buff:setVisible(false)
	end
end
function WorldKingdomLvLogPanel:setMultiple()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomLevelCtrl = gametop.playertop_:getModule("kingdomLevelCtrl")
	self.multiple = kingdomLevelCtrl:getMultiple()
	if self.multiple > 1 then
		self.fields.img_num_buff:setIcon(string.format("icon_9001068_num_%02d.png", self.multiple))
	else
		self.fields.img_num_buff:setVisible(false)
	end
end
function WorldKingdomLvLogPanel:updateLogView(logs)
	self.itemsData = self:getLogDatas(logs)
	self.fields.List:setNumItems(#self.itemsData)
	self:updateNodeLogTip()
end
function WorldKingdomLvLogPanel:getEventDatas()
	local nebulaTowerLvDesRead, ret
	local expList = self.isTower and nebulaTowerLvDesRead.getExpList() or worldKingdomLvDesRead.getExpList()
	if not expList then
		expList, nebulaTowerLvDesRead = nil, nil
	end
	for i, v in ipairs(expList) do
		nebulaTowerLvDesRead = nil
		;(nil).logType = gKingdomLevelLogType.LOG_EVENTS
		;(nil).logData = v
		;(nil).index = i
		table.insert(ret, nil)
	end
	return ret
end
function WorldKingdomLvLogPanel:getLogDatas(logs)
	local _ENV, ret
	if not logs then
		logs, _ENV = nil, nil
	end
	for i, v in ipairs(logs) do
		_ENV = nil
		;(nil).logType = gKingdomLevelLogType.LOG_HISTORY
		;(nil).logData = v
		;(nil).index = i
		table.insert(ret, nil)
	end
	return ret
end
function WorldKingdomLvLogPanel:updateNodeLogTip()
	if self.logType == gKingdomLevelLogType.LOG_HISTORY then
		if self.itemsData and #self.itemsData > 0 then
			self.fields.Text_No_Log:setVisible(false)
		else
			self.fields.Text_No_Log:setVisible(true)
		end
	end
end
return WorldKingdomLvLogPanel
