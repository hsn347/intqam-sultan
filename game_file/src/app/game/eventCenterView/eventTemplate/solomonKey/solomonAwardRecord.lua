local solomonKeyRead = include("solomonKeyRead")
local publicRead = include("publicRead")
local solomonAwardRecord = class("solomonAwardRecord", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("solomonAwardRecord")
	end
	return target
end)
function solomonAwardRecord:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_player")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.text_alter = SoraDGetChildByName(self, "Text_alter")
	self.text_gift = SoraDGetChildByName(self, "Text_gift")
	self.text_name = SoraDGetChildByName(self, "Text_name")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.sprite_right = SoraDGetChildByName(self, "Sprite_right")
	self.sprite_left = SoraDGetChildByName(self, "Sprite_left")
	self.particle_1 = SoraDGetChildByName(self, "Particle_10")
	self.particle_2 = SoraDGetChildByName(self, "Particle_10_0")
	self.dh_suoluohj = SoraDGetChildByName(self, "dh_suoluohj_01_1")
	SoraDMixtureGLONE(self.particle_1)
	SoraDMixtureGLONE(self.particle_2)
	SoraDMixtureGLONE(self.dh_suoluohj)
	self.ccs_bg:hideTitle()
	self.text_alter:setString(i18n("solomon_text_08"))
	self.text_title:setString(i18n("solomon_title_01"))
	self.text_time:setString(i18n("common_text_289"))
	self.text_name:setString(i18n("solomon_text_09"))
	self.text_gift:setString(i18n("common_text_4405"))
	self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV = self.text_gift.setString, self.text_gift.setString, self.text_gift.setString, self.text_gift.setString
	self.itemSize = cc.size(560, 70)
	self:initCommonDh()
end
function solomonAwardRecord:initCommonDh()
	_UPVALUE4_ = nil
	;(nil)[1] = cca.fadeTo(1.3, 0.06)
	;(nil)[2] = cca.fadeTo(1.36, 0.55)
	;(nil)[3] = cca.fadeTo(2.53, 0.52)
	;(nil)[4] = cca.fadeTo(1, 0.23)
	;(nil)[5] = cca.fadeTo(0.95, 0.44)
	;(nil)[6] = cca.fadeTo(0.95, 0.44)
	;(nil)[7] = cca.fadeTo(0.95, 0.44)
	local seq = cca.seq(nil)
	self.dh_suoluohj:stopAllActions()
	self.dh_suoluohj:runAction(seq)
	local frames = display.newFrames("dh_jinzitanew2_%.2d.png", 1, 9)
	local animation = display.newAnimation(frames, 1 / #frames)
	self.sprite_right:playAnimationForever(animation)
	self.sprite_left:playAnimationForever(animation)
end
function solomonAwardRecord:initView(list, keyID)
	self.awardList = list
	self.keyID = keyID
	if self.keyID == solomonKeyRead.silverKey then
		self.text_title:setString(i18n("solomon_title_03"))
	elseif self.keyID == solomonKeyRead.goldKey then
		self.text_title:setString(i18n("solomon_title_02"))
	end
	if next(self.awardList) == nil then
		self.text_alter:setPosition(0, 0)
	else
		self.text_alter:setPosition(0, -self.ccs_bg:getContentSize().height / 2 - 90)
		self:updateScrollData()
	end
end
function solomonAwardRecord:updateScrollData()
	for k, v in pairs(self.awardList) do
		_ENV = nil
		;(nil).data = v
		_ENV, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initScroll()
	self:initAwardList()
end
function solomonAwardRecord:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local accumulateHeight = self.itemSize.height * #self.tableItemsSel
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = (i - 1) * self.itemSize.height
		v.pos.x = -2
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function solomonAwardRecord:initAwardList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = self:createSingle()
				single:addTo(self.scroll)
			end
			self:initSingleView(v.data, single, i)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function solomonAwardRecord:createSingle()
	local single = self.node_single:clone()
	single.panel = SoraDGetChildByName(single, "Panel_4")
	single.panel:setSwallowTouches(false)
	single.item_color = SoraDGetChildByName(single, "item_color")
	single.item_icon = SoraDGetChildByName(single, "item_icon")
	single.text_playerName = SoraDGetChildByName(single, "Text_playerName")
	single.item_single_show = SoraDGetChildByName(single, "item_single_show")
	single.text_num = SoraDGetChildByName(single, "text_num")
	single.text_time = SoraDGetChildByName(single, "Text_time")
	return single
end
function solomonAwardRecord:initSingleView(data, _node, idx)
	local single = _node
	single.panel:setVisible(idx % 2 == 0)
	single.item_color:loadTexture(publicRead.getBg(data.reward[1].id), ccui.TextureResType.plistType)
	single.item_icon:loadTexture(publicRead.getIcon(data.reward[1].id), ccui.TextureResType.plistType)
	single.text_playerName:setString(data.nickName)
	single.text_time:setString(os.date("!%Y-%m-%d %H:%M:%S", data.time))
	single.item_single_show:setTouchEnabled(true)
	single.item_single_show:setSwallowTouches(false)
	single.item_single_show.itemId = data.reward[1].id
	single.text_num:setString(string.formatnumberthousands(data.reward[1].count))
	single.item_single_show:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if single.tips then
				single.tips:removeFromParent()
				single.tips = nil
			end
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
				return
			end
			self:onClickSingle(_node, data.reward[1].id)
		end
	end)
end
function solomonAwardRecord:onClickSingle(_single, _id)
	local single = _single
	if single.tips then
		single.tips:removeFromParent()
		single.tips = nil
	end
	single.tips = SoraDCreatePanel("commonItemTips")
	single.tips:setPositionY(50)
	single.tips:addTo(self)
	single.tips:setLocalZOrder(10)
	single.tips:setVisible(false)
	local worldPos = single:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		single.tips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		single.tips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	single.tips:setPositionY(nodePos.y + 200)
	single.tips:setVisible(true)
	single.tips:initData(_id)
end
function solomonAwardRecord:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initAwardList()
	end
end
return solomonAwardRecord
