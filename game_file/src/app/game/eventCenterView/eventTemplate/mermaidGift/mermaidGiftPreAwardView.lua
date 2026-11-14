local mermaidGiftRead = include("mermaidGiftRead")
local constantRead = include("constantRead")
local mermaidGiftPreAwardView = class("mermaidGiftPreAwardView", function(target)
	return target or SoraDCreateTouchPanel("mermaidGiftPreAwardView")
end)
function mermaidGiftPreAwardView:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("decrypt_text_03"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.singleNode:setVisible(false)
	self.headNode = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.textTip = SoraDGetChildByName(self, "Text_tips")
	self.textTip = SoraDChangeTextToHtml(self.textTip)
	self.title = SoraDGetChildByName(self, "Text_title")
	self.title:setString(i18n("Mermaid_title_03"))
	self.title2 = SoraDGetChildByName(self, "Text_title_2")
	self.title2:setString(i18n("common_text_2078"))
	self.giftCharNumLimit = string.formatnumberthousands(constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000))
	_ENV = constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)
	_ENV, _ENV, constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000).num = constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)
	self.giftCharNumLimit.num, constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000).color = constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)
	self.textTip:setString(i18n_html("Mermaid_text_03", constantRead.getConstValue("MERMAID_GIFT_CHARMNUMLIMIT", 1800000)))
	self.items, _ENV, self.nodeReward = SoraDGetChildByName(self, "Node_reward"), SoraDGetChildByName(self, "Node_reward"), SoraDGetChildByName(self, "Node_reward")
	local parent = SoraDGetChildByName(self, "Node_title_bg")
	local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz01", nil, true)
	effect_normal:setPosition(cc.p(parent:getContentSize().width / 2, parent:getContentSize().height / 2))
	effect_normal:addTo(parent)
	effect_normal:setLocalZOrder(-1)
	self:initData()
end
function mermaidGiftPreAwardView:initData(data)
	local rewards = mermaidGiftRead.getReward()
	local limitRewards = rewards[1].reward1
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	limitRewards = serviceFunctions.tableFormat(limitRewards, nil)
	local parentNode = self.nodeReward
	for k, v in pairs(limitRewards) do
		local item = parentNode:getChildByTag(k)
		if item == nil then
			item = SoraDPopItemAward()
			item:addTo(parentNode)
			item:setTag(k)
			item:setScale(0.9)
			item:setScroll(self)
			item:setPositionY(0)
			table.insert(self.items, item)
		end
		item:setVisible(true)
		item:initData(v.id, v.count)
	end
	SoraDToCenter(parentNode, 100)
	dump(rewards, "mermaidGiftPreAwardView")
	local mermaidGiftRead, rewardList = dump, dump
	for k, v in pairs(rewards) do
		table.insert(rewardList, v)
	end
	table.sort(rewardList, function(l, r)
		return l.type < r.type
	end)
	self.scroll:updateScrollView(cc.size(550, 135), rewardList, 1)
end
function mermaidGiftPreAwardView:createSingle()
	local single = self.singleNode:clone()
	single:setAnchorPoint(cc.p(0, 0))
	single:setVisible(true)
	return single
end
function mermaidGiftPreAwardView:refreshSingle(parent, data)
	local rType = data.type
	_ENV = nil
	;(nil).num = rType
	local str = i18n("Mermaid_text_04", nil)
	if 5 < rType then
		_ENV = nil
		;(nil).num = rType - 5
		str = i18n("Mermaid_text_05", nil)
	end
	SoraDGetChildByName(parent, "Text_gift_name"):setString(str)
	local luckNumLb = SoraDGetChildByName(parent, "Text_LuckyNum")
	_ENV = nil
	;(nil).num = data.giftNum
	luckNumLb:setString(i18n("Mermaid_text_06", nil))
	local icon = SoraDGetChildByName(parent, "icon_value")
	local iconScore = SoraDGetChildByName(parent, "icon_score")
	iconScore:setSpriteFrame(string.format("icon_mermaid_rewardType_%02d.png", rType))
	local itemNode = SoraDGetChildByName(parent, "Node_item")
	local item = SoraDGetChildByName(itemNode, "item")
	if not item then
		item = SoraDPopItemAward()
		item:setName("item")
		item:addTo(itemNode)
		item:setPosition(0, 0)
		item:setScale(0.8)
		item:setScroll(self)
		table.insert(self.items, item)
	end
	if data.reward[1] then
		item:setVisible(true)
		item:initData(data.reward[1], data.reward[2])
		icon:setPositionY(23)
		luckNumLb:setPositionY(23)
	else
		item:setVisible(false)
		icon:setPositionY(68)
		luckNumLb:setPositionY(68)
	end
end
return mermaidGiftPreAwardView
