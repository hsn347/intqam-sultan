local scrollNode = include("scrollNode")
local rechargeRead = include("rechargeRead")
local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRebateUtil = include("sultansBackRebateUtil")
local RECHARGE_GIFT_STATUES = sultansBackRebateUtil.RECHARGE_GIFT_STATUES
local sultansBackRebateGiftSingle = class("sultansBackRebateGiftSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sultansBackRebateGiftSingle")
	end
	return target
end)
function sultansBackRebateGiftSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_alter = SoraDGetChildByName(self, "text_alter")
	SoraDChangeTextToHtml(self.text_alter)
	self.txtDiscount = SoraDGetChildByName(self, "Text_discount")
	self.ScrollView_item = SoraDGetChildByName(self, "ScrollView_item")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.text_buy = SoraDGetChildByName(self, "text_buy")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.btn_operate = include("commonBtnInstance").new(self.btn_operate)
	self.btn_operate:setHandle(handler(self, self.onClick_btn_operate))
	self.btn_operate:setSwallowTouches(false)
	self.OAPButton = SoraDGetExtendChildFromCCSByName(self, "CCS_OAPButton")
	self.OAPButton:setHandle(handler(self, self.onClick_btn_operate))
end
function sultansBackRebateGiftSingle:initData(data, otherData)
