local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameMapViewPanel = class("RoaringFlameMapViewPanel", baseFguiPanel)
_ENV = "RoaringFlameMapViewPanel"
;("RoaringFlameMapViewPanel").CAMP = 1
;("RoaringFlameMapViewPanel").BUILD = 2
local ("RoaringFlameMapViewPanel").PLOT, INFO_TYPE = 3, "RoaringFlameMapViewPanel"
function RoaringFlameMapViewPanel:ctor(...)
	self.isLRU = true
	RoaringFlameMapViewPanel.super.ctor(self, ...)
	print("RoaringFlameMapViewPanel:ctor", self.viewName)
end
function RoaringFlameMapViewPanel:onInit()
	print("=======RoaringFlameMapViewPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text108"), handler(self, self.onClickClose))
	self.fields.List_info:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_plot:addClickListener(handler(self, self.onClickBtnPlot))
	self.fields.Button_build:addClickListener(handler(self, self.onClickBtnBuild))
	local _fields = fguiHelper.get_fields(self.fields.Mod_bottom)
	_fields.Panel_log:addClickListener(handler(self, self.onClickPanelLog))
	_fields.Text_noData:setString(i18n("flames_dunes_text313"))
	self:initComMap()
end
function RoaringFlameMapViewPanel:endShow()
	print("=======RoaringFlameMapViewPanel:endShow")
	self.showType = INFO_TYPE.CAMP
	roaringFlameWarCtrl:reqBuildingOwnerData()
	roaringFlameWarCtrl:reqCampOccupyLog()
	self:updateListInfo()
end
function RoaringFlameMapViewPanel:updateListInfo(...)
	local itemNum = 0
	if self.showType == INFO_TYPE.CAMP then
		local campCount = roaringFlameWarRead.getCampCount()
		itemNum = campCount
	elseif self.showType == INFO_TYPE.BUILD then
		local buildCount = gWorldTypeServerDef.subTypeRoaringFlameWarPalace
		itemNum = buildCount
	elseif self.showType == INFO_TYPE.PLOT then
		local plotCount = roaringFlameWarRead.getPlotCount()
		itemNum = plotCount
	end
	self.fields.List_info:setNumItems(itemNum)
	self.fields.List_info:resizeToFit(itemNum)
	local showInfo2 = self.showType == INFO_TYPE.BUILD
	self.fields.Com_info2:setVisible(showInfo2)
	if showInfo2 then
		self:initComInfo2()
	end
	local showInfo3 = self.showType == INFO_TYPE.PLOT
	self.fields.Com_info3:setVisible(showInfo3)
	if showInfo3 then
		self:initComInfo3()
	end
end
function RoaringFlameMapViewPanel:onItemRenderer(index, obj)
	obj:getChild("icon"):setColor(cc.c3b(255, 255, 255))
	if self.showType == INFO_TYPE.CAMP then
		local camp = index + 1
		local campName = roaringFlameWarRead.getCampName(camp)
		obj:setString(campName)
		local campColor = roaringFlameWarRead.getCampColor(camp)
		obj:setColor(campColor)
		local imageName = roaringFlameWarRead.getCampZhankuangImage(camp)
		obj:setIcon(imageName)
	elseif self.showType == INFO_TYPE.BUILD then
		local subType = index + 1
		local buildName = roaringFlameWarRead.getBuildName(subType)
		obj:setString(buildName)
		obj:setColor(cc.c3b(240, 230, 210))
		local buildIcon = roaringFlameWarRead.getBuildIcon(subType)
		obj:setIcon(buildIcon)
	elseif self.showType == INFO_TYPE.PLOT then
		local plotType = index + 1
		local plotName = roaringFlameWarRead.getPlotName(plotType)
		obj:setString(plotName)
		local plotColor = roaringFlameWarRead.getPlotColor(plotType)
		obj:setColor(plotColor)
		obj:getChild("icon"):setColor(plotColor)
		obj:setIcon("progressbar_white.png")
	end
