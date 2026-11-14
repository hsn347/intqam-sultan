local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001658/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBtnBuy))
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(cfg)
	self.cfg = cfg
	self.ownCount = backpackCtrl:getItemCount(cfg.exchangeitem)
	self.fields.Com_item:initData(cfg.shopitem, cfg.shopitemnum)
	local itemName = itemDesRead.getName(cfg.shopitem)
	self.fields.Text_name:setString(itemName)
	local exchangedCount = activityExchangeMallCtrl:getExchangeNum(self.activityID, cfg.shopItemID)
	self.leftCount = math.max(0, cfg.limitnum - exchangedCount)
	local countStr = string.format("%d/%d", self.leftCount, cfg.limitnum)
	self.fields.Text_num:setString(countStr)
	self.fields.Button_buy:initData(cfg.exchangeitem, cfg.exchangenum)
	local enabled = true
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		enabled = false
	elseif self.leftCount < 0 or self.ownCount < cfg.exchangenum then
		enabled = false
	end
	self.fields.Button_buy:setEnabled(enabled)
end
function Com_shopSingle:onClickBtnBuy()
	SoraDPlaySound()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDShowMsgTip(i18n("BUBBLE_LEGEND_TEXT_134"))
		return
	end
	_ENV, _ENV, _ENV = i18n("BUBBLE_LEGEND_TEXT_134")
	i18n("BUBBLE_LEGEND_TEXT_134").targetID = self.cfg.shopitem
	i18n("BUBBLE_LEGEND_TEXT_134").exchangeID = self.cfg.exchangeitem
	i18n("BUBBLE_LEGEND_TEXT_134").singCount = self.cfg.exchangenum
	i18n("BUBBLE_LEGEND_TEXT_134").curNum = math.min(self.leftCount, math.floor(self.ownCount / self.cfg.exchangenum))
	i18n("BUBBLE_LEGEND_TEXT_134").exchangeData, i18n("BUBBLE_LEGEND_TEXT_134").singleGet = i18n("BUBBLE_LEGEND_TEXT_134")
	i18n("BUBBLE_LEGEND_TEXT_134").exchangeCfg, i18n("BUBBLE_LEGEND_TEXT_134").exchangeHandler = i18n("BUBBLE_LEGEND_TEXT_134")
	uiManager:show("newShopSingleBuy", i18n("BUBBLE_LEGEND_TEXT_134"))
end
return Com_shopSingle
