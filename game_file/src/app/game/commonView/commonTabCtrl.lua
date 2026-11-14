local OCXTAB_VERTICAL = 1
local OCXTAB_HORIZONTAL = 2
local CommonTabCtrl = class("commonTabCtrl")
function CommonTabCtrl:setType(showType, distance)
	self.containers, _UPVALUE0_, self.tabs, _UPVALUE0_ = nil, nil, nil, nil
	self.distance = distance
	self.actionFlag = true
	self.showType = showType
	self.bottomPos = 0
	self.curIndex = nil
end
function CommonTabCtrl:addTabByIndex(tab, index, container, handle)
	table.insert(self.tabs, tonumber(index), tab)
	table.insert(self.containers, tonumber(index), container)
	tab:addTouchEventListener(handler(self, self.tabClickEventCallBack))
	function tab.addTouchEventListener(target, cb)
		target.touchEventCb = cb
	end
	tab.handle = handle
	if OCXTAB_VERTICAL == self.showType then
		local keys = table.keys(self.tabs)
		table.sort(keys)
		self.bottomPos = self.tabs[keys[#keys]]:getPositionY() - self.tabs[keys[#keys]]:getContentSize().height / 2
	elseif OCXTAB_HORIZONTAL == self.showType then
		local keys = table.keys(self.tabs)
		table.sort(keys)
		self.curIndex = keys[1]
		if self.containers[index] then
			self.containers[index]:setVisible(index == self.curIndex)
		end
	end
end
function CommonTabCtrl:setForceBottomPos(val)
	self.forceBottomPos = val
end
function CommonTabCtrl:rangeTheContainers()
	if OCXTAB_VERTICAL == self.showType then
		if next(self.tabs) == nil then
			return
		end
		if table.nums(self.tabs) <= 1 then
			if self.forceBottomPos then
				self.bottomPos = self.forceBottomPos
			else
				self.bottomPos = 0
			end
		end
		local keys = table.keys(self.tabs)
		table.sort(keys)
		local topPos = self.tabs[keys[1]]:getPositionY() + self.tabs[keys[1]]:getContentSize().height / 2
		local totalDistance = topPos - self.bottomPos
		local totalSinglesDistance = 0
		for _, v in pairs(self.tabs) do
			totalSinglesDistance = totalSinglesDistance + v:getContentSize().height
		end
		local perContainerHeight = totalDistance - totalSinglesDistance - (table.nums(self.tabs) - 1) * self.distance
		for _, v in pairs(self.containers) do
			v:setContentSize(cc.size(v:getContentSize().width, perContainerHeight))
		end
	elseif OCXTAB_HORIZONTAL == self.showType then
	end
end
function CommonTabCtrl:tabClickEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		print("点击")
		SoraDPlaySound()
		local index
		for k, v in pairs(self.tabs) do
			if v == target then
				index = k
				break
			end
		end
		if self.tabs[index] then
			self:switchTo(index)
		end
	end
	if target.touchEventCb then
		target.touchEventCb(target, type)
	end
	if target.handle then
		target.handle(target, type)
	end
end
function CommonTabCtrl:switchTo(index, isCloseAct)
	if not self.actionFlag then
		return
	else
		self.actionFlag = false
	end
	index = tonumber(index)
	if OCXTAB_VERTICAL == self.showType then
		if self.tabs[index] then
			local keys = table.keys(self.tabs)
			table.sort(keys)
			local _ENV, upKeys = table.sort, table.sort
			local _ENV, downKeys = keys, keys
			local classify = true
			local topPos = self.tabs[keys[1]]:getPositionY() + self.tabs[keys[1]]:getContentSize().height / 2
			local bottomPos = self.bottomPos
			for _, v in ipairs(keys) do
				if classify then
					table.insert(upKeys, v)
				else
					table.insert(downKeys, v)
				end
				if v == index then
					classify = false
					if self.containers[v] then
						self.containers[v]:setVisible(true)
					end
				end
			end
			table.sort(downKeys, function(a, b)
				return b < a
			end)
			local upAddVal = 0
			for i, v in ipairs(upKeys) do
				self:moveTo(v, topPos - self.tabs[v]:getContentSize().height / 2 - upAddVal, 0.1, v == index, isCloseAct)
				upAddVal = upAddVal + self.tabs[v]:getContentSize().height + self.distance
			end
			local downAddVal = 0
			for i, v in ipairs(downKeys) do
				self:moveTo(v, bottomPos + self.tabs[v]:getContentSize().height / 2 + downAddVal, 0.1, v == index, isCloseAct)
				downAddVal = downAddVal + self.tabs[v]:getContentSize().height + self.distance
			end
		end
	elseif OCXTAB_HORIZONTAL == self.showType and self.tabs[index] and index ~= self.curIndex then
		self:fadeTo(self.curIndex, index)
		self.curIndex = index
	end
end
function CommonTabCtrl:fadeTo(fromIndex, toIndex)
	if self.containers[fromIndex] and self.containers[toIndex] then
		_ENV = nil
		;(nil)[1] = cca.fadeOut(0.1)
		;(nil)[2] = cca.fadeOut(0.1)
		_ENV = nil
		;(nil).onComplete = function()
			self.containers[fromIndex]:setVisible(false)
			self.containers[toIndex]:setOpacity(0.1)
			self.containers[toIndex]:setVisible(true)
			self = nil
			;(nil)[1] = cca.fadeIn(0.1)
			;(nil)[2] = cca.fadeIn(0.1)
			self = nil
			;(nil).onComplete = function()
				self.actionFlag = true
			end
			transition.execute(self.containers[toIndex], cca.seq(nil), nil)
		end
		transition.execute(self.containers[fromIndex], cca.seq(nil), nil)
	end
end
function CommonTabCtrl:moveTo(index, posY, time, isCurIndex, isCloseAct)
	local onComplete = function()
		if not isCurIndex and self.containers[index] then
			self.containers[index]:setVisible(false)
		end
		self.actionFlag = true
	end
	if isCloseAct then
		self.tabs[index]:setPosition(cc.p(self.tabs[index]:getPositionX(), posY))
		onComplete()
	else
		_ENV = cc.p(self.tabs[index]:getPositionX(), posY)
		_ENV = cc.p(self.tabs[index]:getPositionX(), posY)
		cc.p(self.tabs[index]:getPositionX(), posY).x = self.tabs[index]:getPositionX()
		cc.p(self.tabs[index]:getPositionX(), posY).y = posY
		cc.p(self.tabs[index]:getPositionX(), posY)[1] = cca.moveTo(time, cc.p(self.tabs[index]:getPositionX(), posY))
		cc.p(self.tabs[index]:getPositionX(), posY)[2] = cca.moveTo(time, cc.p(self.tabs[index]:getPositionX(), posY))
		cc.p(self.tabs[index]:getPositionX(), posY)[3] = cca.moveTo(time, cc.p(self.tabs[index]:getPositionX(), posY))
		cc.p(self.tabs[index]:getPositionX(), posY)[4] = cca.moveTo(time, cc.p(self.tabs[index]:getPositionX(), posY))
		cc.p(self.tabs[index]:getPositionX(), posY)[5] = cca.moveTo(time, cc.p(self.tabs[index]:getPositionX(), posY))
		_ENV = cc.p(self.tabs[index]:getPositionX(), posY)
		cc.p(self.tabs[index]:getPositionX(), posY).easing = "SINEINOUT"
		cc.p(self.tabs[index]:getPositionX(), posY).onComplete = onComplete
		transition.execute(self.tabs[index], cca.seq(cc.p(self.tabs[index]:getPositionX(), posY)), cc.p(self.tabs[index]:getPositionX(), posY))
	end
end
return CommonTabCtrl
