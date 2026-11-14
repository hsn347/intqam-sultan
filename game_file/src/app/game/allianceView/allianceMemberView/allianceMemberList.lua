_ENV = nil
;(nil)[gAllianceRank.R0] = false
;(nil)[gAllianceRank.R1] = false
;(nil)[gAllianceRank.R2] = false
;(nil)[gAllianceRank.R3] = false
;(nil)[gAllianceRank.R4] = false
;(nil)[gAllianceRank.OFFICIAL] = false
local (nil)[gAllianceRank.R5], tableAllianceListState = true, nil
local allianceMemberListOpen = true
;(nil).inviteMoveCityPos, _ENV, _ENV = nil, nil, nil
local tableParam
local AllianceMemberList = class("allianceMemberList", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMemberList")
	end
	return target
end)
function AllianceMemberList.getParam()
	return tableParam
end
function AllianceMemberList:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableSpareListState, _ENV, self.tableSpareList, _ENV, self.tableMemberList, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.loadNew = false
	self.isOwnAid = false
	self.aid = nil
	self.isHaveTextField = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_180"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnAll = SoraDGetChildByName(self, "Button_all")
	self.btnAll:setVisible(false)
	self.tfdSearch = SoraDGetChildByName(self, "TextField_search")
	_ENV = "TextField_search"
	;("TextField_search").func = handler(self, self.OnInputChangeEnd)
	self.tfdSearch = SoraDChangeToEditBox(self.tfdSearch, "TextField_search")
	self.tfdSearch:setTextHorizontalAlignment(SoraDFLabelR())
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	_ENV = SoraDFLabelR()
	SoraDFLabelR().h = 8
	self.labelNotice:setString(i18n("common_text_3208", SoraDFLabelR()))
	self.labelNotice:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_member")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Button_attack = SoraDGetChildByName(self, "Button_attack")
	self.Button_attribute = SoraDGetChildByName(self, "Button_attribute")
	self.Button_attribute:setTitleText(i18n("common_btn_07"))
	self.Button_attack:setTitleText(i18n("common_btn_21"))
	self.Button_attribute:addTouchEventListener(handler(self, self.btnAttributeClick))
	self.Button_attack:addTouchEventListener(handler(self, self.btnAttackClick))
	if worldMapDefine.isInWarForbid(true) then
		self.Button_attribute:setBright(false)
	end
	if self.btnHelp then
		self.btnAll:addTouchEventListener(handler(self, self.btnAllClickCallBack))
		self.btnHelp:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
	end
end
function AllianceMemberList:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPLY_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_FIRE_BACK", handler(self, self.updateData))
end
function AllianceMemberList:initData(aid, param)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if param then
		for k, v in pairs(param) do
			tableParam[k] = v
		end
	end
	if aid == nil then
		aid = allianceMgr.ownaid
	end
	self.aid = aid
	self.isOwnAid = allianceMgr.ownaid == self.aid
	self:updateScrollSize()
	allianceQuery:reqMemberList(self.aid)
	SoraDShowLoading(self)
end
function AllianceMemberList:updateScrollSize()
	if self.isOwnAid then
		self.Bottom_Node:setVisible(true)
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		if KWKingdomCtrl:isProxyKing() and not self.labelNotice:isVisible() then
			self.scroll:setPositionY(display.height - 270)
			self.scroll:setContentSize(cc.size(640, display.height - 270 - 76))
			self.labelNotice:setVisible(true)
		elseif not KWKingdomCtrl:isProxyKing() and self.labelNotice:isVisible() then
			self.scroll:setPositionY(display.height - 170)
			self.scroll:setContentSize(cc.size(640, display.height - 170 - 76))
			self.labelNotice:setVisible(false)
		end
	else
		self.Bottom_Node:setVisible(false)
		self.scroll:setPositionY(display.height - 170)
		self.scroll:setContentSize(cc.size(640, display.height - 170))
		self.labelNotice:setVisible(false)
	end
