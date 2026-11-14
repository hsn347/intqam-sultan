local _ENV, AbstractNode
AbstractNode.__index = AbstractNode
AbstractNode.__isPocoNodeWrapper__ = true
function AbstractNode:getParent()
	return nil
end
function AbstractNode:getChildren()
end
function AbstractNode:getAvailableAttributeNames()
	_UPVALUE8_ = nil
	;(nil)[1] = "name"
	;(nil)[2] = "type"
	;(nil)[3] = "visible"
	;(nil)[4] = "pos"
	;(nil)[5] = "size"
	;(nil)[6] = "scale"
	;(nil)[7] = "anchorPoint"
	;(nil)[8] = "zOrders"
	return nil
end
function AbstractNode:getAttr(attrName)
	_UPVALUE0_ = nil
	;(nil).name = "<Root>"
	;(nil).type = "Root"
	_UPVALUE2_, (nil).visible = nil, true
	_UPVALUE2_, (nil).pos, (nil)[1] = nil, nil, 0.0
	_UPVALUE2_, (nil).pos, (nil)[2] = nil, nil, 0.0
	_UPVALUE2_, (nil).size, (nil)[1] = nil, nil, 0.0
	_UPVALUE2_, (nil).size, (nil)[2] = nil, nil, 0.0
	_UPVALUE2_, (nil).scale, (nil)[1] = nil, nil, 1.0
	_UPVALUE2_, (nil).scale, (nil)[2] = nil, nil, 1.0
	_UPVALUE0_, (nil).anchorPoint, (nil)[1] = nil, nil, 0.5
	_UPVALUE0_, (nil).anchorPoint, (nil)[2] = nil, nil, 0.5
	;(nil)["local"] = 0
	;(nil).zOrders, (nil).global = nil, 0
	local attrs
	return attrs[attrName]
end
function AbstractNode:setAttr(attrName, val)
	assert(false, string.format("unable to set attributes \"%s\" on this node", attrName))
	return false
end
function AbstractNode:enumerateAttrs()
	local _ENV, attrs
	for _, attrName in ipairs(self:getAvailableAttributeNames()) do
		local attrVal = self:getAttr(attrName)
		if attrVal ~= nil then
			attrs[attrName] = attrVal
		end
	end
	return attrs
end
return AbstractNode
