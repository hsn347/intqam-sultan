local armyDes = include("armyDesRead")
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapRemainsPanel = class("WorldMapRemainsPanel", baseFguiPanel)
function WorldMapRemainsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapRemainsPanel:ctor", self.viewName)
end
function WorldMapRemainsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapRemainsPanel:onInit()
	print("=======WorldMapRemainsPanel:onInit")
	self.remainsData, _ENV, self.isHideCurrentSceneView = print, print, true
	self.fields.Com_title:initData(i18n("common_text_459"), handler(self, self.onClickClose))
	self.fields.Button_retreat:setTitleText(i18n("common_text_569"))
	self.fields.Button_army:setTitleText(i18n("common_text_019"))
	self.fields.Button_retreat:addClickListener(handler(self, self.btnRetreatClick))
	self.fields.Button_army:addClickListener(handler(self, self.btnArmyClick))
end
function WorldMapRemainsPanel:onShow()
	print("=======WorldMapRemainsPanel:onShow")
	self:initData(self.proxy.param)
end
function WorldMapRemainsPanel:initData(tileInstance)
	if tileInstance and tileInstance.__cname == "worldMapRemains" then
		local remiansPos = SoraDStringSplit(tileInstance.tilesArray[1], ",")
		local instanceID = tileInstance.instanceID
		local kingdomID = tileInstance:getWorldMapCell().kingdomID
		_ENV = tileInstance
		tileInstance.instanceID = tileInstance.instanceID
		tileInstance.x = remiansPos[1]
		self.selfInstance, tileInstance.y = tileInstance, remiansPos[2]
		kingdomMapCtrl:reqMapObjInfo(remiansPos[1], remiansPos[2], instanceID, kingdomID)
	end
end
function WorldMapRemainsPanel:initView(remainsData)
	self.remainsData = remainsData
	self:initFlags(false)
	self:updateScroll()
	self.fields.Bar_time:initData(self.remainsData)
end
function WorldMapRemainsPanel:initFlags(needBegin)
	local _ENV, tblPos
	local nowLayerID = math.floor(self.remainsData.finishTime / 180 / 5)
	local nowFlagID = math.ceil(self.remainsData.finishTime / 180)
	local leftTime = nowFlagID * 180 - self.remainsData.finishTime
	local mapID = nowLayerID % 3 + 1
	local flagID = nowLayerID % 2 + 1
	self.fields.Bg_tile:setURL(string.format("img_adventure_stage_%02d.png", mapID))
	local WorldMapRemainsMap = include("worldMapRemainsMap")
	local tablePosMap = WorldMapRemainsMap.getDefauleMap(122, 61)
	local mapData = WorldMapRemainsMap.getMapData(mapID)
	local tablePosFlag = WorldMapRemainsMap.getMapFlagData(mapID, flagID)
	for i, v in ipairs(mapData) do
		for index, val in ipairs(v) do
			if val ~= 0 then
			end
			if tablePosFlag[i][index] ~= 0 then
				tblPos[tablePosFlag[i][index]] = tablePosMap[i][index]
			end
		end
	end
	if needBegin then
		nowFlagID = nowFlagID + 1
		leftTime = 180
	end
	print("nowFlagID", nowFlagID, nowLayerID)
	local Zorder
	local offsetY = self.fields.Bg_tile:getPositionY()
	local offsetX = (self:getWidth() - 640) / 2 - 35
	for i = 1, 5 do
		Zorder = i
		local flagAc = self.fields["Flag" .. i]
		flagAc:setVisible(true)
		flagAc:setPosition(tblPos[i].x + offsetX, offsetY + tblPos[i].y)
		flagAc:setLayer(nowLayerID * 5 + i, i)
		flagAc:setHandlCallBack(handler(self, self.flagCompleteCallBack))
		if nowFlagID == nowLayerID * 5 + i then
			flagAc:beginTime(leftTime)
		elseif nowFlagID > nowLayerID * 5 + i then
			flagAc:setMeUsed()
		else
			flagAc:setMeUnused()
		end
	end
