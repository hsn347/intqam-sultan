local starRhapsodyRead = include("starRhapsodyRead")
local starRhapsodyAwardView = class("starRhapsodyAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("starRhapsodyAwardView")
	end
	return target
end)
function starRhapsodyAwardView:ctor()
	self:setBackGround(229.5)
	self.btnGain = SoraDGetChildByName(self, "Button_gain")
	self.btnGain:addTouchEventListener(handler(self, self.onClickGain))
	self.btnGain:setTitleText(i18n("common_text_204"))
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.singleUse = false
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.initSingle))
	self.scroll:setVisbileShowScale(1, 2)
	self:setCloseCallBack(function()
		self:showAwardAndClose()
	end)
	local nodeFg = SoraDGetChildByName(self, "Node_fg")
	_G.SoraDSetNodeArrayAdditive(nodeFg:getChildren())
	local nodeBg = SoraDGetChildByName(self, "Node_bg")
	_G.SoraDSetNodeArrayAdditive(nodeBg:getChildren())
	SoraDCreatAnimation("starRhapsodyAwardView", self, true)
	SoraDPlaySound("pyramid", 5)
end
function starRhapsodyAwardView:initAnimation()
	local Node_fireWork = SoraDGetChildByName(self, "Node_fireWork")
	local fireWork = SoraDCreatAnimation("animationFireWork")
	fireWork:addTo(Node_fireWork)
end
function starRhapsodyAwardView:initData(data)
	table.sort(data, function(a, b)
		return a < b
	end)
	self.awardList, _ENV, self.itemList, _ENV = table.sort, table.sort, table.sort, table.sort
	for i, v in ipairs(data) do
		_ENV = nil
		self.itemList[i], (nil).index = nil, v
	end
	dump(self.itemList, "self.itemList", 10)
	self.scroll:updateScrollView(cc.size(550, 280), self.itemList)
end
function starRhapsodyAwardView:createSingle()
	local single
	single = self.single:clone()
	single:setVisible(true)
	return single
end
function starRhapsodyAwardView:initSingle(node, data, otherData)
	local index = data.index or 1
	local lampInfo = starRhapsodyRead:getCombCfg(index)
	dump(lampInfo, "lampInfo", 10)
	if lampInfo then
		local isGold = index == 1
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_starRhapsodyLamp_award_", 3, 1, true, true)
			for i, v in ipairs(tableItem) do
				if lampInfo.colorComb[i] then
					v:setLampColor(lampInfo.colorComb[i], isGold)
				end
			end
		end
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_commonItemAward_", 4, 1, true, true)
			for i, v in ipairs(tableItem) do
				local item = lampInfo.reward[i]
				if item then
					v:setOwnView(self)
					v:setVisible(true)
					v:initData(item.id, item.count)
					table.insert(self.awardList, item)
				else
					v:setVisible(false)
				end
			end
		end
		SoraDToCenter(SoraDGetChildByName(node, "Node_award"), 114)
		local nodeGold = SoraDGetChildByName(node, "Node_title_gold")
		local nodeNormal = SoraDGetChildByName(node, "Node_title_normal")
		nodeGold:setVisible(isGold)
		nodeNormal:setVisible(not isGold)
		local txtTitleLevel
		if isGold then
			txtTitleLevel = SoraDGetChildByName(nodeGold, "Text_title_level")
		else
			txtTitleLevel = SoraDGetChildByName(nodeNormal, "Text_title_level")
		end
		local name = starRhapsodyRead:getAwardNmae(lampInfo.type)
		txtTitleLevel:setString(name)
	end
end
function starRhapsodyAwardView:showAwardAndClose()
	if self.awardList and #self.awardList > 0 then
		SoraDMailGainItems(self.awardList, true)
	end
	self:removeFromParent()
end
function starRhapsodyAwardView:onClickGain(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showAwardAndClose()
	end
end
return starRhapsodyAwardView
