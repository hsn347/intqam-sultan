local lostRuinsAwardPop = class("lostRuinsAwardPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lostRuinsAwardPop")
end)
function lostRuinsAwardPop:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("hero_title_02"))
	self.textDescribe = SoraDGetChildByName(self, "Text_describe")
	self.textDescribe:setString(i18n("lost_ruins_text_31"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
end
function lostRuinsAwardPop:initData(bossType, desc)
	if desc then
		self.textDescribe:setString(desc)
	end
	bossType = bossType and bossType or gBossType.lostRuinsBoss
	local reward = worldMapDefine.getWorldBossReward(bossType, 1)
	_UPVALUE2_ = 1
	;(1)[1] = reward
	;(1)[2] = bossType
	dump(1, "lostRuinsAwardPop")
	for k, id in ipairs(reward) do
		local itemAward = include("commonItemAward").new()
		itemAward:setRealScale(0.8)
		itemAward:setOwnView(self)
		itemAward:setPosition(0, 0)
		itemAward:addTo(self.nodeAward)
		itemAward:initData(id, 1)
	end
	SoraDToCenter(self.nodeAward, 100)
end
return lostRuinsAwardPop
