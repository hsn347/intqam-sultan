local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local alliancePBLApplyView = class("alliancePBLApplyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLApplyView")
	end
	return target
end)
function alliancePBLApplyView:ctor()
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.labelRank = SoraDGetChildByName(self, "Text_rank")
	self.btnGroup = SoraDGetChildByName(self, "Button_group")
	self.labelGroup = SoraDGetChildByName(self, "Text_group")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodePBLIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_alliancePBLBigIconNode_pbl")
	self.labelRound1 = SoraDGetChildByName(self, "Text_round_1")
	self.labelRound2 = SoraDGetChildByName(self, "Text_round_2")
	self.labelRound3 = SoraDGetChildByName(self, "Text_round_3")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeSelList = SoraDGetChildByName(self, "Node_SelList")
	self.labelTitle = SoraDGetChildByName(self.nodeSelList, "Text_title")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.btnDraw = SoraDGetChildByName(self, "Button_draw")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btnDraw:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnGroup:addTouchEventListener(handler(self, self.btnGroupClickCallBack))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClickCallBack))
	_ENV = handler(self, self.btnRankClickCallBack)
	handler(self, self.btnRankClickCallBack).num = pyramidWarCtrl.peakSeasonNo
	self.nodeTitle:setTitle(i18n("pyramid_text_47", handler(self, self.btnRankClickCallBack)))
	self.labelRank:setString(i18n("common_text_851"))
	self.labelGroup:setString(i18n("pyramid_btn_03"))
	self.labelRound1:setString(i18n("pyramid_text_109"))
	self.labelRound2:setString(i18n("pyramid_btn_26"))
	self.labelRound3:setString(i18n("pyramid_text_81"))
	self.labelDes:setString(i18n("pyramid_text_51"))
	_ENV = i18n("pyramid_text_51")
	i18n("pyramid_text_51").time = ""
	self.labelTitle:setString(i18n("pyramid_text_48", i18n("pyramid_text_51")))
	self.btnDraw:setTitleText(i18n("common_text_3315"))
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	local legionList = pyramidWarCtrl:getLegionInfoList()
	if not allianceMgr:hasJoinAlliance() or legionList == nil or #legionList == 0 then
		self.btnGroup:setTouchEnabled(false)
	end
	self:updateView()
	if display.height < 1160 then
		local scale = (display.height - 205 - 115) / 840
		self.centerNode:setScale(scale)
		self.centerNode:setPositionY(scale * 280 + 205)
	elseif self.centerNode:getPositionY() < 485 then
		self.centerNode:setPositionY(485)
	end
	SoraDCreatAnimationEx(self.__cname, self, true)
end
function alliancePBLApplyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.updateView))
end
function alliancePBLApplyView:updateView()
	print("pyramidWarCtrl.pinnacleSeasonState", pyramidWarCtrl.pinnacleSeasonState)
	self.seasonState = pyramidWarCtrl.pinnacleSeasonState
	if self.seasonState == gPinnacleSeasonState.WAIT_OPEN then
		_ENV = nil
		;(nil).time = ""
		self.labelTitle:setString(i18n("common_text_3307", nil))
		self.btnDraw:setTouchEnabled(false)
		self.btnDraw:setTitleText(i18n("common_text_3315"))
	elseif self.seasonState == gPinnacleSeasonState.GROUP_LIST_WILL_SHOW or self.seasonState == gPinnacleSeasonState.GROUP_LIST_WAITING or self.seasonState == gPinnacleSeasonState.WAIT_APPLY_NEXT then
		self.labelTitle:setString(i18n("pyramid_text_50"))
		self.btnDraw:setTouchEnabled(false)
		self.btnDraw:setTitleText(i18n("pyramid_text_18"))
	elseif self.seasonState == gPinnacleSeasonState.APPLY_ING_A then
		_ENV = i18n("pyramid_text_18")
		i18n("pyramid_text_18").time = ""
		self.labelTitle:setString(i18n("pyramid_text_48", i18n("pyramid_text_18")))
		self.btnDraw:setTouchEnabled(true)
		self.btnDraw:setTitleText(i18n("common_text_3315"))
	else
		self:removeFromParent()
	end
end
function alliancePBLApplyView:openTimeUp()
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(pyramidWarCtrl.pinnacleSeasonState)
	if nowTimeLeft and 0 <= nowTimeLeft then
		self.labelTime:setString(SoraDConvertSecondToString(nowTimeLeft))
	else
	end
end
function alliancePBLApplyView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function alliancePBLApplyView:btnGroupClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupManagerView")
		panel:show()
	end
end
function alliancePBLApplyView:btnRankClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceGroupRankView"):show()
	end
end
function alliancePBLApplyView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if pyramidWarCtrl:getGroupManagerRank() >= 1 then
			local panel = SoraDCreatePanel("allianceGroupManagerView")
			panel:initApply()
			panel:show()
		else
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
		end
	end
end
return alliancePBLApplyView
