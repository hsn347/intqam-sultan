local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemUseBuy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityInfoView/Com_itemUseBuy", Com_itemUseBuy)
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
function Com_itemUseBuy:initData(data)
	self.itemID = data.iid
	self.count = data.count or 0
	self.gold = data.gold or 0
	self.shopID = data.shopID
	self.fields.item:initData(self.itemID)
	self.fields.item:setNumText(self.count)
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	if self.count > 0 then
		self.fields.Button_use:setVisible(true)
		self.fields.Btn_buyUse:setVisible(false)
	else
		self.fields.Button_use:setVisible(false)
		self.fields.Btn_buyUse:setVisible(true)
		self.fields.Btn_buyUse:setCostTitle(self.gold)
	end
end
function Com_itemUseBuy:btnUseClick()
	SoraDPlaySound()
	itemLogic.useItemsLine(self.itemID, self.count)
end
function Com_itemUseBuy:btnBuyUseClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.gold) then
		local ret, src = itemLogic.checkItemSpecialTip(self.itemID)
		local itemUseAndBuy = function()
			local buffCtrl = SoraDGetCtrl("buffCtrl")
			local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
			local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
			local buffID = backpackltCtrl:getResult(self.itemID)
			local buffEffect = buffltCtrl:getEffectType(buffID)
			local haveBuff = buffCtrl:queryCityBuff(buffEffect)
			local second = buffltCtrl:getTime(buffID)
			local effect, effectType = buffltCtrl:getEffect(buffID)
			local constantRead = include("constantRead")
			local buffStackingTime = constantRead.getConstValue("BUFF_STACKING_TIME", 86400)
			if backpackltCtrl:checkBuffStackingItem(self.itemID) and haveBuff and (haveBuff:getProperty("id") == buffID or haveBuff:getProperty("effectType") == buffEffect and haveBuff:getProperty("effect") == effect) and buffStackingTime < haveBuff:getRemainTime() + second then
				_ENV = nil
				_ENV = nil
				;(nil).time = SoraDConvertSecondToStringHour(buffStackingTime)
				;(nil).content = i18n("common_text_4912", nil)
				;(nil).confirmString = i18n("common_text_204")
				;(nil).cancelString = i18n("common_text_185")
				;(nil).confirmFunc = function()
					itemLogic = nil
					;(nil).needBuy = true
					if not itemLogic.checkItemSpecial(self.itemID, 1, nil) then
						shopCtrl:reqBuyInItemShop(self.shopID, 1, true)
					end
				end
				uiManager:show("MessageBox", nil)
			else
				_ENV = nil
				;(nil).needBuy = true
				if not itemLogic.checkItemSpecial(self.itemID, 1, nil) then
					shopCtrl:reqBuyInItemShop(self.shopID, 1, true)
				end
			end
		end
		if ret then
			SoraDShowMsgBox(src, i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					itemUseAndBuy()
				end
			end)
		else
			_ENV = i18n("common_text_204")
			i18n("common_text_204").var = self.gold
			i18n("common_text_204").name = publicRead.getName(self.itemID)
			src = i18n("common_text_4593", (i18n("common_text_204")))
			SoraDShowMsgBox(src, i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					itemUseAndBuy()
				end
			end)
		end
	end
end
return Com_itemUseBuy
