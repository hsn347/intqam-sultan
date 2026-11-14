local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local activity_9001660_Read = include("activity_9001660_Read")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001660_MapViewPanel = class("Activity_9001660_MapViewPanel", baseFguiPanel)
function Activity_9001660_MapViewPanel:ctor(...)
	Activity_9001660_MapViewPanel.super.ctor(self, ...)
	print("Activity_9001660_MapViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.MUTANT_TENTACLES_ACTIVITY
end
function Activity_9001660_MapViewPanel:onInit()
	print("=======Activity_9001660_MapViewPanel:onInit")
	self.battleType = activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE
	self.normalCost = constantRead.getConstValue("MUTATED_TENTACLES_ITEM_NUM", 10)
	self.eliteCost = self.normalCost * 10
	self.moveLine, _ENV, self.warMatrix, _ENV, self.noticeList, _ENV, self.itemList, _ENV, self.timesOut = self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, false
	self.isNewMsgArrive = false
	self.msgIndex = 1
	self.fightNode, _ENV, self.warInfoTbl, _ENV, self.baseInfoTbl, _ENV, self.beforeMonster = self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, self.normalCost * 10, "idle"
	self.isMonsterDieTip = false
	self.isInit = true
	self.fields.Com_title:initData(i18n("activity_name_9001660"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
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
	self.fields.Button_exchange:setString(i18n("mutated_tentacles_text2"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	for i = 1, 3 do
		self.fightNode[i] = display.newNode()
		self.fields["Node_army" .. i]:setContent(self.fightNode[i])
	end
end
function Activity_9001660_MapViewPanel:onShow()
	print("=======Activity_9001660_MapViewPanel:onShow")
	self.battleType = self.param and self.param.battleType or activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE
	self:req4Start(self.battleType)
	self:pickThreeAward()
	self:updateRed()
end
function Activity_9001660_MapViewPanel:onItemRenderer(index, obj)
	if not self.itemList[index + 1].superaward then
		local _ENV, superaward = self.itemList[index + 1].superaward, self.itemList[index + 1].superaward
	end
	local item = self.itemList[index + 1].item
	local showItem = next(superaward) and superaward or item
	obj:initData(showItem[1], showItem[2])
	obj:showCoolSquare(next(superaward) and true or false)
end
function Activity_9001660_MapViewPanel:updateRed()
	self.fields.Button_exchange:setReddot(activity_9001660_Ctrl:judgeIsEnough(), -1)
end
function Activity_9001660_MapViewPanel:pickThreeAward()
	local serverawardinfo = activity_9001660_Ctrl:getServerAwardInfo()
	if serverawardinfo and next(serverawardinfo) then
		local index = 0
		for i = #serverawardinfo, 1, -1 do
			activity_9001660_Ctrl = nil
			;(nil).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATE_SYSTEMAWARD"
			;(nil).reward = serverawardinfo[i]
			SoraDSendMessage(nil)
			index = index + 1
			if 3 <= index then
				break
			end
		end
	end
end
function Activity_9001660_MapViewPanel:req4Start(monsterType)
	SoraDShowLoading(self)
	self.battleType = monsterType
	activity_9001660_Ctrl:entranceinfoReq(true)
	activity_9001660_Ctrl:enterpalacebattleReq(self.battleType)
	self:initBattleHorn()
	self:initArmy()
	self:initMonster()
end
function Activity_9001660_MapViewPanel:noticeBanner(target, redata)
	dump(redata, "noticeBanner===")
	if redata and redata.reward then
		local txtDes
		if redata.reward.userinfo.allianceName then
			_ENV = nil
			_ENV = nil
			;(nil).abbr = redata.reward.userinfo.allianceName
			;(nil).name = redata.reward.userinfo.nickName
			;(nil).name = i18n("common_text_186", nil)
			;(nil).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
			txtDes = i18n("mutated_tentacles_text12", nil)
		else
			_ENV = nil
			;(nil).name = redata.reward.userinfo.nickName
			;(nil).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
			txtDes = i18n("mutated_tentacles_text12", nil)
		end
		local itemDes = ""
		if next(redata.reward.awarddata.item) then
			_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
			publicRead.getName(activity_9001660_Ctrl:getItemID()).good = publicRead.getName(redata.reward.awarddata.item[1]) .. "*" .. redata.reward.awarddata.item[2]
			itemDes = i18n("common_text_3276", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
		elseif next(redata.reward.awarddata.superaward) then
			_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
			publicRead.getName(activity_9001660_Ctrl:getItemID()).good = publicRead.getName(redata.reward.awarddata.superaward[1]) .. "*" .. redata.reward.awarddata.superaward[2]
			itemDes = i18n("common_text_3276", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
		end
		table.insert(self.noticeList, txtDes .. itemDes)
		self.isNewMsgArrive = true
		self:loopTopInfo()
	end
end
function Activity_9001660_MapViewPanel:loopTopInfo()
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
function Activity_9001660_MapViewPanel:initBattleHorn(target, data)
	self.fields.Com_horn:initData(activity_9001660_Ctrl:getItemID())
end
function Activity_9001660_MapViewPanel:initData(target, data)
	self:justInitData()
	self:initView()
end
function Activity_9001660_MapViewPanel:justInitData()
	SoraDCloseLoading(self)
	self.baseInfoTbl = activity_9001660_Ctrl:getInitInfo()
	self.recentItems = activity_9001660_Ctrl:splitPersonalAward(self.battleType)
	self.warInfoTbl = activity_9001660_Ctrl:getBattleInfo(self.battleType)
	if self.isInit then
		local recordTbl = activity_9001660_Ctrl:getServerAwardInfo()
		for _, data in ipairs(recordTbl) do
			_ENV = nil
			;(nil).name = data.userinfo.nickName
			;(nil).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
			local txtDes = i18n("mutated_tentacles_text12", nil)
			if data.userinfo.allianceName then
				_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
				_ENV = activity_9001660_Ctrl:getItemID()
				activity_9001660_Ctrl:getItemID().abbr = data.userinfo.allianceName
				activity_9001660_Ctrl:getItemID().name = data.userinfo.nickName
				publicRead.getName(activity_9001660_Ctrl:getItemID()).name = i18n("common_text_186", activity_9001660_Ctrl:getItemID())
				publicRead.getName(activity_9001660_Ctrl:getItemID()).item = publicRead.getName(activity_9001660_Ctrl:getItemID())
				txtDes = i18n("mutated_tentacles_text12", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
			end
			local itemDes = ""
			if data.awarddata.item and next(data.awarddata.item) then
				_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
				publicRead.getName(activity_9001660_Ctrl:getItemID()).good = publicRead.getName(data.awarddata.item[1]) .. "*" .. data.awarddata.item[2]
				itemDes = i18n("common_text_3276", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
			elseif data.awarddata.superaward and next(data.awarddata.superaward) then
				_ENV = publicRead.getName(activity_9001660_Ctrl:getItemID())
				publicRead.getName(activity_9001660_Ctrl:getItemID()).good = publicRead.getName(data.awarddata.superaward[1]) .. "*" .. data.awarddata.superaward[2]
				itemDes = i18n("common_text_3276", (publicRead.getName(activity_9001660_Ctrl:getItemID())))
			end
			table.insert(self.noticeList, txtDes .. itemDes)
		end
		self:loopTopInfo()
		self.isInit = false
	end
end
function Activity_9001660_MapViewPanel:attackCB(target, redata)
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
function Activity_9001660_MapViewPanel:dispatchBoxAction(itemlist)
	local _ENV, showList
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
function Activity_9001660_MapViewPanel:changeState(target, data)
	SoraDCloseLoading(self)
	self:initData()
end
function Activity_9001660_MapViewPanel:errCallBack(target, redata)
	SoraDCloseLoading(self)
end
function Activity_9001660_MapViewPanel:initView(ignoreRewardList)
	if not self.warInfoTbl then
		self.timesOut = true
		self.fields.Node_monsterInfo:setVisible(false)
		_ENV = nil
		;(nil).cur = 0
		;(nil).max = activity_9001660_Read.MUTANT_TENTACLES_USERKILL_NORMALMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", nil))
		self.fields.Button_normal:initData(self.normalCost)
		self.fields.Button_special:initData(self.normalCost * activity_9001660_Read.MUTANT_TENTACLES_ELITE_MAXHP)
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
	if activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE == self.battleType then
		_ENV = i18n("%{cur}/%{max}", nil)
		i18n("%{cur}/%{max}", nil).cur = self.warInfoTbl.remainkilltimes
		i18n("%{cur}/%{max}", nil).max = activity_9001660_Read.MUTANT_TENTACLES_USERKILL_NORMALMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)))
	else
		_ENV = i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil))
		i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)).cur = self.warInfoTbl.remainkilltimes
		i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil)).max = activity_9001660_Read.MUTANT_TENTACLES_USERKILL_ELITEMAX
		self.fields.Text_times:setString(i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", i18n("%{cur}/%{max}", nil))))
	end
	if 0 >= self.warInfoTbl.remainkilltimes then
		self.timesOut = true
	else
		self.timesOut = false
	end
end
function Activity_9001660_MapViewPanel:refreshRewardScroll(nowList, addList)
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
function Activity_9001660_MapViewPanel:initMonster()
	local isBigBoss = self.battleType ~= activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE
	self.fields.Node_monsterInfo:setMonsterName(self.battleType == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE and i18n("mutated_tentacles_text1") or i18n("mutated_tentacles_text1"))
	self.fields.Usm_npc:setMaxChunkSize(241280)
	self.fields.Usm_npc:setEffectPath("9001660_npc_cx.usm,9001660_npc_dj.usm")
end
function Activity_9001660_MapViewPanel:initArmy()
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
function Activity_9001660_MapViewPanel:armyFight()
	for i = 1, 3 do
		self.warMatrix[i]:setPosition(cc.p(0, 0))
		self.warMatrix[i]:beginWorkPre()
		self.warMatrix[i]:beginWork()
	end
end
function Activity_9001660_MapViewPanel:createArmyNode(sp, ep, index)
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
function Activity_9001660_MapViewPanel:shakeEffect(target, time, params)
	self.shakeBody = target
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function Activity_9001660_MapViewPanel:dispatchAction(cmdList)
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
		if activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_NORMAL == attackType then
			return ffa.callFunc(function()
				SoraDPlaySound("evilPalace", 1)
			end)
		elseif activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_CRITICAL == attackType then
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
		self.fields.Node_monsterInfo[3] = aFun(function()
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
		end)
		self.fields.Node_monsterInfo[4] = monsterSound(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_CRITICAL)
		self.fields.Node_monsterInfo[5] = delay(2)
		self.fields.Node_monsterInfo[6] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[7] = delay(2)
		self.fields.Node_monsterInfo[8] = aFun(function()
			self.fields.Usm_npc:setEffectPath("9001660_npc_sw.usm", false)
			self.beforeMonster = "dead"
		end)
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
		self.fields.Node_monsterInfo[4] = aFun(function()
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
		end)
		self.fields.Node_monsterInfo[5] = monsterSound(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_CRITICAL)
		self.fields.Node_monsterInfo[6] = delay(2)
		self.fields.Node_monsterInfo[7] = aFun(function(...)
			SoraDPlaySound("worldmap", 3)
		end)
		self.fields.Node_monsterInfo[8] = aFun(function()
			self.fields.Usm_npc:setEffectPath("9001660_npc_sw.usm", false)
			self.beforeMonster = "dead"
		end)
		self.fields.Node_monsterInfo[9] = delay(1)
		self.fields.Node_monsterInfo[10] = aFun(function(...)
			self:initArmy()
		end)
		self.fields.Node_monsterInfo[11] = aFun(function(...)
			self:initData()
		end)
		self.fields.Node_monsterInfo[12] = ffa.fadeOut(1)
		self.fields.Node_monsterInfo[13] = aFun(function()
			self.fields.Usm_npc:setEffectPath("9001660_npc_cx.usm,9001660_npc_dj.usm", true)
			self.beforeMonster = "idle"
		end)
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
		_UPVALUE2_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[2] = monsterSound(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_NORMAL)
		self.fields.Node_monsterInfo[3] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[4] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[5] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[6] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[7] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[8] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[9] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[10] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[11] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[12] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[13] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[14] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[15] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		self.fields.Node_monsterInfo[16] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
			self.monsterInAction = false
		end)
		actionList = ffa.seq(self.fields.Node_monsterInfo)
	else
		_UPVALUE5_ = self.fields.Node_monsterInfo
		self.fields.Node_monsterInfo[1] = ffa.fadeIn(0.1)
		self.fields.Node_monsterInfo[2] = monsterSound(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_NORMAL)
		self.fields.Node_monsterInfo[3] = delay(2)
		self.fields.Node_monsterInfo[4] = aFun(function()
			SoraDPlaySound("worldmap", 3)
			self.fields.Usm_npc:setEffectPath("9001660_npc_gj.usm", true)
			self.beforeMonster = "fight"
		end)
		self.fields.Node_monsterInfo[5] = delay(2)
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
	end
	self.nodeMonster:runAction(actionList)
end
function Activity_9001660_MapViewPanel:btnMonsterClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	uiManager:show("Activity_9001660_DetailView", nil)
end
function Activity_9001660_MapViewPanel:btnLog2Click()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = 2
	;(nil).battleType = self.battleType
	uiManager:show("Activity_9001660_RecordView", nil)
end
function Activity_9001660_MapViewPanel:btnLog1Click()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = 1
	;(nil).battleType = self.battleType
	uiManager:show("Activity_9001660_RecordView", nil)
end
function Activity_9001660_MapViewPanel:judgeTimesOut()
	if self.timesOut then
		SoraDShowMsgTip(i18n("mutated_tentacles_text6"))
		return false
	else
		return true
	end
end
function Activity_9001660_MapViewPanel:btnNormalClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		if activity_9001660_Ctrl:getItemCount() >= self.normalCost then
			SoraDShowLoading(self)
			activity_9001660_Ctrl:palaceattackReq(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_NORMAL)
		else
			_ENV = i18n("common_text_3405")
			i18n("common_text_3405").item = publicRead.getName(activity_9001660_Ctrl:getItemID())
			SoraDShowMsgBox(i18n("common_text_4803", i18n("common_text_3405")), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).itemID = activity_9001660_Ctrl:getItemID()
					uiManager:show("CommonSourceGuide", nil)
				end
			end)
		end
	end
end
function Activity_9001660_MapViewPanel:btnSpecialClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		if activity_9001660_Ctrl:getItemCount() >= self.eliteCost then
			SoraDShowLoading(self)
			activity_9001660_Ctrl:palaceattackReq(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_CRITICAL)
		else
			_ENV = i18n("common_text_3405")
			i18n("common_text_3405").item = publicRead.getName(activity_9001660_Ctrl:getItemID())
			SoraDShowMsgBox(i18n("common_text_4803", i18n("common_text_3405")), i18n("common_text_204"), nil, function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).itemID = activity_9001660_Ctrl:getItemID()
					uiManager:show("CommonSourceGuide", nil)
				end
			end)
		end
	end
end
function Activity_9001660_MapViewPanel:btnAnlaClick()
	SoraDPlaySound()
	if self.isMonsterDieTip then
		SoraDShowMsgTip(i18n("common_text_3405"))
		return
	end
	if self:judgeTimesOut(self.battleType) then
		SoraDShowLoading(self)
		activity_9001660_Ctrl:palaceattackReq(activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_NORMAL)
	end
end
function Activity_9001660_MapViewPanel:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001660_ExchangeView")
end
function Activity_9001660_MapViewPanel:onHide()
	if self.shakeBody and self.shakeBody.animShaker then
		self.shakeBody.animShaker:stop()
	end
	_ENV = self.shakeBody.animShaker
	self.shakeBody.animShaker.msg = "MESSAGE_UI_MUTANT_TENTACLES_UPDATETIPS"
	SoraDSendMessage(self.shakeBody.animShaker)
end
function Activity_9001660_MapViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("mutated_tentacles_rule01")
	uiManager:show("RuleView", nil)
end
return Activity_9001660_MapViewPanel
