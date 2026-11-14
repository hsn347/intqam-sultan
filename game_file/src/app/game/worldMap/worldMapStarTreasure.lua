local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local worldMapStarTreasure = class("worldMapStarTreasure", function(target)
	local target = include("worldMapInstance").new("worldMapStarTreasure")
	return target
end)
local CD_TIME = 1800
function worldMapStarTreasure:ctor()
	self.createUid = 0
	self.leagueID = 0
	self.status = gLosRuinsStatus.SURVEY
	self.lostRuins = display.newSprite("#Map_build_starTreasure.png")
	self.lostRuins:setPosition(cc.p(-30, 10))
	self:addChild(self.lostRuins)
end
function worldMapStarTreasure:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW", handler(self, self.updateData))
end
function worldMapStarTreasure:setBatchNodeGroupID(groupID)
	self.lostRuins:setGroupID(groupID)
end
function worldMapStarTreasure:initInstanceData(resourceClassID, treasureData)
	self:updateData(treasureData)
end
function worldMapStarTreasure:updateData(treasureData)
	dump(treasureData, "fjslfjsfjksfdjkdfjkdfjkd")
	self.curOwnUid = treasureData.curOwnUid
end
function worldMapStarTreasure:playClickSound()
	SoraDPlaySound()
end
function worldMapStarTreasure:onClickInstance(onShowView)
	if lordInfoCtrl:getSourceKid() > 0 or lordInfoCtrl:getMapSourceKid() ~= self.kingdomID then
		SoraDShowMsgTip(i18n("ramadanTreasure_text10"))
		return
	end
	if self.curOwnUid ~= gametop.playertop_:getPlayerID() then
		SoraDShowMsgTip(i18n("ramadanTreasure_text10"))
		return
	end
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapStarTreasure:getInstanceOp(isSelfKindom)
	local _UPVALUE0_, buttonTypeArray
	return buttonTypeArray
end
return worldMapStarTreasure
