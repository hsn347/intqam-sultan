local arenaltCtrl = include("arenaltCtrl")
local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaMainViewPanel = class("ArenaMainViewPanel", baseFguiPanel)
function ArenaMainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaMainViewPanel:ctor", self.viewName)
end
function ArenaMainViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "troopFlagView"
	end
	return self._packageList
end
function ArenaMainViewPanel:onInit()
	print("=======ArenaMainViewPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose), handler(self, self.showHelp))
	local Button_prop = self.fields.Com_prop:getChild("Button_prop")
	Button_prop:addClickListener(handler(self, self.imgStarUpClick))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyItemRenderer))
	self.fields.List_army:addClickListener(handler(self, self.scrollMyArmyClick))
	self.fields.Text_noSetArmyTip:setString(i18n("arena_text_08"))
	self.fields.Text_noSetArmyTip:setVisible(false)
	self.fields.Button_more:setString("•••")
	self.fields.Button_more:addClickListener(handler(self, self.btnMoreMyArmyClick))
	self.fields.Button_set:setString(i18n("arena_btn_02"))
	self.fields.Button_set:addClickListener(handler(self, self.btnSetMyArmyClick))
	self.fields.List_enemy:setItemRenderer(handler(self, self.onEnemyItemRenderer))
	self.fields.Text_noArmy:setString(i18n("arena_text_31"))
	self.fields.Text_noArmy:setVisible(false)
	self.fields.Button_des:setString(i18n("common_text_978"))
	self.fields.Button_des:addClickListener(handler(self, self.btnDesClick))
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_record:setString(i18n("arena_title_02"))
	self.fields.Button_record:addClickListener(handler(self, self.btnRecordClick))
	local Button_reward = self.fields.Com_myRank:getChild("Button_reward")
	Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_refresh:setString(i18n("arena_btn_03"))
	self.fields.Button_refresh:addClickListener(handler(self, self.btnRefreshClick))
	self.btnAddCount = self.fields.Com_count:getChild("Button_add")
	self.btnAddCount:addClickListener(handler(self, self.btnAddCountClick))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
		self.fields.Com_prop:fixChildrenPos()
		self.fields.Com_myRank:fixChildrenPos()
		self.fields.Com_myRank:getChild("Image_bg"):fix()
		self.fields.Com_count:fixChildrenPos()
	end
end
function ArenaMainViewPanel:onShow()
	print("=======ArenaMainViewPanel:onShow")
	local param = self.param
	self:req4init(param.battleType)
	self:initBeforeView(param.index)
end
function ArenaMainViewPanel:judgeOpenGuide(...)
	if tolua.isnull(self) then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	local isGuideNotCompleted = guideCtrl:isGuideNotCompleted(gGuideModule.ARENA_INNER)
	if not isGuideNotCompleted and self.myInfo and self.myInfo.armyInfo and next(self.myInfo.armyInfo) and self.enemyInfo and next(self.enemyInfo) then
		guideCtrl:updateGuideModule(gGuideModule.ARENA_INNER_2)
	end
	gModuleMgr.sharedMgr("mildGuideManager"):clean()
	if isGuideNotCompleted and (not (self.myInfo and self.myInfo.armyInfo) or not next(self.myInfo.armyInfo)) then
		_ENV = nil
		gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.Button_set, nil)
	end
end
function ArenaMainViewPanel:initBeforeView(bid)
	print("ArenaMainViewPanel:initBeforeView bid=", bid)
	local blockInfo = arenaltCtrl.getSubSectionList(bid)
	self.blockID = blockInfo.grading
	if self.battleType == gArenaBattleType.ARENA_LOCAL then
		_ENV = nil
		;(nil).group = i18n(blockInfo.name)
		self.fields.Com_title:updateTitle(i18n("arena_title_03", nil))
	elseif self.battleType == gArenaBattleType.AREAN_GLOBAL then
		_ENV = i18n("arena_title_03", nil)
		i18n("arena_title_03", nil).group = i18n(blockInfo.name)
		self.fields.Com_title:updateTitle(i18n("arena_title_04", i18n("arena_title_03", nil)))
	end
end
function ArenaMainViewPanel:req4init(battleType)
	self.battleType = battleType
	self:enterConfirm()
	SoraDShowLoading(self:displayObject())
	arenaCtrl:req4battleInfo(self.battleType)
end
function ArenaMainViewPanel:initData(target, redata)
	SoraDCloseLoading(self:displayObject())
	self:initHeadData()
	if redata and redata.enemyInfo then
		self.enemyInfo = redata.enemyInfo
	end
	if redata and redata.topInfo then
		self.topInfo = redata.topInfo
	end
	self:initView()
