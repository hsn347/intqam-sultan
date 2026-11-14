local goldSoukCtrl = SoraDGetCtrl("goldSoukCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rewardPopPanel = class("rewardPopPanel", baseFguiPanel)
function rewardPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rewardPopPanel:ctor", self.viewName)
end
function rewardPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rewardPopPanel:onInit()
	print("=======rewardPopPanel:onInit")
	self.cfg = self.param.cfg
	self.status = self.param.status
	self.fields.bg:setTitle(i18n("GoldSouk_text_04"))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.onClick))
end
function rewardPopPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function rewardPopPanel:onShow()
	print("=======rewardPopPanel:onShow")
	_ENV = nil
	;(nil).num = self.cfg.integral
	self.fields.Text_des:setString(i18n("GoldSouk_text_05", nil))
	_UPVALUE2_ = i18n("GoldSouk_text_05", nil)
	i18n("GoldSouk_text_05", nil)[1] = "id"
	i18n("GoldSouk_text_05", nil)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(self.cfg.reward, i18n("GoldSouk_text_05", nil))
	self.fields.List_award:setNumItems(#self.itemList)
	if self.status == gBtnTargetStatusDef.GET then
		self.fields.Btn_reward:setTitleText(i18n("common_text_854"))
		self.fields.Btn_reward:setEnabled(true)
	elseif self.status == gBtnTargetStatusDef.GOT then
		self.fields.Btn_reward:setTitleText(i18n("common_text_1892"))
		self.fields.Btn_reward:setEnabled(false)
	else
		self.fields.Btn_reward:setTitleText(i18n("friend_back_text18"))
		self.fields.Btn_reward:setEnabled(false)
	end
end
function rewardPopPanel:onHide()
	print("=======rewardPopPanel:onHide")
end
function rewardPopPanel:onDispose()
	print("=======rewardPopPanel:onDispose")
end
function rewardPopPanel:onClick()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		goldSoukCtrl:sendClaim(self.cfg.Id)
		self:close()
	end
end
return rewardPopPanel
