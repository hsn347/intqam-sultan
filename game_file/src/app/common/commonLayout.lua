function SoraDCreateAchoringLayoutForChildren(parent, side, sort, names)
	local nodes
	if names == nil then
		nodes = parent:getChildByName()
	else
		nodes, _ENV = parent:getChildByName(), parent:getChildByName()
		for _, name in ipairs(names) do
			table.insert(nodes, parent:getChildByName(name))
		end
	end
	return SoraDCreateAchoringLayout(nodes, side, sort)
end
function SoraDCreateAchoringLayout(nodes, side, sort)
	local _ENV, layout
	layout.gaps, _ENV, layout.nodes = nil, nil, nodes
	layout.side = side
	if sort then
		if side == "bottom" then
			table.sort(nodes, function(left, right)
				return left:getPositionY() < right:getPositionY()
			end)
		elseif side == "top" then
			table.sort(nodes, function(left, right)
				return left:getPositionY() > right:getPositionY()
			end)
		elseif side == "left" then
			table.sort(nodes, function(left, right)
				return left:getPositionX() < right:getPositionX()
			end)
		elseif side == "right" then
			table.sort(nodes, function(left, right)
				return left:getPositionX() > right:getPositionX()
			end)
		end
	end
	for i = 2, #nodes do
		local node = nodes[i]
		local preNode = nodes[i - 1]
		local preBox = SoraDGetBoundBox(preNode, node:getParent())
		local box = SoraDGetBoundBox(node)
		if side == "bottom" then
			gap = box.bottom - preBox.top
		elseif side == "top" then
			gap = box.top - preBox.bottom
		elseif side == "left" then
			gap = box.left - preBox.left
		elseif side == "right" then
			gap = box.right - preBox.left
		end
		layout.gaps[i] = gap
	end
	return layout
end
function SoraDLayout(layout)
	for i = 2, #layout.nodes do
		local node = layout.nodes[i]
		local preIndex = i - 1
		local preNode = layout.nodes[preIndex]
		while 1 < preIndex and not preNode:isVisible() do
			preIndex = preIndex - 1
			preNode = layout.nodes[preIndex]
		end
		local preBox = SoraDGetBoundBox(preNode, node:getParent())
		if layout.side == "bottom" then
			local bottom = preBox.top + layout.gaps[i]
			SoraDSetNodeBottom(node, bottom)
		elseif layout.side == "top" then
			local top = preBox.bottom + layout.gaps[i]
			SoraDSetNodeTop(node, top)
		elseif layout.side == "left" then
			local left = preBox.right + layout.gaps[i]
			SoraDSetNodeLeft(node, left)
		elseif layout.side == "right" then
			local right = preBox.left + layout.gaps[i]
			SoraDSetNodeRight(node, right)
		end
	end
end
function SoraDGetBoundBox(node, ref)
	local x, y = node:getPosition()
	local _ENV, box
	local contentSize = node:getContentSize()
	box.left = x - node:getAnchorPoint().x * contentSize.width * node:getScaleX()
	box.bottom = y - node:getAnchorPoint().y * contentSize.height * node:getScaleY()
	box.right = box.left + contentSize.width * node:getScaleX()
	box.top = box.bottom + contentSize.height * node:getScaleY()
	if ref ~= nil and node:getParent() ~= ref then
		local leftBottom = node:getParent():convertToWorldSpace(cc.p(box.left, box.bottom))
		leftBottom = ref:convertToNodeSpace(leftBottom)
		box.left = leftBottom.x
		box.bottom = leftBottom.y
		local topRight = node:getParent():convertToWorldSpace(cc.p(box.right, box.top))
		topRight = ref:convertToNodeSpace(topRight)
		box.right = topRight.x
		box.top = topRight.y
	end
	return box
end
function SoraDSetNodeBottom(node, bottom)
	local y = bottom + node:getAnchorPoint().y * node:getContentSize().height * node:getScaleY()
	node:setPositionY(y)
end
function SoraDSetNodeTop(node, top)
	local y = top + (node:getAnchorPoint().y - 1) * node:getContentSize().height * node:getScaleY()
	node:setPositionY(y)
end
function SoraDSetNodeLeft(node, left)
	local x = left + node:getAnchorPoint().x * node:getContentSize().width * node:getScaleX()
	node:setPositionX(x)
end
function SoraDSetNodeRight(node, right)
	local x = right + (node:getAnchorPoint().x - 1) * node:getContentSize().width * node:getScaleX()
	node:setPositionX(x)
end
function SoraDSetNodeCenterX(node, centerX)
	local x = centerX - node:getContentSize().width * 0.5 * node:getScaleX() + node:getContentSize().width * node:getAnchorPoint().x * node:getScaleX()
	node:setPositionX(x)
end
function SoraDSetNodeCenterY(node, centerY)
	local y = centerY - node:getContentSize().height * 0.5 * node:getScaleY() + node:getContentSize().height * node:getAnchorPoint().y * node:getScaleY()
	node:setPositionY(y)
end
function SoraDLayoutAchoredChildren(parent)
	if parent.__vStrechChildren then
		local parentSize = parent:getContentSize()
		for _, info in ipairs(parent.__vStrechChildren) do
			local childSize = info.child:getContentSize()
			childSize.height = parentSize.height + info.heightDiff
			info.child:setContentSize(childSize)
		end
	end
	if parent.__topChildren then
		for _, info in ipairs(parent.__topChildren) do
			SoraDSetNodeTop(info.child, info.top)
		end
	end
	if parent.__centerChildren then
		for _, info in ipairs(parent.__centerChildren) do
			local centerY = parent.getContentSize().height * 0.5 + info.centerOffset
			SoraDSetNodeCenterY(info.child, centerY)
		end
	end
end
function SoraDCenterChild(child)
	local parent = child:getParent()
	if parent == nil then
		return
	end
	local size = parent:getContentSize()
	SoraDSetNodeCenterX(child, size.width * 0.5)
	SoraDSetNodeCenterY(child, size.height * 0.5)
end
function SoraDCenterChildY(child)
	local parent = child:getParent()
	if parent == nil then
		return
	end
	local size = parent:getContentSize()
	SoraDSetNodeCenterY(child, size.height * 0.5)
end
function SoraDStrechHeight(target, oldHeight)
	local parent = target:getParent()
	if parent == nil then
		return
	end
	local targetY = target:getPositionY()
	local heightDiff = target:getContentSize().height - oldHeight
	local children = parent:getChildren()
	for _, child in ipairs(children) do
		local y = child:getPositionY()
		if targetY < y then
			y = y + heightDiff
			child:setPositionY(y)
		end
	end
	local parentSize = parent:getContentSize()
	parentSize.height = parentSize.height + heightDiff
	parent:setContentSize(parentSize)
end
