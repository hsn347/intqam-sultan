local worldMapComSelect = class("worldMapComSelect", include("worldMapCom"))
local worldMapViewDef = include("worldMapViewDef")
local MIN_TIME_MARCH = worldMapViewDef.MIN_TIME_MARCH
local MIN_TIME_DRAG = worldMapViewDef.MIN_TIME_DRAG
local Z_ORDER = worldMapDefine.Z_ORDER
function worldMapComSelect:ctor()
	worldMapComSelect.super.ctor(self, "worldMapComSelect")
end
function worldMapComSelect:init()
	worldMapComSelect.super.init(self)
	self.containerView = self.target_.containerView
end
function worldMapComSelect:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL", handler(self, self.removeSelectShowPanel))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_VISIBLE_SELECTSHOWPANEL", handler(self, self.visibleSelectShowPanel))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_SHOW_TROOPTIP", handler(self, self.showTroopTip))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP", handler(self, self.removeTroopTip))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
end
function worldMapComSelect:showTroopTip(target, data)
	self:removeSelectShowPanel()
	local moveLine = self.target_:getMoveLineShow(data)
	if not moveLine then
		return
	end
	local troopInstance = moveLine:getTroopInstance()
	if not troopInstance then
		return
	end
	if not troopInstance:isVisible() then
		return
	end
	if self.currentTroopTip then
		if self.currentTroopTip.close then
			self.currentTroopTip:close()
		end
		self.currentTroopTip = nil
	end
	if troopInstance.setSoliderVisible then
		troopInstance:setSoliderVisible(true)
	end
	local troopTip = include("worldMapTroopTip").new()
	troopTip:initData(moveLine)
	troopTip:show()
	self.currentTroopTip = troopTip
	self.updateMoveContainerTimerHandle = SoradCreateTimer(self, handler(self, self.updateMoveContainerWithTroop), true)
	self:updateMoveContainerWithTroop()
	self.target_.MIN_TIME = MIN_TIME_MARCH
end
function worldMapComSelect:removeTimer()
	if self.updateMoveContainerTimerHandle then
		SoraDManagerRemoveTimer(self, self.updateMoveContainerTimerHandle)
		self.updateMoveContainerTimerHandle = nil
	end
end
function worldMapComSelect:removeTroopTip(target, data)
	if self.currentTroopTip and self.currentTroopTip.__cname then
		local moveLineID = self.currentTroopTip:getMoveLineID()
		if moveLineID == data.moveLineID then
			self:removeTimer()
			if self.currentTroopTip.close then
				self.currentTroopTip:close()
			end
			self.currentTroopTip = nil
			if data.mapMoveToTilePoint then
				self.target_:moveTilePointToCenter(data.mapMoveToTilePoint)
			end
		end
	end
	self.target_.MIN_TIME = MIN_TIME_DRAG
end
function worldMapComSelect:updateMoveContainerWithTroop()
	if not self.currentTroopTip then
		return
	end
	local moveLine = self.currentTroopTip.moveLine
	if not moveLine or tolua.isnull(moveLine) then
		return
	end
	local worldMapCell = moveLine:getWorldMapCell()
	if not worldMapCell or not worldMapCell.__cname then
		return
	end
	local troopInstance = self.currentTroopTip.troopInstance
	if not (troopInstance and troopInstance.__cname) or tolua.isnull(troopInstance) then
		return
	end
	local x, y = troopInstance:getPosition()
	local troopPoint = cc.p(x, y)
	troopPoint = SoraDCoverToPoint2DOr3D(worldMapCell, troopPoint, self.containerView)
	self.target_:moveMapPointToCenter(troopPoint)
end
function worldMapComSelect:removeSelectShowPanel(target, data)
	if not (self.selectShowPanel and self.selectShowPanel.getTilePoint) or tolua.isnull(self.selectShowPanel) then
		self.selectShowPanel = nil
		return false
	end
	local guideStep = SoraDIsGameGuide()
	if guideStep ~= nil and 880100 <= guideStep and guideStep < 900200 then
		return true
	end
	local isRemove = true
	if data and data.relatedTilePoints then
		isRemove = false
		if self.selectShowPanel and self.selectShowPanel.__cname ~= "worldMapAtlantisBossView" then
			local tilePoint = self.selectShowPanel:getTilePoint()
			for _, v in pairs(data.relatedTilePoints) do
				if math.floor(v.x) == math.floor(tilePoint.x) and math.floor(v.y) == math.floor(tilePoint.y) then
					isRemove = true
					break
				end
			end
		end
	end
	if isRemove and self.selectTileRolygon ~= nil then
		self.selectTileRolygon:removeFromParent(true)
		self.selectTileRolygon = nil
		if self.selectTilesRolygon then
			self.selectTilesRolygon:removeFromParent()
			self.selectTilesRolygon = nil
		end
		if self.selectShowPanel ~= nil then
			self.selectShowPanel:removeFromParent()
			self.selectShowPanel = nil
		end
		return true
	end
	return false
