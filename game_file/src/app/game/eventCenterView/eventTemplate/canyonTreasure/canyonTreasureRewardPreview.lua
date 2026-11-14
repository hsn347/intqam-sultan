local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local canyonTreasureCtrl = SoraDGetCtrl("canyonTreasureCtrl")
local canyonTreasureRewardPreview = class("canyonTreasureRewardPreview", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("canyonTreasureRewardPreview")
	end
	return target
end)
function canyonTreasureRewardPreview:ctor()
	self:initWidget()
end
function canyonTreasureRewardPreview:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Canyon_Treasur_text_06"))
	self.Text_name1:setString(i18n("Canyon_Treasur_text_07"))
	self.Text_tips1:setString(i18n("Canyon_Treasur_text_08"))
	self.Text_tips1:setVisible(false)
	self.Text_name2:setString(i18n("Canyon_Treasur_text_09"))
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.btnOkCallback))
	SoraDAutoSizeButtonTextByContent(self.Button_ok)
end
function canyonTreasureRewardPreview:initData(data)
	local optinalRewards = canyonTreasureCtrl:getOptinalRewardsByType(data.type)
	for i, v in ipairs(optinalRewards) do
		local config = canyonTreasureHuntRead.getCtrConfigByID(v)
		local item = self:createItemAward()
		item:addTo(self.Node_rewards1)
		item:initData(config.item, config.num)
	end
	SoraDToCenter(self.Node_rewards1, 141, SoraDFIsRA())
	if not optinalRewards or not next(optinalRewards) then
		self.Text_tips1:setVisible(true)
	end
	local rewards = canyonTreasureHuntRead.getTreasureOptionalReward(data.type, gcanyonTreasureRewardType.FIXED)
	for i, v in ipairs(rewards) do
		local item = self:createItemAward()
		item:addTo(self.Node_rewards2)
		item:initData(v.id, v.count)
	end
	SoraDToCenter(self.Node_rewards2, 101, SoraDFIsRA())
end
function canyonTreasureRewardPreview:createItemAward()
	local item = SoraDCreatePanel("commonItemAward")
	item:setPosition(cc.p(0, 0))
	item:setOwnView(self)
	item:setScale(0.88)
	return item
end
function canyonTreasureRewardPreview:btnOkCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return canyonTreasureRewardPreview
