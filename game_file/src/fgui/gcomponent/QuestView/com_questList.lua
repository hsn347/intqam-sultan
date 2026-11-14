local questCtrl = SoraDGetCtrl("questCtrl")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questDesRead = include("questDesRead")
local itemDesRead = include("itemDesRead")
local resDesRead = include("resDesRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local com_questList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://QuestView/com_questList", com_questList)
function com_questList:onInit()
	self.table_quest = nil
	self.isRecommend = false
	self.prizeID = gIDDef.GOLD
	self.fields.Button_touch:addClickListener(handler(self, self.OnLayerClick))
	self.fields.Button_getPrize:setTitleText(i18n("common_text_677"))
	self.fields.Button_getPrize:addClickListener(handler(self, self.OnBtnGetPrizeClick))
	self.fields.Button_getPrize:setTouchEnabled(false)
	self.fields.Button_getPrize:setBright(false)
	self.fields.List_res:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Bar:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.bar_title:fixPos()
	self.fields.Text_err:fixPos()
	self.fields.Text_targetTitle:fixPos()
end
function com_questList:onItemRenderer(index, obj)
	local data = self.resArray[index + 1]
	obj:setIcon(SoraDJudgeResOrItem(data.id) and itemDesRead.getIcon(data.id) or resDesRead.getIcon(data.id))
	obj:setString(data.count)
end
function com_questList:onShow()
end
function com_questList:initData(questStyle, isRecommend)
	self.isRecommend = isRecommend
	self.table_quest = questStyle
	self.fields.Image_frame:setVisible(not self.isRecommend)
	if self.table_quest then
		local qid
		if self.table_quest.isNewPlayer then
			self.controllers.c1:setSelectedIndex(1)
			local newPlayerTaskRead = include("newPlayerTaskRead")
			_ENV = nil
			;(nil).name = newPlayerTaskRead.getTitleByCID(self.table_quest.isNewPlayer)
			;(nil).msg = newPlayerTaskRead.getNameByCID(self.table_quest.isNewPlayer)
			local newPlayerTitle = i18n("common_text_1000", nil)
			self.fields.Button_touch:setTouchEnabled(true)
			if self.fields.Text_targetTitle then
				self.fields.Text_targetTitle:setString(newPlayerTitle)
			end
			self.fields.Text_target:setString(newPlayerTaskRead.getDesByCID(self.table_quest.isNewPlayer))
			self.fields.Button_getPrize:setTitleText(i18n("common_text_477"))
			self.fields.Button_getPrize:setTouchEnabled(true)
			self.fields.Button_getPrize:setBright(true)
			self.fields.Button_getPrize:setBtnColorIndex(3)
		elseif self.table_quest.isFinished then
			self.controllers.c1:setSelectedIndex(2)
			qid = self.table_quest.qid
			self.fields.Button_touch:setTouchEnabled(false)
			local questType = questltCtrl:getQuestType(qid)
			self.fields.Text_target:setString(questDesRead.getTypeNotice(questType))
		elseif self.table_quest.isUpdate then
			self.controllers.c1:setSelectedIndex(3)
			self.fields.Button_touch:setTouchEnabled(false)
			self.fields.Text_target:setString(i18n("common_text_2496"))
			self.fields.Button_getPrize:setTitleText(i18n("common_text_900"))
			self.fields.Button_getPrize:setTouchEnabled(true)
			self.fields.Button_getPrize:setBright(true)
			self.fields.Button_getPrize:setBtnColorIndex(2)
		elseif self.table_quest:isLock() and not self.isRecommend then
			self.controllers.c1:setSelectedIndex(4)
			qid = self.table_quest:getQuestID()
			self.fields.Text_target:setString(questDesRead.getName(qid))
			self.fields.Button_touch:setTouchEnabled(true)
			local isWarLv, showLv = SoraDGetBuildWarLv(questltCtrl:getCastleLevel(qid))
			if isWarLv then
				_ENV = questltCtrl:getCastleLevel(qid)
				questltCtrl:getCastleLevel(qid).lv = showLv
				if i18n("common_text_1948", questltCtrl:getCastleLevel(qid)) then
					goto lbl_206
				end
			end
			local lvStr = math.min(showLv, _G.CASTLE_MAXLV_NOWAR)
			::lbl_206::
			_ENV = questltCtrl:getCastleLevel(qid)
			questltCtrl:getCastleLevel(qid).lv = lvStr
			self.fields.Text_err:setString(i18n("common_text_2844", questltCtrl:getCastleLevel(qid)))
		else
			self.controllers.c1:setSelectedIndex(5)
			qid = self.table_quest:getQuestID()
			self.fields.Text_target:setString(questDesRead.getName(qid))
			self.fields.Bar:setMax(self.table_quest:getAim())
			self.fields.Bar:setValue(self.table_quest:getProgress())
			_ENV = self.table_quest:getProgress()
			self.table_quest:getProgress().var1 = self.table_quest:getProgress()
			self.table_quest:getProgress().var2 = self.table_quest:getAim()
			self.fields.bar_title:setString(i18n("%{var1}/%{var2}", self.table_quest:getProgress()))
			self:updateRecommendData()
			self.fields.Button_touch:setTouchEnabled(true)
		end
		if qid then
			self.fields.questTargetIcon:setVisible(true)
			_ENV = true
			;(true).IconTarget = questDesRead.getIcon(qid)
			;(true).IconState = questDesRead.getTypeIcon(qid)
			self.fields.questTargetIcon:setTargetIconDate(true)
		elseif self.table_quest.isNewPlayer then
			self.fields.questTargetIcon:setVisible(true)
			_ENV = true
			;(true).IconTarget = "icon_assistant_npc.png"
			self.fields.questTargetIcon:setTargetIconDate(true)
		else
			self.fields.questTargetIcon:setVisible(false)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_target:setString(i18n("common_text_1117"))
	end
	self.fields.questTargetIcon:fixPos()
	self.fields.Text_target:fixPos()
	self.fields.Button_getPrize:fixPos()
	self:updateRes()
