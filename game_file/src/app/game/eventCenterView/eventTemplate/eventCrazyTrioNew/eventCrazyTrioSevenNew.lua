local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordSpineDef = include("lordSpineDef")
local rechargeRead = include("rechargeRead")
local rechargeltCtrl = include("rechargeltCtrl")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
_ENV = gametop.playertop_
gametop.playertop_.noReach = 1
gametop.playertop_.noClaim = 2
local gametop.playertop_.claimed, giftStatus = 3, gametop.playertop_
local eventCrazyTrioSevenNew = class("eventCrazyTrioSevenNew", function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end)
_ENV, _ENV = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "eventCrazyTrioSevenNew"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew01_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew01_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew01_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_03"
_ENV, ("eventCrazyTrioSevenNew")[1], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcznew01_font_01_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_04"
_ENV, ("eventCrazyTrioSevenNew")[2], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_02_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_05"
_ENV, ("eventCrazyTrioSevenNew")[3], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_03_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_05"
_ENV, ("eventCrazyTrioSevenNew")[4], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_04_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_05"
_ENV, ("eventCrazyTrioSevenNew")[5], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_05_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_05"
_ENV, ("eventCrazyTrioSevenNew")[6], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_06_"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).bg = "frame_qcznew02_bg_01.png"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).leftBg = "frame_qcznew02_bgleft_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).rightBg = "frame_qcznew02_bgright_0"
;(function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).name = "trio_text_05"
;("eventCrazyTrioSevenNew")[7], (function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end).frameFont = function(target)
	target = target or SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	return target
