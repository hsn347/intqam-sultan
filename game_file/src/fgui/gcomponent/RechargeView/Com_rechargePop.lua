local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local rechargePresentUtil = include("rechargePresentUtil")
local equipDesRead = include("equipDesRead")
local rechargeRead = include("rechargeRead")
local princeGiftRead = include("princeGiftRead")
local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local ladderGiftCtrl = SoraDGetCtrl("ladderGiftCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local iceBreakCtrl = SoraDGetCtrl("iceBreakCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rechargePop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_rechargePop", Com_rechargePop)
function Com_rechargePop:onInit()
	self.itemList, _ENV = nil, nil
	self.fromCenter = nil
	self.isPageTurn = nil
	self.fields.Text_tip:setString(i18n("common_text_789"))
	self.fields.Com_giftCar:setVisible(false)
	self.fields.Button_rechargeCenter:addClickListener(handler(self, self.btnRechargeCenterClick))
	self.fields.rechargeRedPackageNode:addClickListener(handler(self, self.btnRechargeRedPackageClick))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Tab_price:setVisible(false)
	self.fields.Text_once:setAlign(0)
	self.fields.Text_gold:setAlign(0)
	self.fields.List_items:setVirtual()
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
	self.fields.Node_style:fixPos()
	self.fields.Text_discount:fixPos()
	self.fields.Text_time:fixPos()
	self.fields.Btn_first:fixPos()
	self.fields.rechargeRedPackageNode:fixPos()
	self.fields.Lab_cloth:fixPos()
	self.fields.Lab_cloth:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_rechargePop:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], index + 1)
end
function Com_rechargePop:onShow()
end
function Com_rechargePop:initDataEX(param, parent)
	self.fromCenter = param.fromCenter
	if not param.otherInfo then
		_UPVALUE0_ = param.otherInfo
	end
	self.otherInfo = param.otherInfo
	self.isPageTurn = param.isPageTurn or false
	self.rechargeID = param.id
	self.isLadder = param.isLadder or false
	self.info = param.info
	self.parent = parent
	if self.isLadder then
		self:initLadderGiftData()
	else
		self:initView()
	end
end
function Com_rechargePop:initData(id, fromCenter, isPageTurn, otherInfo)
