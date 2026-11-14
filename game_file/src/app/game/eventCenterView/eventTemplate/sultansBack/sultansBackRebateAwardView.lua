local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local sultansBackRebateUtil = include("sultansBackRebateUtil")
local AWARD_STATUES = sultansBackRebateUtil.AWARD_STATUES
local sultansBackRebateAwardView = class("sultansBackRebateAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sultansBackRebateAwardView")
	end
	return target
end)
function sultansBackRebateAwardView:ctor()
	self.isAdd = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	SoraDChangeTextToHtml(self.Text_des)
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.btnAward:addTouchEventListener(handler(self, self.onClickGo))
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.textBuffName = SoraDGetChildByName(self, "Text_buff_name")
	self.textBuffValue = SoraDGetChildByName(self, "Text_buff_value")
	self.Image_buff = SoraDGetChildByName(self, "Icon_bg")
end
function sultansBackRebateAwardView:initViewBox(info)
	self.info = info
	_ENV = nil
	_ENV = self.info.score
	self.info.score.color = "#FFFF00"
	;(nil).price = SoraDWrapHtmlTagByStyle(SoraDPreciseDecimal(self.info.score, 1), self.info.score)
	self.Text_des:setString(i18n("recharge_new_user_text02", nil))
	local _ENV, reward = self.Text_des.setString, self.Text_des.setString
	if info.reward and next(info.reward) then
		for k, v in ipairs(info.reward) do
			table.insert(reward, v)
		end
	end
	if info.special and next(info.special) then
		table.insert(reward, info.special)
	end
	self:initAwardNode(reward)
	self:updateBuff()
	self:updateBtnStatues()
end
function sultansBackRebateAwardView:updateBuff()
	self.buff = self.info.buff
	self.buffType = buffltCtrl:getEffectType(self.buff)
	self.buffValue = buffltCtrl:getEffect(self.buff)
	self.textBuffName:setString(buffDesRead.getTitleBase(self.buffType))
	self.textBuffValue:setString(buffDesRead.getTitleValueWithValue(self.buffType, self.buffValue))
	self.Image_buff:setSpriteFrame(sultansBackRebateUtil.getBuffImg(self.buff, true))
end
function sultansBackRebateAwardView:initAwardNode(award)
	for _, v in ipairs(award) do
		local node = include("commonItemAward").new()
		node:setScale(0.8)
		node:setBaseScale(1.0)
		node:setOwnView(self)
		node:initData(v.id, v.count)
		node:setPosition(0, 0)
		node:addTo(self.Node_award)
	end
	SoraDToCenter(self.Node_award, 90)
end
function sultansBackRebateAwardView:updateBtnStatues()
	local statues = sultansBackRebateUtil.getRoundStatues(self.info)
	if statues == AWARD_STATUES.AWARD_STATUES_GET then
		self.Text_status:setVisible(true)
		self.Text_status:setString(i18n("common_text_1892"))
		self.btnAward:setVisible(false)
	elseif statues == AWARD_STATUES.AWARD_STATUES_COMPLETE then
		self.Text_status:setVisible(false)
		self.btnAward:setTitleText(i18n("common_text_1146"))
		self.btnAward:setVisible(true)
	else
		self.Text_status:setVisible(true)
		self.Text_status:setString(i18n("friend_back_text18"))
		self.btnAward:setVisible(false)
	end
end
function sultansBackRebateAwardView:onClickGo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local statues = sultansBackRebateUtil.getRoundStatues(self.info)
		if statues == AWARD_STATUES.AWARD_STATUES_COMPLETE then
			local sultansBackCtrl = _G.SoraDGetCtrl("sultansBackCtrl")
			sultansBackCtrl:reqRebateReceive(self.info.score)
			self:removeFromParent()
		else
			self:removeFromParent()
		end
	end
end
return sultansBackRebateAwardView