end
function worldMapComSelect:visibleSelectShowPanel(target, data)
	if not self.selectShowPanel or not self.selectShowPanel.getTilePoint then
		return
	end
	self.target_:moveTilePointToCenter(self.selectShowPanel:getTilePoint(), false, nil, nil, 0.3)
	self.selectShowPanel:setVisible(data.isVisible)
end
function worldMapComSelect:cleanData()
	if self.selectTileRolygon ~= nil then
		if not tolua.isnull(self.selectTileRolygon) then
			self.selectTileRolygon:removeFromParent(true)
		end
		self.selectTileRolygon = nil
		if self.selectTilesRolygon then
			if not tolua.isnull(self.selectTilesRolygon) then
				self.selectTilesRolygon:removeFromParent()
			end
			self.selectTilesRolygon = nil
		end
		if self.selectShowPanel ~= nil then
			if not tolua.isnull(self.selectShowPanel) then
				self.selectShowPanel:removeFromParent()
			end
			self.selectShowPanel = nil
		end
	end
	self:removeSelectShowPanel()
	if self.currentTroopTip then
		local troopMoveLineID = self.currentTroopTip:getMoveLineID()
		_ENV = true
		;(true).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
		;(true).moveLineID = troopMoveLineID
		SoraDSendMessage(true)
	end
	self:removeCurrentTroopTip()
end
function worldMapComSelect:resetData()
	self.selectTileRolygon = nil
	self.selectTilesRolygon = nil
	self.selectShowPanel = nil
	self.currentTroopTip = nil
end
function worldMapComSelect:onExit()
	worldMapComSelect.super.onExit(self)
	self:removeSelectShowPanel()
	self:removeCurrentTroopTip()
end
function worldMapComSelect:removeCurrentTroopTip()
	if self.currentTroopTip then
		if self.currentTroopTip.close then
			self.currentTroopTip:close()
		end
		self.currentTroopTip = nil
	end
end
function worldMapComSelect:updateMapPos(event)
	if self.selectShowPanel and self.selectShowPanel.__cname == "worldMapTip" then
		self.selectShowPanel:updateMapPos()
	end
end
function worldMapComSelect:updateScaleZoom(event)
	if self.worldMapLodClickTip then
		local scale = event.revertScale
		self.worldMapLodClickTip:setScale(1.5 * scale)
	end
end
function worldMapComSelect:onClickInstance_imp(returnData)
	if returnData.selectShowPanel then
		self.selectShowPanel = returnData.selectShowPanel
		local isTrue = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("worldMapView", "isTrue")
		if isTrue then
			gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("worldMapView")
		elseif isTrue == false then
			gModuleMgr.sharedMgr("mildGuideManager"):clean()
		end
	end
	if returnData.selectTileRolygon then
		self.selectTileRolygon = returnData.selectTileRolygon
	end
	if returnData.selectTilesRolygon then
		self.selectTilesRolygon = returnData.selectTilesRolygon
	end
end
function worldMapComSelect:getTipButtons(tipButtonType)
	if self.selectShowPanel and self.selectShowPanel.__cname == "worldMapTip" then
		for _, v in pairs(self.selectShowPanel.tipButtonsArray) do
			local tipButton = v
			if tipButton.tipButtonType == tipButtonType then
				return tipButton.bgButton
			end
		end
	end
	return nil
end
function worldMapComSelect:removeLodClickTip(...)
	if self.worldMapLodClickTip then
		self.worldMapLodClickTip:removeFromParent()
		self.worldMapLodClickTip = nil
	end
end
function worldMapComSelect:showLodClickTip(data)
	self:removeLodClickTip()
	local toTilePos = data.toTilePos
	local touchEndPoint = data.touchEndPoint
	local kingdomID = data.kingdomID
	local node = SoraDCreatAnimation("worldMapLodClickTip", nil, false)
	node:addTo(self.target_.containerViewNode, Z_ORDER.selectView)
	node:setName("worldMapLodClickTip")
	local Button_click = SoraDGetChildByName(node, "Button_click")
	Button_click:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:removeLodClickTip()
			_ENV = nil
			;(nil).toTilePos = toTilePos
			;(nil).toScale = worldMapViewDef.NORMAL_SCALE
			;(nil).kingdomID = kingdomID
			;(nil).needAction = true
			;(nil).isSelected = true
			self.target_:gotoTilePointNew(self.target_, nil)
		end
	end)
	local coverShowPoint = self.target_.containerViewNode:convertToNodeSpace(touchEndPoint)
	node:setPosition(coverShowPoint)
	local scale = self.target_.containerView:getScale()
	node:setScale(1.5 / scale)
	self.worldMapLodClickTip = node
end
function worldMapComSelect:exportMethods()
	_UPVALUE5_ = nil
	;(nil)[1] = "removeSelectShowPanel"
	;(nil)[2] = "onClickInstance_imp"
	;(nil)[3] = "getTipButtons"
	;(nil)[4] = "showLodClickTip"
	;(nil)[5] = "removeLodClickTip"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComSelect
