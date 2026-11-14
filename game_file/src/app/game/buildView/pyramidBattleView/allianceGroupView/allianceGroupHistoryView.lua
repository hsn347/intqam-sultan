local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceDesRead = include("allianceDesRead")
local AllianceGroupHistoryView = class("allianceGroupHistoryView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupHistoryView")
	end
	return target
end)
function AllianceGroupHistoryView:ctor()
	self.curLegionInfo, _ENV, self.legionInfoList, _ENV = nil, nil, nil, nil
	self.curTab = 1
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.imgBar = SoraDGetChildByName(self, "Image_bar")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidBattleHistory")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.labelEmpty = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.nodeTitle:setTitle(i18n("common_text_3031"))
	self.labelEmpty:setString(i18n("god_beast_text_16"))
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self:initData()
end
function AllianceGroupHistoryView:initData()
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self:initTab()
end
function AllianceGroupHistoryView:initTab()
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
function AllianceGroupHistoryView:updateScroll()
	if not self.legionInfoList[self.curTab] or not self.legionInfoList[self.curTab].regularSeasonRecord then
		local _ENV, data = self.legionInfoList[self.curTab].regularSeasonRecord, self.legionInfoList[self.curTab].regularSeasonRecord
	end
	table.sort(data, function(l, r)
		return l.time > r.time
	end)
	_ENV = nil
	;(nil).customHeight = 304.5 * #data + 60
	self.scroll:updateScrollView(cc.size(640, 304.5), data, 1, nil)
	self.scroll:jumpToTop()
	self.labelEmpty:setVisible(#data <= 0)
end
function AllianceGroupHistoryView:createSingle()
	local ocx = self.nodeClone:clone()
	ocx.imgVs = SoraDGetChildByName(ocx, "Image_vs")
	ocx.labelTime = SoraDGetChildByName(ocx, "Text_time")
	ocx.labelName = SoraDGetChildByName(ocx, "Text_name")
	ocx.labelGroup = SoraDGetChildByName(ocx, "Text_group")
	ocx.imgState = SoraDGetChildByName(ocx, "Image_state")
	ocx.spriteGame = SoraDGetChildByName(ocx, "Sprite_game")
	ocx.nodeSelf = SoraDGetChildByName(ocx, "Node_self")
	ocx.nodeOther = SoraDGetChildByName(ocx, "Node_other")
	return ocx
end
function AllianceGroupHistoryView:refreshSingle(single, data, otherData)
	single.imgState:setVisible(true)
	if data.selfinfo.iswin then
		single.imgState:setPositionX(SoraDFPosX(585, 640))
	elseif data.otherinfo.iswin then
		single.imgState:setPositionX(SoraDFPosX(55, 640))
	else
		single.imgState:setVisible(false)
	end
	dump(data, "refreshSingle", 10)
	local curMatchType = data.matchType
	if data.selfinfo.seasonType and data.selfinfo.seasonType == gSeasonType.PINNACLE_SEASON and data.selfinfo.group then
		_UPVALUE3_ = data.selfinfo.group
		data.selfinfo.group[1] = i18n("pyramid_btn_12")
		data.selfinfo.group[2] = i18n("pyramid_btn_13")
		data.selfinfo.group[3] = i18n("pyramid_btn_14")
		data.selfinfo.group[4] = i18n("pyramid_btn_15")
		local data.selfinfo.group[5], str_group = i18n("pyramid_btn_15")
		single.labelName:setString(str_group[data.selfinfo.group])
	else
		single.labelName:setString(i18n("pyramid_btn_15"))
	end
	if curMatchType and 0 < curMatchType then
		_ENV = single.labelName.setString
		single.labelName.setString[gPinnacleMatchType.GROUP_MATCH] = i18n("pyramid_text_56")
		single.labelName.setString[gPinnacleMatchType.BREAKOUT_MATCH] = i18n("pyramid_btn_27")
		local single.labelName.setString[gPinnacleMatchType.CHAMPION_MATCH], str_match = i18n("pyramid_text_81"), single.labelName.setString
		single.labelGroup:setString(str_match[curMatchType])
		single.labelGroup:setPositionY(205)
		single.labelName:setPositionY(185)
	else
		single.labelName:setPositionY(195)
		single.labelGroup:setPositionY(195)
		single.labelGroup:setString("")
	end
	single.spriteGame:setPositionX(single.labelName:getPositionX() + SoraDFSign(0.5 * single.labelName:getContentSize().width + 2))
	single.labelTime:setString(SoraDConverTimeStr(data.time))
	self:updateSmallNode(single.nodeSelf, data.selfinfo, true)
	self:updateSmallNode(single.nodeOther, data.otherinfo)
end
function AllianceGroupHistoryView:updateSmallNode(node, data, isSelf)
	local color = isSelf and display.COLOR_WHITE or cc.c3b(215, 195, 155)
	_ENV = 155
	;(155).abbr = data.abbr or i18n("common_text_480")
	;(155).name = data.legionName or i18n("common_text_480")
	local name = i18n("common_text_186", 155) .. " #" .. data.kid
	node:getChildByName("Text_groupName"):setString(name)
	_ENV = nil
	;(nil).point = string.formatnumberthousands(data.ascore)
	node:getChildByName("Text_groupRank"):setString(i18n("common_text_3347", nil))
	_ENV = i18n("common_text_3347", nil)
	i18n("common_text_3347", nil).cur = data.memberNum
	i18n("common_text_3347", nil).max = ALLIANCE_GROUP_MEMBER_MAX
	node:getChildByName("Text_groupInt"):setString(i18n("common_text_3408", i18n("common_text_3347", nil)))
	local flag = node:getChildByName("Node_groupFlag")
	flag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(data.flag, flag)
	node:getChildByName("Text_groupName"):setColor(color)
	node:getChildByName("Text_groupRank"):setColor(color)
	node:getChildByName("Text_groupInt"):setColor(color)
end
function AllianceGroupHistoryView:OnBtnChangeClick(tag, name)
	self.curTab = tag
	self:updateScroll()
end
return AllianceGroupHistoryView
