local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local publicRead = include("publicRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local universalDebrisExchangeView = class("universalDebrisExchangeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("universalDebrisExchangeView")
	end
	return target
end)
function universalDebrisExchangeView:ctor()
	self.exchageNum = 0
	self.costNum = 0
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("heroskill_title_01"))
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spriteTo = SoraDGetChildByName(self, "sprite_To")
	self.txtTo = SoraDGetChildByName(self, "text_to")
	self.spriteFrom = SoraDGetChildByName(self, "sprite_from")
	self.txtFrom = SoraDGetChildByName(self, "text_from")
	self.btnExchange = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_ex")
	self.nodeRes = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.nodeRes:setSliderCallBack(handler(self, self.sliderBack))
	_ENV, self.tableArrowOpacity, _ENV = self.nodeRes.setSliderCallBack, self.nodeRes.setSliderCallBack, self.nodeRes.setSliderCallBack
	self.nodeRes.setSliderCallBack[1] = SoraDGetChildByName(self, "Sprite_arrow_1")
	self.nodeRes.setSliderCallBack[2] = SoraDGetChildByName(self, "Sprite_arrow_2")
	self.tableArrow, self.nodeRes.setSliderCallBack[3] = self.nodeRes.setSliderCallBack, SoraDGetChildByName(self, "Sprite_arrow_3")
	self.btnExchange:addTouchEventListener(handler(self, self.btnExchangeClickCallBack))
	self:flashingAnimation()
end
function universalDebrisExchangeView:initData(heroID)
	self.chipID = heroltCtrl:getChipID(heroID)
	self.exchangeInfo = heroltCtrl:getExchangeInfo(self.chipID)
	self.spriteTo:setSpriteFrame(publicRead.getIcon(self.chipID))
	self.txtTo:setString(publicRead.getName(self.chipID))
	self.spriteFrom:setSpriteFrame(publicRead.getIcon(self.exchangeInfo.changeID))
	self.txtFrom:setString(publicRead.getName(self.exchangeInfo.changeID))
	SoraDSetTextWidthHeight(self.txtFrom, cc.size(240, 48))
	SoraDSetTextWidthHeight(self.txtTo, cc.size(240, 48))
	self.itemNum = backpackCtrl:getItemCount(self.exchangeInfo.changeID)
	heroltCtrl = self.exchangeInfo.changeID
	self.exchangeInfo.changeID.maxValue = math.min(999, math.floor(self.itemNum / self.exchangeInfo.changeNum))
	self.exchangeInfo.changeID.minValue = 1
	self.exchangeInfo.changeID.curValue = 1
	self.nodeRes:initData(self.exchangeInfo.changeID)
	self.btnExchange:setIconTexture(publicRead.getIcon(self.exchangeInfo.changeID))
	self.btnExchange:setTitleStr(i18n("common_text_1889"))
	self.btnExchange:setTextGoldColor(cc.c3b(255, 255, 255))
end
function universalDebrisExchangeView:sliderBack(value)
	local num = self.exchangeInfo and self.exchangeInfo.changeNum or 1
	self.costNum = value * num
	self.exchageNum = value
	_ENV = nil
	;(nil).total = self.itemNum or 1
	;(nil).member = value * num
	self.btnExchange:setGoldText(i18n("common_text_155", nil))
end
function universalDebrisExchangeView:flashingAnimation()
	local delay = isQuick and 0.2 or 1
	for i, v in ipairs(self.tableArrow) do
		table.insert(self.tableArrowOpacity, v:getOpacity() / 255)
	end
	for i, v in ipairs(self.tableArrow) do
		v:stopAllActions()
		v:setOpacity(self.tableArrowOpacity[i])
		_UPVALUE3_ = nil
		;(nil)[1] = cca.delay((i - 1) * 0.2 * delay)
		;(nil)[2] = cca.fadeTo(0.1 * delay, self.tableArrowOpacity[i])
		;(nil)[3] = cca.delay((#self.tableArrow - i) * 0.2 * delay + 0.3 * delay)
		;(nil)[4] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[5] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[6] = cca.fadeTo(0.2 * delay, 0)
		v:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
function universalDebrisExchangeView:btnExchangeClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).num = self.costNum
		;(nil).item = publicRead.getName(self.exchangeInfo.changeID)
		;(nil).num1 = self.exchageNum
		;(nil).item1 = publicRead.getName(self.chipID)
		SoraDShowMsgBox(i18n("heroskill_text_09", nil), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES and self.exchangeInfo then
				heroCtrl:exchangeChipsReq(self.exchangeInfo.index, self.nodeRes:getSliderCurValue())
				self:removeFromParent()
			end
		end)
	end
end
return universalDebrisExchangeView
