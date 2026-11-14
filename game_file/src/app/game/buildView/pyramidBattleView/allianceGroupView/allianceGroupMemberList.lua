local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
_ENV = "allianceDesRead"
;("allianceDesRead")[tostring(gAllianceRank.R0)] = true
;("allianceDesRead")[tostring(gAllianceRank.R1)] = true
;("allianceDesRead")[tostring(gAllianceRank.R2)] = true
;("allianceDesRead")[tostring(gAllianceRank.R3)] = true
;("allianceDesRead")[tostring(gAllianceRank.R4)] = true
;("allianceDesRead")[tostring(gAllianceRank.OFFICIAL)] = true
local ("allianceDesRead")[tostring(gAllianceRank.R5)], tableAllianceGroupListState = true, "allianceDesRead"
local AllianceGroupMemberList = class("allianceGroupMemberList", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupMemberList")
	end
	return target
end)
function AllianceGroupMemberList:ctor()
	_ENV = nil
	;(nil).byUID = true
	local data = SoraDConfigGet("Game:AllianceGroup:memberList~table", nil)
	if table.nums(data) > 0 then
		data = {}
	end
	self.curLegionInfo, _ENV, self.legionInfoList, _ENV = table.nums(data), table.nums(data), table.nums(data), table.nums(data)
	self.tableRank, _ENV, self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableSpareListState, _ENV, self.tableSpareList, _ENV, self.tableMemberList, _ENV, self.curTab = table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), table.nums(data), 1
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidBattleHistory")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgBar = SoraDGetChildByName(self, "Image_bar")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	SoraDChangeTextToHtml(self.labelMember)
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelRank = SoraDGetChildByName(self, "Text_rank")
	self.labelShow = SoraDGetChildByName(self, "Text_show")
	self.labelList = SoraDGetChildByName(self, "Text_list")
	self.btnCheck = SoraDGetChildByName(self, "CheckBox_language")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.spriteLDog = SoraDGetChildByName(self, "Sprite_lDog")
	self.spriteRDog = SoraDGetChildByName(self, "Sprite_rDog")
	self.labelBottom = SoraDGetChildByName(self, "Text_bottom")
	self.labelNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.labelShow:setString(i18n("pyramid_btn_08"))
	self.labelList:setString(i18n("pyramid_text_27"))
	self.labelBottom:setString(i18n("pyramid_text_28"))
	self.labelNoRecord:setString(i18n("pyramid_text_29"))
	if self.btnCheck then
		self.btnCheck:addEventListener(handler(self, self.btnCheckClickCallBack))
		self.btnChange:addTouchEventListener(handler(self, self.btnChangeClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_TOTTAL_RANK_BACK", function(target, data)
		if data.data and data.data[tostring(self.curLegionInfo.legionId)] then
			if data.data[tostring(self.curLegionInfo.legionId)] > 0 then
				_ENV = nil
				;(nil).num = data.data[tostring(self.curLegionInfo.legionId)]
				self.labelRank:setString(i18n("pyramid_text_26", nil))
			else
				_ENV = i18n("pyramid_text_26", nil)
				i18n("pyramid_text_26", nil).num = i18n("herobattle_text_05")
				self.labelRank:setString(i18n("pyramid_text_26", i18n("pyramid_text_26", nil)))
			end
			self.tableRank[self.curLegionInfo.legionId] = data.data[tostring(self.curLegionInfo.legionId)]
			SoraDCloseLoading()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateGroupList))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateGroupList))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.updateView))
end
function AllianceGroupMemberList:initData(i, isCheck)
	self.curTab = i
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self:initTab()
	allianceQuery:reqMemberList(allianceMgr.ownaid)
	SoraDShowLoading()
	self.btnCheck:setSelected(isCheck)
end
function AllianceGroupMemberList:updateTab()
	for i = 1, 4 do
		if self.legionInfoList[i] == nil then
			self.nodeTab:setBtnTouchEnabled(i, false)
			self.nodeTab:setOtherSprite(i, "icon_lordskill_lock.png")
		else
			self.nodeTab:setBtnTitleText(i, self.legionInfoList[i].legionName)
			self.nodeTab:setOtherSpriteHiddle(i)
		end
	end
end
function AllianceGroupMemberList:initTab()
	_ENV, _ENV = nil, nil
	;(nil).title = ""
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	_ENV, (nil)[2], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	_ENV, (nil)[3], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	;(nil)[4], (nil).handle = nil, handler(self, self.OnBtnChangeClick)
	local tabData
	for i = 1, 4 do
		if self.legionInfoList[i] then
			tabData[i].title = self.legionInfoList[i].legionName
		end
	end
	_ENV = 1
	;(1).tabNum = 4
	;(1).defaultClick = self.curTab
	;(1).tabsetArray = tabData
	self.nodeTab:initView(1)
	for i = 1, 4 do
		if self.legionInfoList[i] == nil then
			self.nodeTab:setBtnTouchEnabled(i, false)
			self.nodeTab:setOtherSprite(i, "icon_lordskill_lock.png")
		end
	end
end
function AllianceGroupMemberList:OnBtnChangeClick(tag, name)
	self.curTab = tag
	self:updateView()
end
function AllianceGroupMemberList:btnChangeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupCreateView")
		panel:initChangeName(self.curLegionInfo.legionId)
		panel:show()
	end
