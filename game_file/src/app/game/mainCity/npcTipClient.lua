npcTipClient, _ENV = nil, nil
npcTipClient.bid = 0
npcTipClient.bIndex = 0
npcTipClient.des = "???"
npcTipClient.tipIndex = 1
_UPVALUE1_ = nil
npcTipClient.tips, (nil)[1] = nil, "???"
npcTipClient.topTipOn = false
function npcTipClient:cleanTipInfo()
	npcTipClient.bid = 0
	npcTipClient.bIndex = 0
	npcTipClient.des = "???"
	npcTipClient.tipIndex = 1
	_UPVALUE1_ = nil
	npcTipClient.tips, (nil)[1] = nil, "???"
	npcTipClient.topTipOn = false
end
function npcTipClient:hitTestPercent(percent)
	local randomRet = math.random(1, 1000)
	print("randomRet = ", randomRet)
	local ret = randomRet <= percent * 10
	return ret
end
function npcTipClient:hasTip()
	local npcTipDataModuleAPI = include("npcTipDataModuleAPI")
	print("npcTipDataModuleAPI:isRewardTimesLimitToday() = ", npcTipDataModuleAPI:isRewardTimesLimitToday())
	if npcTipDataModuleAPI:isRewardTimesLimitToday() then
		return false
	end
	if not self:hitTestPercent(30) then
		return false
	end
	return true
end
function npcTipClient:getOrCreateTipInfo()
	if self.bid == 0 and self.bIndex == 0 then
		self:createNewTipInfo()
	end
	_UPVALUE0_ = self.createNewTipInfo
	self.createNewTipInfo.bid = self.bid
	self.createNewTipInfo.bIndex = self.bIndex
	self.createNewTipInfo.des = self.des
	self.createNewTipInfo.tipIndex = self.tipIndex
	self.createNewTipInfo.tips = self.tips
	return self.createNewTipInfo
end
function npcTipClient:getTipInfo()
	_UPVALUE0_ = nil
	;(nil).bid = self.bid
	;(nil).bIndex = self.bIndex
	;(nil).des = self.des
	;(nil).tipIndex = self.tipIndex
	;(nil).tips = self.tips
	return nil
end
function npcTipClient:createNewTipInfo()
	local maincityDesRead = include("maincityDesRead")
	local npcTips = maincityDesRead.getNpcTips()
	local tempNpcTips = clone(npcTips)
	local mainCityFunctions = include("mainCityFunctions")
	local deadCheck = 1
	while true do
		local _ENV, randIndexTbl
		for i, v in ipairs(tempNpcTips) do
			table.insert(randIndexTbl, 10)
		end
		local randIndex = SoraDRandomItem(randIndexTbl)
		if randIndex == nil then
			break
		end
		local bid = tempNpcTips[randIndex].buildID
		local bIndex = tempNpcTips[randIndex].buildIndex
		local isBuildIdle = false
		if bid ~= 0 then
			isBuildIdle = self:isBuildIdleByBid(bid)
			bIndex = mainCityFunctions.getBuildIndexByBid(bid)
		elseif bIndex ~= 0 then
			isBuildIdle = self:isBuildIdleByIndex(bIndex)
		end
		if isBuildIdle then
			local tips = tempNpcTips[randIndex].tips
			local tipIndex = 1
			if 1 < #tips then
				local _ENV, randTipIndexTbl = #tips, #tips
				for i, v in ipairs(tips) do
					table.insert(randTipIndexTbl, 10)
				end
				tipIndex = SoraDRandomItem(randTipIndexTbl)
			end
			self.bid = bid
			self.bIndex = bIndex
			self.tipIndex = tipIndex
			self.des = tips[tipIndex]
			self.tips = tips
			break
		else
			table.remove(tempNpcTips, randIndex)
		end
		deadCheck = deadCheck + 1
		if 1000 < deadCheck then
			break
		end
	end
end
function npcTipClient:isBuildIdleByBid(bid)
	local mainCityFunctions = include("mainCityFunctions")
	return mainCityFunctions.isBuildIdleByBid(bid)
end
function npcTipClient:isBuildIdleByIndex(bIndex)
	local mainCityFunctions = include("mainCityFunctions")
	return mainCityFunctions.isBuildIdleByIndex(bIndex)
end
function npcTipClient:reqTipReward(bid, blv)
	local npcTipDataModuleAPI = include("npcTipDataModuleAPI")
	npcTipDataModuleAPI:reqGetReward(bid, blv)
end
function npcTipClient:setTopTipOn(value)
	self.topTipOn = value
end
function npcTipClient:getTopTipOn()
	return self.topTipOn
end
return npcTipClient
