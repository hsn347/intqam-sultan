local alliancePBLBigIconNode = class("alliancePBLBigIconNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLBigIconNode")
	end
	return target
end)
function alliancePBLBigIconNode:ctor()
	self.spriteBg = SoraDGetChildByName(self, "Sprite_bg")
	self.spriteBg1 = SoraDGetChildByName(self, "Sprite_bg1")
	self.spriteRound = SoraDGetChildByName(self, "Sprite_round")
	self:initData()
	SoraDCreatAnimationEx(self.__cname, self, true)
end
function alliancePBLBigIconNode:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local totalSeason = math.min(pyramidWarCtrl.peakSeasonNo, 10)
	self.spriteRound:setSpriteFrame("jztdfs.s" .. totalSeason .. ".png")
end
return alliancePBLBigIconNode
