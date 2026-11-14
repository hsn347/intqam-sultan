local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroJailDetailView = class("heroJailDetailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailDetailView")
	end
	return target
end)
function HeroJailDetailView:ctor()
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self.txtHeroName = SoraDGetChildByName(self, "Text_heroName")
	self.nodeHero = SoraDGetChildByName(self, "Bottom_Node_hero")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_heroJailDetail")
	self.windowTitle:setTitle(i18n("prison_text_09"))
	self.ransomBoard = SoraDGetExtendChildFromCCSByName(self, "Center_CCS_heroRansomBoard_set")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_loadBar")
	self.txtLoadBar = SoraDGetChildByName(self, "Text_loadBar")
	self.txtLoadBar = SoraDCreateTimerLabel(self, self.txtLoadBar)
	self.spRelease = SoraDGetChildByName(self, "Sprite_release")
	self.spSetMoney = SoraDGetChildByName(self, "Sprite_setMoney")
	self.spMsg = SoraDGetChildByName(self, "Sprite_msg")
	self.btnRelease = SoraDGetChildByName(self, "Button_release")
	self.btnSetMoney = SoraDGetChildByName(self, "Button_setMoney")
	self.btnMsg = SoraDGetChildByName(self, "Button_msg")
	self.btnRelease:addTouchEventListener(handler(self, self.btnReleaseClick))
	self.btnSetMoney:addTouchEventListener(handler(self, self.btnSetMoneyClick))
	self.btnMsg:addTouchEventListener(handler(self, self.btnMsgClick))
	self.txtRelease = SoraDGetChildByName(self, "Text_release")
	self.txtSetMoney = SoraDGetChildByName(self, "Text_setMoney")
	self.txtMsg = SoraDGetChildByName(self, "Text_msg")
	self.txtRelease:setString(i18n("prison_btn_05"))
	self.txtSetMoney:setString(i18n("prison_btn_03"))
	self.txtMsg:setString(i18n("prison_btn_02"))
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.btnShare:addTouchEventListener(handler(self, self.btnShareClick))
	self.scroll = SoraDGetChildByName(self, "Bottom_ScrollView")
	self.nodeLord = SoraDGetChildByName(self, "Node_lordInfo")
	self.nodeLord:setVisible(false)
	self.btnLord = SoraDGetChildByName(self, "Button_lordHead")
	self.btnLord:setTouchEnabled(true)
	self.btnLord:setPressedActionEnabled(false)
	self.btnLord:addTouchEventListener(handler(self, self.btnLordClick))
	self.nodeLordRes = SoraDGetChildByName(self, "Node_lordRes")
	SoraDGetChildByName(self, "Text_lordInfoTip"):setString(i18n("hero_text_93"))
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(80)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(80)
	nodeFireR:addTo(self.Node_fire_R)
end
function HeroJailDetailView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_SETRANSOMSUCCESS", handler(self, self.refreshRansomBoard))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS", handler(self, self.judgeIsLookHero))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS", handler(self, self.judgeIsLookHero))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.fileDownloadByFile))
end
function HeroJailDetailView:refreshView(target, redata)
	if redata and redata.flagID then
		if heroJailCtrl:getHerosInMyPrisonByID(redata.flagID) then
			if self.heroFlagID == redata.flagID then
				self:refreshData()
				self:initView()
			end
		else
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end
end
function HeroJailDetailView:judgeIsLookHero(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.flagID and redata.flagID == self.heroFlagID then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function HeroJailDetailView:refreshData(...)
	self.heroJailInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
	dump(self.heroJailInfo, "self.heroJailInfo")
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroJailInfo.heroID)
	self.state, self.leftTime, self.totalTime = heroJailCtrl.getJailStateWithTime(self.heroJailInfo)
	self:req4lordInfo()
end
function HeroJailDetailView:initData(heroFlagID)
	self.heroFlagID = heroFlagID
	self:refreshData()
	heroltCtrl:playHeroSound(self.heroJailInfo.heroID)
	self:initView()
end
function HeroJailDetailView:req4lordInfo(...)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	gametop = nil
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(self.heroJailInfo.ownerUid, self.heroJailInfo.ownerKid, nil)
end
function HeroJailDetailView:initView(...)
	self:initHeadSpine()
	self.txtHeroName:setString(i18n(self.heroDesInfo.herName))
	self.ransomBoard:initData(self.heroJailInfo.ransomData)
	self:initSetRasnsomBtnText(self.heroJailInfo.ransomData)
	self:initLoadingBar()
