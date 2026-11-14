local worldLodDef = worldMapDefine.worldLodDef
local cityCtrl = SoraDGetCtrl("cityCtrl")
local worldMapComLodUI = class("worldMapComLodUI", include("worldMapCom"))
function worldMapComLodUI:ctor()
	worldMapComLodUI.super.ctor(self, "worldMapComLodUI")
	self.lodNodeList, worldMapComLodUI = worldMapComLodUI.super.ctor, worldMapComLodUI.super.ctor
end
function worldMapComLodUI:init()
	worldMapComLodUI.super.init(self)
	self.lodUIView = self:initLodUIView()
	self:updateDisplayCenterPoint()
	table.insert(self.lodNodeList, self.lodUIView)
	self:initLodConfig()
	self:initMapLod(self.target_:getCurLod())
end
function worldMapComLodUI:initLodConfig(...)
	local mainUI = SoraDCurrentMainUI()
	local _ENV, config
	if mainUI then
		local mainUITop = mainUI:getMainUITop()
		local mainUIBottom = mainUI:getMainUIBottom()
		_ENV = nil
		;(nil).widget = mainUITop:getNodeAreaRT()
		;(nil).showLodMax = worldLodDef.LOD1
		;(nil).offset = cc.p(SoraDFSign(-200), 0)
		;(nil).isFgui = true
		table.insert(config, nil)
		_ENV = nil
		;(nil).widget = mainUITop:getNodeAreaLT()
		;(nil).showLodMax = worldLodDef.LOD1
		;(nil).offset = cc.p(SoraDFSign(250), 0)
		;(nil).isFgui = true
		table.insert(config, nil)
		_ENV = nil
		;(nil).widget = mainUITop:getNodeAreaTop()
		;(nil).showLodMax = worldLodDef.LOD5
		;(nil).offset = cc.p(0, -143)
		;(nil).beforeShow = function()
			mainUITop:setVisible(true)
		end
		;(nil).afterHide = function()
			mainUITop:setVisible(false)
		end
		;(nil).isFgui = true
		table.insert(config, nil)
		_ENV = nil
		;(nil).widget = mainUIBottom:getLodNode()
		;(nil).showLodMax = worldLodDef.LOD1
		;(nil).isFgui = true
		table.insert(config, nil)
		_ENV = nil
		;(nil).widget = mainUIBottom:getNodeAreaBottom()
		;(nil).showLodMax = worldLodDef.LOD5
		;(nil).offset = cc.p(0, 120)
		;(nil).beforeShow = function()
			mainUIBottom:setVisible(true)
		end
		;(nil).afterHide = function()
			mainUIBottom:setVisible(false)
		end
		;(nil).isFgui = true
		table.insert(config, nil)
	end
	_ENV = table.insert
	table.insert.widget = self.target_:getButtonWorldResouce()
	table.insert.showLodMax = worldLodDef.LOD1
	table.insert.offset = cc.p(SoraDFSign(110), 0)
	table.insert(config, table.insert)
	_ENV = table.insert
	table.insert.widget = self.target_:getButtonFavorite()
	table.insert.showLodMax = worldLodDef.LOD1
	table.insert(config, table.insert)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	if mapClassType == gKingdomClassType.normal then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getButtonMonsterSearch()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD5
		table.insert(config, worldLodDef.LOD1)
	elseif mapClassType == gKingdomClassType.nebula then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getNodeWar()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD1
		table.insert(config, worldLodDef.LOD1)
	elseif mapClassType == gKingdomClassType.atlantis then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getNodeWar()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD1
		table.insert(config, worldLodDef.LOD1)
	elseif mapClassType == gKingdomClassType.nebulaEmperor then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getNodeWar()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD1
		table.insert(config, worldLodDef.LOD1)
	elseif mapClassType == gKingdomClassType.roaringFlame then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getNodeWar()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD1
		table.insert(config, worldLodDef.LOD1)
	elseif mapClassType == gKingdomClassType.garden then
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getGardenNodeTop()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD2
		worldLodDef.LOD1.offset = cc.p(0, -100)
		worldLodDef.LOD1.isFgui = true
		table.insert(config, worldLodDef.LOD1)
		_ENV = worldLodDef.LOD1
		worldLodDef.LOD1.widget = self.target_:getGardenNodeBottom()
		worldLodDef.LOD1.showLodMax = worldLodDef.LOD2
		worldLodDef.LOD1.offset = cc.p(0, 120)
		worldLodDef.LOD1.isFgui = true
		table.insert(config, worldLodDef.LOD1)
	end
	_ENV = worldLodDef.LOD1
	worldLodDef.LOD1.widget = self.target_:getBottomPointNode()
	worldLodDef.LOD1.showLodMax = worldLodDef.LOD5
	table.insert(config, worldLodDef.LOD1)
	for i, v in ipairs(config) do
		if v.widget then
			local widget = SoraDCreatePanelByCloneNode(v.widget, "commonLODInstance")
			widget:initLODData(v)
			table.insert(self.lodNodeList, widget)
		end
	end
	self.lodUIView:initLodConfig()
end
function worldMapComLodUI:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateMapLod))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_DID, handler(self, self.updateDisplayCenterPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_UPDATE_SELF_POINT", handler(self, self.serverMessage_UpdateSelfPoint))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.resetMapLod))
end
function worldMapComLodUI:onExit()
	worldMapComLodUI.super.onExit(self)
	self:initMapLod(worldLodDef.LOD1)
end
function worldMapComLodUI:resetMapLod(...)
	local curLod = self.target_:getCurLod()
	if curLod == worldLodDef.LOD1 then
		return
	end
	self:initMapLod(curLod)
end
function worldMapComLodUI:initMapLod(lod)
	for i, node in ipairs(self.lodNodeList) do
		if not tolua.isnull(node) then
			node:initMapLod(lod)
		end
	end
end
function worldMapComLodUI:updateMapLod(event)
	for i, node in ipairs(self.lodNodeList) do
		node:updateMapLod(event)
	end
end
function worldMapComLodUI:initLodUIView(...)
	local worldMapWarDef = include("worldMapWarDef")
	local panelName = worldMapWarDef.getWarLodUIName()
	local worldMapLodUI = SoraDCreatePanel(panelName)
	worldMapLodUI:addTo(self.target_._ccsView)
	worldMapLodUI:setPosition(0, display.iPhoneXBottom)
	worldMapLodUI:setWorldMapView(self.target_)
	_ENV = self.target_
	self.target_.myCityTilePoint = cityCtrl:getCurCityPos()
	worldMapLodUI:updateData(self.target_)
	return worldMapLodUI
end
function worldMapComLodUI:updateDisplayCenterPoint(event)
	local centerTilePoint = self.target_:getDisplayCenterTilePoint()
	if centerTilePoint.x >= 0 and 0 <= centerTilePoint.y then
		_UPVALUE0_ = nil
		;(nil).centerTilePoint = centerTilePoint
		self.lodUIView:updateData(nil)
	end
end
function worldMapComLodUI:serverMessage_UpdateSelfPoint(target, data)
	_ENV = nil
	;(nil).myCityTilePoint = cc.p(data.data.x, data.data.y)
	self.lodUIView:updateData(nil)
end
return worldMapComLodUI
