local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceDesRead = include("allianceDesRead")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local AllianceGroupMatchView = class("allianceGroupMatchView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceGroupMatchView")
	end
	return target
end)
function AllianceGroupMatchView:ctor()
	self.matchInfoList, _ENV = nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeTitle:setTitleName(i18n("pyramid_btn_04"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK", handler(self, self.initData))
	pyramidWarCtrl:regularSeasonGetMatchAllianceInfoReq()
end
function AllianceGroupMatchView:initData(target, data)
	if data and data.info and data.info then
		local legiondata = pyramidWarCtrl:getLegionInfoList()
		self.matchInfoList, pyramidWarCtrl = pyramidWarCtrl, pyramidWarCtrl
		for i, v in ipairs(legiondata) do
			if v.number > 0 then
				if data.info[tostring(v.legionId)] then
					v.camp = data.info[tostring(v.legionId)].camp == "1" and "2" or "1"
				end
				pyramidWarCtrl = v.legionId
				v.legionId.selfinfo = v
				v.legionId.otherinfo = data.info[tostring(v.legionId)]
				table.insert(self.matchInfoList, v.legionId)
			end
		end
		self:updateScroll()
	end
end
function AllianceGroupMatchView:updateScroll()
	self.scroll:updateScrollView(cc.size(550, 205), self.matchInfoList, 1)
	self.scroll:jumpToTop()
end
function AllianceGroupMatchView:createSingle()
	local single = self.nodeClone:clone()
	single.imgSingleBg = SoraDGetChildByName(single, "Image_singleBg")
	single.imgVs = SoraDGetChildByName(single, "Image_vs")
	single.labelTime = SoraDGetChildByName(single, "Text_time")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.labelEmpty = SoraDGetChildByName(single, "Text_empty")
	single.nodeSelf = SoraDGetChildByName(single, "Node_right")
	single.nodeOther = SoraDGetChildByName(single, "Node_left")
	single.labelEmpty:setString(i18n("pyramid_text_104"))
	return single
end
function AllianceGroupMatchView:refreshSingle(single, data, otherData)
	single.labelTime:setString(pyramidWarltCtrl.getWeedTimeStrByData(data.selfinfo, "\n"))
	if data.selfinfo.pinnacleCompetitionGroup and data.selfinfo.pinnacleCompetitionGroup > 0 then
		single.labelName:setString(pyramidWarltCtrl.getGroupName(data.selfinfo.pinnacleCompetitionGroup))
	elseif data.selfinfo.pinnacleArea and 0 < data.selfinfo.pinnacleArea then
		single.labelName:setString(pyramidWarltCtrl.getGroupName(data.selfinfo.pinnacleBreakoutGroup))
	else
		single.labelName:setString(i18n("pyramid_btn_15"))
	end
	self:updateSmallNode(single.nodeSelf, data.selfinfo, true)
	if data.otherinfo then
		self:updateSmallNode(single.nodeOther, data.otherinfo)
		single.nodeOther:setVisible(true)
		single.labelEmpty:setVisible(false)
		single.imgSingleBg:setVisible(true)
		single.imgVs:setVisible(true)
		single.labelTime:setVisible(true)
		single.labelName:setVisible(true)
	else
		single.nodeOther:setVisible(false)
		single.labelEmpty:setVisible(true)
		single.imgSingleBg:setVisible(false)
		single.imgVs:setVisible(false)
		single.labelTime:setVisible(false)
		single.labelName:setVisible(false)
	end
end
function AllianceGroupMatchView:updateSmallNode(node, data, isSelf)
	local color = isSelf and display.COLOR_WHITE or cc.c3b(215, 195, 155)
	local name = ""
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if isSelf then
		local ownAlliance = allianceMgr:getAlliance(data.aid)
		_ENV = nil
		;(nil).abbr = ownAlliance:getProperty("abbr") or i18n("common_text_480")
		;(nil).name = data.legionName or i18n("common_text_480")
		name = i18n("common_text_186", nil) .. " #" .. gametop.playertop_:getKingdomID()
		_ENV = "common_text_480"
		;("common_text_480").cur = table.nums(data.memberList)
		;("common_text_480").max = ALLIANCE_GROUP_MEMBER_MAX
		node:getChildByName("Text_groupRank"):setString(i18n("common_text_3408", "common_text_480"))
	else
		_ENV = node:getChildByName("Text_groupRank")
		node:getChildByName("Text_groupRank").abbr = data.abbr or i18n("common_text_480")
		node:getChildByName("Text_groupRank").name = data.legionName or i18n("common_text_480")
		name = i18n("common_text_186", (node:getChildByName("Text_groupRank"))) .. " #" .. data.kid
		_ENV = "common_text_480"
		;("common_text_480").cur = data.curmem
		;("common_text_480").max = ALLIANCE_GROUP_MEMBER_MAX
		node:getChildByName("Text_groupRank"):setString(i18n("common_text_3408", "common_text_480"))
	end
	node:getChildByName("Text_groupName"):setString(name)
	local flag = node:getChildByName("Node_flag")
	flag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(data.flag, flag)
	node:getChildByName("Text_groupName"):setColor(color)
	node:getChildByName("Text_groupRank"):setColor(color)
	node:getChildByName("Sprite_groupState"):setSpriteFrame(data.camp == "1" and "icon_battlefield_south.png" or "icon_battlefield_north.png")
end
return AllianceGroupMatchView