end
function HeroJailDetailView:initSetRasnsomBtnText(ransomData)
	if next(ransomData) then
		self.txtSetMoney:setString(i18n("prison_btn_04"))
	else
		self.txtSetMoney:setString(i18n("prison_btn_03"))
	end
end
function HeroJailDetailView:getScaleValue(...)
	if not self.scaleValue then
		if display.height < 850 then
			self.scaleValue = 0.5
		elseif display.height > 1120 then
			self.scaleValue = 0.85
		else
			local deta = display.height - 850
			local seed = deta / 67.5 * 0.1
			self.scaleValue = 0.5 + seed
		end
	end
	return self.scaleValue
end
local getImageScaleValue = function(...)
	_ENV = nil
	;(nil).min = 0.5
	local _ENV, (nil).max, scaleFactor = nil, 0.9, nil
	;(nil).min = -280
	local (nil).max, posYFactor = -150, nil
	local detaF = function(obj)
		return obj.max - obj.min
	end
	if display.height < 850 then
		return scaleFactor.min, posYFactor.min
	elseif display.height > 1250 then
		return scaleFactor.max, posYFactor.max
	else
		local deta = (display.height - 850) / 400
		local detaScale = deta * detaF(scaleFactor)
		local detaPosY = deta * detaF(posYFactor)
		return scaleFactor.min + detaScale, posYFactor.min + detaPosY
	end
end
function HeroJailDetailView:getAddHeightValue(...)
	if not self.addHeight then
		local factX = 0
		if display.height < 850 then
			factX = 0.5
		elseif display.height > 1120 then
			factX = 0.85
		else
			local deta = display.height - 850
			local seed = deta / 67.5 * 0.1
			factX = 0.5 + seed
		end
		self.addHeight = (1 - factX) * 150
	end
	print("self.addHeight=", self.addHeight)
	return self.addHeight
end
function HeroJailDetailView:fileDownloadByFile(target, data)
	if string.find(data.file, self.heroDesInfo.herImage) then
		self:initHeadSpine()
	end
end
function HeroJailDetailView:initHeadSpine(...)
	local dressID = self.heroJailInfo.dressID or heroCtrl:getHeroDressSeting(self.heroJailInfo.heroID)
	if self.spine_hero then
		self.spine_hero:removeFromParent()
		self.spine_hero = nil
	end
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	if isUsm then
		self.spine_hero = cc.criSprite.createCriSprite(spineCfg, false, true)
		self.spine_hero:setAnchorPoint(cc.p(0.5, 0))
		self.spine_hero:setScale(cfg.detail[1])
		self.spine_hero:setPosition(cfg.detail[2], cfg.detail[3])
		self.spine_hero:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.spine_hero:addTo(self.nodeHero)
	else
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		self.spine_hero = sp.SkeletonAnimation:create(spineCfg, atlas, 1)
		self.spine_hero:setScale(cfg.detail[1])
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:setPosition(cfg.detail[2], cfg.detail[3])
		self.spine_hero:addTo(self.nodeHero)
	end
	_ENV = 0.2
	;(0.2).easing = "BACKINOUT"
	transition.execute(self.spine_hero, cca.scaleTo(0.2, 0.9, 0.9), 0.2)