end
function WorldMapRemainsPanel:updateScroll()
	local logText = ""
	if not self.remainsData.log then
		_ENV = self.remainsData.log
	end
	for i, v in ipairs(self.remainsData.log) do
		local addStr = ""
		if v.type == gRelicsExploreResultType.inTrap then
			if next(v.result) ~= nil then
				_ENV = nil
				;(nil).num = i
				;(nil).content = i18n("relicLogType1")
				addStr = i18n("common_text_457", nil)
				for _, v in ipairs(v.result) do
					addStr = addStr .. armyDes.getName(v.id) .. "*" .. v.num
				end
			else
				_ENV = ipairs(v.result)
				ipairs(v.result).num = i
				ipairs(v.result).content = i18n("relicLogType6")
				addStr = i18n("common_text_457", ipairs(v.result))
			end
		elseif v.type == gRelicsExploreResultType.findFood then
			_ENV = ipairs(v.result)
			ipairs(v.result).num = i
			_ENV = addStr
			addStr.count = tostring(v.num)
			ipairs(v.result).content = i18n("relicLogType3", addStr)
			addStr = i18n("common_text_457", ipairs(v.result))
		elseif v.type == gRelicsExploreResultType.findWood then
			_ENV = ipairs(v.result)
			ipairs(v.result).num = i
			_ENV = addStr
			addStr.count = tostring(v.num)
			ipairs(v.result).content = i18n("relicLogType2", addStr)
			addStr = i18n("common_text_457", ipairs(v.result))
		elseif v.type == gRelicsExploreResultType.killGuard then
			_ENV = ipairs(v.result)
			ipairs(v.result).num = i
			_ENV = addStr
			addStr.count = tostring(v.num)
			ipairs(v.result).content = i18n("relicLogType4", addStr)
			addStr = i18n("common_text_457", ipairs(v.result))
		elseif v.type == gRelicsExploreResultType.killGuardFail then
			_ENV = ipairs(v.result)
			ipairs(v.result).num = i
			_ENV = addStr
			addStr.count = tostring(v.num)
			ipairs(v.result).content = i18n("relicLogType5", addStr)
			addStr = i18n("common_text_457", ipairs(v.result))
		elseif v.type == gRelicsExploreResultType.findMaterial then
			local itemDesRead = include("itemDesRead")
			local itemName = itemDesRead.getName(v.id)
			_ENV = "relicLogType5"
			;("relicLogType5").num = i
			_ENV = v.num
			v.num.name = itemName
			v.num.num = v.num
			;("relicLogType5").content = i18n("common_text_1264", v.num)
			addStr = i18n("common_text_457", "relicLogType5")
		elseif v.type == gRelicsExploreResultType.findSteel then
			_ENV = i18n("common_text_457", "relicLogType5")
			i18n("common_text_457", "relicLogType5").num = i
			_ENV = i18n("common_text_1264", v.num)
			i18n("common_text_1264", v.num).num = tostring(v.num)
			i18n("common_text_457", "relicLogType5").content = i18n("common_text_1265", (i18n("common_text_1264", v.num)))
			addStr = i18n("common_text_457", (i18n("common_text_457", "relicLogType5")))
		end
		logText = logText .. addStr .. "\n"
	end
	self.fields.Com_Log:initData(logText)
	self.fields.Com_Log:jumpToBottom()
end
function WorldMapRemainsPanel:flagCompleteCallBack(flagNum, index)
	if self.fields["Flag" .. index + 1] then
		self.fields["Flag" .. index + 1]:beginTime(180)
	elseif flagNum < self.remainsData.allTime / 180 then
		self.remainsData.finishTime = flagNum * 180
		self:initFlags(true)
	else
		self.fields.Bar_time:endTime()
		print("探险完毕，关闭窗口")
		self:removeFromParent()
		return
	end
	print("self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID, #self.remainsData.log ", self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID, #self.remainsData.log)
	kingdomMapCtrl:reqRelicsEvent(self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID, #self.remainsData.log)
end
function WorldMapRemainsPanel:btnRetreatClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("notice_0025"), i18n("common_text_204"), nil, function(type)
		if type == MSGBOX_CALLBACK_YES then
			if tolua.isnull(self) then
				return
			end
			kingdomMapCtrl:reqBackQueue(self.selfInstance.x, self.selfInstance.y, self.selfInstance.instanceID)
			self:removeFromParent()
		end
	end)
end
function WorldMapRemainsPanel:btnArmyClick()
	SoraDPlaySound()
	local armyData = self.remainsData.army
	if not armyData then
		return
	end
	local leagueName = ""
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		leagueName = allianceMgr:getAllianceProperty("abbr")
	end
	_ENV = nil
	;(nil).troopsData = armyData
	;(nil).allianceName = leagueName
	uiManager:show("WorldMapTroopsDetails", nil)
end
return WorldMapRemainsPanel