end, "frame_qcz_font_07_"
local iconConfig = "eventCrazyTrioSevenNew"
function eventCrazyTrioSevenNew:ctor()
	self.activityID = gActivityTimeActivityID.NEW_CRAZY_SEPTET_ACTIVITY
	self.isAddToPopManager = true
	self.giftStatus = giftStatus.noReach
	self.award, _ENV, self.curCrazyIndex = giftStatus.noReach, giftStatus.noReach, 1
	self.totalNum = 7
	self.bgImage = SoraDGetChildByName(self, "Image_BG")
	self.bgImage:ignoreContentAdaptWithSize(true)
	self.bgImageDown = SoraDGetChildByName(self, "Image_BG_Down")
	self.redEffect = SoraDGetChildsArrayByName(self, "red_", 10, 1)
	self.yellowEffect = SoraDGetChildsArrayByName(self, "yellow_", 10, 1)
	self.centerNode = SoraDGetChildByName(self, "Center_node")
	self.nodeSpine = SoraDGetChildByName(self, "Node_Spine")
	self.nodeSpine:setVisible(false)
	self.heroNode = SoraDGetChildByName(self, "Node_Hero")
	self.heroSpineNode = SoraDGetChildByName(self, "Node_SpineHero")
	self.nodeCanGet = SoraDGetChildByName(self, "Node_CanGet")
	self.textCanGet = SoraDGetChildByName(self.nodeCanGet, "Text_CanGet")
	self.btnGetReward = SoraDGetChildByName(self.nodeCanGet, "Button_Get")
	self.btnGetReward:addTouchEventListener(handler(self, self.btnGetRewardClick))
	self.btnGetReward:setTitleText(i18n("common_text_1146"))
	self.nodeHeroSkill = SoraDGetChildByName(self, "Node_HeroSkill")
	self.textTitle = SoraDGetChildByName(self.nodeHeroSkill, "Text_Title")
	self.textTitle:setString(i18n("Payment_activity_optimization_text_17"))
	self.textList = SoraDGetChildsArrayByName(self.nodeHeroSkill, "Text_HeroProperty_", 4, 1)
	self.nodeReward = SoraDGetChildByName(self, "Node_award")
	self.textFrameFont = SoraDGetChildByName(self, "Image_Lang")
	self.textFrameFont:ignoreContentAdaptWithSize(true)
	self.btnDetail = SoraDGetChildByName(self, "Button_Detail")
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.textTotalGold = SoraDGetChildByName(self, "Text_TotalGold")
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.textInfo = SoraDChangeTextToHtml(self.textInfo)
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.lBarProgress = SoraDGetChildByName(self.nodeProgress, "LoadingBar_progress")
	self.btnBox = SoraDGetChildByName(self.nodeProgress, "Button_box")
	self.btnBox:addTouchEventListener(handler(self, self.btnBoxClick))
	self.nodeExtend = SoraDGetChildByName(self, "Node_ExtandGift")
	self.btn_buy = SoraDGetChildByName(self.nodeExtend, "Button_buy")
	self.text_oriPrice = SoraDGetChildByName(self.btn_buy, "Text_oriPrice")
	self.text_nowPrice = SoraDGetChildByName(self.btn_buy, "Text_nowPrice")
	self.btn_buy:addTouchEventListener(handler(self, self.readyBuy))
	self.textPusrchase = SoraDGetChildByName(self, "Text_PurchaseTitle")
	self.textPusrchase:setString(i18n("recharge_gift_config_seven_text_01"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_Gift")
	self.scroll:setClippingEnabled(false)
	self.scroll = include("commonScrollView").new(self.scroll)
	self.frame_qcznew02_img_01_76 = SoraDGetChildByName(self, "frame_qcznew02_img_01_76")
	self.frame_qcznew01_bg_04_24 = SoraDGetChildByName(self, "frame_qcznew01_bg_04_24")
	self.Sprite_46 = SoraDGetChildByName(self, "Sprite_46")
	self.Sprite_46:setPosition(self.Sprite_46:getPositionX() + 5, self.Sprite_46:getPositionY() + 5)
	local nodeSize = cc.size(224, 96)
	;(self.Sprite_46:getPositionY() + 5).listData, _ENV, _ENV = self.Sprite_46, self.Sprite_46, self.Sprite_46:getPositionY() + 5
	;(self.Sprite_46:getPositionY() + 5).nodeSizeType = gScrollViewNodeSizeType.dynamic
	;(self.Sprite_46:getPositionY() + 5).createNodeHandler = handler(self, self.createSingleNode)
	;(self.Sprite_46:getPositionY() + 5).selWheelNodeHandler = handler(self, self.refreshGiftID)
	;(self.Sprite_46:getPositionY() + 5).nodeDirection = SoraDFIsRA() and gScrollViewNodeDirection.right or gScrollViewNodeDirection.left
	;(self.Sprite_46:getPositionY() + 5).scrollViewType = gScrollViewType.wheel
	;(self.Sprite_46:getPositionY() + 5).paddingLeft = self.scroll:getContentSize().width / 2 - nodeSize.width / 2
	;(self.Sprite_46:getPositionY() + 5).paddingRight = self.scroll:getContentSize().width / 2 - nodeSize.width / 2
	;(self.Sprite_46:getPositionY() + 5).nodeClass = include("eventCrazyGiftSingle")
	;(self.Sprite_46:getPositionY() + 5).handler = handler(self, self.updateWheelDressScaleAndPos)
	self.scroll:init(self.Sprite_46:getPositionY() + 5)
	self.scroll:setClippingEnabled(true)
	self:initEffect()
	self:refreshData()
end
function eventCrazyTrioSevenNew:initEffect()
	SoraDCreatAnimation(self.__cname, self, true)
end
function eventCrazyTrioSevenNew:initProgressBar(...)
	if not self.ocxBoxs then
		self.ocxBoxs, rechargeltCtrl = self.ocxBoxs, self.ocxBoxs
		for i = 2, 7 do
			local single
			if i == 2 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self.nodeProgress)
			end
			local num = rechargeltCtrl.getRechargeTotalConfigSeven(i).price
			if i == 7 then
				single:getChildByName("Sprite_box"):setSpriteFrame("icon_crazy_score_rank_gold.png")
			else
				single:getChildByName("Sprite_box"):setSpriteFrame("icon_crazy_score_personal.png")
			end
			single:getChildByName("Text_Num"):setString(string.formatnumberthousands(num))
			single:setTag(i)
			single:addTouchEventListener(handler(self, self.btnBoxClick))
			table.insert(self.ocxBoxs, single)
		end
	end
	self:refreshBoxState()
end
function eventCrazyTrioSevenNew:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO", handler(self, self.msgGetAwardBack))
	SoraDAddMessage(self, "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE", function(...)
		SoraDCloseLoading()
	end)
end
function eventCrazyTrioSevenNew:updateCurCrazyData()
	cumuActiveCtrl:getInitialReceiveState()
	self.crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
	dump(self.crazyTrioData, "crazyTrioData")
	self.curCrazyIndex = table.nums(self.crazyTrioData.receive) + 1
	self.showDownIndex = self.curCrazyIndex
	print("curCrazyIndex", self.curCrazyIndex)
	self.trioData = rechargeltCtrl.getRechargeTotalConfigSeven(self.curCrazyIndex)
	self.totalDollor = self.crazyTrioData.totalDollor
	self.giftStatus = cumuActiveCtrl:getCrazyTrioDataStateByIndex(self.curCrazyIndex)
end
function eventCrazyTrioSevenNew:refreshData(target, data)
	self:updateCurCrazyData()
	self:updateUI()
end
function eventCrazyTrioSevenNew:updateUI()
	if self.curCrazyIndex == 8 then
		self:removeFromParent()
		return
	end
	self:updateReward()
	self:updateDownBg()
	self.textCanGet:setVisible(false)
	self.textFrameFont:loadTexture(iconConfig[self.curCrazyIndex].frameFont .. (SoraDFIsRA() and "ar.png" or "en.png"), ccui.TextureResType.plistType)
	self.bgImage:loadTexture(iconConfig[self.curCrazyIndex].bg, ccui.TextureResType.plistType)
	local needCost = math.max(0, self.trioData.price - self.totalDollor)
	self.textInfo:setColor(cc.c3b(255, 255, 255))
	if needCost <= 0 then
		self.textInfo:setColor(cc.c3b(240, 208, 122))
		self.textInfo:setString(i18n("recharge_gift_config_seven_text_11"))
	end
	if self.curCrazyIndex == 1 then
		self.nodeProgress:setVisible(false)
		self.nodeHeroSkill:setVisible(true)
		self.bgImageDown:loadTexture("frame_qcznew01_bg_02.png", ccui.TextureResType.plistType)
		if 0 < needCost then
			iconConfig = i18n("recharge_gift_config_seven_text_11")
			iconConfig, iconConfig, i18n("recharge_gift_config_seven_text_11").var = self.trioData.gold, string.formatnumberthousands(self.trioData.gold), string.formatnumberthousands(self.trioData.gold)
			iconConfig, string.formatnumberthousands(self.trioData.gold).var, self.trioData.gold.color = self.trioData.gold, self.trioData.gold, "#FFFFFF"
			string.formatnumberthousands(self.trioData.gold).__default, self.trioData.gold.color = self.trioData.gold, "#DCC075"
			self.textInfo:setString(i18n_html("Payment_activity_optimization_text_18", i18n("recharge_gift_config_seven_text_11")))
		end
	else
		self.nodeHeroSkill:setVisible(false)
		self.nodeProgress:setVisible(true)
		self.heroNode:setVisible(false)
		self.nodeSpine:setVisible(true)
		self.frame_qcznew02_img_01_76:setSpriteFrame("frame_qcznew02_img_01.png")
		self.frame_qcznew02_img_01_76:setPositionX(SoraDFIsRA() and 430 or 230)
		self.textFrameFont:setPositionX(SoraDFIsRA() and 200 or 470)
		self.textFrameFont:setRotation(SoraDFIsRA() and 5 or -5)
		self.frame_qcznew01_bg_04_24:setVisible(false)
		self.bgImageDown:loadTexture("frame_qcznew02_bg_02.png", ccui.TextureResType.plistType)
		if 0 < needCost then
			iconConfig = i18n_html("Payment_activity_optimization_text_18", i18n("recharge_gift_config_seven_text_11"))
			i18n_html("Payment_activity_optimization_text_18", i18n("recharge_gift_config_seven_text_11")).var1 = string.formatnumberthousands(needCost)
			iconConfig, iconConfig, i18n_html("Payment_activity_optimization_text_18", i18n("recharge_gift_config_seven_text_11")).var2 = self.trioData.gold, string.formatnumberthousands(self.trioData.gold), string.formatnumberthousands(self.trioData.gold)
			iconConfig, string.formatnumberthousands(self.trioData.gold).var1, self.trioData.gold.color = self.trioData.gold, self.trioData.gold, "#FFFFFF"
			iconConfig, string.formatnumberthousands(self.trioData.gold).var2, self.trioData.gold.color = self.trioData.gold, self.trioData.gold, "#FFFFFF"
			string.formatnumberthousands(self.trioData.gold).__default, self.trioData.gold.color = self.trioData.gold, "#F0D07A"
			self.textInfo:setString(i18n_html("Payment_activity_optimization_text_32", i18n_html("Payment_activity_optimization_text_18", i18n("recharge_gift_config_seven_text_11"))))
		end
		self:initProgressBar()
	end
	self.nodeCanGet:setVisible(self.giftStatus == giftStatus.noClaim)
	self.nodeExtend:setVisible(self.giftStatus ~= giftStatus.noClaim)
	self:updateHeroText()
	if self.giftStatus ~= giftStatus.noClaim then
		self:initExtendNode()
	end
end
function eventCrazyTrioSevenNew:refreshBoxState()
	local totalWidth = self.lBarProgress:getContentSize().width
	local lastPos = SoraDFPosX(-totalWidth / 2 + 20, 0)
	local beginPos = SoraDFPosX(totalWidth / 2 - 60, 0)
	local posXOffset = (lastPos - beginPos) / 5
	_ENV = nil
	;(nil).var = string.formatnumberthousands(self.totalDollor)
	self.textTotalGold:setString(i18n("Payment_activity_optimization_text_23", nil))
	local nowIndex = self.curCrazyIndex
	local isFirstNotGet = true
	for i = 2, 7 do
		local parent = self.ocxBoxs[i - 1]
		self.ocxBoxs[i - 1]:setPosition(beginPos + posXOffset * (i - 2), 25)
		local spBox = self.ocxBoxs[i - 1]:getChildByName("Sprite_box")
		spBox:setColor(cc.c3b(255, 255, 255))
		spBox:stopAllActions()
		spBox:setRotation(0)
		if parent.effectBox then
			parent.effectBox:setVisible(false)
		end
		local spDa = self.ocxBoxs[i - 1]:getChildByName("Sprite_daojuwk")
		spDa:setVisible(false)
		local state = cumuActiveCtrl:getCrazyTrioDataStateByIndex(i)
		if state == giftStatus.claimed then
			self.ocxBoxs[i - 1]:getChildByName("Sprite_box"):setColor(cc.c3b(120, 120, 120))
			nowIndex = i
		elseif state == giftStatus.noClaim then
			if not parent.effectBox then
				parent.effectBox = SoraDCreatAnimationEx("dytx_box_effect", nil, true)
				parent.effectBox:setPosition(cc.p(spBox:getContentSize().width / 2, spBox:getContentSize().height / 2))
				parent.effectBox:addTo(spBox, 1)
			end
			parent.effectBox:setVisible(true)
			_UPVALUE5_ = parent.effectBox
			parent.effectBox[1] = cca.rotateTo(0.25, 12)
			parent.effectBox[2] = cca.rotateTo(0.2, -8)
			parent.effectBox[3] = cca.rotateTo(0.2, 6)
			parent.effectBox[4] = cca.rotateTo(0.15, -3)
			parent.effectBox[5] = cca.rotateTo(0.15, 1)
			parent.effectBox[6] = cca.rotateTo(0.15, 0)
			parent.effectBox[7] = cca.rotateTo(0.15, 0)
			parent.effectBox[8] = cca.rotateTo(0.15, 0)
			local seq = cca.seq(parent.effectBox)
			spBox:runAction(cc.RepeatForever:create(seq))
			nowIndex = i
		elseif state == giftStatus.noReach and isFirstNotGet then
			isFirstNotGet = false
			if not parent.effectBox then
				parent.effectBox = SoraDCreatAnimationEx("dytx_box_effect", nil, true)
				parent.effectBox:setPosition(cc.p(spBox:getContentSize().width / 2, spBox:getContentSize().height / 2))
				parent.effectBox:addTo(spBox, 1)
			end
			parent.effectBox:setVisible(true)
		end
	end
	if rechargeltCtrl.getRechargeTotalConfigNum() >= nowIndex + 1 then
		local nextTarget = rechargeltCtrl.getRechargeTotalConfigSeven(nowIndex + 1).price
		local nowTarget = rechargeltCtrl.getRechargeTotalConfigSeven(nowIndex).price
		local preTarget = nowIndex == 2 and 0 or rechargeltCtrl.getRechargeTotalConfigSeven(nowIndex - 1).price
		local totalDis = (nowIndex - 1) / 6 * 100 + math.abs(posXOffset) * (self.totalDollor - nowTarget) / (nextTarget - nowTarget) * 100 / totalWidth
		print("lthaaa", self.totalDollor, nowIndex, math.abs(posXOffset) * (self.totalDollor - nowTarget) / (nextTarget - nowTarget) * 100 / totalWidth)
		self.lBarProgress:setPercent(totalDis)
	else
		self.lBarProgress:setPercent(100)
	end
end
function eventCrazyTrioSevenNew:updateHeroText()
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local skillIDs = table.keys(heroltCtrl:getMaxQualitySkillInfoByHeroID(1710))
	table.sort(skillIDs)
	for k, v in ipairs(self.textList) do
		local des = heroltCtrl:getSkillDes(skillIDs[k], gHeroQuality.MAXRANK)
		v:setString(i18n(des))
	end
end
function eventCrazyTrioSevenNew:updateReward(index)
	local trioData
	if index then
		trioData = rechargeltCtrl.getRechargeTotalConfigSeven(index)
	else
		trioData = self.trioData
	end
	local rechargeltCtrl, sortList = rechargeltCtrl.getRechargeTotalConfigSeven(index), rechargeltCtrl.getRechargeTotalConfigSeven(index)
	local rechargeltCtrl, paddingArray = index, index
	local rechargeltCtrl, specialItemNode
	_UPVALUE2_ = nil
	;(nil)[1] = "itemID"
	;(nil)[2] = "itemNum"
	local result = serviceFunctions.tableFormat(trioData.result, nil)
	local specialShowItem = trioData.display_special
	local isSpecialShow = function(itemId)
		for i, v in ipairs(specialShowItem) do
			if v == itemId then
				return true
			end
		end
	end
	for i = 1, table.nums(result) do
		local itemAward = self.award[i]
		if itemAward then
			itemAward:initData(result[i].itemID, result[i].itemNum)
			itemAward:removeCoolSquare()
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.65)
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.nodeReward)
			itemAward:initData(result[i].itemID, result[i].itemNum)
			self.award[i] = itemAward
		end
		if not isSpecialShow(result[i].itemID) then
			table.insert(sortList, itemAward)
			table.insert(paddingArray, 10)
			itemAward:setRealScale(0.65)
			itemAward:hideCoolSquare()
		else
			table.insert(specialItemNode, itemAward)
			itemAward:setRealScale(0.8)
			if 1 < self.curCrazyIndex then
				itemAward:showCrazyYellowCoolSquare()
			else
				itemAward:showCrazyRedCoolSquare()
			end
		end
	end
	for i = table.nums(result) + 1, table.nums(self.award) do
		self.award[i]:setVisible(false)
	end
	table.insert(sortList, SoraDGetChildByName(self.nodeReward, "frame_qcznew01_plus"))
	table.insert(paddingArray, 10)
	for i, v in ipairs(specialItemNode) do
		table.insert(sortList, v)
		table.insert(paddingArray, 10)
	end
	SoraDAlignNodeArrayOnCenterX(0, sortList, SoraDFIsRA(), paddingArray)
