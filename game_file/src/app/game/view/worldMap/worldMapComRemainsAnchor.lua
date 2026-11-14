local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorUtil = include("anchorUtil")
local remainsWarUtil = include("remainsWarUtil")
local RW_CAMP = _G.RW_CAMP
local worldMapComRemainsAnchor = class("worldMapComRemainsAnchor", include("worldMapCom"))
function worldMapComRemainsAnchor:ctor()
	worldMapComRemainsAnchor.super.ctor(self, "worldMapComRemainsAnchor")
end
function worldMapComRemainsAnchor:init()
	self:createMapTip()
	self.btnRemainsWarSouth = SoraDGetChildByName(self.target_, "Button_remainswar_south")
	self.btnRemainsWarSouth:addTouchEventListener(handler(self, self.btnRemainsWarSouthCall))
	self.btnRemainsWarNorth = SoraDGetChildByName(self.target_, "Button_remainswar_north")
	self.btnRemainsWarNorth:addTouchEventListener(handler(self, self.btnRemainsWarNorthCall))
end
function worldMapComRemainsAnchor:createMapTip()
	local kid = self.target_.currentInMapViewCell.kingdomID
	if 0 < kid then
		local Z_ORDER = worldMapDefine.Z_ORDER
		local height = display.height + display.iPhoneXBottom
		local pyramidTip = include("worldMapPyramidTip").new()
		pyramidTip:setPosition(cc.p(display.cx, height - 270))
		pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	end
end
function worldMapComRemainsAnchor:onMessageListener()
end
function worldMapComRemainsAnchor:onEnter()
	self:reqSyncRW()
end
function worldMapComRemainsAnchor:onExit()
	worldMapComRemainsAnchor.super.onExit(self)
	if not worldMapDefine.isInRemains() then
		local kingdomID = self.target_.currentInMapViewCell.kingdomID
		if worldMapDefine.isRemainsKingdomID(kingdomID) and remainsWarUtil.checkIsReqSyncRw() then
			remainsWarCtrl:reqStopSyncRW(kingdomID)
		end
	end
end
function worldMapComRemainsAnchor:reqSyncRW()
	if not worldMapDefine.isInRemains() and remainsWarUtil.checkIsReqSyncRw() then
		remainsWarCtrl:reqSyncRW(worldMapDefine.currentMapKindomID)
	end
end
function worldMapComRemainsAnchor:doReqestData()
	self:reqSyncRW()
end
function worldMapComRemainsAnchor:btnRemainsWarSouthCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:doWarInfo(RW_CAMP.SOUTH_KEY)
	end
end
function worldMapComRemainsAnchor:btnRemainsWarNorthCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:doWarInfo(RW_CAMP.NORTH_KEY)
	end
end
function worldMapComRemainsAnchor:doWarInfo(camp)
	local data = remainsWarCtrl:getRemainsWarCampData()
	if not data[camp] then
		local remainsWarCtrl, warData = data[camp], data[camp]
	end
	local teamId = warData.teamId
	if teamId and 0 < teamId then
		anchorUtil.watchAllianceWar(teamId)
	end
end
return worldMapComRemainsAnchor
