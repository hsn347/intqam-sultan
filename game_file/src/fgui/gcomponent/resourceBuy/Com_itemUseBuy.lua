local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemUseBuy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://resourceBuy/Com_itemUseBuy", Com_itemUseBuy)
function Com_itemUseBuy:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Btn_buyUse:fixPos()
end
function Com_itemUseBuy:onShow()
end
function Com_itemUseBuy:initData(data, needResList)
	self.data = data
	self.needResList = needResList
	if self.data.limitData then
		self.fields.item:initData(self.data.iid)
		_ENV = nil
		;(nil).member = self.data.limitData.cur
		;(nil).total = self.data.limitData.max
		self.fields.item:setNumText(i18n("common_text_155", nil))
	else
		self.fields.item:initData(self.data.iid, self.data.count or 0)
	end
	self.fields.Text_name:setString(publicRead.getName(self.data.iid))
	self.fields.Text_des:setString(publicRead.getDes(self.data.iid))
	if self.data.count and self.data.count > 0 then
		self.fields.Button_use:setVisible(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostTitle(self.data.gold or 0)
	end
end
function Com_itemUseBuy:btnUseClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).needResList = self.needResList
	itemLogic.useItemsLine(self.data.iid, self.data.count or 0, nil)
end
function Com_itemUseBuy:btnBuyUseClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.data.gold or 0) then
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(self.data.iid)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			;(nil).needResList = self.needResList
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
end
return Com_itemUseBuy
