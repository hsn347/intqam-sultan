local petExchangeCtrl = SoraDGetCtrl("petExchangeCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetOneKeyViewPanel = class("PetOneKeyViewPanel", baseFguiPanel)
local targetPetId = 1253
local targetPetShardId = 804501
function PetOneKeyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetOneKeyViewPanel:ctor", self.viewName)
end
function PetOneKeyViewPanel:onInit()
	print("=======PetOneKeyViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_3804"))
	_ENV = i18n("common_text_3804")
	i18n("common_text_3804").pid = targetPetId
	i18n("common_text_3804").rank = 1
	self.fields.pet_model:initData(i18n("common_text_3804"))
	local totalGold, discountGold = petExchangeCtrl:getQuickExchangeCost()
	local count = petExchangeCtrl:getEagleMaxExchangeNum(gPetExchangeEagleType.GOLD)
	local deltaGold = totalGold - discountGold
	self.fields.Text_price:setString(string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10))
	local name = publicRead.getName(targetPetShardId)
	_ENV = string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10)
	string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10).count = count
	string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10).petPiece = name
	string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10).gold = string.formatnumberthousands(deltaGold)
	self.fields.Text_content:setString(i18n("common_text_3805", string.format("%d%% OFF", (1000 - PET_EXCHANGE_DISCOUNT) / 10)))
	self.fields.btn_continue:initData(gIDDef.GOLD, discountGold, totalGold)
	self.fields.btn_continue:setTitleTextColor(cc.c3b(255, 255, 0), cc.c3b(255, 200, 0))
	self.fields.btn_continue:addClickListener(handler(self, self.onClick_btn_continue))
end
function PetOneKeyViewPanel:onShow()
	print("=======PetOneKeyViewPanel:onShow")
end
function PetOneKeyViewPanel:onClick_btn_continue(sender, event)
	SoraDPlaySound()
	local totalGold, discountGold = petExchangeCtrl:getQuickExchangeCost()
	if not SoraDEnoughGold(discountGold) then
		return
	end
	SoraDShowLoading(self:displayObject())
	petExchangeCtrl:reqQuickExchangeEagle()
end
function PetOneKeyViewPanel:sMsgOnKeyBack(target, data)
	SoraDCloseLoading(self:displayObject())
	if data.err == gErrDef.Err_None then
		self:closePanel()
	else
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_PET_EXCHANGE_EAGLE_BACK"
	self.err = data.err
	SoraDSendMessage(self)
end
return PetOneKeyViewPanel
