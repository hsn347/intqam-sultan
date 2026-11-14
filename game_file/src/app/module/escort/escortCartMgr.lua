local escortCartMgr = class("escortCartMgr")
function escortCartMgr:ctor()
	self.currCartLv = 1
	self.refreshCount = 0
	self.refreshTime = 0
	self.cartMoveTimeMap, _UPVALUE0_, self.rewardMap, _UPVALUE0_, self.nextRefreshGold = nil, nil, nil, nil, 0
end
function escortCartMgr:getCurrCartLv()
	return self.currCartLv
end
function escortCartMgr:setCurrCartLv(lv)
	self.currCartLv = lv
end
function escortCartMgr:getRefreshCount()
	return self.refreshCount
end
function escortCartMgr:setRefreshCount(count)
	self.refreshCount = count
end
function escortCartMgr:getRefreshTime()
	return self.refreshTime
end
function escortCartMgr:setRefreshTime(t)
	self.refreshTime = t
end
function escortCartMgr:setNextRefreshGold(gold)
	self.nextRefreshGold = gold
end
function escortCartMgr:getNextRefreshGold()
	return self.nextRefreshGold
end
function escortCartMgr:setCartRewardMap(rewardMap)
	self.rewardMap = rewardMap
end
function escortCartMgr:getCartReward(lv)
	if self.rewardMap then
		return self.rewardMap[lv]
	end
	_UPVALUE0_ = self.rewardMap[lv]
	return self.rewardMap[lv]
end
function escortCartMgr:setCurrCartMoveTime(cartMoveTimeMap)
	self.cartMoveTimeMap = cartMoveTimeMap
end
function escortCartMgr:getCurrCartMoveTime()
	if self.cartMoveTimeMap then
		return self.cartMoveTimeMap[self.currCartLv]
	end
	return 0
end
return escortCartMgr
