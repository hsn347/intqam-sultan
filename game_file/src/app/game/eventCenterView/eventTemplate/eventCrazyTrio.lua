local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rechargeltCtrl = include("rechargeltCtrl")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
_ENV = gametop.playertop_
gametop.playertop_.noReach = 1
gametop.playertop_.noClaim = 2
local gametop.playertop_.claimed, giftStatus = 3, gametop.playertop_
local eventCrazyTrio = class("eventCrazyTrio", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, "eventCrazyTrio"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).bg = "frame_scz_bg_01.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).name = "trio_text_03"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).frameFont = "frame_scz_font_01_"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).normalFont = "trio_text_07"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).posY = 332
_ENV, ("eventCrazyTrio")[1], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).rewardPosY = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, 30
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).bg = "frame_scz_bg_02.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).name = "trio_text_04"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).frameFont = "frame_scz_font_02_"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).normalFont = "trio_text_08"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).posY = 372
_ENV, ("eventCrazyTrio")[2], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).rewardPosY = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, 70
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).bg = "frame_scz_bg_03.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).name = "trio_text_05"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).frameFont = "frame_scz_font_03_"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).normalFont = "trio_text_09"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).posY = 410
;("eventCrazyTrio")[3], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end).rewardPosY = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCrazyTrio")
	end
	return target
end, 70
local iconConfig = "eventCrazyTrio"
function eventCrazyTrio:endShow()
	if self.realCurPage == 4 then
		self:removeFromParent()
		return
	end
end
function eventCrazyTrio:ctor()
	self.isAddToPopManager = true
	self.giftStatus = giftStatus.noReach
	self.award, giftStatus, self.realCurPage = giftStatus.noReach, giftStatus.noReach, 1
	self.bgImage = SoraDGetChildByName(self, "Image_BG")
	self.bgImage:ignoreContentAdaptWithSize(true)
	self.btnGoRecharge = SoraDGetChildByName(self, "Button_Go")
	self.btnGoRecharge:addTouchEventListener(handler(self, self.btnRechargeClick))
	self.btnGoRecharge:setTitleText(i18n("common_text_2002"))
	self.btnGetReward = SoraDGetChildByName(self, "Button_Get")
	self.btnGetReward:addTouchEventListener(handler(self, self.btnGetRewardClick))
	self.btnGetReward:setTitleText(i18n("common_text_1146"))
	self.textList = SoraDGetChildsArrayByName(self, "Text_HeroProperty_", 4, 1)
	self.nodeReward = SoraDGetChildByName(self, "Node_award")
	self.singleReward = SoraDGetChildByName(self.nodeReward, "CCS_commonItemAward_1")
	self.singleReward:setVisible(false)
	self.textNeedM = SoraDGetChildByName(self, "Text_LeftM")
	self.textFrameFont = SoraDGetChildByName(self, "Image_Lang")
	self.textFrameFont:ignoreContentAdaptWithSize(true)
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	giftStatus = self
	self.text = iconConfig[self.realCurPage].normalFont
	self.x = self.textFrameFont:getPositionX()
	self.y = self.textFrameFont:getPositionY() + 135
	self.align = cc.TEXT_ALIGNMENT_LEFT
	self.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.size = 30
	self.color = cc.c3b(255, 200, 100)
	self.dimensions = cc.size(420, 100)
	self.labelTitle = display.newTTFLabel(self)
	self.labelTitle:setAnchorPoint(SoraDFIsRA() and cc.p(1, 1) or cc.p(0, 1))
	self.labelTitle:setVisible(GameLanguageCopy ~= "ar" and GameLanguageCopy ~= "en" and not IsArClient)
	self.labelTitle:addTo(self.textFrameFont:getParent())
	self.textFrameFont:setVisible(GameLanguageCopy == "ar" or GameLanguageCopy == "en" or IsArClient)
	self:refreshData()
	SoraDPlaySound("uicontrol", 25)
