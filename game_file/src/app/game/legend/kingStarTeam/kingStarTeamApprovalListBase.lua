local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local kingStarTeamApprovalListBase = class("kingStarTeamApprovalListBase", function(target)
	return target
end)
local TEAM_APPROVAL_TYPE_ADD = _G.TEAM_APPROVAL_TYPE_ADD
function kingStarTeamApprovalListBase:ctor()
	self.showList, _ENV, self.teamList, _ENV, self.ignoreUID, _ENV, self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.txtTeamTitle = SoraDGetChildByName(self, "Text_team_title")
	self.txtTeamTitle:setString(i18n("remains_text_51"))
	self.txtTeamNum = SoraDGetChildByName(self, "Text_team_num")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_approval")
	self.viewType = TEAM_APPROVAL_TYPE_ADD
end
function kingStarTeamApprovalListBase:onMessageListener_common()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateByTeamInfo))
end
function kingStarTeamApprovalListBase:initData(target, data)
	SoraDCloseLoading(self)
	local _ENV, teamList = SoraDCloseLoading, SoraDCloseLoading
	if data.teamList and next(data.teamList) ~= nil then
		teamList = data.teamList
	end
	self:initView(teamList)
end
function kingStarTeamApprovalListBase:initView(teamList)
	self.teamList = teamList
	table.sort(self.teamList, function(team1, team2)
		if team1.online ~= team2.online then
			if team1.online == 0 then
				return true
			elseif team2.online == 0 then
				return false
			end
		end
		if team1.totalFc ~= team2.totalFc then
			return team2.totalFc < team1.totalFc
		end
		if team1.cityLevel ~= team2.cityLevel then
			return team2.cityLevel < team1.cityLevel
		end
		return team1.uid < team2.uid
	end)
	self.ignoreUID, _ENV = table.sort, table.sort
	self:updateListMember(self.teamList)
end
function kingStarTeamApprovalListBase:addIgnoreUID(uid)
	if uid and not self.ignoreUID[uid] then
		self.ignoreUID[uid] = true
		self:updateShowList()
	end
end
function kingStarTeamApprovalListBase:addIgnoreUidList(uidList)
	local isDirty = false
	for _, uid in ipairs(uidList) do
		if not self.ignoreUID[uid] then
			self.ignoreUID[uid] = true
			isDirty = true
		end
	end
	if isDirty then
		self:updateShowList()
	end
end
function kingStarTeamApprovalListBase:updateViewByData()
	for _, v in ipairs(self.scrollItems) do
		v:updateView()
	end
end
function kingStarTeamApprovalListBase:updateRemain()
	local remainNum = kingStarTeamCtrl:getTeamRemainNum()
	self.txtTeamNum:setString(tostring(remainNum))
	_UPVALUE2_ = tostring(remainNum)
	tostring(remainNum)[1] = self.txtTeamNum
	tostring(remainNum)[2] = self.txtTeamTitle
	_ENV = self.txtTeamTitle
	self.txtTeamTitle[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(0, tostring(remainNum))
end
function kingStarTeamApprovalListBase:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = 300 * math.ceil(#self.scrollItems / 2)
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.scrollItems) do
		local posX = SoraDFPosX(160 + i % 2 * 320)
		local posY = sH - math.floor((i - 1) / 2) * 300
		v:setPosition(posX, posY)
	end
end
function kingStarTeamApprovalListBase:updateScrollData()
	for _, v in ipairs(self.showList) do
		local single = self:getSingle()
		v.viewType = self.viewType
		_ENV = nil
		;(nil).isBatch = self.isBatch
		;(nil).scroll = self.scroll
		;(nil).joinHandle = handler(self, self.joinClickCallBack)
		single:initOtherData(nil)
		single:initData(v)
		table.insert(self.scrollItems, single)
	end
end
function kingStarTeamApprovalListBase:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = SoraDCreatePanel("kingStarTeamApprovalListSingle")
		single:addTo(self.scroll)
	end
	single:setVisible(true)
	return single
end
function kingStarTeamApprovalListBase:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function kingStarTeamApprovalListBase:updateScrollList()
	self:recycleSingle()
	self:updateScrollData()
	self:updateScrollPos()
end
function kingStarTeamApprovalListBase:updateByTeamInfo()
	if not kingStarTeamCtrl:isHasTeam() then
		self:removeFromParent()
	else
		self:updateRemain()
		self:updateViewByData()
	end
end
function kingStarTeamApprovalListBase:getSelectUidList()
	local _ENV, ret
	for _, v in ipairs(self.scrollItems) do
		local uid = v:getSelectedUid()
		if v:getIsSelected() and not self.ignoreUID[uid] then
			table.insert(ret, uid)
		end
	end
	return ret
end
function kingStarTeamApprovalListBase:setIsSelected(isSelected)
	for _, v in ipairs(self.scrollItems) do
		v:setIsSelected(isSelected)
	end
end
return kingStarTeamApprovalListBase
