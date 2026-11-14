local evilPalaceDefine = include("evilPalaceDefine")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local angerMapViewPanel = class("angerMapViewPanel", baseFguiPanel)
function angerMapViewPanel:ctor(...)
	angerMapViewPanel.super.ctor(self, ...)
	print("angerMapViewPanel:ctor", self.viewName)
end
function angerMapViewPanel:onInit()
	print("=======angerMapViewPanel:onInit")
	self.activityID = gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY
	self.battleType = gAngrySnowWolfKingBattletype.ELITE_BATTLE
	self.normalCost = 5
	self.eliteCost = 50
	self.moveLine, _ENV, self.warMatrix, _ENV, self.noticeList, _ENV, self.itemList, _ENV, self.timesOut = gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, false
	self.isNewMsgArrive = false
	self.msgIndex = 1
	self.fightNode, _ENV, self.warInfoTbl, _ENV, self.baseInfoTbl, _ENV, self.beforeMonster = gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, gAngrySnowWolfKingBattletype.ELITE_BATTLE, "idle"
	self.isMonsterDieTip = false
	self.isInit = true
	self.fields.Com_title:initData(i18n("activity_name_9001578"), handler(self, self.onClickClose))
	self.nodeMonster = self.fields.Node_monster
	self.fields.Btn_monster:addClickListener(handler(self, self.btnMonsterClick))
	self.fields.Com_topInfo:addClickListener(handler(self, self.btnLog2Click))
	self.fields.Text_priceTip:setString(i18n("common_text_3274"))
	self.fields.Text_priceTip:setTouchEnabled(true)
	self.fields.Text_priceTip:addClickListener(handler(self, self.btnLog1Click))
	self.fields.Button_normal:addClickListener(handler(self, self.btnNormalClick))
	self.fields.Button_special:addClickListener(handler(self, self.btnSpecialClick))
	self.fields.Button_anla:addClickListener(handler(self, self.btnAnlaClick))
	self.fields.List_items:setVirtual()
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_exchange:setString(i18n("Challenge_SnowWolf_text_06"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	for i = 1, 3 do
		self.fightNode[i] = display.newNode()
		self.fields["Node_army" .. i]:setContent(self.fightNode[i])
	end
	self.fields.Text_tip:setString(i18n("snow_competition_text_07"))
	self.fields.Text_lvTitle:setString(i18n("snow_competition_text_08"))
	self.fields.Text_rewardTitle:setString(i18n("return_peak_04"))
	self.fields.Text_rewardTitle1:setString(i18n("StarlitNight_text_07"))
	self.fields.Button_buyGift:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClickBuyGift))
	self.fields.Button_oneKey:setString(i18n("cavalryrise_text_07"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClickOneKey))
	self.fields.List:setItemRenderer(handler(self, self.onSignRenderer))
	self.fields.bg_sign:fix()
	self.fields.Text_lvTitle:fixPos()
	self.fields.Text_rewardTitle:fixPos()
	self.fields.Text_rewardTitle1:fixPos()
	self.fields.sheer:fixPos()
	self.fields.Button_buyGift:fixPos()
end
function angerMapViewPanel:onItemRenderer(index, obj)
	if not self.itemList[index + 1].superaward then
		local _ENV, superaward = self.itemList[index + 1].superaward, self.itemList[index + 1].superaward
	end
	local item = self.itemList[index + 1].item
	local showItem = next(superaward) and superaward or item
	obj:initData(showItem[1], showItem[2])
	obj:showCoolSquare(next(superaward) and true or false)
end
function angerMapViewPanel:onSignRenderer(index, obj)
	obj:initData(self.rewardList[index + 1], index + 1)
end
function angerMapViewPanel:onShow()
	print("=======angerMapViewPanel:onShow")
	self.battleType = self.param and self.param.battleType or gAngrySnowWolfKingBattletype.ELITE_BATTLE
	self:req4Start(self.battleType)
	self:pickThreeAward()
	self.rewardList = monsterpalaceltCtrl:getRewardList()
	self.tag = self.param.tag and self.param.tag or 1
	_ENV = self.battleType
	_ENV, _ENV, self.battleType.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("Challenge_SnowWolf_text_01")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Challenge_SnowWolf_text_13")
	self.battleType.tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	self.battleType.callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(self.battleType)
	self:updateRed()
