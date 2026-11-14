local MainCityGuideManager = class("MainCityGuideManager")
function MainCityGuideManager:ctor()
end
function MainCityGuideManager:initData(mainCityGuide, guideStep)
	self.mainCityGuide = mainCityGuide
	self.roleParentNode = SoraDGetChildByName(self.mainCityGuide, "Roles")
	self.topTipParentNode = SoraDGetChildByName(self.mainCityGuide, "TopTips")
	_UPVALUE5_, self.topTips, _ENV, self.roles, _ENV, self.guideStep = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), guideStep
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[1] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_1")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[2] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_2")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[3] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_3")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[4] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_4")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[5] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_5")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[6] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_6")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[7] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_6")
	_UPVALUE1_, self.fogs, SoraDGetChildByName(self.mainCityGuide, "TopTips")[8] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "fog_6")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[1] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "LowFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[2] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[3] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[4] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[5] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[6] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[7] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self.fogsInited, _ENV, self.fires, SoraDGetChildByName(self.mainCityGuide, "TopTips")[8] = SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(self.mainCityGuide, "TopTips"), SoraDGetChildByName(mainCityGuide, "HightFire")
	self:initSpecialNode()
	self.guideRunner = include("GuideRunner").new()
	self.guideRunner:init()
	local guideScript = include("GuideStep").new()
	guideScript:initData()
	self.guideStepDatas = guideScript:getGuideSteps()
	self.gudeInitData = guideScript:getGuideInitData()
	self.guideBattleDatas = guideScript:getGuideBattleDatas()
end
function MainCityGuideManager:destroy()
	self:clearSpecialNode()
	self.guideRunner:destroy()
end
function MainCityGuideManager:initSpecialNode()
	self.specialNodes, _ENV = nil, nil
	self.mainCityGuide.mainCityView:addBuild(tonumber(1050), tonumber(BUILDID.CASTLE))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1065), tonumber(BUILDID.CHARIOT_PLANT))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1067), tonumber(BUILDID.DEPOT))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1061), tonumber(BUILDID.RANGE))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1058), tonumber(BUILDID.STABLES))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1056), tonumber(BUILDID.BARRACKS))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1064), tonumber(BUILDID.EMBASSY))
	self.mainCityGuide.mainCityView:addBuild(tonumber(1100), tonumber(BUILDID.MILITARY_TENT))
	_ENV = self.mainCityGuide.mainCityView.addBuild
	self.mainCityGuide.mainCityView.addBuild.bingyin2 = "build_1065"
	self.mainCityGuide.mainCityView.addBuild.cangku2 = "build_1067"
	self.mainCityGuide.mainCityView.addBuild.bachang2 = "build_1061"
	self.mainCityGuide.mainCityView.addBuild.majiu2 = "build_1058"
	self.mainCityGuide.mainCityView.addBuild.zhanchegongfang2 = "build_1056"
	self.mainCityGuide.mainCityView.addBuild.dashiguan2 = "build_1064"
	self.mainCityGuide.mainCityView.addBuild.chengbao2 = "build_1050"
	local self.mainCityGuide.mainCityView.addBuild.zhangpeng2, initBuilds = "build_1100", self.mainCityGuide.mainCityView.addBuild
	for k, v in pairs(initBuilds) do
		local build = SoraDGetChildByName(self.mainCityGuide.mainCityView, v)
		build:setVisible(false)
		local buildEntity = SoraDGetChildByName(build, "buildName")
		buildEntity:hideZAnimation()
		self.specialNodes[k] = build
	end
end
function MainCityGuideManager:clearSpecialNode()
	for k, v in pairs(self.specialNodes) do
		v:setVisible(true)
	end
