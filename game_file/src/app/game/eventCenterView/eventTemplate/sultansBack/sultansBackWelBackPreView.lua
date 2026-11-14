local sultansBackRead = include("sultansBackRead")
local sultansBackWelBackPreView = class("sultansBackWelBackPreView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sultansBackWelBackPreView")
	end
	return target
end)
function sultansBackWelBackPreView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("welcome_back_text04"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self:initData()
end
function sultansBackWelBackPreView:initData()
	local reward = sultansBackRead.getWelBackReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(reward, nil)
	for k, v in ipairs(rewardList) do
		local item = include("commonItemAward").new()
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setPosition(0, 0)
		item:addTo(self.Node_item)
		item:setOwnView(self)
		item:initData(v.id, v.count)
	end
	SoraDautoSortPos(self.Node_item, 5, SoraDFIsRA() and 0 or 2, cc.size(100, 100))
end
return sultansBackWelBackPreView
