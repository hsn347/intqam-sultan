local royalSummonsShopScrollList = class("royalSummonsShopScrollList", function(target)
	local commonTaskSingle = include("commonAutoScrollList")
	target = commonTaskSingle.new(target)
	return target
end)
function royalSummonsShopScrollList:ctor()
	self.tableBgSpare, _UPVALUE0_ = nil, nil
end
function royalSummonsShopScrollList:setBgCreateHandle(handle)
	self.bgCreateHandle = handle
end
function royalSummonsShopScrollList:updateRowBg()
	local singleBg
	local maxRowNum = self.widthNum or 1
	local rowNum = math.ceil(#self.tableSingle / maxRowNum)
	local singleBgClone = self.bgCreateHandle
	if rowNum < #self.tableBgSpare then
		for i = rowNum + 1, #self.tableBgSpare do
			self.tableBgSpare[i]:setVisible(false)
		end
	end
	for i = 1, rowNum do
		if self.tableBgSpare[i] then
			singleBg = self.tableBgSpare[i]
			singleBg:setVisible(true)
		else
			singleBg = singleBgClone()
			singleBg:addTo(self)
			table.insert(self.tableBgSpare, singleBg)
		end
		singleBg:setPosition(0, self.tableSingle[i * maxRowNum - 1].pos.y + 25)
	end
end
return royalSummonsShopScrollList
