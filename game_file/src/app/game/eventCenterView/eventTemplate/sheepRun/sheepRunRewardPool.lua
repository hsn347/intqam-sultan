local sheepRunCtrl = SoraDGetCtrl("sheepRunCtrl")
local sheepRunRead = include("sheepRunRead")
local sheepRunRewardPool = class("sheepRunRewardPool", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sheepRunRewardPool")
end)
function sheepRunRewardPool:ctor(properties)
	_UPVALUE3_ = nil
	self.poolNames, (nil)[1] = nil, "runningSheep_text_04"
	self.poolNames, (nil)[2] = nil, "runningSheep_text_03"
	self.poolNames, (nil)[3] = nil, "runningSheep_text_02"
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("decrypt_text_03"))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self:initData()
end
function sheepRunRewardPool:setItems(nodeAward, rewards, index)
	dump(rewards, "sheepRunRewardPool:setItems")
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.item, v.num)
		if v.highlight then
			item:showCoolSquare()
		end
		newItem:addTo(nodeAward)
	end
	nodeAward:setAnchorPoint(cc.p(0.5, 1))
	if 5 <= #rewards and index == 1 then
		SoraDautoSortPos(nodeAward, 3, 1, cc.size(100, 95), not SoraDFIsRA())
	else
		SoraDautoSortPos(nodeAward, 5, 1, cc.size(100, 95), not SoraDFIsRA())
	end
end
function sheepRunRewardPool:initData()
	for i = 1, 3 do
		local poolNode = SoraDGetChildByName(self, "Node_pool_" .. i)
		local textTips_1 = SoraDGetChildByName(poolNode, "Text_Tips_1")
		_UPVALUE2_ = "Text_Tips_1"
		;("Text_Tips_1")[1] = poolNode
		;("Text_Tips_1")[2] = textTips_1
		dump("Text_Tips_1", "sheepRunRewardPool:initData")
		textTips_1:setString(i18n(self.poolNames[i]))
		local nodeAward = SoraDGetChildByName(poolNode, "Node_Award")
		local rewards = sheepRunRead.getShowRewards()[i]
		self:setItems(nodeAward, rewards, i)
	end
end
return sheepRunRewardPool