end
function AllianceGroupMemberList:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		print("selected")
		self:showAllMember(true)
	elseif type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		print("unselected")
		self:showAllMember(false)
	end
end
function AllianceGroupMemberList:showAllMember(isAll)
	self.tableMemberList, allianceMgr = nil, nil
	local no_member = true
	local list = allianceMgr:getMemberList(allianceMgr.ownaid)
	for k, m_list in pairs(list) do
		if 0 < #m_list then
			self.tableMemberList[k], allianceMgr = nil, nil
			for i, v in ipairs(m_list) do
				if v.uinfo.cityLevel >= CASTLE_LV15_LIMITED then
					if isAll then
						table.insert(self.tableMemberList[k], v)
						no_member = false
					elseif self.curLegionInfo.memberList[tostring(v.minfo.uid)] then
						table.insert(self.tableMemberList[k], v)
						no_member = false
					end
				end
			end
		end
	end
	self.labelNoRecord:setVisible(no_member)
	self:initScroll()
	self:updateScrollView()
end
function AllianceGroupMemberList:updateView()
	SoraDShowLoading(self)
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self.curLegionInfo = self.legionInfoList[self.curTab]
	self.tableRank[self.curLegionInfo.legionId] = nil
	self:updateTab()
	self:initGroupInfo()
	self:updateGroupList()
	SoraDCloseLoading(self)
end
function AllianceGroupMemberList:initGroupInfo()
	self.btnChange:setVisible(pyramidWarCtrl:getGroupManagerRank(self.curLegionInfo.legionIndex) >= 1)
	self.labelName:setString(self.curLegionInfo.legionName)
	local cur_num = table.nums(self.curLegionInfo.memberList)
	local numColor = 0 < cur_num and self.labelMember:getColor() or display.COLOR_RED
	pyramidWarCtrl = self.curLegionInfo.legionIndex
	self.curLegionInfo.legionIndex.cur = cur_num
	pyramidWarCtrl, pyramidWarCtrl, self.curLegionInfo.legionIndex.max = nil, ALLIANCE_GROUP_MEMBER_MAX, ALLIANCE_GROUP_MEMBER_MAX
	ALLIANCE_GROUP_MEMBER_MAX.cur, (nil).color = nil, numColor
	local strNum = i18n_html("common_text_3408", self.curLegionInfo.legionIndex, ALLIANCE_GROUP_MEMBER_MAX)
	self.labelMember:setString(strNum)
	pyramidWarCtrl = nil
	;(nil).num = string.formatnumberthousands(self.curLegionInfo.battleFighting)
	self.labelPower:setString(i18n("pyramid_text_25", nil))
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(nil, self.nodeFlag)
	local rank = self.tableRank[self.curLegionInfo.legionId]
	if rank == nil then
		self.labelRank:setString("")
		_ENV = ""
		;("")[1] = self.curLegionInfo.legionId
		pyramidWarCtrl:newQueryLegionlistRankDataReq("")
	elseif 0 < rank then
		pyramidWarCtrl = i18n("pyramid_text_25", nil)
		i18n("pyramid_text_25", nil).num = rank
		self.labelRank:setString(i18n("pyramid_text_26", i18n("pyramid_text_25", nil)))
	else
		pyramidWarCtrl = i18n("pyramid_text_26", i18n("pyramid_text_25", nil))
		i18n("pyramid_text_26", i18n("pyramid_text_25", nil)).num = i18n("herobattle_text_05")
		self.labelRank:setString(i18n("pyramid_text_26", i18n("pyramid_text_26", i18n("pyramid_text_25", nil))))
	end
end
function AllianceGroupMemberList:updateGroupList(target, data)
	self:showAllMember(self.btnCheck:isSelected())
	SoraDCloseLoading()
	if data and data.reload then
		allianceQuery:reqMemberList(allianceMgr.ownaid)
		SoraDShowLoading()
	end
end
function AllianceGroupMemberList:initScroll()
	_UPVALUE6_ = nil
	;(nil)[1] = "5"
	;(nil)[2] = "6"
	;(nil)[3] = "4"
	;(nil)[4] = "3"
	;(nil)[5] = "2"
	local (nil)[6], tableMemberListKey = "1", nil
	dump(tableAllianceGroupListState, "tableAllianceGroupListState")
	for i, v in ipairs(tableMemberListKey) do
		local rankData = self.tableMemberList[v]
		local single = self.tableSingle[i]
		if rankData and 0 < #rankData then
			if single == nil then
				single = SoraDCreatePanel("allianceGroupMemberListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				table.insert(self.tableSingle, single)
			end
			single:initData(tonumber(v), rankData, self.tableSpare, self.curTab)
			single:setState(tableAllianceGroupListState[v])
			single:setVisible(true)
		elseif single ~= nil then
			single:removeMember()
			single:setVisible(false)
		end
	end
end
function AllianceGroupMemberList:updateScrollView(rank, state)
	if rank ~= nil then
		tableAllianceGroupListState[tostring(rank)] = state
		tableAllianceGroupListState = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:AllianceGroup:memberList~table", tableAllianceGroupListState, nil)
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
function AllianceGroupMemberList:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function AllianceGroupMemberList:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
return AllianceGroupMemberList
