local _ENV, buildLogic
local cityltCtrl = include("cityltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local badgeExchangeCtrl = gametop.playertop_:getModule("badgeExchangeCtrl")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local attributeSystem = include("attributeSystem")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
function buildLogic.getCanBuildList(btype)
	local cityltCtrl, ret
	local bididlist = cityltCtrl.getCanBuildIdList(btype)
	for i, bid in ipairs(bididlist) do
		local maxcount = cityltCtrl.buildAttr(bid, BUILD_ATTR.BMAXCOUNT)
		local curcount = cityCtrl:getBuildCount(bid)
		local isbuild = (cityltCtrl.buildAttr(bid, BUILD_ATTR.ISBUILD) or 0) == 1
		if isbuild and maxcount > curcount then
			local iscanbuild = buildLogic.isCanBuild(bid)
			cityltCtrl = nil
			;(nil).bid = bid
			;(nil).iscanbuild = iscanbuild
			table.insert(ret, nil)
		end
	end
	local cityltCtrl, canbuild = (for generator), ipairs(bididlist)
	local cityltCtrl, cantnotbuild = ipairs(bididlist)
	for i, v in ipairs(ret) do
		if v.iscanbuild then
			table.insert(canbuild, v)
		else
			table.insert(cantnotbuild, v)
		end
	end
	for i, v in ipairs(cantnotbuild) do
		table.insert(canbuild, v)
	end
	return canbuild
end
function buildLogic.isCanBuild(bid)
	local bid = tonumber(bid)
	local isbuild = cityltCtrl.buildAttr(bid, BUILD_ATTR.ISBUILD)
	if isbuild and isbuild ~= 0 then
		local errprecond, retdata = buildLogic.isCanUpgrade(bid, -1)
		return errprecond, retdata
	else
	end
end
function buildLogic.isCanUpgrade(bid, iid)
	local bid = tonumber(bid)
	local iid = tonumber(iid)
	_ENV = iid
	iid.bid = bid
	local iid.iid, buildData = iid, iid
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local isLuckyBless = luckyBlessCtrl:getLuckyData().curEffectType == gLuckyBlessActivityEffectType.BUILD_UPGRADE
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local isfulllv = buildLogic.buildLvIsFull(bid, iid)
	if isfulllv then
		return false
	end
	local buildcell = cityCtrl:getBuildCell(bid, iid)
	local blv = cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV)
	local starlv = 0
	if buildcell then
		blv = tonumber(buildcell.info.lv) + 1
		starlv = tonumber(buildcell.info.starLv)
	end
	local errprecond = true
	local retPreNebulaTower
	local preNebulaTowerLv = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.NEBULATOWER)
	if preNebulaTowerLv and 0 < preNebulaTowerLv then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local nebulaTowerLv = nebulaActivityCtrl:getTowerLv()
		local _isreach = true
		if preNebulaTowerLv > nebulaTowerLv then
			errprecond = false
			_isreach = false
		end
		_ENV = nil
		;(nil).lv = nebulaTowerLv
		;(nil).needlv = preNebulaTowerLv
		retPreNebulaTower, (nil).isreach = nil, _isreach
	end
	local _ENV, retPreCond = nebulaActivityCtrl, SoraDGetCtrl("nebulaActivityCtrl")
	local precond = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.PRECOND)
	if precond and next(precond) then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _blv = precond[2 * i]
			local _curlv = cityCtrl:getBuildMaxLv(_bid)
			local _isreach = true
			if _blv > _curlv then
				errprecond = false
				_isreach = false
			end
			_ENV = nil
			;(nil).bid = _bid
			;(nil).blv = _blv
			;(nil).curlv = _curlv
			;(nil).isreach = _isreach
			table.insert(retPreCond, nil)
		end
	else
		local _bid = BUILDID.CASTLE
		local _blv = cityltCtrl.buildAttr(bid, BUILD_ATTR.UNLOCKLEVEL)
		local _curlv = cityCtrl:getBuildMaxLv(_bid)
		local _isreach = true
		if _blv > _curlv then
			errprecond = false
			_isreach = false
		end
		_ENV = cityCtrl:getBuildMaxLv(_bid)
		cityCtrl:getBuildMaxLv(_bid).bid = _bid
		cityCtrl:getBuildMaxLv(_bid).blv = _blv
		cityCtrl:getBuildMaxLv(_bid).curlv = _curlv
		cityCtrl:getBuildMaxLv(_bid).isreach = _isreach
		table.insert(retPreCond, (cityCtrl:getBuildMaxLv(_bid)))
	end
	local _ENV, retCostRes = _bid, BUILDID.CASTLE
	local costres = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.COSTRES)
	if costres then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		local costResReduceBuff = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE) or 0
		if blv <= 30 then
			local buffReduce30 = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30) or 0
			costResReduceBuff = costResReduceBuff + buffReduce30
		end
		if blv <= 70 then
			local buffReduce70 = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4) or 0
			costResReduceBuff = costResReduceBuff + buffReduce70
		end
		if starlv <= 70 then
			local buffStar70 = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_LESS_STARLV_70) or 0
			costResReduceBuff = costResReduceBuff + buffStar70
		end
		local techReduceRate = technologyCtrl:getTechnologyPower(gTechnologyType.BUILD_COST_REDUCE) or 0
		local totalReduceRate = costResReduceBuff / 1000 + techReduceRate
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			local _curcount = cityCtrl:getResCount(_resid)
			if 0 < _rescount then
				if costResReduceBuff then
					_rescount = math.ceil(_rescount * (1 - totalReduceRate))
				end
				local _isreach = true
				local _isLuckyReach = false
				local luckyRescount = _rescount
				if _curcount < _rescount then
					if isLuckyBless then
						luckyRescount = luckyBlessCtrl:getResult(luckyRescount)
					end
					local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, buildData)
					luckyRescount = math.ceil(luckyRescount * subPercent)
					_isLuckyReach = _curcount >= luckyRescount
					_isreach = false
				end
				_ENV = luckyRescount * subPercent
				;(luckyRescount * subPercent).resid = _resid
				;(luckyRescount * subPercent).rescount = _rescount
				;(luckyRescount * subPercent).curcount = _curcount
				;(luckyRescount * subPercent).isreach = _isreach
				;(luckyRescount * subPercent).isLuckyReach = _isLuckyReach
				table.insert(retCostRes, luckyRescount * subPercent)
			end
		end
	end
	local _ENV, retCostTools = buffCtrl, gametop.playertop_:getModule("buffCtrl")
	local costtools = cityltCtrl.buildLvInfo(bid, blv, "costTools")
	if costtools then
		for i = 1, #costtools / 2 do
			local _toolid = costtools[2 * i - 1]
			local _toolcount = costtools[2 * i]
			local _curcount = backpackCtrl:getItemCount(_toolid)
			local _isreach = true
			if _toolcount > _curcount then
				_isreach = false
			end
			_ENV = true
			;(true).toolid = _toolid
			;(true).toolcount = _toolcount
			;(true).curcount = _curcount
			;(true).isreach = _isreach
			table.insert(retCostTools, true)
		end
	end
	local _ENV, retCostWEs = (for index), 1
	local costWEs = cityltCtrl.buildLvInfo(bid, blv, "costWEs")
	if costWEs then
		local costWesReduceRate = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE, gBuffSource.NEBULA_TOWER) or 0
		local activityRate = 1
		if costWEs[1] == 301101 then
			activityRate = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_WAR_BADG_REDUCE, buildData)
		else
			activityRate = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_WAR_SENIOR_BADG_REDUCE, buildData)
		end
		costWesReduceRate = costWesReduceRate / 1000
		for i = 1, #costWEs / 2 do
			local _toolid = costWEs[2 * i - 1]
			local _toolcount = costWEs[2 * i]
			local oriCount = math.floor(_toolcount * (1 - costWesReduceRate))
			_toolcount = math.floor(_toolcount * (1 - costWesReduceRate) * activityRate)
			local _curcount = backpackCtrl:getItemCount(_toolid)
			local _isreach = true
			if _toolcount > _curcount then
				_isreach = false
			end
			_ENV = nil
			;(nil).toolid = _toolid
			;(nil).toolcount = _toolcount
			;(nil).oriCount = oriCount
			;(nil).curcount = _curcount
			;(nil).isreach = _isreach
			table.insert(retCostWEs, nil)
		end
	end
	local buildQueueList = buildLogic.getCurBuildQueue()
	local costtime = buildLogic.getUpgradeTime(bid, iid, blv, starlv)
	local resToGold = 0
	for k, v in pairs(retCostRes) do
		if v.rescount > v.curcount then
			local _rescount = v.rescount
			if isLuckyBless then
				_rescount = luckyBlessCtrl:getResult(_rescount)
			end
			local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, buildData)
			_rescount = math.ceil(_rescount * subPercent)
			local needBuyRes = math.max(_rescount - v.curcount, 0)
			resToGold = resToGold + serviceFunctions.resConvertToGold(v.resid, needBuyRes)
		end
	end
	local toolToGold = 0
	for k, v in pairs(retCostTools) do
		local lackcount = v.toolcount - v.curcount
		if 0 < lackcount then
			local price = gModuleMgr.sharedMgr("shopltCtrl"):getPriceByItemID(v.toolid) or 0
			toolToGold = toolToGold + lackcount * price
		end
	end
	local WEToGold = 0
	for k, v in pairs(retCostWEs) do
		local lackcount = v.toolcount - v.curcount
		if 0 < lackcount then
			local gold = badgeExchangeCtrl:getCostGoldByCount(lackcount, v.toolid)
			WEToGold = WEToGold + gold
		end
	end
	local timeToGold = serviceFunctions.timeConvertToGold(costtime)
	local immediatelyGold = resToGold + timeToGold + toolToGold + WEToGold
	local _exp = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.EXP)
	local _power = cityltCtrl.getPowerReward(bid, blv)
	_ENV = bid
	bid.exp = _exp
	local _ENV, bid.power, retReward = blv, _power, bid
	blv._retPreCond = retPreCond
	blv._buildQueueList = buildQueueList
	blv._retCostRes = retCostRes
	blv._retCostTools = retCostTools
	blv._costtime = costtime
	blv._resToGold = resToGold
	blv._toolToGold = toolToGold
	blv._immediatelyGold = immediatelyGold
	blv._retReward = retReward
	blv._retCostWEs = retCostWEs
	blv._WEToGold = WEToGold
	local blv._retPreNebulaTower, retdata = retPreNebulaTower, blv
	return errprecond, retdata
end
function buildLogic.isCanUpgradeStar(bid, iid, extra)
	local bid = tonumber(bid)
	local iid = tonumber(iid)
	local _ENV, extra = iid, extra or iid
	local isQuick = extra.isQuick
	local totalReduceRate = extra.totalReduceRate
	local isfulllv = buildLogic.buildStarLvIsFull(bid, iid)
	if isfulllv then
		return false
	end
	local buildcell = cityCtrl:getBuildCell(bid, iid)
	local blv = 1
	if buildcell then
		blv = tonumber(buildcell.info.starLv) + 1
	end
	local errprecond = true
	local _ENV, retPreCond = buildcell.info.starLv, buildcell.info.starLv
	local precond = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.PRECOND)
	if precond then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _blv = precond[2 * i]
			local _curlv
			if _bid == bid then
				_curlv = tonumber(buildcell.info.lv)
			else
				_curlv = cityCtrl:getBuildMaxLv(_bid)
			end
			local _isreach = true
			if _blv > _curlv then
				errprecond = false
				_isreach = false
				if isQuick then
					return errprecond
				end
			end
			_ENV = nil
			;(nil).bid = _bid
			;(nil).blv = _blv
			;(nil).curlv = _curlv
			;(nil).isreach = _isreach
			table.insert(retPreCond, nil)
		end
	end
	local _ENV, retPreStar = (for index), 1
	local precond = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.PRESTAR)
	if precond then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _starLv = precond[2 * i]
			local _curlv = cityCtrl:getBuildMaxStarLv(_bid)
			local _isreach = true
			if _starLv > _curlv then
				errprecond = false
				_isreach = false
				if isQuick then
					return errprecond
				end
			end
			_ENV = nil
			;(nil).bid = _bid
			;(nil).starLv = _starLv
			;(nil).curlv = _curlv
			;(nil).isreach = _isreach
			table.insert(retPreStar, nil)
		end
	end
	local _ENV, retPreMagic = (for index), 1
	local precond = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.PREMAGIC)
	if precond then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		cityCtrl = precond[2 * i]
		precond[2 * i][1] = "jinnType"
		precond[2 * i][2] = "jinnLv"
		local precondList = serviceFunctions.tableFormat(precond, precond[2 * i])
		for __, v in ipairs(precondList) do
			local _curlv = magicLampCtrl:getJinnLv(v.jinnType)
			local _isreach = true
			if _curlv < v.jinnLv then
				_isreach = false
				errprecond = false
				if isQuick then
					return errprecond
				end
			end
			_ENV = nil
			;(nil).jinnType = v.jinnType
			;(nil).jinnLv = v.jinnLv
			;(nil).curlv = _curlv
			;(nil).isreach = _isreach
			table.insert(retPreMagic, nil)
		end
	end
	local _ENV, retCostRes = magicLampCtrl, SoraDGetCtrl("magicLampCtrl")
	local costres = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.COSTRES)
	if costres then
		totalReduceRate = totalReduceRate or buildLogic.getUpgradeStarCostReducePercent(bid, blv)
		local gSCRL100Rate = 0
		if bid == BUILDID.STAR_BRAVE_STATUE and blv <= 100 then
			gSCRL100Rate = buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_COST_REDUCE_LESS_100) or 0
		end
		local nebulatowerBuff = buildLogic.getNebulaTowerBuff(bid, blv, radiantDecreeBuffType.UPGRADE_COST_RES_REDUCE)
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			local _curcount = cityCtrl:getResCount(_resid)
			if 0 < _rescount then
				_rescount = math.ceil(_rescount * (1 - totalReduceRate) * (1 - gSCRL100Rate / 1000) * (1 - nebulatowerBuff / 1000))
				local _isreach = true
				local _isLuckyReach = false
				if _curcount < _rescount then
					_isreach = false
				end
				_ENV = nil
				;(nil).resid = _resid
				;(nil).rescount = _rescount
				;(nil).curcount = _curcount
				;(nil).isreach = _isreach
				;(nil).isLuckyReach = _isLuckyReach
				table.insert(retCostRes, nil)
			end
		end
	end
	local _ENV, retCostItems = gSCRL100Rate, 0
	local _ENV, retCostTools = buildLogic.getNebulaTowerBuff(bid, blv, radiantDecreeBuffType.UPGRADE_COST_RES_REDUCE), buildLogic.getNebulaTowerBuff(bid, blv, radiantDecreeBuffType.UPGRADE_COST_RES_REDUCE)
	local costitem = cityltCtrl.buildStarLvInfo(bid, blv, "costitem")
	if costitem then
		for i = 1, #costitem / 2 do
			local _toolid = costitem[2 * i - 1]
			local _toolcount = costitem[2 * i]
			local _curcount = backpackCtrl:getItemCount(_toolid)
			local _toolCountOri
			local nebulatowerBuff = buildLogic.getNebulaTowerBuff(bid, blv, radiantDecreeBuffType.UPGRADE_COST_ITEM_REDUCE)
			_toolcount = _toolcount * (1 - nebulatowerBuff / 1000)
			if _toolid == gBadgeItemID.AMBER_ID then
				_toolCountOri = math.ceil(_toolcount)
				local amberDecreeBuff = buildLogic.getAmberDecreeBuff(bid, blv)
				_toolcount = _toolcount * (1 - amberDecreeBuff / 1000)
				local rechargeBuff = buildLogic.getRechargeBuffDecreeBuff(bid, radiantDecreeBuffType.AMBER_REDUCE)
				_toolcount = _toolcount * (1 - rechargeBuff / 1000)
			elseif _toolid == gBadgeItemID.STELLAR_ID then
				_toolCountOri = math.ceil(_toolcount)
				local astralDecreeBuff = buildLogic.getAstralDecreeBuff(bid, blv)
				_toolcount = _toolcount * (1 - astralDecreeBuff / 1000)
				local rechargeBuff = buildLogic.getRechargeBuffDecreeBuff(bid, radiantDecreeBuffType.ASTRAL_MINE_REDUCE)
				_toolcount = _toolcount * (1 - rechargeBuff / 1000)
			end
			_toolcount = math.ceil(_toolcount)
			local _isreach = true
			if _curcount < _toolcount then
				errprecond = false
				_isreach = false
				if isQuick then
					return errprecond
				end
			end
			_ENV = _toolcount
			_toolcount.toolid = _toolid
			_toolcount.toolcount = _toolcount
			_toolcount.oriCount = _toolCountOri
			_toolcount.curcount = _curcount
			local _toolcount.isreach, data = _isreach, _toolcount
			if BUILD_STAR_COSTITEM[_toolid] then
				table.insert(retCostItems, data)
			else
				table.insert(retCostTools, data)
			end
		end
	end
	local _ENV, buildStarQueueList = (for index), 1
	if bid == BUILDID.STAR_BRAVE_STATUE then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.glorious_upgrade)
		if queue then
			table.insert(buildStarQueueList, queue)
		end
	else
		local queue = queueCtrl:queryQueue(gQueueTypeDef.build_star_queue)
		if queue then
			table.insert(buildStarQueueList, queue)
			if _G.SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(_G.gExaltedPrivilegeType.EXTRA_STAR_UPGRADE_QUEUENUM) then
				local queueSecond = queueCtrl:queryQueue(gQueueTypeDef.build_star_queue_privilege)
				if queueSecond then
					table.insert(buildStarQueueList, queueSecond)
				end
			end
		end
	end
	local _ENV, buildQueueList = queue, queueCtrl:queryQueue(gQueueTypeDef.build_star_queue)
	for i, queue in ipairs(buildLogic.getCurBuildQueue()) do
		if queue.data.optype == tostring(BUILD_OPERATE_TYPE.DEMOLISH) and queue.data.bid == tostring(bid) and queue.data.iid == tostring(iid) then
			errprecond = false
			if isQuick then
				return errprecond
			end
			table.insert(buildQueueList, queue)
		end
	end
	local costtime = buildLogic.getUpgradeStarTime(bid, iid, blv)
	local resToGold = 0
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local isLuckyBless = luckyBlessCtrl:getLuckyData().curEffectType == gLuckyBlessActivityEffectType.BUILD_STRENGTH
	for k, v in pairs(retCostRes) do
		if v.rescount > v.curcount then
			local _rescount = v.rescount
			if isLuckyBless then
				_rescount = luckyBlessCtrl:getResult(_rescount)
			end
			local subPercent = 1
			_ENV = luckyBlessCtrl
			luckyBlessCtrl.bid = bid
			local luckyBlessCtrl.iid, buildData = iid, luckyBlessCtrl
			if bid == BUILDID.STAR_BRAVE_STATUE then
				subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE_STATUE, buildData)
			else
				subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE, buildData)
			end
			_rescount = math.ceil(_rescount * subPercent)
			local needBuyRes = math.max(_rescount - v.curcount, 0)
			resToGold = resToGold + serviceFunctions.resConvertToGold(v.resid, needBuyRes)
		end
	end
	local toolToGold = 0
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	for k, v in pairs(retCostTools) do
		local lackcount = v.toolcount - v.curcount
		if 0 < lackcount then
			local price = shopltCtrl:getPriceByItemID(v.toolid) or 0
			toolToGold = toolToGold + lackcount * price
		end
	end
	local timeToGold = serviceFunctions.timeConvertToGold(costtime)
	local immediatelyGold = resToGold + toolToGold + timeToGold
	local _exp = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.EXP)
	local _power = cityltCtrl.getPowerReward(bid, blv, true)
	_ENV = bid
	bid.exp = _exp
	local _ENV, bid.power, retReward = blv, _power, bid
	blv._retPreCond = retPreCond
	blv._retPreStar = retPreStar
	blv._retPreMagic = retPreMagic
	blv._buildStarQueueList = buildStarQueueList
	blv._buildQueueList = buildQueueList
	blv._retCostRes = retCostRes
	blv._retCostItems = retCostItems
	blv._retCostTools = retCostTools
	blv._costtime = costtime
	blv._resToGold = resToGold
	blv._toolToGold = toolToGold
	blv._immediatelyGold = immediatelyGold
	local blv._retReward, retdata = retReward, blv
	return errprecond, retdata
