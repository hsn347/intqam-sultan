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
local eventCrazyTrioNew = class("eventCrazyTrioNew", function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end)
_ENV, _ENV = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, "eventCrazyTrioNew"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_01_1.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_03"
_ENV, ("eventCrazyTrioNew")[1], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, "frame_scz_font_01_"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_04"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_02_"
_ENV, ("eventCrazyTrioNew")[2], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1503
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_03_"
_ENV, ("eventCrazyTrioNew")[3], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1403
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_04_"
_ENV, ("eventCrazyTrioNew")[4], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1502
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_05_"
_ENV, ("eventCrazyTrioNew")[5], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1401
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_06_"
_ENV, ("eventCrazyTrioNew")[6], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1402
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).bg = "frame_qcz_bg_03.png"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).frameFont = "frame_qcz_font_07_"
;("eventCrazyTrioNew")[7], (function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end).headId = function(target)
	print("eventCrazyTrioNew", target)
	if not target then
		target = SoraDCreateTouchPanel("eventCrazyTrioNew")
	else
		target = SoraDCreateTouchPanel("eventCrazyTrioSevenNew")
	end
	return target
end, 1405
local iconConfig = "eventCrazyTrioNew"
function eventCrazyTrioNew:ctor()
	self.activityID = gActivityTimeActivityID.CRAZY_SEPTET_ACTIVITY
	self.isAddToPopManager = true
	self.giftStatus = giftStatus.noReach
	self.award, _ENV, self.curCrazyIndex = giftStatus.noReach, giftStatus.noReach, 1
	self.totalNum = 7
	self.spFire = SoraDGetChildByName(self, "Sprite_Fire")
	self.spFire:setVisible(false)
	self.bgImage = SoraDGetChildByName(self, "Image_BG")
	self.bgImageDown = SoraDGetChildByName(self, "Image_BG_Down")
	self.bgImage:ignoreContentAdaptWithSize(true)
	self.nodeSpine = SoraDGetChildByName(self, "Node_Spine")
	self.nodeSpine:setVisible(false)
	self.heroNode = SoraDGetChildByName(self, "Node_Hero")
	self.heroSpineNode = SoraDGetChildByName(self, "Node_SpineHero")
	self.nodeCanGet = SoraDGetChildByName(self, "Node_CanGet")
	self.textCanGet = SoraDGetChildByName(self.nodeCanGet, "Text_CanGet")
	self.btnGetReward = SoraDGetChildByName(self.nodeCanGet, "Button_Get")
	self.btnGetReward:addTouchEventListener(handler(self, self.btnGetRewardClick))
	self.btnGetReward:setTitleText(i18n("common_text_1146"))
	self.textList = SoraDGetChildsArrayByName(self, "Text_HeroProperty_", 4, 1)
	self.nodeReward = SoraDGetChildByName(self, "Node_award")
	self.singleReward = SoraDGetChildByName(self.nodeReward, "CCS_commonItemAward_1")
	self.singleReward:setVisible(false)
	self.textFrameFont = SoraDGetChildByName(self, "Image_Lang")
	self.textFrameFont:ignoreContentAdaptWithSize(true)
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.textInfo = SoraDChangeTextToHtml(self.textInfo)
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
	local nodeSize = cc.size(300, 128)
	i18n("recharge_gift_config_seven_text_01").listData, _ENV, _ENV = i18n("recharge_gift_config_seven_text_01")
	i18n("recharge_gift_config_seven_text_01").nodeSizeType = gScrollViewNodeSizeType.dynamic
	i18n("recharge_gift_config_seven_text_01").createNodeHandler = handler(self, self.createSingleNode)
	i18n("recharge_gift_config_seven_text_01").selWheelNodeHandler = handler(self, self.refreshGiftID)
	i18n("recharge_gift_config_seven_text_01").nodeDirection = SoraDFIsRA() and gScrollViewNodeDirection.right or gScrollViewNodeDirection.left
	i18n("recharge_gift_config_seven_text_01").scrollViewType = gScrollViewType.wheel
	i18n("recharge_gift_config_seven_text_01").paddingLeft = self.scroll:getContentSize().width / 2 - nodeSize.width / 2
	i18n("recharge_gift_config_seven_text_01").paddingRight = self.scroll:getContentSize().width / 2 - nodeSize.width / 2
	i18n("recharge_gift_config_seven_text_01").nodeClass = include("eventCrazyGiftSingle")
	i18n("recharge_gift_config_seven_text_01").handler = handler(self, self.updateWheelDressScaleAndPos)
	self.scroll:init(i18n("recharge_gift_config_seven_text_01"))
	self:initEffect()
	self:refreshData()
	SoraDPlaySound("uicontrol", 25)
end
function eventCrazyTrioNew:initEffect()
	local loop = true
	local cssFilePath = getCCSPath(self._name)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function eventCrazyTrioNew:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO", handler(self, self.msgGetAwardBack))
