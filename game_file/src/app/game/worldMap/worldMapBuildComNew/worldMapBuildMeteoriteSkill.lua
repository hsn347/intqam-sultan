local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildMeteoriteSkill = class("worldMapBuildMeteoriteSkill", worldMapBuildComNew)
function worldMapBuildMeteoriteSkill:ctor(...)
	worldMapBuildMeteoriteSkill.super.ctor(self, ...)
end
function worldMapBuildMeteoriteSkill:_initData(...)
	self.leagueID = 0
end
function worldMapBuildMeteoriteSkill:updateData(data)
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.attr then
		local isAdd = false
		for i, v in ipairs(gRangeAttributeList) do
			local attr = data.attr[tostring(v)]
			if attr then
				if self:isNeedShowAttr(v) then
					self.target_:sendTileEffectMessage(worldMapLeagueManorUpdateType.leagueManorInstanceAdd, attr.range)
					self:checkAllCastleMeteorteEffect(data.attr, false)
					isAdd = true
				end
				break
			end
		end
		if not isAdd then
			self.target_:sendTileEffectMessage(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
		end
	else
		self:removeMeteoriteSkillEffect()
	end
end
function worldMapBuildMeteoriteSkill:isNeedShowAttr(attrEnum)
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local leagueID = self.leagueID or 0
	for i, v in ipairs(gMeteoriteSkillList) do
		print("attrEnum,v", attrEnum, v)
		if attrEnum == v then
			if selfLeagueID == leagueID then
				return true
			else
				return false
			end
		end
	end
	return true
end
function worldMapBuildMeteoriteSkill:checkAllCastleMeteorteEffect(attr, isRemove)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ret = worldMapView:getShowTilesArray()
	if ret == nil then
		return
	end
	local selfPoint = self.target_:getTilePoint()
	for i, v in ipairs(gMeteoriteSkillList) do
		local attrValue = attr[tostring(v)]
		if attr[tostring(v)] then
			local rect = cc.rect(selfPoint.x - attrValue.range, selfPoint.y - attrValue.range, attrValue.range * 2, attrValue.range * 2)
			for _, tileInstance in pairs(ret) do
				if tileInstance and tileInstance.instanceType == gMapObjTypeDef.mapObjTypePlayer and self.leagueID == tileInstance.leagueID then
					local tilePoint = tileInstance:getTilePoint()
					if cc.rectContainsPoint(rect, tilePoint) then
						tileInstance:addMeteoriteSkillEffect(v)
					end
				end
			end
		end
	end
end
function worldMapBuildMeteoriteSkill:addMeteoriteSkillEffect(atttE)
	if atttE == gAttributeEnum.METEOR_MARCH_SPEED_BOOST then
		self:removeMeteoriteSkillEffect()
		local effectSp = display.newSprite("#dh_chengbaosxzs_01.png")
		effectSp:setPosition(cc.p(-15, 50))
		effectSp:setScale(2.0)
		effectSp:addTo(self.target_, 1)
		local frames = display.newFrames("dh_chengbaosxzs_%.2d.png", 1, 30)
		local animation = display.newAnimation(frames, 1.0 / #frames)
		effectSp:playAnimationForever(animation)
		_UPVALUE1_ = cc.p(-15, 50)
		cc.p(-15, 50)[1] = cca.delay(5)
		cc.p(-15, 50)[2] = cca.callFunc(function()
			self:removeMeteoriteSkillEffect()
		end)
		cc.p(-15, 50)[3] = cca.callFunc(function()
			self:removeMeteoriteSkillEffect()
		end)
		effectSp:runAction(cca.seq(cc.p(-15, 50)))
		self.meteoriteEffect = effectSp
	else
		local effectSp = display.newSprite("#dh_chengbaosxjn_01.png")
		effectSp:setPosition(cc.p(-15, 150))
		effectSp:setScale(2.5)
		effectSp:addTo(self.target_, 1)
		local frames = display.newFrames("dh_chengbaosxjn_%.2d.png", 1, 29)
		local animation = display.newAnimation(frames, 2.0 / #frames)
		_ENV = cc.p(-15, 150)
		cc.p(-15, 150).removeSelf = true
		effectSp:playAnimationOnce(animation, cc.p(-15, 150))
	end
end
function worldMapBuildMeteoriteSkill:removeMeteoriteSkillEffect()
	if self.meteoriteEffect then
		self.meteoriteEffect:removeFromParent()
		self.meteoriteEffect = nil
	end
end
return worldMapBuildMeteoriteSkill
