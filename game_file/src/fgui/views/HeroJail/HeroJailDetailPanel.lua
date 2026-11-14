local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local worldMapWarDef = include("worldMapWarDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJailDetailPanel = class("HeroJailDetailPanel", baseFguiPanel)
function HeroJailDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroJailDetailPanel:ctor", self.viewName)
end
function HeroJailDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroJailDetailPanel:onInit()
	print("=======HeroJailDetailPanel:onInit")
	self.heroFlagID = self.proxy.param.heroFlagID
	self.heroID = self.proxy.param.heroID
	self.fields.Label_reward:fixChildrenPos()
	if self.heroID then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Label_reward:getChild("Text_realGain"):setString(i18n("hero_text_85"))
		self.fields.Label_reward:getChild("Text_realGain"):setColor(cc.c3b(255, 251, 213))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Com_title:initData(i18n("prison_text_09"), handler(self, self.onClickMyClose))
	self.txtLoadBar = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.fields.Button_release:setString(i18n("prison_btn_05"))
	self.fields.Button_setMoney:setString(i18n("prison_btn_03"))
	self.fields.Button_msg:setString(i18n("prison_btn_02"))
	self.fields.Text_lordInfoTip:setString(i18n("hero_text_93"))
	self.fields.Button_break:setString(i18n("hero_text_86"))
	self.fields.Button_postReward:setString(i18n("hero_btn_02"))
	self.fields.Button_release:addClickListener(handler(self, self.btnReleaseClick))
	self.fields.Button_setMoney:addClickListener(handler(self, self.btnSetMoneyClick))
	self.fields.Button_msg:addClickListener(handler(self, self.btnMsgClick))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.Com_head:setHandle(handler(self, self.btnLordClick))
	self.fields.Button_break:addClickListener(handler(self, self.btnBreakClick))
	self.fields.Button_postReward:addClickListener(handler(self, self.btnPostRewardClick))
	self.fields.Progress_Stage:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Text_lordPos:addClickListener(handler(self, self.onClickPos))
	self.fields.Panel_touch:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onInClick))
	self.fields.Panel_touch:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.Button_lArrow:addClickListener(handler(self, self.btnLHeroClick))
	self.fields.Button_rArrow:addClickListener(handler(self, self.btnRHeroClick))
end
function HeroJailDetailPanel:onShow()
	print("=======HeroJailDetailPanel:onShow")
	self:initData()
end
function HeroJailDetailPanel:initData()
	if not self:refreshData() then
		return
	end
	heroltCtrl:playHeroSound(self.heroID)
	self:initView()
end
function HeroJailDetailPanel:refreshData(...)
	if self:isMyHeroJail() then
		self.heroJailInfo = heroJailCtrl:getHerosInOtherPrisonByID(self.heroID)
	else
		self.heroJailInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
		self.heroID = self.heroJailInfo.heroID
	end
	if not self.heroJailInfo then
		self:close()
		return false
	end
	dump(self.heroJailInfo, "self.heroJailInfo")
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.state, self.leftTime, self.totalTime = heroJailCtrl.getJailStateWithTime(self.heroJailInfo)
	if self.totalTime then
		self.fields.Progress_Stage:setMax(self.totalTime)
	end
	self:req4lordInfo()
	if self:isMyHeroJail() then
		self:req4lordRewardInfo()
	end
	return true
end
function HeroJailDetailPanel:initView(...)
	self:initHeadSpine()
	self:initSetRasnsom()
	self:initLoadingBar()
end
function HeroJailDetailPanel:initSetRasnsom()
	self.fields.Com_ransomBoard:initData(self.heroJailInfo.ransomData)
	if self:isMyHeroJail() then
		self.fields.Button_setMoney:setString(i18n("hero_btn_03"))
		self.fields.Label_reward:setIcon(publicRead.getSmallIcon(self.heroJailInfo.rewardData.id or gHeroRansomRes[1]))
		self.fields.Label_reward:setText(string.formatnumberthousands(math.floor((self.heroJailInfo.rewardData.num or 0) * (1 - gHeroRansomTax))))
	elseif next(self.heroJailInfo.ransomData) then
		self.fields.Button_setMoney:setString(i18n("prison_btn_04"))
	else
		self.fields.Button_setMoney:setString(i18n("prison_btn_03"))
	end
end
function HeroJailDetailPanel:initHeadSpine()
	local dressID = self.heroJailInfo.dressID or heroCtrl:getHeroDressSeting(self.heroID)
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:clearEffect()
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], cfg.detail[3]))
	end
	self.fields.Text_heroName:setString(i18n(self.heroDesInfo.herName))
