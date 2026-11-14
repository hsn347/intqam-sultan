local CtPageView = class("ctPageView", function(target)
	return target
end)
function CtPageView:ctor()
	_ENV = nil
	;(nil).LEFT = 1
	self.constant, (nil).RIGHT = nil, 2
	self.factoryHandler = nil
	self.pageCSBList, _ENV, self.pageInfoList, _ENV, self.nowPageIndex = nil, nil, nil, nil, 1
	self.pageView = self
	self.pageSize = self:getContentSize()
	self.pageView:setTouchEnabled(true)
	self.pageView:addTouchEventListener(handler(self, self.panelClick))
	self.recordNode = display.newNode()
	self.recordNode:addTo(self)
	self.recordNode:setPosition(0, 0)
	self.recordNodePos = cc.p(0, 0)
end
function CtPageView:init(infoList, factoryHandl)
	self.factoryHandler = factoryHandl
	self.pageInfoList = infoList
	for i, v in ipairs(self.pageInfoList) do
		local panel = self:newPage(self.factoryHandler(self.pageInfoList[i]))
		panel:setPosition((i - 1) * self.pageSize.width, 0)
		self.pageCSBList[i] = panel
	end
end
function CtPageView:autoSetPageIndex(forward)
	local rePageIndex = self.nowPageIndex
	if self.constant.LEFT == forward then
		rePageIndex = rePageIndex - 1
	elseif self.constant.RIGHT == forward then
		rePageIndex = rePageIndex + 1
	end
	if rePageIndex <= 0 then
		rePageIndex = #self.pageInfoList
	elseif rePageIndex > #self.pageInfoList then
		rePageIndex = 1
	end
	return rePageIndex
end
function CtPageView:nextLoad(forward)
	local rePageIndex = self:autoSetPageIndex(forward)
	local controlPage = self:addPage(rePageIndex)
	if self.constant.LEFT == forward then
		controlPage:setPosition(-self.pageSize.width, 0)
	elseif self.constant.RIGHT == forward then
		controlPage:setPosition(self.pageSize.width, 0)
	end
end
function CtPageView:showPage(csbList)
	for _, v1 in pairs(self.pageCSBList) do
		local canShow = false
		for _, v2 in pairs(csbList) do
			if v1 == v2 then
				canShow = true
			end
		end
		if canShow then
			v1:setVisible(true)
		else
			v1:setVisible(false)
		end
	end
end
function CtPageView:addPage(_index)
	local page
	if self.pageCSBList[_index] then
		page = self.pageCSBList[_index]
	else
		self.pageCSBList[_index] = self:newPage(self.factoryHandler(self.pageInfoList[_index]))
		page = self.pageCSBList[_index]
	end
	return page
end
function CtPageView:newPage(csb)
	local panel = ccui.Layout:create()
	panel:setAnchorPoint(cc.p(0, 0))
	panel:setClippingEnabled(true)
	panel:setContentSize(cc.size(self.pageSize.width, self.pageSize.height))
	panel:addTo(self.pageView)
	csb:addTo(panel)
	return panel
end
function CtPageView:pageMovePos(detaX)
	local popPageStartPos = function(index)
		local totalRange = #self.pageInfoList * self.pageSize.width
		local deta = self.recordNodePos.x % totalRange
		local realNodePosX = 0
		if 0 < detaX then
			realNodePosX = -totalRange + deta
		else
			realNodePosX = deta
		end
		local posx = realNodePosX + (index - 1) * self.pageSize.width
		return cc.p(posx, self.recordNodePos.y)
	end
	for k, v in pairs(self.pageCSBList) do
		local pos = popPageStartPos(k)
		v:setPosition(pos.x - detaX, pos.y)
	end
	self.recordNode:setPosition(self.recordNodePos.x - detaX, self.recordNodePos.y)
end
function CtPageView:recordMoveStartPos()
	self.recordNodePos = cc.p(self.recordNode:getPositionX(), self.recordNode:getPositionY())
end
function CtPageView:panelClick(button, eventType)
	if eventType == ccui.TouchEventType.began then
		self:recordMoveStartPos()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local detaX = touchBeganPoint.x - touchmovePoint.x
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		self:pageMovePos(detaX)
	elseif eventType == ccui.TouchEventType.canceled then
	elseif eventType == ccui.TouchEventType.ended then
	end
end
return CtPageView
