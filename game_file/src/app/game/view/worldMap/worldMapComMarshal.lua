local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local Z_ORDER = worldMapDefine.Z_ORDER
local GROU_ID = worldMapDefine.GROU_ID
local atlantisWarUtil = include("atlantisWarUtil")
local worldLodDef = worldMapDefine.worldLodDef
local worldMapComMarshal = class("worldMapComMarshal", include("worldMapCom"))
function worldMapComMarshal:ctor()
	worldMapComMarshal.super.ctor(self, "worldMapComMarshal")
	self.effectList, worldMapComMarshal, self.nodeList, worldMapComMarshal = worldMapComMarshal.super.ctor, worldMapComMarshal.super.ctor, worldMapComMarshal.super.ctor, worldMapComMarshal.super.ctor
	self.curLod = nil
end
function worldMapComMarshal:init()
	local kingdomID = worldMapDefine.currentMapKindomID
	local worldMapCell = self.target_:getWorldMapCell(kingdomID)
	if not worldMapCell then
		return
	end
	self:initAtlantisMarshal(worldMapCell)
end
function worldMapComMarshal:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", handler(self, self.refreshMarshalEffect))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_MARSHAL_CHANGE", handler(self, self.refreshMarshalEffect))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_MEMBERCLASS_CHANGE", handler(self, self.refreshMarshalEffect))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
end
function worldMapComMarshal:updateLodChange(event)
	local lodLevel = self.target_:getCurLod()
	if self.curLod == lodLevel then
		return
	end
	self.curLod = lodLevel
	self:refreshMarshalNode()
	self:refreshMarshalEffect()
end
function worldMapComMarshal:initAtlantisMarshal(worldMapCell)
	if not worldMapDefine.isInAtlantis() then
		return
	end
	local marshalPointList = atlantisWarUtil.getMarshalPointList()
	for i, v in ipairs(marshalPointList) do
		local node = display.newNode()
		node:addTo(worldMapCell, Z_ORDER.tmxView)
		node:setGroupID(GROU_ID.group_instance)
		node:setGroupAuto(true)
		table.insert(self.nodeList, node)
		local effect = display.newSprite("#Atlantis_build_marshal.png")
		effect:addTo(node)
		local effect = SoraDCreatAnimation("dikuai_blue_big", nil, true)
		effect:addTo(node)
		effect:setScale(0.25)
		effect:setPosition(0, 6)
		effect:setVisible(false)
		self.effectList[tostring(v.buildId)] = effect
		local tilePoint = v.tilePoint
		local instancePoint = worldMapCell:getPointWithTile(cc.p(tilePoint.x + 0.5, tilePoint.y + 0.5))
		node:setPosition(instancePoint)
	end
end
function worldMapComMarshal:refreshMarshalNode(...)
	local nodeVisible = self.curLod and self.curLod < worldLodDef.LOD4
	for __, v in ipairs(self.nodeList) do
		v:setVisible(nodeVisible)
	end
end
function worldMapComMarshal:refreshMarshalEffect(...)
	if self.curLod and self.curLod >= worldLodDef.LOD2 then
		for k, v in pairs(self.effectList) do
			v:setVisible(false)
		end
		return
	end
	for k, v in pairs(self.effectList) do
		if atlantisWarUtil.checkCanMoveInMarshal(tonumber(k)) then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
return worldMapComMarshal