end
function angerMapViewPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self.fields.Com_title:setTimeShowIndex(0)
		for i = 1, 3 do
			self.fields["Node_army" .. i]:setVisible(true)
		end
	else
		for i = 1, 3 do
			self.fields["Node_army" .. i]:setVisible(false)
		end
		self.fields.Com_title:initCommonActivityTime(self.activityID)
		self.fields.Com_title:setTimeShowIndex(1)
		self:initSign()
	end
end
function angerMapViewPanel:initSign()
	self.fields.List:setNumItems(#self.rewardList)
	self.controllers.c2:setSelectedIndex(angrySnowWolfKingCtrl:isActiveAdvance() and 1 or 0)
	self.fields.Button_oneKey:setEnabled(angrySnowWolfKingCtrl:hasAward())
end
function angerMapViewPanel:updateSign()
	SoraDCloseLoading(self)
	self:initSign()
	self:updateRed()
end
function angerMapViewPanel:updateRed()
	self.fields.Button_exchange:setRedVisible(angrySnowWolfKingCtrl:judgeIsEnough())
	self.fields.Com_title:setBtnRedDot(1, angrySnowWolfKingCtrl:isCanChallenge())
	self.fields.Com_title:setBtnRedDot(2, angrySnowWolfKingCtrl:hasAward())
	self.fields.Button_oneKey:setReddot(angrySnowWolfKingCtrl:hasAward())
end
function angerMapViewPanel:pickThreeAward()
	local serverawardinfo = angrySnowWolfKingCtrl:getServerAwardInfo()
	if serverawardinfo and next(serverawardinfo) then
		local index = 0
		for i = #serverawardinfo, 1, -1 do
			angrySnowWolfKingCtrl = nil
			;(nil).msg = "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATE_SYSTEMAWARD"
			;(nil).reward = serverawardinfo[i]
			SoraDSendMessage(nil)
			index = index + 1
			if 3 <= index then
				break
			end
		end
	end
end
function angerMapViewPanel:req4Start(monsterType)
	SoraDShowLoading(self)
	self.battleType = monsterType
	angrySnowWolfKingCtrl:entranceinfoReq(true)
	angrySnowWolfKingCtrl:enterpalacebattleReq(self.battleType)
	self:initBattleHorn()
	self:initArmy()
	self:initMonster()
end
function angerMapViewPanel:noticeBanner(target, redata)
	dump(redata, "noticeBanner===")
	if redata and redata.reward then
		local txtDes
		if redata.reward.userinfo.allianceName then
			_ENV = nil
			_ENV = nil
			;(nil).abbr = redata.reward.userinfo.allianceName
			;(nil).name = redata.reward.userinfo.nickName
			;(nil).name = i18n("common_text_186", nil)
			txtDes = i18n("Challenge_SnowWolf_text_02", nil)
		else
			_ENV = nil
			;(nil).name = redata.reward.userinfo.nickName
			txtDes = i18n("Challenge_SnowWolf_text_02", nil)
		end
		local itemDes = ""
		if next(redata.reward.awarddata.item) then
			_ENV = redata.reward.userinfo.nickName
			redata.reward.userinfo.nickName.good = publicRead.getName(redata.reward.awarddata.item[1]) .. "*" .. redata.reward.awarddata.item[2]
			itemDes = i18n("common_text_3276", redata.reward.userinfo.nickName)
		elseif next(redata.reward.awarddata.superaward) then
			_ENV = redata.reward.userinfo.nickName
			redata.reward.userinfo.nickName.good = publicRead.getName(redata.reward.awarddata.superaward[1]) .. "*" .. redata.reward.awarddata.superaward[2]
			itemDes = i18n("common_text_3276", redata.reward.userinfo.nickName)
		end
		table.insert(self.noticeList, txtDes .. itemDes)
		self.isNewMsgArrive = true
		self:loopTopInfo()
	end
end
function angerMapViewPanel:loopTopInfo()
	local clampf = function(value, min, max)
		return math.max(math.min(value, max), min)
	end
	local function loop2Action(isOld)
		if next(self.noticeList) then
			local showText
			if isOld then
				self.msgIndex = self.msgIndex % #self.noticeList + 1
			else
				self.msgIndex = #self.noticeList
			end
			print("#self.noticeList = ", #self.noticeList)
			print("self.msgIndex = ", self.msgIndex)
			self.msgIndex = clampf(self.msgIndex, 1, #self.noticeList)
			showText = self.noticeList[self.msgIndex]
			if showText then
				self.fields.Com_topInfo:setAction(showText, 10, function()
					loop2Action(self.isNewMsgArrive)
					self.isNewMsgArrive = false
				end)
				self.noticeInAction = true
			end
		end
	end
	if not self.noticeInAction then
		loop2Action()
	end
end
function angerMapViewPanel:initBattleHorn(target, data)
	self.fields.Com_horn:initData()
end
function angerMapViewPanel:initData(target, data)
	self:justInitData()
	self:initView()
end
function angerMapViewPanel:justInitData()
	SoraDCloseLoading(self)
	self.baseInfoTbl = angrySnowWolfKingCtrl:getInitInfo()
	self.recentItems = angrySnowWolfKingCtrl:splitPersonalAward(self.battleType)
	self.warInfoTbl = angrySnowWolfKingCtrl:getBattleInfo(self.battleType)
	if self.isInit then
		local recordTbl = angrySnowWolfKingCtrl:getServerAwardInfo()
		for _, data in ipairs(recordTbl) do
			_ENV = nil
			;(nil).name = data.userinfo.nickName
			local txtDes = i18n("Challenge_SnowWolf_text_02", nil)
			if data.userinfo.allianceName then
				_ENV = data.userinfo.nickName
				_ENV = nil
				;(nil).abbr = data.userinfo.allianceName
				;(nil).name = data.userinfo.nickName
				data.userinfo.nickName.name = i18n("common_text_186", nil)
				txtDes = i18n("Challenge_SnowWolf_text_02", data.userinfo.nickName)
			end
			local itemDes = ""
			if data.awarddata.item and next(data.awarddata.item) then
				_ENV = i18n("common_text_186", nil)
				i18n("common_text_186", nil).good = publicRead.getName(data.awarddata.item[1]) .. "*" .. data.awarddata.item[2]
				itemDes = i18n("common_text_3276", (i18n("common_text_186", nil)))
			elseif data.awarddata.superaward and next(data.awarddata.superaward) then
				_ENV = i18n("common_text_186", nil)
				i18n("common_text_186", nil).good = publicRead.getName(data.awarddata.superaward[1]) .. "*" .. data.awarddata.superaward[2]
				itemDes = i18n("common_text_3276", (i18n("common_text_186", nil)))
			end
			table.insert(self.noticeList, txtDes .. itemDes)
		end
		self:loopTopInfo()
		self.isInit = false
	end
end
function angerMapViewPanel:attackCB(target, redata)
	SoraDCloseLoading(self)
	local rewardList = redata.awardlist
	local _ENV, commandList = self, self
	if redata.noMonster then
		commandList.dieout = true
		self.timesOut = true
		self.monsterInAction = false
	elseif redata.monsterDie then
		commandList.die = true
		self.monsterInAction = false
	else
		self:justInitData()
		self:initView(true)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(1)
		;(nil)[2] = ffa.callFunc(function()
			self:refreshRewardScroll()
		end)
		;(nil)[3] = ffa.callFunc(function()
			self:refreshRewardScroll()
		end)
		self:runAction(ffa.seq(nil))
	end
	if not self.monsterInAction then
		self.monsterInAction = true
		self:dispatchAction(commandList)
	end
	self:dispatchBoxAction(rewardList)
end
function angerMapViewPanel:dispatchBoxAction(itemlist)
	dump(itemlist, "我是奖品")
	local _ENV, showList = dump, dump
	for k, v in ipairs(itemlist) do
		if v.super_award and next(v.super_award) then
			_ENV = nil
			;(nil).id = v.super_award[1]
			;(nil).count = v.super_award[2]
			table.insert(showList, nil)
		else
			_ENV = nil
			;(nil).id = v.item[1]
			;(nil).count = v.item[2]
			table.insert(showList, nil)
		end
	end
	SoraDMailGainItems(showList, true)
end
function angerMapViewPanel:changeState(target, data)
	SoraDCloseLoading(self)
	self:initData()
end
function angerMapViewPanel:errCallBack(target, redata)
	SoraDCloseLoading(self)
	if gErrDef.Err_MONSTERPALACE_NOTENOUGH_HORN == redata.err then
		SoraDShowMsgTip(i18n("common_text_3279"))
	elseif gErrDef.Err_MONSTERPALACE_ELITE_KILL_MAX == redata.err then
		SoraDShowMsgTip(i18n("common_text_3281"))
	elseif gErrDef.Err_MONSTERPALACE_NORMAL_KILL_MAX == redata.err then
		SoraDShowMsgTip(i18n("common_text_3280"))
	end
end
function angerMapViewPanel:initView(ignoreRewardList)
	if not self.warInfoTbl then
		self.timesOut = true
		self.fields.Node_monsterInfo:setVisible(false)
		_ENV = nil
		;(nil).cur = 0
		;(nil).max = ANGRY_SNOW_WOLF_KING_USERKILL_NORMALMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", nil))
		self.fields.Button_normal:initData(ANGRY_SNOW_WOLF_KING_ELITE_COSTHORN)
		self.fields.Button_special:initData(ANGRY_SNOW_WOLF_KING_ELITE_COSTHORN * ANGRY_SNOW_WOLF_KING_ELITE_MAXHP)
		self:refreshRewardScroll()
		return
	end
	if 0 < self.warInfoTbl.Allanhbless then
		self.fields.Button_anla:setVisible(true)
		self.fields.Button_normal:setVisible(false)
		self.fields.Button_special:setVisible(false)
		self.fields.Button_anla:initData(self.warInfoTbl.Allanhbless)
	else
		self.fields.Button_anla:setVisible(false)
		self.fields.Button_normal:setVisible(true)
		self.fields.Button_special:setVisible(true)
		self.normalCost = self.battleType == gAngrySnowWolfKingBattletype.NORMAL_BATTLE and ANGRY_SNOW_WOLF_KING_NORMAL_COSTHORN or ANGRY_SNOW_WOLF_KING_ELITE_COSTHORN
		self.eliteCost = (self.warInfoTbl.maxhp - self.warInfoTbl.dechp) * self.normalCost
		self.fields.Button_normal:initData(self.normalCost)
		self.fields.Button_special:initData(self.eliteCost)
	end
	self.fields.Node_monsterInfo:setVisible(true)
	self.fields.Node_monsterInfo:setBlood(self.warInfoTbl)
	if not ignoreRewardList then
		self:refreshRewardScroll()
	end
	self:initBattleHorn()
	if gAngrySnowWolfKingBattletype.NORMAL_BATTLE == self.battleType then
		_ENV = i18n("%{cur}/%{max}", nil)
		i18n("%{cur}/%{max}", nil).cur = self.warInfoTbl.remainkilltimes
		i18n("%{cur}/%{max}", nil).max = ANGRY_SNOW_WOLF_KING_USERKILL_NORMALMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)))
	else
		_ENV = i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil))
		i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)).cur = self.warInfoTbl.remainkilltimes
		i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)).max = ANGRY_SNOW_WOLF_KING_USERKILL_ELITEMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil))))
	end
	if 0 >= self.warInfoTbl.remainkilltimes then
		self.timesOut = true
	else
		self.timesOut = false
	end
