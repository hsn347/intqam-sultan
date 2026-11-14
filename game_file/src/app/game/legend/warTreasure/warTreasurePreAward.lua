local warTreasureRead = include("warTreasureRead")
local warTreasurePreAward = class("warTreasurePreAward", function(target)
	return target or SoraDCreateTouchPanel("warTreasurePreAward")
end)
function warTreasurePreAward:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.nodeLine = SoraDGetChildByName(self, "Node_Line")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
end
function warTreasurePreAward:setAward(parent, reward)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(reward, nil)
	for k, v in ipairs(reward) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:addTo(parent)
		single:setPositionY(0)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(parent, 100, SoraDFIsRA())
end
function warTreasurePreAward:setData(point)
	local award = warTreasureRead.getStageAwardByPoint(point)
	self.textTitle:setString(point)
	self:setAward(self.nodeAward, award)
end
return warTreasurePreAward
