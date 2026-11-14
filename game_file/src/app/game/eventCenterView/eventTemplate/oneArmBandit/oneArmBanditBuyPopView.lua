local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local oneArmBanditBuyPopView = class("oneArmBanditBuyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("oneArmBanditBuyPopView")
	end
	return target
end)
function oneArmBanditBuyPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
end
function oneArmBanditBuyPopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_btn_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_buy")
	_UPVALUE1_ = "CCS_commonGoldNormalBtn_buy"
	;("CCS_commonGoldNormalBtn_buy")[1] = "Image_frame_bg"
	self.Image_frame_bg = SoraDGetChildByFullPath(self.Center_Node, "CCS_commonGoldNormalBtn_buy")
	self.Image_frame_bg:setTouchEnabled(true)
	self.Image_frame_bg:setSwallowTouches(true)
	_UPVALUE1_ = true
	;(true)[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Center_Node, true)
	_UPVALUE2_ = true
	;(true)[1] = "Node_info"
	;(true)[2] = "Text_count_1"
	self.Text_count_1 = SoraDGetChildByFullPath(self.Center_Node, true)
	_UPVALUE2_ = true
	;(true)[1] = "Node_info"
	;(true)[2] = "Text_count_2"
	self.Text_count_2 = SoraDGetChildByFullPath(self.Center_Node, true)
	_UPVALUE2_ = true
	;(true)[1] = "Node_info"
	;(true)[2] = "Text_count_3"
	self.Text_count_3 = SoraDGetChildByFullPath(self.Center_Node, true)
end
function oneArmBanditBuyPopView:initData(data)
	local slotType = data.slotType
	local selfCoin = backpackCtrl:getItemCount(ONEARMBANDIT_COIN_ITEMID)
	local needCoin = 0
	if slotType == 1 then
		needCoin = ONEARMBANDIT_COIN_NEED_1
	else
		needCoin = ONEARMBANDIT_COIN_NEED_5
	end
	if selfCoin >= needCoin then
		return
	end
	self.Text_count_1:setString(selfCoin)
	backpackCtrl = nil
	;(nil).member = ""
	;(nil).total = needCoin
	self.Text_count_2:setString(i18n("common_text_155", nil))
	backpackCtrl = i18n("common_text_155", nil)
	i18n("common_text_155", nil).member = needCoin
	i18n("common_text_155", nil).total = needCoin
	self.Text_count_3:setString(i18n("common_text_155", i18n("common_text_155", nil)))
	local needGold = (needCoin - selfCoin) * 100
	backpackCtrl = i18n("common_text_155", i18n("common_text_155", nil))
	i18n("common_text_155", i18n("common_text_155", nil)).num = needGold
	self.Text_des:setString(i18n("slot_machine_text_04", i18n("common_text_155", i18n("common_text_155", nil))))
	backpackCtrl = i18n("slot_machine_text_04", i18n("common_text_155", i18n("common_text_155", nil)))
	i18n("slot_machine_text_04", i18n("common_text_155", i18n("common_text_155", nil))).gold = needGold
	self.ccs_btn_buy:initData(i18n("slot_machine_text_04", i18n("common_text_155", i18n("common_text_155", nil))))
	self.ccs_btn_buy:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if not SoraDEnoughGold(needGold) then
				self:removeFromParent()
				return
			end
			if data.handle then
				data.handle(slotType, true)
			end
			self:removeFromParent()
		end
	end)
end
return oneArmBanditBuyPopView
