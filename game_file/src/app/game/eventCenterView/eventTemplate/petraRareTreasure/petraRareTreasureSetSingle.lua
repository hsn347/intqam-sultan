local commonItemAward = include("commonItemAward")
local petraRareTreasureSetSingle = class("petraRareTreasureSetSingle", function(target)
	target = commonItemAward.new(target)
	return target
end)
function petraRareTreasureSetSingle:ctor()
	self.imgLight = SoraDGetChildByName(self, "Image_light")
	self.imgLight:setVisible(false)
end
function petraRareTreasureSetSingle:initData(data, otherData)
	dump(data, "data", 10)
	self.itemData = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.view
		self.scroll = otherData.scroll
	end
	self:setOwnView(self.view)
	self:setOwnScroll(self.ownScroll)
	commonItemAward.initData(self, data.id, data.count)
end
function petraRareTreasureSetSingle:setLight(show)
	self.imgLight:setVisible(show)
end
function petraRareTreasureSetSingle:setHandle(handle)
	self.opClickCallBack = handle
	commonItemAward.setHandle(self, function()
		if self.opClickCallBack then
			self.opClickCallBack(self, self.itemData)
		end
	end)
end
return petraRareTreasureSetSingle
