local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local publicRead = include("publicRead")
local vipDailyGiftltCtrl = include("vipDailyGiftltCtrl")
_ENV = "vipDailyGiftltCtrl"
;("vipDailyGiftltCtrl").un_active = 1
;("vipDailyGiftltCtrl").active_but_level_not_reach = 2
;("vipDailyGiftltCtrl").level_reach_but_not_active = 3
;("vipDailyGiftltCtrl").not_active_and_not_get_reward = 4
;("vipDailyGiftltCtrl").not_active_and_got_reward = 5
;("vipDailyGiftltCtrl").both_reach_but_not_get_reward = 6
local ("vipDailyGiftltCtrl").both_reach_and_got_reward, vipStatus = 7, "vipDailyGiftltCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local vipCenterRewardViewPanel = class("vipCenterRewardViewPanel", baseFguiPanel)
function vipCenterRewardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("vipCenterRewardViewPanel:ctor", self.viewName)
end
function vipCenterRewardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function vipCenterRewardViewPanel:onInit()
	print("=======vipCenterRewardViewPanel:onInit")
	self.fields.Text_upgrade:setString(i18n("common_text_4544"))
	self.fields.Button_GetReward:setString(i18n("common_text_854"))
	self.fields.Button_GetReward:addClickListener(handler(self, self.btnClickGetReward))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function vipCenterRewardViewPanel:onShow()
	print("=======vipCenterRewardViewPanel:onShow")
	self.level = self.param.level
	self:initData()
end
function vipCenterRewardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1])
end
function vipCenterRewardViewPanel:initData()
	if not vipDailyGiftltCtrl:getGift(self.level) then
		vipDailyGiftltCtrl = vipDailyGiftltCtrl:getGift(self.level)
	end
	self.reward = vipDailyGiftltCtrl:getGift(self.level)
	self.fields.List:setNumItems(#self.reward)
	vipDailyGiftltCtrl = nil
	;(nil).vip = self.level > VIP_SVIP_LV and "SVIP" or "VIP"
	;(nil).lv = self.level > VIP_SVIP_LV and self.level - VIP_SVIP_LV or self.level
	;(nil).reward = i18n("common_text_2078")
	self.fields.Text_title:setString(i18n("%{vip}%{lv}%{reward}", nil))
	self.fields.Text_title:enableGradient(cc.c3b(254, 253, 242), cc.c3b(247, 210, 63))
	self.fields.Text_title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.playerVipLevel = lordInfoCtrl:getVipDetails().level
	if self.playerVipLevel == self.level then
		local vipInfo = lordInfoCtrl:getVip()
		if not vipInfo or not vipInfo[2] then
			self.status = lordInfoCtrl:vipDailyGiftBeGot() and vipStatus.not_active_and_got_reward or vipStatus.not_active_and_not_get_reward
		else
			self.status = lordInfoCtrl:vipDailyGiftBeGot() and vipStatus.both_reach_and_got_reward or vipStatus.both_reach_but_not_get_reward
		end
	else
		self.status = self.playerVipLevel < VIP_LV5_LIMITED and vipStatus.un_active or vipStatus.active_but_level_not_reach
	end
	self.controllers.c1:setSelectedIndex(1)
	if self.status ~= vipStatus.both_reach_and_got_reward then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Button_GetReward:setString(i18n("vip_text_02"))
		self.fields.Button_GetReward:setEnabled(true)
		if self.status == vipStatus.level_reach_but_not_active or self.status == vipStatus.not_active_and_not_get_reward then
			self.fields.Text_upgrade:setString(i18n("common_text_4545"))
			self.fields.Button_GetReward:setString(i18n("Newbie_task_content_13"))
		elseif self.status == vipStatus.both_reach_but_not_get_reward then
			self.fields.Text_upgrade:setVisible(false)
			self.fields.Button_GetReward:setString(i18n("common_text_854"))
		end
	else
		self.fields.Button_GetReward:setString(i18n("common_text_1892"))
		self.fields.Button_GetReward:setEnabled(false)
	end
	self:updatePageBtns()
end
function vipCenterRewardViewPanel:updatePageBtns()
	self.fields.Button_right:setVisible(true)
	local preLevel = self.level - 1
	if SoraDFIsRA() then
		self.fields.Button_right:setVisible(preLevel >= VIP_LV5_LIMITED)
	else
		self.fields.Button_left:setVisible(preLevel >= VIP_LV5_LIMITED)
	end
	local nextLevel = self.level + 1
	local rewards = vipDailyGiftltCtrl:getGift(nextLevel)
	if SoraDFIsRA() then
		self.fields.Button_left:setVisible(rewards ~= false)
	else
		self.fields.Button_right:setVisible(rewards ~= false)
	end
end
function vipCenterRewardViewPanel:btnClickGetReward()
	SoraDPlaySound()
	if self.status == vipStatus.un_active or self.status == vipStatus.active_but_level_not_reach then
		_ENV = nil
		;(nil).itemType = gItemType.VIP_POINT
		uiManager:show("vipBuyView", nil)
	elseif self.status == vipStatus.level_reach_but_not_active or self.status == vipStatus.not_active_and_not_get_reward then
		_ENV = nil
		;(nil).itemType = gItemType.VIP_TIME
		uiManager:show("vipBuyView", nil)
	else
		lordInfoCtrl:getVipDailyGift()
		self:close()
	end
end
function vipCenterRewardViewPanel:btnLeftClick()
	SoraDPlaySound()
	print("向左")
	self.level = SoraDFIsRA() and self.level + 1 or self.level - 1
	self:initData(self.level)
end
function vipCenterRewardViewPanel:btnRightClick(button, eventType)
	SoraDPlaySound()
	print("向右")
	self.level = SoraDFIsRA() and self.level - 1 or self.level + 1
	self:initData(self.level)
end
return vipCenterRewardViewPanel