end
function eventCrazyTrioNew:refreshData(target, data)
	self:updateCurCrazyData()
	self:updateUI()
end
function eventCrazyTrioNew:endShow()
	if self.curCrazyIndex == 8 then
		self:removeFromParent()
		return
	end
end
function eventCrazyTrioNew:updateUI()
	if self.curCrazyIndex == 8 then
		self:removeFromParent()
		return
	end
	self:updateReward()
	self.textCanGet:setVisible(false)
	self.bgImage:loadTexture(iconConfig[self.curCrazyIndex].bg, ccui.TextureResType.plistType)
	self.textFrameFont:loadTexture(iconConfig[self.curCrazyIndex].frameFont .. (SoraDFIsRA() and "ar.png" or "en.png"), ccui.TextureResType.plistType)
	local needCost = math.max(0, self.trioData.price - self.totalDollor)
	self.textInfo:setColor(cc.c3b(255, 255, 255))
	if needCost <= 0 then
		self.textInfo:setColor(cc.c3b(240, 208, 122))
		self.textInfo:setString(i18n("recharge_gift_config_seven_text_11"))
	end
	self:initSpine()
	if self.curCrazyIndex == 1 then
		self.spFire:setVisible(true)
		self.bgImageDown:loadTexture("frame_qcz_bg_02.png", ccui.TextureResType.plistType)
		self.textFrameFont:setPosition(cc.p(SoraDFPosX(430, 640), 445))
		if 0 < needCost then
			iconConfig = cc.p(SoraDFPosX(430, 640), 445)
			iconConfig, iconConfig, cc.p(SoraDFPosX(430, 640), 445).gold = cc.p(SoraDFPosX(430, 640), 445)
			iconConfig, self.trioData.gold.gold, cc.p(SoraDFPosX(430, 640), 445).color = cc.p(SoraDFPosX(430, 640), 445)
			self.trioData.gold.__default, cc.p(SoraDFPosX(430, 640), 445).color = cc.p(SoraDFPosX(430, 640), 445)
			self.textInfo:setString(i18n_html("trio_text_01", cc.p(SoraDFPosX(430, 640), 445)))
		end
	else
		self.heroNode:setVisible(false)
		self.textFrameFont:setPosition(cc.p(320, 365))
		self.nodeSpine:setVisible(true)
		self.bgImageDown:loadTexture("frame_qcz_bg_04.png", ccui.TextureResType.plistType)
		if 0 < needCost then
			iconConfig = cc.p(320, 365)
			cc.p(320, 365).num1 = "$" .. string.format("%0.2f", needCost)
			iconConfig, iconConfig, cc.p(320, 365).num2 = string.format("%0.2f", needCost), self.trioData.gold, self.trioData.gold
			iconConfig, self.trioData.gold.num1, string.format("%0.2f", needCost).color = string.format("%0.2f", needCost), string.format("%0.2f", needCost), "#FFFFFF"
			iconConfig, self.trioData.gold.num2, string.format("%0.2f", needCost).color = string.format("%0.2f", needCost), string.format("%0.2f", needCost), "#FFFFFF"
			self.trioData.gold.__default, string.format("%0.2f", needCost).color = string.format("%0.2f", needCost), "#F0D07A"
			self.textInfo:setString(i18n_html("recharge_gift_config_seven_text_02", cc.p(320, 365)))
		end
	end
	self.nodeCanGet:setVisible(self.giftStatus == giftStatus.noClaim)
	self.nodeExtend:setVisible(self.giftStatus ~= giftStatus.noClaim)
	self:updateHeroText()
	if self.giftStatus ~= giftStatus.noClaim then
		self:initExtendNode()
	end
	self.bgImageDown:setCapInsets(cc.rect(0, 0, 20, 170))
end
function eventCrazyTrioNew:updateCurCrazyData()
	cumuActiveCtrl:getInitialReceiveState()
	self.crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
	dump(self.crazyTrioData, "crazyTrioData")
	self.curCrazyIndex = table.nums(self.crazyTrioData.receive) + 1
	print("curCrazyIndex", self.curCrazyIndex)
	self.trioData = rechargeltCtrl.getRechargeTotalConfigSeven(self.curCrazyIndex)
	self.totalDollor = self.crazyTrioData.totalDollor
	self.giftStatus = cumuActiveCtrl:getCrazyTrioDataStateByIndex(self.curCrazyIndex)
