local mailNodeFactory = include("mailNodeFactory")
local mailAllianceActiveAwardNode = class("mailAllianceActiveAwardNode", function(target)
	return SoraDCreateBasePanel("mailAllianceActiveAwardNode")
end)
function mailAllianceActiveAwardNode:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	self.layout_top = SoraDGetChildByName(self, "Panel_Top")
	self.layout_top.isLayout = true
	self.textAwardTitle = SoraDGetChildByName(self, "Text_AwardTitle")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.layoutSingle = SoraDGetChildByName(self, "Single")
	self.layoutSingle:setVisible(false)
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self.layout_content:setLayoutType(ccui.LayoutType.VERTICAL)
end
function mailAllianceActiveAwardNode:initWithData(data, member)
	self.itemHeight = 100
	if data.rank[1] == data.rank[2] then
		rankStr = data.rank[1]
	else
		rankStr = string.format("%d-%d", data.rank[1], data.rank[2])
	end
	_ENV = nil
	;(nil).num = rankStr
	self.textAwardTitle:setString(i18n("mail_text_618", nil))
	_UPVALUE2_ = i18n("mail_text_618", nil)
	i18n("mail_text_618", nil)[1] = "id"
	i18n("mail_text_618", nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(data.reward, i18n("mail_text_618", nil))
	for i, v in ipairs(reward) do
		local single = include("commonItemAward").new()
		single:setRealScale(0.8)
		single:setOwnView(SoraDCurrentTopPanelFromManager())
		single:initData(v.id, v.count)
		single:addTo(self.nodeAward)
		single:setPosition(cc.p(SoraDFPosX((i - 1) * 90, 0), 0))
	end
	for i, v in ipairs(member) do
		local single = self.layoutSingle:clone()
		single.isLayout = true
		single:setVisible(true)
		single:addTo(self.layout_content)
		single:setPosition(0, 0)
		self:refreshSingle(single, v)
		self.itemHeight = self.itemHeight + 70
	end
	self.layout_content:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailAllianceActiveAwardNode:refreshSingle(target, info)
	local spIndex = SoraDGetChildByName(target, "Sprite_index")
	local textIndex = SoraDGetChildByName(target, "Text_index")
	local textNum = SoraDGetChildByName(target, "Text_Num")
	local textName = SoraDGetChildByName(target, "Text_Name")
	if info.rank > 3 then
		textIndex:setString(info.rank)
		textIndex:setVisible(true)
		spIndex:setVisible(false)
	else
		spIndex:setVisible(true)
		textIndex:setVisible(false)
		spIndex:setSpriteFrame(string.format("icon_ranking_%d.png", info.rank))
	end
	textNum:setString(string.format("%s:%d", i18n("alliance_active_text_005"), string.formatnumberthousands(info.point)))
	textName:setString(info.nickName)
end
function mailAllianceActiveAwardNode:getItemWidth()
	return self.itemWidth
end
function mailAllianceActiveAwardNode:getItemHeight()
	return self.itemHeight
end
return mailAllianceActiveAwardNode