end
function RoaringFlameMapViewPanel:onClickBtnBuild(...)
	SoraDPlaySound()
	if self.showType ~= INFO_TYPE.BUILD then
		self.showType = INFO_TYPE.BUILD
		self.fields.Button_plot:setSelected(false)
	else
		self.showType = INFO_TYPE.CAMP
	end
	self:updateListInfo()
end
function RoaringFlameMapViewPanel:onClickBtnPlot(...)
	SoraDPlaySound()
	if self.showType ~= INFO_TYPE.PLOT then
		self.showType = INFO_TYPE.PLOT
		self.fields.Button_build:setSelected(false)
	else
		self.showType = INFO_TYPE.CAMP
	end
	self:updateListInfo()
end
function RoaringFlameMapViewPanel:onClickPanelLog(...)
	SoraDPlaySound()
	uiManager:show("RoaringFlameWar_BuildLog")
end
local p0 = cc.p(0, 0)
local w, h = 3.504, 1.752
function RoaringFlameMapViewPanel:initComMap(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_map)
	local Com_build = _fields.Com_build
	local Node_zero = _fields.Node_zero
	self.fields.Com_info2 = _fields.Com_info2
	self.fields.Com_info3 = _fields.Com_info3
	local zeroPos = Node_zero:getPosition()
	_UPVALUE11_, self.objMap, _ENV = {
		gWorldTypeServerDef.subTypeRoaringFlameWarInitCity,
		gWorldTypeServerDef.subTypeRoaringFlameWarMine,
		gWorldTypeServerDef.subTypeRoaringFlameWarFort,
		gWorldTypeServerDef.subTypeRoaringFlameWarWoods,
		gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix,
		gWorldTypeServerDef.subTypeRoaringFlameWarStation,
		gWorldTypeServerDef.subTypeRoaringFlameWarRuins,
		gWorldTypeServerDef.subTypeRoaringFlameWarGate,
		gWorldTypeServerDef.subTypeRoaringFlameWarGateway,
		gWorldTypeServerDef.subTypeRoaringFlameWarPalace,
		gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy
	}, {
		gWorldTypeServerDef.subTypeRoaringFlameWarInitCity,
		gWorldTypeServerDef.subTypeRoaringFlameWarMine,
		gWorldTypeServerDef.subTypeRoaringFlameWarFort,
		gWorldTypeServerDef.subTypeRoaringFlameWarWoods,
		gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix,
		gWorldTypeServerDef.subTypeRoaringFlameWarStation,
		gWorldTypeServerDef.subTypeRoaringFlameWarRuins,
		gWorldTypeServerDef.subTypeRoaringFlameWarGate,
		gWorldTypeServerDef.subTypeRoaringFlameWarGateway,
		gWorldTypeServerDef.subTypeRoaringFlameWarPalace,
		gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy
	}, {
		gWorldTypeServerDef.subTypeRoaringFlameWarInitCity,
		gWorldTypeServerDef.subTypeRoaringFlameWarMine,
		gWorldTypeServerDef.subTypeRoaringFlameWarFort,
		gWorldTypeServerDef.subTypeRoaringFlameWarWoods,
		gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix,
		gWorldTypeServerDef.subTypeRoaringFlameWarStation,
		gWorldTypeServerDef.subTypeRoaringFlameWarRuins,
		gWorldTypeServerDef.subTypeRoaringFlameWarGate,
		gWorldTypeServerDef.subTypeRoaringFlameWarGateway,
		gWorldTypeServerDef.subTypeRoaringFlameWarPalace,
		gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy
	}
	local showIconConfig = {
		gWorldTypeServerDef.subTypeRoaringFlameWarInitCity,
		gWorldTypeServerDef.subTypeRoaringFlameWarMine,
		gWorldTypeServerDef.subTypeRoaringFlameWarFort,
		gWorldTypeServerDef.subTypeRoaringFlameWarWoods,
		gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix,
		gWorldTypeServerDef.subTypeRoaringFlameWarStation,
		gWorldTypeServerDef.subTypeRoaringFlameWarRuins,
		gWorldTypeServerDef.subTypeRoaringFlameWarGate,
		gWorldTypeServerDef.subTypeRoaringFlameWarGateway,
		gWorldTypeServerDef.subTypeRoaringFlameWarPalace,
		gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy
	}
	for __, subType in ipairs(showIconConfig) do
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
		for __, objId in ipairs(buildIDList) do
			local subType = roaringFlameWarRead.getBuildSubType(objId)
			local buildIcon = roaringFlameWarRead.getBuildIcon(subType)
			local obj = display.newSpriteNoChild("#" .. buildIcon)
			obj:addTo(Com_build)
			self.objMap[objId] = obj
			if subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
				obj:setScale(1)
			else
				obj:setScale(0.5)
			end
			local tile = roaringFlameWarRead.getBuildServerCoord(objId)
			local point = worldMapDefine.tile2point(p0, tile, w, h)
			obj:setPosition(point)
		end
	end
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local curTime = serviceFunctions.systemTime()
	local isInWar = roaringFlameWarUtil.isInWarState()
	local checkOpenTime = function(objId)
		local openTime = roaringFlameWarRead.getBuildOpenTime(objId)
		if startTime + openTime > curTime then
			return false
		else
			return true
		end
	end
	for objId, obj in pairs(self.objMap) do
		local subType = roaringFlameWarRead.getBuildSubType(objId)
		local showProtect = false
		if not checkOpenTime(objId) then
			showProtect = true
		elseif not isInWar and roaringFlameWarUtil.checkShowProtect(subType) then
			showProtect = true
		end
		if showProtect then
			local sprite = display.newSpriteNoChild("#dh_Texture_XL_sstshd_000.png")
			sprite:addTo(Com_build, 1)
			sprite:setPosition(obj:getPosition())
			if subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
				sprite:setScale(0.6)
			else
				sprite:setScale(0.3)
			end
		end
	end
	local scrollpane = self.fields.Com_map:getScrollPane()
	local jumpPos
	if worldMapDefine.isInRoaringFlame() then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		jumpPos = cityCtrl:getCurCityPos()
	else
		jumpPos = roaringFlameWarRead.getBuildCoordBySubType(gWorldTypeServerDef.subTypeRoaringFlameWarPalace)
	end
	local point = worldMapDefine.tile2point(p0, jumpPos, w, h)
	local posx = point.x - display.cx
	local posy = -point.y - display.cy
	scrollpane:setPosition(cc.p(posx, posy))