end
function eventCrazyTrioNew:updateHeroText()
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local skillIDs = table.keys(heroltCtrl:getMaxQualitySkillInfoByHeroID(1710))
	table.sort(skillIDs)
	dump(skillIDs, "skillIDs")
	for k, v in ipairs(self.textList) do
		v:setVisible(self.curCrazyIndex == 1)
		local des = heroltCtrl:getSkillDes(skillIDs[k], gHeroQuality.MAXRANK)
		_ENV = heroltCtrl:getMaxQualitySkillInfoByHeroID(1710)
		heroltCtrl:getMaxQualitySkillInfoByHeroID(1710).name = des
		heroltCtrl:getMaxQualitySkillInfoByHeroID(1710).abbr = i18n("common_text_1904")
		v:setString(i18n("common_text_186", heroltCtrl:getMaxQualitySkillInfoByHeroID(1710)))
	end
end
function eventCrazyTrioNew:updateReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "itemID"
	;(nil)[2] = "itemNum"
	local result = serviceFunctions.tableFormat(self.trioData.result, nil)
	for index = 1, table.nums(result) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(result[index].itemID, result[index].itemNum)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.8)
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.nodeReward)
			itemAward:initData(result[index].itemID, result[index].itemNum)
			self.award[index] = itemAward
		end
	end
	for i = table.nums(result) + 1, table.nums(self.award) do
		self.award[i]:setVisible(false)
	end
	SoraDToCenter(self.nodeReward, 100, SoraDFIsRA())
end
function eventCrazyTrioNew:updateBuyButton()
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
function eventCrazyTrioNew:initExtendNode()
	local config = rechargeltCtrl.getCrazyTrioSevenGiftConfig(self.curCrazyIndex)
	self:updateBuyButton()
	self.scroll:refreshList(config)
	self.scroll:scrollToWheelIndex(1)
end
function eventCrazyTrioNew:initSpine()
	if self.curCrazyIndex == 1 then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(1710)
		local scale = 0.8
		local spine_npc = cc.criSprite.createCriSprite(spineCfg, false, true)
		spine_npc:setAnchorPoint(cc.p(0.5, 0))
		spine_npc:setScale(scale)
		spine_npc:setPosition(-160, -480)
		spine_npc:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		spine_npc:addTo(self.heroSpineNode)
		if spine_npc.setAutoCull then
			spine_npc:setAutoCull(false)
		end
		if not SoraDFIsRA() then
			self.heroSpineNode:setScaleX(-scale)
			self.heroSpineNode:setScaleY(scale)
		else
			self.heroSpineNode:setScaleX(scale)
			self.heroSpineNode:setScaleY(scale)
		end
	else
		local info = lordSpineDef.getLordSpineInfo(iconConfig[self.curCrazyIndex].headId)
		if info then
			if self.spine then
				self.spine:removeFromParent()
				self.spine = nil
			end
			self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
			local offset = info.offset or cc.p(0, 0)
			self.spine:setPosition(cc.p(0 + offset.x, -150 + offset.y))
			self.spine:setAnimation(0, "animation", true)
			self.spine:addTo(self.nodeSpine, -10)
			self.spine:setScale(0.8)
		end
	end
end
function eventCrazyTrioNew:createSingleNode()
	local csbnode = self.singleNode:clone()
	node = include("eventCrazyGiftSingle").new(csbnode)
	node:setVisible(true)
	node:setScroll(self.scroll)
	node:setNodeSize(cc.size(300, 128))
	node:setPositionY(0)
	return node
end
function eventCrazyTrioNew:refreshGiftID(index, itemData)
	dump(itemData, "eventCrazyTrioNew")
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
function eventCrazyTrioNew:updateWheelDressScaleAndPos(node)
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
	local alpha = math.min(maxScale, math.max(0, 1.0 - deltaX / 276))
	scale = SoraDLerpNumber(minScale, maxScale, alpha)
	if node.setContentScale then
		node:setContentScale(scale)
	end
	if node.setContentOpacity then
		opacity = SoraDLerpNumber(minOpacity, maxOpacity, alpha)
		node:setContentOpacity(opacity)
	end
end
function eventCrazyTrioNew:btnGetRewardClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		cumuActiveCtrl:sendReqClaimNew(self.curCrazyIndex)
		SoraDShowLoading(self)
	end
end
function eventCrazyTrioNew:readyBuy(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
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
		end
	end
end
function eventCrazyTrioNew:msgCallBack(target, data)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		self:removeFromParent()
		return
	end
end
function eventCrazyTrioNew:msgGetAwardBack(target, data)
	dump(data, "eventCrazyTrioNew:refreshData", 20)
	SoraDCloseLoading(self)
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
	end
	self:refreshData()
end
function eventCrazyTrioNew:onExitPanel()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:eventCrazyTrioNew:isShowInDown~bool", nil) and self.curCrazyIndex >= 2 then
		_ENV = "Game:eventCrazyTrioNew:isShowInDown~bool"
		;("Game:eventCrazyTrioNew:isShowInDown~bool").msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH"
		;("Game:eventCrazyTrioNew:isShowInDown~bool").showInDown = true
		SoraDSendMessage("Game:eventCrazyTrioNew:isShowInDown~bool")
	end
end
return eventCrazyTrioNew
