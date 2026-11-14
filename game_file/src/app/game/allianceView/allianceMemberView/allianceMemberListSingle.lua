local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local AllianceMemberListSingle = class("allianceMemberListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMemberListSingle")
	end
	return target
end)
function AllianceMemberListSingle:ctor()
	self.tableSingle, lordInfoCtrl, self.tableSingleData, lordInfoCtrl = nil, nil, nil, nil
	self.tableSpare = nil
	self.isLaunched = false
	self.aid = nil
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
	self.isLongBg = false
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateOtherUI))
end
function AllianceMemberListSingle:setLongBg(isLong)
	self.isLongBg = isLong
end
function AllianceMemberListSingle:sortMemberList()
	local _ENV, online
	local _ENV, unonline
	for i, v in ipairs(self.tableSingleData) do
		if v:getProperty("uid") == self.ownUid then
			table.insert(online, 1, v)
		elseif v:getProperty("online") == 0 then
			table.insert(online, v)
		else
			table.insert(unonline, v)
		end
	end
	self.tableSingleData, _ENV = ipairs(self.tableSingleData)
	for i, v in ipairs(online) do
		table.insert(self.tableSingleData, v)
	end
	for i, v in ipairs(unonline) do
		table.insert(self.tableSingleData, v)
	end
end
function AllianceMemberListSingle:showAppointView(target, data)
	local name = data.uinfo.nickName
	local officialName = allianceDesRead.getOfficialName(self.official)
	allianceDesRead = nil
	;(nil).name = name
	;(nil).office = officialName
	SoraDShowMsgBox(i18n("alliance_office_text_19", nil), i18n("common_text_204"), nil, function(event)
		if event == MSGBOX_CALLBACK_YES then
			allianceMgr:reqAppointAllianceOfficial(data.minfo.uid, self.official)
			SoraDShowLoading()
		end
	end)
end
function AllianceMemberListSingle:initMemberList(singleData, spare, title, official)
	self.aid = allianceMgr:getOwnAid()
	self.tableSingleData = singleData
	self.official = official
	self.tableSpare = spare
	self:sortMemberList()
	self:removeMember()
	local online = 0
	local total = 0
	for i, v in ipairs(self.tableSingleData) do
		allianceMgr = nil
		;(nil).data = v
		;(nil).point = nil
		;(nil).pos = cc.p(0, 0)
		;(nil).scale = 1
		;(nil).handle = handler(self, self.showAppointView)
		table.insert(self.tableSingle, nil)
		if v:getProperty("online") == 0 then
			online = online + 1
		end
	end
	total = #self.tableSingleData
	allianceMgr = v:getProperty("online")
	v:getProperty("online").member = online
	v:getProperty("online").total = total
	self.labelNum:setString("(" .. i18n("common_text_155", (v:getProperty("online"))) .. ")")
	self.spriteLv:setVisible(false)
	self.labelTitle:setPositionX(SoraDFPosX(600))
	self.labelTitle:setString(title)
	if not SoraDFIsRA() then
		self.labelNum:setPositionX(self.labelTitle:getPositionX() + self.labelTitle:getContentSize().width + 20)
	else
		self.labelNum:setPositionX(self.labelTitle:getPositionX() - self.labelTitle:getContentSize().width - 20)
	end
	self:createMember()
end
function AllianceMemberListSingle:isOfficial(rank)
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
function AllianceMemberListSingle:initData(rank, singleData, aid, spare)
	self.tableSingleData = singleData
	self.aid = aid
	self.rank = rank
	self.tableSpare = spare
	self:sortMemberList()
	self:removeMember()
	local online = 0
	local total = 0
	if self.rank == gAllianceRank.OFFICIAL then
		for rank = gAllianceOfficial.COMMANDER, gAllianceOfficial.RECRUITER do
			local data
			local ret, officialData = self:isOfficial(rank)
			if ret then
				data = officialData
				if officialData:getProperty("online") == 0 then
					online = online + 1
				end
				total = total + 1
			else
				local member = include("member").new()
				member:setProperty("official", rank)
				data = member
				table.insert(self.tableSingleData, member)
			end
			_ENV = self.tableSingleData
			self.tableSingleData.data = data
			self.tableSingleData.point = nil
			self.tableSingleData.pos = cc.p(0, 0)
			self.tableSingleData.scale = 1
			table.insert(self.tableSingle, self.tableSingleData)
		end
		table.sort(self.tableSingleData, function(a, b)
			if a.minfo and b.minfo then
				return a.minfo.official < b.minfo.official
			end
		end)
	else
		for i, v in ipairs(self.tableSingleData) do
			_ENV = table.insert
			table.insert.data = v
			table.insert.point = nil
			table.insert.pos = cc.p(0, 0)
			table.insert.scale = 1
			table.insert(self.tableSingle, table.insert)
			if v:getProperty("online") == 0 then
				online = online + 1
			end
		end
		total = #self.tableSingleData
	end
	self:updateOtherUI()
	if self.aid == allianceMgr:getOwnAid() and allianceMgr:hasJoinAlliance() and self.rank > gAllianceRank.R0 and permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_ONLINE_INFO) then
		_ENV = v:getProperty("online")
		v:getProperty("online").member = online
		v:getProperty("online").total = total
		self.labelNum:setString("(" .. i18n("common_text_155", (v:getProperty("online"))) .. ")")
	else
		self.labelNum:setString(tostring(total))
	end
	if not SoraDFIsRA() then
		self.labelNum:setPositionX(self.labelTitle:getPositionX() + self.labelTitle:getContentSize().width + 20)
	else
		self.labelNum:setPositionX(self.labelTitle:getPositionX() - self.labelTitle:getContentSize().width - 20)
	end
	if self.isLaunched then
		self:createMember()
	end
end
function AllianceMemberListSingle:setState(state)
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
function AllianceMemberListSingle:updateOtherUI()
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
	elseif self.rank == gAllianceRank.OFFICIAL then
		if rankTitle and string.utf8len(rankTitle) > 0 then
		else
			rankTitle = i18n("alliance_office_title_02")
		end
	elseif self.rank == gAllianceRank.R0 then
		rankTitle = i18n("common_text_665")
	end
	self.labelTitle:setString(rankTitle)
end
function AllianceMemberListSingle:createMember()
	local panelH = 0
	if 0 < #self.tableSingleData then
		panelH = 230 * math.ceil(#self.tableSingleData / 2)
		if self.rank == gAllianceRank.R5 then
			panelH = 1.1 * panelH
		end
		self.nodeMember:setContentSize(cc.size(640, panelH))
		self.nodeMember:setVisible(false)
		for i, v in ipairs(self.tableSingleData) do
			local posX = SoraDFPosX(160 + i % 2 * 320)
			local posY = panelH - math.floor((i - 1) / 2) * 230
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
			if self.rank == gAllianceRank.R5 then
				self.tableSingle[i].scale = 1.1
				posX = 320
			else
				self.tableSingle[i].scale = 1
			end
			local tmpPos = self.nodeMember:convertToWorldSpace(cc.p(posX, posY))
			tmpPos = self.scroll:getInnerContainer():convertToNodeSpace(tmpPos)
			self.tableSingle[i].pos = tmpPos
			if self.tableSingle[i].point then
				self.tableSingle[i].point:setPosition(self.tableSingle[i].pos)
				self.tableSingle[i].point:setScale(self.tableSingle[i].scale)
			end
		end
		if self.isLongBg then
			panelH = panelH + self.scroll:getContentSize().height
		end
	end
	if 0 < panelH then
		self.nodeMember:setVisible(true)
	end
end
function AllianceMemberListSingle:initMember()
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
				single = SoraDCreatePanel("allianceMemberSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(self.rank, v.data, self.aid)
			if v.handle then
				single:setHandle(v.handle)
			end
			single:setPosition(v.pos)
			single:setScale(v.scale)
			v.point = single
		end
	end
end
function AllianceMemberListSingle:updateScrollSingle(updateSize)
	if #self.tableSingle > 0 and self.isLaunched then
		if updateSize then
			self:createMember()
		end
		self:initMember()
	end
end
function AllianceMemberListSingle:removeMember()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
	self.nodeMember:setVisible(false)
	self.nodeMember:setContentSize(cc.size(640, 0))
end
function AllianceMemberListSingle:getSingleH()
	return self.nodeTouch:getContentSize().height + self.nodeMember:getContentSize().height
end
function AllianceMemberListSingle:setClickCallBack(handle)
	self.handl = handle
end
function AllianceMemberListSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceMemberListSingle:btnClickCallBack(button, type)
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
return AllianceMemberListSingle
