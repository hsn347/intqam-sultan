local commonItemSingle = class("commonItemSingle", function(target)
	return display.newNode()
end)
function commonItemSingle:ctor()
	self.item = include("commonItemAward").new()
	self.item:addTo(self)
end
function commonItemSingle:initData(data, otherData)
	self.itemID = data.id
	local offset = otherData.offset or cc.p(0, 0)
	self.item:setOwnView(otherData.view)
	self.item:setOwnScroll(otherData.scroll)
	self.item:initData(data.id, data.count)
	self.item:setScale(otherData.scale or 1.0)
	self.item:setPosition(offset.x, offset.y)
	self.item:setBaseScale(1.0)
	if otherData.handle then
		self.item:setHandle(otherData.handle)
	end
	if otherData.imageSelet then
		local Image_select = self.item:getImageSelect()
		if Image_select then
			SoraChangeSpriteImage(Image_select, otherData.imageSelet)
		end
	end
end
function commonItemSingle:getItemID()
	return self.itemID
end
function commonItemSingle:isShowSelect(ret)
	self.item:setSelect(ret)
end
return commonItemSingle