end
function HeroJailDetailView:initLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			local lordInfo = data.lord
			self.otherLordInfo = lordInfo
			self.nodeLord:setVisible(true)
			local imgHead = SoraDGetChildByName(self.nodeLord, "Image_lordHead")
			SoraDGetHeadFromManager(imgHead, lordInfo.base.imageId, lordInfo.base.avatar)
			local otherKID = self.heroJailInfo.ownerKid
			local myKID = gametop.playertop_:getKingdomID()
			if lordInfo.abbr and lordInfo.abbr ~= "" then
				_ENV = nil
				;(nil).name = lordInfo.base.nickName
				;(nil).abbr = lordInfo.abbr
				if i18n("common_text_186", nil) then
					goto lbl_50
				end
			end
			local showName = lordInfo.base.nickName
			::lbl_50::
			if tonumber(otherKID) ~= tonumber(myKID) then
				showName = showName .. "#" .. otherKID
			end
			local txtLordName = SoraDGetChildByName(self.nodeLord, "Text_lordName")
			txtLordName:setString(showName)
			local txtForce = SoraDGetChildByName(self.nodeLord, "Text_lordForce")
			_ENV = nil
			;(nil).count = string.formatnumberthousands(lordInfo.fcInfo.totalFc)
			txtForce:setString(i18n("common_text_555", nil))
			local txtKillNum = SoraDGetChildByName(self.nodeLord, "Text_lordKillNum")
			_ENV = i18n("common_text_555", nil)
			i18n("common_text_555", nil).kills = string.formatnumberthousands(lordInfo.fcInfo.killCount)
			txtKillNum:setString(i18n("common_text_344", i18n("common_text_555", nil)))
		end
	end
end
function HeroJailDetailView:initLoadingBar(...)
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
	self.loadBar:loadTexture(heroltCtrl.getJailStateLoadBar(self.state), ccui.TextureResType.plistType)
	self.txtLoadBar:setTimeLast(function(showTime, ticket)
		self.loadBar:setPercent(ticket / self.totalTime * 100)
		return stateDes .. " " .. showTime
	end)
	self.txtLoadBar:setTimeEndListener(function(...)
		self:refreshData()
		self:initLoadingBar()
	end)
	self.txtLoadBar:beginTime(self.leftTime + 1)
end
function HeroJailDetailView:changeRelease2Execute(bool)
	if bool then
		self.txtRelease:setString(i18n("prison_btn_06"))
		self.spRelease:setScale(0.7)
		self.spRelease:setSpriteFrame("btn_execution.png")
		self.btnRelease:addTouchEventListener(handler(self, self.btnExecuteClick))
	else
		self.txtRelease:setString(i18n("prison_btn_05"))
		self.spRelease:setScale(0.9)
		self.spRelease:setSpriteFrame("icon_hero_release.png")
		self.btnRelease:addTouchEventListener(handler(self, self.btnReleaseClick))
	end
end
function HeroJailDetailView:btnExecuteClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound("equipment", 3)
		local panel = SoraDCreatePanel("heroJailExecuteView")
		panel:setShareVisible(self.heroJailInfo.quality >= gHeroQuality.PURPLE)
		panel:setHandle(function(isShare)
			print("sldkjfslkdjflksdjf", isShare)
			SoraDShowLoading(self)
			heroJailCtrl:reqExecute(self.heroJailInfo.heroID, self.heroJailInfo.ownerUid, isShare)
		end)
		panel:show()
	end
end
function HeroJailDetailView:btnReleaseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 29)
		SoraDShowMsgBox(i18n("prison_text_11"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				SoraDShowLoading(self)
				heroJailCtrl:reqReleaseHero(self.heroJailInfo.heroID, self.heroJailInfo.ownerUid)
			end
		end)
	end
end
function HeroJailDetailView:btnSetMoneyClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound("trainsoilder", 200)
		local panel = SoraDCreatePanel("heroRansomPopBoard")
		panel:initData(self.heroFlagID)
		panel:show()
	end
end
function HeroJailDetailView:btnMsgClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.heroJailInfo then
			_ENV = self.heroJailInfo
			self.heroJailInfo.targetType = gMailType.CHAT
			self.heroJailInfo.target = self.heroJailInfo.ownerUid
			self.heroJailInfo.nickName = self.otherLordInfo.base.nickName
			local self.heroJailInfo.allianceAbbr, chatData = self.otherLordInfo.abbr, self.heroJailInfo
			SoraDCreateChatView(chatData)
		end
	end
end
function HeroJailDetailView:btnShareClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroJailShareView")
		panel:initData(self.heroJailInfo, self.otherLordInfo)
		panel:show()
	end
end
function HeroJailDetailView:btnLordClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.otherLordInfo then
			SoraDOpenLordView(self.otherLordInfo)
		end
	end
end
function HeroJailDetailView:refreshRansomBoard(target, redata)
	if redata then
		self.heroJailInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
		self.ransomBoard:initData(self.heroJailInfo.ransomData)
		self:initSetRasnsomBtnText(self.heroJailInfo.ransomData)
	end
end
return HeroJailDetailView
