local gametop = gModuleMgr.getObject("gametop")
local questCtrl = gametop.playertop_:getModule("questCtrl")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questDesRead = include("questDesRead")
local itemDesRead = include("itemDesRead")
local resDesRead = include("resDesRead")
local QuestSingleView = class("questSingleView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("questSingleView")
	end
	return target
end)
function QuestSingleView:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.table_quest = nil
	self.isRecommend = false
	self.prizeID = gIDDef.GOLD
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	if self.btnTouch then
		self.btnTouch:addTouchEventListener(handler(self, self.OnLayerClick))
		self.btnTouch:setSwallowTouches(false)
	end
	self.btn_getPrize = SoraDGetChildByName(self, "Button_getPrize")
	self.btn_getPrize:setTitleText(i18n("common_text_677"))
	if self.btn_getPrize then
		self.btn_getPrize:addTouchEventListener(handler(self, self.OnBtnGetPrizeClick))
		self.btn_getPrize:setTouchEnabled(false)
		self.btn_getPrize:setBright(false)
	end
	self.Image_frame = SoraDGetChildByName(self, "Image_frame")
	self.lab_target = SoraDGetChildByName(self, "Text_target")
	self.labelErr = SoraDGetChildByName(self, "Text_err")
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	local title = SoraDGetChildByName(self, "Text_name")
	if title then
		title:setString(i18n("common_text_679"))
	end
	self.Text_targetTitle = SoraDGetChildByName(self, "Text_targetTitle")
	self.node_progressBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_bar")
	self.tableRes, _ENV, self.node_targetIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_questTargetIcon_icon"), SoraDGetExtendChildFromCCSByName(self, "CCS_questTargetIcon_icon"), SoraDGetExtendChildFromCCSByName(self, "CCS_questTargetIcon_icon")
	self.tableRes[1] = SoraDGetChildByName(self, "Node_resSingle")
	self.resBg = SoraDGetChildByName(self, "Image_46")
