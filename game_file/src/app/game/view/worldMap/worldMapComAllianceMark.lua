local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local Z_ORDER = worldMapDefine.Z_ORDER
local GROU_ID = worldMapDefine.GROU_ID
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local worldMapComAllianceMark = class("worldMapComAllianceMark", include("worldMapCom"))
function worldMapComAllianceMark:ctor()
	worldMapComAllianceMark.super.ctor(self, "worldMapComAllianceMark")
	self.defecenMarkList, worldMapComAllianceMark, self.nodeList, worldMapComAllianceMark = worldMapComAllianceMark.super.ctor, worldMapComAllianceMark.super.ctor, worldMapComAllianceMark.super.ctor, worldMapComAllianceMark.super.ctor
	self.curLod = nil
end
function worldMapComAllianceMark:init()
	self.myKindomID = gametop.playertop_:getMapID()
	self.worldMapCell = self.target_.currentInMapViewCell
	self:initAllianceMark()
end
function worldMapComAllianceMark:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodLevel))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:toggle3D()
	SoraDAddMessage(self, "MESSAGE_SERVER_ALLIANCE_MARK_REFRESH", handler(self, self.refreshAllianceMark))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_MARK", handler(self, self.refresNebulaDefenceMark))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_WARDATA", handler(self, self.updateRoaringFlameMark))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_OCCUPY_NOTIFY", handler(self, self.onMsgRoaringFlameOccupyNotify))
end
function worldMapComAllianceMark:toggle3D(...)
	self:walkAllMark(function(target)
		target:toggle3D()
	end)
end
function worldMapComAllianceMark:initAllianceMark()
	local node = display.newNode()
	node:addTo(self.worldMapCell, Z_ORDER.selectView)
	node:setGroupID(GROU_ID.group_alliance_mark)
	node:setName("Node_AllianceMark")
	node:setGroupAuto(true)
	self.Node_AllianceMark = node
	self:refreshAllianceMark()
	self:refresNebulaDefenceMark()
	self:updateRoaringFlameMark()
	self:updateLodLevel()
end
function worldMapComAllianceMark:updateScaleZoom(event)
	local scale = event.revertScale
	self:walkAllMark(function(target)
		target:updateScaleZoom(scale)
	end)
end
function worldMapComAllianceMark:updateLodLevel(event)
	local lodLevel = self.target_:getCurLod()
	if self.curLod == lodLevel then
		return
	end
	self.curLod = lodLevel
	self:walkAllMark(function(target)
		target:updateLodLevel(self.curLod)
	end)
end
function worldMapComAllianceMark:walkAllMark(func)
	for k, v in pairs(self.nodeList) do
		if v.point then
			func(v.point)
		end
	end
	for k, v in pairs(self.defecenMarkList) do
		if v.point then
			func(v.point)
		end
	end
	if self.roaringFlameMark then
		func(self.roaringFlameMark)
	end
end
function worldMapComAllianceMark:updateCellSwap()
	self:refreshAllianceMarkNode()
	self:refresNebulaDefenceMark()
end
function worldMapComAllianceMark:refreshAllianceMarkNode()
	if not self.Node_AllianceMark then
		return
	end
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local node = self.Node_AllianceMark
	if node:getParent() ~= currentInMapViewCell then
		node:retain()
		node:removeFromParent(false)
		node:addTo(currentInMapViewCell)
		node:release()
	end
	self:refreshAllianceMark()
end
function worldMapComAllianceMark:refreshAllianceMark(...)
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local curMapID = currentInMapViewCell.kingdomID
	local allianceMarkData = collectMapCtrl:getAllianceMarkData()
	local curScale = self.target_.viewScrollView:getZoomScale()
	local revertScale = 1 / curScale
	local curLod = self.target_:getCurLod()
	local isInNebula = worldMapDefine.isInNebula()
	for k, v in pairs(allianceMarkData) do
		local node = self.nodeList[k] and self.nodeList[k].point
		if v.mapID == curMapID then
			if not node then
				node = SoraDCreatePanel("worldMapAllianceMark")
				node:addTo(self.Node_AllianceMark)
				node:updateLodLevel(curLod)
				node:updateScaleZoom(revertScale)
				node:toggle3D()
				collectMapCtrl = node
				self.nodeList[k], node.point = node, node
			else
				node:setVisible(true)
			end
			node:initData(v)
			local pos = cc.p(v.position[1], v.position[2])
			local holdInstace
			if isInNebula then
				local mapSyncUtilClient = include("mapSyncUtilClient")
				local nebulaWarRead = include("nebulaWarRead")
				local holdSize = nebulaWarRead.getBuildHoldSizeByPos(mapSyncUtilClient.clientTOServerPos(pos))
				if holdSize then
					holdInstace = holdSize
				end
			end
			local instancePoint = self.worldMapCell:getPointWithTile(pos, holdInstace)
			node:setPosition(instancePoint)
			node:setLocalZOrder(pos.x + pos.y)
		elseif node then
			node:setVisible(false)
		end
	end
	for k, v in pairs(self.nodeList) do
		if v.point and not allianceMarkData[k] then
			v.point:removeFromParent()
			v.point = nil
		end
	end
