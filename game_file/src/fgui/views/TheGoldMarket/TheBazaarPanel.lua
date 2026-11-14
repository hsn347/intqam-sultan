local goldSoukCtrl = SoraDGetCtrl("goldSoukCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local goldSoukRead = include("goldSoukRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local TheBazaarPanel = class("TheBazaarPanel", baseFguiPanel)
function TheBazaarPanel:ctor(...)
	self.super.ctor(self, ...)
	print("TheBazaarPanel:ctor", self.viewName)
end
function TheBazaarPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function TheBazaarPanel:onInit()
	print("=======TheBazaarPanel:onInit")
	self.activityID = gActivityTimeActivityID.GOLD_SOUK_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001422"), handler(self, self.onClickClose))
	self.fields.Text_refresh:setString(i18n("ramddantent_text_01"))
	self.fields.List_shop:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_gold:addClickListener(handler(self, self.onBtnGoldClick))
	self.fields.Btn_gold:fixChildrenPos()
end
function TheBazaarPanel:onItemRenderer(index, obj)
	obj:initData(self.showShopCfg[index + 1])
end
function TheBazaarPanel:onShow()
	print("=======TheBazaarPanel:onShow")
	local timeInfo = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timeInfo then
		local leftTime = timeInfo.timerNode.timer:getRemainTime()
		self.fields.Label_time:beginTime(leftTime)
	end
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.classtype = param.classtype or 1
	print("self.classtype=====", self.classtype, goldSoukCtrl:getRefreshLv())
	local shopCfg = goldSoukRead.getShopCfg(goldSoukCtrl:getRefreshLv(), self.classtype)
	self.showShopCfg, _ENV = goldSoukCtrl:getRefreshLv(), goldSoukCtrl:getRefreshLv()
	local index = 1
	for k, v in ipairs(shopCfg) do
		if not self.showShopCfg[index] then
			_ENV = self.showShopCfg[index]
		end
		self.showShopCfg[index] = self.showShopCfg[index]
		self.showShopCfg[index].group = index
		if not self.showShopCfg[index].cfg then
			_ENV = self.showShopCfg[index].cfg
		end
		self.showShopCfg[index].cfg = self.showShopCfg[index].cfg
		table.insert(self.showShopCfg[index].cfg, v)
		if k % 2 == 0 then
			index = index + 1
		end
	end
	self:initData()
end
function TheBazaarPanel:initData()
	self.fields.com_score:initData()
	self.fields.List_shop:setNumItems(#self.showShopCfg)
	self.fields.Btn_gold:setString(goldSoukCtrl:getSoukCoin())
end
function TheBazaarPanel:onHide()
	print("=======TheBazaarPanel:onHide")
end
function TheBazaarPanel:onDispose()
	print("=======TheBazaarPanel:onDispose")
end
function TheBazaarPanel:onBtnGoldClick()
	SoraDPlaySound()
	print("跳转到充值礼包======")
	_UPVALUE3_ = print
	print[1] = 19041
	print[2] = 19042
	local print[3], giftArray = 19043, print
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = giftArray
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, giftArray)
		panel:show()
	end
end
return TheBazaarPanel
