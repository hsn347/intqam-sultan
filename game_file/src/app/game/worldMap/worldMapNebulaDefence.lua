local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local activity_9001573_Read = include("activity_9001573_Read")
local worldMapNebulaDefence = class("worldMapNebulaDefence", function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end)
function worldMapNebulaDefence:ctor()
	self.modelImage = display.newSprite("#alliance_mineral_nongtian.png")
	self:addChild(self.modelImage, -1)
	self.image_name_bg = display.newSprite("#frame_map_07.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 60))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 20
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 62))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.effect1 = nil
	self.effect2 = nil
end
function worldMapNebulaDefence:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapNebulaDefence:initInstanceData(objId, buildData)
	self.objId = objId
	self:updateData(buildData)
end
_ENV, _ENV, worldMapNebulaDefence.initBuildInfo = function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end, function(self, ...)
	local buildInfo = activity_9001573_Read.getBuild(self.objId)
	self.buildInfo = buildInfo
	if buildInfo == nil then
		return
	end
	print(buildInfo.buildType, "buildInfo.buildType")
	if self.effect1 then
		self.effect1:removeFromParent()
		self.effect1 = nil
	end
	if self.effect2 then
		self.effect2:removeFromParent()
		self.effect2 = nil
	end
	if self.effect3 then
		self.effect3:removeFromParent()
		self.effect3 = nil
	end
	if buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall then
		if buildInfo.buildPic == "Celestial_build_wall_02.png" then
			self.modelImage:setPosition(cc.p(-52, 52))
		else
			self.modelImage:setPosition(cc.p(-32, 41))
		end
		self.modelImage:setScale(1.05)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarTower then
		if self.status == gNebulaDefenceWarBuildStatus.RUIN then
			self.modelImage:setPosition(cc.p(-25, 40))
		else
			self.modelImage:setPosition(cc.p(-100, 120))
		end
		self.modelImage:setScale(1.0)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarGateway then
		self.modelImage:setPosition(cc.p(-46, 74))
		self.modelImage:setScale(1.0)
	end
	if self.status == gNebulaDefenceWarBuildStatus.RUIN then
		self.modelImage:setSpriteFrame(buildInfo.breakPic)
	else
		self.modelImage:setSpriteFrame(buildInfo.buildPic)
	end
	self.text_Name:setString(i18n(buildInfo.buildName))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	self:updateEffect()
end, function(self, ...)
	local buildInfo = activity_9001573_Read.getBuild(self.objId)
	self.buildInfo = buildInfo
	if buildInfo == nil then
		return
	end
	print(buildInfo.buildType, "buildInfo.buildType")
	if self.effect1 then
		self.effect1:removeFromParent()
		self.effect1 = nil
	end
	if self.effect2 then
		self.effect2:removeFromParent()
		self.effect2 = nil
	end
	if self.effect3 then
		self.effect3:removeFromParent()
		self.effect3 = nil
	end
	if buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall then
		if buildInfo.buildPic == "Celestial_build_wall_02.png" then
			self.modelImage:setPosition(cc.p(-52, 52))
		else
			self.modelImage:setPosition(cc.p(-32, 41))
		end
		self.modelImage:setScale(1.05)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarTower then
		if self.status == gNebulaDefenceWarBuildStatus.RUIN then
			self.modelImage:setPosition(cc.p(-25, 40))
		else
			self.modelImage:setPosition(cc.p(-100, 120))
		end
		self.modelImage:setScale(1.0)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarGateway then
		self.modelImage:setPosition(cc.p(-46, 74))
		self.modelImage:setScale(1.0)
	end
	if self.status == gNebulaDefenceWarBuildStatus.RUIN then
		self.modelImage:setSpriteFrame(buildInfo.breakPic)
	else
		self.modelImage:setSpriteFrame(buildInfo.buildPic)
	end
	self.text_Name:setString(i18n(buildInfo.buildName))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	self:updateEffect()