end
function com_questList:updateRes()
	self.resArray, questltCtrl = nil, nil
	if self.table_quest and self.table_quest.getQuestID then
		local questPrize = questltCtrl:getReward(self.table_quest:getQuestID())
		for i, v in ipairs(questPrize) do
			questltCtrl = self.table_quest:getQuestID()
			self.table_quest:getQuestID().id = v.id
			self.table_quest:getQuestID().count = SoraDConvertNumberWithUnit(v.count)
			table.insert(self.resArray, self.table_quest:getQuestID())
		end
	end
	self.fields.List_res:setNumItems(#self.resArray)
end
function com_questList:OnLayerClick(button, type)
	if self.table_quest then
		SoraDPlaySound()
		if self.table_quest.isNewPlayer then
			SoraDCreatePanel("newPlayerQuestView"):show()
		else
			local panel = SoraDCreatePanel("questDetailsView")
			panel:initData(self.table_quest, self.isRecommend)
			panel:show()
		end
	end
end
function com_questList:OnBtnGetPrizeClick()
	if self.table_quest.isUpdate then
		SoraDPlaySound()
		SoraDUpdateDownload()
		return
	end
	if self.table_quest.isNewPlayer then
		SoraDPlaySound()
		SoraDCreatePanel("newPlayerQuestView"):show()
		return
	end
	local canGetPrize = self.table_quest:canCommit()
	if canGetPrize then
		SoraDPlaySound("normalcontrol", 4)
		self.fields.Button_getPrize:setTouchEnabled(false)
		self.fields.Button_getPrize:setBright(false)
		questCtrl:reqCommitQuest(self.table_quest:getQuestID())
	else
		SoraDPlaySound()
		self:jumpToFinished()
		if SoraDIsGameGuide() == 2031 then
			_ENV = self
			self.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			self.step = 2032
			SoraDSendMessage(self)
		end
	end
end
function com_questList:jumpToFinished()
	questltCtrl:jumpToFinishedById(self.table_quest:getQuestID())
	SoraDRemoveAllPanelFromManager()
end
function com_questList:getPrizeID()
	return self.prizeID
end
function com_questList:updateRecommendData()
	local canGetPrize = self.table_quest:canCommit()
	local questType = questltCtrl:getQuestType(self.table_quest:getQuestID())
	local showBtn = true
	local colorIndex = 0
	if canGetPrize then
		self.fields.Button_getPrize:setTitleText(i18n("common_text_677"))
		colorIndex = 0
	else
		self.fields.Button_getPrize:setTitleText(i18n("common_text_678"))
		colorIndex = 3
		if questType == 27 or questType == 28 or questType == 31 or questType == 37 then
			showBtn = false
		end
	end
	self.fields.Button_getPrize:setBtnColorIndex(colorIndex)
	self.fields.Button_getPrize:setTouchEnabled(showBtn)
	self.fields.Button_getPrize:setBright(showBtn)
	self.fields.Button_getPrize:setVisible(showBtn)
end
function com_questList:getTarget(name)
	return self.fields[name]
end
return com_questList
