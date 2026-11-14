local epicBattleDef = include("epicBattleDef")
local publicRead = include("publicRead")
local epicBattleAwardDetailSingle = class("epicBattleAwardDetailSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleAwardDetailSingle")
	end
	return target
end)
function epicBattleAwardDetailSingle:ctor()
	self.ccs_item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
end
function epicBattleAwardDetailSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	self.ccs_item:setScale(0.8)
	self.ccs_item:setBaseScale(1.0)
	self.ccs_item:setOwnScroll(self.scroll)
	self.ccs_item:setOwnView(self.view)
	self.ccs_item:initData(self.data.id, self.data.count)
	self.ccs_item:hideNum()
	self.Text_name:setString(publicRead.getName(self.data.id))
	self.Text_num:setString("x" .. self.data.count)
end
return epicBattleAwardDetailSingle
