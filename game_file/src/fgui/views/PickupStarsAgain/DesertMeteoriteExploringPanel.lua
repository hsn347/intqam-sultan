local armyDes = include("armyDesRead")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local timeCtrl = SoraDGetCtrl("timeCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMeteoriteExploringPanel = class("DesertMeteoriteExploringPanel", baseFguiPanel)
function DesertMeteoriteExploringPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DesertMeteoriteExploringPanel:ctor", self.viewName)
end
function DesertMeteoriteExploringPanel:onInit()
	print("=======DesertMeteoriteExploringPanel:onInit")
	self.fields.Panel_bg:setString(i18n("pickup_star_019"))
	self.fields.Button_troop:setString(i18n("buildDes_name_109"))
	self.fields.Button_exit:setString(i18n("common_text_569"))
	self.fields.Button_troop:addClickListener(handler(self, self.onClickTroop))
	self.fields.Button_exit:addClickListener(handler(self, self.onClickExit))
	self.fields.Progress:setValue(0)
	self.fields.List_log:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_log:setItemProvider(handler(self, self.onItemProvider))
	self.fields.Button_troop:fixPos()
	self.fields.Button_exit:fixPos()
end
function DesertMeteoriteExploringPanel:onItemRenderer(index, obj)
	print("index", index, #self.data.log)
	if index < #self.data.log then
		local data = self.data.log[index + 1]
		local _ENV, listReward = index + 1, index + 1
		local logCfg = pickupStarsAgainRead:getDesetMeteoritesLog(data.type)
		for _, v1 in ipairs(data.result) do
			_ENV = nil
			;(nil).name = publicRead.getName(v1.id)
			;(nil).count = v1.count
			table.insert(listReward, i18n("pickup_star_028", nil))
		end
		_ENV = ipairs(data.result)
		ipairs(data.result).var = table.concat(listReward, ",")
		local str = i18n(logCfg.Description, ipairs(data.result))
		obj:setString(str)
	else
		obj:updateView()
	end
	obj:showBg(index % 2 ~= 0)
end
function DesertMeteoriteExploringPanel:onItemProvider(index)
	if index == #self.data.log then
		return "ui://PickupStarsAgain/DesertMeteoriteExploringLog"
	else
		return "ui://PickupStarsAgain/Label_log"
	end
end
function DesertMeteoriteExploringPanel:onClickTroop()
	SoraDPlaySound()
	local armyData = self.data.army
	if not armyData then
		return
	end
	local leagueName = ""
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		leagueName = allianceMgr:getAllianceProperty("abbr")
	end
	_ENV = nil
	;(nil).troopsData = armyData
	;(nil).allianceName = leagueName
	uiManager:show("WorldMapTroopsDetails", nil)
end
function DesertMeteoriteExploringPanel:onClickExit()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("notice_0025"), i18n("common_text_204"), nil, function(type)
		if type == MSGBOX_CALLBACK_YES then
			kingdomMapCtrl:reqBackQueue(self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID)
			self:close()
		end
	end)
end
function DesertMeteoriteExploringPanel:onShow()
	print("=======DesertMeteoriteExploringPanel:onShow")
	dump(self.param, "DesertMeteoriteExploringPanel:onShow param", 10)
	local tileInstance = self.param
	local remiansPos = SoraDStringSplit(tileInstance.tilesArray[1], ",")
	local instanceID = tileInstance.instanceID
	local kingdomID = tileInstance:getWorldMapCell().kingdomID
	_ENV = tileInstance
	tileInstance.instanceID = tileInstance.instanceID
	tileInstance.x = remiansPos[1]
	self.selfInstance, tileInstance.y = tileInstance, remiansPos[2]
	kingdomMapCtrl:reqMapObjInfo(remiansPos[1], remiansPos[2], instanceID, kingdomID)
	self.fields.Loader_banner:setURL("bg_zlxc_01.png")
	kingdomMapCtrl:reqMapObjInfo(remiansPos[1], remiansPos[2], instanceID, kingdomID)
	pickupStarsAgainCtrl:reqInit()
end
function DesertMeteoriteExploringPanel:initView(data)
	dump(data, "DesertMeteoriteExploringPanel:initView")
	self.data = data
	self:updateView()
end
function DesertMeteoriteExploringPanel:updateView()
	if not self.data then
		return
	end
	self.fields.Progress:setMin(0)
	self.fields.Progress:setMax(self.data.allTime)
	self:removeTimer()
	self.startTime = timeCtrl:getServerTime()
	self:updateTime()
	self.timerHandler = SoradCreateTimer(self, handler(self, self.updateTime), false)
	self:updateLog()
end
function DesertMeteoriteExploringPanel:removeTimer()
	if self.timerHandler then
		SoraDManagerRemoveTimer(self, self.timerHandler)
		self.timerHandler = nil
	end
end
function DesertMeteoriteExploringPanel:updateTime()
	local finishTime = self.data.finishTime
	if finishTime > self.data.allTime then
		self.fields.Text_time:setString("")
	else
		local leftTime = self.data.allTime - finishTime
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.fields.Text_time:setString(i18n("pickup_star_015", nil))
	end
	self.fields.Progress:setValue(finishTime)
	self.data.finishTime = self.data.finishTime + 1
end
function DesertMeteoriteExploringPanel:addLog(data)
	for _, v in ipairs(data) do
		table.insert(self.data.log, v)
	end
	self:updateLog()
end
function DesertMeteoriteExploringPanel:updateLog()
	local perLogTime = constantRead.getConstValue("DESERT_METEORITES_TIME")
	local nextLogTime = perLogTime - self.data.finishTime % perLogTime + 1
	print("nextLogTime", nextLogTime, perLogTime, self.data.finishTime)
	SoraDDelayCallOnce("DesertMeteoriteExploringPanel:updateLog", function()
		local logIndex = #self.data.log
		kingdomMapCtrl:reqExploreDesertMeteoriteEvent(self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID, logIndex)
	end, nextLogTime)
	self.fields.List_log:setNumItems(#self.data.log + 1)
	self.fields.List_log:getScrollPane():scrollBottom(true)
end
function DesertMeteoriteExploringPanel:onHide()
	SoraDManagerRemoveTimerByTarget("DesertMeteoriteExploringPanel:updateLog")
end
return DesertMeteoriteExploringPanel