end
function worldMapComAllianceMark:refresNebulaDefenceMark(...)
	local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
	if not (not worldMapDefine.inInCrossWar() and worldMapDefine.checkCurrentKingdomIsMyKingdom()) or not activity_9001573_Ctrl:getCampMarkList() then
		local _ENV, campMarkList = activity_9001573_Ctrl:getCampMarkList(), activity_9001573_Ctrl:getCampMarkList()
	end
	local curScale = self.target_.viewScrollView:getZoomScale()
	local revertScale = 1 / curScale
	local curLod = self.target_:getCurLod()
	for k, v in pairs(campMarkList) do
		local node = self.defecenMarkList[k] and self.defecenMarkList[k].point
		if not node then
			node = SoraDCreatePanel("worldMapAllianceMark")
			node:addTo(self.Node_AllianceMark)
			node:updateScaleZoom(revertScale)
			node:updateLodLevel(curLod)
			node:toggle3D()
			_ENV = node
			self.defecenMarkList[k], node.point = node, node
		else
			node:setVisible(true)
		end
		_ENV = true
		;(true).name = v.desc
		;(true).markType = tonumber(k)
		;(true).collectType = gCollectType.nebulaDefence
		node:initData(true)
		local instancePoint = self.worldMapCell:getPointWithTile(cc.p(v.x, v.y))
		node:setPosition(instancePoint)
	end
	for k, v in pairs(self.defecenMarkList) do
		if v.point and not campMarkList[k] then
			v.point:removeFromParent()
			v.point = nil
		end
	end
end
function worldMapComAllianceMark:updateRoaringFlameMark(...)
	if not worldMapDefine.isRoaringFlameKingdomID() then
		return
	end
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	local buildID = roaringFlameWarUtil.getSelfCampInitCity()
	local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(buildID)
	if owner then
		if self.roaringFlameMark then
			self.roaringFlameMark:removeFromParent()
			self.roaringFlameMark = nil
		end
		return
	end
	if not self.roaringFlameMark then
		local curScale = self.target_.viewScrollView:getZoomScale()
		local revertScale = 1 / curScale
		local curLod = self.target_:getCurLod()
		local node = SoraDCreatePanel("worldMapAllianceMark")
		node:addTo(self.Node_AllianceMark)
		node:updateLodLevel(curLod)
		node:updateScaleZoom(revertScale)
		node:toggle3D()
		_ENV = node.toggle3D
		node.toggle3D.name = i18n("flames_dunes_text324")
		local node.toggle3D.iconName, data = "frame_9001674_world_punctuation.png", node.toggle3D
		node:updateTextName(data.name)
		node:updateSpriteIcon(data.iconName)
		node:setLocalZOrder(9999)
		self.roaringFlameMark = node
	end
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local color = roaringFlameWarRead.getCampColor(selfCamp)
	self.roaringFlameMark:updateSpriteColor(color)
	local pos = roaringFlameWarRead.getBuildCoord(buildID)
	local holdInstace = 2
	local instancePoint = self.worldMapCell:getPointWithTile(pos, holdInstace)
	self.roaringFlameMark:setPosition(instancePoint)
end
function worldMapComAllianceMark:onMsgRoaringFlameOccupyNotify(target, event)
	local subType = event.subType
	if subType ~= gWorldTypeServerDef.subTypeRoaringFlameWarInitCity then
		return
	end
	self:updateRoaringFlameMark()
end
return worldMapComAllianceMark
