local pyramidTreasureRewardSingle = class("pyramidTreasureRewardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidTreasureRewardSingle")
	end
	return target
end)
function pyramidTreasureRewardSingle:ctor()
	self.Text_day = SoraDGetChildByName(self, "Text_day")
	self.ccs_item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
end
function pyramidTreasureRewardSingle:initData(index, data, view)
	_ENV = nil
	;(nil).num = index
	self.Text_day:setString(i18n("petra_text_07", nil))
	self.ccs_item:setOwnView(view)
	self.ccs_item:initData(data.id, data.count)
end
return pyramidTreasureRewardSingle
