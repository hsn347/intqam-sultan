local heroCtrl = SoraDGetCtrl("heroCtrl")
local mailItemDetailFightHero = class("mailItemDetailFightHero", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailFightHero")
end)
function mailItemDetailFightHero:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.defendDivineBeastItems, _ENV, self.attackDivineBeastItems, _ENV, self.attackLItems, _ENV, self.defenceLItems, _ENV, self.defenceItems, _ENV, self.attackItems, _ENV = self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled, self.setCascadeOpacityEnabled
	self.itemWidth = gMailDetaiViewWidth
	self.layout_content = SoraDGetChildByName(self, "Panel")
	self.imgLine = SoraDGetChildByName(self.layout_content, "Image_line")
	self.nodeAttack = SoraDGetChildByName(self.layout_content, "Node_Attack")
	self.attackSkill = SoraDGetChildByName(self.nodeAttack, "Node_skill")
	self.attackSkillBtn = SoraDGetChildByName(self.attackSkill, "Button_skill")
	self.attackSkillBtn:addTouchEventListener(handler(self, self.onAttackSkillDetail))
	self.attackSkillBtn:setSwallowTouches(false)
	self.nodeDefence = SoraDGetChildByName(self.layout_content, "Node_Defence")
	self.defenceSkill = SoraDGetChildByName(self.nodeDefence, "Node_skill")
	self.defenceSkillBtn = SoraDGetChildByName(self.defenceSkill, "Button_skill")
	self.defenceSkillBtn:addTouchEventListener(handler(self, self.onDefenceSkillDetail))
	self.defenceSkillBtn:setSwallowTouches(false)
	self.nodeAl = SoraDGetChildByName(self.layout_content, "Node_AL")
	SoraDGetChildByName(self.nodeAl, "Text_Title"):setString(i18n("lieutenant_text_01"))
	self.nodeDl = SoraDGetChildByName(self.layout_content, "Node_DL")
	SoraDGetChildByName(self.nodeDl, "Text_Title"):setString(i18n("lieutenant_text_01"))
