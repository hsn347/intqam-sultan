local scrollNode = include("scrollNode")
local remainsWarBuffDetail = class("remainsWarBuffDetail", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarBuffDetail")
	end
	return target
end)
function remainsWarBuffDetail:ctor()
	self.itemList, _UPVALUE0_ = nil, nil
	self:initWidget()
end
function remainsWarBuffDetail:initWidget()
	self.Image_detail = SoraDGetChildByName(self, "Image_detail")
	self.oldSize = self.Image_detail:getContentSize()
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
end
function remainsWarBuffDetail:initData(data)
	local itemN = #data
	local totalRow = math.ceil(itemN / 3)
	for i = 1, itemN do
		local row = math.ceil(i / 3)
		local col = (i - 1) % 3 + 1
		local item = self.Node_single:clone()
		item:addTo(self, 1)
		item:setVisible(true)
		self:initItemSingle(item)
		item:setPosition(192 * SoraDFSign(2 - col), -40 - 80 * (row - 1))
		self:refreshItemSingle(item, data[i])
		table.insert(self.itemList, item)
	end
	self.Image_detail:setContentSize(cc.size(self.oldSize.width, self.oldSize.height + 80 * (totalRow - 1)))
	for i = 1, totalRow - 1 do
		local line = display.newSprite("#frame_duihuanshangcheng_line.png")
		line:addTo(self, 1)
		line:setScaleX(575 / line:getContentSize().width)
		line:setPosition(0, -80 * i)
	end
end
function remainsWarBuffDetail:initItemSingle(item)
	item.Text_time = SoraDGetChildByName(item, "Text_time")
	item.Text_time = SoraDCreateTimerLabel(self, item.Text_time)
	item.Text_time:setTimeUpdateListener(function(tick)
		item.progressBar:setPercent(tick / item.totalTime * 100)
	end)
	item.Text_time:setTimeEndListener(function()
		item:removeFromParent()
	end)
	item.progressBar = SoraDGetChildByName(item, "LoadingBar_progress")
end
function remainsWarBuffDetail:refreshItemSingle(item, data)
	local leftTime = data.endTime - serviceFunctions.systemTime()
	local totalTime = data.endTime - data.beginTime
	item.totalTime = totalTime
	item.Text_time:beginTime(leftTime)
	item.progressBar:setPercent(leftTime / totalTime * 100)
end
function remainsWarBuffDetail:getItemHeight()
	return self.Image_detail:getContentSize().height - self.Image_detail:getPositionY() - 10
end
return remainsWarBuffDetail
