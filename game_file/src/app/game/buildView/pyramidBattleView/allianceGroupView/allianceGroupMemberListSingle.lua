local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local AllianceGroupMemberListSingle = class("allianceGroupMemberListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupMemberListSingle")
	end
	return target
end)
function AllianceGroupMemberListSingle:ctor()
	self.tableSingle, lordInfoCtrl, self.tableSingleData, lordInfoCtrl = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.rank = nil
	self.ownUid = lordInfoCtrl:getLordInfo().base.uid
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	self.nodeMember = SoraDGetChildByName(self, "Panel_member")
	self.nodeMember:setSwallowTouches(false)
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.spriteLv = SoraDGetChildByName(self, "Sprite_icon")
	self.labelNum = SoraDGetChildByName(self, "Text_member")
	self.imgArr = SoraDGetChildByName(self, "Sprite_arr")
	self.handl = nil
	self.scroll = nil
	self.singleIsMoved = false
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceGroupMemberListSingle:sortMemberList()
	table.sort(self.tableSingleData, function(l, r)
		return l.uinfo.totalFc > r.uinfo.totalFc
	end)
end
function AllianceGroupMemberListSingle:isOfficial(rank)
	local ret = false
	local data
	for i, v in ipairs(self.tableSingleData) do
		if v and v.minfo.official and v.minfo.official == rank then
			ret = true
			data = v
			break
		end
	end
	return ret, data
end
function AllianceGroupMemberListSingle:initData(rank, singleData, spare, groupIndex)
	self.tableSingleData = singleData
	self.rank = rank
	self.tableSpare = spare
	self.groupIndex = groupIndex
	self:sortMemberList()
	self:removeMember()
	local legionInfoList = pyramidWarCtrl:getLegionInfoList()
	local curLegionInfo = legionInfoList[self.groupIndex]
	local online = 0
	local total = 0
	for i, v in ipairs(self.tableSingleData) do
		pyramidWarCtrl = nil
		;(nil).data = v
		;(nil).point = nil
		;(nil).pos = cc.p(0, 0)
		;(nil).scale = 1
		table.insert(self.tableSingle, nil)
		if curLegionInfo.memberList[tostring(v:getProperty("uid"))] then
			online = online + 1
		end
	end
	total = #self.tableSingleData
	self:updateOtherUI()
	pyramidWarCtrl = curLegionInfo.memberList[tostring(v:getProperty("uid"))]
	curLegionInfo.memberList[tostring(v:getProperty("uid"))].member = online
	curLegionInfo.memberList[tostring(v:getProperty("uid"))].total = total
	self.labelNum:setString("(" .. i18n("common_text_155", curLegionInfo.memberList[tostring(v:getProperty("uid"))]) .. ")")
	if not SoraDFIsRA() then
		self.labelNum:setPositionX(self.labelTitle:getPositionX() + self.labelTitle:getContentSize().width + 20)
	else
		self.labelNum:setPositionX(self.labelTitle:getPositionX() - self.labelTitle:getContentSize().width - 20)
	end
	if self.isLaunched then
		self:createMember()
	end
end
function AllianceGroupMemberListSingle:setState(state)
	print("AllianceGroupMemberListSingle:setState", state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeMember()
		self.imgArr:setRotation(SoraDFPosX(90, 0))
	else
		self:createMember()
		self.imgArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceGroupMemberListSingle:updateOtherUI()
	self.spriteLv:setSpriteFrame(allianceDesRead.getIcon(self.rank))
	local rankKey = "r" .. self.rank .. "Name"
	local rankTitle = allianceMgr:getAllianceProperty(rankKey, self.aid)
	if rankTitle and string.utf8len(rankTitle) == 0 then
		allianceDesRead = self.aid
		self.aid.rank = self.rank
		rankTitle = i18n("common_text_205", self.aid)
		if self.rank == gAllianceRank.OFFICIAL then
			rankTitle = i18n("alliance_office_title_02")
		end
	elseif self.rank ~= gAllianceRank.OFFICIAL or rankTitle and string.utf8len(rankTitle) > 0 then
	else
		rankTitle = i18n("alliance_office_title_02")
	end
	self.labelTitle:setString(rankTitle)
end
function AllianceGroupMemberListSingle:createMember()
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
				if self.official then
					self.tableSingle[i].handle = handler(self, self.showAppointView)
				end
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
	end
end
function AllianceGroupMemberListSingle:initMember()
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
				single = SoraDCreatePanel("allianceGroupMemberSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(self.rank, v.data, self.groupIndex)
			if v.handle then
				single:setHandle(v.handle)
			end
			single:setPosition(v.pos)
			single:setScale(v.scale)
			v.point = single
		end
	end
end
function AllianceGroupMemberListSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createMember()
		end
		self:initMember()
	end
end
function AllianceGroupMemberListSingle:removeMember()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			v.point:setHiddle()
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.nodeMember:setVisible(false)
	self.nodeMember:setContentSize(cc.size(640, 0))
end
function AllianceGroupMemberListSingle:getSingleH()
	return self.nodeTouch:getContentSize().height + self.nodeMember:getContentSize().height
end
function AllianceGroupMemberListSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceGroupMemberListSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceGroupMemberListSingle:btnClickCallBack(button, type)
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
return AllianceGroupMemberListSingle