end
function HeroJailDetailPanel:initLoadingBar(...)
	local stateDes = i18n("prison_text_06")
	if gHeroJailState.waiting == self.state then
		stateDes = i18n("prison_text_06")
	elseif gHeroJailState.execute == self.state then
		stateDes = i18n("prison_text_08")
		self:changeRelease2Execute(true)
	elseif gHeroJailState.escape == self.state then
		stateDes = i18n("prison_text_07")
	end
	self.txtLoadBar:setColor(heroltCtrl.getJailStateColor(self.state))
	self.fields.Progress_Stage:getController("c1"):setSelectedIndex(self.state)
	self.txtLoadBar:setTimeLast(function(showTime, ticket)
		self.fields.Progress_Stage:setValue(self.totalTime - ticket)
		return stateDes .. " " .. showTime
	end)
	self.txtLoadBar:setTimeEndListener(function(...)
		self:refreshData()
		self:initLoadingBar()
	end)
	self.txtLoadBar:beginTime(self.leftTime + 1)
end
function HeroJailDetailPanel:initTurnBtn(...)
	local lb, rb = self:getLeftOrRightHeroID()
	print("lb=", lb, "rb=", rb)
	self.fields.Button_lArrow:setVisible(not not lb)
	self.fields.Button_rArrow:setVisible(not not rb)
end
function HeroJailDetailPanel:initLordInfo(lordInfo)
	self.otherLordInfo = lordInfo
	self.fields.Com_head:setHeadSprite(lordInfo.base.imageId, lordInfo.base.avatar)
	local kingdom = lordInfo.base.sourceKid > 0 and lordInfo.base.sourceKid or lordInfo.base.partition
	if lordInfo.abbr and lordInfo.abbr ~= "" then
		_ENV = lordInfo.base.avatar
		lordInfo.base.avatar.name = lordInfo.base.nickName
		lordInfo.base.avatar.abbr = lordInfo.abbr
		if i18n("common_text_186", lordInfo.base.avatar) then
			goto lbl_39
		end
	end
	local showName = lordInfo.base.nickName
	::lbl_39::
	_ENV = nil
	;(nil).kid = kingdom
	showName = showName .. "#" .. i18n("common_text_342", nil)
	self.fields.Text_lordName:setString(showName)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(lordInfo.fcInfo.totalFc)
	self.fields.Text_lordForce:setString(i18n("common_text_555", nil))
	_ENV = i18n("common_text_555", nil)
	i18n("common_text_555", nil).kills = string.formatnumberthousands(lordInfo.fcInfo.killCount)
	self.fields.Text_lordKillNum:setString(i18n("common_text_344", i18n("common_text_555", nil)))
	if self:isMyHeroJail() and lordInfo.base.pos then
		local isNotice = false
		local warName
		local isQuit = false
		local selfLordInfo = lordInfoCtrl:getLordInfo()
		local isTargetInWar = false
		if lordInfo.base.mapId and worldMapDefine.isWarKingdomID(lordInfo.base.mapId) then
			isTargetInWar = true
			warName = worldMapWarDef.getKingdomNameByKid(lordInfo.base.mapId)
		end
		local isSelfInWar = false
		if selfLordInfo.base.mapId and worldMapDefine.isWarKingdomID(selfLordInfo.base.mapId) then
			isSelfInWar = true
		end
		if not isTargetInWar and not isSelfInWar then
			_ENV = i18n("common_text_344", i18n("common_text_555", nil))
			i18n("common_text_344", i18n("common_text_555", nil)).k = lordInfo.base.partition
			i18n("common_text_344", i18n("common_text_555", nil)).x = lordInfo.base.pos.x
			i18n("common_text_344", i18n("common_text_555", nil)).y = lordInfo.base.pos.y
			self.fields.Text_lordPos:setString(i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))
		elseif isTargetInWar and not isSelfInWar then
			_ENV = i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))
			i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))).k = warName
			i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))).x = lordInfo.base.pos.x
			i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))).y = lordInfo.base.pos.y
			self.fields.Text_lordPos:setString(i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))
			isNotice = true
		elseif not isTargetInWar and isSelfInWar then
			warName = worldMapWarDef.getKingdomNameByKid(selfLordInfo.base.mapId)
			_ENV = i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))
			i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))).x = lordInfo.base.pos.x
			i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))).y = lordInfo.base.pos.y
			self.fields.Text_lordPos:setString(i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))
			isNotice = true
			isQuit = true
		elseif lordInfo.base.mapId == selfLordInfo.base.mapId then
			_ENV = i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))
			i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))).x = lordInfo.base.pos.x
			i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))).y = lordInfo.base.pos.y
			self.fields.Text_lordPos:setString(i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))))
		else
			_ENV = i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))
			i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))).k = warName
			i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))).x = lordInfo.base.pos.x
			i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))).y = lordInfo.base.pos.y
			self.fields.Text_lordPos:setString(i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))))
			isNotice = true
		end
		if self.isNotice then
			if not self.isQuit then
				_ENV = i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))))
				i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))).name = warName
				self.noticeStr = i18n("worldwar_text_20", i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))))
			else
				_ENV = i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil)))))))
				i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))).name = warName
				self.noticeStr = i18n("worldwar_text_21", i18n("common_text_639", i18n("common_text_465", i18n("common_text_465", i18n("common_text_639", i18n("common_text_639", i18n("common_text_344", i18n("common_text_555", nil))))))))
			end
		else
			local kid = isTargetInWar and lordInfo.base.mapId or lordInfo.base.partition
			self.jumpPos = cc.p(lordInfo.base.pos.x, lordInfo.base.pos.y)
			self.jumpKid = kid
		end
	end
