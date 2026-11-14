local m = fgui.GComponent
local addChild_old = tolua.getcfunction(m, "addChild")
function m:LuaRegisterScriptHandler()
	self:registerScriptHandler(function(name)
		local funName = name
		if name == "ctor" then
			funName = "ctor"
		elseif name == "enter" then
			funName = "onEnter"
		elseif name == "exit" then
			funName = "onExit"
		elseif name == "enterTransitionFinish" then
			error("not support: onEnterTransitionFinish")
		elseif name == "exitTransitionStart" then
			error("not support: onExitTransitionStart")
		elseif name == "cleanup" then
			funName = "onCleanup"
		else
			error("undefined event:" .. name)
		end
		local fun = self[funName]
		if fun and type(fun) == "function" then
			fun(self)
		else
		end
	end)
end
function m:setNodeEventEnabled(enabled)
	self:LuaRegisterScriptHandler()
end
function m:getInnerContainer()
	return self:getScrollPane()
end
function m:setBounceEnabled(value)
	self:getScrollPane():setBouncebackEffect(value)
end
function m:scrollToObj(obj, ani)
	local scrollPanel = self:getScrollPane()
	local objPosY = obj:getY()
	local objH = obj:getContentSize().height
	local listH = self:getContentSize().height
	local scrollH = scrollPanel:getContentSize().height
	local _overlapSizeH = math.abs(scrollH - listH)
	if 0 < _overlapSizeH then
		local perY = (objPosY + objH / 2 - listH / 2) / _overlapSizeH
		scrollPanel:setPercY(perY, ani)
	end
end
function m:setReddot(visible, num)
	self:getChild("Label_reddot"):initData(visible, num)
end
function m:setScrollEnable(value)
	self:getScrollPane():setTouchEffect(value)
end
return m