end
function angerMapViewPanel:refreshRewardScroll(nowList, addList)
	local self.itemList, _ENV, _ENV, nowList = nil, nil, self.recentItems, nowList or self.recentItems or self.recentItems
	local index = 0
	if addList and next(addList) then
		for i = #addList, 1, -1 do
			index = index + 1
			table.insert(self.itemList, addList[i])
			if 12 <= index then
				break
			end
		end
	end
	for i = #nowList, 1, -1 do
		index = index + 1
		table.insert(self.itemList, nowList[i].awarddata)
		if 12 <= index then
			break
		end
	end
	self.fields.List_items:setNumItems(#self.itemList)
	self.fields.List_items:scrollToView(0, true)
end
function angerMapViewPanel:initMonster()
	local isBigBoss = self.battleType ~= gAngrySnowWolfKingBattletype.NORMAL_BATTLE
	self.fields.Node_monsterInfo:setMonsterName(self.battleType == gAngrySnowWolfKingBattletype.NORMAL_BATTLE and i18n("Challenge_SnowWolf_text_01") or i18n("Challenge_SnowWolf_text_01"))
	self.fields.Node_monster:clearContent()
	local initMonsterPng = "langguai_dj_ws_01.png"
	self.spMonster = display.newSprite("#" .. initMonsterPng)
	self.spMonster:setPosition(5, 5)
	self.fields.Node_monster:setContent(self.spMonster)
	function self.spMonster.fight(...)
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeMonster, 1.0, nil)
		self.spMonster:stopAllActions()
		local frames = evilPalaceDefine.getSnowWolfActionArray("gj")
		local animation = display.newAnimation(frames, 0.041666666666666664)
		self.spMonster:playAnimationForever(animation)
		self.beforeMonster = "fight"
	end
	function self.spMonster.idle(...)
		self.spMonster:stopAllActions()
		local frames = evilPalaceDefine.getSnowWolfActionArray("dj")
		local animation = display.newAnimation(frames, 0.041666666666666664)
		self.spMonster:playAnimationForever(animation)
		self.beforeMonster = "idle"
	end
	function self.spMonster.dead(...)
		self = nil
		;(nil).diff_max = 10
		;(nil).interval = 0.03
		self:shakeEffect(self.nodeMonster, 1.0, nil)
		self.spMonster:stopAllActions()
		local frames = evilPalaceDefine.getSnowWolfActionArray("sw")
		local animation = display.newAnimation(frames, 0.041666666666666664)
		self.spMonster:playAnimationOnce(animation)
		self.beforeMonster = "dead"
	end
	self.spMonster.idle()
end
function angerMapViewPanel:initArmy()
	for i = 1, 3 do
		if self.moveLine[i] then
			self.moveLine[i]:removeFromParent()
			self.moveLine[i] = nil
		end
		if self.warMatrix[i] then
			self.warMatrix[i]:removeFromParent()
			self.warMatrix[i] = nil
		end
		self.fightNode[i]:removeAllChildren()
		local beginPos = cc.p(self.fields["Node_army" .. i]:getPositionX(), -self.fields["Node_army" .. i]:getPositionY())
		local endPos = cc.p(self.fields.Node_monster:getPositionX(), -self.fields.Node_monster:getPositionY())
		self.warMatrix[i], self.moveLine[i] = self:createArmyNode(beginPos, endPos, i)
		self.warMatrix[i]:setPosition(cc.p(0, 0))
	end
end
function angerMapViewPanel:armyFight()
	for i = 1, 3 do
		self.warMatrix[i]:setPosition(cc.p(0, 0))
		self.warMatrix[i]:beginWorkPre()
		self.warMatrix[i]:beginWork()
	end
end
function angerMapViewPanel:createArmyNode(sp, ep, index)
	local beginPos = cc.p(sp.x - ep.x, sp.y - ep.y)
	local endPos = cc.p(0, 0)
	_ENV, _UPVALUE4_ = 0, 0
	;(0).id = 401
	_ENV, (0).num = nil, 1000
	;(nil).id = 501
	_ENV, (nil).num = nil, 1000
	;(nil).id = 601
	_ENV, (nil).num = nil, 1000
	;(nil).id = 710
	;(nil).num = 1000
	;(0)[1] = 0
	;(0)[2] = nil
	;(0)[3] = nil
	local (0)[4], soldiers = nil, 0
	local troopsMatrix = include("troopsMatrixPreview")
	local warMatrix = troopsMatrix.new()
	warMatrix:setName("warMatrix")
	_ENV, _UPVALUE1_ = nil, 0
	;(nil).armyList = soldiers
	;(0)[1] = nil
	warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), gMapObjTypeDef.mapObjTypeCampsite, 0)
	warMatrix:setVisible(true)
	warMatrix:setTouchEnabled(false)
	warMatrix:setSoliderVisible(true)
	warMatrix:addTo(self.fightNode[index], 1)
	local moveLine = include("worldMapMoveLine").new(beginPos, endPos)
	moveLine:addTo(self.fightNode[index], 0)
	warMatrix:setMoveLine(moveLine)
	_ENV, _ENV = warMatrix, warMatrix.setMoveLine
	warMatrix.distancePrecent = 0.3
	_ENV, warMatrix.setMoveLine[1], warMatrix.time = warMatrix, warMatrix, 10
	warMatrix.distancePrecent = 1
	warMatrix.setMoveLine[2], warMatrix.time = warMatrix, 999999
	local span = warMatrix.setMoveLine
	_ENV = 0
	;(0).currentMoveTime = 10
	;(0).moveTimeSpan = span
	warMatrix:setMoveTimeData(0)
	warMatrix:beginMove(0)
	warMatrix:setPosition(cc.p(0, 0))
	return warMatrix, moveLine
