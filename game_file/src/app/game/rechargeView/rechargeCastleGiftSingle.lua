local publicRead = include("publicRead")
local rechargeCastleGiftSingle = class("rechargeCastleGiftSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeCastleGiftSingle")
	end
	return target
end)
function rechargeCastleGiftSingle:ctor()
	self.Image_itemSheer = SoraDGetChildByName(self, "Image_itemSheer")
	self.Image_itemBuff = SoraDGetChildByName(self, "Image_itemBuff")
	self.Image_itemIcon = SoraDGetChildByName(self, "Image_itemIcon")
	self.Text_itemName = SoraDGetChildByName(self, "Text_itemName")
	self.Text_itemCount = SoraDGetChildByName(self, "Text_itemCount")
	self.Image_item = SoraDGetChildByName(self, "Image_item")
	self.Image_item = include("commonBtnInstance").new(self.Image_item)
end
function rechargeCastleGiftSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.Image_itemSheer:setVisible(self.data.index % 2 == 1)
	self.Image_itemBuff:loadTexture(publicRead.getBg(self.data.id), ccui.TextureResType.plistType)
	self.Image_itemIcon:loadTexture(publicRead.getIcon(self.data.id), ccui.TextureResType.plistType)
	self.Image_itemIcon:ignoreContentAdaptWithSize(true)
	self.Image_itemIcon:setScale(55 / self.Image_itemIcon:getContentSize().width)
	self.Text_itemName:setString(publicRead.getName(self.data.id))
	self.Text_itemCount:setString("x" .. string.formatnumberthousands(tonumber(self.data.count)))
	self.Image_item:setItemInfo(self.view, self.data.id, self.data.count)
	self.Image_item:setSwallowTouches(false)
end
return rechargeCastleGiftSingle
