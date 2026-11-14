local escortSolider = class("escortSolider", function()
	local view = include("worldMapTroopInstance").new(cc.size(100, 100))
	return view
end)
function escortSolider:ctor()
	self.emojiID = 0
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self.size = self:getContentSize()
end
function escortSolider:createTroopIcon(scale)
	if self.lodNode then
		return
	end
	local sprite = display.newSprite("#lod_marchingQueue.png")
	self.lodNode = sprite
	self.lodNode:addTo(self, 10)
	local size = self:getContentSize()
	self.lodNode:setPosition(cc.p(size.width / 2, size.height / 2))
	self.soldierLod = sprite
	if self.moveLineColor then
		local color = worldMapDefine.getMoveLineColor(self.moveLineColor)
		self.soldierLod:setColor(color)
	end
	if scale then
		self.lodNode:setScale(scale)
	end
	sprite:setGroupID(worldMapDefine.GROU_ID.group_moveline_lodicon)
end
function escortSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data, carLv)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	self.soldier = display.newSprite("#shangdui_yd_w_01.png")
	self.soldier:setPosition(cc.p(self.size.width / 2, self.size.height / 2))
	self.soliderNode:addChild(self.soldier, 1)
	local frames = display.newFrames("biaoche01_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.125)
	self.soldier:playAnimationForever(animation)
	self.soldier:setFlippedX(isFlipX)
	if carLv ~= nil then
		self.lv = carLv
	else
		self.lv = 1
	end
	if 1 < self.lv then
		local ex_format = "#biaoche0" .. self.lv .. "_yd_" .. imgNameAngle .. "_01.png"
		local ex_car = display.newSprite(ex_format)
		ex_car:setPosition(cc.p(self.size.width / 2, self.size.height / 2))
		ex_car:addTo(self.soliderNode, self.soldier:getLocalZOrder() + 1)
		ex_car:setFlippedX(isFlipX)
	end
	self:initCheckVisible()
end
function escortSolider:setIsAttacked(isAttacked)
	if isAttacked then
		if self.fightEffect == nil then
			local fightEffect = SoraDGetFightingEffect()
			self.soliderNode:addChild(fightEffect, 5)
			fightEffect:setScale(0.7)
			fightEffect:setPosition(cc.p(self.size.width / 2, self.size.height / 2))
			self.fightEffect = fightEffect
		else
		end
		self:createTimer()
	elseif self.fightEffect then
		self.fightEffect:removeFromParent()
		self.fightEffect = nil
	end
end
function escortSolider:createTimer()
	if self.atkTimeHandler then
		SoraDManagerRemoveTimer(self, self.atkTimeHandler)
	end
	self.atkTimeHandler = SoraDCreateDelayTimer(self, handler(self, self.removeFightEffect), 8)
end
function escortSolider:removeFightEffect()
	self.atkTimeHandler = nil
	if self.fightEffect then
		self.fightEffect:removeFromParent()
		self.fightEffect = nil
	end
end
function escortSolider:setIsBuff(isBuff)
	if isBuff then
		print("TODO: 添加宝藏押运加成特效")
		_ENV, _ENV = "TODO: 添加宝藏押运加成特效", print
		_ENV, ("TODO: 添加宝藏押运加成特效").plist = nil, "et_mcdouble_01.plist"
		;(nil).x = 1.35
		_ENV, print[1], ("TODO: 添加宝藏押运加成特效").scale, (nil).y = "TODO: 添加宝藏押运加成特效", "TODO: 添加宝藏押运加成特效", nil, 0.57
		_ENV, ("TODO: 添加宝藏押运加成特效").plist = nil, "et_mcdouble_04.plist"
		;(nil).x = 2.16
		_ENV, _ENV, print[2], ("TODO: 添加宝藏押运加成特效").scale, (nil).y = nil, "TODO: 添加宝藏押运加成特效", "TODO: 添加宝藏押运加成特效", nil, 0.94
		local param_bg = print
		_ENV, (nil).plist = nil, "et_mcdouble_02.plist"
		;(nil).x = 0.96
		;(nil).scale, (nil).y = nil, 1.08
		;("TODO: 添加宝藏押运加成特效")[1], (nil).rotate = nil, 90
		local param_top = "TODO: 添加宝藏押运加成特效"
		local et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:setName("et_node_bg")
		et_node_bg:setPosition(cc.p(50, 40))
		et_node_bg:addTo(self.soliderNode, 0)
		local et_node_top = SoraDCreateEffectNode(param_top)
		et_node_top:setName("et_node_top")
		et_node_top:setPosition(cc.p(50, 40))
		et_node_top:addTo(self.soliderNode, 2)
	else
		print("TODO:删除宝藏押运加成特效")
		if self:getChildByName("et_node_bg") then
			self:removeChildByName("et_node_bg", true)
		end
		if self:getChildByName("et_node_top") then
			self:removeChildByName("et_node_top", true)
		end
	end
end
function escortSolider:addEffectByQuality(quality)
	_ENV = nil
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_mcbaise_01.plist"
	;(nil)[gQualityDef.WHITE], (nil)[2], (nil).plist = nil, nil, "et_mcxx_01.plist"
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_mclvse_01.plist"
	;(nil)[gQualityDef.GREEN], (nil)[2], (nil).plist = nil, nil, "et_mcxx_01.plist"
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_mclanse_01.plist"
	;(nil)[gQualityDef.BLUE], (nil)[2], (nil).plist = nil, nil, "et_mcxx_01.plist"
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_mczise_01.plist"
	;(nil)[gQualityDef.PURPLE], (nil)[2], (nil).plist = nil, nil, "et_mcxx_01.plist"
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_mcjinse_01.plist"
	;(nil)[gQualityDef.ORANGE], (nil)[2], (nil).plist = nil, nil, "et_mcxx_01.plist"
	local param_quality
	local param = param_quality[quality]
	if param then
		local et_node = SoraDCreateEffectNode(param)
		et_node:setPosition(cc.p(self.size.width / 2, self.size.height / 2))
		if self.soldier:isFlippedX() then
			et_node:setScaleX(-1)
		end
		et_node:addTo(self.soliderNode, 9)
	end
end
function escortSolider:setAssistBattlePlus(assistBattlePlus)
	self.assistBattlePlus = assistBattlePlus
end
function escortSolider:setAssistorInfo(assistorInfo)
	self.assistorInfo = assistorInfo
end
function escortSolider:setAssistArmy(assistArmy)
	self.assistArmy = assistArmy
end
function escortSolider:getAssistArmy()
	return self.assistArmy
end
function escortSolider:getAssistBattlePlus()
	return self.assistBattlePlus
end
function escortSolider:getAssistorInfo()
	return self.assistorInfo
end
function escortSolider:getAssistData()
	_UPVALUE0_ = nil
	;(nil).assistBattlePlus = self.assistBattlePlus
	;(nil).assistorInfo = self.assistorInfo
	;(nil).assistArmy = self.assistArmy
	return nil
end
function escortSolider:canHasEmojiOperator(playerID)
	if self.moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
		return false
	end
	if not playerID then
		local gametop = gModuleMgr.getObject("gametop")
		playerID = gametop.playertop_:getPlayerID() or 0
	end
	if self.playerID and self.playerID == playerID then
		return true
	end
end
return escortSolider