end
local getUpgradeStarCostReducePercent = function(bid, blv)
	local buffValue = 0
	local techAddPercent = technologyCtrl:getTechnologyPower(gTechnologyType.BRIGHT_STRENGTHEN_COST_REDUCE) or 0
	local techAddPercent2 = buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_COST_REDUCE, gBuffSource.KINGDOM_LEVEL) or 0
	techAddPercent2 = techAddPercent2 / 1000
	local heroAddPercent = buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_COST_REDUCE, gBuffSource.HERO_SYSTEM) or 0
	heroAddPercent = heroAddPercent / 1000
	local magicLampPercent = 0
	local permilVal = 0
	if bid == BUILDID.STAR_BRAVE_STATUE then
		if blv <= 160 then
			permilVal = permilVal + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_COST_REDUCE_LESS_160) or 0)
		elseif blv <= 215 then
			permilVal = permilVal + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_COST_REDUCE_LV_160_TO_215) or 0)
		end
		if blv <= 50 then
			permilVal = permilVal + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_COST_REDUCE_LESS_50) or 0)
		end
	else
		if blv <= 70 then
			permilVal = permilVal + (buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_COST_REDUCE_LESS_70) or 0)
		end
		if blv <= 54 then
			permilVal = permilVal + (buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_COST_REDUCE_LESS_54) or 0)
		end
	end
	buffValue = buffValue + permilVal / 1000
	buffValue = buffValue + techAddPercent + techAddPercent2 + heroAddPercent + magicLampPercent
	return buffValue
end
buildLogic.getUpgradeStarCostReducePercent = SoraDCacheByFrame(getUpgradeStarCostReducePercent)
function buildLogic.checkPreCondition(bid, blv)
	local precond = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.PRECOND)
	if precond then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _blv = precond[2 * i]
			local _curlv = cityCtrl:getBuildMaxLv(_bid)
			if _blv > _curlv then
				return false
			end
		end
	end
	return true
end
function buildLogic.checkFreeTimeCondition(bid, blv)
	local costTime = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.COSTTIME)
	return costTime and costTime <= buildLogic.getFreeSpeedUpTime(blv)
end
function buildLogic.checkToolCondition(bid, iid, blv)
	local cityltCtrl, retCostTools
	local costtools = cityltCtrl.buildLvInfo(bid, blv, "costTools")
	if costtools then
		for i = 1, #costtools / 2 do
			local _toolid = costtools[2 * i - 1]
			local _toolcount = costtools[2 * i]
			local _curcount = backpackCtrl:getItemCount(_toolid)
			if _toolcount > _curcount then
				return false
			end
		end
	end
	local cityltCtrl, retCostWEs = (for index), 1
	local costWEs = cityltCtrl.buildLvInfo(bid, blv, "costWEs")
	if costWEs then
		local costWesReduceRate = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE, gBuffSource.NEBULA_TOWER) or 0
		local activityRate = 1
		cityltCtrl = gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE
		gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE.bid = bid
		local gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE.iid, buildData = iid, gBuffEffect.UPGRADE_CASTLE_COST_WES_REDUCE
		if costWEs[1] == 301101 then
			activityRate = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_WAR_BADG_REDUCE, buildData)
		else
			activityRate = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_WAR_SENIOR_BADG_REDUCE, buildData)
		end
		costWesReduceRate = costWesReduceRate / 1000
		for i = 1, #costWEs / 2 do
			local _toolid = costWEs[2 * i - 1]
			local _toolcount = costWEs[2 * i]
			_toolcount = math.floor(_toolcount * (1 - costWesReduceRate) * activityRate)
			local _curcount = backpackCtrl:getItemCount(_toolid)
			if _toolcount > _curcount then
				return false
			end
		end
	end
	return true
end
function buildLogic.checkResCondition(bid, iid, blv)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local isLuckyBless = luckyBlessCtrl:getLuckyData().curEffectType == gLuckyBlessActivityEffectType.BUILD_UPGRADE
	local gametop, retCostRes = gLuckyBlessActivityEffectType.BUILD_UPGRADE, gLuckyBlessActivityEffectType.BUILD_UPGRADE
	local costres = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.COSTRES)
	if costres then
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		local costResReduceBuff = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE) or 0
		if blv <= 30 then
			local buffReduce30 = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_30) or 0
			costResReduceBuff = costResReduceBuff + buffReduce30
		end
		if blv <= 70 then
			local buffReduce70 = buffCtrl:getBuffEffect(gBuffEffect.UPGRADE_BUILD_COST_RES_REDUCE_LESS_Z4) or 0
			costResReduceBuff = costResReduceBuff + buffReduce70
		end
		local techReduceRate = technologyCtrl:getTechnologyPower(gTechnologyType.BUILD_COST_REDUCE) or 0
		local totalReduceRate = costResReduceBuff / 1000 + techReduceRate
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			local _curcount = cityCtrl:getResCount(_resid)
			if 0 < _rescount then
				if costResReduceBuff then
					_rescount = math.ceil(_rescount * (1 - totalReduceRate))
				end
				local _isLuckyReach = false
				local luckyRescount = _rescount
				if _curcount < _rescount then
					if isLuckyBless then
						luckyRescount = luckyBlessCtrl:getResult(luckyRescount)
					end
					gametop = luckyBlessCtrl:getResult(luckyRescount)
					luckyBlessCtrl:getResult(luckyRescount).bid = bid
					local luckyBlessCtrl:getResult(luckyRescount).iid, buildData = iid, luckyBlessCtrl:getResult(luckyRescount)
					local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, buildData)
					luckyRescount = math.ceil(luckyRescount * subPercent)
					_isLuckyReach = _curcount >= luckyRescount
					return false
				end
			end
		end
	end
	return true
end
function buildLogic.isShowUpgrade(bid, iid)
	local bid = tonumber(bid)
	local iid = tonumber(iid)
	local buildcell = cityCtrl:getBuildCell(bid, iid)
	if not buildcell then
		return false
	end
	if buildcell and buildcell.info and tonumber(buildcell.info.state) == BUILD_STATE.UPGRADEING then
		return true
	end
	local blv
	if buildcell then
		blv = tonumber(buildcell.info.lv) + 1
	else
		blv = cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV)
	end
	local idlebqueue, lefttime = buildLogic.getIdleBuildQueue()
	if not idlebqueue and not buildLogic.checkFreeTimeCondition(bid, blv) then
		return false
	end
	local curlv = blv
	local maxlv = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV)
	if curlv >= maxlv then
		return false
	end
	if not buildLogic.isBuildingUnlock(bid, iid) then
		return false
	end
	if bid == BUILDID.NEBULA_PALACE then
		return true
	end
	if not buildLogic.checkPreCondition(bid, blv) then
		return false
	end
	if not buildLogic.checkToolCondition(bid, iid, blv) then
		return false
	end
	if not buildLogic.checkResCondition(bid, iid, blv) then
		return false
	end
	return true
end
function buildLogic.isBuildingUnlock(bid, iid)
	local buildcell = cityCtrl:getBuildCell(bid, iid)
	local blv = cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV)
	if buildcell then
		blv = tonumber(buildcell.info.lv) + 1
	end
	local unlockLv = cityltCtrl.buildLvInfo(BUILDID.CASTLE, blv, BUILD_LVINFO.KINGDOMLV)
	return buildLogic.checkKingdomLevel(unlockLv)
end
function buildLogic.checkKingdomLevel(unlockLv)
	if "number" ~= type(unlockLv) then
		return false
	end
	if 0 ~= unlockLv then
		if not kingdomLevelDataModuleAPI:isOpen() then
			return false
		end
		if not kingdomLevelDataModuleAPI:isUnlock() then
			return false
		end
		local kingdomLevel = kingdomLevelDataModuleAPI:getKingdomLevel()
		if "number" ~= type(kingdomLevel) then
			return false
		end
		if unlockLv > kingdomLevel then
			return false
		end
	end
	return true
end
function buildLogic.isBuildingStarUnlock(bid, iid)
	if not commonCheck.BUILD_STAR then
		return
	end
	local buildcell = cityCtrl:getBuildCell(bid, iid)
	if not buildcell then
		return
	end
	local starLv = tonumber(buildcell.info.starLv) + 1
	starLv = math.min(starLv, cityltCtrl.buildAttr(BUILDID.CASTLE, BUILD_ATTR.MAXSTARLV))
	local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, starLv, BUILD_LVINFO.KINGDOMLV)
	return buildLogic.checkKingdomLevel(unlockLv)
end
function buildLogic.isCanDemolish(bid, iid)
	local bid = tonumber(bid)
	local iid = tonumber(iid)
	local err = gErrDef.Err_None
	local isdemolish = cityltCtrl.buildAttr(bid, BUILD_ATTR.ISDEMOLISH)
	if isdemolish == 0 then
		err = gErrDef.Err_BUILD_CANNOT_DEMOLISH
	end
	local bcell = cityCtrl:getBuildCell(bid, iid)
	if bcell and bcell.info and tonumber(bcell.info.state) ~= BUILD_STATE.NORMAL then
		err = gErrDef.Err_BUILDSTATE_NOT_NORMAL
	end
	local queueMastery = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
	if queueMastery and queueMastery.data.bid == bid then
		err = gErrDef.Err_BUILD_MASTERY_IS_UPGRADING
		_ENV = gQueueTypeDef.build_mastery
		return err, gQueueTypeDef.build_mastery
	end
	local lvupcosttime = buildLogic.getUpgradeTime(bid, iid, tonumber(bcell.info.lv), tonumber(bcell.info.starLv))
	local demolishTime = lvupcosttime * gConstValue.BUILD_DEMOLISH_TIME_COEFFICIENT
	demolishTime = math.max(1, demolishTime)
	local idlebqueue, lefttime = buildLogic.getIdleBuildQueue()
	if not idlebqueue then
		err = gErrDef.Err_QUEUE_BUSY
	elseif idlebqueue == gQueueTypeDef.charge_build_queue and demolishTime > lefttime then
		err = gErrDef.Err_CHARGE_QUEUE_TIME_NOT_REACH
	end
	_ENV = gErrDef
	gErrDef._demolishTime = demolishTime
	local gErrDef._idlebqueue, retdata = idlebqueue, gErrDef
	return err, retdata
end
function buildLogic.build(_index, _mode, data, _bid, _isReal)
	return buildLogic.upgrade(_index, _mode, data, true, _bid, _isReal)