end
function MainCityGuideManager:startGuide(guideStep)
	local _ENV, curGuideStepDatas
	local startIdx = -1
	local _ENV, allNodeSteps
	local _ENV, rolePoses
	local mainUIIndex = 1
	local offsetPos, preapareStep, showZhanCheGongFangBattle
	for i, v in ipairs(self.guideStepDatas) do
		if startIdx == -1 and v.func == "prepareGuideData" and (v.param == guideStep or guideStep == nil) then
			startIdx = i
			preapareStep = v
		elseif startIdx ~= -1 then
			table.insert(curGuideStepDatas, v)
		elseif startIdx == -1 and (v.func == "showNode" or v.func == "hideNode") then
			table.insert(allNodeSteps, v)
		elseif startIdx == -1 and (v.func == "rolesAction" or v.func == "showBattle") then
			local actions = v.func == "rolesAction" and v.param or self:getBattleDatas(v.param)
			for i2, v2 in ipairs(actions) do
				if rolePoses[v2.role] == nil then
					_ENV = nil
					rolePoses[v2.role], (nil).action = nil, "STAND"
				end
				if v2.action ~= nil then
					rolePoses[v2.role].finalAction = v2.action
				end
				if v2.to then
					if rolePoses[v2.role].to then
						rolePoses[v2.role].start = rolePoses[v2.role].to
					end
					rolePoses[v2.role].action = "STAND"
					rolePoses[v2.role].finalAction = nil
					rolePoses[v2.role].to = v2.to
				end
				if v2.face ~= nil then
					rolePoses[v2.role].face = v2.face
				end
				if v2.flipX ~= nil then
					rolePoses[v2.role].flipX = v2.flipX
				end
			end
		elseif startIdx == -1 and v.func == "updateMainUI" then
			mainUIIndex = v.param
		elseif startIdx == -1 and v.func == "setOffset" then
			offsetPos = v.param.offset
		elseif startIdx == -1 and v.func == "showZhanCheGongFangBattle" then
			if v.param == true then
				showZhanCheGongFangBattle = v
			else
				showZhanCheGongFangBattle = nil
			end
		end
	end
	dump(rolePoses, "rolePoses")
	for i, v in ipairs(allNodeSteps) do
		self.mainCityGuide[v.func](self.mainCityGuide, v.param, true)
	end
	if offsetPos then
		_ENV = ipairs(allNodeSteps)
		ipairs(allNodeSteps).offset = offsetPos
		self.mainCityGuide:setOffset(ipairs(allNodeSteps))
	end
	if preapareStep then
		self:prepareGuideData(preapareStep.param, rolePoses)
	end
	if showZhanCheGongFangBattle then
		self.mainCityGuide:showZhanCheGongFangBattle(showZhanCheGongFangBattle.param, true)
	end
	self:initFires()
	self.mainCityGuide:updateMainUI(mainUIIndex, true)
	self.guideRunner:run(curGuideStepDatas, self.mainCityGuide)
end
function MainCityGuideManager:prepareGuideData(guideStep, rolePoses)
	local guideStepData = self.gudeInitData[guideStep]
	if guideStepData.pos then
		_UPVALUE0_ = nil
		;(nil).offset = guideStepData.pos
		self.mainCityGuide:setOffset(nil, true)
	end
	self:prepareRoles(guideStepData.roles, rolePoses)
	self:prepareTopTips(guideStepData.topTips)
	self:prepareFogs(guideStepData.fogIdx)
end
function MainCityGuideManager:prepareRoles(roleDatas, rolePoses)
	if not roleDatas or next(roleDatas) == nil then
		for k, v in pairs(self.roles) do
			v:removeFromParent()
		end
		self.roles, _ENV = pairs(self.roles)
		return
	end
	for k, v in pairs(self.roles) do
		local isNeedRemove = true
		for i, v2 in ipairs(roleDatas) do
			if v2.name == k then
				isNeedRemove = false
			end
		end
		if isNeedRemove then
			self.roles[k]:removeFromParent()
			self.roles[k] = nil
		end
	end
	for i, v in ipairs(roleDatas) do
		if not self.roles[v.name] then
			local role = include("AniRole").new()
			role:setName(v.name)
			role:initRole(v)
			role:addTo(self.roleParentNode)
			self.roles[v.name] = role
		end
		if rolePoses and rolePoses[v.name] then
			self.roles[v.name]:addAction(rolePoses[v.name])
			if rolePoses[v.name].to then
				self.roles[v.name]:setPos(rolePoses[v.name].to)
			end
		end
	end
