local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local itemID = 203601
local equipStrengthStoneGetWayView = class("equipStrengthStoneGetWayView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("equipStrengthStoneGetWayView")
	end
	return target
end)
function equipStrengthStoneGetWayView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("equip_text_50"))
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Text_msg:setString(i18n("equip_text_51"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("equipStrengthStoneGetWaySingle")
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("common_text_4619"))
	self:initData()
end
function equipStrengthStoneGetWayView:initData()
	local data = itemDesRead.getOutput(itemID)
	local itemDesRead, infoData = itemID, itemID
	for i, v in ipairs(data) do
		table.insert(infoData, jumpDesRead.getCfg(v))
	end
	self.Text_none:setVisible(#infoData == 0)
	itemDesRead = table.insert
	table.insert.parent = self
	self.scroll:updateScrollView(cc.size(516, 100), infoData, 1, table.insert)
end
return equipStrengthStoneGetWayView