end
function HeroJailDetailPanel:refreshRansomBoard()
	if self:isMyHeroJail() then
		self.heroJailInfo = heroJailCtrl:getHerosInOtherPrisonByID(self.heroID)
	else
		self.heroJailInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
	end
	self:initSetRasnsom()
end
function HeroJailDetailPanel:changeRelease2Execute(bool)
	if bool then
		self.fields.Button_release:setString(i18n("prison_btn_06"))
		self.fields.Button_release:setIcon("btn_execution.png")
	else
		self.fields.Button_release:setString(i18n("prison_btn_05"))
		self.fields.Button_release:setIcon("icon_hero_release.png")
	end
end
function HeroJailDetailPanel:btnReleaseClick()
	if gHeroJailState.execute == self.state then
		SoraDPlaySound("equipment", 3)
		_ENV = nil
		;(nil).isShare = self.heroJailInfo.quality >= gHeroQuality.PURPLE
		;(nil).handle = function(isShare)
			SoraDShowLoading(self)
			heroJailCtrl:reqExecute(self.heroID, self.heroJailInfo.ownerUid, isShare)
		end
		uiManager:show("HeroJailExecute", nil)
	else
		SoraDPlaySound("uicontrol", 29)
		_ENV = nil
		;(nil).content = i18n("prison_text_11")
		;(nil).confirmFunc = function()
			SoraDShowLoading(self)
			heroJailCtrl:reqReleaseHero(self.heroID, self.heroJailInfo.ownerUid)
		end
		;(nil).cancelFunc = function()
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	end
end
function HeroJailDetailPanel:btnSetMoneyClick()
	SoraDPlaySound("trainsoilder", 200)
	if self:isMyHeroJail() then
		if next(self.heroJailInfo.ransomData) then
			_ENV = nil
			;(nil).jailInfo = self.heroJailInfo
			uiManager:show("HeroPayMoney", nil)
		else
			SoraDShowMsgTip(i18n("hero_text_16"))
		end
	else
		_ENV = i18n("hero_text_16")
		i18n("hero_text_16").heroFlagID = self.heroFlagID
		uiManager:show("HeroRansomBoard", i18n("hero_text_16"))
	end
end
function HeroJailDetailPanel:btnMsgClick()
	SoraDPlaySound()
	if self.heroJailInfo and self.otherLordInfo then
		_ENV = self.otherLordInfo
		self.otherLordInfo.targetType = gMailType.CHAT
		self.otherLordInfo.target = self.heroJailInfo.ownerUid
		self.otherLordInfo.nickName = self.otherLordInfo.base.nickName
		local self.otherLordInfo.allianceAbbr, chatData = self.otherLordInfo.abbr, self.otherLordInfo
		SoraDCreateChatView(chatData)
	end
end
function HeroJailDetailPanel:btnShareClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroJailInfo = self.heroJailInfo
	;(nil).otherLordInfo = self.otherLordInfo
	uiManager:show("HeroJailShare", nil)
end
function HeroJailDetailPanel:btnLordClick()
	SoraDPlaySound()
	dump(self.otherLordInfo, "self.otherLordInfo")
	if self.otherLordInfo then
		SoraDOpenLordView(self.otherLordInfo)
	end
end
function HeroJailDetailPanel:onClickPos()
	SoraDPlaySound()
	if self.noticeStr then
		SoraDShowMsgTip(self.noticeStr)
	else
		SoraDGotoWorldMapPoint(self.jumpPos, true, self.jumpkid)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function HeroJailDetailPanel:onInClick(context)
	self.isTouchBegin = true
	print("HeroJailDetailPanel:onInClick")
	self.posBegin = context:getInput():getPosition()
