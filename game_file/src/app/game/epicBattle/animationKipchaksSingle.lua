local animationKipchaksSingle = class("animationKipchaksSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("animationKipchaksSingle")
	end
	return target
end)
function animationKipchaksSingle:ctor()
	self:setCascadeOpacityEnabled(true)
	self.moveLine, _ENV, self.warMatrix, _ENV = self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled
	self.isRun = false
	self.nodeBig = SoraDGetChildByName(self, "Node_big")
	self.nodeBigbase = SoraDGetChildByName(self, "Node_bigbase")
	self.nodeLv4 = SoraDGetChildByName(self, "Node_lv4")
	self._4TjbbDjWn4 = SoraDGetChildByName(self, "4_tjbb_dj_wn_4")
	self._4TjbbDjWn3 = SoraDGetChildByName(self, "4_tjbb_dj_wn_3")
	self._4TjbbDjWn2 = SoraDGetChildByName(self, "4_tjbb_dj_wn_2")
	self._4TjbbDjWs2 = SoraDGetChildByName(self, "4_tjbb_dj_ws_2")
	self._4TjqbDjWs3 = SoraDGetChildByName(self, "4_tjqb_dj_ws_3")
	self._4TjcbDjWs1 = SoraDGetChildByName(self, "4_tjcb_dj_ws_1")
	self._4TjqbDjWs1 = SoraDGetChildByName(self, "4_tjqb_dj_ws_1")
	self._4TjbbDjWn1 = SoraDGetChildByName(self, "4_tjbb_dj_wn_1")
	self._4TjqbDjWs2 = SoraDGetChildByName(self, "4_tjqb_dj_ws_2")
	self._4TjbbDjWs1 = SoraDGetChildByName(self, "4_tjbb_dj_ws_1")
	self.nodeLv5 = SoraDGetChildByName(self, "Node_lv5")
	self._5TjcbDjWs3 = SoraDGetChildByName(self, "5_tjcb_dj_ws_3")
	self._5TjcbDjWs2 = SoraDGetChildByName(self, "5_tjcb_dj_ws_2")
	self._5TjcbDjWs1 = SoraDGetChildByName(self, "5_tjcb_dj_ws_1")
	self._5TjqbDjWs2 = SoraDGetChildByName(self, "5_tjqb_dj_ws_2")
	self._5TjqbDjWs1 = SoraDGetChildByName(self, "5_tjqb_dj_ws_1")
	self._5TjbbDjWn2 = SoraDGetChildByName(self, "5_tjbb_dj_wn_2")
	self._5TjbbDjWn1 = SoraDGetChildByName(self, "5_tjbb_dj_wn_1")
	self._5TjbbDjWs3 = SoraDGetChildByName(self, "5_tjbb_dj_ws_3")
	self._5TjbbDjWs2 = SoraDGetChildByName(self, "5_tjbb_dj_ws_2")
	self._5TjbbDjWs1 = SoraDGetChildByName(self, "5_tjbb_dj_ws_1")
	self.nodeSmall = SoraDGetChildByName(self, "Node_small")
	self.nodeSmallbase = SoraDGetChildByName(self, "Node_smallbase")
	self.nodeLv1 = SoraDGetChildByName(self, "Node_lv1")
	self._1TjbbDjWn1 = SoraDGetChildByName(self, "1_tjbb_dj_wn_1")
	self._1TjbbDjWn2 = SoraDGetChildByName(self, "1_tjbb_dj_wn_2")
	self._1TjbbDjWs1 = SoraDGetChildByName(self, "1_tjbb_dj_ws_1")
	self.nodeLv2 = SoraDGetChildByName(self, "Node_lv2")
	self._2TjbbDjWn1 = SoraDGetChildByName(self, "2_tjbb_dj_wn_1")
	self._2TjbbDjWn2 = SoraDGetChildByName(self, "2_tjbb_dj_wn_2")
	self._2TjbbDjWn3 = SoraDGetChildByName(self, "2_tjbb_dj_wn_3")
	self._2TjbbDjWs3 = SoraDGetChildByName(self, "2_tjbb_dj_ws_3")
	self._2TjbbDjWs2 = SoraDGetChildByName(self, "2_tjbb_dj_ws_2")
	self._2TjbbDjWs1 = SoraDGetChildByName(self, "2_tjbb_dj_ws_1")
	self.nodeLv3 = SoraDGetChildByName(self, "Node_lv3")
	self._3TjbbDjWn4 = SoraDGetChildByName(self, "3_tjbb_dj_wn_4")
	self._3TjbbDjWn3 = SoraDGetChildByName(self, "3_tjbb_dj_wn_3")
	self._3TjbbDjWn2 = SoraDGetChildByName(self, "3_tjbb_dj_wn_2")
	self._3TjbbDjWn1 = SoraDGetChildByName(self, "3_tjbb_dj_wn_1")
	self._3TjbbDjWs3 = SoraDGetChildByName(self, "3_tjbb_dj_ws_3")
	self._3TjbbDjWs2 = SoraDGetChildByName(self, "3_tjbb_dj_ws_2")
	self._3TjbbDjWs1 = SoraDGetChildByName(self, "3_tjbb_dj_ws_1")
	self._3TjqbDjWs2 = SoraDGetChildByName(self, "3_tjqb_dj_ws_2")
	self._3TjqbDjWs1 = SoraDGetChildByName(self, "3_tjqb_dj_ws_1")
	self.nodeBig:setVisible(false)
	self.nodeSmall:setVisible(false)
	for i = 1, 5 do
		self["nodeLv" .. i]:setVisible(false)
	end
	SoraDCreatAnimationEx(self.__cname, self, true)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_KIPCHAKS", handler(self, self.msgKipchaksUpdate))
