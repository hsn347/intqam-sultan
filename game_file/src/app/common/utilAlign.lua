local _ENV, _ENV, ua
;(nil).GRID = 1
_ENV, ua.Mode, (nil).FIT = nil, nil, 2
;(nil).LEFT = 1
;(nil).RIGHT = 2
;(nil).UP = 3
ua.Direction, (nil).DOWN = nil, 4
function ua.calcHGrid(param)
	local padding, width, numPadding
	local directionx = param.directionx or ua.Direction.RIGHT
	local itemWidth = param.itemWidth
	local totalWidth = param.totalWidth
	local marginx = param.marginx
	local offsetx = param.offsetx
	local beginx = param.beginx
	local numx = param.numx
	if marginx then
		width = totalWidth - 2 * marginx
		numPadding = numx - 1
		padding = (width - numx * itemWidth) / numPadding
	else
		padding = (totalWidth - numx * itemWidth) / (numx + 1)
		marginx = padding
		width = totalWidth - 2 * marginx
	end
	local ua, ret = 2 * marginx, 2 * marginx
	if directionx == ua.Direction.LEFT then
		print("numx = ", numx)
		for i = 1, numx do
			local posx = beginx + marginx + itemWidth / 2 + (i - 1) * (itemWidth + padding) + offsetx
			print("beginx = ", beginx, ", marginx = ", marginx, ", itemWidth = ", itemWidth, ", padding = ", padding, ", offsetx = ", offsetx)
			print("pox = ", posx)
			table.insert(ret, posx)
		end
	elseif directionx == ua.Direction.RIGHT then
		for i = 1, numx do
			local posx = beginx + totalWidth - marginx - itemWidth / 2 - (i - 1) * (itemWidth + padding) + offsetx
			table.insert(ret, posx)
		end
	end
	return ret
end
function ua.alignHGrid(nodes, param)
	local posxArray = ua.calcHGrid(param)
	for i, v in ipairs(nodes) do
		if posxArray[i] then
			v:setPositionX(posxArray[i])
		end
	end
end
function ua.calcHFit(param)
	local width, numPadding
	local directionx = param.directionx or ua.Direction.RIGHT
	local itemWidth
	local totalWidth = param.totalWidth
	local marginx = param.marginx or 0
	local offsetx = param.offsetx or 0
	local beginx = param.beginx or 0
	local numx = param.numx
	width = totalWidth - 2 * marginx
	itemWidth = width / numx
	local ua, ret = 2 * marginx, 2 * marginx
	if directionx == ua.Direction.LEFT then
		for i = 1, numx do
			local posx = beginx + marginx + itemWidth / 2 + (i - 1) * itemWidth + offsetx
			table.insert(ret, posx)
		end
	elseif directionx == ua.Direction.RIGHT then
		for i = 1, numx do
			local posx = beginx + totalWidth - marginx - itemWidth / 2 - (i - 1) * itemWidth + offsetx
			table.insert(ret, posx)
		end
	end
	return ret
end
function ua.alignHFit(nodes, param)
	local posxArray = ua.calcHFit(param)
	for i, v in ipairs(nodes) do
		if posxArray[i] then
			v:setPositionX(posxArray[i])
		end
	end
end
function ua.calcVGrid(param)
	local padding, height, numPadding
	local directiony = param.directiony or ua.Direction.DOWN
	local itemHeight = param.itemHeight
	local totalHeight = param.totalHeight
	local marginy = param.marginy
	local offsety = param.offsety
	local beginy = param.beginy
	local numy = param.numy
	if marginy then
		height = totalHeight - 2 * marginy
		numPadding = numy - 1
		padding = (height - numy * itemHeight) / numPadding
	else
		padding = (totalHeight - numy * itemHeight) / (numy + 1)
		marginy = padding
		height = totalHeight - 2 * marginy
	end
	local ua, ret = 2 * marginy, 2 * marginy
	if directiony == ua.Direction.DOWN then
		for i = 1, numy do
			local posy = beginy + marginy + itemHeight / 2 + (i - 1) * (itemHeight + padding) + offsety
			table.insert(ret, posy)
		end
	elseif directiony == ua.Direction.UP then
		for i = 1, numy do
			local posy = beginy + totalHeight - marginy - itemHeight / 2 - (i - 1) * (itemHeight + padding) + offsety
			table.insert(ret, posy)
		end
	end
	return ret
end
function ua.alignVGrid(nodes, param)
	local posyArray = ua.calcVGrid(param)
	for i, v in ipairs(nodes) do
		if posyArray[i] then
			v:setPositionY(posyArray[i])
		end
	end
end
function ua.alignVFit(nodes, param)
	param.num = #nodes
	ua.alignVGrid(nodes, param)
end
function ua.calcHGrids(param)
	local posxArray = ua.calcHGrid(param)
	local row = math.ceil(param.totalNum / param.numx)
	param.numy = row
	param.totalHeight = param.numy * param.itemHeight + 2 * (param.marginy or 0) + (param.numy - 1) * (param.paddingy or 0)
	local posyArray = ua.calcVGrid(param)
	return posxArray, posyArray
end
function ua.alignHGrids(nodes, param)
	local row = math.ceil(param.totalNum / param.numx)
	param.numy = row
	local posxArray, posyArray = ua.calcHGrids(param)
	for i, v in ipairs(nodes) do
		local modx = math.fmod(i, param.numx)
		local xIndex = modx == 0 and param.numx or modx
		local yIndex = math.ceil(i / param.numx)
		print("posxArray[" .. xIndex .. "] = ", posxArray[xIndex], ", posyArray[" .. yIndex .. "] = ", posyArray[yIndex])
		v:setPositionX(posxArray[xIndex])
		v:setPositionY(posyArray[yIndex])
	end
end
function ua.alignHFits(nodes, param)
	local row = math.ceil(param.totalNum / param.numx)
	param.numy = row
	local posxArray, posyArray = ua.calcHGrids(param)
	local gridRow = math.floor(param.totalNum / param.numx)
	local gridCount = gridRow * param.numx
	local lastRowCount = param.totalNum - gridCount
	local posxFitArray
	local numx = param.numx
	print("lastRowCount = ", lastRowCount)
	if 0 < lastRowCount then
		if param.isSamePadding then
			param.totalWidth = param.totalWidth - (numx - lastRowCount) * param.itemWidth
			param.beginx = param.beginx + (numx - lastRowCount) * param.itemWidth / 2
		end
		param.numx = lastRowCount
		posxFitArray = ua.calcHFit(param)
	end
	print("gridCount = ", gridCount)
	for i, v in ipairs(nodes) do
		local modx = math.fmod(i, numx)
		local xIndex = modx == 0 and numx or modx
		local yIndex = math.ceil(i / numx)
		if i > gridCount then
			v:setPositionX(posxFitArray[xIndex])
		else
			v:setPositionX(posxArray[xIndex])
		end
		v:setPositionY(posyArray[yIndex])
	end
end
return ua
