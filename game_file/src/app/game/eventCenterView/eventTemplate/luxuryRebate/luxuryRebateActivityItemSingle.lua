local luxuryRebateActivityItemSingle = class("luxuryRebateActivityItemSingle", function(target, normal)
	if target == nil then
		return display.node()
	end
	return target
end)
local luxuryRebateDef = include("luxuryRebateDef")
local DAY_STATUES = luxuryRebateDef.DAY_STATUES
local AWARD_STATUES = luxuryRebateDef.AWARD_STATUES
function luxuryRebateActivityItemSingle:ctor(target)
	self.listNode, _UPVALUE0_, self.scrollItems, _UPVALUE0_, self.singleCCS = nil, nil, nil, nil, "luxuryRebateActivityItem"
end
function luxuryRebateActivityItemSingle:setSingleCCS(ccsFileName)
	self.singleCCS = ccsFileName
end
function luxuryRebateActivityItemSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function luxuryRebateActivityItemSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self:createItem()
	end
	single:setVisible(true)
	return single
end
function luxuryRebateActivityItemSingle:createItem()
	local single = include(self.singleCCS).new()
	single:setScale(0.7)
	single:setBaseScale(1.0)
	single:addTo(self)
	return single
end
function luxuryRebateActivityItemSingle:setAwardEffect(show)
	if show then
		if not self.effectNode then
			local effect = SoraDCreatAnimation("luxuryRebateEffect_award", nil, true)
			effect:setPosition(0, 0)
			effect:addTo(self, -1)
			self.effectNode = effect
		end
		self.effectNode:setVisible(true)
	elseif self.effectNode then
		self.effectNode:setVisible(false)
	end
end
function luxuryRebateActivityItemSingle:setItemStatus(statue, dayStatue)
	for _, v in ipairs(self.scrollItems) do
		v:setItemStatus(statue)
	end
	local show = dayStatue == DAY_STATUES.DAY_STATUES_DONE and statue == AWARD_STATUES.AWARD_STATUES_NORMAL
	self:setAwardEffect(show)
end
function luxuryRebateActivityItemSingle:setScroll(scroll)
	for _, v in ipairs(self.scrollItems) do
		v:setOwnScroll(scroll)
	end
end
local MAX_ROW_NUM = 2
function luxuryRebateActivityItemSingle:initPreviewItem(award, view)
	self:recycleSingle()
	local height = 60
	local offset = 30
	for k, v in ipairs(award) do
		local single = self:getSingle()
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(offset - x * height, 0)
		local posy = -y * height + offset
		single:setPosition(cc.p(posX, posy))
		single:setScale(0.55)
		single:setBaseScale(1.0)
		single:setOwnView(view)
		single:initData(v.id, v.count)
		table.insert(self.scrollItems, single)
	end
end
function luxuryRebateActivityItemSingle:initNormalItem(award, other)
	self:recycleSingle()
	local height = 80
	local offsetX = 40
	local offsetY = 40
	if #award <= 2 then
		offsetY = 0
	end
	for k, v in ipairs(award) do
		local single = self:getSingle()
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(offsetX - x * height, 0)
		local posy = -y * height + offsetY
		single:setPosition(cc.p(posX, posy))
		single:setOwnView(other.view)
		single:setOwnScroll(other.scroll)
		single:initData(v.id, v.count)
		table.insert(self.scrollItems, single)
	end
end
return luxuryRebateActivityItemSingle
