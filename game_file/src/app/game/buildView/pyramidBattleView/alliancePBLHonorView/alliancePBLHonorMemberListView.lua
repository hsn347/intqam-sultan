local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorMemberListView = class("alliancePBLHonorMemberListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLHonorMemberListView")
	end
	return target
end)
function alliancePBLHonorMemberListView:ctor()
	CenterNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.node21 = SoraDGetChildByName(self, "Node_21")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.nodeBg:setTitleName(i18n("pyramid_title_15"))
	self.labelTitle1:setString(i18n("pyramid_title_15"))
	self.labelTitle2:setString(i18n("common_text_090"))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_MEMBER_BACK", handler(self, self.updateView))
end
function alliancePBLHonorMemberListView:createSingle()
	local single = self.nodeClone:clone()
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.labelPower = SoraDGetChildByName(single, "Text_power")
	single.nodeHead = SoraDGetExtendChildFromCCSByName(single, "CCS_commonHead_head")
	single.nodeHead:setTouchEnabled(true)
	single.nodeHead:setSwallowTouches(false)
	single.nodeHead:setScroll(self.scroll)
	return single
end
function alliancePBLHonorMemberListView:refreshSingle(single, data, otherData)
	single.labelName:setString(data.nickName)
	single.labelPower:setString(string.formatnumberthousands(data.power))
	single.nodeHead:setHeadSprite(data.iconID, data.avatar)
	single.nodeHead:setPlayerID(data.uid)
end
function alliancePBLHonorMemberListView:initData(season, legionId, kid)
	self.legionId = legionId
	self.season = season
	self.kid = kid
	self:updateView()
end
function alliancePBLHonorMemberListView:updateView()
	self.curData = pyramidWarCtrl:getPBLHistoryGroupMemberSum(self.season)
	if self.curData and self.curData[self.legionId] then
		self.curData = self.curData[self.legionId]
		self.scroll:updateScrollView(cc.size(530, 70), self.curData)
		SoraDCloseLoading(self)
	else
		pyramidWarCtrl:queryGrloryLegionMemberSumReq(self.kid, self.legionId, self.season)
		SoraDShowLoading(self)
	end
end
return alliancePBLHonorMemberListView
