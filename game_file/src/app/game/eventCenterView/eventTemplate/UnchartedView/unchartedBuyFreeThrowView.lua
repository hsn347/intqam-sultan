local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local unchartedBuyFreeThrowView = class("unchartedBuyFreeThrowView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedBuyFreeThrowView")
	end
	return target
end)
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
function unchartedBuyFreeThrowView:ctor()
	self:initControls()
	self:initData()
end
function unchartedBuyFreeThrowView:initControls()
	self.panelTotal = SoraDGetChildByName(self, "panel_total")
	self.txtSecondDiscount = SoraDGetChildByName(self, "text_secondDiscount")
	self.txtThirdDiscount = SoraDGetChildByName(self, "text_thirdDiscount")
	self.txtFirstPlusNum = SoraDGetChildByName(self, "BitmapFontLabel_first")
	self.txtSecondPlusNum = SoraDGetChildByName(self, "BitmapFontLabel_second")
	self.txtThirdPlusNum = SoraDGetChildByName(self, "BitmapFontLabel_third")
	self.txtFirstGold = SoraDGetChildByName(self, "text_firstGold")
	self.txtSecondGold = SoraDGetChildByName(self, "text_secondGold")
	self.txtThirdGold = SoraDGetChildByName(self, "text_thirdGold")
	self.txtTodayRemain = SoraDGetChildByName(self, "text_todayRemain")
	self.btnGiveUp = SoraDGetChildByName(self, "btn_giveUp")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.btnFirst = SoraDGetChildByName(self, "btn_first")
	self.btnSecond = SoraDGetChildByName(self, "btn_second")
	self.btnThird = SoraDGetChildByName(self, "btn_third")
	self.imageFirst = SoraDGetChildByName(self, "image_first")
	self.imageSecond = SoraDGetChildByName(self, "image_second")
	self.imageThird = SoraDGetChildByName(self, "image_third")
	self.txtSecondDiscount:setString("90%")
	self.txtThirdDiscount:setString("80%")
	self.txtFirstGold:setString("200")
	self.txtSecondGold:setString("900")
	self.txtThirdGold:setString("1600")
	self.btnGiveUp:setTitleText(i18n("common_text_185"))
	self.btnBuy:setTitleText(i18n("common_text_282"))
	self.btnBuy:setTag(1)
	self.imageFirst:loadTexture("frame_jz_bdxx2.png", ccui.TextureResType.plistType)
	self.panelTotal:setPositionY(display.height / 2)
	self.btnFirst:setTag(1)
	self.btnSecond:setTag(5)
	self.btnThird:setTag(10)
	self.btnFirst:addTouchEventListener(handler(self, self.chooseClickCallBack))
	self.btnSecond:addTouchEventListener(handler(self, self.chooseClickCallBack))
	self.btnThird:addTouchEventListener(handler(self, self.chooseClickCallBack))
	self.btnGiveUp:addTouchEventListener(handler(self, self.giveUpClickCallBack))
	self.btnBuy:addTouchEventListener(handler(self, self.buyClickCallBack))
	self.needGold = 0
end
function unchartedBuyFreeThrowView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_REMAIN_BUY_THROW_BACK", handler(self, self.initData))
end
function unchartedBuyFreeThrowView:initData()
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	unchartedCtrl = nil
	;(nil).num = unchartedInfo.buyThrow
	self.txtTodayRemain:setString(i18n("Secret_explore_text_56", nil))
	if lordInfoCtrl:getBaseInfo().gold < 200 or unchartedInfo.buyThrow < 1 then
		SoraDSetGray(self.imageFirst, true, true)
		self.txtFirstGold:setColor(CORLOR_GREY)
		self.txtFirstPlusNum:setColor(CORLOR_GREY)
		self.btnFirst:setEnabled(false)
	end
	if lordInfoCtrl:getBaseInfo().gold < 900 or unchartedInfo.buyThrow < 5 then
		SoraDSetGray(self.imageSecond, true, true)
		self.txtSecondGold:setColor(CORLOR_GREY)
		self.txtSecondPlusNum:setColor(CORLOR_GREY)
		self.btnSecond:setEnabled(false)
	end
	if lordInfoCtrl:getBaseInfo().gold < 1600 or unchartedInfo.buyThrow < 10 then
		SoraDSetGray(self.imageThird, true, true)
		self.txtThirdGold:setColor(CORLOR_GREY)
		self.txtThirdPlusNum:setColor(CORLOR_GREY)
		self.btnThird:setEnabled(false)
	end
end
function unchartedBuyFreeThrowView:giveUpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function unchartedBuyFreeThrowView:buyClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		unchartedCtrl:sendBuyFreeThrowTimesMsg(button:getTag())
		self:removeFromParent()
	end
end
function unchartedBuyFreeThrowView:chooseClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == 1 then
			self.imageFirst:loadTexture("frame_jz_bdxx2.png", ccui.TextureResType.plistType)
			self.imageSecond:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.imageThird:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.btnBuy:setTag(1)
		elseif button:getTag() == 5 then
			self.imageFirst:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.imageSecond:loadTexture("frame_jz_bdxx2.png", ccui.TextureResType.plistType)
			self.imageThird:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.btnBuy:setTag(5)
		elseif button:getTag() == 10 then
			self.imageFirst:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.imageSecond:loadTexture("frame_jz_bdxx.png", ccui.TextureResType.plistType)
			self.imageThird:loadTexture("frame_jz_bdxx2.png", ccui.TextureResType.plistType)
			self.btnBuy:setTag(10)
		end
	end
end
return unchartedBuyFreeThrowView