end
function buildLogic.upgrade(_index, _mode, data, isbuild, _bid, _isReal)
	local _bid = tonumber(_bid)
	local _mode = tonumber(_mode)
	local _isPre = _isReal or false
	local err = gErrDef.Err_None
	local idlebqueue, lefttime = buildLogic.getIdleBuildQueue()
	cityCtrl = nil
	;(nil)[1] = idlebqueue
	;(nil)[2] = lefttime
	;(nil)[3] = _isPre
	dump(nil, "buildLogic.upgrade")
	if _isPre then
		if _mode == OPERATE_MODE.NORMAL or _mode == OPERATE_MODE.GOLD_REPLACE then
			if not idlebqueue then
				err = gErrDef.Err_QUEUE_BUSY
			elseif idlebqueue == gQueueTypeDef.charge_build_queue and lefttime < data._costtime then
				err = gErrDef.Err_CHARGE_QUEUE_TIME_NOT_REACH
			end
		end
		for k, v in pairs(data._retPreCond) do
			if v.isreach == false then
				err = gErrDef.Err_PRECOND_NOT_REACH
			end
		end
		if isbuild then
			local maxcount = cityltCtrl.buildAttr(_bid, BUILD_ATTR.BMAXCOUNT)
			local curcount = cityCtrl:getBuildCount(_bid)
			if maxcount <= curcount then
				err = gErrDef.Err_MAX_BUILD
			end
		end
		if _mode == OPERATE_MODE.NORMAL or _mode == OPERATE_MODE.FREE then
			for k, v in pairs(data._retCostRes) do
				if v.isreach == false and v.isLuckyReach == false then
					err = gErrDef.Err_RESOUCH_NOT_REACH
				end
			end
			for k, v in pairs(data._retCostTools) do
				if v.isreach == false then
					err = gErrDef.Err_TOOLS_NOT_REACH
				end
			end
			for k, v in pairs(data._retCostWEs) do
				if v.isreach == false then
					err = gErrDef.Err_TOOLS_NOT_REACH
				end
			end
		end
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		if _mode == OPERATE_MODE.GOLD_REPLACE then
			local owngold = lordInfoCtrl:getBaseInfo().gold
			if owngold < data._resToGold + data._toolToGold + data._WEToGold then
				err = gErrDef.Err_GOLD_NOT_REACH
			end
		end
		if _mode == OPERATE_MODE.IMMEDIATELY then
			local owngold = lordInfoCtrl:getBaseInfo().gold
			if owngold < data._immediatelyGold then
				err = gErrDef.Err_GOLD_NOT_REACH
			end
		end
		local freeTime = buildLogic.getFreeSpeedUpTime()
		if not isbuild then
			local bcell = cityCtrl:getBuildCellByIndex(_index)
			freeTime = buildLogic.getFreeSpeedUpTime(bcell.info.lv)
		end
		if _mode == OPERATE_MODE.FREE and freeTime < data._costtime then
			err = gErrDef.Err_QUEUE_FREE_TIME_NOT_REACH
		end
	end
	if err == gErrDef.Err_None and (not _isPre or isbuild) then
		local starttime = serviceFunctions.systemTime()
		local totaltime = data._costtime
		local lefttime = data._costtime
		local _ENV, eventdata = buildLogic.getFreeSpeedUpTime(bcell.info.lv), buildLogic.getFreeSpeedUpTime(bcell.info.lv)
		if isbuild then
			local iid = cityCtrl:createBuild(_index, _bid)
			local initlv = cityltCtrl.buildAttr(_bid, BUILD_ATTR.INITLV)
			_ENV, initlv = tostring(initlv), tostring(initlv)
			tostring(initlv).optype = tostring(BUILD_OPERATE_TYPE.BUILD)
			tostring(initlv).lv = initlv
			tostring(initlv).bid = tostring(_bid)
			tostring(initlv).iid = tostring(iid)
			tostring(initlv).costres = data._retCostRes
			tostring(initlv).costtool = data._retCostTools
			eventdata, tostring(initlv).ishelp = tostring(initlv), 0
		else
			local bcell = cityCtrl:getBuildCellByIndex(_index)
			local bid = bcell.info.bid
			local iid = bcell.info.iid
			local lv = bcell.info.lv
			cityCtrl:changeBuildState(_index, BUILD_STATE.UPGRADEING)
			_ENV = cityCtrl.changeBuildState
			cityCtrl.changeBuildState.optype = tostring(BUILD_OPERATE_TYPE.UPGRADE)
			cityCtrl.changeBuildState.lv = tostring(lv)
			cityCtrl.changeBuildState.bid = tostring(bid)
			cityCtrl.changeBuildState.iid = tostring(iid)
			cityCtrl.changeBuildState.costres = data._retCostRes
			cityCtrl.changeBuildState.costtool = data._retCostTools
			eventdata, cityCtrl.changeBuildState.ishelp = cityCtrl.changeBuildState, 0
		end
		if _mode == OPERATE_MODE.IMMEDIATELY or _mode == OPERATE_MODE.FREE then
			_ENV = OPERATE_MODE.FREE
			OPERATE_MODE.FREE.name = tostring(gQueueTypeDef.free_build_queue)
			local OPERATE_MODE.FREE.data, event = eventdata, OPERATE_MODE.FREE
			queueCtrl:dispatchEvent(event)
		else
			queueCtrl:addQueue(idlebqueue, starttime, totaltime, lefttime, eventdata)
			local queue = queueCtrl:queryQueue(idlebqueue)
			if queue then
				queue.ottime = totaltime
			end
		end
	end
	return err
end
function buildLogic.checkUpgradeStarCond(_mode, data)
	local _mode = tonumber(_mode)
	local err = gErrDef.Err_None
	if data._buildQueueList and next(data._buildQueueList) then
		err = gErrDef.Err_QUEUE_BUSY
	end
	if (_mode == OPERATE_MODE.NORMAL or _mode == OPERATE_MODE.GOLD_REPLACE) and data._buildStarQueueList and next(data._buildStarQueueList) and (#data._buildStarQueueList == 2 or not _G.SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(_G.gExaltedPrivilegeType.EXTRA_STAR_UPGRADE_QUEUENUM)) then
		err = gErrDef.Err_QUEUE_BUSY
	end
	for k, v in pairs(data._retPreCond) do
		if v.isreach == false then
			err = gErrDef.Err_PRECOND_NOT_REACH
		end
	end
	for k, v in pairs(data._retPreStar) do
		if v.isreach == false then
			err = gErrDef.Err_PER_STAR_NOT_REACH
		end
	end
	if _mode == OPERATE_MODE.NORMAL then
		for k, v in pairs(data._retCostRes) do
			if v.isreach == false then
				err = gErrDef.Err_RESOUCH_NOT_REACH
			end
		end
	end
	for k, v in pairs(data._retCostItems) do
		if v.isreach == false then
			err = gErrDef.Err_TOOLS_NOT_REACH
		end
	end
	if _mode == OPERATE_MODE.GOLD_REPLACE and not SoraDEnoughGold(data._resToGold) then
		err = gErrDef.Err_GOLD_NOT_REACH
	end
	if _mode == OPERATE_MODE.IMMEDIATELY and not SoraDEnoughGold(data._immediatelyGold) then
		err = gErrDef.Err_GOLD_NOT_REACH
	end
	return err
end
function buildLogic.upgradeStar(_index, _mode, data, _bid, _queueType, _isPre)
	local _bid = tonumber(_bid)
	local _mode = tonumber(_mode)
	local _queueType = tonumber(_queueType)
	local err = not _isPre and gErrDef.Err_None or buildLogic.checkUpgradeStarCond(_mode, data)
	print("buildLogic.upgradeStar err,_isPre=====", err, _isPre, _queueType)
	if err == gErrDef.Err_None and not _isPre then
		local starttime = serviceFunctions.systemTime()
		local totaltime = data._costtime
		local lefttime = data._costtime
		local _ENV, eventdata = _isPre, _isPre
		local bcell = cityCtrl:getBuildCellByIndex(_index)
		local bid = bcell.info.bid
		local iid = bcell.info.iid
		local lv = bcell.info.lv
		cityCtrl:changeBuildStarState(_index, BUILD_STAR_STATE.UPGRADEING)
		_ENV = cityCtrl.changeBuildStarState
		cityCtrl.changeBuildStarState.optype = tostring(BUILD_OPERATE_TYPE.UPGRADE_STAR)
		cityCtrl.changeBuildStarState.lv = tostring(lv)
		cityCtrl.changeBuildStarState.bid = tostring(bid)
		cityCtrl.changeBuildStarState.iid = tostring(iid)
		cityCtrl.changeBuildStarState.costres = data._retCostRes
		cityCtrl.changeBuildStarState.costtool = data._retCostItems
		eventdata, cityCtrl.changeBuildStarState.ishelp = cityCtrl.changeBuildStarState, 0
		if _mode == OPERATE_MODE.IMMEDIATELY or _mode == OPERATE_MODE.FREE then
			_ENV = OPERATE_MODE.FREE
			OPERATE_MODE.FREE.name = tostring(_queueType)
			local OPERATE_MODE.FREE.data, event = eventdata, OPERATE_MODE.FREE
			queueCtrl:dispatchEvent(event)
		else
			queueCtrl:addQueue(_queueType, starttime, totaltime, lefttime, eventdata)
			local queue = queueCtrl:queryQueue(_queueType)
			if queue then
				queue.ottime = totaltime
			end
		end
	end
	return err
end
function buildLogic.demolishBuild(index, data)
	local bcell = cityCtrl:getBuildCellByIndex(index)
	local bid = bcell.info.bid
	local iid = bcell.info.iid
	cityCtrl:changeBuildState(index, BUILD_STATE.DEMOLISHING)
	local starttime = serviceFunctions.systemTime()
	local totaltime = data._demolishTime
	local lefttime = data._demolishTime
	cityCtrl = nil
	;(nil).optype = tostring(BUILD_OPERATE_TYPE.DEMOLISH)
	;(nil).bid = tostring(bid)
	;(nil).iid = tostring(iid)
	queueCtrl:addQueue(data._idlebqueue, starttime, totaltime, lefttime, nil)
end
function buildLogic.getIdleBuildQueue()
	local freequeue = queueCtrl:queryQueue(gQueueTypeDef.free_build_queue)
	local chargequeue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
	if not freequeue then
		return gQueueTypeDef.free_build_queue, 0
	elseif not chargequeue then
		local buildchargequeue = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue)
		if buildchargequeue then
			local timerNode = buildchargequeue.timerNode
			if timerNode then
				return gQueueTypeDef.charge_build_queue, timerNode.timer:getRemainTime()
			end
		end
	end
end
function buildLogic.getCurBuildQueue()
	local queueCtrl, ret
	local freequeue = queueCtrl:queryQueue(gQueueTypeDef.free_build_queue)
	if freequeue then
		table.insert(ret, freequeue)
	end
	local chargequeue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
	if chargequeue then
		table.insert(ret, chargequeue)
	end
	return ret
end
function buildLogic.getQueueType(bid, iid)
	local bid = tonumber(bid)
	local iid = tonumber(iid)
	local curbqueue = buildLogic.getCurBuildQueue()
	for i, v in ipairs(curbqueue) do
		if v.data and bid == tonumber(v.data.bid) and iid == tonumber(v.data.iid) then
			return tonumber(v.qtype)
		end
	end
	return nil
end
function buildLogic.getArmorForgingSpeedAdd(armorId)
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local bcell = cityCtrl:getBuildCellByIndex(1205)
	local starlv = tonumber(bcell.info.starLv)
	local buildSpeedAdd = 0
	if 0 < starlv then
		buildSpeedAdd = cityltCtrl.buildLvInfo(BUILDID.STAR_BRAVE_STATUE, starlv, "trainspeed", true)
		buildSpeedAdd = buildSpeedAdd / 1000
	end
	local armorForgingTimeReduce = technologyCtrl:getTechnologyPower(armorSystemRead:getProperty(armorId, "timeTechnology")) or 0
	local cfg = armorSystemRead:getArmorRefSoldierInfo(armorId)
	if cfg.newLv == 14 then
		armorForgingTimeReduce = technologyCtrl:getTechnologyPower(armorSystemRead:getProperty(armorId, "crystalTimeTechnology")) or 0
	end
	local speedAdd = (1 - armorForgingTimeReduce) / (1 + buildSpeedAdd)
	print("buildLogic.getArmorForgingSpeedAdd", speedAdd, armorForgingTimeReduce, buildSpeedAdd)
	return speedAdd
end
function buildLogic.getArmorMaxForgNum()
	local bcell = cityCtrl:getBuildCellByIndex(1205)
	local starlv = tonumber(bcell.info.starLv)
	local buildForgNum = 0
	if 0 < starlv then
		buildForgNum = cityltCtrl.buildLvInfo(BUILDID.STAR_BRAVE_STATUE, starlv, "capacity", true)
	end
	local armorForgAddNum = technologyCtrl:getTechnologyPower(gTechnologyType.ARMOR_FORIGIN_NUM_ADD) or 0
	buildForgNum = armorForgAddNum + buildForgNum
	print("buildLogic.getArmorMaxForgNum", armorForgAddNum, buildForgNum)
	return buildForgNum
end
function buildLogic.getFreeStrongTime()
	local rettime = 0
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local bufAdd = buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_FREE_TIME)
	if bufAdd then
		rettime = rettime + bufAdd
	end
	return rettime
end
function buildLogic.getFreeSpeedUpTime(blv)
	blv = tonumber(blv)
	local rettime = gConstValue.BUILD_FREE_SPEEDUP_TIME
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local bufAdd, buffList = buffCtrl:getBuffEffectWithList(gBuffEffect.INSTANT_BUILD_SPEED_BOOST)
	if bufAdd then
		rettime = rettime + bufAdd
		for _, buff in pairs(buffList) do
			if buff.source == gBuffSource.VIP then
				rettime = rettime - gConstValue.BUILD_FREE_SPEEDUP_TIME
			end
		end
	end
	local bufAdd_lv29 = 0
	if blv and blv <= 29 then
		bufAdd_lv29 = buffCtrl:getBuffEffect(gBuffEffect.LEV_29_INSTANT_BUILD_SPEED_BOOST, gBuffSource.PRINCE_GIFT_ACTIVITY) or 0
		bufAdd_lv29 = bufAdd_lv29 + buffCtrl:getBuffEffect(gBuffEffect.LEV_29_INSTANT_BUILD_SPEED_BOOST, gBuffSource.PRINCE_GIFT_NEW)
		rettime = rettime + bufAdd_lv29
	end
	return rettime
end
function buildLogic.getTrainCountAndSpeedAdd()
	local totaltraincount = 0
	local totalspeedadd = 0
	local buildlist = cityCtrl:getBuildList()
	for k, bcell in pairs(buildlist) do
		local bid = tonumber(bcell.info.bid)
		if BUILDID.MILITARY_TENT == bid then
			local traincount = buildLogic.getBuildBaseValue(bid, "capacity", bcell)
			local speedadd = buildLogic.getBuildBaseValue(bid, "trainspeed", bcell) / 1000
			totaltraincount = totaltraincount + traincount
			totalspeedadd = totalspeedadd + speedadd
		end
	end
	return totaltraincount, totalspeedadd
end
function buildLogic.getUpgradeTime(bid, iid, blv, starlv)
	local basetime = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.COSTTIME)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local addValue, buffList = buffCtrl:getBuffEffectWithList(gBuffEffect.BUILD_REDUCE_TIME)
	if type(addValue) == "number" then
		for _, buff in pairs(buffList) do
			if buff.source == gBuffSource.RECHARGE_WEEK_CARD then
				local curCastleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
				if curCastleLevel < 16 then
					addValue = basetime
				end
			end
		end
	end
	addValue = addValue or 0
	basetime = math.max(0, basetime - addValue)
	local addPercent = buildLogic.getUpgradeTimeAddPercent(bid, blv, starlv)
	cityltCtrl = starlv
	starlv.bid = bid
	starlv.iid = iid
	local subPercent = buildLogic.getActivityBuff(gBuffEffect.BUILD_SPEED_BOOST_FOR_POW, starlv)
	local ret = math.floor(basetime * (1 / (1 + addPercent)) * subPercent)
	return ret