end
function HeroJailDetailPanel:onOutClick(context)
	print("HeroJailDetailPanel:onOutClick")
	if not self.isTouchBegin then
		return
	end
	self.isTouchBegin = false
	self.posEnd = context:getInput():getPosition()
	if self.posBegin and self.posEnd then
		if self.posEnd.x - self.posBegin.x >= 30 then
			self:btnLHeroClick()
		elseif self.posEnd.x - self.posBegin.x <= -30 then
			self:btnRHeroClick()
		else
			heroltCtrl:playHeroSound(self.heroID)
		end
		self.posBegin = nil
		self.posEnd = nil
	end
end
function HeroJailDetailPanel:btnLHeroClick()
	SoraDPlaySound()
	if SoraDFIsRA() then
		local _, rb = self:getLeftOrRightHeroID()
		if rb then
			self:jumpToHero(rb)
		end
	else
		local lb, _ = self:getLeftOrRightHeroID()
		if lb then
			self:jumpToHero(lb)
		end
	end
end
function HeroJailDetailPanel:btnRHeroClick()
	SoraDPlaySound()
	if SoraDFIsRA() then
		local lb, _ = self:getLeftOrRightHeroID()
		if lb then
			self:jumpToHero(lb)
		end
	else
		local _, rb = self:getLeftOrRightHeroID()
		if rb then
			self:jumpToHero(rb)
		end
	end
end
function HeroJailDetailPanel:btnBreakClick()
	SoraDPlaySound("innerbuildsound", 120)
	local breakKeyNum = backpackCtrl:getItemCount(gHeroSpecialItems.breakKey)
	if 0 < breakKeyNum then
		_ENV = nil
		_ENV = nil
		;(nil).num = breakKeyNum
		;(nil).content = i18n("hero_text_15", nil)
		;(nil).confirmString = i18n("common_text_054")
		;(nil).confirmFunc = function()
			print("使用了越狱道具在" .. self.heroID)
			SoraDShowLoading(self)
			heroJailCtrl:reqBreaker(self.heroID)
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	elseif SoraDCheckShow(gHeroBreakJailGiftID) then
		_ENV = nil
		_ENV = nil
		;(nil).num = breakKeyNum
		;(nil).content = i18n("hero_text_15", nil)
		;(nil).confirmString = i18n("common_text_282")
		;(nil).confirmFunc = function()
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).id = gHeroBreakJailGiftID
				;(nil).fromCenter = gRechargeActiveFromEnum.ROAD21
				uiManager:show("rechargePopFrame", nil)
			else
				local panel = SoraDCreatePanel("rechargePopFrame")
				panel:initData(gHeroBreakJailGiftID, gRechargeActiveFromEnum.ROAD21)
				panel:show()
			end
		end
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	else
		SoraDShowMsgTip(i18n("hero_text_91"))
	end
end
function HeroJailDetailPanel:btnPostRewardClick()
	SoraDPlaySound("uicontrol", 13)
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroRansomBoard", nil)
end
function HeroJailDetailPanel:getLeftOrRightHeroID()
	local showList = heroCtrl:getAllHerosListByRule()
	local pos = 1
	for k, v in ipairs(showList) do
		if tonumber(v) == tonumber(self.heroID) then
			pos = k
			break
		end
	end
	local lPos = (pos - 1) % #showList == 0 and #showList or (pos - 1) % #showList
	local rPos = pos + 1 > #showList and (pos + 1) % #showList or pos + 1
	return showList[lPos], showList[rPos]
end
function HeroJailDetailPanel:jumpToHero(hid)
	if not heroCtrl:judgeMyHeroInJail(hid) then
		SoraDShowHeroDetailView(hid)
	else
		self.heroID = hid
		self:initData()
		self:initTurnBtn()
	end
end
function HeroJailDetailPanel:req4lordInfo(...)
	if self:isMyHeroJail() then
		lordInfoCtrl = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(self.heroJailInfo.wardenUid, nil, nil)
	else
		lordInfoCtrl = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(self.heroJailInfo.ownerUid, self.heroJailInfo.ownerKid, nil)
	end
end
function HeroJailDetailPanel:req4lordRewardInfo(...)
	heroJailCtrl:reqGetReward(self.heroJailInfo.wardenUid)
end
function HeroJailDetailPanel:isMyHeroJail()
	return self.controllers.c1:getSelectedIndex() == 1
end
function HeroJailDetailPanel:onClickMyClose()
	self:onClickClose()
	local proxy = uiManager:getProxy("newHeroDetailView")
	if proxy then
		proxy:getPanel():removeFromParent()
	end
end
return HeroJailDetailPanel