end
;(function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end).name = "dh_cq_jd1_alpha_%02d.png"
_ENV, _ENV, (function(self, ...)
	local buildInfo = activity_9001573_Read.getBuild(self.objId)
	self.buildInfo = buildInfo
	if buildInfo == nil then
		return
	end
	print(buildInfo.buildType, "buildInfo.buildType")
	if self.effect1 then
		self.effect1:removeFromParent()
		self.effect1 = nil
	end
	if self.effect2 then
		self.effect2:removeFromParent()
		self.effect2 = nil
	end
	if self.effect3 then
		self.effect3:removeFromParent()
		self.effect3 = nil
	end
	if buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall then
		if buildInfo.buildPic == "Celestial_build_wall_02.png" then
			self.modelImage:setPosition(cc.p(-52, 52))
		else
			self.modelImage:setPosition(cc.p(-32, 41))
		end
		self.modelImage:setScale(1.05)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarTower then
		if self.status == gNebulaDefenceWarBuildStatus.RUIN then
			self.modelImage:setPosition(cc.p(-25, 40))
		else
			self.modelImage:setPosition(cc.p(-100, 120))
		end
		self.modelImage:setScale(1.0)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarGateway then
		self.modelImage:setPosition(cc.p(-46, 74))
		self.modelImage:setScale(1.0)
	end
	if self.status == gNebulaDefenceWarBuildStatus.RUIN then
		self.modelImage:setSpriteFrame(buildInfo.breakPic)
	else
		self.modelImage:setSpriteFrame(buildInfo.buildPic)
	end
	self.text_Name:setString(i18n(buildInfo.buildName))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	self:updateEffect()
end).fire1, (function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end).isAdd = nil, function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end, function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end, false
local function name1s(self, ...)
	local buildInfo = activity_9001573_Read.getBuild(self.objId)
	self.buildInfo = buildInfo
	if buildInfo == nil then
		return
	end
	print(buildInfo.buildType, "buildInfo.buildType")
	if self.effect1 then
		self.effect1:removeFromParent()
		self.effect1 = nil
	end
	if self.effect2 then
		self.effect2:removeFromParent()
		self.effect2 = nil
	end
	if self.effect3 then
		self.effect3:removeFromParent()
		self.effect3 = nil
	end
	if buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall then
		if buildInfo.buildPic == "Celestial_build_wall_02.png" then
			self.modelImage:setPosition(cc.p(-52, 52))
		else
			self.modelImage:setPosition(cc.p(-32, 41))
		end
		self.modelImage:setScale(1.05)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarTower then
		if self.status == gNebulaDefenceWarBuildStatus.RUIN then
			self.modelImage:setPosition(cc.p(-25, 40))
		else
			self.modelImage:setPosition(cc.p(-100, 120))
		end
		self.modelImage:setScale(1.0)
	elseif buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarGateway then
		self.modelImage:setPosition(cc.p(-46, 74))
		self.modelImage:setScale(1.0)
	end
	if self.status == gNebulaDefenceWarBuildStatus.RUIN then
		self.modelImage:setSpriteFrame(buildInfo.breakPic)
	else
		self.modelImage:setSpriteFrame(buildInfo.buildPic)
	end
	self.text_Name:setString(i18n(buildInfo.buildName))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	self:updateEffect()