end
function buildLogic.getUpgradeTimeAddPercent(bid, blv, starlv)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local skill_add = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ACCELERATE_CONSTRUCTION)
	local technologyAdd = technologyCtrl:getTechnologyPower(gTechnologyType.CONSTRUCTION_SPEED)
	local allianceAdd = allianceScience:getScienceAddValue(gAScienceType.BUILDING_UPGRADE_SPEED)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.BUILD_SPEED_BOOST) or 0
	if blv and blv <= 30 then
		local buffValue30 = buffCtrl:getBuffEffect(gBuffEffect.CONSTRUCTION_SPEED_30) or 0
		buffValue = buffValue + buffValue30
	end
	local buffReduce = buffCtrl:getBuffEffect(gBuffEffect.BUILD_SPEED_REDUCE) or 0
	if buffReduce and 0 < buffReduce then
		buffValue = buffValue - buffReduce
	end
	if blv and blv <= 70 then
		local buffValue70 = buffCtrl:getBuffEffect(gBuffEffect.CONSTRUCTION_SPEED_Z4) or 0
		buffValue = buffValue + buffValue70
	end
	if blv and blv <= 120 then
		local buffValue120 = buffCtrl:getBuffEffect(gBuffEffect.CONSTRUCTION_SPEED_120) or 0
		buffValue = buffValue + buffValue120
	end
	if starlv and starlv <= 70 then
		local buffStarValue70 = buffCtrl:getBuffEffect(gBuffEffect.BUILD_SPEED_BOOST_LESS_STARLV_70) or 0
		buffValue = buffValue + buffStarValue70
	end
	local attrPlus = attributeSystem.query(gAttributeEnum.BUILD_SPEED_UP_RATE) or 0
	attrPlus = attrPlus / 10
	buffValue = buffValue + attrPlus
	buffValue = buffValue and buffValue / 1000 or 0
	local ret = skill_add + technologyAdd + allianceAdd + buffValue
	return ret
end
function buildLogic.getUpgradeStarTime(bid, iid, blv)
	local basetime = cityltCtrl.buildStarLvInfo(bid, blv, BUILD_LVINFO.COSTTIME)
	local addPercent = buildLogic.getUpgradeStarTimeAddPercent(bid, blv)
	if blv <= 70 and bid ~= BUILDID.STAR_BRAVE_STATUE then
		addPercent = addPercent + (buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_TIME_REDUCE_LESS_70) or 0) / 1000
	elseif blv <= 160 and bid == BUILDID.STAR_BRAVE_STATUE then
		addPercent = addPercent + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_TIME_REDUCE_LESS_160) or 0) / 1000
	elseif 160 < blv and blv <= 215 and bid == BUILDID.STAR_BRAVE_STATUE then
		addPercent = addPercent + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_TIME_REDUCE_LV_160_TO_215) or 0) / 1000
	end
	local gSCRL100Rate = 0
	if bid == BUILDID.STAR_BRAVE_STATUE and blv <= 100 then
		gSCRL100Rate = buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_TIME_REDUCE_LESS_100) or 0
	end
	local subPercent = 1
	cityltCtrl = buffCtrl
	buffCtrl.bid = bid
	local buffCtrl.iid, buildData = iid, buffCtrl
	if bid == BUILDID.STAR_BRAVE_STATUE then
		subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST_STATUE, buildData)
	else
		subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_BUILD_SPEED_BOOST, buildData)
	end
	local ret = math.floor(basetime * (1 / (1 + addPercent)) * subPercent * (1 - gSCRL100Rate / 1000))
	return ret
end
local getUpgradeStarTimeAddPercent = function()
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.BRIGHT_STRENGTHEN_TIME_REDUCE) or 0
	buffValue = buffValue / 1000
	local techAddPercent = technologyCtrl:getTechnologyPower(gTechnologyType.BRIGHT_STRENGTHEN_TIME_REDUCE) or 0
	buffValue = buffValue + techAddPercent
	return buffValue
end
buildLogic.getUpgradeStarTimeAddPercent = SoraDCacheByFrame(getUpgradeStarTimeAddPercent)
function buildLogic.getHostpitalTotalCapacity()
	local totalCapacity = 0
	local buildlist = cityCtrl:getBuildList()
	for k, bcell in pairs(buildlist) do
		local bid = tonumber(bcell.info.bid)
		if BUILDID.HOSTPITAL == bid then
			totalCapacity = totalCapacity + buildLogic.getBuildBaseValue(bid, "capacity", bcell)
		end
	end
	return totalCapacity
end
function buildLogic.buildLvIsFull(bid, iid)
	bid = tonumber(bid)
	iid = tonumber(iid)
	local bcell = cityCtrl:getBuildCell(bid, iid)
	if bcell then
		local curlv = tonumber(bcell.info.lv)
		local maxlv = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV)
		if curlv >= maxlv then
			return true
		end
	end
end
function buildLogic.buildStarLvIsFull(bid, iid)
	bid = tonumber(bid)
	iid = tonumber(iid)
	local bcell = cityCtrl:getBuildCell(bid, iid)
	if bcell then
		local curlv = tonumber(bcell.info.starLv)
		local maxlv = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)
		if bid == BUILDID.STAR_BRAVE_STATUE then
			local addMaxStarLv = cityltCtrl.buildAttr(bid, BUILD_ATTR.ADDMAXSTARLV)
			local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
			local ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.GLORIOUS_STATUE_LEVEL_MAX, maxlv)
			ret = math.min(ret, addMaxStarLv)
			maxlv = math.max(maxlv, ret)
		end
		if curlv >= maxlv then
			return true
		end
	end
end
function buildLogic.getWarehouseProtectCount()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local skill_add = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.STOREHOUSE)
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.WAREHOUSE_PROTECTION)
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_PROTECT_BOOST)
	if buffValue then
		buffValue = buffValue / 1000
	else
		buffValue = 0
	end
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_PROTECT_REDUCE)
	if deBuffValue then
		deBuffValue = deBuffValue / 1000
	else
		deBuffValue = 0
	end
	local gametop, ret = buffCtrl, buffCtrl
	local bcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
	if bcell then
		local base = buildLogic.getBuildBaseValue(BUILDID.DEPOT, "capacity", bcell)
		for i = 1, #base / 2 do
			local resid = base[2 * i - 1]
			local rescount = base[2 * i]
			local buff_add = math.floor((rescount + skill_add + tech_add) * (buffValue - deBuffValue))
			local totaladd = skill_add + tech_add + buff_add
			ret[tostring(resid)], gametop = resid, resid
			ret[tostring(resid)].base = rescount
			ret[tostring(resid)].add = totaladd
		end
	end
	return ret
end
function buildLogic.getAllianceHelpCountAndDescTime()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local gametop, ret = gametop.playertop_, gametop.playertop_
	local bid = BUILDID.EMBASSY
	local bcell = cityCtrl:getBuildCell(bid, 0)
	if bcell then
		local totalhelp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell)
		local basetime = buildLogic.getBuildBaseValue(bid, "reduceTime", bcell)
		local ascienceadd = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_HELP_DESC_TIME)
		local add = basetime * ascienceadd
		gametop, ret.totalHp = gAScienceType.ALLIANCE_HELP_DESC_TIME, totalhelp
		gAScienceType.ALLIANCE_HELP_DESC_TIME.total = add + basetime
		gAScienceType.ALLIANCE_HELP_DESC_TIME.base = basetime
		ret.reduceTime, gAScienceType.ALLIANCE_HELP_DESC_TIME.add = gAScienceType.ALLIANCE_HELP_DESC_TIME, add
	else
		gametop, ret.totalHp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 2
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).total = 30
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).base = 30
		ret.reduceTime, buildLogic.getBuildBaseValue(bid, "helpCount", bcell).add = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 0
	end
	return ret
end
local _ENV, ret_getResOutputHour = function()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local gametop, ret = gametop.playertop_, gametop.playertop_
	local bid = BUILDID.EMBASSY
	local bcell = cityCtrl:getBuildCell(bid, 0)
	if bcell then
		local totalhelp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell)
		local basetime = buildLogic.getBuildBaseValue(bid, "reduceTime", bcell)
		local ascienceadd = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_HELP_DESC_TIME)
		local add = basetime * ascienceadd
		gametop, ret.totalHp = gAScienceType.ALLIANCE_HELP_DESC_TIME, totalhelp
		gAScienceType.ALLIANCE_HELP_DESC_TIME.total = add + basetime
		gAScienceType.ALLIANCE_HELP_DESC_TIME.base = basetime
		ret.reduceTime, gAScienceType.ALLIANCE_HELP_DESC_TIME.add = gAScienceType.ALLIANCE_HELP_DESC_TIME, add
	else
		gametop, ret.totalHp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 2
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).total = 30
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).base = 30
		ret.reduceTime, buildLogic.getBuildBaseValue(bid, "helpCount", bcell).add = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 0
	end
	return ret
end, function()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local gametop, ret = gametop.playertop_, gametop.playertop_
	local bid = BUILDID.EMBASSY
	local bcell = cityCtrl:getBuildCell(bid, 0)
	if bcell then
		local totalhelp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell)
		local basetime = buildLogic.getBuildBaseValue(bid, "reduceTime", bcell)
		local ascienceadd = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_HELP_DESC_TIME)
		local add = basetime * ascienceadd
		gametop, ret.totalHp = gAScienceType.ALLIANCE_HELP_DESC_TIME, totalhelp
		gAScienceType.ALLIANCE_HELP_DESC_TIME.total = add + basetime
		gAScienceType.ALLIANCE_HELP_DESC_TIME.base = basetime
		ret.reduceTime, gAScienceType.ALLIANCE_HELP_DESC_TIME.add = gAScienceType.ALLIANCE_HELP_DESC_TIME, add
	else
		gametop, ret.totalHp = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 2
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).total = 30
		buildLogic.getBuildBaseValue(bid, "helpCount", bcell).base = 30
		ret.reduceTime, buildLogic.getBuildBaseValue(bid, "helpCount", bcell).add = buildLogic.getBuildBaseValue(bid, "helpCount", bcell), 0
	end
	return ret
end
local _ENV, bid2ResID = getUpgradeStarTimeAddPercent, getUpgradeStarTimeAddPercent
bid2ResID[BUILDID.FARM] = gIDDef.FOOD
bid2ResID[BUILDID.SAWMILL] = gIDDef.WOOD
bid2ResID[BUILDID.IRON_MINE] = gIDDef.IRON
bid2ResID[BUILDID.STEEL] = gIDDef.MITHRIL
bid2ResID[BUILDID.CRYSTAL_MINE] = gIDDef.CRYSTAL
local _ENV, bid2EffectID = BUILDID.CRYSTAL_MINE, BUILDID.CRYSTAL_MINE
bid2EffectID[BUILDID.FARM] = gBuffEffect.FOOD_ITEM_ADD_EFFECT
bid2EffectID[BUILDID.SAWMILL] = gBuffEffect.WOOD_ITEM_ADD_EFFECT
bid2EffectID[BUILDID.IRON_MINE] = gBuffEffect.IRON_ITEM_ADD_EFFECT
bid2EffectID[BUILDID.STEEL] = gBuffEffect.MITHRIL_ITEM_ADD_EFFECT
local _ENV, attrFilter_getResOutputHour = BUILDID.STEEL, BUILDID.STEEL
local getResOutputHour = function(bid, blv, iid)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local resCalculate = cityCtrl.resCalculate
	local bcell = cityCtrl:getBuildCell(bid, iid)
	local baseoutput = buildLogic.getBuildBaseValue(bid, "output", bcell)
	local add_skill = resCalculate:getSkillAdd(bid)
	local skill_count = math.floor(baseoutput * add_skill)
	local equipadd = resCalculate:getEquipAdd(bid)
	local equipcount = math.floor(baseoutput * equipadd)
	local petadd = resCalculate:getPetAdd()
	local petcount = math.floor(baseoutput * petadd)
	local acieveadd = resCalculate:getAchieveAdd()
	local achievecount = math.floor(baseoutput * acieveadd)
	local add_technology = resCalculate:getTechnologyAdd(bid)
	local add_alliancesci = resCalculate:getAllianceSciAdd(bid)
	local tech_count = math.floor(baseoutput * (add_technology + add_alliancesci))
	tech_count = tech_count + equipcount + achievecount
	local add_vip = resCalculate:getVipAdd(bid)
	local vip_count = math.floor(baseoutput * add_vip)
	local add_guardian = resCalculate:getGuardianAdd(bid)
	local guardian_count = math.floor(baseoutput * add_guardian)
	local add_nebulaTower = resCalculate:getNebulaTowerAdd(bid)
	local nebulaTower_count = math.floor(baseoutput * add_nebulaTower)
	local add_official = resCalculate:getOfficialAdd()
	local desc_official = resCalculate:getOfficialDec()
	local official = add_official - desc_official
	local official_count = math.floor(baseoutput * official)
	skill_count = skill_count + official_count
	local activity_add = resCalculate:getActivityAdd()
	local activity_count = math.floor(baseoutput * activity_add)
	local conquestwar_add = resCalculate:getConquestWarAdd()
	local conquestwar_count = math.floor(baseoutput * conquestwar_add)
	local buff_week_add = resCalculate:getResCalculateAdd(bid, gBuffSource.RECHARGE_WEEK_CARD) or 0
	buff_week_add = buff_week_add / 1000
	local buff_week_count = math.floor(baseoutput * buff_week_add)
	local wargem_add = resCalculate:getWarGemAdd(bid)
	local wargem_count = math.floor(baseoutput * wargem_add)
	local hero_add = resCalculate:getHeroAdd(bid)
	local hero_add_count = math.floor(baseoutput * hero_add)
	local skill_add_self = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.SKILL)
	if skill_add_self then
		skill_add_self = skill_add_self / 1000
	else
		skill_add_self = 0
	end
	local skill_add_self_count = math.floor(baseoutput * skill_add_self)
	local nebulaTower_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.NEBULA_TOWER)
	if nebulaTower_add then
		nebulaTower_add = nebulaTower_add / 1000
	else
		nebulaTower_add = 0
	end
	local nebulaTower_add_count = math.floor(baseoutput * nebulaTower_add)
	local kingdomLevelAdd = resCalculate:getKingdomLevelAdd()
	if kingdomLevelAdd then
		kingdomLevelAdd = kingdomLevelAdd / 1000
	else
		kingdomLevelAdd = 0
	end
	local kingdomLevel_count = math.floor(baseoutput * kingdomLevelAdd)
	local miraculousWeaponAdd = resCalculate:getMiraculousWeaponAdd()
	if miraculousWeaponAdd then
		miraculousWeaponAdd = miraculousWeaponAdd / 1000
	else
		miraculousWeaponAdd = 0
	end
	local miraculous_weapon_count = math.floor(baseoutput * miraculousWeaponAdd)
	local magicLampAdd = resCalculate:getMagicLampAdd()
	if magicLampAdd then
		magicLampAdd = magicLampAdd / 1000
	else
		magicLampAdd = 0
	end
	local magiclamp_count = math.floor(baseoutput * magicLampAdd)
	local legendLordAdd = resCalculate:getLegendLordAdd(bid)
	if legendLordAdd then
		legendLordAdd = legendLordAdd / 1000
	else
		legendLordAdd = 0
	end
	local legendLord_count = math.floor(baseoutput * legendLordAdd)
	local hegemonLordAdd = resCalculate:getHegemonLordAdd(bid)
	if hegemonLordAdd then
		hegemonLordAdd = hegemonLordAdd / 1000
	else
		hegemonLordAdd = 0
	end
	local hegemonLord_count = math.floor(baseoutput * hegemonLordAdd)
	local add_alliance_pet = resCalculate:getResCalculateAdd(bid, gBuffSource.ABEAST_BLESSING) or 0
	add_alliance_pet = add_alliance_pet / 1000
	local alliance_pet_count = math.floor(baseoutput * add_alliance_pet)
	local add_mastery = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_MASTERY) or 0
	add_mastery = add_mastery / 1000
	local mastery_count = math.floor(baseoutput * add_mastery)
	local add_halloween = resCalculate:getResCalculateAdd(bid, gBuffSource.HALLOWEEN) or 0
	add_halloween = add_halloween / 1000
	local halloween_count = math.floor(baseoutput * add_halloween)
	activity_count = activity_count + kingdomLevel_count + conquestwar_count + legendLord_count + hegemonLord_count + mastery_count + halloween_count
	local add_star = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_STAR) or 0
	add_star = add_star / 1000
	local star_count = math.floor(baseoutput * add_star)
	activity_count = activity_count + star_count
	local add_heroAppoint = resCalculate:getResCalculateAdd(bid, gBuffSource.HERO_APPOINT) or 0
	add_heroAppoint = add_heroAppoint / 1000
	local heroAppoint_count = math.floor(baseoutput * add_heroAppoint)
	attrFilter_getResOutputHour.resourceID = bid2ResID[bid]
	attrFilter_getResOutputHour[gFilterType.RESOURCE] = nil
	local add_newAttr = 0
	local attrValue = attributeSystem.query(gAttributeEnum.BUILD_RES_OUTPUT_RATE, attrFilter_getResOutputHour)
	if attrValue ~= 0 then
		attrValue = attrValue / 10000
		add_newAttr = math.floor(baseoutput * attrValue)
	end
	local totaladd = skill_count + tech_count + vip_count + guardian_count + nebulaTower_count + activity_count + petcount + buff_week_count + skill_add_self_count + nebulaTower_add_count + wargem_count + hero_add_count + miraculous_weapon_count + magiclamp_count + alliance_pet_count + heroAppoint_count + add_newAttr
	local total = baseoutput + totaladd
	local add_tool = resCalculate:getToolAdd(bid, iid)
	local build_count = math.floor(total * add_tool)
	if 0 < add_tool then
		local effect = bid2EffectID[bid]
		if effect then
			local reduceBuildMastery = buffCtrl:getBuffEffect(effect)
			if reduceBuildMastery and 0 < reduceBuildMastery then
				reduceBuildMastery = reduceBuildMastery / 1000
				build_count = math.floor(total * (add_tool + reduceBuildMastery))
				add_tool = add_tool + reduceBuildMastery
			end
		end
	end
	total = build_count + total
	ret_getResOutputHour.baseoutput = baseoutput
	ret_getResOutputHour.skill_count = skill_count
	ret_getResOutputHour.tech_count = tech_count
	ret_getResOutputHour.vip_count = vip_count
	ret_getResOutputHour.guardian_count = guardian_count
	ret_getResOutputHour.activity_count = activity_count
	ret_getResOutputHour.conquestwar_count = conquestwar_count
	ret_getResOutputHour.pet_count = petcount
	ret_getResOutputHour.totaladd = totaladd
	ret_getResOutputHour.build_count = build_count
	ret_getResOutputHour.add_tool = 1 + add_tool
	ret_getResOutputHour.wargem_count = wargem_count
	ret_getResOutputHour.hero_add_count = hero_add_count
	ret_getResOutputHour.miraculous_weapon_count = miraculous_weapon_count
	ret_getResOutputHour.magiclamp_count = magiclamp_count
	ret_getResOutputHour.alliance_pet_count = alliance_pet_count
	ret_getResOutputHour.heroAppoint_count = heroAppoint_count
	ret_getResOutputHour.total = total
	return ret_getResOutputHour
