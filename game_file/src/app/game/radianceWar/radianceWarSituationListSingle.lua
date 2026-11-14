local radianceWarRead = include("radianceWarRead")
local radianceWarSituationListSingle = class("radianceWarSituationListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarSituationListSingle")
	end
	return target
end)
function radianceWarSituationListSingle:ctor()
	self.tableSingle, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.rank = nil
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	self.nodeMember = SoraDGetChildByName(self, "Panel_member")
	self.nodeMember:setSwallowTouches(false)
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.frame_up = SoraDGetChildByName(self, "frame_up")
	self.frame_up:setVisible(false)
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelEmpty = SoraDGetChildByName(self, "Text_empty")
	self.labelEmpty:setVisible(false)
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function radianceWarSituationListSingle:sortMemberList()
end
function radianceWarSituationListSingle:initData(rank, singleData, spare, curTab)
	self.tableSingleData = singleData
	self.rank = rank
	self.tableSpare = spare
	self.curTab = curTab
	self:sortMemberList()
	self:removeMember()
	for i, v in ipairs(self.tableSingleData) do
		_ENV = nil
		;(nil).data = v
		;(nil).point = nil
		;(nil).pos = cc.p(0, 0)
		;(nil).scale = 1
		table.insert(self.tableSingle, nil)
	end
	local total = #self.tableSingleData
	self.frame_up:setVisible(false)
	if self.curTab == 1 then
		self.spriteIcon:setScale(0.9)
		_ENV = table.insert
		table.insert.build = radianceWarRead.getResourceNameByType(self.rank)
		self.labelEmpty:setString(i18n("brightWar_text_112", table.insert))
		self.spriteIcon:setSpriteFrame(radianceWarRead.getResourceSmallImageNameByType(self.rank))
		self.labelTitle:setString(radianceWarRead.getResourceNameByType(self.rank))
		_ENV = radianceWarRead.getResourceNameByType(self.rank)
		radianceWarRead.getResourceNameByType(self.rank).member = total
		radianceWarRead.getResourceNameByType(self.rank).total = radianceWarRead.getResourceNumLimit(self.rank)
		self.labelMember:setString(i18n("common_text_155", radianceWarRead.getResourceNameByType(self.rank)))
		local buff = radianceWarRead.getResourceBuff(self.rank)
		local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
		local buffData = lightShiningCtrl:getBuffList()
		local isActive = lightShiningCtrl:isBuffActive()
		if isActive and buff and 0 < buff and SoraDisInList(buff, buffData) then
			self.frame_up:setVisible(true)
		end
	else
		self.spriteIcon:setScale(0.85)
		self.spriteIcon:setSpriteFrame(radianceWarRead.getBuildIcon(self.rank))
		self.labelTitle:setString(radianceWarRead.getBuildName(self.rank))
		if self.rank == gMapObjTypeDef.mapTypeRadianceWarBeacon then
			_ENV = radianceWarRead.getBuildName(self.rank)
			radianceWarRead.getBuildName(self.rank).member = total
			radianceWarRead.getBuildName(self.rank).total = include("constantRead").getConstValue("RADIANCE_ALLIANCE_MAX_BEACON_NUM")
			self.labelMember:setString(i18n("common_text_155", radianceWarRead.getBuildName(self.rank)))
		else
			self.labelMember:setString(tostring(total))
		end
	end
	if self.isLaunched then
		self:createMember()
	end
end
function radianceWarSituationListSingle:setState(state)
	print("radianceWarSituationListSingle:setState", state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeMember()
		self.imgArr:setRotation(SoraDFSign(90))
	else
		self:createMember()
		self.imgArr:setRotation(0)
	end
	self.isLaunched = state
end
function radianceWarSituationListSingle:createMember()
	local panelH = 0
	if 0 < #self.tableSingleData then
		panelH = 120 * #self.tableSingleData
		self.nodeMember:setContentSize(cc.size(640, panelH))
		self.nodeMember:setVisible(false)
		for i, v in ipairs(self.tableSingleData) do
			local posX = 320
			local posY = panelH - (i - 1) * 120
			if self.tableSingle[i] == nil then
				_ENV = cc.size(640, panelH)
				cc.size(640, panelH).data = v
				cc.size(640, panelH).point = nil
				cc.size(640, panelH).pos = cc.p(0, 0)
				self.tableSingle[i], cc.size(640, panelH).scale = cc.size(640, panelH)
			end
			local tmpPos = self.nodeMember:convertToWorldSpace(cc.p(posX, posY))
			tmpPos = self.scroll:getInnerContainer():convertToNodeSpace(tmpPos)
			self.tableSingle[i].pos = tmpPos
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
			end
		end
	end
	if 0 < panelH then
		self.nodeMember:setVisible(true)
	elseif self.curTab == 1 then
		self.labelEmpty:setVisible(true)
		self.nodeMember:setContentSize(cc.size(640, 60))
	end
end
function radianceWarSituationListSingle:initMember()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				v.point:setHiddle()
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("radianceWarSituationSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(self.rank, v.data, self.curTab)
			if v.handle then
				single:setHandle(v.handle)
			end
			single:setPosition(v.pos)
			single:setScale(v.scale)
			v.point = single
		end
	end
end
function radianceWarSituationListSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createMember()
		end
		self:initMember()
	end
end
function radianceWarSituationListSingle:removeMember()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			v.point:setHiddle()
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.labelEmpty:setVisible(false)
	self.nodeMember:setVisible(false)
	self.nodeMember:setContentSize(cc.size(640, 0))
end
function radianceWarSituationListSingle:getSingleH()
	return self.nodeTouch:getContentSize().height + self.nodeMember:getContentSize().height
end
function radianceWarSituationListSingle:setClickCallBack(handle)
	self.handl = handle
end
function radianceWarSituationListSingle:setScroll(scroll)
	self.scroll = scroll
end
function radianceWarSituationListSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:setState(not self.isLaunched)
		if self.handl then
			self.handl(self.rank, self.isLaunched)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarSituationListSingle
