local constantRead = include("constantRead")
local beastCanyonRead = include("beastCanyonRead")
local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonFightPanel = class("BeastCanyonFightPanel", baseFguiPanel)
_ENV, _UPVALUE3_, BeastCanyonFightPanel.ctor = baseFguiPanel, function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end, function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end
_UPVALUE3_, baseFguiPanel.loadImg = nil, "worldMapBossAtlantis3"
_UPVALUE3_, baseFguiPanel.dj, (nil)[1] = nil, nil, "shmcclr_dj_ws_%02d.png"
_UPVALUE3_, baseFguiPanel.dj, (nil)[2] = nil, nil, 24
_UPVALUE3_, baseFguiPanel.dj, (nil)[3] = nil, nil, 5
_UPVALUE3_, baseFguiPanel.gj, (nil)[1] = nil, nil, "shmcclr_gj_ws_%02d.png"
_UPVALUE3_, baseFguiPanel.gj, (nil)[2] = nil, nil, 24
_UPVALUE3_, baseFguiPanel.gj, (nil)[3] = nil, nil, 5
_ENV, baseFguiPanel.sj, (nil)[1] = nil, nil, "clr_sj_ws_%02d.png"
_ENV, baseFguiPanel.sj, (nil)[2] = nil, nil, 16
_ENV, baseFguiPanel.sj, (nil)[3] = nil, nil, 2
_UPVALUE3_, (nil).loadImg = "clr_sj_ws_%02d.png", "worldMapBossSnowman"
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[1] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", "wjsl_dj_ws_%02d.png"
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[2] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 24
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[3] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 5
_UPVALUE3_, (nil).gj, ("clr_sj_ws_%02d.png")[1] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", "wjsl_gj_ws_%02d.png"
_UPVALUE3_, (nil).gj, ("clr_sj_ws_%02d.png")[2] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 24
_UPVALUE3_, (nil).gj, ("clr_sj_ws_%02d.png")[3] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 5
_ENV, (nil).sj, ("clr_sj_ws_%02d.png")[1] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png"
_ENV, (nil).sj, ("clr_sj_ws_%02d.png")[2] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 16
_ENV, (nil).sj, ("clr_sj_ws_%02d.png")[3] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 2
_UPVALUE3_, ("clr_sj_ws_%02d.png").loadImg = "wjsl_sj_ws_%02d.png", "worldMapBossRemain2"
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("wjsl_sj_ws_%02d.png")[1] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", "esboss_dj_ws_%02d.png"
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("wjsl_sj_ws_%02d.png")[2] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", 24
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("wjsl_sj_ws_%02d.png")[3] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", 5
_UPVALUE3_, ("clr_sj_ws_%02d.png").gj, ("wjsl_sj_ws_%02d.png")[1] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", "esboss_gj_ws_%02d.png"
_UPVALUE3_, ("clr_sj_ws_%02d.png").gj, ("wjsl_sj_ws_%02d.png")[2] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", 24
_UPVALUE3_, ("clr_sj_ws_%02d.png").gj, ("wjsl_sj_ws_%02d.png")[3] = "wjsl_sj_ws_%02d.png", "wjsl_sj_ws_%02d.png", 5
;("clr_sj_ws_%02d.png").sj, ("wjsl_sj_ws_%02d.png")[1] = "wjsl_sj_ws_%02d.png", "esboss_sj_ws_%02d.png"
;("clr_sj_ws_%02d.png").sj, ("wjsl_sj_ws_%02d.png")[2] = "wjsl_sj_ws_%02d.png", 16
;("clr_sj_ws_%02d.png").sj, ("wjsl_sj_ws_%02d.png")[3] = "wjsl_sj_ws_%02d.png", 2
_UPVALUE3_, _ENV, _UPVALUE3_, (function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end)[1] = "clr_sj_ws_%02d.png", nil, baseFguiPanel, baseFguiPanel
_UPVALUE3_, _ENV, _UPVALUE3_, (function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end)[2] = "clr_sj_ws_%02d.png", nil, baseFguiPanel
local _UPVALUE3_, _ENV, _UPVALUE3_, (function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end)[3], bossShowConfig = "clr_sj_ws_%02d.png", nil, baseFguiPanel, "clr_sj_ws_%02d.png", function(self, ...)
	self.super.ctor(self, ...)
	print("BeastCanyonFightPanel:ctor", self.viewName)
end
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[1] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", "huolong_dj_ws_%02d.png"
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[2] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 24
_UPVALUE3_, (nil).dj, ("clr_sj_ws_%02d.png")[3] = "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 5
_UPVALUE3_, _ENV, (nil).gj, ("clr_sj_ws_%02d.png")[1] = "huolong_gj_ws_%02d.png", "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", "huolong_gj_ws_%02d.png"
_UPVALUE3_, _ENV, (nil).gj, ("clr_sj_ws_%02d.png")[2] = "huolong_gj_ws_%02d.png", "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 24
_UPVALUE3_, _ENV, (nil).gj, ("clr_sj_ws_%02d.png")[3] = "huolong_gj_ws_%02d.png", "clr_sj_ws_%02d.png", "clr_sj_ws_%02d.png", 5
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("huolong_gj_ws_%02d.png")[1] = "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", "langguai_dj_ws_%02d.png"
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("huolong_gj_ws_%02d.png")[2] = "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", 24
_UPVALUE3_, ("clr_sj_ws_%02d.png").dj, ("huolong_gj_ws_%02d.png")[3] = "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", 5
_UPVALUE2_, _ENV, ("clr_sj_ws_%02d.png").gj, ("huolong_gj_ws_%02d.png")[1] = "langguai_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", "langguai_gj_ws_%02d.png"
_UPVALUE2_, _ENV, ("clr_sj_ws_%02d.png").gj, ("huolong_gj_ws_%02d.png")[2] = "langguai_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", 24
_UPVALUE2_, _ENV, ("clr_sj_ws_%02d.png").gj, ("huolong_gj_ws_%02d.png")[3] = "langguai_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", "huolong_gj_ws_%02d.png", 5
_UPVALUE3_, ("huolong_gj_ws_%02d.png").loadImgs, ("langguai_gj_ws_%02d.png")[1] = "langguai_gj_ws_%02d.png", "langguai_gj_ws_%02d.png", "worldMapLegendOfPegasus"
_UPVALUE3_, ("huolong_gj_ws_%02d.png").loadImgs, ("langguai_gj_ws_%02d.png")[2] = "langguai_gj_ws_%02d.png", "langguai_gj_ws_%02d.png", "worldMapLegendOfPegasus2"
_UPVALUE3_, ("huolong_gj_ws_%02d.png").dj, ("langguai_gj_ws_%02d.png")[1] = "langguai_gj_ws_%02d.png", "langguai_gj_ws_%02d.png", "bjss_dj_ws_%02d.png"
_UPVALUE3_, ("huolong_gj_ws_%02d.png").dj, ("langguai_gj_ws_%02d.png")[2] = "langguai_gj_ws_%02d.png", "langguai_gj_ws_%02d.png", 24
_UPVALUE3_, ("huolong_gj_ws_%02d.png").dj, ("langguai_gj_ws_%02d.png")[3] = "langguai_gj_ws_%02d.png", "langguai_gj_ws_%02d.png", 5
;("huolong_gj_ws_%02d.png").gj, ("langguai_gj_ws_%02d.png")[1] = "langguai_gj_ws_%02d.png", "bjss_gj_ws_%02d.png"
;("huolong_gj_ws_%02d.png").gj, ("langguai_gj_ws_%02d.png")[2] = "langguai_gj_ws_%02d.png", 24
;("huolong_gj_ws_%02d.png").gj, ("langguai_gj_ws_%02d.png")[3] = "langguai_gj_ws_%02d.png", 5
baseFguiPanel[1] = nil
baseFguiPanel[2] = "clr_sj_ws_%02d.png"
local baseFguiPanel[3], bossShowConfig_9001650 = "huolong_gj_ws_%02d.png", baseFguiPanel
function BeastCanyonFightPanel:downloadImage(showCfg)
	if not showCfg.loadImg and not showCfg.loadImgs then
		return
	end
	local isExist = true
	if showCfg.loadImg then
		isExist = SoraDIsFileExistByKey(showCfg.loadImg)
	elseif showCfg.loadImgs then
		for __, loadImg in ipairs(showCfg.loadImgs) do
			if not SoraDIsFileExistByKey(loadImg) then
				isExist = false
			end
		end
	end
	if isExist then
		SoraDShowLoading(self)
		local _ENV, imgArray = SoraDShowLoading, SoraDShowLoading
		if showCfg.loadImg then
			_ENV = nil
			;(nil).name = "worldMap/" .. showCfg.loadImg
			table.insert(imgArray, nil)
		elseif showCfg.loadImgs then
			for __, loadImg in ipairs(showCfg.loadImgs) do
				_ENV = nil
				;(nil).name = "worldMap/" .. loadImg
				table.insert(imgArray, nil)
			end
		end
		self.proxy:loadImages(imgArray, function()
			if tolua.isnull(self) then
				return
			end
			self:setBossAnimation(showCfg.dj, function()
			end, -1)
			SoraDCloseLoading(self)
		end)
	end
end
function BeastCanyonFightPanel:onInit()
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		self.gameTime = constantRead.getConstValue("ELITEBEASTCANYON_BATTLE_TIME", 10000) / 1000
		self.oneTime = constantRead.getConstValue("ELITEBEASTCANYON_CD_TIME", 5000) / 1000
	else
		self.gameTime = constantRead.getConstValue("DIVINEBEASTCANYON_BATTLE_TIME", 10000) / 1000
		self.oneTime = constantRead.getConstValue("DIVINEBEASTCANYON_CD_TIME", 5000) / 1000
	end
	self.damageTime = math.floor(self.gameTime / self.oneTime)
	self.bossType = self.proxy.param.bossType
	local _ENV, showCfg = self.proxy.param.bossType, self.proxy.param.bossType
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		showCfg = bossShowConfig_9001650[self.bossType]
	else
		showCfg = bossShowConfig[self.bossType]
	end
	self.showCfg = showCfg
	self:downloadImage(self.showCfg)
	print("=======BeastCanyonFightPanel:onInit")
	self.movieLineList, _ENV, self.movieItemList, _ENV, self.challengeRewardList, _ENV = print, print, print, print, print, print
	self.bossConfig = beastCanyonRead.getBossConfigByBossType(self.activityID, self.bossType)
	self.fields.Com_title:initData(i18n(self.bossConfig.name), handler(self, self.onClickClose))
	self.rewardList = self.bossConfig.rewardShow
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).name = i18n(self.bossConfig.bossName)
	handler(self, self.onItemRederer).tips = i18n(self.bossConfig.tips)
	self.fields.Text_Name:setString(i18n("Divinebeastcanyon_text_12", handler(self, self.onItemRederer)))
	self.fields.Button_Sweep:setString(i18n("epicbattle_btn_01"))
	self.fields.Button_Challege:setString(i18n("arena_btn_04"))
	self.fields.Button_Sweep:addClickListener(handler(self, self.onClickSweep))
	self.fields.Button_Challege:addClickListener(handler(self, self.onClickChallenge))
	self.fields.Label_TimeLeft:getChild("Button_Add"):addClickListener(handler(self, self.onClickAdd))
	self.fields.Text_ChallengeTip:setString(i18n("alliance_hunt_text_30"))
	self.fields.Movie_Line:setAllFrameName("dh_xiagufei_%02d.png", 1)
	self.fields.Movie_Line:fixPos()
	self.fields.Movie_Line:setVisible(false)
	self.fields.Movie_Item:setAllFrameName("dh_llk1_%02d.png", 1)
	self.fields.Movie_Item:setVisible(false)
	self.movieItemList[1] = self.fields.Movie_Item
	self.movieLineList[1] = self.fields.Movie_Line
	self.fightNode = display.newNode()
	self.fields.Load_Soldier:setContent(self.fightNode)
end
function BeastCanyonFightPanel:onShow()
	print("=======BeastCanyonFightPanel:onShow")
	_ENV = nil
	;(nil).byUID = true
	self.isSkip = SoraDConfigGet("Game:BeastCanyon:switch~bool", nil) or false
	self.fields.Com_skip:initData(self.isSkip, i18n("Canyon_Treasur_text_27"), handler(self, self.onClickSkip))
	self:updateChallenge()
	self:updateView()
end
function BeastCanyonFightPanel:onClickSkip(ret)
	self.isSkip = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:BeastCanyon:switch~bool", self.isSkip, nil)
end
function BeastCanyonFightPanel:updateChallenge()
	self.challengeNum = beastCanyonCtrl:getChallengeTimes(self.activityID)
	beastCanyonCtrl = nil
	beastCanyonCtrl, beastCanyonCtrl, (nil).num = nil, self.challengeNum, self.challengeNum
	beastCanyonCtrl, self.challengeNum.num, (nil).color = nil, nil, self.challengeNum > 0 and "#FFFBD5" or "#FF0000"
	self.challengeNum.__default, (nil).color = nil, "#FFFBD5"
	self.fields.Label_TimeLeft:setString(i18n_html("Divinebeastcanyon_text_5", nil, self.challengeNum))
end
function BeastCanyonFightPanel:updateView(isChallenge, reward)
	self.isChallenge = isChallenge
	self.controllers.c1:setSelectedIndex(not (not self.isChallenge or self.isSkip) and 1 or 0)
	self.controllers.c2:setSelectedIndex(not beastCanyonCtrl:getTodayMaxLoseLife(self.activityID, self.bossType) and 0 or 1)
	if self.isChallenge then
		if not self.isSkip then
			self.fields.Text_Reward:setString(i18n("feast_the_world_text_14"))
			self.challengeRewardList, beastCanyonCtrl, self.lastIndex = self.fields.Text_Reward.setString, self.fields.Text_Reward.setString, 0
			self.challengeReward = beastCanyonCtrl:getRewardList(self.activityID)
			self.fields.List:setNumItems(#self.challengeRewardList)
			self.fields.Com_Bar:resetBar()
			self:beginFight()
		else
			self.fields.Text_Reward:setString(i18n("common_text_488"))
			self.fields.List:setNumItems(#self.rewardList)
			self.challengeRewardList = reward
			beastCanyonCtrl = i18n("common_text_488")
			i18n("common_text_488").resultType = 1
			i18n("common_text_488").bossType = self.bossType
			i18n("common_text_488").reward = self.challengeRewardList
			i18n("common_text_488").damage = beastCanyonCtrl:getLoseLife(self.activityID)
			uiManager:show("BeastCanyonResult", i18n("common_text_488"))
		end
	else
		self:setBossAnimation(self.showCfg.dj, function()
		end, -1)
		self.challengeReward, beastCanyonCtrl, self.challengeRewardList, beastCanyonCtrl = self.setBossAnimation, self.setBossAnimation, self.setBossAnimation, self.setBossAnimation
		self.fields.Text_Reward:setString(i18n("common_text_488"))
		self.fields.List:setNumItems(#self.rewardList)
		self.fightNode:removeAllChildren()
	end
end
function BeastCanyonFightPanel:beginFight()
	self.oneBlood = math.ceil(beastCanyonCtrl:getLoseLife(self.activityID) / self.damageTime)
	print("self.damageTime", self.damageTime)
	self.fields.Text_blood:setString(string.format("-%s", string.formatnumberthousands(self.oneBlood)))
	self:playBlood()
	self.fields.Com_Bar:runDamageAction(self.activityID, self.bossType, self.oneBlood)
	self.dtTime = 0
	self.playTime = 1
	self.dtOneTime = 0
	self.gameTimer = SoradCreateTimer(self, handler(self, self.updateTime), true)
	self.armyTroop = self:createArmyTroop(cc.p(0, 100), cc.p(0, 300))
	self.armyTroop:beginWork()
	self:playGj()
end
function BeastCanyonFightPanel:playGj()
	SoraDPlaySound("worldmap", 3)
	if self.showCfg.sj then
		self:setBossAnimation(self.showCfg.gj, handler(self, self.playSj))
	else
		self:setBossAnimation(self.showCfg.gj, function()
		end, -1)
	end
end
function BeastCanyonFightPanel:playSj()
	self:setBossAnimation(self.showCfg.sj, handler(self, self.playGj))
end
function BeastCanyonFightPanel:updateTime(dt)
	if self.gameTime <= self.dtTime then
		if self.gameTimer then
			SoraDManagerRemoveTimer(self, self.gameTimer)
			self.gameTimer = nil
		end
		_ENV = nil
		;(nil).resultType = 1
		;(nil).bossType = self.bossType
		;(nil).reward = self.challengeRewardList
		;(nil).damage = beastCanyonCtrl:getLoseLife(self.activityID)
		uiManager:show("BeastCanyonResult", nil)
		self:updateView()
		return
	end
	self.dtOneTime = self.dtOneTime + dt
	print("dt", self.dtOneTime, dt, self.oneTime)
	if self.oneTime <= self.dtOneTime and self.playTime < self.damageTime then
		self.dtOneTime = 0
		self.playTime = self.playTime + 1
		if self.playTime == self.damageTime then
			self.fields.Text_blood:setString(string.format("-%s", string.formatnumberthousands(beastCanyonCtrl:getLoseLife(self.activityID) - (self.damageTime - 1) * self.oneBlood)))
		end
		self:playBlood()
		self.fields.Com_Bar:runDamageAction(self.activityID, self.bossType, self.oneBlood)
	end
	self.dtTime = self.dtTime + dt
	self.fields.Label_Time:setString(SoraDConvertSecondToString(self.gameTime - self.dtTime))
end
function BeastCanyonFightPanel:onItemRederer(index, target)
	local isChallenge = self.isChallenge and not self.isSkip
	local id = isChallenge and self.challengeRewardList[index + 1].id or self.rewardList[index + 1]
	local count = isChallenge and self.challengeRewardList[index + 1].count or 0
	target:initData(id, count)
end
function BeastCanyonFightPanel:onClickAdd(content, noSound)
	if not noSound then
		SoraDPlaySound()
	end
	local buyNum = beastCanyonCtrl:getBuyTimes(self.activityID)
	local max = constantRead.getConstValue("DIVINEBEASTCANYON_BASE_BUYNUM", 5)
	if buyNum >= max then
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_6"))
	else
		_ENV = i18n("Divinebeastcanyon_text_6")
		i18n("Divinebeastcanyon_text_6").activityID = self.activityID
		uiManager:show("BeastCanyonBuyPop", i18n("Divinebeastcanyon_text_6"))
	end
end
function BeastCanyonFightPanel:checkBuyTimes()
	local buyNum = beastCanyonCtrl:getBuyTimes(self.activityID)
	local max = constantRead.getConstValue("DIVINEBEASTCANYON_BASE_BUYNUM", 5)
	if buyNum >= max then
		beastCanyonCtrl = nil
		;(nil).time = os.date("!%H:%M:%S", beastCanyonCtrl:getNextAddTime(self.activityID) - serviceFunctions.systemTime())
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_43", nil))
	else
		beastCanyonCtrl = i18n("Divinebeastcanyon_text_43", nil)
		i18n("Divinebeastcanyon_text_43", nil).activityID = self.activityID
		uiManager:show("BeastCanyonBuyPop", i18n("Divinebeastcanyon_text_43", nil))
	end
end
function BeastCanyonFightPanel:onClickSweep()
	SoraDPlaySound()
	if not self:checkOpen() then
		_ENV = nil
		;(nil).name = i18n(self.bossConfig.name)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_15", nil))
		self:close()
		return
	end
	if not beastCanyonCtrl:getTodayMaxLoseLife(self.activityID, self.bossType) then
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_16"))
	end
	if beastCanyonCtrl:getChallengeTimes(self.activityID) <= 0 then
		self:checkBuyTimes()
		return
	end
	_ENV = i18n("Divinebeastcanyon_text_16")
	i18n("Divinebeastcanyon_text_16").activityID = self.activityID
	i18n("Divinebeastcanyon_text_16").bossType = self.bossType
	uiManager:show("BeastCanyonSweep", i18n("Divinebeastcanyon_text_16"))
end
function BeastCanyonFightPanel:onClickChallenge()
	SoraDPlaySound()
	if not self:checkOpen() then
		_ENV = nil
		;(nil).name = i18n(self.bossConfig.name)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_15", nil))
		self:close()
		return
	end
	if beastCanyonCtrl:getChallengeTimes(self.activityID) <= 0 then
		self:checkBuyTimes()
		return
	end
	local dispatchPanel = uiManager:show("WorldDispatchArmyView")
	_ENV = i18n("Divinebeastcanyon_text_15", nil)
	i18n("Divinebeastcanyon_text_15", nil).isBeastCanyon = self.activityID
	i18n("Divinebeastcanyon_text_15", nil).targetID = self.bossType
	dispatchPanel:initData(i18n("Divinebeastcanyon_text_15", nil))
end
function BeastCanyonFightPanel:checkOpen()
	local weekDay = serviceFunctions.getWeekDayEx()
	for i, v in ipairs(self.bossConfig.open) do
		if v == weekDay then
			return true
		end
	end
	return false
end
function BeastCanyonFightPanel:playBlood()
	self.fields.Text_blood:getTransition("t0"):play()
end
function BeastCanyonFightPanel:addBoxReward(newIndex)
	local _ENV, indexList
	if self.challengeReward then
		for k = self.lastIndex + 1, newIndex do
			local info = self.challengeReward[k]
			for i, v in ipairs(info) do
				local _idx = self:isOwnReward(v[1].id)
				if _idx then
					self.challengeRewardList[_idx].count = self.challengeRewardList[_idx].count + v[1].count
				else
					table.insert(self.challengeRewardList, v[1])
					_idx = #self.challengeRewardList
				end
				if k == newIndex then
					table.insert(indexList, _idx)
				end
			end
		end
	end
	self.fields.List:setNumItems(#self.challengeRewardList)
	for i, v in ipairs(indexList) do
		local child = self.fields.List:getChildAt(v - 1)
		local pos = child:localToGlobal(cc.p(40, 40))
		pos = self:globalToLocal(pos)
		local movieLine = self.movieLineList[i]
		if not movieLine then
			movieLine = self.fields.Movie_Line:clone()
			movieLine:addTo(self.fields.Movie_Line:getParent())
			movieLine:setAnchorPoint(0.5, 1)
			movieLine:setPosition(self.fields.Movie_Line:getPosition())
			self.movieLineList[i] = movieLine
		end
		movieLine:setVisible(false)
		local rotation = math.atan2(pos.y - movieLine:getPositionY(), pos.x - movieLine:getPositionX())
		local distance = cc.pGetDistance(pos, movieLine:getPosition()) + 50
		movieLine:setRotation(math.radian2angle(rotation) - 90)
		movieLine:setScaleY(distance / 650)
		local movieItem = self.movieItemList[i]
		if not movieItem then
			movieItem = self.fields.Movie_Item:clone()
			movieItem:addTo(self.fields.Movie_Item:getParent())
			movieItem:setAnchorPoint(0.5, 0.5)
			movieItem:setScale(0.7)
			self.movieItemList[i] = movieItem
		end
		movieItem:setVisible(false)
		movieItem:setPosition(pos)
		print("child:pos ", rotation, math.radian2angle(rotation), pos.x, pos.y, movieLine:getPositionX(), movieLine:getPositionY())
	end
	for i, v in ipairs(indexList) do
		self.movieLineList[i]:setVisible(true)
		self.movieLineList[i]:setPlaySettings(0, -1, 1, -1)
	end
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(0.3)
	;(nil)[2] = ffa.callFunc(function()
		for i, v in ipairs(indexList) do
			self.movieItemList[i]:setVisible(true)
			self.movieItemList[i]:setPlaySettings(0, -1, 1, -1)
		end
	end)
	;(nil)[3] = ffa.delay(0.7)
	;(nil)[4] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[5] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[6] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[7] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[8] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[9] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[10] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[11] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[12] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[13] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[14] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[15] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	;(nil)[16] = ffa.callFunc(function()
		for i, v in ipairs(self.movieLineList) do
			v:setVisible(false)
		end
		for i, v in ipairs(self.movieItemList) do
			v:setVisible(false)
		end
	end)
	self:runAction(ffa.seq(nil))
	self.lastIndex = newIndex
end
function BeastCanyonFightPanel:isOwnReward(id)
	for i, v in ipairs(self.challengeRewardList) do
		if v.id == id then
			return i
		end
	end
end
function BeastCanyonFightPanel:createArmyTroop(sp, ep)
	local beginPos = sp
	local endPos = ep
	_ENV, _UPVALUE4_ = nil, nil
	;(nil).id = 401
	_ENV, (nil).num = nil, 10000
	;(nil).id = 501
	_ENV, (nil).num = nil, 10000
	;(nil).id = 601
	_ENV, (nil).num = nil, 10000
	;(nil).id = 710
	;(nil).num = 10000
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	local (nil)[4], soldiers
	local troopsMatrix = include("troopsMatrixHeroTrial")
	local warMatrix = troopsMatrix.new()
	self.fightNode:addChild(warMatrix, 11)
	_ENV, _UPVALUE1_ = nil, 0
	;(nil).armyList = soldiers
	;(0)[1] = nil
	warMatrix:initData(beginPos, endPos, cc.p(0, 0), cc.p(0, 0), gMapObjTypeDef.mapObjTypeBattery, 0, nil, 120)
	warMatrix:setPosition(beginPos)
	warMatrix:setVisible(true)
	warMatrix:setTouchEnabled(false)
	warMatrix:setScale(1.5)
	warMatrix:setSoliderVisible(true)
	local moveLine = include("worldMapMoveLine").new(beginPos, endPos)
	self.fightNode:addChild(moveLine, 10)
	warMatrix:setMoveLine(moveLine)
	_ENV, _ENV = warMatrix, warMatrix.setMoveLine
	warMatrix.distancePrecent = 0.9
	_ENV, warMatrix.setMoveLine[1], warMatrix.time = warMatrix, warMatrix, 1
	warMatrix.distancePrecent = 1
	warMatrix.setMoveLine[2], warMatrix.time = warMatrix, 9999
	local span = warMatrix.setMoveLine
	_ENV = 10
	;(10).currentMoveTime = 0
	;(10).moveTimeSpan = span
	warMatrix:setMoveTimeData(10)
	warMatrix:beginMove(0)
	return warMatrix
end
function BeastCanyonFightPanel:setBossAnimation(config, callback, time)
	_UPVALUE3_ = nil
	self.lastBossAnimation, (nil)[1] = nil, config
	self.lastBossAnimation, (nil)[2] = nil, callback
	self.lastBossAnimation, (nil)[3] = nil, time
	dump(self.lastBossAnimation, "self.lastBossAnimation")
	local framesNpc = display.newFrames(config[1], 1, config[2])
	local animationNpc = display.newAnimation(framesNpc, config[3] / 60)
	self.fields.Movie_Boss:setAnimation(animationNpc)
	if callback then
		self.fields.Movie_Boss:setPlaySettings(0, -1, time or 1, -1, callback)
	end
end
function BeastCanyonFightPanel:onDownloadSuccess(key)
	if not self.lastBossAnimation then
		return
	end
	if self.showCfg.loadImg and key == self.showCfg.loadImg then
		self:setBossAnimation(self.lastBossAnimation[1], self.lastBossAnimation[2], self.lastBossAnimation[3])
	elseif self.showCfg.loadImgs then
		for __, loadImg in ipairs(self.showCfg.loadImgs) do
			if key == loadImg then
				self:setBossAnimation(self.lastBossAnimation[1], self.lastBossAnimation[2], self.lastBossAnimation[3])
				return
			end
		end
	end
end
return BeastCanyonFightPanel
