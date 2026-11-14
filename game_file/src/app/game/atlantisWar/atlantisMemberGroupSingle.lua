local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local atlantisMemberGroupSingle = class("atlantisMemberGroupSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisMemberGroupSingle")
	end
	return target
end)
function atlantisMemberGroupSingle:getSingleH(...)
	return -self.nodeMember:getPositionY() + self.nodeMember:getContentSize().height + 5
end
function atlantisMemberGroupSingle:ctor()
	self.tableSingle, _UPVALUE0_ = nil, nil
	self.isLaunched = false
	self:initWidget()
end
function atlantisMemberGroupSingle:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.nodeTouch = SoraDCreatePanelByCloneNode(self.Panel_touch, "commonBtnInstance")
	self.nodeTouch:setSwallowTouches(false)
	self.nodeTouch:setHandle(handler(self, self.btnClickCallBack))
	self.nodeMember = self.Panel_member
	self.nodeMember:setSwallowTouches(false)
	self.nodeMember:setVisible(false)
end
function atlantisMemberGroupSingle:initData(data, otherData)
	self.data = data
	if not data.playerList then
		_ENV = data.playerList
	end
	self.playerList = data.playerList
	self.index = otherData.index
	self.tableSpare = otherData.tableSpare
	self.scroll = otherData.scroll
	_UPVALUE4_, self.itemSize = otherData.itemSize, otherData.itemSize
	_ENV = nil
	;(nil).lv = 3
	_ENV = nil
	;(nil).lv = 2
	_ENV = nil
	;(nil).lv = 1
	_ENV = nil
	;(nil).lv = 0
	otherData.itemSize[1] = i18n("atlantiswar_text_0141")
	otherData.itemSize[2] = i18n("common_text_277", nil)
	otherData.itemSize[3] = i18n("common_text_277", nil)
	otherData.itemSize[4] = i18n("common_text_277", nil)
	otherData.itemSize[5] = i18n("common_text_277", nil)
	otherData.itemSize[6] = i18n("common_text_277", nil)
	otherData.itemSize[7] = i18n("common_text_277", nil)
	otherData.itemSize[8] = i18n("common_text_277", nil)
	otherData.itemSize[9] = i18n("common_text_277", nil)
	otherData.itemSize[10] = i18n("common_text_277", nil)
	local otherData.itemSize[11], config = i18n("common_text_277", nil)
	self.Text_title:setString(string.format("%s(%d)", config[self.index], #self.playerList))
	self:removeMember()
	for i, v in ipairs(self.playerList) do
		_ENV = string.format("%s(%d)", config[self.index], #self.playerList)
		string.format("%s(%d)", config[self.index], #self.playerList).data = v
		string.format("%s(%d)", config[self.index], #self.playerList).point = nil
		string.format("%s(%d)", config[self.index], #self.playerList).pos = cc.p(0, 0)
		table.insert(self.tableSingle, string.format("%s(%d)", config[self.index], #self.playerList))
	end
	if self.isLaunched then
		self:createMember()
	end
	self.nodeTouch:setScroll(self.scroll)
end
function atlantisMemberGroupSingle:setClickCallBack(handle)
	self.clickHandle = handle
end
function atlantisMemberGroupSingle:btnClickCallBack(button, type)
	self:setState(not self.isLaunched)
	if self.clickHandle then
		self.clickHandle(self.index, self.isLaunched)
	end
end
function atlantisMemberGroupSingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeMember()
		self.Sprite_arr:setRotation(90)
	else
		self:createMember()
		self.Sprite_arr:setRotation(SoraDFPosX(0, 180))
	end
	self.isLaunched = state
end
function atlantisMemberGroupSingle:createMember(...)
	local itemSize = self.itemSize
	local itemH = itemSize.height
	local beginY = 0
	local panelH = 0
	if 0 < #self.playerList then
		panelH = math.ceil(#self.playerList / 2) * itemH
		for i, v in ipairs(self.playerList) do
			local row = math.ceil(i / 2)
			local col = (i - 1) % 2 + 1
			local posX = 320 - SoraDFSign((col - 1) * 300 - 150)
			local posY = beginY + (panelH - itemH * (row - 1))
			if self.tableSingle[i] == nil then
				_ENV = nil
				;(nil).data = v
				;(nil).point = nil
				self.tableSingle[i], (nil).pos = nil, cc.p(0, 0)
			end
			local tmpPos = self.nodeMember:convertToWorldSpace(cc.p(posX, posY))
			tmpPos = self.scroll:getInnerContainer():convertToNodeSpace(tmpPos)
			self.tableSingle[i].pos = tmpPos
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
			end
		end
	end
	self.nodeMember:setContentSize(cc.size(640, panelH))
end
function atlantisMemberGroupSingle:initMember()
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
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("atlantisMemberSingle")
				single:addTo(self.scroll, 1)
			end
			_ENV = 1
			;(1).scroll = self.scroll
			single:initData(v.data, 1)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function atlantisMemberGroupSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createMember()
		end
		self:initMember()
	end
end
function atlantisMemberGroupSingle:removeMember(...)
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.nodeMember:setContentSize(cc.size(640, 0))
end
return atlantisMemberGroupSingle
