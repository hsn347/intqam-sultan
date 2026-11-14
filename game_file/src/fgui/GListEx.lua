local m = fgui.GList
function m:scrollToCenter(obj, ani)
	local scrollPanel = self:getScrollPane()
	local objPosx = obj:getX()
	local objW = obj:getContentSize().width
	local listW = self:getContentSize().width
	local scrollW = scrollPanel:getContentSize().width
	local _overlapSizeW = scrollW - listW
	if 0 < _overlapSizeW then
		local perx = (objPosx + objW / 2 - listW / 2) / _overlapSizeW
		scrollPanel:setPercX(perx, ani)
	end
end
function m:scrollToObj(obj, ani)
	local scrollPanel = self:getScrollPane()
	local objPosY = obj:getY()
	local objH = obj:getContentSize().height
	local listH = self:getContentSize().height
	local scrollH = scrollPanel:getContentSize().height
	local _overlapSizeH = scrollH - listH
	if 0 < _overlapSizeH then
		local perY = (objPosY + objH / 2 - listH / 2) / _overlapSizeH
		scrollPanel:setPercY(perY, ani)
	end
end
function m:playGridList(offsetT, delayTime)
	local items = self:getChildren()
	if #items == 0 then
		return
	end
	for k, v in ipairs(items) do
		v:setAlpha(0)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(delayTime + k * offsetT)
		;(nil)[2] = ffa.fadeIn(0.2)
		;(nil)[3] = ffa.fadeIn(0.2)
		v:runAction(ffa.seq(nil))
	end
end
function m:playAniList(offsetY, delayTime)
	local oriPosY = self:getPositionY()
	self:setAlpha(0)
	self:setPositionY(oriPosY - offsetY)
	_UPVALUE1_ = nil
	_UPVALUE1_ = nil
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.1)
	;(nil)[2] = ffa.moveTo(0.1, self:getPositionX(), oriPosY)
	;(nil)[3] = ffa.moveTo(0.1, self:getPositionX(), oriPosY)
	;(nil)[4] = ffa.moveTo(0.1, self:getPositionX(), oriPosY)
	;(nil)[5] = ffa.moveTo(0.1, self:getPositionX(), oriPosY)
	;(nil)[1] = ffa.fadeIn(0.2)
	;(nil)[2] = ffa.seq(nil)
	;(nil)[3] = ffa.seq(nil)
	;(nil)[4] = ffa.seq(nil)
	;(nil)[5] = ffa.seq(nil)
	;(nil)[6] = ffa.seq(nil)
	;(nil)[7] = ffa.seq(nil)
	;(nil)[8] = ffa.seq(nil)
	;(nil)[1] = ffa.delay(delayTime)
	;(nil)[2] = ffa.spawn(nil)
	;(nil)[3] = ffa.spawn(nil)
	;(nil)[4] = ffa.spawn(nil)
	;(nil)[5] = ffa.spawn(nil)
	;(nil)[6] = ffa.spawn(nil)
	;(nil)[7] = ffa.spawn(nil)
	;(nil)[8] = ffa.spawn(nil)
	;(nil)[9] = ffa.spawn(nil)
	;(nil)[10] = ffa.spawn(nil)
	;(nil)[11] = ffa.spawn(nil)
	self:runAction(ffa.seq(nil))
end
local setNumItems_old = m.setNumItems
function m:onExit()
	self.__isInit = nil
end
function m:onExitByCache()
	if self.__isFirstInit then
		self:setNumItems(0)
	end
end
function m:setNumItems(items)
	setNumItems_old(self, items)
	if items == 0 then
		return
	end
	if self.__isFirstInit and not self:isRunning() then
		return
	end
	self.__isFirstInit = true
	if not self.__isInit then
		self.__isInit = true
		self:playListAction()
	end
end
function m:playListAction()
	local customData = self:getCustomData()
	if customData and type(customData) == "string" then
		local customTb = string.split(customData, ":")
		local actionType = customTb[1]
		local custom2 = customTb[2] and tonumber(customTb[2])
		local custom3 = customTb[3] and tonumber(customTb[3])
		local delayTime = (custom3 or 0) / 60
		if actionType == "1" then
			local offsetT = (custom2 or 2) / 60
			self:playGridList(offsetT, delayTime)
		elseif actionType == "2" then
			local offsetY = custom2 or 10
			self:playAniList(offsetY, delayTime)
		end
		if not self.__initNodeEvent then
			self.__initNodeEvent = true
			self:setNodeEventEnabled(true)
		end
	end
end
