local mailItemRewardRecycle = class("mailItemRewardRecycle", function(target)
	return target
end)
function mailItemRewardRecycle:ctor()
	self.tblRewardItems, _UPVALUE0_, self.recycledReward, _UPVALUE0_ = nil, nil, nil, nil
end
function mailItemRewardRecycle:createLayoutMonsterRewardItem(contentData, rewardLayout)
	local vContentLayout = rewardLayout
	if vContentLayout == nil then
		vContentLayout = ccui.VBox:create()
	end
	vContentLayout:setName("rewardLayout")
	vContentLayout:setSwallowTouches(false)
	vContentLayout:setCascadeOpacityEnabled(true)
	vContentLayout:setVisible(true)
	local _ENV, items = vContentLayout.setVisible, vContentLayout.setVisible
	local reward = contentData.reward
	if not reward then
		vContentLayout:setContentSize(cc.size(gMailDetaiViewWidth, 0))
		vContentLayout:setVisible(false)
		return vContentLayout
	end
	local lineNum = 5
	for i, v in ipairs(reward.items) do
		if SoraDFIsRA() then
			_ENV = cc.size(gMailDetaiViewWidth, 0)
			cc.size(gMailDetaiViewWidth, 0).id = reward.items[i].id
			cc.size(gMailDetaiViewWidth, 0).num = reward.items[i].num
			table.insert(items, i, cc.size(gMailDetaiViewWidth, 0))
		else
			_ENV = cc.size(gMailDetaiViewWidth, 0)
			cc.size(gMailDetaiViewWidth, 0).id = reward.items[i].id
			cc.size(gMailDetaiViewWidth, 0).num = reward.items[i].num
			table.insert(items, 1, cc.size(gMailDetaiViewWidth, 0))
		end
	end
	local showUp = false
	if reward.addExp and 0 < reward.addExp then
		showUp = true
	end
	if reward.exp and 0 < reward.exp then
		if SoraDFIsRA() then
			_ENV = cc.size(gMailDetaiViewWidth, 0)
			cc.size(gMailDetaiViewWidth, 0).id = gIDDef.EXP
			cc.size(gMailDetaiViewWidth, 0).num = reward.exp
			cc.size(gMailDetaiViewWidth, 0).showUp = showUp
			table.insert(items, #items + 1, cc.size(gMailDetaiViewWidth, 0))
		else
			_ENV = cc.size(gMailDetaiViewWidth, 0)
			cc.size(gMailDetaiViewWidth, 0).id = gIDDef.EXP
			cc.size(gMailDetaiViewWidth, 0).num = reward.exp
			cc.size(gMailDetaiViewWidth, 0).showUp = showUp
			table.insert(items, 1, cc.size(gMailDetaiViewWidth, 0))
		end
	end
	local totalHeight = 100 * math.ceil(#items / lineNum)
	local contentWidth = gMailDetaiViewWidth
	print("createLayoutMonsterRewardItem", #items, lineNum, totalHeight)
	local labeExpDes = vContentLayout:getChildByName("translateDesc")
	if labeExpDes then
		labeExpDes:setVisible(showUp)
	end
	local textHeight = 0
	if showUp == true then
		_ENV = totalHeight
		totalHeight.percent = reward.addExp or 0
		local expDes = i18n("common_text_4366", totalHeight)
		local labeExpDes = vContentLayout:getChildByName("translateDesc")
		if not labeExpDes then
			labeExpDes = ccui.Text:create()
			labeExpDes:setName("translateDesc")
			vContentLayout:addChild(labeExpDes)
			labeExpDes:setFontSize(22)
			labeExpDes:setColor(cc.c3b(18, 123, 13))
			labeExpDes:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			labeExpDes:setPosition(cc.p(contentWidth / 2, 0))
		end
		labeExpDes:setString(expDes)
		local lp1 = ccui.LinearLayoutParameter:create()
		labeExpDes:setLayoutParameter(lp1)
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		if contentData.monsterInfo.id and contentData.monsterInfo.id > 3121 and contentData.monsterInfo.id < 3127 then
			labeExpDes:setVisible(false)
		end
		textHeight = labeExpDes:getContentSize().height
		totalHeight = totalHeight + textHeight
	end
	vContentLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local rewardNode = vContentLayout:getChildByName("rewardNode")
	if not rewardNode then
		rewardNode = display.newNode()
		rewardNode:setCascadeOpacityEnabled(true)
		rewardNode:setName("rewardNode")
		rewardNode:addTo(vContentLayout)
	end
	rewardNode:setPosition(gMailDetaiViewWidth / 2, (totalHeight - textHeight) / 2)
	for i, itemInfo in ipairs(items) do
		local itemNode, isFromRecycle = self:getRewardItem(itemInfo)
		if isFromRecycle then
			itemNode:setVisible(true)
		else
			itemNode:addTo(rewardNode)
			itemNode:setVisible(true)
		end
		itemNode:setLocalZOrder(i)
		table.insert(self.tblRewardItems, itemNode)
	end
	SoraDautoSortPos(rewardNode, lineNum, 1, cc.size(100, 100), SoraDFIsRA())
	return vContentLayout
end
function mailItemRewardRecycle:hasAnyRecycledRewardItem()
	local result = false
	if #self.recycledReward > 0 then
		result = true
		return result
	end
	return result
end
function mailItemRewardRecycle:recycleRewardItems(rewardLayout)
	if not self.tblRewardItems then
		return
	end
	for i, item in ipairs(self.tblRewardItems) do
		self:addToRecycledRewardList(item)
		item:setVisible(false)
	end
	self.tblRewardItems, _ENV = ipairs(self.tblRewardItems)
end
function mailItemRewardRecycle:addToRecycledRewardList(item)
	self.recycledReward[#self.recycledReward + 1] = item
end
function mailItemRewardRecycle:pickRewardItem()
	local item
	if #self.recycledReward > 0 then
		item = self.recycledReward[#self.recycledReward]
		table.remove(self.recycledReward, #self.recycledReward)
	end
	return item
end
function mailItemRewardRecycle:getRewardItem(data)
	local item
	local isFromRecycle = false
	if self:hasAnyRecycledRewardItem() == true then
		item = self:pickRewardItem()
		item:initWithData(data)
		isFromRecycle = true
	else
		item = self:createRewardItem(data)
	end
	return item, isFromRecycle
end
function mailItemRewardRecycle:createRewardItem(data)
	local mailRewardItem = include("mailRewardItem")
	local itemBoxNode = mailRewardItem.new()
	itemBoxNode:initWithData(data)
	return itemBoxNode
end
return mailItemRewardRecycle