end
function mailItemDetailFightHero:initData(contentData)
	self.isArenaReport = contentData.mailReportType == gMailReportType.ARENA
	local parentScroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	local itemWidth = 95
	_ENV, _ENV = nil, nil
	local _ENV, _ENV, attackHero, attackArms, attackDivineBeast
	local _ENV, lieuTenantA, lieuTenantD
	local _ENV, attackDivineBeastMarkList
	dump(contentData, "mailItemDetailFightHero:initData")
	if contentData.playerInfo1.uinfo and contentData.playerInfo1.uinfo.id then
		attackHero, _ENV = contentData.heroList[tostring(contentData.playerInfo1.uinfo.id)], contentData.heroList[tostring(contentData.playerInfo1.uinfo.id)]
		attackHero = contentData.heroList[tostring(contentData.playerInfo1.uinfo.id)] or nil
		lieuTenantA = heroCtrl:getLieutenantByHeroList(attackHero)
		attackArms, _ENV = contentData.armsList[tostring(contentData.playerInfo1.uinfo.id)], contentData.armsList[tostring(contentData.playerInfo1.uinfo.id)]
		attackArms = contentData.armsList[tostring(contentData.playerInfo1.uinfo.id)] or nil
		attackDivineBeast, _ENV = contentData.divineBeastList[tostring(contentData.playerInfo1.uinfo.id)], contentData.divineBeastList[tostring(contentData.playerInfo1.uinfo.id)]
		attackDivineBeast = contentData.divineBeastList and contentData.divineBeastList[tostring(contentData.playerInfo1.uinfo.id)] or nil
		attackDivineBeastMarkList, _ENV = contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)], contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)]
		attackDivineBeastMarkList = contentData.divineBeastMarkList and contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)] or nil
	end
	local _ENV, defenceHero = contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)], contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)]
	local _ENV, defenceArms = tostring(contentData.playerInfo1.uinfo.id), tostring(contentData.playerInfo1.uinfo.id)
	local _ENV, defenceDivineBeast = contentData.playerInfo1.uinfo.id, contentData.playerInfo1.uinfo.id
	local _ENV, defenceDivineBeastMarkList
	if contentData.playerInfo2.uinfo and contentData.playerInfo2.uinfo.id then
		defenceHero, _ENV = contentData.heroList[tostring(contentData.playerInfo2.uinfo.id)], contentData.heroList[tostring(contentData.playerInfo2.uinfo.id)]
		defenceHero = contentData.heroList[tostring(contentData.playerInfo2.uinfo.id)] or contentData.divineBeastMarkList[tostring(contentData.playerInfo1.uinfo.id)]
		lieuTenantD = heroCtrl:getLieutenantByHeroList(defenceHero)
		defenceArms, _ENV = contentData.armsList[tostring(contentData.playerInfo2.uinfo.id)], contentData.armsList[tostring(contentData.playerInfo2.uinfo.id)]
		defenceArms = contentData.armsList[tostring(contentData.playerInfo2.uinfo.id)] or tostring(contentData.playerInfo1.uinfo.id)
		defenceDivineBeast, _ENV = contentData.divineBeastList[tostring(contentData.playerInfo2.uinfo.id)], contentData.divineBeastList[tostring(contentData.playerInfo2.uinfo.id)]
		defenceDivineBeast = contentData.divineBeastList and contentData.divineBeastList[tostring(contentData.playerInfo2.uinfo.id)] or contentData.playerInfo1.uinfo.id
		defenceDivineBeastMarkList, _ENV = contentData.divineBeastMarkList[tostring(contentData.playerInfo2.uinfo.id)], contentData.divineBeastMarkList[tostring(contentData.playerInfo2.uinfo.id)]
		defenceDivineBeastMarkList = contentData.divineBeastMarkList and contentData.divineBeastMarkList[tostring(contentData.playerInfo2.uinfo.id)] or nil
	end
	local attackHeight1 = self:initLieutenant(self.nodeAl, lieuTenantA, SoraDFIsRA() and 0 or 2)
	local defenceHeight1 = self:initLieutenant(self.nodeDl, lieuTenantD, SoraDFIsRA() and 2 or 0)
	local attackHeight2, defenceHeight2 = 0, 0
	for i, v in ipairs(attackHero) do
		local single = self.attackItems[i]
		if not single then
			single = include("heroEpicItem").new()
			single:setScale(0.65)
			single:addTo(self.nodeAttack)
			self.attackItems[i] = single
		end
		single:initData(v, parentScroll)
	end
	for i, v in ipairs(attackDivineBeast) do
		local single = self.attackDivineBeastItems[i]
		if not single then
			single = include("commonDivinebeast").new()
			single:setScale(0.85)
			single:addTo(self.nodeAttack)
			self.attackDivineBeastItems[i] = single
		end
		single:initData(v, 1)
		_ENV = single.initData
		single.initData.beastData = v
		local single.initData.markList, mailData = attackDivineBeastMarkList[tostring(v.beastId)], single.initData
		single:setClickCallback(handler(self, self.onAttackDivineDetail), mailData)
	end
	local num = #attackHero + #attackDivineBeast
	if next(attackArms) and attackArms[1] then
		SoraDGetChildByName(self.attackSkill, "Sprite_skill"):setSpriteFrame(include("equipDesRead").getArtifactIcon(attackArms[1].armsID))
		SoraDGetChildByName(self.attackSkill, "Text_lv"):setString(tostring(attackArms[1].level))
		self.attackSkill:setVisible(true)
		num = num + 1
	else
		self.attackSkill:setVisible(false)
	end
	if 0 < num then
		attackHeight2 = attackHeight2 + 20
	end
	attackHeight2 = attackHeight2 + math.ceil(num / 3) * itemWidth
	SoraDautoSortPos(self.nodeAttack, 3, SoraDFIsRA() and 0 or 2, cc.size(itemWidth, itemWidth), SoraDFIsRA())
	for i, v in ipairs(defenceHero) do
		local single = self.defenceItems[i]
		if not single then
			single = include("heroEpicItem").new()
			single:setScale(0.65)
			self.defenceItems[i] = single
			single:addTo(self.nodeDefence)
		end
		single:initData(v, parentScroll)
	end
	for i, v in ipairs(defenceDivineBeast) do
		local single = self.defendDivineBeastItems[i]
		if not single then
			single = include("commonDivinebeast").new()
			single:setScale(0.85)
			single:addTo(self.nodeDefence)
			self.defendDivineBeastItems[i] = single
		end
		single:initData(v, 1)
		_ENV = single.initData
		single.initData.beastData = v
		local single.initData.markList, mailData = defenceDivineBeastMarkList[tostring(v.beastId)], single.initData
		single:setClickCallback(handler(self, self.onDefendDivineDetail), mailData)
	end
	num = #defenceHero + #defenceDivineBeast
	if defenceArms and next(defenceArms) and defenceArms[1] then
		SoraDGetChildByName(self.defenceSkill, "Sprite_skill"):setSpriteFrame(include("equipDesRead").getArtifactIcon(defenceArms[1].armsID))
		SoraDGetChildByName(self.defenceSkill, "Text_lv"):setString(tostring(defenceArms[1].level))
		self.defenceSkill:setVisible(true)
		num = num + 1
	else
		self.defenceSkill:setVisible(false)
	end
	if 0 < num then
		defenceHeight2 = defenceHeight2 + 20
	end
	defenceHeight2 = defenceHeight2 + math.ceil(num / 3) * itemWidth
	SoraDautoSortPos(self.nodeDefence, 3, SoraDFIsRA() and 2 or 0, cc.size(itemWidth, itemWidth), SoraDFIsRA())
	local defenceHeight = defenceHeight2 + defenceHeight1
	local attackHeight = attackHeight1 + attackHeight2
	local totalHeight = math.max(defenceHeight, attackHeight)
	self.nodeAttack:setPositionY(totalHeight - attackHeight2 / 2)
	self.nodeDefence:setPositionY(totalHeight - defenceHeight2 / 2)
	self.nodeAl:setPositionY(totalHeight - attackHeight2)
	self.nodeDl:setPositionY(totalHeight - defenceHeight2)
	totalHeight = math.max(attackHeight, defenceHeight)
	self.layout_content:setContentSize(cc.size(self.itemWidth, totalHeight))
	self.imgLine:setContentSize(cc.size(totalHeight + 20, 3))
	self.imgLine:setPositionY(totalHeight / 2)
	self.itemHeight = totalHeight
	self.attackArms = attackArms
	self.defenceArms = defenceArms
