local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001691_MainPanel = class("Activity_9001691_MainPanel", baseFguiPanel)
local constantRead = include("constantRead")
local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
local activity_9001691_Read = include("activity_9001691_Read")
function Activity_9001691_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001691_MainPanel.super.ctor(self, ...)
	print("Activity_9001691_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001691
	print("Activity_9001691_MainPanel:ctor", self.viewName)
	constantRead = self.viewName
	self.viewName[1] = 875601
	self.viewName[2] = 1
	self.itemID = constantRead.getConstValueArray("SURPRISE_BOX_START_COST", self.viewName)[1]
end
function Activity_9001691_MainPanel:onInit()
	print("=======Activity_9001691_MainPanel:onInit")
	self.fields.Button_battlePass:fixPos()
	self.fields.Button_reward:fixPos()
	self.fields.Button_rank:fixPos()
	self.fields.Com_9001691_detail:fixPos()
	self.fields.Usm_1:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.bg:fix()
	self.fields.txt_maxLv:fixChildrenPos()
	self.fields.txt_maxScore:fixChildrenPos()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.obSystemBackKeyClick), handler(self, self.onClickHelp))
	self.fields.Button_battlePass:setTitle(i18n("surprise_box_002"))
	self.fields.Button_battlePass:addClickEventListener(handler(self, self.onClickBattlePass))
	self.fields.Button_reward:setString(i18n("surprise_box_004"))
	self.fields.Button_reward:addClickEventListener(handler(self, self.onClickBtnReward))
	self.fields.Button_rank:setString(i18n("surprise_box_003"))
	self.fields.Button_rank:addClickEventListener(handler(self, self.onClickBtnRank))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Button_satrt:addClickEventListener(handler(self, self.onClickStart))
	self.fields.Button_satrt:setTitle(i18n("common_text_2849"))
	self.fields.txt_stage_tip:setString(i18n("surprise_box_072"))
	fguiHelper.get_fields(self.fields.txt_maxLv).des:setString(i18n("surprise_box_070"))
	fguiHelper.get_fields(self.fields.txt_maxScore).des:setString(i18n("surprise_box_071"))
	self.fields.btn_left:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and 1 or -1)
	self.fields.btn_right:addClickEventListener(handler(self, self.onPageClick), SoraDFIsRA() and -1 or 1)
