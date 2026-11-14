local maincityDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	maincityDesRead = nil
	;(nil)[1] = "localmaincity"
	maincityDesRead:defineValue("tblCfg", nil)
	maincityDesRead = nil
	;(nil)[1] = "guardsoldiercfg"
	maincityDesRead:defineValue("tblGuardSoldierCfg", nil)
	maincityDesRead = nil
	;(nil)[1] = "tips_npc_builds"
	maincityDesRead:defineValue("npcBuildTips", nil)
	maincityDesRead = nil
	;(nil)[1] = "new_function_popup"
	maincityDesRead:defineValue("unlockInfo", nil)
	maincityDesRead = nil
	;(nil)[1] = "new_function_page"
	maincityDesRead:defineValue("unlockIcon", nil)
	maincityDesRead = nil
	;(nil)[1] = "new_function_manor"
	maincityDesRead:defineValue("unlockBlock", nil)
end
init()
function maincityDesRead.getUnlockBlockInfo()
	local _ENV, ret
	for i, v in ipairs(maincityDesRead.unlockBlock) do
		ret[v.index] = v
		ret[v.index].title = v.name
	end
	return ret
end
function maincityDesRead.getUnlockInfoByLv(lv, isSuccess)
	local _ENV, ret
	for i, v in ipairs(maincityDesRead.unlockInfo) do
		if isSuccess then
			if v.unlocklevel == lv then
				table.insert(ret, v)
			end
		elseif #v.ununlockedlevel == 2 then
			if lv >= v.ununlockedlevel[1] and lv <= v.ununlockedlevel[2] then
				table.insert(ret, v)
			end
		elseif v.ununlockedlevel[1] == lv then
			table.insert(ret, v)
		end
	end
	return ret
end
function maincityDesRead.getUnlockIconByLv(lv)
	return maincityDesRead.unlockIcon[lv].icon
end
function maincityDesRead:getCqCfg()
	return self.tblCfg.CqCfg
end
function maincityDesRead:getNumOfCq()
	return 9
end
function maincityDesRead:getCqPosByIndex(index)
	local cqName = "Cq_" .. index
	local cqCfg = self:getCqCfg()
	_ENV = self
	self.x = 0
	local self.y, pos = 0, self
	for k, v in pairs(cqCfg) do
		if cqName == k then
			local cqPos = v.pos
			pos.x = cqPos[1]
			pos.y = cqPos[2]
			break
		end
	end
	return pos
end
function maincityDesRead.getGuardSoldierCfgByMask(mask)
	local bit = require("bit32")
	local _ENV, ret = "bit32", "bit32"
	for i, v in ipairs(maincityDesRead.tblGuardSoldierCfg) do
		if bit.band(mask, v.mask) ~= 0 then
			table.insert(ret, #ret + 1, v)
		end
	end
	return ret
end
function maincityDesRead.getNpcTips()
	return maincityDesRead.npcBuildTips
end
function maincityDesRead.getNpcTipsByBid(bid)
	for i, v in ipairs(maincityDesRead.npcBuildTips) do
		if bid == v.buildID then
			return v.tips
		end
	end
end
function maincityDesRead.getNpcTipsByIndex(bIndex)
	for i, v in ipairs(maincityDesRead.npcBuildTips) do
		if bid == v.bIndex then
			return v.tips
		end
	end
end
return maincityDesRead