end
function MainCityGuideManager:prepareTopTips(topTipDatas)
	if not topTipDatas or next(topTipDatas) == nil then
		for k, v in pairs(self.topTips) do
			v:removeFromParent()
		end
		self.topTips, _ENV = pairs(self.topTips)
		return
	end
	for k, v in pairs(self.topTips) do
		local isNeedRemove = true
		for i, v2 in ipairs(topTipDatas) do
			if v2.name == k then
				isNeedRemove = false
			end
		end
		if isNeedRemove then
			self.topTips[k]:removeFromParent()
			self.topTips[k] = nil
		end
	end
	for i, v in ipairs(topTipDatas) do
		if not self.topTips[v.name] then
			local topTip = SoraDCreatePanel("mainCityGuideTopTip")
			topTip:setVisible(false)
			topTip:setName(v.name)
			topTip:initData(v)
			topTip:addTo(self.topTipParentNode)
			self.topTips[v.name] = topTip
		else
			self.topTips[v.name]:reUse(v)
		end
	end
end
function MainCityGuideManager:prepareFogs(fogIdx)
	for i, v in ipairs(self.fogs) do
		if fogIdx < i then
			v:setVisible(true)
			if not self.fogsInited[i] then
				self:initFog(i, v)
			end
		else
			v:setVisible(false)
		end
	end
end
function MainCityGuideManager:initFog(idx, fog)
	for i, v in ipairs(fog:getChildren()) do
		local res = math.random(10) > 7 and "dh_mc_mw1_%.2d.png" or "dh_mc_mw2_%.2d.png"
		local frames = self:newFrames(res, 1, 30)
		local animation = display.newAnimation(frames, 0.125)
		v:playAnimationForever(animation)
		v:setScale(math.random(50, 70) / 10.0)
		v:setOpacity(math.random(255, 255))
		v:setRotation(math.random(0, 360))
	end
	self.fogsInited[idx] = true
end
function MainCityGuideManager:initFires()
	for i, v in ipairs(self.fires) do
		for i2, v2 in ipairs(v:getChildren()) do
			if v2:isVisible() then
				v2:stopAllActions()
				local res = v2:getName() .. "_%.2d.png"
				local frames = self:newFrames(res, 1, 15)
				local animation = display.newAnimation(frames, 0.06666666666666667)
				v2:playAnimationForever(animation)
				SoraDHighpSprite(v2)
			end
		end
	end
end
function MainCityGuideManager:getRole(role)
	return self.roles[role]
end
function MainCityGuideManager:getTopTips(name)
	return self.topTips[name]
end
function MainCityGuideManager:getNode(name)
	if self.specialNodes[name] then
		return self.specialNodes[name]
	elseif self.roles[name] then
		return self.roles[name]
	elseif self.topTips[name] then
		return self.topTips[name]
	else
		return SoraDGetChildByName(self.mainCityGuide, name)
	end
end
function MainCityGuideManager:newFrames(pattern, begin, length)
	local _ENV, frames
	local step = 1
	local last = begin + length - 1
	local rdIdx = math.random(begin, length)
	for index = begin + rdIdx, last, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	for index = begin, begin + rdIdx - 1, step do
		local frameName = string.format(pattern, index)
		local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	return frames
end
function MainCityGuideManager:createEffectSp(fileName, frameCount, loop, autoRemove)
	local sp = display.newSprite(fileName .. "_01")
	local frames = display.newFrames(fileName .. "_%.2d.png", 1, frameCount)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	if not loop then
		sp:playAnimationOnce(animation, true, function()
			if autoRemove then
				sp:removeFromParent()
			end
		end, 0)
	else
		sp:playAnimationForever(animation)
	end
	sp:addTo(self.roleParentNode, 10000)
	return sp
end
function MainCityGuideManager:getBattleDatas(param)
	return self.guideBattleDatas[param]
end
function MainCityGuideManager:closeUI()
	self.mainCityGuide:showGuideEnding(nil, true)
end
function MainCityGuideManager:setRolesVisible(isVisible)
	for k, v in pairs(self.roles) do
		v:setVisible(isVisible)
	end
end
return MainCityGuideManager
