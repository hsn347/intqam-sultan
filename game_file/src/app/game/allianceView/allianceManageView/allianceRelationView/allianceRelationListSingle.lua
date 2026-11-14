local gametop = gModuleMgr.getObject("gametop")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local AllianceRelationListSingle = class("allianceRelationListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceRelationListSingle")
	end
	return target
end)
function AllianceRelationListSingle:ctor()
	self.tableSingle, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.relationType = nil
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.buidlH = 0
	self.layerBuild = SoraDGetChildByName(self, "Panel_build")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerBuild:setSwallowTouches(false)
	self.layerTouch:setSwallowTouches(false)
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	if self.layerTouch then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceRelationListSingle:initData(relationType, relationData, spare)
	self.tableSingleData = relationData
	self.relationType = relationType
	self.tableSpare = spare
	self:removeBuild()
	for i, v in ipairs(self.tableSingleData) do
		_ENV = nil
		;(nil).data = v
		;(nil).point = nil
		;(nil).pos = cc.p(0, 0)
		table.insert(self.tableSingle, nil)
	end
	self:updateOtherUI()
	if self.isLaunched then
		self:createBuild()
	end
end
function AllianceRelationListSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeBuild()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:createBuild()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceRelationListSingle:updateOtherUI()
	_ENV = nil
	;(nil)[1] = i18n("common_text_3076")
	;(nil)[2] = i18n("common_text_3077")
	;(nil)[3] = i18n("common_text_3078")
	local (nil)[4], showData = i18n("common_text_182"), nil
	self.labelTitle:setString(showData[self.relationType])
	if self.relationType == gAllianceRelationType.FRIENDLY or self.relationType == gAllianceRelationType.ENEMY then
		self.labelMember:setString(string.formatnumberthousands(#self.tableSingleData))
	elseif self.relationType == gAllianceRelationType.ALLY then
		self.labelMember:setString(string.formatnumberthousands(#self.tableSingleData) .. "/" .. tostring(ALLIANCE_RELATION_ALLY_MAX))
	else
		self.labelMember:setString(string.formatnumberthousands(allianceRelationCtrl:getAR():getSendInviteNum()) .. "/" .. string.formatnumberthousands(allianceRelationCtrl:getAR():getRecvInviteNum()))
	end
end
function AllianceRelationListSingle:createBuild()
	self.buidlH = 0
	if 0 < #self.tableSingleData then
		self.buidlH = 200 * #self.tableSingleData
		self.layerBuild:setContentSize(cc.size(640, self.buidlH))
		self.layerBuild:setVisible(false)
		for i, v in ipairs(self.tableSingleData) do
			if self.tableSingle[i] == nil then
				_ENV = cc.size(640, self.buidlH)
				cc.size(640, self.buidlH).data = v
				cc.size(640, self.buidlH).point = nil
				self.tableSingle[i], cc.size(640, self.buidlH).pos = cc.size(640, self.buidlH)
			end
			local tmpPos = self.layerBuild:convertToWorldSpace(cc.p(320, self.buidlH - (i - 1) * 200))
			tmpPos = self.scroll:getInnerContainer():convertToNodeSpace(tmpPos)
			self.tableSingle[i].pos = tmpPos
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
			end
		end
	end
	if self.buidlH > 0 then
		self.layerBuild:setVisible(true)
	end
end
function AllianceRelationListSingle:initBuild()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 2 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("allianceRelationSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function AllianceRelationListSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createBuild()
		end
		self:initBuild()
	end
end
function AllianceRelationListSingle:removeBuild()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.layerBuild:setVisible(false)
	self.layerBuild:setContentSize(cc.size(640, 0))
end
function AllianceRelationListSingle:getSingleH()
	return self.layerTouch:getContentSize().height + self.layerBuild:getContentSize().height + 5
end
function AllianceRelationListSingle:getLaunched()
	return self.isLaunched
end
function AllianceRelationListSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceRelationListSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceRelationListSingle:btnClickCallBack(button, type)
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
			self.handl(self.relationType, self.isLaunched)
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
return AllianceRelationListSingle
