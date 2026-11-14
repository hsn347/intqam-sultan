local iceCumuRechargeCtrl = SoraDGetCtrl("iceCumuRechargeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://IceFestival/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Button_Get:addClickEventListener(handler(self, self.onClickButton))
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.data = data
	self.fields.Text_Day:setString(data.days)
	local price = iceCumuRechargeCtrl:getCurPrice(data.days)
	self.fields.Button_Get:setVisible(true)
	self.fields.Button_Get:setReddot(false)
	if data.status == gBtnTargetStatusDef.GET then
		self.fields.Button_Get:setEnabled(true)
		self.fields.Button_Get:setString(i18n("common_text_1146"))
		self.fields.Button_Get:setReddot(true)
	elseif data.status == gBtnTargetStatusDef.GOT then
		self.fields.Button_Get:setEnabled(false)
		self.fields.Button_Get:setString(i18n("common_text_1892"))
	elseif data.status == gBtnTargetStatusDef.GO then
		self.fields.Button_Get:setEnabled(false)
		self.fields.Button_Get:setString(i18n("common_text_2139"))
	elseif data.status == gBtnTargetStatusDef.NONE then
		self.fields.Button_Get:setVisible(false)
	end
	iceCumuRechargeCtrl = i18n("common_text_2139")
	iceCumuRechargeCtrl, iceCumuRechargeCtrl, i18n("common_text_2139").price = "$%s/$%s", string.format("$%s/$%s", price, data.amount), string.format("$%s/$%s", price, data.amount)
	string.format("$%s/$%s", price, data.amount).price, ("$%s/$%s").color = "$%s/$%s", data.status == gBtnTargetStatusDef.GO and "#FF6C6C" or "#FFFFFF"
	self.fields.Text_des:setString(i18n_html("recharge_new_user_text02", i18n("common_text_2139")))
	self.fields.List_Award:setNumItems(#self.data.reward)
end
function Com_list:onClickButton()
	SoraDPlaySound()
	iceCumuRechargeCtrl:reqCumuRecharge2023Claim(self.data.type, self.data.index)
end
function Com_list:onItemRederer(index, target)
	local reward = self.data.reward[index + 1]
	target:getChildByName("item"):initData(reward.id, reward.count)
end
return Com_list
