local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local publicRead = include("publicRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
_ENV = gametop.playertop_
gametop.playertop_.normal = 1
gametop.playertop_.lessCCount = 2
local _ENV, gametop.playertop_.lessHP, challengeStatus = "activityShowCtrl", 3, gametop.playertop_
;("activityShowCtrl").normal = 1
;("activityShowCtrl").lessCCount = 2
local ("activityShowCtrl").lessHP, sweepStatus = 3, "activityShowCtrl"
local epicBattleChallengeView = class("epicBattleChallengeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleChallengeView")
	end
	return target
end)
function epicBattleChallengeView:ctor()
	self.isInit = false
	self.btnChallengeStatus = challengeStatus.normal
	self.singleData, challengeStatus, self.btnSweepStatus = sweepStatus.normal, sweepStatus.normal, sweepStatus.normal
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Sprite_boss = SoraDGetChildByName(self, "Sprite_boss")
	self.Panel_boss = SoraDGetChildByName(self, "Panel_boss")
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.Text_talk = SoraDGetChildByName(self, "Text_talk")
	self.frame_cw_line = SoraDGetChildByName(self, "frame_cw_line")
	self.Text_chance = SoraDGetChildByName(self, "Text_chance")
	self.Text_chance:setString(i18n("common_text_488"))
	self.frame_cw_line:setPositionX(SoraDFPosX(self.Text_chance:getPositionX() - self.Text_chance:getContentSize().width - 10, 0))
	self.Node_star = SoraDGetChildByName(self, "Node_star")
	self.Text_level_name = SoraDGetChildByName(self, "Text_level_name")
	self.Text_left = SoraDGetChildByName(self, "Text_left")
	self.Text_left:setString(i18n("common_text_4354"))
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Button_countPlus = SoraDGetChildByName(self, "Button_countPlus")
	self.Button_countPlus:addTouchEventListener(handler(self, self.btnAddChallengeClick))
	self.Button_challenge = SoraDGetChildByName(self, "Button_challenge")
	self.Button_challenge:setTitleText(i18n("arena_btn_04"))
	self.Button_challenge:addTouchEventListener(handler(self, self.btnChallengeClick))
	self.Button_wipeout = SoraDGetChildByName(self, "Button_wipeout")
	self.Button_wipeout:setTitleText(i18n("epicbattle_btn_01"))
	self.Button_wipeout:addTouchEventListener(handler(self, self.btnSweepClick))
	epicWarCtrl:checkUpdateChallengeCount()
end
function epicBattleChallengeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ENTER_STAGE", handler(self, self.enterStage))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_SWEEP_STAGE", handler(self, self.sweepStage))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_CHALLENGE_BUY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ACTION_UPDATE", handler(self, self.updateView))
end
function epicBattleChallengeView:updateView(target, data)
	if data and data.msg == "MESSAGE_SERVER_EPICBATTLE_ACTION_UPDATE" and not self.isInit then
		return
	end
	local leftCount = epicWarCtrl:getStageCurChallangeCount(self.singleData.stage)
	local boughtCount = epicWarCtrl:getStageBoughtChallangeCount(self.singleData.stage)
	local maxCount = epicWarltCtrl.getStageMaxChallengeCount(self.singleData.stage)
	local stageMaxStar = epicWarltCtrl.getStageMaxStars(self.singleData.stage)
	epicWarCtrl = nil
	;(nil).member = leftCount
	;(nil).total = maxCount
	self.Text_num:setString(i18n("common_text_155", nil))
	self.Text_num:setColor(0 < leftCount and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))
	self.Button_countPlus:setVisible(leftCount < 1 and boughtCount < EPIC_MAX_BUY_COUNT)
	if not SoraDFIsRA() then
		self.Text_left:setPositionX(self.Text_num:getPositionX() - self.Text_num:getContentSize().width - 10)
	else
		self.Text_left:setPositionX(self.Text_num:getPositionX() + self.Text_num:getContentSize().width + 10)
	end
	if 0 < leftCount then
		self.Button_challenge:setTitleColor(cc.c3b(255, 255, 255))
		self.btnChallengeStatus = challengeStatus.normal
		local curAction = epicWarCtrl:getCurExploreCount()
		if curAction < SWEEP_COST_ACTION then
			self.btnChallengeStatus = challengeStatus.lessHP
		end
	else
		self.Button_challenge:setTitleColor(cc.c3b(190, 40, 40))
		self.btnChallengeStatus = challengeStatus.lessCCount
	end
	if stageMaxStar <= self.singleData.curStar then
		self.Button_wipeout:setVisible(true)
		self.Text_tip:setVisible(true)
		self.Button_challenge:setPositionX(SoraDFPosX(140, 0))
		self.Button_wipeout:setPositionX(SoraDFPosX(-140, 0))
		local curAction = epicWarCtrl:getCurExploreCount()
		self.btnSweepStatus = sweepStatus.normal
		if curAction < SWEEP_COST_ACTION then
			self.Button_wipeout:setTitleColor(cc.c3b(190, 40, 40))
			self.Text_tip:setColor(cc.c3b(190, 40, 40))
			self.btnSweepStatus = sweepStatus.lessHP
		elseif 0 < leftCount then
			self.Button_wipeout:setTitleColor(cc.c3b(255, 255, 255))
			self.Text_tip:setColor(cc.c3b(215, 195, 155))
		else
			self.btnSweepStatus = sweepStatus.lessCCount
			self.Button_wipeout:setTitleColor(cc.c3b(190, 40, 40))
			self.Text_tip:setColor(cc.c3b(190, 40, 40))
		end
	else
		self.Button_wipeout:setVisible(false)
		self.Text_tip:setVisible(false)
		self.Button_challenge:setPositionX(0)
	end
