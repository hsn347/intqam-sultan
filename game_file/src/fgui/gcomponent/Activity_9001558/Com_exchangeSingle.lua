local activity_9001558_Ctrl = SoraDGetCtrl("activity_9001558_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_exchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001558/Com_exchangeSingle", Com_exchangeSingle)
function Com_exchangeSingle:onInit()
	self.fields.CheckBox:addClickListener(handler(self, self.onClickCheckBox))
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Sprite_line:fix()
		self.fields.Sprite_arrow:fix()
	end
end
function Com_exchangeSingle:onShow()
end
function Com_exchangeSingle:initData(cfg, otherData)
	self.cfg = cfg
	self.shopItemID = cfg.shopItemID
	self.fromItemID = gIDDef.STELLAR_ODYSSEY_POINT
	self.fromItemCount = cfg.exchangeItem
	self.toItemID = cfg.shopItem[1]
	self.toItemCount = cfg.shopItem[2]
	self.limitNum = cfg.limit
	self.fields.CheckBox:setSelected(cfg.isRemind)
	self.fields.Com_itemFrom:initData(self.fromItemID)
	self.ownCount = activity_9001558_Ctrl:getExchangePoint()
	self.fields.Com_itemFrom:setNum(self.ownCount, self.fromItemCount)
	self.fields.Com_itemTo:initData(self.toItemID, self.toItemCount)
	self.leftCount = math.max(0, self.limitNum - cfg.curExchangeNum)
	local countStr = string.format("%d/%d", self.leftCount, self.limitNum)
	_ENV = nil
	;(nil).count = countStr
	self.fields.Text_leftCount:setString(i18n("common_text_1673", nil))
	if self.leftCount <= 0 then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		if self.ownCount <= 0 then
			self.fields.Button_exchange:setTitleColor(display.COLOR_RED)
		else
			self.fields.Button_exchange:setTitleColor(display.COLOR_WHITE)
		end
	end
end
function Com_exchangeSingle:onClickCheckBox(context)
	SoraDPlaySound()
	if self.fields.CheckBox:isSelected() then
		activity_9001558_Ctrl:reqRemind(self.shopItemID, 1)
		self.cfg.isRemind = true
	else
		activity_9001558_Ctrl:reqRemind(self.shopItemID, 0)
		self.cfg.isRemind = false
	end
end
function Com_exchangeSingle:onClickExchange(context)
	SoraDPlaySound()
	local remainTime = activity_9001558_Ctrl:getReceiveStageRemainTime()
	if 0 < remainTime then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(remainTime)
		SoraDShowMsgTip(i18n("spices_text_08", nil))
		return
	end
	if self.ownCount < self.fromItemCount then
		SoraDShowMsgTip(i18n("gemEnchant_text_62"))
	elseif 0 >= self.leftCount then
		SoraDShowMsgTip(i18n("common_text_1865"))
	else
		local maxNum = math.floor(self.ownCount / self.fromItemCount)
		if self.leftCount and 0 < self.leftCount then
			maxNum = math.min(maxNum, self.leftCount)
		end
		_ENV, _ENV, _ENV = i18n("common_text_1865")
		i18n("common_text_1865").targetID = self.toItemID
		i18n("common_text_1865").exchangeID = self.fromItemID
		i18n("common_text_1865").singCount = self.fromItemCount
		i18n("common_text_1865").curNum = maxNum
		i18n("common_text_1865").exchangeData, i18n("common_text_1865").singleGet = i18n("common_text_1865")
		i18n("common_text_1865").exchangeCfg, i18n("common_text_1865").exchangeHandler = i18n("common_text_1865")
		uiManager:show("newShopSingleBuy", i18n("common_text_1865"))
	end
end
return Com_exchangeSingle