end
function QuestSingleView:OnLayerClick(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
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
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function QuestSingleView:OnBtnGetPrizeClick(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
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
			SoraDShowLoading(SoraDSearchPanelFromManagerByName("questView"))
			button:setTouchEnabled(false)
			button:setBright(false)
			button:setTitleColor(display.COLOR_WHITE)
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
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function QuestSingleView:jumpToFinished()
	questltCtrl:jumpToFinishedById(self.table_quest:getQuestID())
	SoraDRemoveAllPanelFromManager()
end
function QuestSingleView:setScroll(scroll)
	self.scroll = scroll
end
function QuestSingleView:initData(questStyle, isRecommend)
	self.isRecommend = isRecommend
	self.table_quest = questStyle
	if self.table_quest then
		local qid
		if not self.isRecommend and not self.table_quest.isNewPlayer then
			self.labelErr:setVisible(false)
			self.lab_target:setPositionY(162)
		end
		if self.Image_line then
			self.Image_line:setVisible(true)
		end
		self.node_targetIcon:setPositionY(106)
		self.lab_target:setPositionY(162)
		if self.Text_targetTitle then
			self.Text_targetTitle:setVisible(false)
		end
		if self.table_quest.isNewPlayer then
			local newPlayerTaskRead = include("newPlayerTaskRead")
			_ENV = nil
			;(nil).name = newPlayerTaskRead.getTitleByCID(self.table_quest.isNewPlayer)
			;(nil).msg = newPlayerTaskRead.getNameByCID(self.table_quest.isNewPlayer)
			local newPlayerTitle = i18n("common_text_1000", nil)
			self.btn_getPrize:setVisible(true)
			self.btnTouch:setTouchEnabled(true)
			if self.Text_targetTitle then
				self.Text_targetTitle:setVisible(true)
				self.Text_targetTitle:setString(newPlayerTitle)
			end
			self.lab_target:setString(newPlayerTaskRead.getDesByCID(self.table_quest.isNewPlayer))
			self.btn_getPrize:setTitleText(i18n("common_text_477"))
			self.btn_getPrize:setTouchEnabled(true)
			self.btn_getPrize:setBright(true)
			self.btn_getPrize:loadTextures("btn_blue_normal_01.png", "", "", ccui.TextureResType.plistType)
			if self.Image_frame then
				self.Image_frame:loadTexture("frame_rw_cell_03.png", ccui.TextureResType.plistType)
			end
			if self.Image_line then
				self.Image_line:setVisible(false)
			end
			if self.labelErr then
				self.labelErr:setVisible(false)
			end
			self.node_progressBar:setVisible(false)
			self.node_targetIcon:setPositionY(80)
			self.lab_target:setPositionY(105)
		elseif self.table_quest.isFinished then
			qid = self.table_quest.qid
			self.node_progressBar:setVisible(false)
			self.btn_getPrize:setVisible(false)
			self.btnTouch:setTouchEnabled(false)
			local questType = questltCtrl:getQuestType(qid)
			self.lab_target:setContentSize(cc.size(450, 120))
			self.lab_target:setString(questDesRead.getTypeNotice(questType))
			if self.Image_frame then
				self.Image_frame:loadTexture("frame_rw_cell_02.png", ccui.TextureResType.plistType)
			end
		elseif self.table_quest.isUpdate then
			self.node_progressBar:setVisible(false)
			self.btn_getPrize:setVisible(true)
			self.btnTouch:setTouchEnabled(false)
			self.lab_target:setContentSize(cc.size(290, 120))
			self.lab_target:setString(i18n("common_text_2496"))
			self.btn_getPrize:setTitleText(i18n("common_text_900"))
			self.btn_getPrize:setTouchEnabled(true)
			self.btn_getPrize:setBright(true)
			self.btn_getPrize:loadTextures("btn_yellow_normal_01.png", "", "", ccui.TextureResType.plistType)
			if self.Image_frame then
				self.Image_frame:loadTexture("frame_rw_cell_01.png", ccui.TextureResType.plistType)
			end
		elseif self.table_quest:isLock() and not self.isRecommend then
			qid = self.table_quest:getQuestID()
			self.lab_target:setContentSize(cc.size(293, 62))
			if userSDKManager.isKO() then
				self.labelErr:setContentSize(cc.size(420, 62))
			end
			self.lab_target:setString(questDesRead.getName(qid))
			self.node_progressBar:setVisible(false)
			self.labelErr:setVisible(true)
			self.btn_getPrize:setVisible(false)
			self.btnTouch:setTouchEnabled(true)
			self.btnTouch:setSwallowTouches(false)
			local isWarLv, showLv = SoraDGetBuildWarLv(questltCtrl:getCastleLevel(qid))
			if isWarLv then
				_ENV = questltCtrl:getCastleLevel(qid)
				questltCtrl:getCastleLevel(qid).lv = showLv
				if i18n("common_text_1948", questltCtrl:getCastleLevel(qid)) then
					goto lbl_342
				end
			end
			local lvStr = math.min(showLv, _G.CASTLE_MAXLV_NOWAR)
			::lbl_342::
			_ENV = questltCtrl:getCastleLevel(qid)
			questltCtrl:getCastleLevel(qid).lv = lvStr
			self.labelErr:setString(i18n("common_text_2844", questltCtrl:getCastleLevel(qid)))
			if self.Image_frame then
				self.Image_frame:loadTexture("frame_rw_cell_01.png", ccui.TextureResType.plistType)
			end
		else
			qid = self.table_quest:getQuestID()
			self.lab_target:setContentSize(cc.size(293, 62))
			self.lab_target:setString(questDesRead.getName(qid))
			_ENV = questDesRead.getName(qid)
			questDesRead.getName(qid).maxValue = self.table_quest:getAim()
			questDesRead.getName(qid).curValue = self.table_quest:getProgress()
			self.node_progressBar:setProgressDate(questDesRead.getName(qid))
			self:updateRecommendData()
			self.node_progressBar:setVisible(true)
			self.btnTouch:setTouchEnabled(true)
			self.btnTouch:setSwallowTouches(false)
			if self.Image_frame then
				self.Image_frame:loadTexture("frame_rw_cell_01.png", ccui.TextureResType.plistType)
			end
		end
		if qid then
			self.node_targetIcon:setVisible(true)
			_ENV = true
			;(true).IconTarget = questDesRead.getIcon(qid)
			;(true).IconState = questDesRead.getTypeIcon(qid)
			self.node_targetIcon:setTargetIconDate(true)
		elseif self.table_quest.isNewPlayer then
			self.node_targetIcon:setVisible(true)
			_ENV = true
			;(true).IconTarget = "icon_assistant_npc.png"
			self.node_targetIcon:setTargetIconDate(true)
		else
			self.node_targetIcon:setVisible(false)
		end
	else
		if self.Image_frame then
			self.Image_frame:loadTexture("frame_rw_cell_01.png", ccui.TextureResType.plistType)
		end
		self.lab_target:setPositionY(110)
		self.lab_target:setContentSize(cc.size(360, 80))
		self.lab_target:setString(i18n("common_text_1117"))
		self.node_targetIcon:setVisible(false)
		self.node_progressBar:setVisible(false)
		self.btn_getPrize:setVisible(false)
		if self.resBg then
			self.resBg:setVisible(false)
		end
	end
	self:updateRes()
end
function QuestSingleView:updateRes()
	for i, v in ipairs(self.tableRes) do
		v:setVisible(false)
	end
	if self.table_quest and self.table_quest.getQuestID then
		local questPrize = questltCtrl:getReward(self.table_quest:getQuestID())
		local starX = 530
		for i, v in ipairs(questPrize) do
			local node = self.tableRes[i]
			if node == nil then
				node = self.tableRes[1]:clone()
				node:addTo(self.tableRes[1]:getParent())
				self.tableRes[i] = node
			end
			node:getChildByName("Text_resCount"):setString(SoraDConvertNumberWithUnit(v.count))
			local nodeRes = node:getChildByName("Sprite_res")
			nodeRes:setSpriteFrame(SoraDJudgeResOrItem(v.id) and itemDesRead.getIcon(v.id) or resDesRead.getIcon(v.id))
			if v.id == gIDDef.EXP then
				nodeRes:setScale(40 / nodeRes:getContentSize().height)
			elseif v.id == gIDDef.GOLD then
				nodeRes:setScale(44 / nodeRes:getContentSize().height)
			else
				nodeRes:setScale(48 / nodeRes:getContentSize().height)
			end
			node:setVisible(true)
			node:setPosition(SoraDFPoint(starX - (i - 1) * 100, node:getPositionY(), 640))
		end
	end
end
function QuestSingleView:getPrizeID()
	return self.prizeID
end
function QuestSingleView:updateRecommendData()
	local canGetPrize = self.table_quest:canCommit()
	local questType = questltCtrl:getQuestType(self.table_quest:getQuestID())
	local showBtn = true
	if canGetPrize then
		self.btn_getPrize:setTitleText(i18n("common_text_677"))
		btnName = "btn_green_normal_01.png"
		btnClickName = ""
	else
		self.btn_getPrize:setTitleText(i18n("common_text_678"))
		btnName = "btn_blue_normal_01.png"
		btnClickName = ""
		if questType == 27 or questType == 28 or questType == 31 or questType == 37 then
			showBtn = false
		end
	end
	self.btn_getPrize:loadTextures(btnName, btnClickName, "", ccui.TextureResType.plistType)
	self.btn_getPrize:setTouchEnabled(showBtn)
	self.btn_getPrize:setBright(showBtn)
	self.btn_getPrize:setVisible(showBtn)
end
return QuestSingleView
