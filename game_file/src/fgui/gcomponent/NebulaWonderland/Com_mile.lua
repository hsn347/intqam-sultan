local nebulaWonderlandRead = include("nebulaWonderlandRead")
local nebulaWonderlandCtrl = SoraDGetCtrl("nebulaWonderlandCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_mile = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWonderland/Com_mile", Com_mile)
function Com_mile:onInit()
	self.fields.n2:setPositionY(2699)
	self.pane = self:getScrollPane()
	if display.width / display.height < 0.5 then
		self:setBouncePos()
		self.fields.Com_mileage:setPositionX(self.fields.Com_mileage:getPositionX() + 3)
	end
	self:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:captureTouch()
	end)
	self:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.setScrollProgress))
	self.rewardCfg = nebulaWonderlandRead.getRewardConfig()
	self.index = self:calCurIndex()
	self:setStaticPage()
	self.fields.Com_mileage:setCallback(handler(self, self.setStaticPage))
end
function Com_mile:setBouncePos()
	self.fields.n2:setPositionY(2805)
end
function Com_mile:setYOff()
	self.fields.n2:setPositionY(2805)
	self.pane:setPercY(1)
	self.pane:updatePositionImmediately()
end
function Com_mile:setScrollProgress()
	local index = 0
	local offset = self.pane:getPercY()
	if offset < 0.3 then
		index = 2
	elseif offset < 0.6 then
		index = 1
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_NEBULA_WONDERLAND_PAGE"
	;(nil).pageIndex = index
	SoraDSendMessage(nil)
	if offset < 0.1 then
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_WONDERLAND_PAGE"
		;(nil).top = true
		SoraDSendMessage(nil)
	elseif 0.9 < offset then
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_WONDERLAND_PAGE"
		;(nil).bottom = true
		SoraDSendMessage(nil)
	end
end
function Com_mile:calCurIndex()
	local index = 1
	local left = 0
	for i, v in ipairs(self.rewardCfg) do
		if nebulaWonderlandCtrl:getProgress() >= v.integral then
			index = index + 1
		end
	end
	return index
end
function Com_mile:setStaticPage(index)
	local scrollIndex = index or self:calCurIndex()
	if 11 <= scrollIndex then
		self.pane:setPosY(50)
	elseif 6 <= scrollIndex then
		self.pane:setPosY(1000)
	else
		self.pane:setPercY(1)
	end
	self.pane:updatePositionImmediately()
end
function Com_mile:setGiftState(index)
	self.fields.Com_mileage:setGiftState(index)
end
function Com_mile:initData()
	self.fields.Com_mileage:initData()
end
function Com_mile:onShow()
end
return Com_mile
