local worldMapBuildFireEffect = class("worldMapBuildFireEffect", function(target)
	return target
end)
local worldMapUtil = include("worldMapUtil")
function worldMapBuildFireEffect:resetFireEffect()
	self.fightTime = 0
	self:removeFireEffect()
	self:removeHurtDieEffect()
end
function worldMapBuildFireEffect:addFireEffect(fightTime)
	if not self.fireNode then
		self.fireNode = SoraDCreatAnimation("cwjz_ranshao_effect", nil, true)
		self.fireNode:setPosition(cc.p(self.centerPoint.x - 30, self.centerPoint.y + 30))
		self:addChild(self.fireNode, 3)
		SoraDPlaySound("worldmap", 3)
	end
	_UPVALUE1_ = "worldmap"
	;("worldmap")[1] = cca.delay(fightTime)
	;("worldmap")[2] = cca.callFunc(function()
		self:addFightEffect_imp()
	end)
	;("worldmap")[3] = cca.callFunc(function()
		self:addFightEffect_imp()
	end)
	local seq = cca.seq("worldmap")
	self.fireNode:runAction(seq)
end
function worldMapBuildFireEffect:updateFireEffect(status)
	if worldMapDefine.isGardenKingdomID() then
		self:removeHurtDieEffect()
		return
	end
	if status == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		if not self.fireNode_ex then
			_ENV, _ENV = self, self.fireNode_ex
			_ENV, self.fireNode_ex[1], self.plist = self, self, "et_castle_ranshao_yan_01.plist"
			_ENV, self.plist = nil, "et_castle_ranshao_yan_02.plist"
			;(nil).x = -6
			self.fireNode_ex[2], self.pos, (nil).y = self, nil, -16.32
			local param = self.fireNode_ex
			self.fireNode_ex = SoraDCreateEffectNode(param)
			self.fireNode_ex:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y - 0))
			self:addChild(self.fireNode_ex, 3)
		end
	else
		self:removeHurtDieEffect()
	end
end
function worldMapBuildFireEffect:addFightEffect_imp(otherData)
	local fightTime = worldMapUtil.getDelayTimeByFight(self.fightTime)
	if 0 < fightTime then
		self:addFireEffect(fightTime, otherData)
	else
		self:removeFireEffect()
	end
end
function worldMapBuildFireEffect:removeFireEffect(fightTime)
	if self.fireNode then
		self.fireNode:removeFromParent()
		self.fireNode = nil
	end
end
function worldMapBuildFireEffect:removeHurtDieEffect(fightTime)
	if self.fireNode_ex then
		self.fireNode_ex:removeFromParent()
		self.fireNode_ex = nil
	end
end
function worldMapBuildFireEffect:updateFightTime(fightTime, otherData)
	local OldfightTime = self.fightTime
	self.fightTime = fightTime
	if OldfightTime and 0 < OldfightTime then
		local time = worldMapUtil.getDelayTimeByFight(OldfightTime)
		if 0 < time then
			return
		end
	end
	self:addFightEffect_imp(otherData)
end
return worldMapBuildFireEffect
