local kohMigrateKingdomListScroll = class("kohMigrateKingdomListScroll", function(target)
	return target
end)
local _ENV, kingdomListState = "kohMigrateKingdomListScroll", "kohMigrateKingdomListScroll"
function kohMigrateKingdomListScroll:ctor()
	self.tableSpare, _UPVALUE0_, self.tableSingle, _UPVALUE0_ = nil, nil, nil, nil
	self.scroll = self
	self.singleCCS = "atlantisMemberGroupSingle"
	self:initWidget()
end
function kohMigrateKingdomListScroll:initWidget()
	self:addEventListener(handler(self, self.scrollEventCallBack))
end
function kohMigrateKingdomListScroll:setSingleCCS(ccsFileName)
	self.singleCCS = ccsFileName
end
function kohMigrateKingdomListScroll:initScroll(groupList, otherData)
	for k, v in ipairs(self.tableSingle) do
		v:setVisible(false)
		v:setState(false)
	end
	for i, groupData in ipairs(groupList) do
		local index = i
		local single = self.tableSingle[index]
		if single == nil then
			single = SoraDCreatePanel(self.singleCCS)
			single:setClickCallBack(handler(self, self.updateScrollView))
			single:addTo(self.scroll)
			single:setVisible(false)
			table.insert(self.tableSingle, single)
		end
		if not groupData.type or #groupData.kingdomList > 0 and groupData.type == 0 or groupData.type ~= 0 then
			_ENV = handler(self, self.updateScrollView)
			handler(self, self.updateScrollView).index = index
			handler(self, self.updateScrollView).tableSpare = self.tableSpare
			handler(self, self.updateScrollView).scroll = self.scroll
			handler(self, self.updateScrollView).itemSize = otherData.itemSize
			handler(self, self.updateScrollView).showRedPoint = otherData.showRedPoint
			single:initData(groupData, handler(self, self.updateScrollView))
			single:setState(kingdomListState[tonumber(index)])
			single:setVisible(true)
		end
	end
	self:updateScrollView()
end
function kohMigrateKingdomListScroll:updateScrollView(index, state)
	if index then
		kingdomListState[tonumber(index)] = state
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 42
	for i = #self.tableSingle, 1, -1 do
		local single = self.tableSingle[i]
		if single:isVisible() then
			scrollInnerNewH = scrollInnerNewH + single:getSingleH()
			single:setPosition(cc.p(320, scrollInnerNewH))
		end
	end
	scrollInnerNewH = scrollInnerNewH + 5
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			if v:isVisible() then
				v:setPositionY(v:getPositionY() + upto)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function kohMigrateKingdomListScroll:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function kohMigrateKingdomListScroll:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
return kohMigrateKingdomListScroll