end
function angerMapViewPanel:shakeEffect(target, time, params)
	self.shakeBody = target
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function angerMapViewPanel:dispatchAction(cmdList)
	local delay = function(ticket)
		return ffa.delay(ticket)
	end
	local aFun = function(fun)
		if fun then
			return ffa.callFunc(function()
				fun()
			end)
		else
			return ffa.callFunc(function()
				print("没行为")
			end)
		end
	end
	local monsterSound = function(attackType)
		if gAngrySnowWolfKingAtkType.ATKTYPE_NORMAL == attackType then
			return ffa.callFunc(function()
				SoraDPlaySound("evilPalace", 1)
			end)
		elseif gAngrySnowWolfKingAtkType.ATKTYPE_CRITICAL == attackType then
			return ffa.callFunc(function()
				SoraDPlaySound("evilPalace", 2)
			end)
		end
	end
	_ENV = nil
	;(nil)[1] = delay(2)
	;(nil)[2] = delay(2)
	;(nil)[3] = delay(2)
	;(nil)[4] = delay(2)
	;(nil)[5] = delay(2)
	;(nil)[6] = delay(2)
	;(nil)[7] = delay(2)
	;(nil)[8] = delay(2)
	;(nil)[9] = delay(2)
	;(nil)[10] = delay(2)
	;(nil)[11] = delay(2)
	;(nil)[12] = delay(2)
	;(nil)[13] = delay(2)
	;(nil)[14] = delay(2)
	;(nil)[15] = delay(2)
	;(nil)[16] = delay(2)
	;(nil)[17] = delay(2)
	local actionList = ffa.seq(nil)
	self:armyFight()
	self.nodeMonster:stopAllActions()
	self.fields.Node_monsterInfo:setVisible(true)
	self.isMonsterDieTip = false
	if cmdList.dieout then
		_UPVALUE12_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = aFun(function(...)
			self.fields.Node_monsterInfo:resetBlood()
		end)
		self.fields.Node_monsterInfo[2] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[3] = aFun(self.spMonster.fight)
		self.fields.Node_monsterInfo[4] = monsterSound(gAngrySnowWolfKingAtkType.ATKTYPE_CRITICAL)
		self.fields.Node_monsterInfo[5] = delay(2)
		self.fields.Node_monsterInfo[6] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[7] = delay(2)
		self.fields.Node_monsterInfo[8] = aFun(self.spMonster.dead)
		self.fields.Node_monsterInfo[9] = delay(4)
		self.fields.Node_monsterInfo[10] = aFun(function(...)
			self:initData()
		end)
		self.fields.Node_monsterInfo[11] = aFun(function(...)
			self:initArmy()
		end)
		self.fields.Node_monsterInfo[12] = aFun(function(...)
			self.fields.Node_monsterInfo:setVisible(false)
		end)
		self.fields.Node_monsterInfo[13] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[14] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[15] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[16] = aFun(function(...)
			self.monsterInAction = false
		end)
		actionList = ffa.seq(self.fields.Node_monsterInfo)
	elseif cmdList.die then
		_UPVALUE14_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = aFun(function(...)
			self.fields.Node_monsterInfo:resetBlood()
		end)
		self.fields.Node_monsterInfo[2] = aFun(function(...)
			self.isMonsterDieTip = true
		end)
		self.fields.Node_monsterInfo[3] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[4] = aFun(self.spMonster.fight)
		self.fields.Node_monsterInfo[5] = monsterSound(gAngrySnowWolfKingAtkType.ATKTYPE_CRITICAL)
		self.fields.Node_monsterInfo[6] = delay(2)
		self.fields.Node_monsterInfo[7] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[8] = aFun(self.spMonster.dead)
		self.fields.Node_monsterInfo[9] = delay(1)
		self.fields.Node_monsterInfo[10] = aFun(function(...)
			self:initArmy()
		end)
		self.fields.Node_monsterInfo[11] = aFun(function(...)
			self:initData()
		end)
		self.fields.Node_monsterInfo[12] = ffa.fadeOut(1)
		self.fields.Node_monsterInfo[13] = aFun(self.spMonster.idle)
		self.fields.Node_monsterInfo[14] = ffa.fadeIn(0.5)
		self.fields.Node_monsterInfo[15] = aFun(function(...)
			self.monsterInAction = false
			self.isMonsterDieTip = false
		end)
		self.fields.Node_monsterInfo[16] = aFun(function(...)
			self.monsterInAction = false
			self.isMonsterDieTip = false
		end)
		actionList = ffa.seq(self.fields.Node_monsterInfo)
	elseif self.beforeMonster ~= "idle" and self.beforeMonster ~= "dead" then
		_UPVALUE4_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[2] = monsterSound(gAngrySnowWolfKingAtkType.ATKTYPE_NORMAL)
		self.fields.Node_monsterInfo[3] = aFun(self.spMonster.fight)
		self.fields.Node_monsterInfo[4] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[5] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[6] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[7] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[8] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[9] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[10] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[11] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[12] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[13] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[14] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[15] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[16] = aFun(function(...)
			self.monsterInAction = false
		end)
		actionList = ffa.seq(self.fields.Node_monsterInfo)
	else
		_UPVALUE7_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[2] = monsterSound(gAngrySnowWolfKingAtkType.ATKTYPE_NORMAL)
		self.fields.Node_monsterInfo[3] = delay(2)
		self.fields.Node_monsterInfo[4] = aFun(self.spMonster.fight)
		self.fields.Node_monsterInfo[5] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[6] = delay(2)
		self.fields.Node_monsterInfo[7] = aFun(self.spMonster.fight)
		self.fields.Node_monsterInfo[8] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[9] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[10] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[11] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[12] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[13] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[14] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[15] = aFun(function(...)
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[16] = aFun(function(...)
			self.monsterInAction = false
		end)
		actionList = ffa.seq(self.fields.Node_monsterInfo)
	end
	self.nodeMonster:runAction(actionList)
end
function angerMapViewPanel:btnMonsterClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	uiManager:show("angerDetailView", nil)
end
function angerMapViewPanel:btnLog2Click()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = 2
	;(nil).battleType = self.battleType
	uiManager:show("angerRecordView", nil)
end
function angerMapViewPanel:btnLog1Click()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = 1
	;(nil).battleType = self.battleType
	uiManager:show("angerRecordView", nil)
end
function angerMapViewPanel:judgeTimesOut()
	if self.timesOut then
		SoraDShowMsgTip(i18n("Challenge_SnowWolf_text_04"))
		return false
	else
		return true
	end
end
function angerMapViewPanel:btnNormalClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		if angrySnowWolfKingCtrl:getItemCount() >= self.normalCost then
			SoraDShowLoading(self)
			angrySnowWolfKingCtrl:palaceattackReq(gAngrySnowWolfKingAtkType.ATKTYPE_NORMAL)
		else
			_ENV = i18n("common_text_3405")
			i18n("common_text_3405").item = publicRead.getName(angrySnowWolfKingCtrl:getItemID())
			SoraDShowMsgBox(i18n("common_text_4803", i18n("common_text_3405")), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).itemID = angrySnowWolfKingCtrl:getItemID()
					uiManager:show("CommonSourceGuide", nil)
				end
			end)
		end
	end
