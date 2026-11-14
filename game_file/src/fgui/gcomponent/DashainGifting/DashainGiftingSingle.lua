local eidSignCtrl = SoraDGetCtrl("eidSignCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signRewadRead = include("signRewadRead")
local baseComponent = require("fgui.base.baseComponent")
local DashainGiftingSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://DashainGifting/DashainGiftingSingle", DashainGiftingSingle)
function DashainGiftingSingle:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self:addClickListener(handler(self, self.onClickItem))
	self.fields.Text_Got:setString(i18n("common_text_2874"))
	self.fields.Text_Sign:setString(i18n("common_text_2875"))
end
function DashainGiftingSingle:onShow()
end
function DashainGiftingSingle:initData(data)
	self.day = data.day
	self.goldNum = signRewadRead.getEidaladhaPrice(activityShowCtrl:getParamClassType(gActivityTimeActivityID.EID_SIGN_ACTIVITY), self.day)
	self.fields.Tex_Rank:setString(data.day)
	_ENV = data.day
	data.day[1] = "id"
	data.day[2] = "count"
	self.awardConfig = serviceFunctions.tableFormat(data.reward, data.day)
	self.fields.List:setNumItems(#self.awardConfig)
	self.status = eidSignCtrl:getStatusByDay(data.day)
	self.controllers.c1:setSelectedIndex(self.status)
end
function DashainGiftingSingle:onClickItem()
	SoraDPlaySound()
	if self.status == 0 then
		_ENV = nil
		_ENV = nil
		;(nil).num = self.goldNum
		;(nil).content = i18n("eidaladha_sign_text_04", nil)
		;(nil).confirmFunc = function()
			if SoraDEnoughGold(self.goldNum, true) then
				SoraDShowLoading()
				eidSignCtrl:reqEidSignUseGoldSign(self.day)
			else
				SoraDShowMsgTip(i18n("common_text_423"))
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = i18n("common_text_423")
					i18n("common_text_423").toCategory = gRechargeCenterCategory.GOLD
					uiManager:show("rechargeView", i18n("common_text_423"))
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:show()
					panel:expect2SelectTabEx(gRechargeCenterCategory.GOLD)
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end
		uiManager:show("MessageBox", nil)
	elseif self.status == gIceCrazyNightStatus.RECEIVE then
		SoraDShowLoading()
		eidSignCtrl:reqEidSignCommonSign()
	end
end
function DashainGiftingSingle:onItemRederer(index, target)
	target:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
return DashainGiftingSingle