end
function eventCrazyTrio:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO", handler(self, self.refreshData))
end
function eventCrazyTrio:refreshData(target, data)
	dump(data, "eventCrazyTrio:refreshData", 20)
	SoraDCloseLoading(self)
	if not activityShowCtrl:isActivityOpen(gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY) then
		self:removeFromParent()
		return
	end
	local hasAward
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
		hasAward = self.realCurPage + 1
	end
	local trioData = rechargeltCtrl.getRechargeTotalConfig()
	local crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
	local totalDollor = crazyTrioData.totalDollor
	local receiveInfo = crazyTrioData.receive
	self.realCurPage = hasAward and hasAward or table.nums(receiveInfo) + 1
	if self.realCurPage == 4 then
		self:removeFromParent()
		_ENV = self
		self.msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH"
		self.redPointState = false
		SoraDSendMessage(self)
		return
	end
	self.textFrameFont:setPositionY(iconConfig[self.realCurPage].posY)
	self.labelTitle:setPositionY(self.textFrameFont:getPositionY() + 108)
	if totalDollor >= trioData[self.realCurPage].price then
		self.giftStatus = giftStatus.noClaim
	else
		self.giftStatus = giftStatus.noReach
	end
	self.bgImage:loadTexture(iconConfig[self.realCurPage].bg, ccui.TextureResType.plistType)
	self.textFrameFont:loadTexture(iconConfig[self.realCurPage].frameFont .. (SoraDFIsRA() and "ar.png" or "en.png"), ccui.TextureResType.plistType)
	if self.realCurPage == 1 then
		_ENV = nil
		;(nil).gold = trioData[self.realCurPage].gold
		self.textInfo:setString(i18n("trio_text_01", nil))
	else
		_ENV = i18n("trio_text_01", nil)
		i18n("trio_text_01", nil).charge = "$" .. string.format("%0.2f", trioData[self.realCurPage].price)
		i18n("trio_text_01", nil).gold = trioData[self.realCurPage].gold
		self.textInfo:setString(i18n("trio_text_02", i18n("trio_text_01", nil)))
	end
	self.labelTitle:setString(i18n(iconConfig[self.realCurPage].normalFont))
	_ENV = i18n(iconConfig[self.realCurPage].normalFont)
	i18n(iconConfig[self.realCurPage].normalFont).charge = "$" .. string.format("%0.2f", trioData[self.realCurPage].price - totalDollor)
	self.textNeedM:setString(i18n("trio_text_06", i18n(iconConfig[self.realCurPage].normalFont)))
	self.textNeedM:setVisible(self.giftStatus == giftStatus.noReach and self.realCurPage ~= 1)
	self.btnGoRecharge:setVisible(self.giftStatus == giftStatus.noReach)
	self.btnGetReward:setVisible(self.giftStatus == giftStatus.noClaim)
	_ENV = self.btnGetReward
	self.btnGetReward.msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH"
	self.btnGetReward.redPointState = self.giftStatus == giftStatus.noClaim
	SoraDSendMessage(self.btnGetReward)
	self:upDataReward()
	self:updateHeroText()
end
function eventCrazyTrio:updateHeroText()
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local skillIDs = table.keys(heroltCtrl:getMaxQualitySkillInfoByHeroID(1710))
	table.sort(skillIDs)
	for k, v in ipairs(self.textList) do
		v:setVisible(self.realCurPage == 1)
		if self.realCurPage == 1 then
			local des = heroltCtrl:getSkillDes(skillIDs[k], gHeroQuality.MAXRANK)
			_ENV = heroltCtrl:getMaxQualitySkillInfoByHeroID(1710)
			heroltCtrl:getMaxQualitySkillInfoByHeroID(1710).name = des
			heroltCtrl:getMaxQualitySkillInfoByHeroID(1710).abbr = i18n("common_text_1904")
			v:setString(i18n("common_text_186", heroltCtrl:getMaxQualitySkillInfoByHeroID(1710)))
		end
	end
end
function eventCrazyTrio:upDataReward()
	local trioData = rechargeltCtrl.getRechargeTotalConfig()
	iconConfig = nil
	;(nil)[1] = "itemID"
	;(nil)[2] = "itemNum"
	local result = serviceFunctions.tableFormat(trioData[self.realCurPage].result, nil)
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
	self.nodeReward:setPositionY(iconConfig[self.realCurPage].rewardPosY)
	self.textInfo:setPositionY(iconConfig[self.realCurPage].rewardPosY + 100)
end
function eventCrazyTrio:btnRechargeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
			if princeGiftNewCtrl:getNewPrinceData() then
				_ENV = nil
				;(nil).rechargeID = princeGiftNewCtrl:getActiviyID()
				uiManager:show("rechargeView", nil)
			elseif self.realCurPage == 1 and self.giftStatus == giftStatus.noReach then
				_ENV = nil
				;(nil).toCategory = gRechargeCenterCategory.DAILYADISCOUNT
				uiManager:show("rechargeView", nil)
			elseif self.giftStatus == giftStatus.noReach and self.realCurPage == 2 then
				_ENV = nil
				;(nil).toCategory = gRechargeCenterCategory.MONTH
				;(nil).toNodeTag = 0
				uiManager:show("rechargeView", nil)
			else
				_ENV = nil
				;(nil).toCategory = gRechargeCenterCategory.LIMITGIFT
				uiManager:show("rechargeView", nil)
			end
		else
			local panel = SoraDCreatePanel("rechargeView")
			if panel:isNewPriceGfitOpen() then
				local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
				panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT, princeGiftNewCtrl:getActiviyID())
			elseif panel:isOpen(gRechargeCenterCategory.DAILYADISCOUNT) and self.realCurPage == 1 and self.giftStatus == giftStatus.noReach then
				panel:expect2SelectTab(gRechargeCenterCategory.DAILYADISCOUNT)
			elseif self.giftStatus == giftStatus.noReach and self.realCurPage == 2 then
				panel:expect2SelectTab(gRechargeCenterCategory.MONTH)
			elseif panel:isOpen(gRechargeCenterCategory.LIMITGIFT) then
				panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT)
			end
			panel:show()
		end
		paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD22)
	end
end
function eventCrazyTrio:btnGetRewardClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		cumuActiveCtrl:sendReqClaim(self.realCurPage)
		SoraDShowLoading(self)
	end
end
return eventCrazyTrio
