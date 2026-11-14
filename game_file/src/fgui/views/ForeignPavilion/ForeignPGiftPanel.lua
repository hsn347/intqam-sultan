local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPGiftPanel = class("ForeignPGiftPanel", baseFguiPanel)
local foreignPavilionRead = include("foreignPavilionRead")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function ForeignPGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("ForeignPGiftPanel:ctor", self.viewName)
end
function ForeignPGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function ForeignPGiftPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.fields.com_title:initData(i18n("exitic_pavillion_text_0065"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.text_npc_name:setString(i18n("exitic_pavillion_text_0046"))
	print("=======ForeignPGiftPanel:onInit")
	self.giftCfgs = foreignPavilionRead:getGiftCfgs()
	table.sort(self.giftCfgs, function(l, r)
		return l.index < r.index
	end)
end
function ForeignPGiftPanel:onShow()
	self.fisrtIn = true
	print("=======ForeignPGiftPanel:onShow")
	self:updateView()
	self.fields.titlebg:setAllFrameName("G_ygg_daji2_%02d.png", 1)
	self.fields.titlebg:setPlaySettings(0, -1, -1)
	self.fields.n73:setVisible(false)
	self.fields.txt_time:setVisible(false)
end
function ForeignPGiftPanel:updateView()
	self.fields.intimacy:initData()
	for index = 1, 3 do
		local cfg = self.giftCfgs[index]
		self.fields["gift" .. index]:initData(cfg, index)
	end
	self.fields.role:updateRole(exoticPavilionCtrl:getCurDressLv(), self.fisrtIn)
	self.fisrtIn = false
end
function ForeignPGiftPanel:onHide()
	print("=======ForeignPGiftPanel:onHide")
end
function ForeignPGiftPanel:onDispose()
	print("=======ForeignPGiftPanel:onDispose")
end
function ForeignPGiftPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("exitic_pavillion_text_0038")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ForeignPGiftPanel:onGetGift()
	local lastGiftIdx = exoticPavilionCtrl:getLastGiftIdx() or 1
	self.fields.role:setChat(2, 1)
	self.fields.intimacy:addHeartShow(function()
		self:updateView()
	end, self.fields["gift" .. lastGiftIdx].fields.button_gift)
end
return ForeignPGiftPanel
