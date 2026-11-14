local buildCell = class("buildCell")
local cityltCtrl = include("cityltCtrl")
function buildCell:ctor()
	self.info, _UPVALUE0_ = nil, nil
end
function buildCell:upgrade()
	local maxlv = cityltCtrl.buildAttr(tonumber(self.info.bid), BUILD_ATTR.MAXLV)
	local lv = tonumber(self.info.lv)
	lv = lv + 1
	if maxlv < lv then
		lv = maxlv
	end
	self.info.lv = tostring(lv)
end
function buildCell:upgradeStar()
	local maxlv = cityltCtrl.buildAttr(tonumber(self.info.bid), BUILD_ATTR.MAXSTARLV)
	if tonumber(self.info.bid) == BUILDID.STAR_BRAVE_STATUE then
		local addMaxStarLv = cityltCtrl.buildAttr(tonumber(self.info.bid), BUILD_ATTR.ADDMAXSTARLV)
		local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
		local ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.GLORIOUS_STATUE_LEVEL_MAX, maxlv)
		ret = math.min(ret, addMaxStarLv)
		maxlv = math.max(maxlv, ret)
	end
	local starLv = tonumber(self.info.starLv)
	starLv = math.min(starLv + 1, maxlv)
	self.info.starLv = tostring(starLv)
end
function buildCell:update(dttime)
	local buildLogic = include("buildLogic")
	local bid = tonumber(self.info.bid)
	local blv = tonumber(self.info.lv)
	local iid = tonumber(self.info.iid)
	if buildLogic.judgeIsResBuild(bid) and tonumber(self.info.state) == BUILD_STATE.NORMAL then
		local ret = buildLogic.getResOutputHour(bid, blv, iid)
		local outputmax = buildLogic.getResOututMaxCount(bid, blv, iid)
		local totaloutput = ret.total
		local output = totaloutput * (dttime / 3600)
		self.info.curres = tostring(tonumber(self.info.curres) + output)
		if tonumber(self.info.curres) >= outputmax.total then
			self.info.curres = tostring(outputmax.total)
		end
	end
end
return buildCell