end
function eventCrazyTrioSevenNew:refreshDownUI(index)
	if self.showDownIndex == index then
		return
	end
	self.showDownIndex = index
	self:updateReward(index)
	self:initExtendNode(index)
	local trioData = rechargeltCtrl.getRechargeTotalConfigSeven(index)
	local needCost = math.max(0, trioData.price - self.totalDollor)
	if 0 < needCost then
		rechargeltCtrl = nil
		;(nil).var1 = string.formatnumberthousands(needCost)
		rechargeltCtrl, rechargeltCtrl, (nil).var2 = trioData.gold, string.formatnumberthousands(trioData.gold), string.formatnumberthousands(trioData.gold)
		rechargeltCtrl, string.formatnumberthousands(trioData.gold).var1, trioData.gold.color = trioData.gold, trioData.gold, "#FFFFFF"
		rechargeltCtrl, string.formatnumberthousands(trioData.gold).var2, trioData.gold.color = trioData.gold, trioData.gold, "#FFFFFF"
		string.formatnumberthousands(trioData.gold).__default, trioData.gold.color = trioData.gold, "#F0D07A"
		self.textInfo:setString(i18n_html("Payment_activity_optimization_text_32", nil, (string.formatnumberthousands(trioData.gold))))
	else
		self.textInfo:setString(i18n("recharge_gift_config_seven_text_11"))
	end
