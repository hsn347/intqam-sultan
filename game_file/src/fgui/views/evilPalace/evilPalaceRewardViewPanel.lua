local monsterpalaceCtrl = SoraDGetCtrl("monsterpalaceCtrl")
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local evilPalaceRewardViewPanel = class("evilPalaceRewardViewPanel", baseFguiPanel)
function evilPalaceRewardViewPanel:ctor(...)
	evilPalaceRewardViewPanel.super.ctor(self, ...)
	print("evilPalaceRewardViewPanel:ctor", self.viewName)
end
function evilPalaceRewardViewPanel:onInit()
	print("=======evilPalaceRewardViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Text_tip:setString(i18n("common_text_3283"))
	self.fields.Text_des:setString(i18n("Challenge_SnowWolf_text_09"))
	self.fields.Button_gain:setString(i18n("common_text_1889"))
	self.fields.Button_gain:addClickListener(handler(self, self.btnGainClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:fixPos()
	self.fields.icon_box:fixPos()
end
function evilPalaceRewardViewPanel:onShow()
	print("=======evilPalaceRewardViewPanel:onShow")
	self.index = self.param.index
	self.isCanExchange = self.param.isCanExchange
	local priceConfig = clone(monsterpalaceltCtrl:get_feahtershop(monsterpalaceCtrl:getZeroLv()))
	self.myInfo = priceConfig[self.index]
	self:initView()
end
function evilPalaceRewardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], index + 1)
end
function evilPalaceRewardViewPanel:initView()
	self.fields.icon_box:setSpriteFrame(self.myInfo.picture)
	self.fields.Panel_bg:setString(i18n(self.myInfo.boxName))
	_UPVALUE2_ = i18n(self.myInfo.boxName)
	i18n(self.myInfo.boxName)[1] = "id"
	i18n(self.myInfo.boxName)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(self.myInfo.rewards, i18n(self.myInfo.boxName))
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Button_gain:setEnabled(self.isCanExchange)
end
function evilPalaceRewardViewPanel:btnGainClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_3284"), i18n("common_text_054"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			SoraDPlaySound()
			monsterpalaceCtrl:feathershopbuyReq(self.index)
			self:close()
		end
	end)
end
return evilPalaceRewardViewPanel
