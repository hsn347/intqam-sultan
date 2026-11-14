local gametop = gModuleMgr.getObject("gametop")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceRelationView = class("allianceRelationView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceRelationView")
	end
	return target
end)
function AllianceRelationView:ctor()
	_ENV = nil
	;(nil)[gAllianceRelationType.ALLY] = false
	;(nil)[gAllianceRelationType.FRIENDLY] = false
	;(nil)[gAllianceRelationType.ENEMY] = false
	self.tableAllianceRelationListState, (nil)[4] = nil, true
	self.tableRelationList, (nil)[4], _ENV, (nil)[3], _ENV, (nil)[2], _ENV, (nil)[1], _ENV, _ENV, self.tableSpare, _ENV, self.tableSingle, _ENV, self.dataCount = nil, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, gAllianceRelationType.ENEMY, nil, nil, nil, nil, nil, 0
	self.tableCurShow = nil
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_alliance")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_3075"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnIgnoreAll = SoraDGetChildByName(self, "Button_ignoreAll")
	self.btnIgnoreAll:setTitleText(i18n("common_text_1266"))
	self.btnIgnoreAll:setVisible(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnIgnoreAll:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_GET_SUCCESS", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_INVITES_GET_SUCCESS", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.dataBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	if not worldMapDefine.isInRemains() then
		SoraDShowLoading(self)
		allianceRelationCtrl:reqGetRelations()
		if allianceDesRead.checkRank(gAllianceRank.R4) then
			allianceRelationCtrl:reqGetRelationInvites()
		else
			self.dataCount = 1
		end
	else
		self:initData()
	end
end
function AllianceRelationView:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(SoraDCurrentTopPanelFromManager())
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceRelationView" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function AllianceRelationView:dataBack(target, data)
	if data.msg == "MESSAGE_ALLIANCE_RELATION_GET_SUCCESS" then
		self.dataCount = self.dataCount + 1
	elseif data.msg == "MESSAGE_ALLIANCE_RELATION_INVITES_GET_SUCCESS" then
		self.dataCount = self.dataCount + 1
	end
	if self.dataCount >= 2 then
		for k, v in pairs(self.tableRelationList) do
			self.tableRelationList[k], _ENV = nil, nil
		end
		local dataSingle = allianceRelationCtrl:getAR().data
		for k, v in pairs(dataSingle.relationMap) do
			table.insert(self.tableRelationList[v.type], v)
		end
		for k, v in pairs(dataSingle.inviteMap) do
			local arr = serviceFunctions.mapConvertArrayAndSort(v, function(p1, p2)
				if p1.t and p2.t then
					return p1.t > p2.t
				end
			end)
			for _, data in ipairs(arr) do
				data.inviteType = k
				data.type = 4
				table.insert(self.tableRelationList[4], data)
			end
		end
	end
	if self.dataCount >= 2 then
		SoraDCloseLoading(self)
		self:initData()
	end
end
function AllianceRelationView:initData()
	self:updateData()
end
function AllianceRelationView:updateData()
	self:initScroll()
	self:updateScrollView()
end
function AllianceRelationView:initScroll()
	_UPVALUE3_, self.tableCurShow = nil, nil
	;(nil)[1] = gAllianceRelationType.ALLY
	;(nil)[2] = gAllianceRelationType.FRIENDLY
	local (nil)[3], tableRelationListKey = gAllianceRelationType.ENEMY, nil
	if allianceDesRead.checkRank(gAllianceRank.R4) then
		table.insert(tableRelationListKey, 4)
	end
	for i, v in ipairs(tableRelationListKey) do
		local relationData = self.tableRelationList[v]
		local single = self.tableSingle[i]
		if relationData then
			if single == nil then
				single = SoraDCreatePanel("allianceRelationListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				table.insert(self.tableSingle, single)
			end
			single:initData(tonumber(v), relationData, self.tableSpare)
			single:setState(self.tableAllianceRelationListState[tonumber(v)])
			if self.tableAllianceRelationListState[tonumber(v)] then
				self.tableCurShow = i
			end
		elseif single ~= nil then
			single:removeMember()
			single:removeFromParent()
			table.remove(self.tableSingle, i)
		end
	end
	if tableRelationListKey[4] and self.tableAllianceRelationListState[4] then
		self.btnIgnoreAll:setVisible(true)
		local enable = self.tableRelationList[4] and #self.tableRelationList[4] > 0
		self.btnIgnoreAll:setEnabled(enable)
		self.btnIgnoreAll:setBright(enable)
		self.scroll:setContentSize(cc.size(640, display.height - 170))
	end
end
function AllianceRelationView:updateScrollView(buildClass, state)
	if buildClass ~= nil and state ~= nil then
		if self.btnIgnoreAll:isVisible() and (buildClass ~= 4 and state or not state) then
			self.btnIgnoreAll:setVisible(false)
			self.scroll:setContentSize(cc.size(640, display.height - 100))
		elseif not self.btnIgnoreAll:isVisible() and buildClass == 4 and state then
			self.btnIgnoreAll:setVisible(true)
			local enable = self.tableRelationList[4] and #self.tableRelationList[4] > 0
			self.btnIgnoreAll:setEnabled(enable)
			self.btnIgnoreAll:setBright(enable)
			self.scroll:setContentSize(cc.size(640, display.height - 170))
		end
		for k, v in pairs(self.tableAllianceRelationListState) do
			self.tableAllianceRelationListState[k] = false
		end
		self.tableAllianceRelationListState[tonumber(buildClass)] = state
		if self.tableCurShow then
			self.tableSingle[self.tableCurShow]:setState(false)
			self.tableCurShow = nil
		end
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	local openY
	for i = 1, #self.tableSingle do
		local index = #self.tableSingle - i + 1
		local single = self.tableSingle[index]
		scrollInnerNewH = scrollInnerNewH + single:getSingleH()
		single:setPosition(cc.p(320, scrollInnerNewH))
		if single:getLaunched() then
			self.tableCurShow = index
			openY = single:getPositionY()
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			v:setPositionY(v:getPositionY() + upto)
			if i == self.tableCurShow then
				openY = v:getPositionY()
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	if openY then
		openY = self.scroll:getContentSize().height - openY
		offsetY = math.min(offsetY, openY)
	end
	offsetY = math.max(offsetY, -(scrollInnerNewH - self.scroll:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function AllianceRelationView:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function AllianceRelationView:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
function AllianceRelationView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnHelp then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceRelationApplyView")
			else
				local panel = SoraDCreatePanel("allianceRelationApplyView")
				panel:initData()
				panel:show()
			end
		elseif self.btnIgnoreAll == button and allianceDesRead.checkRank(gAllianceRank.R4, true) then
			allianceRelationCtrl:reqRejectAllyAllianceInvite()
		end
	end
end
return AllianceRelationView
