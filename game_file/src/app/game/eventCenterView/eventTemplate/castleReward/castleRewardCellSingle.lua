local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local castleRewardRead = include("castleRewardRead")
local castleRewardCellSingle = class("castleRewardCellSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("castleRewardCellSingle")
	end
	return target
end)
local maxAwardNum = 6
function castleRewardCellSingle:ctor()
	self.goldAwardList, _ENV, self.normalAwardList, _ENV = nil, nil, nil, nil
	self.normalReward = SoraDGetChildByName(self, "Node_reward_Normal")
	self.imgLightLeft = SoraDGetChildByName(self, "image_Light_Left")
	SoraDMixtureGLONE(self.imgLightLeft)
	self.leftEffectNode = SoraDGetChildByName(self, "Node_reward_Normal_Effect")
	self.highReward = SoraDGetChildByName(self, "Node_reward_high")
	self.normalEf = SoraDGetChildByName(self, "blue")
	self.goldEf = SoraDGetChildByName(self, "orange")
	self.index = 1
	if not SoraDFIsRA() then
		print("======= Node_getGold:setScaleX")
		SoraDGetChildByName(self, "frame_wczx_bj_2"):setFlippedX(false)
		SoraDGetChildByName(self, "frame_wczx_bj_2"):getChildByName("icon"):setFlippedX(true)
	end
end
function castleRewardCellSingle:playAnimation(index)
	self.index = index
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.08333333333333333 * (index - 1))
	;(nil)[2] = cca.callFunc(function()
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = nil
		;(nil)[1] = cca.delay(1.65)
		;(nil)[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(100, 200, true)
		end)
		;(nil)[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(100, 200, true)
		end)
		self:runAction(cca.seq(nil))
	end)
	;(nil)[3] = cca.callFunc(function()
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = nil
		;(nil)[1] = cca.delay(1.65)
		;(nil)[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(100, 200, true)
		end)
		;(nil)[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(100, 200, true)
		end)
		self:runAction(cca.seq(nil))
	end)
	self:runAction(cca.seq(nil))
end
function castleRewardCellSingle:initData(parent, cfg)
	self.parentView = parent
	self.cfg = cfg
	local curlv = SoraDGetCastleLv()
	local isHaveCanGet = false
	SoraDGetChildByName(self, "Text_slv"):setString(cfg.castlelv)
	local isBuy = castleRewardCtrl:getIsBuy()
	local isGot = castleRewardCtrl:isRecevied(1, cfg.castlelv)
	local canGet = false
	if curlv >= cfg.castlelv and not isGot and not castleRewardCtrl:isRecevied(1, cfg.castlelv) then
		canGet = true
	end
	self.normalAwardList = self:initAwardNode(self.normalReward, self.normalAwardList, false, isGot, canGet, isBuy, cfg.castlelv)
	if canGet then
		isHaveCanGet = true
	end
	self.normalEf:setVisible(canGet)
	canGet = false
	local isGoldGot = castleRewardCtrl:isRecevied(2, cfg.castlelv)
	if castleRewardCtrl:getIsBuy() and curlv >= cfg.castlelv and not isGoldGot and not castleRewardCtrl:isRecevied(2, cfg.castlelv) then
		canGet = true
	end
	self.goldAwardList = self:initAwardNode(self.highReward, self.goldAwardList, true, isGoldGot, canGet, isBuy, cfg.castlelv)
	if canGet then
		isHaveCanGet = true
	end
	self.goldEf:setVisible(canGet)
	return isHaveCanGet
end
function castleRewardCellSingle:initAwardNode(parent, nodeList, isGold, isGot, canGet, isBuy, castleLv)
	local _ENV, awardList
	if isGold then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		awardList = serviceFunctions.tableFormat(self.cfg[2].reward, nil)
	else
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		awardList = serviceFunctions.tableFormat(self.cfg[1].reward, nil)
	end
	parent:stopAllActions()
	local setPosFunc = function()
		for i = maxAwardNum + 1, #nodeList do
			nodeList[i]:setVisible(false)
		end
		local align = 2
		if isGold and SoraDFIsRA() then
			align = 0
		end
		for k, v in pairs(nodeList) do
			v:setVisible(true)
		end
		SoraDautoSortPos(parent, 3, align, cc.size(85, 85), SoraDFIsRA())
	end
	for i = 1, math.min(#awardList, maxAwardNum) do
		local single = nodeList[i]
		if not single then
			single = include("castleRewardSingle").new()
			single:setOwnScroll(self.parentView)
			single:initData(awardList[i], isGot, canGet, isGold, isBuy, castleLv)
			single:setPosition(0, 0)
			single:addTo(parent)
			table.insert(nodeList, single)
		else
			single:initData(awardList[i], isGot, canGet, isGold, isBuy, castleLv)
			single:setVisible(true)
		end
	end
	setPosFunc()
	return nodeList
end
return castleRewardCellSingle