end
buildLogic.getResOutputHour = SoraDCacheByFrame(getResOutputHour)
function buildLogic.getCrystalGatherSpeed(base)
	local total = base
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local hInfo = heroCtrl:getHeroInfoByID(1724)
	if hInfo then
		local buffValue = heroCtrl:getBuffValue(hInfo, gSkillActiveType.PASSIVE_SKILL, gBuffEffect.CRYSTAL_GATHER_SPEED_BOOST)
		total = total + buffValue
	end
	local buff_nebulatower_value = buffCtrl:getBuffEffect(gBuffEffect.CRYSTAL_GATHER_SPEED_BOOST, gBuffSource.NEBULA_TOWER) or 0
	total = total + buff_nebulatower_value
	return total / 1000
end
function buildLogic.getResOutputHourAddPercent(bid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local resCalculate = cityCtrl.resCalculate
	local gametop, tbAdd = "cityCtrl", "cityCtrl"
	local add_skill = resCalculate:getSkillAdd(bid)
	local equipadd = resCalculate:getEquipAdd(bid)
	local acieveadd = resCalculate:getAchieveAdd()
	local add_technology = resCalculate:getTechnologyAdd(bid)
	local add_alliancesci = resCalculate:getAllianceSciAdd(bid)
	local add_vip = resCalculate:getVipAdd(bid)
	local add_Guardian = resCalculate:getGuardianAdd(bid)
	local add_nebulaTower = resCalculate:getNebulaTowerAdd(bid)
	local activity_add = resCalculate:getActivityAdd()
	local add_official = resCalculate:getOfficialAdd()
	local desc_official = resCalculate:getOfficialDec()
	local conquestwar_add = resCalculate:getConquestWarAdd()
	local pet_add = resCalculate:getPetAdd()
	local buff_week_add = resCalculate:getResCalculateAdd(bid, gBuffSource.RECHARGE_WEEK_CARD) or 0
	buff_week_add = buff_week_add / 1000
	local wargem_add = resCalculate:getWarGemAdd(bid)
	local hero_add = resCalculate:getHeroAdd(bid)
	local skill_add_self = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.SKILL)
	if skill_add_self then
		skill_add_self = skill_add_self / 1000
	else
		skill_add_self = 0
	end
	local nebulaTower_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.NEBULA_TOWER)
	if nebulaTower_add then
		nebulaTower_add = nebulaTower_add / 1000
	else
		nebulaTower_add = 0
	end
	local suit_add_mithril = buffCtrl:getBuffEffect(gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST, gBuffSource.EQUIPMENT)
	if suit_add_mithril and bid == BUILDID.STEEL then
		suit_add_mithril = suit_add_mithril / 1000
	else
		suit_add_mithril = 0
	end
	local kigndomLevelAdd = resCalculate:getKingdomLevelAdd() or 0
	kigndomLevelAdd = kigndomLevelAdd / 1000
	local legendTitleAdd = resCalculate:getLegendLordAdd(bid) or 0
	legendTitleAdd = legendTitleAdd / 1000
	local add_alliance_pet = resCalculate:getResCalculateAdd(bid, gBuffSource.ABEAST_BLESSING) or 0
	add_alliance_pet = add_alliance_pet / 1000
	local add_halloween = resCalculate:getResCalculateAdd(bid, gBuffSource.HALLOWEEN) or 0
	add_halloween = add_halloween / 1000
	local add_heroAppoint = buffCtrl:getBuffEffect(resCalculate:getHeroAppointAdd(bid), gBuffSource.HERO_APPOINT)
	add_heroAppoint = add_heroAppoint / 1000
	tbAdd["领主技能加成百分比"] = add_skill
	tbAdd["装备属性加成百分比"] = equipadd
	tbAdd["成就加成百分比"] = acieveadd
	tbAdd["学院科技加成百分比"] = add_technology
	tbAdd["联盟科技加成百分比"] = add_alliancesci
	tbAdd["vip加成百分比"] = add_vip
	tbAdd["守护者加成百分比"] = add_Guardian
	tbAdd["星云塔加成百分比"] = add_nebulaTower
	tbAdd["城堡资源田丰收活动加成百分比"] = activity_add
	tbAdd["官职增加百分比"] = add_official
	tbAdd["官职减少加成百分比"] = desc_official
	tbAdd["征服战加成百分比"] = conquestwar_add
	tbAdd["宠物加成加成百分比"] = pet_add
	tbAdd["周卡加成加成百分比"] = buff_week_add
	tbAdd["战争宝石加成加成百分比"] = wargem_add
	tbAdd["领主主动技能加成百分比"] = skill_add_self
	tbAdd["星云塔加成百分比"] = nebulaTower_add
	tbAdd["王国等级加成加成百分比"] = kigndomLevelAdd
	tbAdd["传奇头衔加成百分比"] = legendTitleAdd
	tbAdd["联盟神兽加成"] = add_alliance_pet
	tbAdd["万圣节buff道具加成"] = add_halloween
	tbAdd["套装属性加成百分比"] = suit_add_mithril
	tbAdd["英雄建筑任命加成百分比"] = add_heroAppoint
	local hegemonTitleAdd = resCalculate:getHegemonLordAdd(bid) or 0
	hegemonTitleAdd = hegemonTitleAdd / 1000
	local add_miraculous_weapon = resCalculate:getResCalculateAdd(bid, gBuffSource.MIRACULOUS_WEAPON) or 0
	add_miraculous_weapon = add_miraculous_weapon / 1000
	local add_mastery = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_MASTERY) or 0
	gametop, add_mastery = resCalculate, add_mastery / 1000
	local resCalculate.resourceID, attrFilter = bid2ResID[bid], resCalculate
	local attrValue = attributeSystem.query(gAttributeEnum.BUILD_RES_OUTPUT_RATE, attrFilter)
	if attrValue ~= 0 then
		attrValue = attrValue / 10000
	end
	local add_star = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_STAR) or 0
	add_star = add_star / 1000
	local ret = legendTitleAdd + hegemonTitleAdd + kigndomLevelAdd + add_skill + equipadd + acieveadd + add_technology + add_alliancesci + add_vip + add_Guardian + add_nebulaTower + add_official - desc_official + activity_add + conquestwar_add + pet_add + buff_week_add + wargem_add + skill_add_self + nebulaTower_add + hero_add + add_miraculous_weapon + add_mastery + suit_add_mithril + add_alliance_pet + attrValue + add_halloween + add_star + add_heroAppoint
	return ret, tbAdd
end
local _ENV, ret_getResOututMaxCount = function(bid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local resCalculate = cityCtrl.resCalculate
	local gametop, tbAdd = "cityCtrl", "cityCtrl"
	local add_skill = resCalculate:getSkillAdd(bid)
	local equipadd = resCalculate:getEquipAdd(bid)
	local acieveadd = resCalculate:getAchieveAdd()
	local add_technology = resCalculate:getTechnologyAdd(bid)
	local add_alliancesci = resCalculate:getAllianceSciAdd(bid)
	local add_vip = resCalculate:getVipAdd(bid)
	local add_Guardian = resCalculate:getGuardianAdd(bid)
	local add_nebulaTower = resCalculate:getNebulaTowerAdd(bid)
	local activity_add = resCalculate:getActivityAdd()
	local add_official = resCalculate:getOfficialAdd()
	local desc_official = resCalculate:getOfficialDec()
	local conquestwar_add = resCalculate:getConquestWarAdd()
	local pet_add = resCalculate:getPetAdd()
	local buff_week_add = resCalculate:getResCalculateAdd(bid, gBuffSource.RECHARGE_WEEK_CARD) or 0
	buff_week_add = buff_week_add / 1000
	local wargem_add = resCalculate:getWarGemAdd(bid)
	local hero_add = resCalculate:getHeroAdd(bid)
	local skill_add_self = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.SKILL)
	if skill_add_self then
		skill_add_self = skill_add_self / 1000
	else
		skill_add_self = 0
	end
	local nebulaTower_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.NEBULA_TOWER)
	if nebulaTower_add then
		nebulaTower_add = nebulaTower_add / 1000
	else
		nebulaTower_add = 0
	end
	local suit_add_mithril = buffCtrl:getBuffEffect(gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST, gBuffSource.EQUIPMENT)
	if suit_add_mithril and bid == BUILDID.STEEL then
		suit_add_mithril = suit_add_mithril / 1000
	else
		suit_add_mithril = 0
	end
	local kigndomLevelAdd = resCalculate:getKingdomLevelAdd() or 0
	kigndomLevelAdd = kigndomLevelAdd / 1000
	local legendTitleAdd = resCalculate:getLegendLordAdd(bid) or 0
	legendTitleAdd = legendTitleAdd / 1000
	local add_alliance_pet = resCalculate:getResCalculateAdd(bid, gBuffSource.ABEAST_BLESSING) or 0
	add_alliance_pet = add_alliance_pet / 1000
	local add_halloween = resCalculate:getResCalculateAdd(bid, gBuffSource.HALLOWEEN) or 0
	add_halloween = add_halloween / 1000
	local add_heroAppoint = buffCtrl:getBuffEffect(resCalculate:getHeroAppointAdd(bid), gBuffSource.HERO_APPOINT)
	add_heroAppoint = add_heroAppoint / 1000
	tbAdd["领主技能加成百分比"] = add_skill
	tbAdd["装备属性加成百分比"] = equipadd
	tbAdd["成就加成百分比"] = acieveadd
	tbAdd["学院科技加成百分比"] = add_technology
	tbAdd["联盟科技加成百分比"] = add_alliancesci
	tbAdd["vip加成百分比"] = add_vip
	tbAdd["守护者加成百分比"] = add_Guardian
	tbAdd["星云塔加成百分比"] = add_nebulaTower
	tbAdd["城堡资源田丰收活动加成百分比"] = activity_add
	tbAdd["官职增加百分比"] = add_official
	tbAdd["官职减少加成百分比"] = desc_official
	tbAdd["征服战加成百分比"] = conquestwar_add
	tbAdd["宠物加成加成百分比"] = pet_add
	tbAdd["周卡加成加成百分比"] = buff_week_add
	tbAdd["战争宝石加成加成百分比"] = wargem_add
	tbAdd["领主主动技能加成百分比"] = skill_add_self
	tbAdd["星云塔加成百分比"] = nebulaTower_add
	tbAdd["王国等级加成加成百分比"] = kigndomLevelAdd
	tbAdd["传奇头衔加成百分比"] = legendTitleAdd
	tbAdd["联盟神兽加成"] = add_alliance_pet
	tbAdd["万圣节buff道具加成"] = add_halloween
	tbAdd["套装属性加成百分比"] = suit_add_mithril
	tbAdd["英雄建筑任命加成百分比"] = add_heroAppoint
	local hegemonTitleAdd = resCalculate:getHegemonLordAdd(bid) or 0
	hegemonTitleAdd = hegemonTitleAdd / 1000
	local add_miraculous_weapon = resCalculate:getResCalculateAdd(bid, gBuffSource.MIRACULOUS_WEAPON) or 0
	add_miraculous_weapon = add_miraculous_weapon / 1000
	local add_mastery = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_MASTERY) or 0
	gametop, add_mastery = resCalculate, add_mastery / 1000
	local resCalculate.resourceID, attrFilter = bid2ResID[bid], resCalculate
	local attrValue = attributeSystem.query(gAttributeEnum.BUILD_RES_OUTPUT_RATE, attrFilter)
	if attrValue ~= 0 then
		attrValue = attrValue / 10000
	end
	local add_star = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_STAR) or 0
	add_star = add_star / 1000
	local ret = legendTitleAdd + hegemonTitleAdd + kigndomLevelAdd + add_skill + equipadd + acieveadd + add_technology + add_alliancesci + add_vip + add_Guardian + add_nebulaTower + add_official - desc_official + activity_add + conquestwar_add + pet_add + buff_week_add + wargem_add + skill_add_self + nebulaTower_add + hero_add + add_miraculous_weapon + add_mastery + suit_add_mithril + add_alliance_pet + attrValue + add_halloween + add_star + add_heroAppoint
	return ret, tbAdd
