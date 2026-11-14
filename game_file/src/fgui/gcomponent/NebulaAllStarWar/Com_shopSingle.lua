local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.fields.CheckBox:addClickListener(handler(self, self.onClickCheckBox))
	self.fields.Text_notify:setString(i18n("atlantiswar_text_0224"))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.Text_tip:setString(i18n("NebulaAllstar_295"))
	self.fields.Text_tip:setVisible(false)
	self:fixChildrenPos()
	self.fields.Sprite_line:fix()
	self.fields.Sprite_arrow:fix()
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(cfg)
	self.cfg = cfg
	self.shopItemID = cfg.shopItemID
	self.fromItemID = gIDDef.NEBULA_ALLSTAR_QUIZ_COIN
	self.fromItemCount = cfg.exchangeitem
	self.toItemID = cfg.shopitem[1]
	self.toItemCount = cfg.shopitem[2]
	self.limitNum = cfg.limitnum
	local record = nebulaAllStarCtrl:getViewerExchangeRecord(self.shopItemID)
	self.fields.CheckBox:setSelected(record.remind ~= false)
	self.fields.Com_itemFrom:initData(self.fromItemID)
	self.ownCount = nebulaAllStarCtrl:getViewerQuizCoin()
	self.fields.Com_itemFrom:setNum(self.ownCount, self.fromItemCount)
	self.fields.Com_itemTo:initData(self.toItemID, self.toItemCount)
	self.fields.Text_tip:setVisible(self.cfg.itemtype == 2)
	local exchangedCount = record and record.count or 0
	self.leftCount = math.max(0, self.limitNum - exchangedCount)
	local countStr = string.format("%d/%d", self.leftCount, self.limitNum)
	_ENV = nil
	;(nil).count = countStr
	self.fields.Text_leftCount:setString(i18n("common_text_1673", nil))
	if self.cfg.itemtype == 2 then
		local isInBattle = nebulaAllStarUtil.checkActivityState(nebulaAllStarRead.NEBULA_ALL_STAR_STATE.BATTLE)
		self.controllers.c1:setSelectedIndex(isInBattle and 0 < self.leftCount and 0 or 1)
	else
		self.controllers.c1:setSelectedIndex(0 < self.leftCount and 0 or 1)
	end
end
function Com_shopSingle:onClickCheckBox()
	SoraDPlaySound()
	if self.fields.CheckBox:isSelected() then
		nebulaAllStarCtrl:reqViewerExchangeRemind(self.shopItemID, true)
	else
		nebulaAllStarCtrl:reqViewerExchangeRemind(self.shopItemID, false)
	end
end
function Com_shopSingle:onClickExchange()
	if self.controllers.c1:getSelectedIndex() == 1 then
		return
	end
	SoraDPlaySound()
	if self.ownCount < self.fromItemCount then
		_ENV = nil
		;(nil).item = i18n("item_name_1679")
		SoraDShowMsgTip(i18n("common_text_1806", nil))
	elseif self.leftCount <= 0 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	else
		local maxNum = math.floor(self.ownCount / self.fromItemCount)
		maxNum = math.min(maxNum, self.leftCount)
		_ENV, _ENV, _ENV = i18n("common_text_1865")
		i18n("common_text_1865").targetID = self.toItemID
		i18n("common_text_1865").exchangeID = self.fromItemID
		i18n("common_text_1865").singCount = self.fromItemCount
		i18n("common_text_1865").exchangeData, i18n("common_text_1865").curNum = i18n("common_text_1865")
		i18n("common_text_1865").exchangeCfg, i18n("common_text_1865").exchangeHandler = i18n("common_text_1865")
		uiManager:show("newShopSingleBuy", i18n("common_text_1865"))
	end
end
return Com_shopSingle
