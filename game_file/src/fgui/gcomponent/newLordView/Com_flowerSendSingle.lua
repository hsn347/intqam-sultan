local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local flowerSysCtrl = SoraDGetCtrl("flowerSysCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_flowerSendSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_flowerSendSingle", Com_flowerSendSingle)
function Com_flowerSendSingle:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Button_cost:setString(i18n("common_text_4436"))
	self.fields.Button_cost:addClickListener(handler(self, self.btnBuyAndUseClick))
	self:fixChildrenPos()
end
function Com_flowerSendSingle:onShow()
end
function Com_flowerSendSingle:initData(id, uid)
	self.id = id
	self.uid = uid
	self.fields.Com_item:initData(self.id)
	self.count = backpackCtrl:getItemCount(self.id)
	self.fields.Text_own:setString(self.count)
	self.fields.Button_use:setVisible(self.count > 0)
	local itemInfo = shopltCtrl:getShopItemByItemID(self.id)
	self.fields.Button_cost:setVisible(self.count <= 0)
	if itemInfo then
		self.fields.Button_cost:setCost(gIDDef.GOLD, itemInfo.price)
	end
	self.fields.Text_name:setString(publicRead.getName(self.id))
	self.fields.Text_des:setString(publicRead.getDes(self.id))
end
function Com_flowerSendSingle:btnUseClick()
	SoraDPlaySound()
	_ENV, _ENV = nil, nil
	;(nil).id = self.id
	;(nil).itemData, (nil).count = nil, self.count
	;(nil).handle = function(target, data)
		flowerSysCtrl:sendGift(self.uid, data.id, data.num)
	end
	uiManager:show("newItemSingleUse", nil)
end
function Com_flowerSendSingle:btnBuyAndUseClick()
	SoraDPlaySound()
	local shopItem = shopltCtrl:getShopItemByItemID(self.id)
	if shopItem then
		local maxCount = backpackltCtrl:getUseMax(shopItem.id)
		_ENV = nil
		_ENV, (nil).itemData = nil, shopItem
		;(nil).otherData, (nil).maxCount = nil, maxCount
		;(nil).useAndBuy = true
		uiManager:show("newShopSingleBuy", nil)
	else
		SoraDShowMsgTip(i18n("notice_0170"))
	end
end
return Com_flowerSendSingle
