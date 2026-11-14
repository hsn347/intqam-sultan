local publicRead = include("publicRead")
local allianceActiveGiftSingle = class("allianceActiveGiftSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveGiftSingle")
	end
	return target
end)
function allianceActiveGiftSingle:ctor()
	self.Image_sheer = SoraDGetChildByName(self, "Image_sheer")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.ccs_item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
end
function allianceActiveGiftSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	self.Image_sheer:setVisible(self.data.index % 2 == 0)
	self.Text_name:setString(publicRead.getName(self.data.id))
	self.Text_num:setString("x" .. string.formatnumberthousands(self.data.count))
	self.ccs_item:setBaseScale(1.0)
	self.ccs_item:setOwnView(self.view)
	self.ccs_item:setScroll(self.ownScroll)
	self.ccs_item:initData(self.data.id, self.data.count)
	self.ccs_item:hideNum()
end
return allianceActiveGiftSingle