end
function Activity_9001691_MainPanel:endShow()
	print("=======Activity_9001691_MainPanel:endShow")
	self.fields.bg:setURL("frame_9001691_bg01.png")
	self.controllers.c1:setSelectedIndex(0)
	self.stageCfgs = activity_9001691_Read.getMainCfgs()
	self.curLevel = math.min(activity_9001691_Ctrl:getCurLevel(), #self.stageCfgs)
	activity_9001691_Ctrl:sendReqInitDataMsg()
	self:updateView()
end
function Activity_9001691_MainPanel:updateView()
	self.maxLevel = math.min(activity_9001691_Ctrl:getCurLevel(), #self.stageCfgs)
	if self.lastMaxLevel ~= nil and self.maxLevel > self.lastMaxLevel and self.curLevel == self.lastMaxLevel then
		self.curLevel = self.maxLevel
	end
	self.lastMaxLevel = self.maxLevel
	self.fields.txt_stage:setString(self.curLevel)
	self.fields.Com_9001691_detail:initData(self.stageCfgs[self.curLevel])
	self.haveNum = self.fields.Com_have:updateNum()
	self.hasGuided = activity_9001691_Ctrl:hasGuided()
	self.fields.Button_satrt:setIsFree(not self.hasGuided)
	if self.hasGuided then
		self.fields.Button_satrt:setCost(self.itemID, 1)
	end
	local isAddEnable = #self.stageCfgs > self.curLevel
	local isMinEnable = self.curLevel > 1
	if SoraDFIsRA() then
		self.fields.btn_left:setEnabled(isAddEnable)
		self.fields.btn_right:setEnabled(isMinEnable)
	else
		self.fields.btn_left:setEnabled(isMinEnable)
		self.fields.btn_right:setEnabled(isAddEnable)
	end
	self.fields.Button_battlePass:setReddot(activity_9001691_Ctrl:hasAward())
	self.fields.txt_maxLv:setTitle(activity_9001691_Ctrl:getCurLevel() - 1)
	self.fields.txt_maxScore:setTitle(activity_9001691_Ctrl:getMyScore())
end
function Activity_9001691_MainPanel:startGame(data)
	self.fields.Usm_1:clearEffect()
	SoraDShowLoading(self, nil, nil, true)
	self.fields.Usm_1:setVisible(true)
	self.fields.Usm_1:setAlpha(1)
	self.fields.Usm_1:setEffectPath("9001691_loading.usm", false)
	self.fields.Usm_1:setCompleteCallback(function()
		SoraDCloseLoading(self)
		self.fields.Usm_1:setVisible(false)
		self.fields.bg:setURL("frame_9001691_bg02.png")
		self.fields.Com_9001691_game:onShowAniEnd()
	end)
	self.transitions.t0:playReverse(function()
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_9001691_game:startGame(data, self.hasGuided, handler(self, self.onGameEnd))
	end)
	self.isInGame = true
end
function Activity_9001691_MainPanel:onGameEnd()
	self.isInGame = false
	self.fields.bg:setURL("frame_9001691_bg01.png")
	self.transitions.t0:play()
	self.controllers.c1:setSelectedIndex(0)
	activity_9001691_Ctrl:sendReqInitDataMsg()
	self.maxLevel = math.min(activity_9001691_Ctrl:getCurLevel(), #self.stageCfgs)
end
function Activity_9001691_MainPanel:onClickStart()
	SoraDPlaySound()
	if self.hasGuided and self.haveNum <= 0 then
		SoraDShowMsgTip(i18n("surprise_box_067"))
		return
	end
	activity_9001691_Ctrl:reqSurpriseBoxBegin(self.curLevel)
end
function Activity_9001691_MainPanel:onClickBattlePass()
	SoraDPlaySound()
	uiManager:show("Activity_9001691_BattlePass")
end
function Activity_9001691_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	local rewards = activity_9001691_Read.getGameReward()
	_ENV = nil
	;(nil).rewards = rewards
	;(nil).desc = i18n("surprise_box_068")
	uiManager:show("CommonRewardPreview", nil)
end
function Activity_9001691_MainPanel:onClickBtnRank(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001691_Rank")
end
function Activity_9001691_MainPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.curLevel + params
	if self.stageCfgs[curIndex] == nil or curIndex >= self.maxLevel then
		if curIndex >= self.maxLevel then
			if curIndex > self.maxLevel then
				SoraDShowMsgTip(i18n("surprise_box_005"))
			end
			curIndex = self.maxLevel
		else
			curIndex = 1
		end
	end
	self.curLevel = curIndex
	self:updateView()
end
function Activity_9001691_MainPanel:obSystemBackKeyClick()
	if self.isInGame then
		SoraDPlaySound()
		if self.fields.Com_9001691_game:getIsGameStart() then
			_ENV = nil
			;(nil).content = i18n("surprise_box_024")
			;(nil).cancel = true
			;(nil).confirmFunc = function()
				if tolua.isnull(self) then
					return
				end
				self.fields.Com_9001691_game:finishGame()
			end
			uiManager:show("MessageBox", nil)
		else
			self.isInGame = false
		end
	else
		self:onClickClose()
	end
end
function Activity_9001691_MainPanel:onClickHelp()
	SoraDPlaySound()
	local str = i18n("surprise_box_065")
	_ENV = nil
	;(nil).content = str
	uiManager:show("RuleView", nil)
end
return Activity_9001691_MainPanel
