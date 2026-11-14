local weaponSprctrumCtrl = SoraDGetCtrl("weaponSprctrumCtrl")
local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityFinalView = class("equipActivityFinalView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("equipActivityFinalView")
	end
	return target
end)
function equipActivityFinalView:ctor()
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("spectrum_text_05"))
	self.Text_point = SoraDGetChildByName(self, "Text_point")
	self.Sprite_point = SoraDGetChildByName(self, "Sprite_point")
	self.icon_g = SoraDGetChildByName(self, "icon_g")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self:initData()
end
function equipActivityFinalView:initData()
	_ENV = nil
	;(nil).num = weaponSprctrumCtrl:getWeaponPoint()
	;(nil).limit = weaponSprctrumRead.getFinalRewardNum()
	self.Text_point:setString(i18n("spectrum_text_06", nil))
	if SoraDFIsRA() then
		self.Sprite_point:setPositionX(self.Text_point:getPositionX() - self.Text_point:getContentSize().width - 20)
	else
		self.Sprite_point:setPositionX(self.Text_point:getPositionX() + self.Text_point:getContentSize().width + 20)
	end
	self.icon_g:setVisible(weaponSprctrumCtrl:isFinalRewardReceived() or false)
	local reward = weaponSprctrumRead.getFinalReward()
	weaponSprctrumRead = weaponSprctrumCtrl
	weaponSprctrumCtrl[1] = "id"
	weaponSprctrumCtrl[2] = "count"
	local rewardList = serviceFunctions.tableFormat(reward, weaponSprctrumCtrl)
	for k, v in ipairs(rewardList) do
		local item = include("commonItemAward").new()
		item:setOwnView(self)
		item:initData(v.id, v.count)
		item:setBaseScale(1.0)
		item:setPosition(0, 0)
		item:addTo(self.Node_items)
	end
	SoraDToCenter(self.Node_items, 120)
end
return equipActivityFinalView
