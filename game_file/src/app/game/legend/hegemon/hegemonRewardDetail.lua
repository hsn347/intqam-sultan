local hegemonRead = include("hegemonRead")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").TITLE = 1
local ("publicRead").REWARD, itemType = 2, "publicRead"
local titleH = 62
local rewardH = 90
local HegemonRewardDetail = class("hegemonRewardDetail", function(target)
	if target == nil then
		return SoraDCreateBasePanel("hegemonRewardDetail")
	end
	return target
end)
function HegemonRewardDetail:ctor()
	self.Size_bg_Image_pp = SoraDGetChildByName(self, "Size_bg_Image_pp")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.Size_ScrollView_Content = SoraDGetChildByName(self, "Size_ScrollView_Content")
	self.node_title = SoraDGetChildByName(self, "node_title")
	self.img_title_bg = SoraDGetChildByName(self, "img_title_bg")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.node_reward = SoraDGetChildByName(self, "node_reward")
	self.panel_content_bg = SoraDGetChildByName(self, "panel_content_bg")
	self.sprite_line_bg = SoraDGetChildByName(self, "sprite_line_bg")
	self.sprite_frame_top_line = SoraDGetChildByName(self, "sprite_frame_top_line")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_num = SoraDGetChildByName(self, "text_num")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.bg = SoraDGetChildByName(self, "bg")
	self.icon = SoraDGetChildByName(self, "icon")
	self.frame = SoraDGetChildByName(self, "frame")
	self.Size_bg_Image_pp:setFillType(1)
	self.scroll = self.Size_ScrollView_Content
	local scrollContentSize = self.scroll:getContentSize()
	self.scroll:setInnerContainerSize(scrollContentSize)
	self.templateNodeTitle = self.node_title
	self.templateNodeReward = self.node_reward
	self.commonFramTitle_node:setTitle(i18n("hegemon_title_01"))
end
function HegemonRewardDetail:getCloneNodeTitle()
	local cloneNode = self.templateNodeTitle:clone()
	return cloneNode
end
function HegemonRewardDetail:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	return cloneNode
end
function HegemonRewardDetail:getLocalDatas()
	local hegemonRead, ret
	local totalH = 0
	for rank = 1, hegemonRead.getWarRankMax() do
		if rank == 1 then
			hegemonRead = nil
			;(nil).itemType = itemType.TITLE
			;(nil).text = i18n("hegemon_name_13")
			table.insert(ret, nil)
		else
			hegemonRead = nil
			;(nil).itemType = itemType.TITLE
			hegemonRead = nil
			;(nil).rank = rank
			;(nil).text = i18n("hegemon_title_14", nil)
			table.insert(ret, nil)
		end
		local reward = hegemonRead.getWarRankReward(rank)
		for i = 1, #reward do
			hegemonRead = nil
			;(nil).itemType = itemType.REWARD
			;(nil).item = reward[i]
			table.insert(ret, nil)
		end
		totalH = totalH + titleH + #reward * rewardH
	end
	return ret, totalH
end
function HegemonRewardDetail:initNodeTitle(node, data)
	local text_title = node:getChildByName("text_title")
	text_title:setString(data.text)
	SoraDSetTextWidthHeight(text_title, cc.size(568, text_title:getContentSize().height))
end
function HegemonRewardDetail:initNodeReward(node, data)
	dump(data, "奖励内容")
	local itemId = data.item.id
	local itemNum = data.item.count
	local bg = SoraDGetChildByName(node, "bg")
	local icon = SoraDGetChildByName(node, "icon")
	local frame = SoraDGetChildByName(node, "frame")
	local text_name = SoraDGetChildByName(node, "text_name")
	local text_num = SoraDGetChildByName(node, "text_num")
	bg:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
	icon:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
	local itemName = publicRead.getName(itemId)
	text_name:setString(itemName)
	text_num:setString(SoraDFIsRA() and string.formatnumberthousands(itemNum) .. "X" or "X" .. string.formatnumberthousands(itemNum))
	SoraDSetTextWidthHeight(text_name, cc.size(300, 50))
	SoraDSetTextWidthHeight(text_num, cc.size(120, 50))
end
function HegemonRewardDetail:init(data)
	self.bid = data.bid
	local innerContainer = self.scroll:getInnerContainer()
	local itemDatas, totalH = self:getLocalDatas()
	local newInnerH = innerContainer:getContentSize().height
	if totalH > innerContainer:getContentSize().height then
		newInnerH = totalH
		local scrollContentSize = self.scroll:getContentSize()
		self.scroll:setInnerContainerSize(cc.size(scrollContentSize.width, newInnerH))
	end
	local node
	local accuH = 0
	local itemH = 0
	local bottomLine = self.node_reward:getChildByName("sprite_frame_top_line"):clone()
	bottomLine:setPosition(320, -2)
	bottomLine:addTo(self.scroll)
	for i, v in ipairs(itemDatas) do
		if v.itemType == itemType.TITLE then
			node = self:getCloneNodeTitle()
			self:initNodeTitle(node, v)
			itemH = titleH
		else
			node = self:getCloneNodeReward()
			self:initNodeReward(node, v)
			itemH = rewardH
		end
		accuH = itemH + accuH
		node:addTo(self.scroll)
		node:setPosition(cc.p(320, newInnerH - accuH))
	end
end
return HegemonRewardDetail