end
function eventCrazyTrioSevenNew:updateBuyButton()
	if self.curGiftID then
		self.btn_buy:setVisible(true)
		print("curGiftID", self.curGiftID)
		local giftInfo = rechargeltCtrl.getGiftConfigByIndex(self.curGiftID)
		local showPrice, isGetPrice = paymentManager.judgePrice(self.curGiftID, giftInfo.rechargeAmount)
		self.text_nowPrice:setString(showPrice)
		local discount = giftInfo.originalPrice / giftInfo.rechargeAmount
		local oriShowPrice = paymentManager.calculateDiscount(self.curGiftID, showPrice, discount, giftInfo.originalPrice)
		self.text_oriPrice:setString(oriShowPrice)
	else
		self.btn_buy:setVisible(false)
	end
end
function eventCrazyTrioSevenNew:initExtendNode(index)
	local config = rechargeltCtrl.getCrazyTrioSevenGiftConfig(index or self.curCrazyIndex)
	self.btn_buy:setVisible(false)
	self.scroll:refreshList(config)
	self.scroll:scrollToWheelIndex(1)
end
function eventCrazyTrioSevenNew:updateDownBg()
	self.centerNode:setVisible(self.curCrazyIndex > 1)
end
function eventCrazyTrioSevenNew:refreshGiftID(index, itemData)
	dump(itemData, "eventCrazyTrioSevenNew")
	if itemData.recommendId == self.curGiftID then
		return
	end
	if self.lastNode then
		self.lastNode:hideAction()
	end
	self.curGiftID = itemData.recommendId
	self.lastNode = itemData.node
	self.lastNode:showAction(itemData)
	self:updateBuyButton()
