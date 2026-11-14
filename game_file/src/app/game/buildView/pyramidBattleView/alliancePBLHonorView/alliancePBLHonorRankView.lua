local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorRankView = class("alliancePBLHonorRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLHonorRankView")
	end
	return target
end)
function alliancePBLHonorRankView:ctor()
	self.getData, _ENV = nil, nil
	self.curTab = gGloryRankTypeDef.POWER_TOP_4_LEGION
	self.imgBg = SoraDGetChildByName(self, "Image_bigBg")
	self.imgBg:setScale(math.max(1, display.height / self.imgBg:getContentSize().height))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.labelEmpty = SoraDGetChildByName(self, "Center_Text_empty")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	self.nodeTitle:setTitle(i18n("pyramid_title_13"))
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.labelEmpty:setString(i18n("herobattle_text_05"))
end
function alliancePBLHonorRankView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_BACK", handler(self, self.updateView))
end
function alliancePBLHonorRankView:btnFlagCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.scroll and self.isMoved then
			self.isMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorGroupInfoView")
		panel:initData(self.curData[button:getTag()], self.curData[button:getTag()].pinnacleRank, self.curSeason, self.curTab, button:getTag())
		panel:show()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.isMoved = false
	end
end
function alliancePBLHonorRankView:createSingle()
	local single = self.nodeClone:clone()
	single.btnFlag = SoraDGetChildByName(single, "Button_flag")
	single.btnFlag:setSwallowTouches(false)
	single.btnFlag:addTouchEventListener(handler(self, self.btnFlagCallBack))
	single.nodeFlag = SoraDGetChildByName(single, "Node_flag")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.labelDes = SoraDGetChildByName(single, "Text_des")
	SoraDChangeTextToHtml(single.labelDes)
	return single
end
function alliancePBLHonorRankView:refreshSingle(single, data, otherData)
	single.btnFlag:setTag(single:getTag())
	allianceDesRead.getFlagWithParticle(data.flag, single.nodeFlag)
	allianceDesRead = single:getTag()
	single:getTag().abbr = data.abbr
	single:getTag().name = data.legionName
	single.labelName:setString(i18n("common_text_186", single:getTag()) .. "#" .. data.kid)
	if self.curTab == gGloryRankTypeDef.POWER_TOP_4_LEGION then
		allianceDesRead = data.kid
		data.kid.num = self.curSeason
		data.kid.power = string.formatnumberthousands(data.power)
		allianceDesRead, allianceDesRead, data.kid.rank = single, single:getTag(), single:getTag()
		allianceDesRead, single:getTag().power, single.color = single, single, cc.c3b(0, 255, 0)
		allianceDesRead, single:getTag().rank, single.color = single, single, cc.c3b(255, 255, 0)
		single:getTag().__default, single.color = single, cc.c3b(200, 155, 100)
		single.labelDes:setString(i18n_html("pyramid_text_92", data.kid, (single:getTag())))
	elseif self.curTab == gGloryRankTypeDef.DARK_HORSE_RANK then
		allianceDesRead = i18n_html("pyramid_text_92", data.kid, (single:getTag()))
		i18n_html("pyramid_text_92", data.kid, (single:getTag())).num = self.curSeason
		i18n_html("pyramid_text_92", data.kid, (single:getTag())).power = string.formatnumberthousands(data.power)
		i18n_html("pyramid_text_92", data.kid, (single:getTag())).rank1 = data.joinRank
		allianceDesRead, allianceDesRead, i18n_html("pyramid_text_92", data.kid, (single:getTag())).rank2 = self, self:getRankStr(data.pinnacleRank), self:getRankStr(data.pinnacleRank)
		allianceDesRead, self:getRankStr(data.pinnacleRank).power, self.color = self, self, cc.c3b(0, 255, 0)
		allianceDesRead, self:getRankStr(data.pinnacleRank).rank1, self.color = self, self, cc.c3b(255, 255, 255)
		allianceDesRead, self:getRankStr(data.pinnacleRank).rank2, self.color = self, self, cc.c3b(255, 255, 0)
		self:getRankStr(data.pinnacleRank).__default, self.color = self, cc.c3b(200, 155, 100)
		single.labelDes:setString(i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag()))))
	elseif self.curTab == gGloryRankTypeDef.NEWBIE_LEGION then
		allianceDesRead = i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag())))
		i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag()))).num = self.curSeason
		i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag()))).power = string.formatnumberthousands(data.power)
		allianceDesRead, allianceDesRead, i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag()))).rank = self, self:getRankStr(data.pinnacleRank), self:getRankStr(data.pinnacleRank)
		allianceDesRead, self:getRankStr(data.pinnacleRank).power, self.color = self, self, cc.c3b(0, 255, 0)
		allianceDesRead, self:getRankStr(data.pinnacleRank).rank, self.color = self, self, cc.c3b(255, 255, 0)
		self:getRankStr(data.pinnacleRank).__default, self.color = self, cc.c3b(200, 155, 100)
		single.labelDes:setString(i18n_html("pyramid_text_97", i18n_html("pyramid_text_93", i18n_html("pyramid_text_92", data.kid, (single:getTag())))))
	end
end
function alliancePBLHonorRankView:getRankStr(rank)
	if rank and rank <= 16 then
		if 8 < rank then
			_ENV = nil
			;(nil).num = 16
			return i18n("pyramid_text_96", nil)
		elseif 4 < rank then
			_ENV = nil
			;(nil).num = 8
			return i18n("pyramid_text_96", nil)
		elseif 2 < rank then
			_ENV = nil
			;(nil).num = 4
			return i18n("pyramid_text_96", nil)
		elseif rank == 2 then
			return i18n("pyramid_text_95")
		elseif rank == 1 then
			return i18n("pyramid_text_94")
		end
	else
		return ""
	end
end
function alliancePBLHonorRankView:initTab()
	_ENV = nil
	;(nil).tabNum = 3
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	;(nil).title = i18n("pyramid_btn_37")
	;(nil).tag = gGloryRankTypeDef.POWER_TOP_4_LEGION
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = i18n("pyramid_btn_38")
	;(nil).tag = gGloryRankTypeDef.DARK_HORSE_RANK
	_ENV, (nil)[2], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = i18n("pyramid_btn_39")
	;(nil).tag = gGloryRankTypeDef.NEWBIE_LEGION
	;(nil).tabsetArray, (nil)[3], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	self.nodeTab:initView(nil)
end
function alliancePBLHonorRankView:OnBtnChangeClick(tag)
	self.curTab = tag
	self:updateView()
end
function alliancePBLHonorRankView:initData(season)
	self.curSeason = season
	self:initTab()
end
function alliancePBLHonorRankView:updateView()
	self.curData = pyramidWarCtrl:getPBLHistoryRank(self.curTab, self.curSeason)
	if self.curData and next(self.curData) then
		self.scroll:updateScrollView(cc.size(640, 160), self.curData)
		SoraDCloseLoading(self)
		self.labelEmpty:setVisible(false)
	elseif self.getData[self.curTab] == nil then
		self.getData[self.curTab] = true
		SoraDShowLoading(self)
		pyramidWarCtrl:newGloryRankReq(self.curTab, self.curSeason)
	else
		SoraDCloseLoading(self)
		self.labelEmpty:setVisible(true)
		pyramidWarCtrl = 640
		self.scroll:updateScrollView(cc.size(640, 160), 640)
	end
end
return alliancePBLHonorRankView