end
function ArenaMainViewPanel:initView(...)
	self:refreshHead()
	self:changeTip()
	self:refreshPropAndKing()
	self:refreshEnemys()
end
function ArenaMainViewPanel:reqBackInfo(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and next(redata) and redata.fromPanel == "ArenaMainView" then
		_ENV = self:displayObject()
		self:displayObject().lordInfo = redata.lordInfo
		self:displayObject().armyBuff, _ENV, self:displayObject().armyList = redata.armyInfo, redata.armyInfo, redata.armyInfo
		self:displayObject().battleType = self.battleType
		uiManager:show("ArenaArmyInfoView", self:displayObject())
	end
end
function ArenaMainViewPanel:initEnemysData(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and redata.enemyInfo then
		self.enemyInfo = redata.enemyInfo
	end
	self:refreshEnemys()
end
function ArenaMainViewPanel:refreshTopRank(target, readData)
	local changeData = readData
	if changeData and changeData.rankinfo then
		self.topInfo = changeData.rankinfo
	end
	self:refreshPropAndKing()
end
function ArenaMainViewPanel:initHeadData()
	self.myInfo = arenaCtrl:getBattleInfo(self.battleType)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local cLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local totalInfo = lordInfoCtrl:getLordInfo()
	self.myInfo.nickName = totalInfo.base.nickName
	self.myInfo.abbr = totalInfo.abbr and totalInfo.abbr ~= "" and totalInfo.abbr or nil
	self.myInfo.castleLv = cLevel
	self.myInfo.iconID = totalInfo.base.imageId
	self.myInfo.avatar = totalInfo.base.avatar
end
function ArenaMainViewPanel:refreshHead(...)
	_ENV = nil
	;(nil).pow = string.formatnumberthousands(self.myInfo.fightCapacity)
	self.fields.Text_force:setString(i18n("arena_columntext_02", nil))
	if self.enemyInfo and next(self.enemyInfo) then
		_ENV = i18n("arena_columntext_02", nil)
		i18n("arena_columntext_02", nil).member = self.myInfo.remainTimes
		i18n("arena_columntext_02", nil).total = ARENA_DAY_SEND_COUNTS
		local showTimes = i18n("common_text_155", i18n("arena_columntext_02", nil))
		_ENV = i18n("arena_columntext_02", nil)
		i18n("arena_columntext_02", nil).num = showTimes
		self.fields.Com_count:setString(i18n("arena_columntext_03", i18n("arena_columntext_02", nil)))
	else
		_ENV = self.fields.Com_count
		self.fields.Com_count.member = 0
		self.fields.Com_count.total = ARENA_DAY_SEND_COUNTS
		local showTimes = i18n("common_text_155", self.fields.Com_count)
		_ENV = i18n("arena_columntext_03", i18n("arena_columntext_02", nil))
		i18n("arena_columntext_03", i18n("arena_columntext_02", nil)).num = showTimes
		self.fields.Com_count:setString(i18n("arena_columntext_03", i18n("arena_columntext_03", i18n("arena_columntext_02", nil))))
	end
	if self.myInfo.remainTimes > 0 then
		self.fields.Com_count:setColor(display.COLOR_WHITE)
		self.btnAddCount:setVisible(false)
	else
		self.fields.Com_count:setColor(display.COLOR_RED)
		self.btnAddCount:setVisible(true)
	end
	_ENV = i18n("arena_columntext_03", i18n("arena_columntext_03", i18n("arena_columntext_02", nil)))
	i18n("arena_columntext_03", i18n("arena_columntext_03", i18n("arena_columntext_02", nil))).rank = self.myInfo.myRank
	self.fields.Com_myRank:setString(i18n("common_text_825", i18n("arena_columntext_03", i18n("arena_columntext_03", i18n("arena_columntext_02", nil)))))
	local _ENV, cutArmyList = self.fields.Com_myRank.setString, self.fields.Com_myRank.setString
	table.sort(self.myInfo.armyInfo, function(l, r)
		local armyID1 = l.id % 1000
		local armyID2 = r.id % 1000
		local armyLv1 = armyID1 % 100
		local armyLv2 = armyID2 % 100
		if armyLv1 == armyLv2 then
			return armyID1 < armyID2
		else
			return armyLv1 > armyLv2
		end
	end)
	for i = 1, math.min(#self.myInfo.armyInfo, 3) do
		table.insert(cutArmyList, self.myInfo.armyInfo[i])
	end
	self.cutArmyList = cutArmyList
	self.fields.List_army:setNumItems(#self.cutArmyList)
	if cutArmyList and next(cutArmyList) then
		self.fields.Text_noSetArmyTip:setVisible(false)
		self.fields.Button_more:setVisible(true)
	else
		self.fields.Text_noSetArmyTip:setVisible(true)
		self.fields.Button_more:setVisible(false)
	end
end
function ArenaMainViewPanel:onArmyItemRenderer(index, obj)
	local data = self.cutArmyList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Com_army:initData(data.id)
	_fields.Text_count:setString(string.formatnumberthousands(data.num))
	_fields.Button_prop:setVisible(arenaltCtrl.judgeIsStar(self.myInfo.arenaBuff, data.id))
end
function ArenaMainViewPanel:refreshPropAndKing(...)
	local _ENV, buffStr
	if not self.myInfo or not self.myInfo.personalBuff then
		local _ENV, personalBuff = self.myInfo.personalBuff, self.myInfo.personalBuff
	end
	for i, v in ipairs(personalBuff) do
		local buffInfo = arenaltCtrl.getArmyBuff(v.effectType)
		if buffInfo then
			_ENV = nil
			;(nil).title = i18n(buffInfo.effectName)
			;(nil).value = v.value / 10
			local propStr = i18n("common_text_1298", nil)
			table.insert(buffStr, propStr)
		end
	end
	self.fields.Com_prop:setString(table.concat(buffStr, ","))
	_ENV = table.concat(buffStr, ",")
	table.concat(buffStr, ",").info = self.topInfo
	table.concat(buffStr, ",").myInfo = self.myInfo
	table.concat(buffStr, ",").battleType = self.battleType
	self.fields.Node_topLord:initData(table.concat(buffStr, ","))
end
function ArenaMainViewPanel:refreshEnemys(...)
	self.fields.List_enemy:setNumItems(#self.enemyInfo)
	if self.enemyInfo and next(self.enemyInfo) then
		self.fields.Text_noArmy:setVisible(false)
	else
		self.fields.Text_noArmy:setVisible(true)
	end
end
function ArenaMainViewPanel:onEnemyItemRenderer(index, obj)
	local data = self.enemyInfo[index + 1]
	_ENV = nil
	;(nil).info = data
	;(nil).myInfo = self.myInfo
	;(nil).battleType = self.battleType
	;(nil).challengeHandle = handler(self, self.challengeHandle)
	obj:initData(nil)
end
function ArenaMainViewPanel:challengeHandle(info)
	if self.myInfo == nil then
		return
	end
	if not next(self.myInfo.armyInfo) then
		SoraDShowMsgTip(i18n("arena_text_25"))
	elseif self.myInfo.remainTimes <= 0 then
		self:pop2BuyRemainTimes()
	elseif next(self.myInfo.armyInfo) and self.myInfo.remainTimes > 0 then
		_ENV = i18n("arena_text_25")
		i18n("arena_text_25").req4fight = true
		i18n("arena_text_25").battleType = self.battleType
		i18n("arena_text_25").fightData = info
		i18n("arena_text_25").blockID = self.blockID
		i18n("arena_text_25").fatherPanel = self
		uiManager:show("ArenaTeamSetView", i18n("arena_text_25"))
	end
end
function ArenaMainViewPanel:btnMoreMyArmyClick()
	SoraDPlaySound()
	print("self.battleType=", self.battleType)
	_ENV = nil
	;(nil).lordInfo = self.myInfo
	;(nil).armyList = self.myInfo.armyInfo
	;(nil).armyBuff = self.myInfo.arenaBuff
	;(nil).battleType = self.battleType
	;(nil).isOwn = true
	uiManager:show("ArenaArmyInfoView", nil)
end
function ArenaMainViewPanel:btnDesClick()
	SoraDPlaySound()
	local index = arenaltCtrl.getSubSectionIndex(self.battleType, self.blockID)
	_ENV = nil
	;(nil).bType = self.battleType
	;(nil).blockID = self.blockID
	;(nil).tIndex = index
	uiManager:show("ArenaPriceShowView", nil)
end
function ArenaMainViewPanel:btnRecordClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	uiManager:show("ArenaRecordView", nil)
end
function ArenaMainViewPanel:btnRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	;(nil).blockID = self.blockID
	;(nil).lordInfo = self.myInfo
	uiManager:show("ArenaRankView", nil)
end
function ArenaMainViewPanel:btnRewardClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).bType = self.battleType
	;(nil).blockID = self.blockID
	uiManager:show("ArenaPriceView", nil)
end
function ArenaMainViewPanel:btnSetMyArmyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).req4result = true
	;(nil).battleType = self.battleType
	;(nil).guideHandle = handler(self, self.judgeOpenGuide)
	uiManager:show("ArenaTeamSetView", nil)
end
function ArenaMainViewPanel:btnRefreshClick()
	SoraDPlaySound()
	SoraDShowLoading(self:displayObject())
	arenaCtrl:req2refreshEnemy(self.battleType)
end
function ArenaMainViewPanel:pop2BuyRemainTimes(...)
	if self.myInfo.remainTimes <= 0 then
		local gold = arenaltCtrl.getBuyCon(self.myInfo.buyTimes)
		SoraDShowBuyBox(i18n("arena_text_21"), gold, i18n("common_text_282"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				SoraDShowLoading(self:displayObject())
				arenaCtrl:req2buyCounts(self.battleType)
			end
		end)
	end
end
function ArenaMainViewPanel:btnAddCountClick()
	SoraDPlaySound()
	self:pop2BuyRemainTimes()
end
function ArenaMainViewPanel:enterConfirm(...)
	local mathBit = include("mathBit")
	_ENV = nil
	;(nil).byUID = true
	local recordInfo = SoraDConfigGet("Game:ArenaReadyView:enterLog~integer", nil)
	if gArenaBattleType.ARENA_LOCAL == self.battleType then
		recordInfo = mathBit.orOp(recordInfo, 2)
	elseif gArenaBattleType.AREAN_GLOBAL == self.battleType then
		recordInfo = mathBit.orOp(recordInfo, 1)
	end
	print("recordInfo = ", recordInfo)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:ArenaReadyView:enterLog~integer", recordInfo, nil)
end
function ArenaMainViewPanel:judgeGlobalChange(target, redata)
	if gArenaBattleType.AREAN_GLOBAL == self.battleType then
		self.battleInfo = arenaCtrl:getBattleInfo(self.battleType)
		if self.battleInfo.arenaStatus == gActivityState.CLOSE then
			SoraDShowMsgTip(i18n("mail_text_118"))
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end
end
function ArenaMainViewPanel:errTip(target, redata)
	if redata and redata.err then
		local errCode = redata.err
		if errCode == gErrDef.Err_ARENA_RANK_CHANGE then
			SoraDShowMsgTip(i18n("arena_text_22"))
		elseif errCode == gErrDef.Err_ARENA_CHALLENGE_TIMES_NOT_ENOUGH then
			SoraDShowMsgTip(i18n("arena_text_24"))
		elseif errCode == gErrDef.Err_ARENA_NOT_FIND_PLAYER or errCode == gErrDef.Err_ARENA_DATA_CHANGED then
			SoraDShowMsgTip(i18n("arena_text_22"))
		elseif errCode == gErrDef.Err_ARENA_CLEARING then
			SoraDShowMsgTip(i18n("arena_text_45"))
		end
	end
end
function ArenaMainViewPanel:changeTip(target, redata)
	local c1 = self.fields.Button_record:getController("c1")
	if arenaCtrl:getAllTipState(gArenaTipEnum.rankFall, self.battleType) then
		c1:setSelectedIndex(3)
	elseif arenaCtrl:getAllTipState(gArenaTipEnum.underAttackAndWin, self.battleType) then
		c1:setSelectedIndex(2)
	else
		c1:setSelectedIndex(0)
	end
end
function ArenaMainViewPanel:showHelp()
	SoraDPlaySound()
	if self.battleType == gArenaBattleType.ARENA_LOCAL then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LOCAL_ARENA)
	elseif self.battleType == gArenaBattleType.AREAN_GLOBAL then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.GLOBAL_ARENA)
	end
end
function ArenaMainViewPanel:scrollMyArmyClick()
	if next(self.myInfo.armyInfo) then
		self:btnMoreMyArmyClick()
	end
end
function ArenaMainViewPanel:imgStarUpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	uiManager:show("ForceBlessingPopView", nil)
end
function ArenaMainViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "fight_select_single_btn" then
		if self.enemyInfo and next(self.enemyInfo) then
			local obj = self.fields.List_enemy:getChildAt(#self.enemyInfo - 1)
			return obj.fields.Button_challenge
		end
	elseif itemName == "Button_set" then
		return self.fields.Button_set
	end
	return self.fields[itemName]
end
return ArenaMainViewPanel
