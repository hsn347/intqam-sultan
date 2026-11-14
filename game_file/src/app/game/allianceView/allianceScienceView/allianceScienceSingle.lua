local allianceDesRead = include("allianceDesRead")
local allianceltCtrl = include("allianceltCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local AllianceScienceSingle = class("allianceScienceSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceScienceSingle")
	end
	return target
end)
function AllianceScienceSingle:ctor()
	self.scroll = nil
	;(nil).data, _ENV, _ENV, self.singleIsMoved = nil, nil, nil, false
	self.tableStar, _ENV, self.singleData, (nil).isOpened = nil, nil, nil, false
	self.queue = nil
	self.timer = nil
	self.handle = nil
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.curScience = SoraDGetChildByName(self, "bg_science_icon_cur")
	self.curImgIcon = SoraDGetChildByName(self.curScience, "Image_icon")
	self.curLabelLv = SoraDGetChildByName(self.curScience, "Text_curLv")
	self.nextScience = SoraDGetChildByName(self, "bg_science_icon_next")
	self.nextScience:setVisible(false)
	self.nextImgIcon = SoraDGetChildByName(self.nextScience, "Image_icon")
	self.nextLabelLv = SoraDGetChildByName(self.nextScience, "Text_nextLv")
	self.tableStar[1] = SoraDGetChildByName(self, "Sprite_star")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_283"))
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnStudying = SoraDGetChildByName(self, "Button_studying")
	self.btnStudying:setLocalZOrder(2)
	self.labelStudy = SoraDGetChildByName(self.btnStudying, "Text_study")
	self.labelStudy:setString(i18n("common_text_062"))
	self.labelStudyTime = SoraDGetChildByName(self.btnStudying, "Text_studyTime")
	self.labelNewStudy = SoraDGetChildByName(self.btnStudying, "Text_newStudy")
	self.spriteNewStudy = SoraDGetChildByName(self.btnStudying, "Sprite_newStudy")
	self.imgBarBg = SoraDGetChildByName(self, "Image_barBg")
	self.ldbProgress = SoraDGetChildByName(self, "LoadingBar_progress")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.spriteRecommand = SoraDGetChildByName(self, "Sprite_recommand")
	self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnStudying:addTouchEventListener(handler(self, self.btnStudyingClickCallBack))
	self.Button_speed = SoraDGetChildByName(self, "Button_speed")
	self.Button_speed:setVisible(false)
	self.textGold = SoraDGetChildByName(self.Button_speed, "Text_gold")
	SoraDGetChildByName(self.Button_speed, "Text_nextLv"):setString(i18n("common_text_018"))
	self.Button_speed:addTouchEventListener(handler(self, self.btnSpeedClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STUDY_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STUDY_END", handler(self, self.updateData))
end
function AllianceScienceSingle:singleHeightUpdateCallBack(handle)
	self.handle = handle
end
function AllianceScienceSingle:updateData(target, data)
	if target == nil or self.singleData and data and data.sciid == self.singleData.data.id then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		self.singleData.data = allianceScience:getScienceData(self.singleData.data.id)
		self:updateView()
		if (data.msg == "MESSAGE_ALLIANCE_STUDY_BACK" or data.msg == "MESSAGE_ALLIANCE_STUDY_END") and self.handle then
			self.handle()
		end
	end
	SoraDCloseLoading(self.scroll)
end
function AllianceScienceSingle:initData(singleData)
	self.singleData = singleData
	self:updateView()
end
function AllianceScienceSingle:showQueue()
	self.imgBarBg:setVisible(true)
	self.labelTime:setVisible(true)
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function AllianceScienceSingle:hiddleQueue()
	self.imgBarBg:setVisible(false)
	self.labelTime:setVisible(false)
	self.nextScience:setVisible(false)
	self.Button_speed:setVisible(false)
	self.labelNotice:setVisible(false)
	self.btnStudying:setVisible(false)
	self.labelName:setPositionY(62)
	for i, v in ipairs(self.tableStar) do
		self:starHightLightEffect(v)
	end
end
function AllianceScienceSingle:openTimeUp(dt)
	local leftTime = 0
	if self.queue then
		leftTime = self.queue.timerNode.timer:getRemainTime()
		local totalTime = self.queue.totaltime
		self.ldbProgress:setPercent((totalTime - leftTime) * 100 / totalTime)
		self.labelTime:setString(SoraDConvertSecondToString(leftTime))
		local goldPay = serviceFunctions.timeConvertToGold(leftTime, false)
		self.textGold:setString(string.formatnumberthousands(math.floor(goldPay)))
	end
	if leftTime <= 0 then
		SoraDManagerRemoveTimer(self, self.timer)
		if self.hiddleQueue then
			self:hiddleQueue()
		end
		self.timer = nil
	end
end
function AllianceScienceSingle:updateView()
	if self.singleData.data.isRecommended then
		self.spriteRecommand:setVisible(true)
	else
		self.spriteRecommand:setVisible(false)
	end
	local maxLv = allianceltCtrl.scienceAttr(self.singleData.data.id, gAScienceInfo.MAXLV)
	local maxStar = allianceltCtrl.scienceAttr(self.singleData.data.id, gAScienceInfo.MAXSTAR)
	allianceltCtrl = nil
	;(nil).level = 0
	self.curLabelLv:setString(i18n("common_text_420", nil))
	for i, v in ipairs(self.tableStar) do
		v:setVisible(false)
	end
	self.imgBarBg:setVisible(false)
	self.labelTime:setVisible(false)
	self.nextScience:setVisible(false)
	self.Button_speed:setVisible(false)
	self.labelNotice:setVisible(false)
	self.btnStudying:setVisible(false)
	self.labelName:setPositionY(85)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.curImgIcon:loadTexture(allianceDesRead.getScienceIcon(self.singleData.data.id), ccui.TextureResType.plistType)
	self.labelName:setString(allianceDesRead.getScienceName(self.singleData.data.id))
	if self.singleData.isOpened then
		if maxLv <= self.singleData.data.lv then
			self.labelNotice:setVisible(true)
		else
			local gametop = gModuleMgr.getObject("gametop")
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			for i = 1, maxStar do
				if self.tableStar[i] == nil then
					local star = display.newSprite("#icon_star1_02.png", self.tableStar[1]:getPositionX() - SoraDFPosX((i - 1) * 60, 0), self.tableStar[1]:getPositionY())
					star:addTo(self.layerTouch)
					table.insert(self.tableStar, star)
				else
					self.tableStar[i]:RemoveChildren(1, -1, false)
				end
				if i <= self.singleData.data.star then
					self.tableStar[i]:setSpriteFrame("icon_star1_01.png")
				else
					self.tableStar[i]:setSpriteFrame("icon_star1_02.png")
				end
				self.tableStar[i]:setVisible(true)
			end
			if maxStar <= self.singleData.data.star then
				local allianceScience = gametop.playertop_:getModule("allianceScience")
				if memberMgr:getOwnMember():getProperty("rank") >= gAllianceRank.R4 then
					local leftTime, activitytime = allianceScience:getScienceTechTime(self.singleData.data.id)
					self.btnStudying:setVisible(true)
					self.labelStudyTime:setString(SoraDConvertSecondToString(leftTime))
					if leftTime ~= activitytime then
						self.labelStudy:setString(SoraDConvertSecondToString(leftTime))
						self.spriteNewStudy:setVisible(true)
						self.labelNewStudy:setVisible(true)
						self.labelStudyTime:setVisible(false)
						self.labelNewStudy:setString(SoraDConvertSecondToString(activitytime))
					else
						self.labelStudy:setString(i18n("common_text_062"))
						self.spriteNewStudy:setVisible(false)
						self.labelNewStudy:setVisible(false)
						self.labelStudyTime:setVisible(true)
					end
				end
				self.queue = allianceScience:queryQueue(SCIENCE_RESEARCH_QUEUE)
				if self.queue and self.queue.data.sciid == self.singleData.data.id then
					self.btnStudying:setVisible(false)
					if allianceltCtrl.getSciStarLvUpCanSpeed(self.singleData.data.id, self.singleData.data.lv, self.singleData.data.star) and permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_TECHNOLOGY_SPEED_UP) then
						self.Button_speed:setVisible(true)
					else
						self.nextScience:setVisible(true)
					end
					self.labelName:setPositionY(85)
					allianceltCtrl = true
					;(true).level = self.singleData.data.lv + 1
					self.nextLabelLv:setString(i18n("common_text_420", true))
					self.nextImgIcon:loadTexture(allianceDesRead.getScienceIcon(self.singleData.data.id), ccui.TextureResType.plistType)
					self:showQueue()
					for i, v in ipairs(self.tableStar) do
						v:setVisible(false)
					end
				elseif self.queue == nil then
					for i, v in ipairs(self.tableStar) do
						self:starHightLightEffect(v)
					end
				end
			else
				local star = self:starFlickEffect()
				local starBg = self.tableStar[self.singleData.data.star + 1]
				if starBg then
					star:addTo(starBg)
					star:setPosition(cc.p(starBg:getContentSize().width / 2, starBg:getContentSize().height / 2))
				end
			end
		end
		allianceltCtrl = star.setPosition
		star.setPosition.level = self.singleData.data.lv
		self.curLabelLv:setString(i18n("common_text_420", star.setPosition))
	end
	self:setColorState(self.singleData.isOpened)
end
function AllianceScienceSingle:setColorState(isOpened)
	local state = 1
	if isOpened then
		state = 0
	end
	self.curImgIcon:getVirtualRenderer():setState(state)
end
function AllianceScienceSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceScienceSingle:btnStudyingClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		self.queue = allianceScience:queryQueue(SCIENCE_RESEARCH_QUEUE)
		if self.queue then
			SoraDShowMsgTip(i18n("common_text_653"), nil, button)
		elseif include("pyramidWarltCtrl").checkPwXianXiaSai() then
			_ENV = button
			button.tech = include("allianceDesRead").getScienceName(self.singleData.data.id)
			SoraDShowMsgBox(i18n("common_text_859", button), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
					local gametop = gModuleMgr.getObject("gametop")
					local allianceScience = gametop.playertop_:getModule("allianceScience")
					allianceScience:reqResearchSci(self.singleData.data.id)
				end
			end)
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
function AllianceScienceSingle:btnSpeedClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.queue then
			_ENV = "common_text_4722"
			;("common_text_4722").speedUpName = i18n("common_text_018")
			;("common_text_4722").isBySelf = false
			SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpCallBack), i18n("common_text_4722"), "common_text_4722")
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
function AllianceScienceSingle:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		SoraDGetCtrl("allianceMgr"):reqSpeedAllianceScience()
	end
