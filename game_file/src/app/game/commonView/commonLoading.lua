local commonLoading = class("commonLoading", function(size)
	local isFullScreen = false
	if not size then
		size = display.realSize
		isFullScreen = true
	end
	local view = include("baseView").new(size, false)
	view.isFullScreen = isFullScreen
	view.size = size
	return view
end)
function commonLoading:ctor()
	self.mark = nil
	self.viewName = "commonLoading"
	self:setName(self.viewName)
	local size = self:getContentSize()
	self.loadingImg = display.newSprite("SinglePicture/loading1.png")
	self.loadingImg:setPosition(cc.p(size.width / 2, size.height / 2))
	self:addChild(self.loadingImg, 1)
	self:doLoadingAnimation()
end
function commonLoading:doLoadingAnimation()
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.RotateBy:create(1.0, 360)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:doLoadingAnimation()
	end)
	local actions = transition.sequence(actionsArray)
	self.loadingImg:runAction(actions)
end
function commonLoading:setMark(mark)
	self.mark = mark
end
function commonLoading:getMark()
	return self.mark
end
function commonLoading:showLoading(parent, mark, isTransparent, timeOut, isShadow)
	if not parent or parent == display.getRunningScene() then
		parent = display.getRunningScene()
		self:setPosition(cc.p(display.cx, display.rcy))
	else
		if self.isFullScreen then
			local size = parent:getContentSize()
			self:setContentSize(size.x, size.y)
		end
		local size = self:getContentSize()
		self:setPosition(size.width / 2, size.height / 2)
		self.loadingImg:setPosition(size.width / 2, size.height / 2)
	end
	self:closeLoading(parent, mark)
	self.mark = mark
	if isTransparent == true then
		self.loadingImg:setVisible(false)
	end
	parent:addChild(self, 100)
	if timeOut then
		_UPVALUE1_ = 100
		;(100)[1] = cca.delay(timeOut)
		;(100)[2] = cca.callFunc(function()
			if not tolua.isnull(self) then
				self:removeFromParent()
			end
		end)
		;(100)[3] = cca.callFunc(function()
			if not tolua.isnull(self) then
				self:removeFromParent()
			end
		end)
		self:runAction(cca.seq(100))
	end
	if isShadow then
		self:setBackGround(100)
		_ENV = self
		self.msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
		self.onEnter = true
		self.opacity = self:getBackGroundColorOpacity()
		SoraDSendMessage(self)
	else
		self:setBackGround(0)
	end
end
function commonLoading:closeLoading(parent, mark)
	parent = parent or display.getRunningScene()
	mark = mark or self.mark
	local preLoading = parent:getChildByName(self.viewName)
	if preLoading and self.mark == mark then
		preLoading:removeFromParent(true)
	end
end
function commonLoading:onExitOther()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
	SoraDSendMessage(nil)
end
return commonLoading
