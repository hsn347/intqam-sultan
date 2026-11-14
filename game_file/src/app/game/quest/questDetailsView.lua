local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local QuestDetailsView = class("questDetailsView", function()
	return SoraDCreateTouchPanel("questDetailsView")
end)
function QuestDetailsView:ctor()
	self.questPoint = nil
	self.isRecommend = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_02"))
	self.btnGetPrize = SoraDGetChildByName(self, "Button_get")
	self.btnGetPrize:setTitleText(i18n("common_text_677"))
	if self.btnGetPrize then
		self.btnGetPrize:addTouchEventListener(handler(self, self.OnselfBtnGetPrizeClick))
	end
	self.lab_target = SoraDGetChildByName(self, "Text_target")
	self.lab_details = SoraDGetChildByName(self, "Text_detail")
	self.lab_getPrize = SoraDGetChildByName(self, "Text_prize")
	self.lab_getPrize:setString(i18n("common_text_4458"))
	self.labelErr = SoraDGetChildByName(self, "Text_err")
	self.labelErr:setVisible(false)
	self.node_progressBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_bar")
	self.node_targetIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_questTargetIcon_icon")
	self.node_scroll = SoraDGetChildByName(self, "ScrollView_details")
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE", handler(self, self.updateData))
end
function QuestDetailsView:updateData(target, data)
	if self.questPoint == nil then
		SoraDCloseLoading(self)
		self:removeFromParent()
	elseif data.questType == questltCtrl:getQuestType(self.questPoint:getQuestID()) then
		SoraDCloseLoading(self)
		if data.msg == "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE" then
			self:initView()
		end
	end
end
function QuestDetailsView:initData(questSingleData, isRecommend)
	self.questPoint = questSingleData
	self.isRecommend = isRecommend
	if self.questPoint == nil then
		self:removeFromParent()
	end
	self:initView()
	self:addScrollView()
end
function QuestDetailsView:initView()
	local questDesRead = include("questDesRead")
	local qid = self.questPoint:getQuestID()
	local questType = questltCtrl:getQuestType(qid)
	self.lab_target:setString(questDesRead.getName(qid))
	self.lab_details:setString(questDesRead.getDes(qid))
	_ENV = questDesRead.getDes(qid)
	questDesRead.getDes(qid).IconTarget = questDesRead.getIcon(qid)
	questDesRead.getDes(qid).IconState = questDesRead.getTypeIcon(qid)
	self.node_targetIcon:setTargetIconDate(questDesRead.getDes(qid))
	if self.questPoint:isLock() then
		self.labelErr:setVisible(true)
		self.node_progressBar:setVisible(false)
		local isWarLv, showLv = SoraDGetBuildWarLv(questltCtrl:getCastleLevel(qid))
		if isWarLv then
			_ENV = questltCtrl:getCastleLevel(qid)
			questltCtrl:getCastleLevel(qid).lv = showLv
			if i18n("common_text_1948", questltCtrl:getCastleLevel(qid)) then
				goto lbl_69
			end
		end
		local lvStr = math.min(showLv, _G.CASTLE_MAXLV_NOWAR)
		::lbl_69::
		_ENV = questltCtrl:getCastleLevel(qid)
		questltCtrl:getCastleLevel(qid).lv = lvStr
		self.labelErr:setString(i18n("common_text_2844", questltCtrl:getCastleLevel(qid)))
	else
		_ENV = math.min(showLv, _G.CASTLE_MAXLV_NOWAR)
		math.min(showLv, _G.CASTLE_MAXLV_NOWAR).maxValue = self.questPoint:getAim()
		math.min(showLv, _G.CASTLE_MAXLV_NOWAR).curValue = self.questPoint:getProgress()
		self.node_progressBar:setProgressDate((math.min(showLv, _G.CASTLE_MAXLV_NOWAR)))
	end
	if self.questPoint:canCommit() then
		self.btnGetPrize:setTitleText(i18n("common_text_677"))
		btnName = "btn_green_normal_01.png"
	else
		self.btnGetPrize:setTitleText(i18n("common_text_678"))
		btnName = "btn_blue_normal_01.png"
	end
	if not self.questPoint:canCommit() and (questType == 27 or questType == 28 or questType == 31 or questType == 37) then
		self.btnGetPrize:setTitleText(i18n("common_text_677"))
		btnName = "btn_green_normal_01.png"
		self.btnGetPrize:setTouchEnabled(false)
		self.btnGetPrize:setBright(false)
	else
		self.btnGetPrize:setTouchEnabled(true)
		self.btnGetPrize:setBright(true)
	end
	self.btnGetPrize:loadTextures(btnName, "", "", ccui.TextureResType.plistType)
end
function QuestDetailsView:addScrollView()
	local questPrize = questltCtrl:getReward(self.questPoint:getQuestID())
	if self.node_scroll then
		self.node_scroll:removeAllChildren()
		local scrollH = math.max(#questPrize * 90, self.node_scroll:getContentSize().height)
		self.node_scroll:setInnerContainerSize(cc.size(550, scrollH))
		for k, v in ipairs(questPrize) do
			local panel = SoraDCreatePanel("questDetailsSingleView")
			panel:setPosition(cc.p(275.0, scrollH - (k - 1) * 90))
			panel:initDate(v, k)
			panel:addTo(self.node_scroll, k)
		end
	end
end
function QuestDetailsView:OnselfBtnGetPrizeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("normalcontrol", 4)
		if self.questPoint:canCommit() then
			SoraDShowLoading(SoraDSearchPanelFromManagerByName("questView"))
			local gametop = gModuleMgr.getObject("gametop")
			local questCtrl = gametop.playertop_:getModule("questCtrl")
			button:setTouchEnabled(false)
			button:setBright(false)
			questCtrl:reqCommitQuest(self.questPoint:getQuestID())
			self:removeFromParent()
		else
			questltCtrl:jumpToFinishedById(self.questPoint:getQuestID())
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return QuestDetailsView
