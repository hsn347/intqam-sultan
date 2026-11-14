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
local epicWarGateView = class("epicWarGateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarGateView")
	end
	return target
end)
function epicWarGateView:ctor()
	self.isInit = false
	self.btnChallengeStatus = challengeStatus.normal
	self.singleData, challengeStatus, self.btnSweepStatus = sweepStatus.normal, sweepStatus.normal, sweepStatus.normal
	self.Panel_boss = SoraDGetChildByName(self, "Panel_boss")
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.Text_talk = SoraDGetChildByName(self, "Text_talk")
	self.frame_cw_line = SoraDGetChildByName(self, "frame_cw_line")
	self.Text_chance = SoraDGetChildByName(self, "Text_chance")
	self.Text_chance:setString(i18n("common_text_488"))
	self.Text_level_name = SoraDGetChildByName(self, "Text_level_name")
	self.Node_leftSwap = SoraDGetChildByName(self, "Node_leftSwap")
	self.Text_left = SoraDGetChildByName(self, "Text_left")
	challengeStatus = i18n("common_text_488")
	i18n("common_text_488").var1 = ""
	self.Text_left:setString(i18n("epic_war_moppingUpTimes_name", i18n("common_text_488")))
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Button_add = SoraDGetChildByName(self, "Button_add")
	self.Button_add:setVisible(false)
	self.Node_swap = SoraDGetChildByName(self, "Node_swap")
	self.Text_notice = SoraDGetChildByName(self, "Text_notice")
	self.Button_wipeout = SoraDGetChildByName(self, "Button_wipeout")
	self.Text_swap = SoraDGetChildByName(self.Button_wipeout, "Text_swap")
	self.Text_swap:setString(i18n("epicbattle_btn_01"))
	self.Node_wipeout = SoraDGetChildByName(self.Button_wipeout, "Node_wipeout")
	self.Text_swapNum = SoraDGetChildByName(self.Button_wipeout, "Text_swapNum")
	self.Button_wipeout:addTouchEventListener(handler(self, self.btnSweepClick))
	self.Button_add:addTouchEventListener(handler(self, self.btnAddClick))
	self.Button_back = SoraDGetChildByName(self, "Button_back")
	self.Button_back:setTitleText(i18n("epic_war_backChallenge_btn"))
	self.Button_back:addTouchEventListener(handler(self, self.btnBackCallBack))
	self.Button_left = SoraDGetChildByName(self, "Button_left")
	self.Button_left:addTouchEventListener(handler(self, self.btnLeftClick))
	self.Button_right = SoraDGetChildByName(self, "Button_right")
	self.Button_right:addTouchEventListener(handler(self, self.btnRightClick))
end
function epicWarGateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ENTER_STAGE", handler(self, self.enterStage))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_SWEEP_STAGE", handler(self, self.sweepStage))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_CHALLENGE_BUY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ACTION_UPDATE", handler(self, self.updateView))
end
function epicWarGateView:updateView(target, data)
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
	self.Button_add:setVisible(leftCount <= 0)
	SoraDToCenter(self.Node_leftSwap)
	self.Node_leftSwap:setVisible(self.singleData.isSweep)
	if 0 < leftCount then
		self.btnChallengeStatus = challengeStatus.normal
		local curAction = epicWarCtrl:getCurExploreCount()
		if curAction < SWEEP_COST_ACTION then
			self.btnChallengeStatus = challengeStatus.lessHP
		end
	else
		self.btnChallengeStatus = challengeStatus.lessCCount
	end
	if self.singleData.isSweep then
		self.Text_notice:setVisible(false)
		self.Node_swap:setVisible(true)
		self.Button_wipeout:setVisible(true)
		local curAction = epicWarCtrl:getCurExploreCount()
		self.btnSweepStatus = sweepStatus.normal
		if curAction < SWEEP_COST_ACTION then
			self.btnSweepStatus = sweepStatus.lessHP
			self.Text_swapNum:setColor(cc.c3b(190, 40, 40))
		elseif 0 < leftCount then
			self.Text_swapNum:setColor(cc.c3b(255, 255, 0))
		else
			self.btnSweepStatus = sweepStatus.lessCCount
			self.Text_swapNum:setColor(cc.c3b(190, 40, 40))
		end
	else
		self.Text_notice:setVisible(true)
		self.Node_swap:setVisible(false)
		self.Button_wipeout:setVisible(false)
	end
	local isBack = false
	if epicWarCtrl:getCurGateID() and epicWarCtrl:getCurGateID() == self.singleData.stage then
		isBack = true
		self.Node_swap:setVisible(true)
		self.Text_notice:setVisible(false)
	end
	self.Button_back:setVisible(isBack)
	SoraDToCenter(self.Node_swap, 60)
	self:updateArrow()