end
;(nil).name = "dh_cq_jd1_alpha_%02d.png"
_ENV, _UPVALUE2_, (function(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end).fire1, (nil).isAdd = nil, nil, nil, false
local function name2s(target)
	local target = include("worldMapInstance").new("worldMapNebulaDefence")
	return target
end
;(nil).key = "fire1"
_ENV, (nil).pos = cc.p(-259, -173), cc.p(-259, -173)
cc.p(-259, -173).key = "fire1"
cc.p(-259, -173).pos = cc.p(345, 121)
_ENV, _UPVALUE2_, (nil)[1] = (cc.p(-259, -173))
local _ENV, _UPVALUE2_, (nil)[2], pos1s = cc.p(-259, -173), nil, cc.p(-259, -173), nil
cc.p(-259, -173).key = "fire1"
_ENV, cc.p(-259, -173).pos = cc.p(-223, 136), cc.p(-223, 136)
cc.p(-223, 136).key = "fire1"
cc.p(-223, 136).pos = cc.p(334, -163)
;(nil)[1] = cc.p(-259, -173)
local (nil)[2], pos2s = cc.p(-223, 136), nil
function worldMapNebulaDefence:updateEffect()
	if self.buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarGateway and self.status ~= gNebulaDefenceWarBuildStatus.RUIN then
		if self.effect1 == nil then
			self.effect1 = display.newSprite("#dh_CSM_ALPHA_01.png")
			local frames = display.newFrames("dh_CSM_ALPHA_%02d.png", 1, 20)
			local animation = display.newAnimation(frames, 0.05)
			self.effect1:setPosition(278, 195)
			self.effect1:setScale(1.33)
			self.effect1:playAnimationForever(animation)
			self.effect1:addTo(self.modelImage)
		end
		if self.effect2 == nil then
			self.effect2 = display.newSprite("#dh_CSM_ADD_01.png")
			local frames = display.newFrames("dh_CSM_ADD_%02d.png", 1, 20)
			local animation = display.newAnimation(frames, 0.05)
			SoraDMixtureGLONE(self.effect2)
			self.effect2:setPosition(278, 195)
			self.effect2:setScale(1.33)
			self.effect2:playAnimationForever(animation)
			self.effect2:addTo(self.modelImage)
		end
	end
	if self.buildInfo.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall and self.status ~= gNebulaDefenceWarBuildStatus.RUIN then
		local isWallEffect1 = self.buildInfo.buildPic == "Celestial_build_wall_02.png"
		if self.effect3 == nil then
			self.effect3 = display.newNode()
			self.effect3:setPosition(self.modelImage:getContentSize().width / 2, self.modelImage:getContentSize().height / 2)
			self.effect3:addTo(self.modelImage)
			local frames
			local effect = display.newSprite(isWallEffect1 and "#dh_cm_jd1_Alpha_01.png" or "#dh_cm_jd2_alpha_01.png")
			frames = display.newFrames(isWallEffect1 and "dh_cm_jd1_Alpha_%02d.png" or "dh_cm_jd2_alpha_%02d.png", 1, 15)
			effect:setRotation(isWallEffect1 and -25 or 25)
			local animation = display.newAnimation(frames, 0.06666666666666667)
			if not isWallEffect1 then
				effect:setPosition(97, 40)
			else
				effect:setPosition(42, 84)
			end
			effect:setScale(1.33)
			effect:playAnimationForever(animation)
			effect:addTo(self.effect3)
			local effect = display.newSprite(isWallEffect1 and "#dh_cm_jd1_Add_01.png" or "#dh_cm_jd2_add_01.png")
			local frames = display.newFrames(isWallEffect1 and "dh_cm_jd1_Add_%02d.png" or "dh_cm_jd2_add_%02d.png", 1, 15)
			effect:setRotation(isWallEffect1 and -25 or 25)
			local animation = display.newAnimation(frames, 0.06666666666666667)
			SoraDMixtureGLONE(effect)
			if not isWallEffect1 then
				effect:setPosition(97, 40)
			else
				effect:setPosition(42, 84)
			end
			effect:setScale(1.33)
			effect:playAnimationForever(animation)
			effect:addTo(self.effect3)
			local isWallEffect1 = self.buildInfo.buildPic == "Celestial_build_wall_02.png"
			local poses = isWallEffect1 and pos1s or pos2s
			local names = isWallEffect1 and name1s or name2s
			for i, v in ipairs(poses) do
				local effName = names[v.key].name
				local pos = v.pos
				local effect = display.newSprite(string.format(effName, 1))
				frames = display.newFrames(effName, 1, 15)
				effect:setFlippedX(isWallEffect1)
				local animation = display.newAnimation(frames, 0.06666666666666667)
				effect:setPosition(v.pos)
				if names[v.key].isAdd then
					SoraDMixtureGLONE(self.effect6)
				end
				effect:playAnimationForever(animation)
				effect:addTo(self.effect3)
			end
		end
	end
end
function worldMapNebulaDefence:updateData(data)
	dump(data, "worldMapNebulaDefence data======")
	if not data or data and not next(data) then
		return
	end
	_ENV = data
	_UPVALUE1_, data.msg = "worldMapNebulaDefence data======", "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	data.relatedTilePoints, ("worldMapNebulaDefence data======")[1] = "worldMapNebulaDefence data======", self.tilePoint
	SoraDSendMessage(data)
	if data.buildStatus then
		self.status = data.buildStatus
	end
	self:initBuildInfo()
end
function worldMapNebulaDefence:playClickSound()
	SoraDPlaySound()
end
function worldMapNebulaDefence:isSurveying()
	return false
end
function worldMapNebulaDefence:getBuildClassID()
	return self.objId
end
function worldMapNebulaDefence:getFavoriteName()
	return self.buildInfo and i18n(self.buildInfo.buildName) or i18n("Celestial_defense_build_001")
end
function worldMapNebulaDefence:onClickInstance(onShowView)
	self:playClickSound()
	_UPVALUE2_ = self
	self[1] = self.status
	self[2] = gNebulaDefenceWarBuildStatus.RUIN
	dump(self, "self.status")
	if activity_9001573_Ctrl:getIsInBattle() and self.status ~= gNebulaDefenceWarBuildStatus.RUIN then
		return self:onShowWorldMapTip(onShowView)
	end
end
function worldMapNebulaDefence:getInstanceOp(isSelfKindom)
	if not isSelfKindom then
		return
	end
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
	table.insert(buttonTypeArray, nil)
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
	table.insert(buttonTypeArray, nil)
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_nebuladefence_chakanshoujun
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
return worldMapNebulaDefence
