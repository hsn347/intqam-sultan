local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
local mermaidGiftRead = include("mermaidGiftRead")
local mermaidGiftpLogView = class("mermaidGiftpLogView", function()
	return SoraDCreateTouchPanel("mermaidGiftpLogView")
end)
function mermaidGiftpLogView:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("Mermaid_title_16"))
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.listData, _ENV, self.scroll = include("commonScrollView").new(self.scroll), include("commonScrollView").new(self.scroll), include("commonScrollView").new(self.scroll)
	_ENV = "ScrollView"
	;("ScrollView").listData = self.listData
	;("ScrollView").nodeSizeType = gScrollViewNodeSizeType.dynamic
	;("ScrollView").createNodeHandler = handler(self, self.createSingle)
	;("ScrollView").nodeDirection = gScrollViewNodeDirection.top
	;("ScrollView").cellSizeFunc = handler(self, self.getCellSize)
	;("ScrollView").updateCellAtIndexFunc = handler(self, self.refreshSingle)
	self.scroll:init("ScrollView")
	self.textNoLog = SoraDGetChildByName(self, "text_no_rank_tip")
	self.textNoLog:setString(i18n("god_beast_text_16"))
	self.giftSingle = SoraDGetChildByName(self, "node_gift_num")
	self.luckySingle = SoraDGetChildByName(self, "node_luck_num")
	self.single = SoraDGetChildByName(self, "Node_Singles")
	SoraDShowLoading(self)
	mermaidGiftCtrl:reqMermaidGiftHistory()
end
function mermaidGiftpLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MERMAID_GIFT_HISTORY", handler(self, self.updataData))
end
function mermaidGiftpLogView:updataData(target, data)
	SoraDCloseLoading(self)
	self.textNoLog:setVisible(not next(data.record))
	self.scroll.listData = data.record
	self.scroll:updateScrollView()
end
function mermaidGiftpLogView:createSingle(data)
	local single = self.single:clone()
	single:setAnchorPoint(cc.p(0, 0))
	single:setVisible(true)
	local node1 = SoraDGetChildByName(single, "Node_Single")
	local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz01", nil, true)
	effect_normal:setPosition(cc.p(0, 0))
	effect_normal:addTo(SoraDGetChildByName(node1, "Node_Effect"))
	effect_normal:setLocalZOrder(-1)
	local node2 = SoraDGetChildByName(single, "Node_Single_2")
	local effect_normal = SoraDCreatAnimation("Node_Effect_rydkz01", nil, true)
	effect_normal:setPosition(cc.p(0, 0))
	effect_normal:addTo(SoraDGetChildByName(node2, "Node_Effect"))
	effect_normal:setLocalZOrder(-1)
	return single
end
function mermaidGiftpLogView:getCellSize(data)
	if #data.vals > 5 then
		return cc.size(550, 286)
	else
		return cc.size(550, 200)
	end
end
function mermaidGiftpLogView:refreshSingle(node, data)
	local node1 = SoraDGetChildByName(node, "Node_Single")
	node1:setVisible(#data.vals <= 5)
	local node2 = SoraDGetChildByName(node, "Node_Single_2")
	node2:setVisible(#data.vals > 5)
	local parent = #data.vals > 5 and node2 or node1
	local titleLb = SoraDGetChildByName(parent, "Text_Title")
	local timeLb = SoraDGetChildByName(parent, "Text_Time")
	local giftNumLb = SoraDGetChildByName(parent, "Text_gift_num")
	local luckyNumLb = SoraDGetChildByName(parent, "Text_lucky_num")
	local nolukcyNumLb = SoraDGetChildByName(parent, "Text_no_lucky")
	_ENV = nil
	;(nil).num = data.num
	titleLb:setString(i18n("Mermaid_title_04", nil))
	timeLb:setString(os.date("!%Y/%m/%d %H:%M:%S", data.time))
	giftNumLb:setString(i18n("Mermaid_text_07"))
	luckyNumLb:setString(i18n("Mermaid_text_08"))
	nolukcyNumLb:setString(i18n("Mermaid_text_09"))
	nolukcyNumLb:setVisible(table.nums(data.lucks) <= 0)
	self:updateGifts(data.vals, SoraDGetChildByName(parent, "Node_1"))
	self:updateLuckys(data.lucks, SoraDGetChildByName(parent, "Node_2"))
end
function mermaidGiftpLogView:updateGifts(gifts, parentNode)
	for k, v in pairs(parentNode:getChildren()) do
		v:setVisible(false)
	end
	for k, v in pairs(gifts) do
		local giftNode = parentNode:getChildByTag(k)
		if giftNode == nil then
			giftNode = self.giftSingle:clone()
			giftNode:addTo(parentNode)
			giftNode:setTag(k)
			giftNode:setPositionY(0)
		end
		giftNode:setVisible(true)
		local giftNum = mermaidGiftRead.getGiftNumByType(v)
		local icon = SoraDGetChildByName(giftNode, "icon_gift_num")
		icon:setSpriteFrame(string.format("icon_mermaid_rewardType_%02d.png", v))
	end
	if table.nums(gifts) > 5 then
		parentNode:setPositionY(175)
	end
	if SoraDFIsRA() then
		SoraDautoSortPos(parentNode, 5, 2, cc.size(70, 50), not SoraDFIsRA())
	else
		SoraDautoSortPos(parentNode, 5, 0, cc.size(70, 50), not SoraDFIsRA())
	end
end
function mermaidGiftpLogView:updateLuckys(luckys, parentNode)
	for k, v in pairs(parentNode:getChildren()) do
		v:setVisible(false)
	end
	for k, v in pairs(luckys) do
		local luckyNode = parentNode:getChildByTag(k)
		if luckyNode == nil then
			luckyNode = self.luckySingle:clone()
			luckyNode:addTo(parentNode)
			luckyNode:setTag(k)
			luckyNode:setPositionY(0)
		end
		luckyNode:setVisible(true)
		local numLb = SoraDGetChildByName(luckyNode, "Text_lucky")
		numLb:setColor(cc.c3b(255, 255, 255))
		numLb:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
		numLb:setString(v)
	end
	if table.nums(luckys) > 5 then
		parentNode:setPositionY(65)
	end
	if SoraDFIsRA() then
		SoraDautoSortPos(parentNode, 5, 2, cc.size(70, 50), not SoraDFIsRA())
	else
		SoraDautoSortPos(parentNode, 5, 0, cc.size(70, 50), not SoraDFIsRA())
	end
end
return mermaidGiftpLogView
