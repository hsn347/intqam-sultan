local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local publicRead = include("publicRead")
local lordLocalData = include("lordLocalData")
local lordSpineDef = include("lordSpineDef")
local HeroWantedBoard = class("heroWantedBoard", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroWantedBoard")
	end
	return target
end)
function HeroWantedBoard:ctor()
	self.lordResOcx, _ENV = nil, nil
	self.txtLordName = SoraDGetChildByName(self, "Text_lordName")
	self.txtKillNum = SoraDGetChildByName(self, "Text_killNum")
	self.txtForce = SoraDGetChildByName(self, "Text_force")
	self.nodeLord = SoraDGetChildByName(self, "Node_lord")
	self.spriteHead = SoraDGetChildByName(self, "Sprite_head")
	self.txtAdd = SoraDGetChildByName(self, "Text_add")
	self.txtHnum = SoraDGetChildByName(self, "Text_h_num")
	self.spriteHead:setVisible(false)
	self.btnLord = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnLord:setPosition(cc.p(self.spriteHead:getPositionX(), self.spriteHead:getPositionY()))
	self.btnLord:ignoreContentAdaptWithSize(false)
	self.btnLord:setContentSize(self.spriteHead:getContentSize())
	self.btnLord:setScale(self.spriteHead:getScale())
	self.btnLord:setPressedActionEnabled(false)
	self.btnLord:addTo(self.nodeLord, 1)
	self.btnLord:addTouchEventListener(handler(self, self.btnLordClick))
	self.panelRes = SoraDGetChildByName(self, "Node_resBase")
	self.nodeRes = SoraDGetChildByName(self, "Node_res")
	self.nodeHero = SoraDGetChildByName(self, "Node_hero")
	self.scroll = SoraDGetChildByName(self, "ScrollView_herosList")
	self.scroll:setScaleY(1.0)
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.btnClose:addTouchEventListener(handler(self, self.btnCloseClick))
	SoraDGetChildByName(self, "Text_title"):setString(i18n("prison_title_01"))
	SoraDGetChildByName(self, "Text_needRes"):setString(i18n("prison_common_02"))
	SoraDGetChildByName(self, "Text_herosListTip"):setString(i18n("prison_title_02"))
	SoraDGetChildByName(self, "Text_lordNameTip"):setString(i18n("common_text_2037"))
	SoraDGetChildByName(self, "Text_heroNameTip"):setString(i18n("common_name_01"))
	SoraDGetChildByName(self, "Text_resNumTip"):setString(i18n("prison_common_02"))
end
function HeroWantedBoard:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_LORDREWARDINFO", handler(self, self.initRewardInfo))
end
function HeroWantedBoard:req4Info(uid, kid)
	self.lordUid = uid
	self.lordKid = kid
	lordInfoCtrl = nil
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(self.lordUid, self.lordKid, nil)
	self:req4lordRewardInfo()
	local ownUUID = lordInfoCtrl:getLordInfo().base.uid
	if ownUUID == self.lordUid then
		local buildLogic = include("buildLogic")
		local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
		local heroInMyJail = heroJailCtrl:getHerosInMyPrison()
		local totalNum = buildLogic.getHeroJailCapacity().total
		local curNum = table.nums(heroInMyJail)
		lordInfoCtrl = nil
		;(nil).num1 = curNum
		;(nil).num2 = totalNum
		self.txtHnum:setString(i18n("prison_text_02", nil))
		local reduceTime = buildLogic.getHeroJailReduceSpeedTime().total
		lordInfoCtrl = i18n("prison_text_02", nil)
		i18n("prison_text_02", nil).time = SoraDConvertSecondToString(reduceTime)
		self.txtAdd:setString(i18n("prison_text_03", i18n("prison_text_02", nil)))
	else
		self.txtAdd:setVisible(false)
		self.txtHnum:setVisible(false)
	end
end
function HeroWantedBoard:req4lordRewardInfo(...)
	heroJailCtrl:reqGetReward(self.lordUid)
end
function HeroWantedBoard:updateLordInfo(target, data)
	local ownUUID = lordInfoCtrl:getLordInfo().base.uid
	if ownUUID == self.lordUid then
		self:req4Info(self.lordUid, self.lordKid)
	end
