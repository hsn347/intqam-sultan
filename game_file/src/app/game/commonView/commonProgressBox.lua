local commonProgressBox = class("commonProgressBox", function(target)
	return target
end)
function commonProgressBox:ctor()
	_UPVALUE4_ = nil
	self.boxImgs, (nil)[1] = nil, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, (nil)[2] = nil, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, (nil)[3] = nil, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, (nil)[4] = nil, "icon_KingGroupbuy_lv4_small.png"
	self:initWidget()
end
function commonProgressBox:initWidget()
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnBox = SoraDGetChildByName(self, "Button_box")
end
function commonProgressBox:initData(data)
	if data.boxData then
		self.boxData = data.boxData
	end
	if data.curNum then
		self.curNum = data.curNum
	end
	if data.receivedReward then
		self.receivedReward = data.receivedReward
	end
	if data.boxImgs then
		self.boxImgs = data.boxImgs
	end
	if data.boxClickHandle then
		self.boxClickHandle = data.boxClickHandle
	end
	if data.createEffectHandle then
		self.createEffectHandle = data.createEffectHandle
	end
	local boxPosY = data.boxPosY or 0
	local caculatePosX = function(num)
		local totalWidth = self.loadBar:getContentSize().width
		local perDis = totalWidth / (#self.boxData - 1)
		if SoraDFIsRA() then
			return totalWidth / 2 - (num - 1) * perDis
		else
			return (num - 1) * perDis - totalWidth / 2
		end
	end
	if not self.ocxBoxs then
		self.ocxBoxs, _ENV = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single
			if i == 1 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self)
			end
			single:setCascadeOpacityEnabled(true)
			SoraDGetChildByName(single, "Sprite_box"):setSpriteFrame(self.boxImgs[i] or self.boxImgs[1])
			SoraDGetChildByName(single, "Text_price"):setString(string.formatnumberthousands(v.num))
			SoraDGetChildByName(single, "Sprite_get"):setVisible(false)
			single:setTag(i)
			single:setPosition(caculatePosX(i), boxPosY)
			single = include("commonBtnInstance").new(single)
			single:setHandle(handler(self, self.boxClick))
			single:setSwallowTouches(false)
			table.insert(self.ocxBoxs, single)
		end
	end
end
function commonProgressBox:boxClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		local idx = button:getTag()
		if self.boxClickHandle then
			self.boxClickHandle(idx, button.state)
		end
	end
end
function commonProgressBox:setProgressBarPercent(...)
	local offset1 = 15
	local offset2 = 0
	local belongNum = 0
	for i, v in ipairs(self.boxData) do
		if self.curNum >= v.num then
			belongNum = i
			offset2 = offset2 + 0.5
		end
	end
	if 1 <= belongNum then
		local perDis = math.ceil(100 / (#self.boxData - 1))
		local baseDis = (belongNum - 1) * perDis
		local preTaskNum = self.boxData[belongNum] and self.boxData[belongNum].num or 0
		local afterTaskNum = self.boxData[belongNum + 1] and self.boxData[belongNum + 1].num or self.boxData[#self.boxData].num + 1
		local curDis = (self.curNum - preTaskNum) / (afterTaskNum - preTaskNum) * (perDis - offset1)
		if 0 < curDis then
			curDis = curDis + offset1 / 2 - offset2
		end
		local totalDis = baseDis + curDis
		self.loadBar:setPercent(totalDis)
	else
		self.loadBar:setPercent(0)
	end
end
function commonProgressBox:refreshBoxState(...)
	for i, v in ipairs(self.boxData) do
		if self.curNum >= v.num then
			if self.receivedReward[tostring(i)] then
				self:showRoundEffect(self.ocxBoxs[i], gActivityTaskStatus.TASK_STATUS_COMPLETE_DONE)
			else
				self:showRoundEffect(self.ocxBoxs[i], gActivityTaskStatus.TASK_STATUS_COMPLETE)
			end
		else
			self:showRoundEffect(self.ocxBoxs[i], gActivityTaskStatus.TASK_STATUS_DOING)
		end
	end
end
function commonProgressBox:createRoundEffect(pNode)
	_ENV, _ENV = nil, nil
	;(nil).png = "dh_xsyd_01.png"
	;(nil).scale = 2.75
	;(nil).opacity = 178.5
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeTo(0.55, 0.2)
	;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
	_ENV, (nil)[1], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	_ENV, (nil)[2], (nil).scale = nil, nil, 2
	;(nil).png = "dh_xsyd_02.png"
	;(nil).scale = 2.4
	_ENV = nil
	;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[3], (nil).seq = nil, cca.seq(nil)
	local actionConfig
	local roundNode = display.newNode()
	if pNode then
		local nSize = pNode:getContentSize()
		roundNode:setPosition(nSize.width / 2, nSize.height / 2)
		roundNode:addTo(pNode, 1)
	end
	for k, v in ipairs(actionConfig) do
		if v.png then
			local sprite = display.newSprite("#" .. v.png)
			if v.scale then
				sprite:setScale(v.scale)
			end
			if v.opacity then
				sprite:setOpacity(v.opacity)
			end
			if v.rotation then
				sprite:setRotation(v.rotation)
			end
			if v.seq then
				sprite:runAction(cc.RepeatForever:create(v.seq))
			end
			sprite:addTo(roundNode, k)
		end
	end
	roundNode:setScale(0.28)
	return roundNode
end
function commonProgressBox:showRoundEffect(pNode, state)
	pNode.state = state
	local effect_node = SoraDGetChildByName(pNode, "effect_node")
	local Sprite_box = SoraDGetChildByName(pNode, "Sprite_box")
	local Sprite_get = SoraDGetChildByName(pNode, "Sprite_get")
	local Sprite_point = SoraDGetChildByName(pNode, "Image_dian")
	if state == gActivityTaskStatus.TASK_STATUS_COMPLETE then
		if not effect_node then
			local roundNode
			if self.createEffectHandle then
				roundNode = self.createEffectHandle()
			else
				roundNode = self:createRoundEffect(pNode)
			end
			roundNode:setName("effect_node")
			local nSize = pNode:getContentSize()
			roundNode:setPosition(nSize.width / 2, nSize.height / 2)
			roundNode:addTo(pNode, 1)
		else
			effect_node:setVisible(true)
		end
		Sprite_box:setColor(cc.c3b(255, 255, 255))
		if Sprite_point then
			Sprite_point:setColor(cc.c3b(255, 200, 100))
		end
		Sprite_get:setVisible(false)
	elseif state == gActivityTaskStatus.TASK_STATUS_DOING then
		if effect_node then
			effect_node:setVisible(false)
		end
		if Sprite_point then
			Sprite_point:setColor(cc.c3b(0, 0, 0))
		end
		Sprite_box:setColor(cc.c3b(255, 255, 255))
		Sprite_get:setVisible(false)
	elseif state == gActivityTaskStatus.TASK_STATUS_COMPLETE_DONE then
		if effect_node then
			effect_node:setVisible(false)
		end
		if Sprite_point then
			Sprite_point:setColor(cc.c3b(255, 200, 100))
		end
		Sprite_box:setColor(cc.c3b(125, 125, 125))
		Sprite_get:setVisible(true)
	end
end
function commonProgressBox:setDirection(direction)
	self.loadBar:setDirection(direction or SoraDFIsRA() and 1 or 0)
end
return commonProgressBox
