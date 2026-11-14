local legendLordWarltCtrl = include("legendLordWarltCtrl")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").TITLE = 1
local ("publicRead").REWARD, itemType = 2, "publicRead"
local titleH = 62
local rewardH = 90
local legendaryKingRewardDetail = class("legendaryKingRewardDetail", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendaryKingRewardDetail")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendaryKingRewardDetail:ctor()
	self:createUI()
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
	self.commonFramTitle_node:setTitle(i18n("common_text_4211"))
end
function legendaryKingRewardDetail:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryKingRewardDetail:getCloneNodeTitle()
	local cloneNode = self.templateNodeTitle:clone()
	return cloneNode
end
function legendaryKingRewardDetail:getCloneNodeReward()
	local cloneNode = self.templateNodeReward:clone()
	return cloneNode
end
function legendaryKingRewardDetail:getLocalDatas()
	local _ENV, ret
	dump(self.mapid, "self.mapid")
	local name1 = i18n(worldMapDefine.isKingStarMapId(self.mapid) and "kingstarbattle_name_01" or "common_text_4207")
	local name2 = worldMapDefine.isKingStarMapId(self.mapid) and "kingstarbattle_text_59" or "mail_text_458"
	local configs = legendLordWarltCtrl.getLegendLordWarRankRewards(self.mapid)
	local _ENV, keys = self.mapid, self.mapid
	for k, v in pairs(configs) do
		keys[#keys + 1] = tonumber(k)
	end
	table.sort(keys)
	for rank = 1, #keys do
		local curRank = keys[rank]
		local titleText = ""
		if curRank == 1 then
			titleText = name1
		elseif rank < curRank then
			local preRank = keys[rank - 1] + 1
			_ENV = nil
			;(nil).rank = string.format("%d-%d", preRank, curRank)
			titleText = i18n(name2, nil)
		else
			_ENV = name2
			name2.rank = curRank
			titleText = i18n(name2, name2)
		end
		_ENV = name2
		name2.itemType = itemType.TITLE
		name2.text = titleText
		table.insert(ret, name2)
		local reward = legendLordWarltCtrl.getLegendLordWarRankReward(curRank, self.mapid)
		for i = 1, #reward do
			_ENV = curRank
			curRank.itemType = itemType.REWARD
			curRank.item = reward[i]
			table.insert(ret, curRank)
		end
	end
	local totalH = #ret * rewardH - #keys * (rewardH - titleH)
	return ret, totalH
end
function legendaryKingRewardDetail:initNodeTitle(node, data)
	node:getChildByName("text_title"):setString(data.text)
end
function legendaryKingRewardDetail:initNodeReward(node, data)
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
	SoraDGetAutoHeightLabel(text_name, 330)
	text_num:setString(SoraDFIsRA() and string.formatnumberthousands(itemNum) .. "X" or "X" .. string.formatnumberthousands(itemNum))
end
function legendaryKingRewardDetail:init(mapid)
	self.mapid = mapid
	if worldMapDefine.isKingStarMapId(self.mapid) then
		local activityID = worldMapDefine.getKingStarActivityID(self.mapid)
		_ENV = self.mapid
		self.mapid[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_23")
		_ENV = nil
		;(nil).ranklist = i18n("remains_name_01")
		self.mapid[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text6", nil)
		_ENV = nil
		;(nil).ranklist = i18n("king_star_rank_text3")
		local self.mapid[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text6", nil), self.mapid
		self.commonFramTitle_node:setTitle(activityID and titleCfg[activityID] or i18n("kingstarbattle_text_23"))
	end
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
function legendaryKingRewardDetail:onMessageListener()
end
return legendaryKingRewardDetail
