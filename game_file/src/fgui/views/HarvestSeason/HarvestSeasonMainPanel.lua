local gametop = gModuleMgr.getObject("gametop")
local actCommonltCtrl = include("actCommonltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HarvestSeasonMainPanel = class("HarvestSeasonMainPanel", baseFguiPanel)
function HarvestSeasonMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HarvestSeasonMainPanel:ctor", self.viewName)
end
function HarvestSeasonMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "HarvestSeason"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function HarvestSeasonMainPanel:onInit()
	print("=======HarvestSeasonMainPanel:onInit")
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	local lan = SoraDGetDefaultLanguage()
	self.controllers.lan:setSelectedIndex(lan == "ar" and 0 or 1)
	self.fields.Text_title:setString(i18n("cat_common_01"))
	self.fields.Text_tip:setString(i18n("cat_common_02"))
	self:initData()
end
function HarvestSeasonMainPanel:initData()
	local remainTime, actIDList = self:actOpen()
	self.buffData = self:getData(actIDList)
	self.fields.timer:initData(remainTime)
	self.fields.List_buff:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_buff:setNumItems(table.nums(self.buffData))
	if table.nums(self.buffData) < 7 then
		local originalSize = self.fields.List_buff:getHeight()
		self.fields.List_buff:resizeToFit(table.nums(self.buffData), 100)
		self.fields.List_buff:setHeight(self.fields.List_buff:getHeight() + 10)
		self.view:setPositionY(self.view:getPositionY() + (originalSize - self.fields.List_buff:getHeight()) / 2)
	end
end
function HarvestSeasonMainPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.buffData[index + 1])
end
function HarvestSeasonMainPanel:getData(actIDList)
	local configTable = require("app." .. LocalTblPath .. ".config_server.act_common_config")
	local _ENV, data = "app." .. LocalTblPath .. ".config_server.act_common_config", "app." .. LocalTblPath .. ".config_server.act_common_config"
	self.actConfig = self:getConfigList()
	for i, v in pairs(actIDList) do
		local actInfo = actCommonltCtrl.getConfig(v)
		local index = 1
		for k, value in pairs(actInfo.boost) do
			if value and 0 < value then
				local _ENV, tmp
				tmp.activityID = v
				tmp.boostType = k
				tmp.boostValue = value
				tmp.icon = self:getConfig(v, "icon", index)
				tmp.rank = self:getConfig(v, "rank", index)
				tmp.text = self:getConfig(v, "text", index)
				table.insert(data, tmp)
				index = index + 1
			end
		end
	end
	table.sort(data, function(a, b)
		if a.rank < b.rank then
			return true
		end
		return false
	end)
	printf("fdfkdfd545454543433iiiii")
	dump(data, "HarvestSeasonMainPanel", 10)
	return data
end
function HarvestSeasonMainPanel:getConfigList()
	local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
	local _ENV, ret = "app." .. LocalTblPath .. ".config_server.act_common_config", "app." .. LocalTblPath .. ".config_server.act_common_config"
	for actID, data in pairs(config) do
		ret[actID], _ENV = nil, nil
		for k, v in pairs(data) do
			if "string" == type(v) and "" ~= v then
				local temp = string.split(v, ";")
				if temp then
					for i = 1, #temp do
						local n = tonumber(temp[i])
						if n then
							temp[i] = n
						end
					end
				end
				ret[actID][k] = serviceFunctions.tableFormatToMap(temp)
			else
				ret[actID][k] = v
			end
		end
	end
	self.actConfig = ret
	return ret
end
function HarvestSeasonMainPanel:getConfig(actID, key1, key2)
	if not actID then
		return
	end
	local config = self.actConfig[actID]
	if nil == key1 or nil == config then
		return config
	end
	config = config[key1]
	if nil == key2 or nil == config then
		return config
	end
	return config[key2]
end
function HarvestSeasonMainPanel:judgeClose()
	local remainTime, actIDList = self:actOpen()
	if remainTime and remainTime ~= 0 then
		self:initData(remainTime, actIDList)
	elseif self then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function HarvestSeasonMainPanel:actOpen()
	local _ENV, actIDList
	local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local remainTime = 0
	for actID, v in pairs(config) do
		if clientEventMgr.judgeIsOpen(actID) then
			table.insert(actIDList, actID)
			local eventTime = activityShowCtrl:getTimeInfoByID(actID)
			if eventTime then
				local tmp = eventTime.timerNode.timer:getRemainTime()
				if remainTime < tmp then
					remainTime = tmp
				end
			end
		end
	end
	return remainTime, actIDList
end
function HarvestSeasonMainPanel:onShow()
	print("=======HarvestSeasonMainPanel:onShow")
end
function HarvestSeasonMainPanel:onHide()
	print("=======HarvestSeasonMainPanel:onHide")
	_ENV = "=======HarvestSeasonMainPanel:onHide"
	;("=======HarvestSeasonMainPanel:onHide").msg = "MESSAGE_HARVEST_SEASON_REDPOINT"
	SoraDSendMessage("=======HarvestSeasonMainPanel:onHide")
end
function HarvestSeasonMainPanel:onDispose()
	print("=======HarvestSeasonMainPanel:onDispose")
end
return HarvestSeasonMainPanel
