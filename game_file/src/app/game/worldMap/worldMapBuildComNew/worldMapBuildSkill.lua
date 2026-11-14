local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildSkill = class("worldMapBuildSkill", worldMapBuildComNew)
_ENV = "worldMapBuildSkill"
;("worldMapBuildSkill").RUINS_WAR_MOVE_CITY_LOCKED = 1
;("worldMapBuildSkill").RUINS_WAR_SPEED_QUEUE_LOCKED = 2
;("worldMapBuildSkill").APPOINT_DAMAGE_BOOST = 3
local ("worldMapBuildSkill").APPOINT_CURE_SOLDIER_SPEED_BOOST, skillEffectType = 4, "worldMapBuildSkill"
function worldMapBuildSkill:ctor(...)
	worldMapBuildSkill.super.ctor(self, ...)
end
function worldMapBuildSkill:updateData(data)
	self:refreshSkillEffect(data)
end
function worldMapBuildSkill:refreshSkillEffect(data)
	if not self.skillEffectList then
		skillEffectType = self.skillEffectList
		skillEffectType = nil
		;(nil).key = "isMoveCityLocked"
		self.skillEffectList[skillEffectType.RUINS_WAR_MOVE_CITY_LOCKED], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isSpeedQueueLocked"
		self.skillEffectList[skillEffectType.RUINS_WAR_SPEED_QUEUE_LOCKED], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isInDamagePlus"
		self.skillEffectList[skillEffectType.APPOINT_DAMAGE_BOOST], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isInCureSpeedPlus"
		self.skillEffectList, self.skillEffectList[skillEffectType.APPOINT_CURE_SOLDIER_SPEED_BOOST], (nil).effect = self.skillEffectList, nil, nil
	end
	for i, v in ipairs(self.skillEffectList) do
		if data[v.key] then
			if not v.effect then
				v.effect = self:createSkillEffect(i)
			end
		elseif v.effect then
			v.effect:removeFromParent()
			v.effect = nil
		end
	end
end
function worldMapBuildSkill:createSkillEffect(effectType)
	if effectType == skillEffectType.RUINS_WAR_MOVE_CITY_LOCKED then
		local effect = SoraDCreatAnimation("Node_yjzz_jntx2", nil, false)
		effect:addTo(self.target_, 6)
		effect:setPosition(0, 50)
		return effect
	end
	if effectType == skillEffectType.RUINS_WAR_SPEED_QUEUE_LOCKED then
		local effect = SoraDCreatAnimation("Node_yjzz_jntx1", nil, false)
		effect:addTo(self.target_, 5)
		effect:setPosition(0, 0)
		return effect
	end
	if effectType == skillEffectType.APPOINT_DAMAGE_BOOST then
		local criSprite = cc.criSprite.createCriSprite("G_shixue.usm", false, true, nil)
		criSprite:addTo(self.target_, 6)
		criSprite:setPosition(0, 80)
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
		return criSprite
	end
	if effectType == skillEffectType.APPOINT_CURE_SOLDIER_SPEED_BOOST then
		local criSprite = cc.criSprite.createCriSprite("shengliao.usm", false, true, nil)
		criSprite:addTo(self.target_, 6)
		criSprite:setPosition(-10, 50)
		return criSprite
	end
end
return worldMapBuildSkill
