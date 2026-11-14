local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_CampRewardPanel = class("RoaringFlame_CampRewardPanel", baseFguiPanel)
function RoaringFlame_CampRewardPanel:ctor(...)
	RoaringFlame_CampRewardPanel.super.ctor(self, ...)
	print("RoaringFlame_CampRewardPanel:ctor", self.viewName)
end
function RoaringFlame_CampRewardPanel:onInit()
	print("=======RoaringFlame_CampRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text17"))
	self.fields.Text_num:setString(i18n("flames_dunes_text48"))
	self.fields.Text_free:setString(i18n("common_text_049"))
	self.fields.Text_unlock:setString(i18n("flames_dunes_text49"))
	self.fields.Btn_unlock:setString(i18n("flames_dunes_text50"))
	self.fields.Btn_unlock:addClickListener(handler(self, self.btnUnlockClick))
	self.fields.Button_oneKey:setString(i18n("ice_carnival_text05"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.btnOneKeyClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_num:fixPos()
	self.fields.Text_free:fixPos()
	self.fields.Text_unlock:fixPos()
	self.fields.nbg:fix()
	self.fields.Btn_unlock:fixPos()
	self.fields.line2:fixPos()
	self.fields.line3:fixPos()
	self.fields.sheer:fixPos()
end
function RoaringFlame_CampRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgList[index + 1], index + 1)
end
function RoaringFlame_CampRewardPanel:onShow()
	print("=======RoaringFlame_CampRewardPanel:onShow")
	self.cfgList = roaringFlameWarRead.getPassNumConfig()
	self:initData()
end
function RoaringFlame_CampRewardPanel:initData()
	SoraDCloseLoading(self)
	self.userNum = roaringFlameWarCtrl:getDecreeGiftUserNum()
	_ENV = nil
	;(nil).num = self.userNum
	self.fields.Text_tip:setString(i18n("flames_dunes_text47", nil))
	self.isSeniorRewardLock = roaringFlameWarCtrl:isSeniorRewardLock()
	self.fields.Btn_unlock:setVisible(not self.isSeniorRewardLock)
	self.fields.sheer:setVisible(not self.isSeniorRewardLock)
	self.isCanClaim = self:isHaveReward()
	local ret = roaringFlameWarCtrl:isHaveDecreeCampReward()
	self.fields.Button_oneKey:setEnabled(self.isCanClaim)
	self.fields.Button_oneKey:setReddot(ret)
	self.fields.List:setNumItems(#self.cfgList)
end
function RoaringFlame_CampRewardPanel:isHaveReward()
	local ret = false
	local giftNormalIdx = roaringFlameWarCtrl:getGiftNormalIdx()
	local giftSeniorIdx = roaringFlameWarCtrl:getGiftSeniorIdx()
	for k, v in ipairs(self.cfgList) do
		if self.userNum >= v.lv then
			if k > giftNormalIdx then
				ret = true
			end
			if self.isSeniorRewardLock and k > giftSeniorIdx then
				ret = true
			end
		end
	end
	return ret
end
function RoaringFlame_CampRewardPanel:btnUnlockClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_DecreeGift")
end
function RoaringFlame_CampRewardPanel:btnOneKeyClick()
	SoraDPlaySound()
	roaringFlameWarCtrl:reqDecreeGift()
	SoraDShowLoading(self)
end
return RoaringFlame_CampRewardPanel
