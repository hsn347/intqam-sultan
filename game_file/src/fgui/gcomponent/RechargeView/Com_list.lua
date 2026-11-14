local publicRead = include("publicRead")
local vipLocalData = include("vipLocalData")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function Com_list:onShow()
end
function Com_list:initData(data, index)
	local cfg = data.itemData
	self.isGold = data.isGold or false
	self.fields.sheer:setVisible(index % 2 == 1)
	if self.isGold then
		self.fields.Btn_go:setString(i18n("common_text_2002"))
		self.fields.icon:setSpriteFrame(publicRead.getIcon(gIDDef.GOLD))
		_ENV = publicRead.getIcon(gIDDef.GOLD)
		_ENV = publicRead.getIcon(gIDDef.GOLD)
		publicRead.getIcon(gIDDef.GOLD).n = paymentManager.returnCurrencyByChannel()
		publicRead.getIcon(gIDDef.GOLD).c = paymentManager.exchangeByChannel(string.formatnumberthousands(cfg.total))
		publicRead.getIcon(gIDDef.GOLD).price = i18n("common_text_2358", publicRead.getIcon(gIDDef.GOLD))
		self.fields.Text_name:setString(i18n("common_text_1977", publicRead.getIcon(gIDDef.GOLD)))
		self:isConditionMet(premiumStoreCtrl:getDollor() >= cfg.total)
	else
		self.fields.Btn_go:setString(i18n("common_text_452"))
		self.fields.icon:setSpriteFrame(publicRead.getIcon(gIDDef.VIP_POINT))
		self:isConditionMet(SoraDGetVipLv() >= cfg.viplv)
		local num, isVip = vipLocalData:getVipNum(cfg.viplv)
		if isVip then
			self.fields.Text_name:setString(i18n("recharge_label_014") .. num)
		else
			_ENV = publicRead.getIcon(gIDDef.VIP_POINT)
			publicRead.getIcon(gIDDef.VIP_POINT).lv = num
			self.fields.Text_name:setString(i18n("common_text_3974", publicRead.getIcon(gIDDef.VIP_POINT)))
		end
	end
end
function Com_list:isConditionMet(isMet)
	self.controllers.c1:setSelectedIndex(isMet and 1 or 0)
end
function Com_list:btnGoClick()
	SoraDPlaySound()
	if self.isGold then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	else
		uiManager:show("vipCenterView")
	end
end
return Com_list