end, function(bid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local resCalculate = cityCtrl.resCalculate
	local gametop, tbAdd = "cityCtrl", "cityCtrl"
	local add_skill = resCalculate:getSkillAdd(bid)
	local equipadd = resCalculate:getEquipAdd(bid)
	local acieveadd = resCalculate:getAchieveAdd()
	local add_technology = resCalculate:getTechnologyAdd(bid)
	local add_alliancesci = resCalculate:getAllianceSciAdd(bid)
	local add_vip = resCalculate:getVipAdd(bid)
	local add_Guardian = resCalculate:getGuardianAdd(bid)
	local add_nebulaTower = resCalculate:getNebulaTowerAdd(bid)
	local activity_add = resCalculate:getActivityAdd()
	local add_official = resCalculate:getOfficialAdd()
	local desc_official = resCalculate:getOfficialDec()
	local conquestwar_add = resCalculate:getConquestWarAdd()
	local pet_add = resCalculate:getPetAdd()
	local buff_week_add = resCalculate:getResCalculateAdd(bid, gBuffSource.RECHARGE_WEEK_CARD) or 0
	buff_week_add = buff_week_add / 1000
	local wargem_add = resCalculate:getWarGemAdd(bid)
	local hero_add = resCalculate:getHeroAdd(bid)
	local skill_add_self = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.SKILL)
	if skill_add_self then
		skill_add_self = skill_add_self / 1000
	else
		skill_add_self = 0
	end
	local nebulaTower_add = buffCtrl:getBuffEffect(gBuffEffect.RESOURCE_OUTPUT_BOOST, gBuffSource.NEBULA_TOWER)
	if nebulaTower_add then
		nebulaTower_add = nebulaTower_add / 1000
	else
		nebulaTower_add = 0
	end
	local suit_add_mithril = buffCtrl:getBuffEffect(gBuffEffect.ALL_MITHRIL_OUTPUT_BOOST, gBuffSource.EQUIPMENT)
	if suit_add_mithril and bid == BUILDID.STEEL then
		suit_add_mithril = suit_add_mithril / 1000
	else
		suit_add_mithril = 0
	end
	local kigndomLevelAdd = resCalculate:getKingdomLevelAdd() or 0
	kigndomLevelAdd = kigndomLevelAdd / 1000
	local legendTitleAdd = resCalculate:getLegendLordAdd(bid) or 0
	legendTitleAdd = legendTitleAdd / 1000
	local add_alliance_pet = resCalculate:getResCalculateAdd(bid, gBuffSource.ABEAST_BLESSING) or 0
	add_alliance_pet = add_alliance_pet / 1000
	local add_halloween = resCalculate:getResCalculateAdd(bid, gBuffSource.HALLOWEEN) or 0
	add_halloween = add_halloween / 1000
	local add_heroAppoint = buffCtrl:getBuffEffect(resCalculate:getHeroAppointAdd(bid), gBuffSource.HERO_APPOINT)
	add_heroAppoint = add_heroAppoint / 1000
	tbAdd["领主技能加成百分比"] = add_skill
	tbAdd["装备属性加成百分比"] = equipadd
	tbAdd["成就加成百分比"] = acieveadd
	tbAdd["学院科技加成百分比"] = add_technology
	tbAdd["联盟科技加成百分比"] = add_alliancesci
	tbAdd["vip加成百分比"] = add_vip
	tbAdd["守护者加成百分比"] = add_Guardian
	tbAdd["星云塔加成百分比"] = add_nebulaTower
	tbAdd["城堡资源田丰收活动加成百分比"] = activity_add
	tbAdd["官职增加百分比"] = add_official
	tbAdd["官职减少加成百分比"] = desc_official
	tbAdd["征服战加成百分比"] = conquestwar_add
	tbAdd["宠物加成加成百分比"] = pet_add
	tbAdd["周卡加成加成百分比"] = buff_week_add
	tbAdd["战争宝石加成加成百分比"] = wargem_add
	tbAdd["领主主动技能加成百分比"] = skill_add_self
	tbAdd["星云塔加成百分比"] = nebulaTower_add
	tbAdd["王国等级加成加成百分比"] = kigndomLevelAdd
	tbAdd["传奇头衔加成百分比"] = legendTitleAdd
	tbAdd["联盟神兽加成"] = add_alliance_pet
	tbAdd["万圣节buff道具加成"] = add_halloween
	tbAdd["套装属性加成百分比"] = suit_add_mithril
	tbAdd["英雄建筑任命加成百分比"] = add_heroAppoint
	local hegemonTitleAdd = resCalculate:getHegemonLordAdd(bid) or 0
	hegemonTitleAdd = hegemonTitleAdd / 1000
	local add_miraculous_weapon = resCalculate:getResCalculateAdd(bid, gBuffSource.MIRACULOUS_WEAPON) or 0
	add_miraculous_weapon = add_miraculous_weapon / 1000
	local add_mastery = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_MASTERY) or 0
	gametop, add_mastery = resCalculate, add_mastery / 1000
	local resCalculate.resourceID, attrFilter = bid2ResID[bid], resCalculate
	local attrValue = attributeSystem.query(gAttributeEnum.BUILD_RES_OUTPUT_RATE, attrFilter)
	if attrValue ~= 0 then
		attrValue = attrValue / 10000
	end
	local add_star = resCalculate:getResCalculateAdd(bid, gBuffSource.BUILD_STAR) or 0
	add_star = add_star / 1000
	local ret = legendTitleAdd + hegemonTitleAdd + kigndomLevelAdd + add_skill + equipadd + acieveadd + add_technology + add_alliancesci + add_vip + add_Guardian + add_nebulaTower + add_official - desc_official + activity_add + conquestwar_add + pet_add + buff_week_add + wargem_add + skill_add_self + nebulaTower_add + hero_add + add_miraculous_weapon + add_mastery + suit_add_mithril + add_alliance_pet + attrValue + add_halloween + add_star + add_heroAppoint
	return ret, tbAdd
end
local getResOututMaxCount = function(bid, blv, iid)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local bcell = cityCtrl:getBuildCell(bid, iid)
	local basecapacity = buildLogic.getBuildBaseValue(bid, "capacity", bcell)
	local totaladd = buildLogic.getResOutputHour(bid, blv, iid).totaladd * 10
	ret_getResOututMaxCount.base = basecapacity
	ret_getResOututMaxCount.add = totaladd
	ret_getResOututMaxCount.total = basecapacity + totaladd
	return ret_getResOututMaxCount
end
buildLogic.getResOututMaxCount = SoraDCacheByFrame(getResOututMaxCount)
function buildLogic.judgeIsResBuild(bid)
	if buildLogic.getResID(bid) then
		return true
	end
end
function buildLogic.getResID(bid)
	if bid == BUILDID.FARM then
		return gIDDef.FOOD
	elseif bid == BUILDID.SAWMILL then
		return gIDDef.WOOD
	elseif bid == BUILDID.IRON_MINE then
		return gIDDef.IRON
	elseif bid == BUILDID.STEEL then
		return gIDDef.MITHRIL
	elseif bid == BUILDID.CRYSTAL_MINE then
		return gIDDef.CRYSTAL
	end
end
function buildLogic.getBuildID(resid)
	if resid == gIDDef.FOOD then
		return BUILDID.FARM
	elseif resid == gIDDef.WOOD then
		return BUILDID.SAWMILL
	elseif resid == gIDDef.IRON then
		return BUILDID.IRON_MINE
	elseif resid == gIDDef.MITHRIL then
		return BUILDID.STEEL
	elseif resid == gIDDef.CRYSTAL then
		return BUILDID.CRYSTAL_MINE
	end
end
function buildLogic.getHallofwarCapacity()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local mapBuffCtrl = SoraDGetCtrl("mapBuffCtrl")
	gametop = "mapBuffCtrl"
	;("mapBuffCtrl").base = 0
	;("mapBuffCtrl").add = 0
	local ("mapBuffCtrl").total, ret = 0, "mapBuffCtrl"
	local bcell = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	if bcell then
		local blv = tonumber(bcell.info.lv)
		local base = buildLogic.getBuildBaseValue(BUILDID.HALL_OF_WAR, "capacity", bcell)
		local worldMapWarDef = include("worldMapWarDef")
		local alliance_sci_add = worldMapWarDef.getHallOfWarArmyCount()
		local buff_add_value = buffCtrl:getBuffEffect(gBuffEffect.CLUMP_NUM_BOOST) or 0
		local attrAdd = mapBuffCtrl:getBuffEffect(gAttributeEnum.HALLOFWAR_ARMY_UP_RANGE)
		buff_add_value = buff_add_value + attrAdd
		local wartech_add = technologyCtrl:getTechnologyPower(gTechnologyType.WARHALL_CAPACITY_VALUE_BOOST)
		local gametop, battlefieldType = kingdomMapCtrl, kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
		local kingdomMapCtrl.battleField, attrFilter = battlefieldType, kingdomMapCtrl
		local gametop, attrAdd = gAttributeEnum.ASSEMBLY_TROOP_COUNT_NUM, attributeSystem.query(gAttributeEnum.ASSEMBLY_TROOP_COUNT_NUM, attrFilter) or 0
		local gAttributeEnum.ASSEMBLY_TROOP_COUNT_NUM.battleField, attrFilter = battlefieldType, gAttributeEnum.ASSEMBLY_TROOP_COUNT_NUM
		local attrAddPerc = attributeSystem.query(gAttributeEnum.HALLOFWAR_ARMY_UP_PERCENT, attrFilter) or 0
		attrAddPerc = attrAddPerc / 10000
		local hallbuff_add_percent = buffCtrl:getBuffEffect(gBuffEffect.HALLOFWAR_ARMY_UP_PERCENT)
		if hallbuff_add_percent then
			hallbuff_add_percent = hallbuff_add_percent / 1000
		else
			hallbuff_add_percent = 0
		end
		local group_buff_add = buffCtrl:getBuffEffect(gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT) or 0
		group_buff_add = group_buff_add / 1000
		local buff_total_add_percent = hallbuff_add_percent + group_buff_add + attrAddPerc
		local add = alliance_sci_add + buff_add_value + wartech_add + attrAdd
		local total = math.floor((base + add) * (1 + buff_total_add_percent))
		local finaladd = math.floor(add + (base + add) * buff_total_add_percent)
		gametop = add + (base + add) * buff_total_add_percent
		;(add + (base + add) * buff_total_add_percent).base = base
		;(add + (base + add) * buff_total_add_percent).add = finaladd
		;(add + (base + add) * buff_total_add_percent).total = total
		ret, (add + (base + add) * buff_total_add_percent).addpercent = add + (base + add) * buff_total_add_percent, buff_total_add_percent
		print("buildLogic.getHallofwarCapacity base,add,total", base, "@1", add, "@2", total, "@3", buff_total_add_percent)
	end
	return ret
end
function buildLogic.getExpArmyCount(moveLineType)
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local base = 0
	local bcell = cityCtrl:getBuildCell(BUILDID.DRILL_GROUDS, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.DRILL_GROUDS, "capacity", bcell)
	end
	local default = gConstValue.DEFAULT_EXP_ARMY_COUNT
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.SINGLE_TROOP_STRENGTH)
	local techGroupAdd = 0
	techGroupAdd = techGroupAdd + technologyCtrl:getTechnologyPower(gTechnologyType.CONQUEST_WAR_SINGLE_TROOP_STRENGTH)
	techGroupAdd = techGroupAdd + technologyCtrl:getTechnologyPower(gTechnologyType.PYRAMID_SINGLE_TROOP_STRENGTH)
	techGroupAdd = techGroupAdd + technologyCtrl:getTechnologyPower(gTechnologyType.LEGEND_SINGLE_TROOP_STRENGTH)
	local buff_value_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST, nil, true) or 0
	local attrAdd = attributeSystem.query(gAttributeEnum.DISPATCH_TROOP_COUNT_NUM) or 0
	local hero_add = heroCtrl:getTheActiveBuff(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
	local total_add = default + tech_add + buff_value_add + attrAdd + hero_add
	local buff_percent_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST) or 0
	buff_percent_add = buff_percent_add / 1000
	local meteriteMagicAdd = 0
	local meteriteMagicAddPercent = 0
	if moveLineType and (moveLineType == gMapMoveLineServerType.moveLineTypeMass or moveLineType == gMapMoveLineServerType.moveLineTypeOccupyMass) then
		meteriteMagicAdd = buffCtrl:getBuffEffect(gBuffEffect.MASS_MARCH_VALUE_LIMIT_BOOST, nil, true) or 0
		meteriteMagicAddPercent = (buffCtrl:getBuffEffect(gBuffEffect.MASS_MARCH_LIMIT_BOOST, nil, true) or 0) / 1000
		total_add = total_add + meteriteMagicAdd
		buff_percent_add = buff_percent_add + meteriteMagicAddPercent
	end
	local buff_add = math.floor((base + total_add) * (buff_percent_add + techGroupAdd))
	print("buff_add===xxx===", buff_add, base, total_add, buff_percent_add)
	local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.ACHIEVEMENT) or 0
	achieveadd = achieveadd / 1000
	local unchangesize = math.floor((base + total_add) * (1 + achieveadd + techGroupAdd))
	gametop, total_add = (base + total_add) * (1 + achieveadd + techGroupAdd), total_add + buff_add
	;(base + total_add) * (1 + achieveadd + techGroupAdd).base = base
	;(base + total_add) * (1 + achieveadd + techGroupAdd).add = total_add
	;(base + total_add) * (1 + achieveadd + techGroupAdd).total = base + total_add
	local (base + total_add) * (1 + achieveadd + techGroupAdd).unchangesize, ret = unchangesize, (base + total_add) * (1 + achieveadd + techGroupAdd)
	if buffCtrl.virtualBuff then
		ret.total = buffCtrl.virtualBuff.marchMaxCount
	end
	return ret
end
function buildLogic.getArenaExpArmyCount()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local base = 0
	local bcell = cityCtrl:getBuildCell(BUILDID.DRILL_GROUDS, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.DRILL_GROUDS, "capacity", bcell)
	end
	local default = gConstValue.DEFAULT_EXP_ARMY_COUNT
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.SINGLE_TROOP_STRENGTH, nil, true)
	local techGroupAdd = 0
	print("buildLogic.getExpArmyCount()", tech_add, techGroupAdd)
	local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.ACHIEVEMENT) or 0
	local vip_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.VIP) or 0
	local _buff_value_add, buffList = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST, nil, true)
	local buff_value_add = _buff_value_add or 0
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local heroDressAdd = heroCtrl:getTheActiveBuff(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
	local nebula_tower_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST, gBuffSource.NEBULA_TOWER) or 0
	buff_value_add = buff_value_add - nebula_tower_add
	local attrValue = attributeSystem.query(gAttributeEnum.DISPATCH_TROOP_COUNT_NUM) or 0
	local total_add = default + tech_add + buff_value_add + heroDressAdd + attrValue
	local buff_add = math.floor((base + total_add) * ((achieveadd + vip_add) / 1000))
	local godarmsadd = 0
	total_add = total_add + godarmsadd + buff_add
	local unchangesize = math.floor((base + total_add) * (1 + achieveadd / 1000))
	gametop = (base + total_add) * (1 + achieveadd / 1000)
	;(base + total_add) * (1 + achieveadd / 1000).base = base
	;(base + total_add) * (1 + achieveadd / 1000).add = total_add
	;(base + total_add) * (1 + achieveadd / 1000).total = base + total_add
	local (base + total_add) * (1 + achieveadd / 1000).unchangesize, ret = unchangesize, (base + total_add) * (1 + achieveadd / 1000)
	if buffCtrl.virtualBuff then
		ret.total = buffCtrl.virtualBuff.marchMaxCount
	end
	gametop = buffCtrl.virtualBuff.marchMaxCount
	buffCtrl.virtualBuff.marchMaxCount.base = base
	buffCtrl.virtualBuff.marchMaxCount.default = default
	buffCtrl.virtualBuff.marchMaxCount.tech_add = tech_add
	buffCtrl.virtualBuff.marchMaxCount.achieveadd = achieveadd
	buffCtrl.virtualBuff.marchMaxCount.vip_add = vip_add
	buffCtrl.virtualBuff.marchMaxCount.buff_value_add = buff_value_add
	buffCtrl.virtualBuff.marchMaxCount.nebula_tower_add = nebula_tower_add
	buffCtrl.virtualBuff.marchMaxCount.attrValue = attrValue
	buffCtrl.virtualBuff.marchMaxCount.buff_add = buff_add
	local buffCtrl.virtualBuff.marchMaxCount.total_add, logtb = total_add, buffCtrl.virtualBuff.marchMaxCount
	dump(logtb, "getArenaExpArmyCount logtb=================")
	return ret, logtb, buffList
