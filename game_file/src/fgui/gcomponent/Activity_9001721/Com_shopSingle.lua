local publicRead = include("publicRead")
local activity_9001721_Read = include("activity_9001721_Read")
local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001721/Com_shopSingle", Com_shopSingle)
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
	self.fields.Com_item:initData(self.data.shopitem, self.data.shopitemnum)
	self.fields.Text_name:setString(publicRead.getName(self.data.shopitem))
	self.leftCount = data.leftCount
	publicRead = publicRead.getName(self.data.shopitem)
	publicRead.getName(self.data.shopitem).left = fguiHelper.getColorString(self.leftCount > 0 and "#FFFBD5" or "#BE2828", self.leftCount)
	publicRead.getName(self.data.shopitem).limit = self.data.limitnum
	self.fields.Text_limit:setString(i18n("%{left}/%{limit}", publicRead.getName(self.data.shopitem)))
	self.isEnough = backpackCtrl:getItemCount(self.data.exchangeitem) >= self.data.exchangenum
	self.fields.Btn_buy:initData(self.data.exchangeitem, self.data.exchangenum)
	self.fields.Btn_buy:setStatus(self.isEnough, false)
	self.fields.Btn_buy:setGrayed(self.leftCount <= 0)
end
function Com_shopSingle:onClick_Btn_buy()
	SoraDPlaySound()
	if not self.isEnough then
		SoraDShowMsgTip(i18n("worldboss_monkey_07"))
		return
	end
	if self.leftCount < 1 then
		SoraDShowMsgTip(i18n("worldboss_monkey_18"))
		return
	end
	local maxNum = math.min(self.leftCount, math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum))
	_ENV, _ENV, _ENV = math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum)
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).targetID = self.data.shopitem
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).exchangeID = self.data.exchangeitem
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).singCount = self.data.exchangenum
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).curNum = maxNum
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).exchangeData, math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).singleGet = math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum)
	math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).exchangeCfg, math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum).exchangeHandler = math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum)
	uiManager:show("newShopSingleBuy", math.floor(backpackCtrl:getItemCount(self.data.exchangeitem) / self.data.exchangenum))
end
return Com_shopSingle
