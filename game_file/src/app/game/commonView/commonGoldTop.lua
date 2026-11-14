local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
_ENV = gametop.playertop_
gametop.playertop_.main = 120000000
gametop.playertop_.animation = 120000005
gametop.playertop_.mainTop = 120000010
local gametop.playertop_.text, groupID = 120000015, gametop.playertop_
local CommonGoldTop = class("commonGoldTop", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonGoldTop")
	end
	return target
end)
function CommonGoldTop:ctor()
	self.openOff = true
	self.dataGold = 0
	self.oriDataGold = 0
	self.img_gold = SoraDGetChildByName(self, "Image_gold")
	self.goldRedPoint = SoraDGetChildByName(self, "Sprite_goldRedPoint")
	self.goldRedPoint:setVisible(false)
	self.btnGold = SoraDGetChildByName(self, "Button_gold")
	self.btnGold:setPressedActionEnabled(false)
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.imgBtn = SoraDGetChildByName(self, "Image_btn")
	self.spriteBtn = SoraDGetChildByName(self, "sptite_btn")
	self.btnGold:addTouchEventListener(handler(self, self.btnGoldClick))
	self:updateGold()
	self:setUIStyle()
	self.scoreTextGold = SoraDCreateScoreLabel(self.txtGold, true)
	self.uiChristmas = SoraDGetChildByName(self, "frame_chritmas_05_3")
	self.uiChristmas:setVisible(false)
end
function CommonGoldTop:initGroupNode()
	local createGroupNode = function(groupID, zOrder)
		local node = display.newNode()
		node:setGroupID(groupID, true)
		node:addTo(self)
		node:setLocalZOrder(zOrder)
	end
	createGroupNode(groupID.main, 1)
	createGroupNode(groupID.animation, 2)
	createGroupNode(groupID.mainTop, 3)
	createGroupNode(groupID.text, 4)
end
function CommonGoldTop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
end
function CommonGoldTop:setRedPoint(ret)
	self.goldRedPoint:setVisible(ret)
end
function CommonGoldTop:setUIStyle()
	self.imgBtn:setVisible(true)
	self.img_gold:setScale(0.6)
	self.img_gold:setPositionX(-25)
	self.txtGold:setPositionX(-95)
	self.txtGold:setFontSize(18)
	self.txtGold:setColor(cc.c3b(255, 255, 255))
	self:hideAnimation()
end
function CommonGoldTop:setMainUIStyle()
	self:initGroupNode()
	self.img_gold:setScale(1)
	self.img_gold:setPositionX(-149.0)
	self.txtGold:setPositionX(-62.0)
	self.txtGold:setFontSize(24)
	self.txtGold:setColor(cc.c3b(255, 255, 0))
	self.img_gold:setGroupID(groupID.mainTop)
	self.goldRedPoint:setGroupID(groupID.mainTop)
	self.btnGold:setGroupID(groupID.main)
	self.txtGold:setGroupID(groupID.text)
	self.txtGold:setGroupAuto(true)
	self.imgBtn:setGroupID(groupID.main)
	self.spriteBtn:setGroupID(groupID.animation)
	self.uiChristmas:setGroupID(groupID.mainTop)
	self.uiChristmas:setVisible(GLOBAL_MAINUI_STYLE == gMainUIStype.CHRITMAS)
end
function CommonGoldTop:showAnimation()
	self.imgBtn:setVisible(false)
	self.spriteBtn:setVisible(true)
	local frames = display.newFrames("dh_anniuzjmlv_%.2d.png", 1, 12)
	local animation = display.newAnimation(frames, 1.5 / #frames)
	self.spriteBtn:stopAllActions()
	self.spriteBtn:playAnimationForever(animation)
end
function CommonGoldTop:hideAnimation()
	self.spriteBtn:stopAllActions()
	self.spriteBtn:setVisible(false)
end
function CommonGoldTop:closeTouch()
	self.openOff = false
end
function CommonGoldTop:updateGold(target, data)
	if self.rid and self.rid ~= gIDDef.GOLD then
		return
	end
	self.dataGold = lordInfoCtrl:getBaseInfo().gold
	self:refreshGoldTxt()
end
function CommonGoldTop:refreshGoldTxt()
	if self.oriDataGold == 0 then
		self.txtGold:setString(string.formatnumberthousands(self.dataGold))
	elseif self.oriDataGold and self.dataGold then
		SoraDCreateScoreLabel(self.txtGold, true):runScoreAnimation(self.oriDataGold, self.dataGold, 1)
	end
	self.oriDataGold = self.dataGold
end
function CommonGoldTop:getGold()
	self:updateGold()
	return self.dataGold
end
function CommonGoldTop:btnGoldClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 25)
		if self.handleGoldClick then
			self.handleGoldClick()
			return
		end
		_ENV = "uicontrol"
		;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage("uicontrol")
		if self.openOff then
			advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_coin_btn)
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
			paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD07)
		end
	end
end
function CommonGoldTop:initWithData(data)
	if data.rid then
		self.rid = data.rid
		SoraChangeSpriteImage(self.img_gold, include("resDesRead").getIcon(self.rid))
		self.img_gold:ignoreContentAdaptWithSize(true)
		self.img_gold:setScale(40 / self.img_gold:getContentSize().width)
		self.oriDataGold = 0
		if self.rid ~= gIDDef.GOLD then
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_UPDATE_BASE")
		end
	end
	if data.rcount then
		self.dataGold = data.rcount
		self:refreshGoldTxt()
	end
	if data.handle then
		self.handleGoldClick = data.handle
	end
end
return CommonGoldTop
