local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local wargemResRead = include("wargemResRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemReplacePanel = class("WarGemReplacePanel", baseFguiPanel)
function WarGemReplacePanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarGemReplacePanel:ctor", self.viewName)
end
function WarGemReplacePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WarGemReplacePanel:onInit()
	print("=======WarGemReplacePanel:onInit")
	self.fields.Text_tip:setString(i18n("gemEnchant_text_74"))
	self.fields.Text_warn:setString(i18n("gemEnchant_text_75"))
	self.fields.Btn_replace:setString(i18n("common_text_1371"))
	self.fields.Btn_replace:addClickListener(handler(self, self.onReplaceClick))
	self.fields.Btn_again:setString(i18n("common_text_1372"))
	self.fields.Btn_again:addClickListener(handler(self, self.onAgainClick))
	self.fields.Com_cur:fixPos()
	self.fields.Com_to:fixPos()
	self.fields.arrow:fix()
	self.fields.Btn_replace:fixPos()
	self.fields.Btn_again:fixPos()
	self.fields.Lab_cost:fixPos()
end
function WarGemReplacePanel:onShow()
	print("=======WarGemReplacePanel:onShow")
	self.idx = self.param.data.idx
	self.lv = self.param.data.lv
	self.position = self.param.data.position
	self.rspdata = self.param.rspdata
	self:initView()
end
function WarGemReplacePanel:initView()
	local info = warGemCtrl:getEnchantedInfo(self.idx, self.lv, self.position)
	dump(info, "info===")
	local attr, val = wargemResRead.getEnchantmentAttr(info.enchantmentID, info.amount, info.strengthenLv, true)
	self.fields.Com_cur:initData(info.strengthenLv, attr, val)
	local toAttr, toVal = wargemResRead.getEnchantmentAttr(self.rspdata.retEnchantmentID, self.rspdata.retAmount, info.strengthenLv, true)
	self.fields.Com_to:initData(info.strengthenLv, toAttr, toVal)
	local itemID = warGemCtrl:getEnchantedItemID(self.idx, self.lv)
	local num = warGemCtrl:getEnchantedItemInBag(itemID) or 0
	self.isEnough = 0 < num
	self.fields.Lab_cost:initData(itemID, num, 1)
end
function WarGemReplacePanel:updateView(target, data)
	self.idx = data.data.idx
	self.lv = data.data.lv
	self.position = data.data.position
	self.rspdata = data.rspdata
	self:initView()
end
function WarGemReplacePanel:onReplaceClick()
	SoraDPlaySound()
	warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.position, gWarGemOptionType.REPLACE)
	self:close()
end
function WarGemReplacePanel:onAgainClick()
	SoraDPlaySound()
	if self.isEnough then
		warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.position, gWarGemOptionType.SHOW, true)
	else
		SoraDShowMsgTip(i18n("gemEnchant_text_17"))
	end
end
return WarGemReplacePanel
