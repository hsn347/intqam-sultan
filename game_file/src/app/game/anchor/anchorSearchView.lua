local gametop = gModuleMgr.getObject("gametop")
local anchorCtrl = gametop.playertop_:getModule("anchorCtrl")
local anchorSearchView = class("anchorSearchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anchorSearchView")
	end
	return target
end)
_UPVALUE3_ = "anchorSearchView"
_ENV, ("anchorSearchView")[1] = 6, 6
_ENV, ("anchorSearchView")[2] = 6, 8
local _ENV, ("anchorSearchView")[3], SEGMENT_LIST = 6, 7, "anchorSearchView"
;(6).TEAM_VIEW_TYPE_NAME = 1
local (6).TEAM_VIEW_TYPE_SEGMENT, TEAM_VIEW_TYPE = 2, 6
function anchorSearchView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("Anchor_btn_06"))
	self.nodeNotice = SoraDGetChildByName(self, "Center_node_tips")
	self.nodeNotice:setVisible(false)
	_ENV, self.labelNotice = SoraDGetChildByName(self, "Text_notice"), SoraDGetChildByName(self, "Text_notice")
	_ENV = "Text_notice"
	;("Text_notice").title = "CheckBox_Name"
	;("Text_notice").lableTitle = "Text_Name"
	SoraDGetChildByName(self, "Text_notice")[TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_NAME], ("Text_notice").titleText = "Text_notice", "Anchor_btn_08"
	_ENV = "Text_notice"
	;("Text_notice").title = "CheckBox_Search_Segment"
	;("Text_notice").lableTitle = "Text_Search_Segment"
	SoraDGetChildByName(self, "Text_notice")[TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEGMENT], ("Text_notice").titleText = "Text_notice", "Anchor_btn_07"
	local tableData = SoraDGetChildByName(self, "Text_notice")
	for i, v in ipairs(tableData) do
		local checkBox = SoraDGetChildByName(self, v.title)
		checkBox:setTag(i)
		checkBox:ignoreContentAdaptWithSize(true)
		checkBox:addTouchEventListener(handler(self, self.OnBtnChangeClick))
		v.checkBox = checkBox
		local lableTitle = SoraDGetChildByName(self, v.lableTitle)
		lableTitle:setString(i18n(v.titleText))
	end
	self.fieldText_name = SoraDGetChildByName(self, "TextField_search_name")
	_ENV = "TextField_search_name"
	;("TextField_search_name").func = handler(self, self.OnInputChangeByEditBoxEnd)
	self.fieldText_name = _G.SoraDChangeToEditBox(self.fieldText_name, "TextField_search_name")
	self.nodeName = SoraDGetChildByName(self, "Top_Node_name")
	self.nodeSegment = SoraDGetChildByName(self, "Top_Node_segment")
	self.btnName = SoraDGetChildByName(self, "Button_Search_name")
	self.btnName:addTouchEventListener(handler(self, self.btnNameClick))
	self.btnSegment = SoraDGetChildByName(self, "Button_Search_segment")
	self.btnSegment:addTouchEventListener(handler(self, self.btnSegmentClick))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_approval")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setScrollBottomFun(handler(self, self.scrollEventCallBack))
	self.scroll:setSingleCCS("anchorSearchSingle")
	self.tableData = tableData
	self.showViewType = nil
	self.btnRefreshStatus = nil
	self.segment = 1
	self.showList, _ENV, self.totalRoom = self.scroll.setSingleCCS, self.scroll.setSingleCCS, 0
	self:initShowBtn(TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEGMENT)
	self:initSegment()