end
function epicWarGateView:updateArrow()
	local preGateID, nextGateID = epicWarltCtrl.getGatePreNextID(self.singleData.stage)
	self.Button_left:setVisible(preGateID and true or false)
	self.Button_right:setVisible(nextGateID and true or false)
end
function epicWarGateView:initData(data)
	self.singleData = data
	local heroID = epicWarltCtrl.getStageHeroID(self.singleData.stage)
	if self.spine_hero then
		self.spine_hero:removeFromParent()
		self.spine_hero = nil
	end
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroID)
	local isUsm = cfg.isUsm or false
	if isUsm then
		self.spine_hero = cc.criSprite.createCriSprite(spineCfg, false, true)
		self.spine_hero:setAnchorPoint(cc.p(0.5, 0))
		self.spine_hero:setScale(cfg.detail[1])
		self.spine_hero:setPosition(cfg.detail[2], cfg.detail[3])
		self.spine_hero:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.spine_hero:addTo(self.Node_spine)
	else
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		self.spine_hero = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
		self.spine_hero:setScale(cfg.detail[1])
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:setPosition(cfg.detail[2], cfg.detail[3])
		self.spine_hero:addTo(self.Node_spine)
	end
	self.Text_talk:setString(self.singleData.des)
	local gateName = string.format("%d-%d %s", self.singleData.chapter, self.singleData.index, self.singleData.name)
	self.Text_level_name:setString(gateName)
	epicWarltCtrl = true
	;(true).var1 = self.singleData.chapter
	;(true).var2 = 10
	self.Text_notice:setString(i18n("epic_war_moppingup_desc", true))
	self.Text_swapNum:setString(SWEEP_COST_ACTION)
	SoraDToCenter(self.Node_wipeout)
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
function epicWarGateView:enterStage(target, data)
	SoraDCloseLoading(self)
	local panel = SoraDCreatePanel("epicWarMapView")
	panel:show()
end
function epicWarGateView:sweepStage(target, data)
	SoraDCloseLoading()
	self:updateView()
	local panel = SoraDCreatePanel("epicBattleSweepAwardView")
	panel:initData(self.singleData, data.reward, data.times)
	panel:show()
end
function epicWarGateView:btnSweepClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnSweepStatus == sweepStatus.lessHP then
			SoraDCreatePanel("epicBattleActionBuyView"):show()
		elseif self.btnChallengeStatus == challengeStatus.lessCCount then
			local panel = SoraDCreatePanel("epicBattleChallengeBuyView")
			panel:initData(self.singleData)
			panel:show()
		else
			local panel = SoraDCreatePanel("epicWarSweepView")
			panel:initData(self.singleData)
			panel:show()
		end
	end
end
function epicWarGateView:btnAddClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicBattleChallengeBuyView")
		panel:initData(self.singleData)
		panel:show()
	end
end
function epicWarGateView:btnBackCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicWarMapView")
		panel:show()
		self:removeFromParent()
	end
end
function epicWarGateView:btnLeftClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local preID = epicWarltCtrl.getGatePreNextID(self.singleData.stage)
		local gateData = epicWarCtrl:getStageEntityInfo(preID)
		self:initData(gateData)
	end
end
function epicWarGateView:btnRightClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _, nextID = epicWarltCtrl.getGatePreNextID(self.singleData.stage)
		print("stage,nextID=====", stage, nextID)
		local gateData = epicWarCtrl:getStageEntityInfo(nextID)
		self:initData(gateData)
	end
end
function epicWarGateView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Text_num" then
		return self.Text_num
	else
		return SoraDGetChildByName(self, itemName)
	end
end
return epicWarGateView