end
function buildLogic.getExpQueueCount()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local base = gConstValue.DEFAULT_EXP_ARMY_QUEUE
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local vip_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_TROOP_TOTAL_BOOST, gBuffSource.VIP) or 0
	local skill_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_TROOP_TOTAL_BOOST, gBuffSource.ATLANTIS_SKILL) or 0
	local isNewPlayer = buffCtrl:isNewPlayerBuffOpen()
	local newbieAdd = isNewPlayer and 1 or 0
	local newStartAdd = buffCtrl:getBuffEffect(gBuffEffect.MARCH_TROOP_TOTAL_BOOST, gBuffSource.NEW_START_BUFF) or 0
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.EXPEDITION_TROOPS) or 0
	local roaringFlame_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_TROOP_TOTAL_BOOST, gBuffSource.ROARING_FLAME_WAR) or 0
	local total_add = tech_add + vip_add + newbieAdd + skill_add + newStartAdd + roaringFlame_add
	gametop = gBuffEffect.MARCH_TROOP_TOTAL_BOOST
	gBuffEffect.MARCH_TROOP_TOTAL_BOOST.base = base
	gBuffEffect.MARCH_TROOP_TOTAL_BOOST.total_add = total_add
	gBuffEffect.MARCH_TROOP_TOTAL_BOOST.total = base + total_add
	gBuffEffect.MARCH_TROOP_TOTAL_BOOST.vip_add = vip_add
	gBuffEffect.MARCH_TROOP_TOTAL_BOOST.tech_add = tech_add
	local gBuffEffect.MARCH_TROOP_TOTAL_BOOST.newbieAdd, ret = newbieAdd, gBuffEffect.MARCH_TROOP_TOTAL_BOOST
	return ret
end
function buildLogic.getEmbassyReinforcements()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local base = 0
	local add = 0
	local bcell = cityCtrl:getBuildCell(BUILDID.EMBASSY, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.EMBASSY, "reinforcements", bcell)
		local worldMapWarDef = include("worldMapWarDef")
		local alliance_add = worldMapWarDef.getEmbassyReinforcements()
		if IsArClient then
			local pet_add = buffCtrl:getBuffEffect(gBuffEffect.REINFORCEMENTS_MAX_COUNT, gBuffSource.PET) or 0
			local achievement_percent = buffCtrl:getBuffEffect(gBuffEffect.REINFORCEMENTS_MAX_COUNT, gBuffSource.ACHIEVEMENT) or 0
			local achievement_add = math.floor(base * achievement_percent / 1000)
			local gametop, battlefieldType = kingdomMapCtrl, kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
			local kingdomMapCtrl.battleField, attrFilter = battlefieldType, kingdomMapCtrl
			local attrAdd = attributeSystem.query(gAttributeEnum.REINFORCEMENT_CAPACITY_NUM, attrFilter) or 0
			add = pet_add + alliance_add + achievement_add + attrAdd
		else
			local buff_add_value = buffCtrl:getBuffEffect(gBuffEffect.REINFORCEMENTS_MAX_COUNT) or 0
			add = buff_add_value + alliance_add
			local gametop, battlefieldType = kingdomMapCtrl, kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
			local kingdomMapCtrl.battleField, attrFilter = battlefieldType, kingdomMapCtrl
			local attrAdd = attributeSystem.query(gAttributeEnum.REINFORCEMENT_CAPACITY_NUM, attrFilter) or 0
			add = add + attrAdd
			local buff_add_percent = buffCtrl:getBuffEffect(gBuffEffect.REINFORCEMENTS_COUNT_ADD) or 0
			buff_add_percent = buff_add_percent / 1000
			add = math.floor((base + add) * (1 + buff_add_percent)) - base
		end
	end
	gametop = worldMapWarDef
	include("worldMapWarDef").base = base
	include("worldMapWarDef").add = add
	local include("worldMapWarDef").total, ret = base + add, include("worldMapWarDef")
	return ret
end
function buildLogic.getWallsDef()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local base, add = 0, 0
	local bcell = cityCtrl:getBuildCell(BUILDID.WALLS, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.WALLS, "defValue", bcell)
		add = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD)
	end
	gametop = technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD)
	technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD).base = base
	technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD).add = add
	local technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD).total, ret = base + add, technologyCtrl:getTechnologyPower(gTechnologyType.DEFENSE_ADD)
	return ret
end
function buildLogic.getMarketWeight()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local base, add = 0, 0
	local bcell = cityCtrl:getBuildCell(BUILDID.MARKET, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.MARKET, "capacity", bcell)
		local alliance_add = allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT)
		add = math.floor(base * alliance_add)
	end
	gametop = alliance_add
	allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT).base = base
	allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT).add = add
	local allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT).total, ret = base + add, allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT)
	return ret
end
function buildLogic.getMarketRate()
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local base, add = 0, 0
	local bcell = cityCtrl:getBuildCell(BUILDID.MARKET, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.MARKET, "taxRate", bcell)
		local allianceadd = allianceScience:getScienceAddValue(gAScienceType.TRADING_TAX_RATE_DESC)
		add = allianceadd * base
		base = base / 1000
		add = add / 1000
	end
	gametop = allianceadd
	allianceScience:getScienceAddValue(gAScienceType.TRADING_TAX_RATE_DESC).base = base
	allianceScience:getScienceAddValue(gAScienceType.TRADING_TAX_RATE_DESC).add = add
	local allianceScience:getScienceAddValue(gAScienceType.TRADING_TAX_RATE_DESC).total, ret = base + add, allianceScience:getScienceAddValue(gAScienceType.TRADING_TAX_RATE_DESC)
	return ret
end
function buildLogic.getHeroJailCapacity()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local base, add = 0, 0
	local bcell = cityCtrl:getBuildCell(BUILDID.HERO_PRISON, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.HERO_PRISON, "prisonnum", bcell)
		local techAdd = technologyCtrl:getTechnologyPower(gTechnologyType.IMPRISON_HERO_COUNT_ADD) or 0
		add = techAdd
	end
	gametop = techAdd
	;(0).base = base
	;(0).add = add
	local (0).total, ret = base + add, 0
	return ret
end
function buildLogic.getHeroJailReduceSpeedTime()
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local base, add = 0, 0
	local bcell = cityCtrl:getBuildCell(BUILDID.HERO_PRISON, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.HERO_PRISON, "speedtime", bcell)
		local techAdd = technologyCtrl:getTechnologyPower(gTechnologyType.EXECUTE_HERO_WAITING_TIME_REDUCE) or 0
		local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.EXECUTE_WAITING_TIME) or 0
		add = techAdd + achieveadd
	end
	gametop = techAdd
	;(0).base = base
	;(0).add = add
	local (0).total, ret = base + add, 0
	return ret
end
function buildLogic.getHeroJailAddAttack(...)
	local base = 0
	local bcell = cityCtrl:getBuildCell(BUILDID.HERO_PRISON, 0)
	if bcell then
		base = buildLogic.getBuildBaseValue(BUILDID.HERO_PRISON, "heronum", bcell)
	end
	return base
end
function buildLogic.getTurretAtk(buildCell)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local base, add = 0, 0
	base = buildLogic.getBuildBaseValue(BUILDID.TURRET, "atkAdd", buildCell)
	local lordSkillAdd = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.TOWER_ATTACK)
	gametop, add = lordInfoCtrl, lordSkillAdd * base
	lordInfoCtrl.base = base
	lordInfoCtrl.add = add
	local lordInfoCtrl.total, ret = base + add, lordInfoCtrl
	return ret
end
function buildLogic.getTurretSpeed(buildCell)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local base, add = 0, 0
	base = buildLogic.getBuildBaseValue(BUILDID.TURRET, "atkSpeedAdd", buildCell)
	local lordSkillAdd = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.TOWER_ATTACK_SPEED)
	add = lordSkillAdd * 1000
	gametop, base = lordInfoCtrl, base / 1000
	lordInfoCtrl.base = base
	lordInfoCtrl.add = add
	local lordInfoCtrl.total, ret = base + add, lordInfoCtrl
	return ret
end
function buildLogic.getLongHarvestTime()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	_UPVALUE4_ = gametop.playertop_
	gametop.playertop_[1] = gIDDef.FOOD
	gametop.playertop_[2] = gIDDef.WOOD
	gametop.playertop_[3] = gIDDef.IRON
	local gametop.playertop_[4], resType = gIDDef.MITHRIL, gametop.playertop_
	local maxTime = 0
	for _, v in ipairs(resType) do
		local bid = buildLogic.getBuildID(v)
		local bCellList = cityCtrl:getBuildCellList(bid)
		if bCellList then
			for key, val in pairs(bCellList) do
				local bid = tonumber(val.info.bid)
				local lv = tonumber(val.info.lv)
				local iid = tonumber(val.info.iid)
				local buildData = buildLogic.getResOutputHour(bid, lv, iid)
				local perTotal = buildLogic.getResOututMaxCount(bid, lv, iid).total
				local needTime = math.floor((perTotal - val.info.curres) / (buildData.total / 3600))
				maxTime = maxTime < needTime and needTime or maxTime
			end
		end
	end
	return maxTime
end
function buildLogic.isUpgrade(bid, iid)
	local ret = true
	local errprecond, retdata = buildLogic.isCanUpgrade(bid, iid)
	if errprecond then
		local idlebqueue, lefttime = buildLogic.getIdleBuildQueue()
		if not idlebqueue then
			ret = false
		else
			for k, v in pairs(retdata._retCostRes) do
				if v.isreach == false then
					ret = false
				end
			end
			for k, v in pairs(retdata._retCostTools) do
				if v.isreach == false then
					ret = false
				end
			end
			for k, v in pairs(retdata._retCostWEs) do
				if v.isreach == false then
					ret = false
				end
			end
		end
	else
		ret = false
	end
	local bcell = cityCtrl:getBuildCell(bid, iid)
	if bcell and bcell.info and tonumber(bcell.info.state) == BUILD_STATE.UPGRADEING then
		ret = true
	end
	return ret
end
function buildLogic.isBuildWarLv(lv)
	lv = tonumber(lv)
	local wlv = buildLogic.transformBuildLvToWarLv(lv)
	if -1 == wlv then
		return false
	end
	return true, wlv, buildLogic.getBuildWLProgress(lv)
end
function buildLogic.transformBuildLvToWarLv(lv)
	lv = tonumber(lv)
	local buildMaxLv = 30
	if lv < buildMaxLv then
		return -1
	end
	local wlv = math.floor((lv - buildMaxLv) / 10)
	return wlv
end
function buildLogic.getBuildLvStr(lv)
	local warLv = buildLogic.transformBuildLvToWarLv(lv)
	if 0 < warLv then
		buildLogic = nil
		;(nil).lv = warLv
		return i18n("common_text_1948", nil)
	else
		return math.min(lv, CASTLE_MAXLV_NOWAR)
	end
end
function buildLogic.isBuildIDWarLv(bid, lv)
	if not cityltCtrl.isOpenWL(bid) then
		return false
	end
	return buildLogic.isBuildWarLv(lv)
end
function buildLogic.getBuildWLProgress(lv)
	local buildMaxLv = 30
	local progress = 0
	local wlv = buildLogic.transformBuildLvToWarLv(lv)
	if -1 == wlv then
		return progress
	end
	progress = (lv - buildMaxLv) % 10 / 10
	return progress
end
function buildLogic.isOwnBuild(bid)
	local buildList = cityCtrl:getBuildList()
	local isOwn = false
	for k, v in pairs(buildList) do
		if tonumber(v.info.bid) == bid then
			isOwn = true
			break
		end
	end
	return isOwn
end
function buildLogic.isOwnBuildedBuilding(bid)
	local buildList = cityCtrl:getBuildList()
	local isOwn = false
	for k, v in pairs(buildList) do
		if tonumber(v.info.bid) == bid and v.info.state ~= BUILD_STATE.BUILDING then
			isOwn = true
			break
		end
	end
	return isOwn
end
function buildLogic.getBuildStateByBid(bid)
	local buildList = cityCtrl:getBuildList()
	local buildRead = include("buildDescribeRead")
	local state = BUILD_STATE.NORMAL
	for k, v in pairs(buildList) do
		if tonumber(v.info.bid) == bid then
			state = tonumber(v.info.state)
			if state == BUILD_STATE.NORMAL then
				local queueType = buildRead.getQueueType(bid)
				if queueType then
					local queue = queueCtrl:queryQueue(queueType)
					if queue and queue.timerNode.timer:getRemainTime() > 0 then
						if bid == BUILDID.HOSTPITAL then
							state = BUILD_STATE.TREATING
							break
						end
						if bid == BUILDID.CHARIOT_PLANT then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.STABLES then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.RANGE then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.BARRACKS then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.FORTRESS then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.COLLEGE then
							state = BUILD_STATE.STUDYING
							break
						end
						if bid == BUILDID.ELITE_PALACE then
							state = BUILD_STATE.TRAINING
							break
						end
						if bid == BUILDID.MIRACLE then
							state = BUILD_STATE.STUDYING
						end
					end
				end
			end
			break
		end
	end
	return state
end
function buildLogic.getOutBuildIsResBuild(bid)
	local isResBuild = false
	if bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
		isResBuild = true
	end
	return isResBuild
end
function buildLogic.builderIsLeisure(button)
	local gametop = gModuleMgr.getObject("gametop")
	local questCtrl = gametop.playertop_:getModule("questCtrl")
	local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
	local quest = questCtrl:getPerformingGuideQuest()
	if quest == nil then
		SoraDShowMsgTip(i18n("common_text_845"), nil, button)
		return
	end
	local questID = quest.questID
	local questType = questltCtrl:getQuestType(questID)
	if gQuestType.BUILD_BUILDING == questType or gQuestType.UPGRADE_BUILDING == questType or gQuestType.RESOURCE_OUTPUT == questType then
		questltCtrl:jumpToFinishedById(questID)
	else
		SoraDShowMsgTip(i18n("common_text_845"), nil, button)
	end
