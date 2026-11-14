local worldStrongPointFirstAwardView = class("worldStrongPointFirstAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointFirstAwardView")
	end
	return target
end)
function worldStrongPointFirstAwardView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_stronghold_text_046"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("common_text_2211"))
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
end
function worldStrongPointFirstAwardView:initData(reward)
	for k, v in ipairs(reward) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.Node_reward)
		single:setOwnView(self)
		single:initData(v.id, v.count)
		single:setScale(0.88)
		single:setPosition(0, 0)
	end
	SoraDToCenter(self.Node_reward, 100)
end
return worldStrongPointFirstAwardView
