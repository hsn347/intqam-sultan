local worldMapBoss = include("worldMapBoss")
local worldMapBossAtlantis = class("worldMapBossAtlantis", worldMapBoss)
function worldMapBossAtlantis:ctor()
	worldMapBossAtlantis.super.ctor(self)
end
function worldMapBossAtlantis:_initData(...)
	worldMapBossAtlantis.super._initData(self)
	self.warStatus = gKingdomWarStatusType.close
end
function worldMapBossAtlantis:_initUI()
	worldMapBossAtlantis.super._initUI(self)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(1.4)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
	self.image_level:setVisible(false)
	self.levelLabel:setVisible(false)
end
function worldMapBossAtlantis:updateData(data)
	worldMapBossAtlantis.super.updateData(self, data)
	if not data then
		return
	end
	if data.objId then
		self.objId = data.objId
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updateSafeState()
end
function worldMapBossAtlantis:getObjId(...)
	return self.objId
end
function worldMapBossAtlantis:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = SoraDCreatePanel("worldMapAtlantisBossView")
	selectShowPanel:setTilePoint(self.tilePoint)
	selectShowPanel:initData(self)
	selectShowPanel:show()
	return selectShowPanel, true
end
function worldMapBossAtlantis:updateSafeState(...)
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
		self.progressBar:setVisible(false)
	end
end
return worldMapBossAtlantis