end
function anchorSearchView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_ANCHOR_ROOMS", handler(self, self.initData))
end
function anchorSearchView:initSegment()
	self.tableSegment = SoraDGetChildsArrayByName(self, "Node_Segment_", 3, 5)
	local remainsWarRead = include("remainsWarRead")
	for i, v in ipairs(self.tableSegment) do
		local tag = SEGMENT_LIST[i]
		v:setTag(tag)
		local checkBox = SoraDGetChildByName(v, "CheckBox_segment")
		checkBox:addEventListener(handler(self, self.btnCheckClickCallBack))
		checkBox:ignoreContentAdaptWithSize(true)
		checkBox:setTag(tag)
		local labelSegment = SoraDGetChildByName(v, "Text_segment")
		local strTitle = remainsWarRead.getDanName(tag)
		labelSegment:setString(strTitle)
	end
	self:selectSegment(self.tableSegment[#self.tableSegment]:getTag())
end
function anchorSearchView:initData(target, data)
	SoraDCloseLoading(self)
	if data.err and data.err == gErrDef.Err_None then
		self.totalRoom = data.count or 0
		if not data.roomList then
			_ENV = data.roomList
		end
		self:updateListMember(data.roomList)
	end
end
function anchorSearchView:resetUI()
	self.scroll:setVisible(false)
	self.scroll:jumpToTop()
	self.nodeNotice:setVisible(false)
	self:setBtnRefresh(false, true)
end
function anchorSearchView:req4Data()
	local TEAM_VIEW_TYPE, data
	local TEAM_VIEW_TYPE, cond
	data.idx = #self.showList + 1
	data.count = 10
	data.cond = cond
	if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_NAME then
		local name = self.fieldText_name:getText()
		cond.nickname = name
	elseif self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEGMENT then
		cond.segment = self.segment or 1
	end
	anchorCtrl:reqAnchorRooms(data)
	SoraDShowLoading(self)
end
function anchorSearchView:scrollEventCallBack(target, event)
	if self.totalRoom > #self.showList then
		self:req4Data()
	end
end
function anchorSearchView:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		local btn = v.checkBox
		btn:setTouchEnabled(not show)
		btn:setSelected(show)
		if show then
			self:selectPanel(self.showViewType)
		end
	end
end
function anchorSearchView:selectPanel(showViewType)
	if showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_NAME then
		self.nodeSegment:setVisible(false)
		self.nodeName:setVisible(true)
	elseif showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEGMENT then
		self.nodeSegment:setVisible(true)
		self.nodeName:setVisible(false)
	end
	self:resetUI()
end
function anchorSearchView:beginSearch()
	self.showList, _UPVALUE0_ = nil, nil
	self:req4Data()
	self:setBtnRefresh(true)
end
function anchorSearchView:updateListMember(showList)
	dump(showList, "showList", 10)
	if showList then
		for _, v in ipairs(showList) do
			self.showList[#self.showList + 1] = v
		end
	end
	if not next(self.showList) then
		self.nodeNotice:setVisible(true)
		if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_NAME then
			self.labelNotice:setString(i18n("Anchor_text_09"))
		else
			self.labelNotice:setString(i18n("Anchor_text_06"))
		end
		self.scroll:setVisible(false)
		self:setBtnRefresh(false)
	else
		self.nodeNotice:setVisible(false)
		self.scroll:setVisible(true)
		_ENV = i18n("Anchor_text_06")
		i18n("Anchor_text_06").scroll = self.scroll
		i18n("Anchor_text_06").mainView = self
		self.scroll:updateScrollView(cc.size(640, 245), self.showList, 1, i18n("Anchor_text_06"))
	end
end
function anchorSearchView:OnBtnChangeClick(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
local namkVailidCheck = function(nickName)
	local __err
	if nickName then
		if string.utf8len(nickName) > 15 then
			__err = gErrDef.Err_NICKNAME
		elseif string.utf8len(nickName) < 1 then
			__err = gErrDef.Err_NICKNAME_MIN_SIZE
		elseif string.sub(nickName, 1, 1) == "(" then
			__err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(nickName, "$SoarDragon&") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "[%%%*%^%$%[%]%*%+%-%?#&]+") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\n") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, "\r") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif string.match(nickName, " ") then
			__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		else
			__err = gErrDef.Err_None
		end
	else
		__err = gErrDef.Err_NICKNAME
	end
	return __err
end
function anchorSearchView:btnNameClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local name = self.fieldText_name:getText()
		if string.utf8len(name) < 3 then
			SoraDShowMsgTip(i18n("common_text_365"))
			self:resetUI()
			return
		elseif namkVailidCheck(name) ~= gErrDef.Err_None then
			SoraDShowMsgTip(i18n("notice_0071"))
			self:resetUI()
			return
		end
		self:beginSearch()
	end
end
function anchorSearchView:btnSegmentClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:beginSearch()
	end
end
function anchorSearchView:setBtnRefresh(refresh, force)
	if not force and refresh == self.btnRefreshStatus then
		return
	end
	self.btnRefreshStatus = refresh
	if self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_NAME then
		if self.btnRefreshStatus then
			self.btnName:setTitleText(i18n("common_text_911"))
		else
			self.btnName:setTitleText(i18n("common_text_166"))
		end
	elseif self.showViewType == TEAM_VIEW_TYPE.TEAM_VIEW_TYPE_SEGMENT then
		if self.btnRefreshStatus then
			self.btnSegment:setTitleText(i18n("common_text_911"))
		else
			self.btnSegment:setTitleText(i18n("common_text_166"))
		end
	end
end
function anchorSearchView:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected or type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		local tag = button:getTag()
		self:selectSegment(tag)
	end
end
function anchorSearchView:selectSegment(index)
	self.segment = index
	for i, v in ipairs(self.tableSegment) do
		local tag = v:getTag()
		local checkBox = SoraDGetChildByName(v, "CheckBox_segment")
		checkBox:setSelected(tag == index)
	end
	self:setBtnRefresh(false)
end
function anchorSearchView:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "changed" then
		self:setBtnRefresh(false)
	end
end
function anchorSearchView:testAddData()
	local base = #self.showList
	local _ENV, list
	for i = 1, 10 do
		_ENV = nil
		;(nil).isAccurateSearch = true
		_ENV, (nil).mapId = 10000 + i + base, 10000 + i + base
		;(10000 + i + base)["1"] = (base + i) * 100
		_ENV, _ENV, (nil).pointsData, (10000 + i + base)["2"] = (base + i) * 10, 10000 + i + base, 10000 + i + base, (base + i) * 10
		_ENV, (base + i) * 10.camp = nil, 1
		;(nil).allianceAbb = "z1z"
		;(nil).fromKid = 1
		;(nil).nickName = "zw1"
		;(base + i) * 10.leader, (nil).uid = nil, 1
		_ENV, (10000 + i + base)["1"], (base + i) * 10.teamId = (base + i) * 10, (base + i) * 10, 4
		_ENV, (base + i) * 10.camp = nil, 2
		;(nil).allianceAbb = "222"
		;(nil).fromKid = 1
		;(nil).nickName = "zw10"
		;(base + i) * 10.leader, (nil).uid = nil, 10
		;(nil).warCampData, (10000 + i + base)["2"], (base + i) * 10.teamId = 10000 + i + base, (base + i) * 10, 3
		;(nil).warStartTime = serviceFunctions.systemTime()
		;(nil).warStatus = 2
		;(nil).warTotalTime = 1020
		table.insert(list, nil)
	end
	self:updateListMember(list)
end
return anchorSearchView
