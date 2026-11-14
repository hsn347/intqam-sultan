local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemUseBuy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_itemUseBuy", Com_itemUseBuy)
function Com_itemUseBuy:onInit()
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Btn_buyUse:setString(i18n("common_text_4436"))
	self.fields.Btn_buyUse:addClickListener(handler(self, self.btnBuyUseClick))
	self.fields.item:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_use:fixPos()
	self.fields.Btn_buyUse:fixPos()
end
function Com_itemUseBuy:onShow()
end
function Com_itemUseBuy:initData(data)
	self.data = data
	self.itemType = backpackltCtrl:getItemType(self.data.iid)
	if self.data.limitData then
		self.fields.item:initData(self.data.iid)
		backpackltCtrl = nil
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
	_UPVALUE2_ = SoraDPlaySound
	SoraDPlaySound[1] = gItemType.VIP_POINT
	local SoraDPlaySound[2], vipList = gItemType.S_VIP_POINT, SoraDPlaySound
	if SoraDisInList(self.itemType, vipList) and SoraDGetVipLv() >= SVIP_LV10_LIMITED then
		SoraDShowMsgBox(i18n("circus_text_25"), i18n("common_text_204"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				include("itemLogic").useItemsLine(self.data.iid, self.data.count)
			end
		end)
	else
		include("itemLogic").useItemsLine(self.data.iid, self.data.count)
	end
end
function Com_itemUseBuy:btnBuyUseClick()
	SoraDPlaySound()
	local buyItem = function(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if SoraDEnoughGold(self.data.gold) then
		local vipInfo = lordInfoCtrl:getVipDetails()
		if vipInfo.level == VIP_MAX_LV - 1 and gItemType.VIP_POINT == self.itemType then
			SoraDShowMsgBox(i18n("common_text_1500"), i18n("common_text_204"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					buyItem(self.data.iid)
				end
			end)
		else
			buyItem(self.data.iid)
		end
	end
end
return Com_itemUseBuy
