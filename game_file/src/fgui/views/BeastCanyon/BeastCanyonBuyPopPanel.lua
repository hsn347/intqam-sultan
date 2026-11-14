local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local beastCanyonRead = include("beastCanyonRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonBuyPopPanel = class("BeastCanyonBuyPopPanel", baseFguiPanel)
function BeastCanyonBuyPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonBuyPopPanel:ctor", self.viewName)
end
function BeastCanyonBuyPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeastCanyonBuyPopPanel:onInit()
	print("=======BeastCanyonBuyPopPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	self.curValue = 1
	self.fields.Panel_bg:setString(i18n("petra_btn_02"))
	self.fields.Text_Tips:setString(i18n("Divinebeastcanyon_text_7"))
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		self.buyMax = include("constantRead").getConstValue("ELITEBEASTCANYON_BASE_BUYNUM", 5)
	else
		self.buyMax = include("constantRead").getConstValue("DIVINEBEASTCANYON_BASE_BUYNUM", 5)
	end
	self.buyNum = beastCanyonCtrl:getBuyTimes(self.activityID)
	_ENV = i18n("Divinebeastcanyon_text_7")
	i18n("Divinebeastcanyon_text_7").num = self.buyNum
	i18n("Divinebeastcanyon_text_7").max = self.buyMax
	self.fields.Text_LeftTime:setString(i18n("Divinebeastcanyon_text_8", i18n("Divinebeastcanyon_text_7")))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.onSliderBack))
	self.fields.Button_Cost:setString(i18n("common_text_282"))
	self.fields.Button_Cost:addClickListener(handler(self, self.onClickCost))
end
function BeastCanyonBuyPopPanel:onShow()
	print("=======BeastCanyonBuyPopPanel:onShow")
	_ENV = nil
	;(nil).maxValue = self.buyMax - self.buyNum
	;(nil).minValue = 1
	;(nil).curValue = self.curValue
	self.fields.Com_slider:initData(nil)
end
function BeastCanyonBuyPopPanel:onSliderBack(num)
	self.curValue = num
	local costNum = 0
	self.itemID, costNum = beastCanyonRead.getCostNumAndItemID(self.activityID, self.buyNum + 1, self.curValue)
	self.fields.Button_Cost:setCost(self.itemID, costNum)
end
function BeastCanyonBuyPopPanel:onClickCost()
	SoraDPlaySound()
	if self.buyNum >= self.buyMax then
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_6"))
		return
	elseif self.fields.Button_Cost:getController("Ctrl_status"):getSelectedIndex() == 1 then
		_ENV = i18n("Divinebeastcanyon_text_6")
		_ENV = i18n("Divinebeastcanyon_text_6")
		i18n("Divinebeastcanyon_text_6").item = include("publicRead").getName(self.itemID)
		i18n("Divinebeastcanyon_text_6").content = i18n("Divinebeastcanyon_text_10", i18n("Divinebeastcanyon_text_6"))
		i18n("Divinebeastcanyon_text_6").confirmFunc = function()
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		end
		uiManager:show("MessageBox", i18n("Divinebeastcanyon_text_6"))
	else
		SoraDShowLoading()
		beastCanyonCtrl:reqDivineBeastCanyonBuyTimes(self.activityID, self.curValue)
		self:close()
	end
end
return BeastCanyonBuyPopPanel