end
function epicBattleChallengeView:initData(data)
	self.singleData = data
	local heroID = epicWarltCtrl.getStageHeroID(self.singleData.stage)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroID)
	if cfg then
		self.Sprite_boss:setVisible(false)
		self.Panel_boss:setVisible(true)
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		self.spine_hero = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:setPosition(cc.p(0, -100))
		self.spine_hero:addTo(self.Node_spine)
	else
		self.Sprite_boss:setVisible(true)
		self.Panel_boss:setVisible(false)
		self.Sprite_boss:setSpriteFrame(epicWarltCtrl.getBossHeroMiddleIcon(heroID))
	end
	self.Text_talk:setString(self.singleData.des)
	local gateName = string.format("%d-%d %s", self.singleData.chapter, self.singleData.index, self.singleData.name)
	self.Text_level_name:setString(gateName)
	for i = 1, 3 do
		local star = SoraDGetChildByName(self.Node_star, "icon_star_" .. i)
		star:setSpriteFrame(i <= self.singleData.curStar and "icon_star1_01.png" or "icon_star1_02.png")
	end
	SoraDToCenter(self.Node_star)
	local sweepAction = SWEEP_COST_ACTION
	self.Text_tip:setString(i18n("epicbattle_text_09") .. sweepAction)
	self:updateView()
	local award = epicWarltCtrl.getStageDrop(self.singleData.stage)
	local multiple = activityShowCtrl:getEpicCommandMultiple()
	for i = 1, 4 do
		local awardItem = SoraDGetChildByName(self, "Node_award_" .. i)
		local sprite_item = SoraDGetChildByName(awardItem, "sprite_item")
		local itemID = award[i]
		if itemID then
			sprite_item:setSpriteFrame(publicRead.getIcon(itemID))
			if backpackltCtrl:getItemType(itemID) == gItemType.LEADER_POINT and 1 < multiple then
				if not awardItem.upArrow then
					awardItem.upArrow = display.newSprite("#icon_arrow_03.png")
					awardItem.upArrow:setPosition(SoraDFPosX(-26, 0), 22)
					awardItem.upArrow:addTo(awardItem, 9)
				else
					awardItem.upArrow:setVisible(true)
				end
			elseif awardItem.upArrow then
				awardItem.upArrow:setVisible(false)
			end
		else
			sprite_item:setSpriteFrame("icon_equip_storagebox.png")
		end
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
	end
	self.isInit = true
end
function epicBattleChallengeView:enterStage(target, data)
	SoraDCloseLoading(self)
	local panel = SoraDCreatePanel("epicWarMapView")
	panel:show()
end
function epicBattleChallengeView:sweepStage(target, data)
	SoraDCloseLoading()
	self:updateView()
	local panel = SoraDCreatePanel("epicBattleSweepAwardView")
	panel:initData(self.singleData, data.reward)
	panel:show()
end
function epicBattleChallengeView:btnAddChallengeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicBattleChallengeBuyView")
		panel:initData(self.singleData)
		panel:show()
	end
end
function epicBattleChallengeView:btnChallengeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound("epicControl", 4)
		local challenge = function()
			local panel = SoraDCreatePanel("epicBattleDispatchView")
			panel:initData(self.singleData)
			panel:show()
		end
		if self.singleData.stage == epicWarCtrl:getCurGateID() then
			self:enterStage()
		elseif self.btnChallengeStatus == challengeStatus.normal then
			challenge()
		elseif self.btnChallengeStatus == challengeStatus.lessCCount then
			local panel = SoraDCreatePanel("epicBattleChallengeBuyView")
			panel:initData(self.singleData)
			panel:show()
		elseif self.btnChallengeStatus == challengeStatus.lessHP then
			SoraDShowMsgBox(i18n("epicbattle_text_08"), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					challenge()
				end
			end)
		end
	end
end
function epicBattleChallengeView:btnSweepClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnSweepStatus == sweepStatus.lessHP then
			SoraDCreatePanel("epicBattleActionBuyView"):show()
		elseif self.btnChallengeStatus == challengeStatus.lessCCount then
			local panel = SoraDCreatePanel("epicBattleChallengeBuyView")
			panel:initData(self.singleData)
			panel:show()
		else
			epicWarCtrl:sendReqSweepStage(self.singleData.stage)
			SoraDShowLoading()
		end
	end
end
return epicBattleChallengeView