end
function HeroWantedBoard:initLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			local lordInfo = data.lord
			self.otherLordInfo = lordInfo
			self.nodeLord:setVisible(true)
			local imageID = lordInfo.base.imageId
			local info = lordSpineDef.getLordSpineInfo(imageID)
			if info then
				if self.spine then
					self.spine:removeFromParent()
					self.spine = nil
				end
				self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
				self.spine:setScale(0.6)
				local offset = info.offset or cc.p(0, 5)
				self.spine:setPosition(cc.p(offset.x, offset.y - 181))
				self.spine:setAnimation(0, "animation", true)
				self.spine:addTo(self.nodeLord, -1)
				self.spriteHead:setVisible(false)
			else
				self.spriteHead:setVisible(true)
				self.spriteHead:setSpriteFrame(lordLocalData.getPortrait(imageID))
			end
			if self.isSysWarProtect then
				if self.spine then
					self.spine:setScale(0.5)
					self.spine:setPosition(cc.p(self.spine:getPositionX(), self.spine:getPositionY() + 16))
				else
					self.spriteHead:setScale(0.5)
					self.spriteHead:setPosition(cc.p(0, -36))
				end
			end
			if lordInfo.abbr and lordInfo.abbr ~= "" then
				lordSpineDef = cc.p(0, -36)
				cc.p(0, -36).name = lordInfo.base.nickName
				cc.p(0, -36).abbr = lordInfo.abbr
				if i18n("common_text_186", cc.p(0, -36)) then
					goto lbl_139
				end
			end
			local showName = lordInfo.base.nickName
			::lbl_139::
			local kid = lordInfo.base.sourceKid and 0 < lordInfo.base.sourceKid and lordInfo.base.sourceKid or lordInfo.base.partition
			self.txtLordName:setString(showName .. "#" .. kid)
			lordSpineDef = kid
			kid.power = string.formatnumberthousands(lordInfo.fcInfo.totalFc)
			self.txtForce:setString(i18n("common_text_128", kid))
			lordSpineDef = i18n("common_text_128", kid)
			i18n("common_text_128", kid).kills = string.formatnumberthousands(lordInfo.fcInfo.killCount)
			self.txtKillNum:setString(i18n("common_text_344", i18n("common_text_128", kid)))
		end
	end
end
function HeroWantedBoard:initRewardInfo(target, redata)
	if redata and redata.total then
		local showRes = redata.total
		local keyTbl = table.keys(showRes)
		table.sort(keyTbl)
		_ENV, _UPVALUE4_ = keyTbl, table.sort
		keyTbl.x = -115
		_ENV, keyTbl.y = nil, -40
		;(nil).x = 115
		_ENV, (nil).y = nil, -40
		;(nil).x = -115
		_ENV, (nil).y = nil, -80
		;(nil).x = 115
		;(nil).y = -80
		table.sort[1] = keyTbl
		table.sort[2] = nil
		table.sort[3] = nil
		local table.sort[4], posTbl = nil, table.sort
		if not next(self.lordResOcx) then
			for i, v in ipairs(gHeroRansomRes) do
				local resNode = self.nodeRes:clone()
				resNode:setPosition(posTbl[i])
				resNode:addTo(self.panelRes)
				resNode:getChildByName("Sprite_res"):setSpriteFrame(publicRead.getSmallIcon(v))
				resNode:getChildByName("Text_res"):setString("0")
				self.lordResOcx[v] = resNode
			end
		end
		for i, v in ipairs(keyTbl) do
			self.lordResOcx[tonumber(v)]:getChildByName("Text_res"):setString(string.formatnumberthousands(math.floor(showRes[v] * (1 - gHeroRansomTax))))
		end
		local resRecords = redata.detail
		local sSize = self.scroll:getContentSize()
		local sH = math.max(sSize.height, #resRecords * 50)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		local filleResSingle = function(ocx, info, index)
			local spRes = ocx:getChildByName("Sprite_res")
			local txtResNum = ocx:getChildByName("Text_res")
			local txtHeroName = ocx:getChildByName("Text_hero")
			local txtLordName = ocx:getChildByName("Text_lord")
			local bgImg = ocx:getChildByName("Image_sheer")
			bgImg:setVisible(index % 2 == 0)
			if info.rewardData.id then
				spRes:setVisible(true)
				spRes:setSpriteFrame(publicRead.getSmallIcon(info.rewardData.id))
				txtResNum:setString(string.formatnumberthousands(math.floor(info.rewardData.num * (1 - gHeroRansomTax))))
			else
				spRes:setVisible(false)
				txtResNum:setString(i18n("hero_text_84"))
			end
			txtHeroName:setString(i18n(heroltCtrl.getHeroInfo(info.heroID).herName))
			if info.ownerAbbr and info.ownerAbbr ~= "" then
				publicRead = i18n(heroltCtrl.getHeroInfo(info.heroID).herName)
				i18n(heroltCtrl.getHeroInfo(info.heroID).herName).name = info.ownerNickName
				i18n(heroltCtrl.getHeroInfo(info.heroID).herName).abbr = info.ownerAbbr
				if i18n("common_text_186", i18n(heroltCtrl.getHeroInfo(info.heroID).herName)) then
					goto lbl_83
				end
			end
			local showName = info.ownerNickName
			::lbl_83::
			txtLordName:setString(showName .. "#" .. info.ownerKid)
		end
		for i, v in ipairs(resRecords) do
			local single = self.nodeHero:clone()
			single:addTo(self.scroll)
			single:setPosition(sSize.width / 2, sH - (i - 1) * 50 - 25.0)
			filleResSingle(single, v, i)
		end
	end
end
function HeroWantedBoard:btnLordClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.otherLordInfo then
			SoraDOpenLordView(self.otherLordInfo)
		end
	end
end
function HeroWantedBoard:btnCloseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function HeroWantedBoard:setIsSysWarProtect(isSysWarProtect)
	SoraDGetChildByName(self, "Text_tips"):setString(i18n("common_text_4647"))
	self.isSysWarProtect = isSysWarProtect
end
return HeroWantedBoard
