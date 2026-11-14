local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local teamApprovalListBase = class("teamApprovalListBase", function(target)
	return target
end)
local TEAM_APPROVAL_TYPE_ADD = _G.TEAM_APPROVAL_TYPE_ADD
function teamApprovalListBase:ctor()
	self.showList, _ENV, self.teamList, _ENV, self.ignoreUID, _ENV, self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.txtTeamTitle = SoraDGetChildByName(self, "Text_team_title")
	self.txtTeamTitle:setString(i18n("remains_text_51"))
	self.txtTeamNum = SoraDGetChildByName(self, "Text_team_num")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_approval")
	self.viewType = TEAM_APPROVAL_TYPE_ADD
end
function teamApprovalListBase:onMessageListener_common()
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateByTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS", function(target, data)
		if not remainsTeamCtrl:isWarMatchBegin() then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
end
function teamApprovalListBase:initData(target, data)
	SoraDCloseLoading(self)
	local _ENV, teamList = SoraDCloseLoading, SoraDCloseLoading
	if data.teamList and next(data.teamList) ~= nil then
		teamList = data.teamList
	end
	self:initView(teamList)
end
function teamApprovalListBase:initView(teamList)
	self.teamList = teamList
	table.sort(self.teamList, function(team1, team2)
		local online1 = team1.online or 0
		local online2 = team2.online or 0
		if online1 ~= online2 then
			if online1 == 0 then
				return true
			elseif online2 == 0 then
				return false
			else
				return online1 > online2
			end
		end
		return team1.uid < team2.uid
	end)
	self.ignoreUID, _ENV = table.sort, table.sort
	self:updateListMember(self.teamList)
end
function teamApprovalListBase:addIgnoreUID(uid)
	if uid and not self.ignoreUID[uid] then
		self.ignoreUID[uid] = true
		self:updateShowList()
	end
end
function teamApprovalListBase:updateViewByData()
	for _, v in ipairs(self.scrollItems) do
		v:updateView()
	end
end
function teamApprovalListBase:updateRemain()
	local remainNum = remainsTeamCtrl:getTeamRemainNum()
	self.txtTeamNum:setString(tostring(remainNum))
	_UPVALUE2_ = tostring(remainNum)
	tostring(remainNum)[1] = self.txtTeamNum
	tostring(remainNum)[2] = self.txtTeamTitle
	_ENV = self.txtTeamTitle
	self.txtTeamTitle[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(0, tostring(remainNum))
end
function teamApprovalListBase:updateScrollPos()
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
function teamApprovalListBase:updateScrollData()
	for _, v in ipairs(self.showList) do
		local single = self:getSingle()
		v.viewType = self.viewType
		single:initData(v)
		single:setScroll(self.scroll)
		single:setJoinHandle(handler(self, self.joinClickCallBack))
		table.insert(self.scrollItems, single)
	end
end
function teamApprovalListBase:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = SoraDCreatePanel("teamApprovalListSingle")
		single:addTo(self.scroll)
	end
	single:setVisible(true)
	return single
end
function teamApprovalListBase:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function teamApprovalListBase:updateScrollList()
	self:recycleSingle()
	self:updateScrollData()
	self:updateScrollPos()
end
function teamApprovalListBase:updateByTeamInfo()
	if not remainsTeamCtrl:isHasTeam() then
		self:removeFromParent()
	else
		self:updateRemain()
		self:updateViewByData()
	end
end
return teamApprovalListBase