end
function buildLogic.starBuilderIsLeisure(button)
	local curStep = SoraDIsGameGuide()
	if curStep then
		return
	end
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	mildGuideManager:starMildByEverydayTaskID(gEverydayTaskType.UPGRADESTAR_BUILD)
end
function buildLogic.buyRechargeQueue()
	local gametop = gModuleMgr.getObject("gametop")
	local itemId = 500501
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemId)
	if 0 < itemCount then
		_ENV = nil
		;(nil).day = BUILDER_WORK_TIME
		;(nil).gold = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
		SoraDShowBuyBox(i18n("common_text_842", nil), gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD, i18n("common_text_843"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				gametop.playertop_:getModule("cityCtrl"):openChargeQueueReq()
			end
		end, nil, nil, function()
			_ENV, _ENV = nil, nil
			;(nil).id = itemId
			;(nil).itemData, (nil).count = nil, itemCount
			uiManager:show("newItemSingleUse", nil)
		end)
	else
		_ENV = i18n("common_text_843")
		i18n("common_text_843").day = BUILDER_WORK_TIME
		i18n("common_text_843").gold = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
		SoraDShowBuyBox(i18n("common_text_842", (i18n("common_text_843"))), gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD, i18n("common_text_843"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				gametop.playertop_:getModule("cityCtrl"):openChargeQueueReq()
			end
		end)
	end
end
function buildLogic.getBuildQueueByBid(bid, iid)
	local iid = iid or 0
	local buildQueue, queueType
	local freeQueue = queueCtrl:queryQueue(gQueueTypeDef.free_build_queue)
	if freeQueue and freeQueue.data.bid == tostring(bid) and freeQueue.data.iid == tostring(iid) then
		buildQueue = freeQueue
		queueType = gQueueTypeDef.free_build_queue
	end
	if not buildQueue then
		local goldQueue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
		if goldQueue and goldQueue.data.bid == tostring(bid) and goldQueue.data.iid == tostring(iid) then
			buildQueue = goldQueue
			queueType = gQueueTypeDef.charge_build_queue
		end
	end
	return buildQueue, queueType
end
function buildLogic.getBestStrongTool(speedType, leftTime, curItemID, otherData)
	local index, bestNum
	local _ret, _id, _index, _count = false
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local tableItemData = backpackCtrl:getSpeedUpItemList(speedType)
	local freeTime = buildLogic.getFreeStrongTime()
	leftTime = math.max(leftTime - freeTime, 0)
	local isOwnOneMin = function(data)
		local ret = false
		local id, index, count
		for k, v in pairs(data) do
			local resultTime = backpackltCtrl:getResult(v.id).value
			if resultTime <= 60 then
				ret = true
				id = v.id
				index = k
				count = v.count
				break
			end
		end
		return ret, id, index, count
	end
	_ret, _id, _index, _count = isOwnOneMin(tableItemData)
	if curItemID then
		for k, v in pairs(tableItemData) do
			if v.id == curItemID then
				index = k
				local resultTime = backpackltCtrl:getResult(v.id).value
				bestNum = math.floor(leftTime / resultTime)
				if resultTime <= 300 then
					bestNum = math.ceil(leftTime / resultTime)
					if _ret and curItemID ~= _id then
						bestNum = bestNum - 1
					end
				end
				bestNum = math.max(math.min(bestNum, v.count), 1)
				break
			end
		end
	else
		local _ENV, curTypeData = pairs(tableItemData)
		local _ENV, generalData = pairs(tableItemData)
		for k, v in pairs(tableItemData) do
			local result = backpackltCtrl:getResult(v.id)
			if result and result.key == speedType then
				v.index = k
				table.insert(curTypeData, v)
			end
			if result and result.key == gAbbrSpeedUpType.GENERAL then
				v.index = k
				table.insert(generalData, v)
			end
		end
		table.sort(curTypeData, function(a, b)
			return backpackltCtrl:getResult(a.id).value > backpackltCtrl:getResult(b.id).value
		end)
		table.sort(generalData, function(a, b)
			return backpackltCtrl:getResult(a.id).value > backpackltCtrl:getResult(b.id).value
		end)
		local chooseBest = function(data)
			if leftTime < 300 and _ret and _id and _index and _count then
			else
				for k, v in ipairs(data) do
					local resultTime = backpackltCtrl:getResult(v.id).value
					if resultTime <= leftTime then
						break
					end
				end
			end
		end
		if curTypeData and next(curTypeData) then
			chooseBest(curTypeData)
		else
			chooseBest(generalData)
		end
	end
	return index or 1, bestNum or 1
end
function buildLogic.getBestSpeedUpTool(speedType, leftTime, curItemID, otherData, queueType)
	local index, bestNum
	local _ret, _id, _index, _count = false
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local tableItemData = backpackCtrl:getSpeedUpItemList(speedType)
	local isUpgradeStar = otherData and otherData.isUpgradeStar
	if speedType == gAbbrSpeedUpType.BUILD_UPGRADE and not isUpgradeStar then
		local freeTime = buildLogic.getFreeSpeedUpTime(otherData.buildLv)
		leftTime = math.max(leftTime - freeTime, 0)
	end
	if speedType == gAbbrSpeedUpType.TECH then
		local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
		freeTime = technologyCtrl:getFreeSpeedUpTime(queueType)
		leftTime = math.max(leftTime - freeTime, 0)
	end
	local isOwnOneMin = function(data)
		local ret = false
		local id, index, count
		for k, v in pairs(data) do
			local resultTime = backpackltCtrl:getResult(v.id).value
			if resultTime <= 60 then
				ret = true
				id = v.id
				index = k
				count = v.count
				break
			end
		end
		return ret, id, index, count
	end
	_ret, _id, _index, _count = isOwnOneMin(tableItemData)
	if curItemID then
		for k, v in pairs(tableItemData) do
			if v.id == curItemID then
				index = k
				local resultTime = backpackltCtrl:getResult(v.id).value
				bestNum = math.floor(leftTime / resultTime)
				if resultTime <= 300 then
					bestNum = math.ceil(leftTime / resultTime)
					if _ret and curItemID ~= _id then
						bestNum = bestNum - 1
					end
				end
				bestNum = math.max(math.min(bestNum, v.count), 1)
				break
			end
		end
	else
		local _ENV, curTypeData = pairs(tableItemData)
		local _ENV, generalData = pairs(tableItemData)
		for k, v in pairs(tableItemData) do
			local result = backpackltCtrl:getResult(v.id)
			if result and result.key == speedType then
				v.index = k
				table.insert(curTypeData, v)
			end
			if result and speedType == gAbbrSpeedUpType.CRAFT_STUDY and result.key == gAbbrSpeedUpType.TECH then
				v.index = k
				table.insert(curTypeData, v)
			end
			if result and result.key == gAbbrSpeedUpType.GENERAL then
				v.index = k
				table.insert(generalData, v)
			end
		end
		table.sort(curTypeData, function(a, b)
			return backpackltCtrl:getResult(a.id).value > backpackltCtrl:getResult(b.id).value
		end)
		table.sort(generalData, function(a, b)
			return backpackltCtrl:getResult(a.id).value > backpackltCtrl:getResult(b.id).value
		end)
		local chooseBest = function(data)
			if leftTime < 300 and _ret and _id and _index and _count then
			else
				for k, v in ipairs(data) do
					local resultTime = backpackltCtrl:getResult(v.id).value
					if resultTime <= leftTime then
						break
					end
				end
			end
		end
		if curTypeData and next(curTypeData) then
			chooseBest(curTypeData)
		else
			chooseBest(generalData)
		end
	end
	return index or 1, bestNum or 1
end
function buildLogic.getBuildStateStr(bid, iid)
	local statusStr, buildState
	local bid = tonumber(bid)
	local iid = tonumber(iid) or 0
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	if buildCell then
		buildState = tonumber(buildCell.info.state)
		if buildState == BUILD_STATE.NORMAL then
			buildState = tonumber(buildLogic.getBuildStateByBid(bid))
		end
		if buildState == BUILD_STATE.BUILDING then
			statusStr = i18n("common_text_043")
		elseif buildState == BUILD_STATE.UPGRADEING then
			statusStr = i18n("common_text_056")
		elseif buildState == BUILD_STATE.DEMOLISHING then
			statusStr = i18n("common_text_038")
		elseif buildState == BUILD_STATE.TRAINING then
			statusStr = i18n("common_text_769")
			if bid == BUILDID.FORTRESS then
				statusStr = i18n("common_text_770")
			end
		elseif buildState == BUILD_STATE.STUDYING then
			statusStr = i18n("common_text_771")
		end
	end
	return statusStr, buildState
end
function buildLogic.isCanMasteryUpgrade(bid, lv)
	local specializationRead = include("specializationRead")
	local data = specializationRead.getMasteryData(bid, lv)
	local _ENV, retPreCond = bid, bid
	local precond = data.buildingLvl
	if precond then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _blv = precond[2 * i]
			local _curlv = cityCtrl:getBuildMaxLv(_bid)
			local _isreach = _blv <= _curlv
			_ENV = nil
			;(nil).bid = _bid
			;(nil).blv = _blv
			;(nil).curlv = _curlv
			;(nil).isreach = _isreach
			table.insert(retPreCond, nil)
		end
	end
	local costResReduceBuff = buffCtrl:getBuffEffect(gBuffEffect.MASTERY_UPGRADE_COST_REDUCE) or 0
	costResReduceBuff = costResReduceBuff / 1000
	local _ENV, retCostRes = buffCtrl, buffCtrl
	local costres = data.resource
	if costres then
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			local _curcount = cityCtrl:getResCount(_resid)
			_rescount = math.ceil(_rescount * (1 - costResReduceBuff))
			if 0 < _rescount then
				local _isreach = true
				if _curcount < _rescount then
					_isreach = false
				end
				_ENV = nil
				;(nil).resid = _resid
				;(nil).rescount = _rescount
				;(nil).curcount = _curcount
				;(nil).isreach = _isreach
				table.insert(retCostRes, nil)
			end
		end
	end
	local resToGold = 0
	for k, v in pairs(retCostRes) do
		if v.rescount > v.curcount then
			local _rescount = v.rescount
			local needBuyRes = math.max(_rescount - v.curcount, 0)
			resToGold = resToGold + serviceFunctions.resConvertToGold(v.resid, needBuyRes)
		end
	end
	local _ENV, retCostTools = (for generator), pairs(retCostRes)
	local costtools = data.plan
	if costtools then
		for i = 1, #costtools / 2 do
			local _toolid = costtools[2 * i - 1]
			local _toolcount = costtools[2 * i]
			local _curcount = backpackCtrl:getItemCount(_toolid)
			_toolcount = math.ceil(_toolcount * (1 - costResReduceBuff))
			local _isreach = true
			if _curcount < _toolcount then
				_isreach = false
			end
			_ENV = nil
			;(nil).toolid = _toolid
			;(nil).toolcount = _toolcount
			;(nil).curcount = _curcount
			;(nil).isreach = _isreach
			table.insert(retCostTools, nil)
		end
	end
	local _ENV, masteryQueueList = (for index), 1
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
	if queue then
		table.insert(masteryQueueList, queue)
	end
	local _ENV, buildQueueList = table.insert, table.insert
	for i, queue in ipairs(buildLogic.getCurBuildQueue()) do
		if queue.data.optype == tostring(BUILD_OPERATE_TYPE.DEMOLISH) and queue.data.bid == tostring(bid) then
			table.insert(buildQueueList, queue)
		end
	end
	local costtime = data.time
	costtime = buildLogic.getMasteryUpgradeTime(costtime)
	local timeToGold = serviceFunctions.timeConvertToGold(costtime)
	local immediatelyGold = resToGold + timeToGold
	_ENV = buildLogic.getCurBuildQueue()
	buildLogic.getCurBuildQueue()._retPreCond = retPreCond
	buildLogic.getCurBuildQueue()._retCostRes = retCostRes
	buildLogic.getCurBuildQueue()._retCostTools = retCostTools
	buildLogic.getCurBuildQueue()._masteryQueueList = masteryQueueList
	buildLogic.getCurBuildQueue()._buildQueueList = buildQueueList
	buildLogic.getCurBuildQueue()._costtime = costtime
	buildLogic.getCurBuildQueue()._resToGold = resToGold
	local buildLogic.getCurBuildQueue()._immediatelyGold, retdata = immediatelyGold, buildLogic.getCurBuildQueue()
	return retdata
end
function buildLogic.getMasteryUpgradeTime(time)
	local buff_reduce = buffCtrl:getBuffEffect(gBuffEffect.MASTERY_UPGRADE_SPEED_ADD) or 0
	buff_reduce = buff_reduce / 1000
	return math.ceil(time * (1 / (1 + buff_reduce)))
end
function buildLogic.checkDemolishQueue(bid)
	for i, queue in ipairs(buildLogic.getCurBuildQueue()) do
		if queue.data.optype == tostring(BUILD_OPERATE_TYPE.DEMOLISH) and queue.data.bid == tostring(bid) then
			return true
		end
	end
end
function buildLogic.getBuildBaseValue(bid, key, bcell)
	local base = 0
	bcell = bcell or cityCtrl:getBuildCell(bid, 0)
	if not bcell then
		return base
	end
	local blv = tonumber(bcell.info.lv)
	base = cityltCtrl.buildLvInfo(bid, blv, key)
	local slv = tonumber(bcell.info.starLv)
	if 0 < slv then
		local sInfo = cityltCtrl.buildStarLvInfo(bid, slv, key)
		if type(base) == "number" then
			base = base + sInfo
		elseif type(base) == "table" then
			local cityCtrl, ret = type(base), type(base)
			for i = 1, #base / 2 do
				ret[i * 2 - 1] = base[i * 2 - 1]
				ret[i * 2] = base[i * 2] + (sInfo[i * 2] or 0)
			end
			return ret
		end
	end
	return base
end
function buildLogic.getBuildStarJumpOffset(buildIndex)
	local posX = display.size.width * 0.5
	local posY = display.rheight * 0.5 + 70 + display.iPhoneXBottom
	return posX, posY
end
function buildLogic.getAmberDecreeBuff(bid, blv)
	local ret = 0
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	if blv <= 70 and bid ~= BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.AMBER_REDUCE_COST_REDUCE_LESS_70) or 0)
	elseif blv <= 160 and bid == BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_AMBER_REDUCE_COST_REDUCE_LESS_160) or 0)
	elseif 160 < blv and blv <= 215 and bid == BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_AMBER_REDUCE_COST_REDUCE_LV_160_TO_215) or 0)
	end
	return ret
end
function buildLogic.getAstralDecreeBuff(bid, blv)
	local ret = 0
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	if blv <= 70 and bid ~= BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.ASTRAL_REDUCE_COST_REDUCE_LESS_70) or 0)
	elseif blv <= 160 and bid == BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_ASTRAL_REDUCE_COST_REDUCE_LESS_160) or 0)
	elseif 160 < blv and blv <= 215 and bid == BUILDID.STAR_BRAVE_STATUE then
		ret = ret + (buffCtrl:getBuffEffect(gBuffEffect.GLORIOUS_STATUE_ASTRAL_REDUCE_COST_REDUCE_LV_160_TO_215) or 0)
	end
	return ret
end
function buildLogic.getNebulaTowerBuff(bid, blv, buffChoiceType)
	local ret = 0
	local buffType
	if bid == BUILDID.GLORIOUS_STATUE then
		if blv <= 260 then
			if buffChoiceType == radiantDecreeBuffType.UPGRADE_COST_ITEM_REDUCE then
				buffType = gBuffEffect.GLORIOUS_STATUE_ITEM_COST_REDUCE_LESS_260
			elseif buffChoiceType == radiantDecreeBuffType.UPGRADE_COST_RES_REDUCE then
				buffType = gBuffEffect.GLORIOUS_STATUE_RES_COST_REDUCE_LESS_260
			end
		end
	elseif blv <= 70 then
		if buffChoiceType == radiantDecreeBuffType.UPGRADE_COST_ITEM_REDUCE then
			buffType = gBuffEffect.UPGRADE_STAR_LV_ITEM_COST_REDUCE_LESS_70
		elseif buffChoiceType == radiantDecreeBuffType.UPGRADE_COST_RES_REDUCE then
			buffType = gBuffEffect.UPGRADE_STAR_LV_RES_COST_REDUCE_LESS_70
		end
	end
	if buffType then
		ret = buffCtrl:getBuffEffect(buffType, gBuffSource.NEBULA_TOWER) or 0
	end
	return ret
end
function buildLogic.getRechargeBuffDecreeBuff(bid, buffChoiceType)
	local effectType
	if buffChoiceType == radiantDecreeBuffType.ASTRAL_MINE_REDUCE then
		effectType = bid ~= BUILDID.GLORIOUS_STATUE and gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE or gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE_STATUE
	elseif buffChoiceType == radiantDecreeBuffType.AMBER_REDUCE then
		effectType = bid ~= BUILDID.GLORIOUS_STATUE and gBuffEffect.RADIANT_DECREE_AMBER_REDUCE or gBuffEffect.RADIANT_DECREE_AMBER_REDUCE_STATUE
	end
	local ret = 0
	if effectType then
		ret = buffCtrl:getBuffEffect(effectType, gBuffSource.RECHARGE_ACTIVITY) or 0
	end
	return ret
end
function buildLogic.getActivityBuff(effectType, buildData)
	local warOrderRead = include("warOrderRead")
	return warOrderRead.getBuildBuffEffect(effectType, buildData)
end
return buildLogic
