local heroCtrl = SoraDGetCtrl("heroCtrl")
local mailItemDetailFightJinn = class("mailItemDetailFightJinn", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailFightJinn")
end)
function mailItemDetailFightJinn:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.defenceItems, _ENV, self.attackItems, _ENV = self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled
	self.itemWidth = gMailDetaiViewWidth
	self.layout_content = SoraDGetChildByName(self, "Panel")
	self.imgLine = SoraDGetChildByName(self.layout_content, "Image_line")
	self.nodeAttack = SoraDGetChildByName(self.layout_content, "Node_Attack")
	self.attackSkill = SoraDGetChildByName(self.nodeAttack, "Node_skill")
	self.nodeDefence = SoraDGetChildByName(self.layout_content, "Node_Defence")
	self.defenceSkill = SoraDGetChildByName(self.nodeDefence, "Node_skill")
	self.nodeAl = SoraDGetChildByName(self.layout_content, "Node_AL")
	SoraDGetChildByName(self.nodeAl, "Text_Title"):setString(i18n("battlelog_text_2"))
	self.nodeDl = SoraDGetChildByName(self.layout_content, "Node_DL")
	SoraDGetChildByName(self.nodeDl, "Text_Title"):setString(i18n("battlelog_text_2"))
	self.attackDetailBtn = SoraDGetChildByName(self.nodeAl, "Button_1")
	self.attackDetailBtn:addTouchEventListener(handler(self, self.onAttackDetail))
	self.attackDetailBtn:setSwallowTouches(false)
	self.defenceDetailBtn = SoraDGetChildByName(self.nodeDl, "Button_1")
	self.defenceDetailBtn:addTouchEventListener(handler(self, self.onDefenceDetail))
	self.defenceDetailBtn:setSwallowTouches(false)
end
function mailItemDetailFightJinn:initData(contentData)
	local parentScroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local itemWidth = 95
	local _ENV, attackJinn
	local _ENV, defenceJinn
	if contentData.battleDetails and contentData.battleDetails.magicLmapInfo then
		if contentData.battleDetails.magicLmapInfo.attack and contentData.battleDetails.magicLmapInfo.attack.isUnLock then
			if not contentData.battleDetails.magicLmapInfo.attack.jinnList then
				_ENV = contentData.battleDetails.magicLmapInfo.attack.jinnList
			end
			for i, v in pairs(contentData.battleDetails.magicLmapInfo.attack.jinnList) do
				v.jinnType = tonumber(i)
				table.insert(attackJinn, v)
			end
			table.sort(attackJinn, function(a, b)
				return a.jinnType > b.jinnType
			end)
		end
		if contentData.battleDetails.magicLmapInfo.defend and contentData.battleDetails.magicLmapInfo.defend.isUnLock then
			if not contentData.battleDetails.magicLmapInfo.defend.jinnList then
				_ENV = contentData.battleDetails.magicLmapInfo.defend.jinnList
			end
			for i, v in pairs(contentData.battleDetails.magicLmapInfo.defend.jinnList) do
				v.jinnType = tonumber(i)
				table.insert(defenceJinn, v)
			end
			table.sort(defenceJinn, function(a, b)
				return a.jinnType > b.jinnType
			end)
		end
	end
	_UPVALUE2_ = defenceJinn
	defenceJinn[1] = attackJinn
	defenceJinn[2] = defenceJinn
	dump(defenceJinn, "mailItemDetailFightJinn:initData")
	local attackHeight1 = 0 < #attackJinn and 45 or 0
	local defenceHeight1 = 0 < #defenceJinn and 45 or 0
	local attackHeight2, defenceHeight2 = 0, 0
	for i, v in ipairs(attackJinn) do
		if not v.lock then
			local single = self.attackItems[i]
			if not single then
				single = include("commonJinn").new()
				single:setScale(0.65)
				single:addTo(self.nodeAttack)
				self.attackItems[i] = single
			end
			single:initData(v.jinnType, v.starLv, v.lv)
		end
	end
	local num = #attackJinn
	attackHeight2 = attackHeight2 + math.ceil(num / 3) * itemWidth
	SoraDautoSortPos(self.nodeAttack, 3, SoraDFIsRA() and 0 or 2, cc.size(itemWidth, itemWidth), SoraDFIsRA())
	for i, v in ipairs(defenceJinn) do
		if not v.lock then
			local single = self.defenceItems[i]
			if not single then
				single = include("commonJinn").new()
				single:setScale(0.65)
				self.defenceItems[i] = single
				single:addTo(self.nodeDefence)
			end
			single:initData(v.jinnType, v.starLv, v.lv)
		end
	end
	num = #defenceJinn
	defenceHeight2 = defenceHeight2 + math.ceil(num / 3) * itemWidth
	SoraDautoSortPos(self.nodeDefence, 3, SoraDFIsRA() and 2 or 0, cc.size(itemWidth, itemWidth), SoraDFIsRA())
	local defenceHeight = defenceHeight2 + defenceHeight1
	local attackHeight = attackHeight1 + attackHeight2
	local totalHeight = math.max(defenceHeight, attackHeight)
	self.nodeAttack:setPositionY(totalHeight - attackHeight2 / 2)
	self.nodeDefence:setPositionY(totalHeight - defenceHeight2 / 2)
	self.nodeAl:setPositionY(totalHeight - attackHeight2 + 10)
	self.nodeDl:setPositionY(totalHeight - defenceHeight2 + 10)
	self.nodeAl:setVisible(0 < #attackJinn)
	self.nodeDl:setVisible(0 < #defenceJinn)
	totalHeight = math.max(attackHeight, defenceHeight)
	self.layout_content:setContentSize(cc.size(self.itemWidth, totalHeight))
	self.imgLine:setContentSize(cc.size(totalHeight + 20, 3))
	self.imgLine:setPositionY(totalHeight / 2)
	self.itemHeight = totalHeight
	self.attackJinn = attackJinn
	self.defenceJinn = defenceJinn
end
function mailItemDetailFightJinn:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFightJinn:getItemHeight()
	return self.itemHeight
end
function mailItemDetailFightJinn:onAttackDetail(button, event)
	self:onDetailClick(button, event, self.attackJinn)
end
function mailItemDetailFightJinn:onDefenceDetail(button, event)
	self:onDetailClick(button, event, self.defenceJinn)
end
function mailItemDetailFightJinn:onDetailClick(button, event, jinnData)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local proxy = uiManager:show("MagicLampMailRecount")
		proxy.view:updateJinnDetail(jinnData)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
return mailItemDetailFightJinn