end
function eventCrazyTrioSevenNew:updateWheelDressScaleAndPos(node)
	local scale = 1.0
	local opacity
	local minScale = 0.8
	local maxScale = display.height < 960 and 0.9 or 1
	local radius = 800
	local minOpacity = 178.5
	local maxOpacity = 255
	local scrollInner = self.scroll:getInnerContainer()
	local posX = node:getPositionX() + node:getNodeWidth() / 2
	local offsetX = scrollInner:getPositionX()
	local halfW = self.scroll:getContentSize().width / 2
	local centerX = halfW - offsetX
	local deltaX = math.min(halfW, math.abs(centerX - posX))
	local alpha = math.min(maxScale, math.max(0, 1.0 - deltaX / 257))
	scale = SoraDLerpNumber(minScale, maxScale, alpha)
	print("scale", scale)
	if node.setContentScale then
		node:setContentScale(scale)
	end
	if node.setContentOpacity then
		opacity = SoraDLerpNumber(minOpacity, maxOpacity, alpha)
		node:setContentOpacity(opacity)
	end
end
function eventCrazyTrioSevenNew:btnGetRewardClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		cumuActiveCtrl:sendReqClaimSevenNew(self.curCrazyIndex)
		SoraDShowLoading(self)
	end
end
function eventCrazyTrioSevenNew:btnBoxClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		if index < self.curCrazyIndex then
			SoraDShowMsgTip(i18n("common_text_1892"))
		else
			self:refreshDownUI(index)
		end
	end