end
function RoaringFlameMapViewPanel:initComInfo2(...)
	if self.isInitComInfo2 then
		return
	end
	self.isInitComInfo2 = true
	local roaringFlameWarUtil, cityLine3Map = self.isInitComInfo2, self.isInitComInfo2
	local fromPos, toPos, cityLine3
	local config = roaringFlameWarUtil.getBuildConnectConfig()
	for key, cfg in pairs(config) do
		fromPos = worldMapDefine.tile2point(p0, cfg.fromPos, w, h)
		toPos = worldMapDefine.tile2point(p0, cfg.toPos, w, h)
		cityLine3 = self:createCityLine(fromPos, toPos, cfg.lineType + 3, 0, cfg.isGatewayLine)
		cityLine3:addTo(self.fields.Com_info2)
		cityLine3Map[key] = cityLine3
	end
	self.cityLine3Map = cityLine3Map
end
function RoaringFlameMapViewPanel:initComInfo3(...)
	if self.isInitComInfo3 then
		return
	end
	self.isInitComInfo3 = true
	local sprite = display.newSpriteNoChild("#frame_9001674_ditusekuai.png")
	sprite:addTo(self.fields.Com_info3)
	sprite:setPosition(cc.p(900, -699))
	for __, cfg in ipairs(roaringFlameWarRead.get_flames_dunes_plot()) do
		local plotType = cfg.type
		local plotName = roaringFlameWarRead.getPlotName(plotType)
		local coordList = roaringFlameWarRead.getPlotCoordList(plotType)
		for __, coord in ipairs(coordList) do
			_ENV = roaringFlameWarRead.get_flames_dunes_plot()
			roaringFlameWarRead.get_flames_dunes_plot().text = plotName
			roaringFlameWarRead.get_flames_dunes_plot().size = 20
			local obj = SoraDCreateLabelNoChild(roaringFlameWarRead.get_flames_dunes_plot())
			obj:addTo(self.fields.Com_info3)
			local point = worldMapDefine.tile2point(p0, coord, w, h)
			obj:setPosition(point)
			obj:enableOutline(cc.c3b(30, 25, 25), 1)
		end
	end