end
function AllianceScienceSingle:getSingleH()
	return 124
end
function AllianceScienceSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.singleData.isOpened then
			local panel = SoraDCreatePanel("allianceScienceInfoView")
			panel:initData(self.singleData.data)
			panel:show()
		else
			SoraDShowMsgTip(i18n("notice_0081"), nil, button)
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
function AllianceScienceSingle:starFlickEffect(...)
	local star = display.newSprite("#Image_alliance_twinkleStar.png")
	_ENV, _ENV = nil, "#Image_alliance_twinkleStar.png"
	_ENV, ("#Image_alliance_twinkleStar.png")[1], (nil).plist = nil, nil, "et_alliance_twinkleStar_01.plist"
	;("#Image_alliance_twinkleStar.png")[2], (nil).plist = nil, "et_alliance_twinkleStar_02.plist"
	local param = "#Image_alliance_twinkleStar.png"
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(star:getContentSize().width / 2, star:getContentSize().height / 2))
	parNode:addTo(star, 2)
	_UPVALUE3_ = parNode
	parNode[1] = cca.fadeOut(1)
	parNode[2] = cca.delay(0.2)
	parNode[3] = cca.fadeIn(1)
	parNode[4] = cca.delay(0.2)
	parNode[5] = cca.delay(0.2)
	local seq = transition.sequence(parNode)
	local action = cc.RepeatForever:create(seq)
	star:runAction(action)
	return star
end
function AllianceScienceSingle:starHightLightEffect(star)
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_alliance_shiningStar_01.plist"
	;(nil).x = 1.2
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.2
	_ENV, (nil).plist = nil, "et_alliance_shiningStar_02.plist"
	;(nil).x = 0.996
	;(nil)[2], (nil).scale, (nil).y = nil, nil, 0.996
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(star:getContentSize().width / 2, star:getContentSize().height / 2))
	parNode:addTo(star, 2)
end
return AllianceScienceSingle