end
function eventCrazyTrioSevenNew:btnDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("Payment_activity_optimization_text_27", rechargeltCtrl.getVarTable()))
	end
end
function eventCrazyTrioSevenNew:readyBuy(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if device.platform == "mac" then
			local cheatCtrl = SoraDGetCtrl("cheatCtrl")
			_ENV = nil
			;(nil).command = "czbd"
			;(nil).param = self.curGiftID
			cheatCtrl:reqCheat(nil, nil)
			return
		end
		local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
		local giftInfo = rechargeltCtrl.getGiftConfigByIndex(self.curGiftID)
		if giftInfo.jumpType == 2 and clientEventMgr.judgeIsOpen(giftInfo.activityID) then
			if giftInfo.activityID == gActivityTimeActivityID.ORIENT_PRINCE_GIFT then
				local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
				princeGiftCtrl:reqBuyPackage(self.curGiftID)
			else
				paymentManager.normalGiftBuyClassify(self.curGiftID)
				paymentManager.OnemtReadyBuy(self.curGiftID, gRechargeActiveFromEnum.ROAD22)
			end
		elseif giftInfo.jumpType == 1 then
			paymentManager.normalGiftBuyClassify(self.curGiftID)
			paymentManager.OnemtReadyBuy(self.curGiftID, gRechargeActiveFromEnum.ROAD22)
		elseif giftInfo.jumpType == 3 then
			local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
			local retValue = privilegeGiftCtrl:getErrByRechargeID(self.curGiftID)
			local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
			local privilegeGiftRead = include("privilegeGiftRead")
			local curLv = privilegeGiftRead.getVipLvByRechargeID(self.curGiftID)
			if retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH then
				local comStr = ""
				self.vipInfo = lordInfoCtrl:getVipDetails()
				if curLv <= VIP_SVIP_LV then
					if curLv > self.vipInfo.level then
						comStr = i18n("common_text_1147")
					end
				elseif curLv > self.vipInfo.level then
					comStr = i18n("common_text_4456")
				end
				SoraDShowMsgTip(comStr)
				return
			end
			if retValue == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
				SoraDShowMsgTip(i18n("common_text_3833"))
				return
			end
			paymentManager.normalGiftBuyClassify(self.curGiftID)
		elseif giftInfo.jumpType == 4 then
			local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
			princeGiftNewCtrl:reqBuyPackage(self.curGiftID)
			SoraDShowLoading()
		end
	end
end
function eventCrazyTrioSevenNew:msgCallBack(target, data)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		self:removeFromParent()
		return
	end
end
function eventCrazyTrioSevenNew:msgGetAwardBack(target, data)
	dump(data, "eventCrazyTrioSevenNew:refreshData", 20)
	SoraDCloseLoading(self)
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
	end
	self:refreshData()
end
function eventCrazyTrioSevenNew:onExitPanel()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:eventCrazyTrioSevenNew:isShowInDown~bool", nil) and self.curCrazyIndex >= 2 then
		_ENV = "Game:eventCrazyTrioSevenNew:isShowInDown~bool"
		;("Game:eventCrazyTrioSevenNew:isShowInDown~bool").msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH"
		;("Game:eventCrazyTrioSevenNew:isShowInDown~bool").showInDown = true
		SoraDSendMessage("Game:eventCrazyTrioSevenNew:isShowInDown~bool")
	end
end
function eventCrazyTrioSevenNew:endShow()
	if self.curCrazyIndex == 8 then
		self:removeFromParent()
		return
	end
end
function eventCrazyTrioSevenNew:createSingleNode()
	local csbnode = self.singleNode:clone()
	local node = include("eventCrazyGiftSingle").new(csbnode)
	node:setVisible(true)
	node:setScroll(self.scroll)
	node:setNodeSize(cc.size(224, 96))
	node:setPositionY(0)
	return node
end
return eventCrazyTrioSevenNew