end
function AllianceMemberList:updateData(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownMapId = ownmember:getProperty("mapId")
	if target then
		self.tableMemberList = allianceMgr:getMemberList(self.aid)
	end
	if ownMapId then
		for k, v in pairs(self.tableMemberList) do
			for i = #v, 1, -1 do
				if v[i].getProperty and (v[i]:getProperty("mapId") == nil or v[i]:getProperty("mapId") ~= ownMapId) then
					table.remove(v, i)
				end
			end
		end
	end
	self:updateScrollSize()
	self:initScroll()
	self:updateScrollView()
	SoraDCloseLoading(self)
	if not self.loadNew and self.isOwnAid then
		self.loadNew = true
		allianceQuery:reqApplyList(self.aid)
		SoraDShowLoading(self)
	end
	if data and data.reload and self.isOwnAid then
		allianceQuery:reqMemberList(self.aid)
		SoraDShowLoading(self)
	end
end
function AllianceMemberList:initScroll()
	local allianceDesRead = include("allianceDesRead")
	_UPVALUE7_ = "allianceDesRead"
	;("allianceDesRead")[1] = "5"
	;("allianceDesRead")[2] = "6"
	;("allianceDesRead")[3] = "4"
	;("allianceDesRead")[4] = "3"
	;("allianceDesRead")[5] = "2"
	;("allianceDesRead")[6] = "1"
	local ("allianceDesRead")[7], tableMemberListKey = "0", "allianceDesRead"
	if allianceMemberListOpen and self.isOwnAid then
		_ENV = {
			[gAllianceRank.R0] = false,
			[gAllianceRank.R1] = false,
			[gAllianceRank.R2] = false,
			[gAllianceRank.R3] = false,
			[gAllianceRank.R4] = false,
			[gAllianceRank.R5] = false,
			[gAllianceRank.OFFICIAL] = false
		}
		tableAllianceListState[allianceDesRead.getOwnRank()] = true
	end
	for i, v in ipairs(tableMemberListKey) do
		local rankData = self.tableMemberList[v]
		local single = self.tableSingle[i]
		if rankData then
			if single == nil then
				single = SoraDCreatePanel("allianceMemberListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				table.insert(self.tableSingle, single)
			end
			single:initData(tonumber(v), rankData, self.aid, self.tableSpare)
			single:setState(tableAllianceListState[tonumber(v)])
			single:setVisible(true)
		elseif single ~= nil then
			single:removeMember()
			single:setVisible(false)
		end
	end
	for i = #self.tableSingle, 1, -1 do
		local single = self.tableSingle[i]
		if single:isVisible() then
			single:setLongBg(true)
			break
		end
	end
end
function AllianceMemberList:updateScrollView(rank, state)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if allianceMgr:hasJoinAlliance() and allianceMgr:getOwnAid() == self.aid and rank ~= nil then
		tableAllianceListState[tonumber(rank)] = state
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	for i = 1, #self.tableSingle do
		local single = self.tableSingle[#self.tableSingle - i + 1]
		if single:isVisible() then
			scrollInnerNewH = scrollInnerNewH + single:getSingleH()
			single:setPosition(cc.p(320, scrollInnerNewH))
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			if v:isVisible() then
				v:setPositionY(v:getPositionY() + upto)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function AllianceMemberList:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function AllianceMemberList:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
function AllianceMemberList:OnInputChangeEnd(eventType, textField)
	if eventType == "changed" then
		local returnName = textField:getString()
		local nameLen = string.utf8len(returnName)
		self.btnAll:setVisible(0 < nameLen)
		if nameLen <= 0 then
			self:showAllMember()
		end
	end
end
function AllianceMemberList:btnSearchClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local returnName = self.tfdSearch:getString()
		local nameLen = string.utf8len(returnName)
		if 0 < nameLen then
			if 0 >= table.nums(self.tableSpareList) then
				self.tableSpareList = self.tableMemberList
				self.tableSpareListState = tableAllianceListState
			end
			_UPVALUE7_ = tableAllianceListState
			tableAllianceListState[1] = "5"
			tableAllianceListState[2] = "6"
			tableAllianceListState[3] = "4"
			tableAllianceListState[4] = "3"
			tableAllianceListState[5] = "2"
			tableAllianceListState[6] = "1"
			local tableAllianceListState[7], tableMemberListKey = "0", tableAllianceListState
			local _ENV, searchData = "5", "5"
			for i, v in ipairs(tableMemberListKey) do
				local rankData = self.tableMemberList[v]
				if rankData then
					for j, member in ipairs(rankData) do
						local baseName = member.nickName or member:getProperty("nickName")
						if string.find(string.lower(baseName), string.lower(returnName), 1, true) then
							if searchData[v] == nil then
								searchData[v], _ENV = searchData[v], searchData[v]
							end
							tableAllianceListState[tonumber(v)] = true
							table.insert(searchData[v], member)
						end
					end
				end
			end
			if 0 < table.nums(searchData) then
				self.tableMemberList = searchData
				self:updateData()
			else
				SoraDShowMsgTip(i18n("common_text_963"))
				self.tfdSearch:setString("")
				self.btnAll:setVisible(false)
				self:showAllMember()
			end
		end
	end
end
function AllianceMemberList:btnAllClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.tfdSearch:setString("")
		button:setVisible(false)
		self:showAllMember()
	end
end
function AllianceMemberList:showAllMember()
	if table.nums(self.tableSpareList) > 0 then
		self.tableMemberList = self.tableSpareList
		self.tableSpareList, _ENV, self.tableSpareListState, _ENV = {}, {}, {}, {}
		self:updateData(true)
	end
end
function AllianceMemberList:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local allianceDesRead = include("allianceDesRead")
		if not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMemberRankInfoView")
			else
				SoraDCreatePanel("allianceMemberRankInfoView"):show()
			end
		end
	end
end
function AllianceMemberList:btnAttributeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		SoraDCreatePanel("allianceAttributeView"):show()
	end
end
function AllianceMemberList:btnAttackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceMemberBattlePointView"):show()
	end
end
function AllianceMemberList:onExitPanel()
	tableParam.inviteMoveCityPos, tableParam = nil, nil
end
return AllianceMemberList