end
function angerMapViewPanel:btnSpecialClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		if angrySnowWolfKingCtrl:getItemCount() >= self.eliteCost then
			SoraDShowLoading(self)
			angrySnowWolfKingCtrl:palaceattackReq(gAngrySnowWolfKingAtkType.ATKTYPE_CRITICAL)
		else
			_ENV = i18n("common_text_3405")
			i18n("common_text_3405").item = publicRead.getName(angrySnowWolfKingCtrl:getItemID())
			SoraDShowMsgBox(i18n("common_text_4803", i18n("common_text_3405")), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).itemID = angrySnowWolfKingCtrl:getItemID()
					uiManager:show("CommonSourceGuide", nil)
				end
			end)
		end
	end
end
function angerMapViewPanel:btnAnlaClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		SoraDShowLoading(self)
		angrySnowWolfKingCtrl:palaceattackReq(gAngrySnowWolfKingAtkType.ATKTYPE_NORMAL)
	end
end
function angerMapViewPanel:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("angerSnowWolfExchangeView")
end
function angerMapViewPanel:onClickBuyGift()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("CommonBuyGift", nil)
end
function angerMapViewPanel:onClickOneKey()
	SoraDPlaySound()
	SoraDShowLoading(self)
	angrySnowWolfKingCtrl:reqDecreeReward()
end
function angerMapViewPanel:onHide()
	if self.shakeBody and self.shakeBody.animShaker then
		self.shakeBody.animShaker:stop()
	end
	_ENV = self.shakeBody.animShaker
	self.shakeBody.animShaker.msg = "MESSAGE_UI_SNOW_WOLF_KING_UPDATETIPS"
	SoraDSendMessage(self.shakeBody.animShaker)
end
return angerMapViewPanel
