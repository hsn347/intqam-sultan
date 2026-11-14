local publicRead = include("publicRead")
local activity_9001713_Read = include("activity_9001713_Read")
local activity_9001713_Ctrl = SoraDGetCtrl("activity_9001713_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local dailyRemindManager = include("dailyRemindManager")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001713/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.fields.Btn_buy:addClickListener(handler(self, self.onClick_Btn_buy))
	self.fields.Com_item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_limit:fixPos()
	self.fields.Btn_buy:fixPos()
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(data)
	self.data = data
	self.cfg = activity_9001713_Read.getShopGoodCfg(self.data.goodsID)
	self.controllers.c1:setSelectedIndex(self.cfg.goodsLabel)
	self.fields.Lab_style:setTitle(self:getStyleTitle(self.cfg.goodsLabel))
	self.fields.Com_item:initData(self.cfg.goodsItemID, self.cfg.goodsItemCount)
	self.fields.Text_name:setString(publicRead.getName(self.cfg.goodsItemID))
	local buyCount = activity_9001713_Ctrl:getGoodsBuyCount(self.data.goodsID)
	self.leftCount = self.cfg.limit - buyCount
	self.isEnough = backpackCtrl:getItemCount(self.cfg.itemID) >= self.cfg.itemCount
	activity_9001713_Read = publicRead.getName(self.cfg.goodsItemID)
	publicRead.getName(self.cfg.goodsItemID).num = self.leftCount
	self.fields.Text_limit:setString(i18n("ANNIVERSARY_MARKET_TEXT_03", publicRead.getName(self.cfg.goodsItemID)))
	if self.leftCount > 0 then
		if self.cfg.itemCount > 0 then
			self.fields.Btn_buy:initData(self.cfg.itemID, self.cfg.itemCount)
			self.fields.Btn_buy:setStatus(self.isEnough, false)
		else
			self.fields.Btn_buy:setTitle(i18n("common_text_049"))
			self.fields.Btn_buy:setStatus(true, false)
		end
	else
		self.fields.Btn_buy:setTitle(i18n("common_text_4376"))
		self.fields.Btn_buy:setGrayed(true)
	end
end
function Com_shopSingle:getStyleTitle(goodsLabel)
	local title = i18n("common_text_049")
	if goodsLabel == 2 then
		title = i18n("lucky_text_05")
	elseif goodsLabel == 3 then
		title = i18n("common_text_438")
	end
	return title
end
function Com_shopSingle:onClick_Btn_buy()
	SoraDPlaySound()
	if self.leftCount < 1 then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_07"))
		return
	end
	if not self.isEnough then
		SoraDShowMsgTip(i18n("Frosty_Market_text_10"))
		uiManager:show("Activity_9001713_Gift")
		return
	end
	if self.cfg.itemCount > 0 and dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.activity_9001713_1) then
		_ENV = i18n("Frosty_Market_text_10")
		_ENV = i18n("Frosty_Market_text_10")
		i18n("Frosty_Market_text_10").num = self.cfg.itemCount
		i18n("Frosty_Market_text_10").item = publicRead.getName(self.cfg.itemID)
		i18n("Frosty_Market_text_10").content = i18n("common_text_4935", i18n("Frosty_Market_text_10"))
		i18n("Frosty_Market_text_10").confirmFunc = function()
			activity_9001713_Ctrl:reqBuyGood(self.data.goodsID)
		end
		i18n("Frosty_Market_text_10").remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.activity_9001713_1)
			end
		end
		uiManager:show("MessageBox", i18n("Frosty_Market_text_10"))
	else
		activity_9001713_Ctrl:reqBuyGood(self.data.goodsID)
	end
end
return Com_shopSingle
