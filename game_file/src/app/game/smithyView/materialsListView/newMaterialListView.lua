local newMaterialListView = class("newMaterialListView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newMaterialListView")
	end
	return target
end)
function newMaterialListView:ctor()
	self:setBackGround(0)
	self.Text_help = SoraDGetChildByName(self, "Text_help")
	self.Image_79 = SoraDGetChildByName(self, "Image_79")
	self.ScrollView_items = SoraDGetChildByName(self, "ScrollView_items")
end
function newMaterialListView:setTipText(str, isOrange)
	self.Text_help:setString(str)
	if isOrange then
		self.Text_help:setColor(cc.c3b(238, 0, 0))
	end
end
function newMaterialListView:initScroll(items, equip)
	self.ScrollView_items:removeAllChildren()
	if equip then
		self.ScrollView_items:setAnchorPoint(0.5, 0.5)
		self.ScrollView_items:setBounceEnabled(true)
		self.ScrollView_items:setDirection(1)
		self.ScrollView_items:setContentSize(cc.size(640, 490))
		self.Image_79:setContentSize(cc.size(600, 560))
		self.ScrollView_items:setPositionY(self.Image_79:getPositionY() - 15)
		self.ScrollView_items:setPositionX(self.Image_79:getPositionX() + 10)
		self.Text_help:setPositionY(self.Image_79:getPositionY() + 255)
		local totalW = self.ScrollView_items:getContentSize().width
		local totalR = #items / 5 + 1
		local totalH = math.max(self.ScrollView_items:getContentSize().height, 110 * totalR)
		self.ScrollView_items:setInnerContainerSize(cc.size(totalW, totalH))
		local col = 1
		local row = 1
		for k, v in ipairs(items) do
			v:setScroll(self.ScrollView_items)
			v:setPosition(640 - 110 * col, totalH - row * 110 + 60)
			v:addTo(self.ScrollView_items)
			col = col + 1
			if 5 < col then
				col = 1
				row = row + 1
			end
		end
		return
	end
	local totalW = math.max(self.ScrollView_items:getContentSize().width, 110 * #items)
	self.ScrollView_items:setInnerContainerSize(cc.size(totalW, self.ScrollView_items:getContentSize().height))
	for k, v in ipairs(items) do
		v:setScroll(self.ScrollView_items)
		v:setPosition(110 * k - 50, self.ScrollView_items:getContentSize().height / 2)
		v:addTo(self.ScrollView_items)
	end
end
function newMaterialListView:setFontSize(size)
	self.Text_help:setFontSize(size)
end
return newMaterialListView
