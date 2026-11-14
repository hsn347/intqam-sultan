local CommonScrollIndicatorNumber = class("commonScrollIndicatorNumber", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonScrollIndicatorNumber")
	end
	return target
end)
function CommonScrollIndicatorNumber:ctor()
	self.imgLight = SoraDGetChildByName(self, "Image_light")
	self.imgLight:setLocalZOrder(1)
	_ENV, self.tableBgSingle, _ENV, self.imgBaseBg = SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg")
	self.tableIndicatorNumberData, SoraDGetChildByName(self, "Image_bg").count = SoraDGetChildByName(self, "Image_bg"), 0
	self.curIndex = 1
end
function CommonScrollIndicatorNumber:initData(indicatorNumberData)
	self.tableIndicatorNumberData = indicatorNumberData
	for i, v in ipairs(self.tableBgSingle) do
		if 1 < i then
			v:removeFromParent()
		end
	end
	self.tableBgSingle, _ENV = ipairs(self.tableBgSingle)
	self:updateView()
end
function CommonScrollIndicatorNumber:updateView()
	table.insert(self.tableBgSingle, self.imgBaseBg)
	for i = 1, self.tableIndicatorNumberData.count - 1 do
		local singleBg = self.imgBaseBg:clone()
		singleBg:addTo(self)
		table.insert(self.tableBgSingle, singleBg)
	end
	local rowCountMax = self.tableIndicatorNumberData.rowCountMax
	if rowCountMax then
		local intervalW = self.tableIndicatorNumberData.intervalWidth or self.imgBaseBg:getContentSize().width
		local intervalH = self.tableIndicatorNumberData.intervalH or intervalW
		local count = self.tableIndicatorNumberData.count
		local biginX = (math.min(rowCountMax, count) - 1) * intervalW * -0.5
		local rowMax = math.ceil(count / rowCountMax)
		for i, v in ipairs(self.tableBgSingle) do
			local col = (i - 1) % rowCountMax + 1
			local row = math.ceil(i / rowCountMax)
			if rowMax == row then
				biginX = (count - (row - 1) * rowCountMax - 1) * intervalW * -0.5
			end
			v:setPositionX(biginX + intervalW * (col - 1))
			v:setPositionY((rowMax - row) * intervalH)
		end
	else
		local biginX = -0.5 * (self.tableIndicatorNumberData.count - 1) * self.tableIndicatorNumberData.intervalWidth
		for i, v in ipairs(self.tableBgSingle) do
			v:setPositionX(biginX + self.tableIndicatorNumberData.intervalWidth * (i - 1))
		end
	end
	self:setCurLight(self.tableIndicatorNumberData.begin)
end
function CommonScrollIndicatorNumber:scrollOnePage(isToLeft)
	if isToLeft then
		self:setCurLight(self.curIndex + 1)
	else
		self:setCurLight(self.curIndex - 1)
	end
end
function CommonScrollIndicatorNumber:setCurLight(index)
	if index <= 0 then
		index = 1
	elseif index > self.tableIndicatorNumberData.count then
		index = self.tableIndicatorNumberData.count
	end
	self.curIndex = index
	local posx, posy = self.tableBgSingle[self.curIndex]:getPosition()
	self.imgLight:setPosition(posx, posy)
	self.imgLight:setScale(self.tableBgSingle[self.curIndex]:getScale())
end
function CommonScrollIndicatorNumber:setImage(bgImg, lightImg)
	if bgImg then
		self.imgBaseBg:loadTexture(bgImg, ccui.TextureResType.plistType)
		self.imgBaseBg:ignoreContentAdaptWithSize(true)
	end
	if lightImg then
		self.imgLight:loadTexture(lightImg, ccui.TextureResType.plistType)
		self.imgLight:ignoreContentAdaptWithSize(true)
	end
end
return CommonScrollIndicatorNumber