end
function RoaringFlameMapViewPanel:createCityLine(beginPoint, endPoint, lineType, colorType, isGatewayLine)
	local cityLine = include("worldMapRoaringFlameLine").new(beginPoint, endPoint, lineType)
	cityLine:setPosition(beginPoint)
	cityLine:setMoveLineColor(colorType, isGatewayLine)
	cityLine:setScale(0.6)
	local distance = cityLine.distance
	cityLine:setWidth(distance / 0.6)
	return cityLine
end
function RoaringFlameMapViewPanel:onMsgUpdateBuildLog(target, event)
	local _fields = fguiHelper.get_fields(self.fields.Mod_bottom)
	local c1 = self.fields.Mod_bottom:getController("c1")
	if not event.rspdata then
		local _ENV, logList = event.rspdata, event.rspdata
	end
	local data = logList[1]
	if data then
		c1:setSelectedIndex(0)
		_ENV = c1
		c1.data = data
		local logStr = roaringFlameWarUtil.parseBuildLog(c1)
		_fields.Text_log:setString(logStr)
		_fields.Text_time:setString(SoraDConverTimeStr(data.t))
	else
		c1:setSelectedIndex(1)
	end
end
function RoaringFlameMapViewPanel:onMsgBuildingInfo(target, event)
	if not event.ownerMap then
		local _ENV, ownerMap = event.ownerMap, event.ownerMap
	end
	dump(ownerMap, "==ownerMap==")
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGateway)
	for __, objId in ipairs(buildIDList) do
		local _objId = roaringFlameWarRead.getGatewayCopy2gateway(objId)
		ownerMap[tostring(_objId)] = ownerMap[tostring(objId)]
	end
	for k, v in pairs(ownerMap) do
		local objId = tonumber(k)
		local obj = self.objMap[objId]
		if obj and v.camp then
			local campColor = roaringFlameWarRead.getCampColor(v.camp)
			obj:setColor(campColor)
			if not v.finishOccupy then
				roaringFlameWarRead = nil
				;(nil)[1] = ffa.fadeTo(0.7, 0.5)
				;(nil)[2] = ffa.fadeTo(0.7, 1)
				;(nil)[3] = ffa.fadeTo(0.7, 1)
				;(nil)[4] = ffa.fadeTo(0.7, 1)
				obj:runAction(ffa.repeatForever(ffa.seq(nil)))
			end
		end
	end
	local checkShowLine = function(owner1, owner2)
		if not owner1 or not owner1.finishOccupy then
			return
		end
		if not owner2 or not owner2.finishOccupy then
			return
		end
		return owner1.camp == owner2.camp
	end
	self:initComInfo2()
	local config = roaringFlameWarUtil.getBuildConnectConfig()
	for key, cfg in pairs(config) do
		local owner1 = ownerMap[tostring(cfg.fromObjId)]
		local owner2 = ownerMap[tostring(cfg.toObjId)]
		if checkShowLine(owner1, owner2) then
			local cityLine = self.cityLine3Map[key]
			local colorType = owner1.camp
			cityLine:setMoveLineColor(colorType, cfg.isGatewayLine)
			if not cfg.isGatewayLine then
				cityLine:changeLineType(4)
			end
		end
	end
end
return RoaringFlameMapViewPanel