end
function animationKipchaksSingle:initData(lv, index)
	if self.isRun then
		return
	end
	self.buildIndex = index
	self.lv = math.min(math.ceil(lv / 2), 5)
	self.nodeBig:setVisible(false)
	self.nodeSmall:setVisible(false)
	for i = 1, 5 do
		self["nodeLv" .. i]:setVisible(false)
	end
	if self.lv >= 4 then
		self.nodeBig:setVisible(true)
	else
		self.nodeSmall:setVisible(true)
	end
	self.showNode = self["nodeLv" .. self.lv]
	if self.showNode then
		self.showNode:setVisible(true)
		for i, v in ipairs(self.showNode:getChildren()) do
			local name = v:getName()
			local key = SoraDStringSplit(name, "_")
			self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
		end
		self:removeArmy()
	end
end
function animationKipchaksSingle:msgKipchaksUpdate(target, data)
	if data.buildIndex and data.buildIndex == self.buildIndex then
		print("self.buildIndex", self.buildIndex)
		self:runAtkAction(data.isWin, data.army)
	end
end
function animationKipchaksSingle:runFramesAction(sprite, name)
	sprite:stopAllActions()
	local frames = display.newFrames(name .. "_%02d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.13333333333333333)
	sprite:playAnimationForever(animation)
end
function animationKipchaksSingle:runAtkAction(isRemove, army)
	if self.showNode then
		for i, v in ipairs(self.showNode:getChildren()) do
			local name = v:getName()
			local key = SoraDStringSplit(name, "_")
			self:runFramesAction(v, key[2] .. "_gj_" .. key[4])
		end
	end
	self:initArmy(army)
	if isRemove then
		_UPVALUE2_ = self.showNode:getChildren()
		self.showNode:getChildren()[1] = cca.delay(6)
		self.showNode:getChildren()[2] = cca.fadeOut(0.5)
		self.showNode:getChildren()[3] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[4] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[5] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[6] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[7] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[8] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self.showNode:getChildren()[9] = cca.callFunc(function(...)
			self:setVisible(false)
			self:removeArmy()
		end)
		self:runAction(cca.seq(self.showNode:getChildren()))
	else
		self.isRun = true
		_UPVALUE1_ = cca.seq(self.showNode:getChildren())
		cca.seq(self.showNode:getChildren())[1] = cca.delay(6)
		cca.seq(self.showNode:getChildren())[2] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[3] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[4] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[5] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[6] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[7] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[8] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		cca.seq(self.showNode:getChildren())[9] = cca.callFunc(function(...)
			if self.showNode then
				self.showNode:setVisible(true)
				for i, v in ipairs(self.showNode:getChildren()) do
					local name = v:getName()
					local key = SoraDStringSplit(name, "_")
					self:runFramesAction(v, key[2] .. "_dj_" .. key[4])
				end
			end
			self:removeArmy()
			self.isRun = false
		end)
		self:runAction(cca.seq(cca.seq(self.showNode:getChildren())))
	end
end
function animationKipchaksSingle:removeArmy()
	for _, v in ipairs(self.warMatrix) do
		v:removeFromParent()
	end
	for _, v in ipairs(self.moveLine) do
		v:removeFromParent()
	end
	self.moveLine, _ENV, self.warMatrix, _ENV = ipairs(self.moveLine)
end
function animationKipchaksSingle:initArmy(army)
	self:removeArmy()
	local createArmyTroop = function(sp, ep)
		local beginPos = sp
		local endPos = ep
		local soldiers = army
		local troopsMatrix = include("troopsMatrixHeroTrial")
		local warMatrix = troopsMatrix.new()
		self:addChild(warMatrix, 11)
		army, _ENV = nil, 0
		;(nil).armyList = soldiers
		;(0)[1] = nil
		warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), gMapObjTypeDef.mapObjTypeBattery, 0, nil, 120)
		warMatrix:setPosition(beginPos)
		warMatrix:setVisible(true)
		warMatrix:setTouchEnabled(false)
		warMatrix:setSoliderVisible(true)
		local moveLine = include("worldMapMoveLine").new(beginPos, endPos)
		self:addChild(moveLine, 10)
		warMatrix:setMoveLine(moveLine)
		army, army = warMatrix, warMatrix.setMoveLine
		warMatrix.distancePrecent = 0.3
		army, warMatrix.setMoveLine[1], warMatrix.time = warMatrix, warMatrix, 10
		warMatrix.distancePrecent = 1
		warMatrix.setMoveLine[2], warMatrix.time = warMatrix, 9999
		local span = warMatrix.setMoveLine
		army = 10
		;(10).currentMoveTime = 0
		;(10).moveTimeSpan = span
		warMatrix:setMoveTimeData(10)
		warMatrix:beginMove(0)
		return warMatrix, moveLine
	end
	local monsterPos = cc.p(self.showNode:getPositionX(), self.showNode:getPositionY())
	self.warMatrix[1], self.moveLine[1] = createArmyTroop(monsterPos, monsterPos)
	self.warMatrix[2], self.moveLine[2] = createArmyTroop(monsterPos, monsterPos)
	self.warMatrix[3], self.moveLine[3] = createArmyTroop(monsterPos, monsterPos)
	self.warMatrix[1]:beginWork()
	self.warMatrix[2]:beginWork()
	self.warMatrix[3]:beginWork()
end
return animationKipchaksSingle
