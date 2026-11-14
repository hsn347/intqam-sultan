local commonIndexNumber = class("commonIndexNumber", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonIndexNumber")
	end
	return target
end)
function commonIndexNumber:ctor()
	self.imgLight = SoraDGetChildByName(self, "Image_light")
	self.Node_bg = SoraDGetChildByName(self, "Node_bg")
	self.param, _ENV, self.tableBgSingle, _ENV, self.imgBaseBg = SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg")
	self.curIndex = 1
	self.showCount = 1
	self.pointIndex = 1
	self.tableBgSingle[1] = self.imgBaseBg
	for i = 1, 13 do
		if not self.tableBgSingle[i] then
			self.tableBgSingle[i] = self.imgBaseBg:clone()
			self.tableBgSingle[i]:addTo(self.Node_bg)
		end
		self.tableBgSingle[i]:setPosition(0, 0)
	end
	SoraDToCenter(self.Node_bg)
	self:setLightPoint()
end
function commonIndexNumber:initData(param)
	self.param = param
	self:updateView()
end
function commonIndexNumber:updateView()
	for i, v in ipairs(self.tableBgSingle) do
		v:setVisible(false)
	end
	if self.param.count < 13 then
		self.showCount = self.param.count
	else
		self.showCount = math.min(self.param.count, 13)
	end
	if 13 > self.showCount then
		for i = 1, self.showCount do
			self.tableBgSingle[i]:setVisible(true)
			self.tableBgSingle[i]:setScale(1.0)
		end
		SoraDToCenter(self.Node_bg, self.param.intervalWidth or 10)
	else
		for i = 1, self.showCount do
			self.tableBgSingle[i]:setVisible(true)
			if i <= 3 then
				self.tableBgSingle[i]:setScale(i / 4)
			elseif i >= self.showCount - 2 then
				self.tableBgSingle[i]:setScale((self.showCount - i + 1) / 4)
			else
				self.tableBgSingle[i]:setScale(1.0)
			end
		end
		SoraDToCenter(self.Node_bg, self.param.intervalWidth or 10)
	end
	self.curIndex = self.param.begin or 1
	self:setCurLight(self.curIndex)
end
function commonIndexNumber:setLightPoint()
	self.pointIndex = math.max(1, math.min(self.pointIndex, 13))
	self.imgLight:setPositionX(self.tableBgSingle[self.pointIndex]:getPositionX())
	self.imgLight:setScale(self.tableBgSingle[self.pointIndex]:getScaleX())
end
function commonIndexNumber:setCurLight(index)
	if index == 1 or index == self.param.count then
		self.pointIndex = index
		self.curIndex = index
		self:setLightPoint()
		return
	end
	local dir = index - self.curIndex
	if self.param.count >= 13 then
		if 0 < dir then
			if self.curIndex >= 10 and self.curIndex < self.param.count - 3 then
				self.pointIndex = math.min(self.pointIndex + 1, 10)
			else
				self.pointIndex = self.pointIndex + 1
			end
		elseif dir < 0 then
			if self.curIndex > 4 and self.curIndex < self.param.count - 8 then
				self.pointIndex = math.max(4, self.pointIndex - 1)
			else
				self.pointIndex = self.pointIndex - 1
			end
		elseif self.curIndex <= 10 then
			self.pointIndex = self.curIndex
		elseif self.curIndex >= self.param.count - 9 then
			self.pointIndex = self.showCount - (self.param.count - self.curIndex)
		else
			self.pointIndex = 7
		end
		self:setLightPoint()
	else
		self.pointIndex = index
		self:setLightPoint()
	end
	self.curIndex = index
end
return commonIndexNumber
