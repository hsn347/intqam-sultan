local dynamicScroll = class("dynamicScroll", function(target)
	return target
end)
function dynamicScroll:ctor()
	self.canUseOCXs, _UPVALUE0_, self.listData, _UPVALUE0_ = nil, nil, nil, nil
	self.scroll = self
end
function dynamicScroll:init(newList, doSingle, singleSize)