end
function mailItemDetailFightHero:initLieutenant(target, data, align)
	if #data <= 0 or not commonCheck.HERO_COMBOS_SKILL then
		target:setVisible(false)
		return 0
	end
	local parentScroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	target:setVisible(true)
	local height = 30
	local heroNode = SoraDGetChildByName(target, "Node_Hero")
	heroNode:removeAllChildren()
	local itemWidth = 95
	for _, v in ipairs(data) do
		local single = include("heroEpicItem").new()
		single:setScale(0.65)
		single:addTo(heroNode)
		single:initData(v, parentScroll)
	end
	height = height + math.ceil(#data / 3) * itemWidth
	SoraDautoSortPos(heroNode, 3, align, cc.size(itemWidth, itemWidth), SoraDFIsRA())
	heroNode:setPositionY(-(height / 2 + 20))
	return height
end
function mailItemDetailFightHero:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFightHero:getItemHeight()
	return self.itemHeight
end
function mailItemDetailFightHero:onAttackDivineDetail(button, event, data)
	self:onBeastDetailClick(button, event, data)
end
function mailItemDetailFightHero:onDefendDivineDetail(button, event, data)
	self:onBeastDetailClick(button, event, data)
end
function mailItemDetailFightHero:onBeastDetailClick(button, event, mailData)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.isArenaReport then
			return
		end
		SoraDPlaySound()
		dump(mailData, "onBeastDetailClick")
		_ENV = nil
		;(nil).mailData = mailData
		uiManager:show("DivineBeastMarkRecount", nil)
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
function mailItemDetailFightHero:onAttackSkillDetail(button, event)
	self:onArmsDetailClick(button, event, self.attackArms[1])
end
function mailItemDetailFightHero:onDefenceSkillDetail(button, event)
	self:onArmsDetailClick(button, event, self.defenceArms[1])
end
function mailItemDetailFightHero:onArmsDetailClick(button, event, armsData)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local proxy = uiManager:show("MagicLampMailRecount")
		proxy.view:updateArmsDetail(armsData)
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
return mailItemDetailFightHero
