local artifactRuneRead = include("artifactRuneRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
local Com_HoleSlot = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_HoleSlot", Com_HoleSlot)
function Com_HoleSlot:onInit()
end
function Com_HoleSlot:onShow()
end
function Com_HoleSlot:initData(weaponID)
	self.weaponID = weaponID
	artifactRuneRead, artifactRuneRead, artifactRuneRead, self.holeCfg = nil, weaponID, artifactRuneRead.getHoleInfo(weaponID), artifactRuneRead.getHoleInfo(weaponID)
	;(nil).pos = cc.p(530, 85)
	artifactRuneRead, weaponID[1], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(390, 110)
	artifactRuneRead, weaponID[2], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(250, 110)
	artifactRuneRead, weaponID[3], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(110, 85)
	artifactRuneRead, artifactRuneRead, artifactRuneRead.getHoleInfo(weaponID)[4], weaponID[4], (nil).scale = nil, weaponID, weaponID, nil, 1
	;(nil).pos = cc.p(570, 55)
	artifactRuneRead, weaponID[1], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(445, 100)
	artifactRuneRead, weaponID[2], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(320, 110)
	artifactRuneRead, weaponID[3], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(195, 100)
	artifactRuneRead, weaponID[4], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(70, 55)
	artifactRuneRead, artifactRuneRead, artifactRuneRead.getHoleInfo(weaponID)[5], weaponID[5], (nil).scale = nil, weaponID, weaponID, nil, 1
	;(nil).pos = cc.p(598, 60)
	artifactRuneRead, weaponID[1], (nil).scale = nil, nil, 0.88
	;(nil).pos = cc.p(510, 95)
	artifactRuneRead, weaponID[2], (nil).scale = nil, nil, 0.94
	;(nil).pos = cc.p(390, 110)
	artifactRuneRead, weaponID[3], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(250, 110)
	artifactRuneRead, weaponID[4], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(130, 95)
	artifactRuneRead, weaponID[5], (nil).scale = nil, nil, 0.94
	;(nil).pos = cc.p(42, 60)
	artifactRuneRead, artifactRuneRead, artifactRuneRead.getHoleInfo(weaponID)[6], weaponID[6], (nil).scale = nil, weaponID, weaponID, nil, 0.88
	;(nil).pos = cc.p(535, 15)
	artifactRuneRead, weaponID[1], (nil).scale = nil, nil, 0.85
	;(nil).pos = cc.p(580, 80)
	artifactRuneRead, weaponID[2], (nil).scale = nil, nil, 0.92
	;(nil).pos = cc.p(460, 100)
	artifactRuneRead, weaponID[3], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(320, 110)
	artifactRuneRead, weaponID[4], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(180, 100)
	artifactRuneRead, weaponID[5], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(60, 80)
	artifactRuneRead, weaponID[6], (nil).scale = nil, nil, 0.92
	;(nil).pos = cc.p(105, 15)
	artifactRuneRead, artifactRuneRead, artifactRuneRead.getHoleInfo(weaponID)[7], weaponID[7], (nil).scale = nil, weaponID, weaponID, nil, 0.85
	;(nil).pos = cc.p(533, 5)
	artifactRuneRead, weaponID[1], (nil).scale = nil, nil, 0.82
	;(nil).pos = cc.p(598, 60)
	artifactRuneRead, weaponID[2], (nil).scale = nil, nil, 0.88
	;(nil).pos = cc.p(510, 95)
	artifactRuneRead, weaponID[3], (nil).scale = nil, nil, 0.94
	;(nil).pos = cc.p(390, 110)
	artifactRuneRead, weaponID[4], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(250, 110)
	artifactRuneRead, weaponID[5], (nil).scale = nil, nil, 1
	;(nil).pos = cc.p(130, 95)
	artifactRuneRead, weaponID[6], (nil).scale = nil, nil, 0.94
	;(nil).pos = cc.p(42, 60)
	artifactRuneRead, weaponID[7], (nil).scale = nil, nil, 0.88
	;(nil).pos = cc.p(107, 5)
	artifactRuneRead.getHoleInfo(weaponID)[8], weaponID[8], (nil).scale = weaponID, nil, 0.82
	local slotCfg = artifactRuneRead.getHoleInfo(weaponID)
	local limit = activity_9001656_Ctrl:getUnlockWarLineHoleCount()
	self.holeLimit = limit and limit or #self.holeCfg
	local cfg = slotCfg[self.holeLimit]
	for k = 1, 8 do
		local v = self.fields["Com_RuneSlot" .. k]
		if cfg[k] then
			v:setPosition(SoraDFPosX(cfg[k].pos.x, 640), cfg[k].pos.y)
			v:setScale(cfg[k].scale or 1)
			if k <= math.ceil(#self.holeCfg / 2) then
			else
			end
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
function Com_HoleSlot:updateView(updateUid, group, runePreArray)
	local unlockTip
	local ignoreIndex = 0
	local plusData = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.ADD_WAR_LINE_HOLE_COUNT, nil, lordInfoCtrl:getMapSourceKid())
	local plusVal = 0
	if plusData and type(plusData) == "number" then
		plusVal = plusData
	elseif plusData and type(plusData) == "table" then
		plusVal = plusData.value
	end
	for ki = 1, 8 do
		local vi = self.fields["Com_RuneSlot" .. ki]
		if vi:isVisible() then
			local isUnlock = true
			local unlockCfg = self.holeCfg[ki].Unlock
			if unlockCfg.key == 1 and SoraDGetCastleLv() < unlockCfg.val then
				isUnlock = false
				unlockTip = unlockCfg
			end
			if unlockCfg.key == 2 then
				local taskInfo = nebulaMileStoneCtrl:getTaskData(unlockCfg.val)
				if not taskInfo or taskInfo and taskInfo.status ~= "end" then
					isUnlock = false
					unlockTip = unlockCfg
				end
			end
			if unlockCfg.key == 3 then
				if ignoreIndex < plusVal then
					ignoreIndex = ignoreIndex + 1
				else
					local techInfo = technologyCtrl:getTechnoDataByID(unlockCfg.val, "nebula")
					if not techInfo or techInfo and (not techInfo.isOpened or techInfo.isOpened and techInfo.currentLevel < unlockCfg.lv) then
						isUnlock = false
						unlockTip = unlockCfg
					end
				end
			end
			local uid = runePreArray[tostring(ki)]
			if group == 1 then
				uid = godArmsRuneCtrl:findRune(self.weaponID, ki, group)
			end
			print("group====", group, ki, uid)
			if not godArmsRuneCtrl:getRuneInfo(uid) then
				local nebulaMileStoneCtrl, runeInfo = godArmsRuneCtrl:getRuneInfo(uid), godArmsRuneCtrl:getRuneInfo(uid)
			end
			local isRune = uid and 0 < uid and next(runeInfo) or false
			local showType = 0
			if isUnlock then
				showType = isRune and 2 or 1
			end
			local rid = runeInfo.rid or nil
			if not runeInfo.extraProperty then
				local nebulaMileStoneCtrl, extraProperty = runeInfo.extraProperty, runeInfo.extraProperty
			end
			local tempExtraProperty = runeInfo.tempExtraProperty
			local level = runeInfo.level or 1
			local exp = runeInfo.exp or 0
			local luckyValue = runeInfo.luckyValue or 0
			local isLock = runeInfo.isLock or false
			local isMine = updateUid and updateUid == uid
			local nebulaMileStoneCtrl, info = lordInfoCtrl:getMapSourceKid()
			local nebulaMileStoneCtrl, lvCfg = lordInfoCtrl:getMapSourceKid()
			if rid then
				info = artifactRuneRead.getRuneInfo(rid)
				lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, level)
			end
			nebulaMileStoneCtrl = level
			level.godArmsID = self.weaponID
			level.godArmsCell = ki
			level.showType = showType
			level.holeType = self.holeCfg[ki].HoleType
			level.uid = uid
			level.rid = rid
			level.exp = exp
			level.level = level
			level.luckyValue = luckyValue
			level.extraProperty = extraProperty
			level.tempExtraProperty = tempExtraProperty
			level.unlockTip = unlockTip
			level.isLock = isLock
			level.class = lvCfg.Class
			level.season = info.Season
			vi:initData(level, isMine, group)
		end
	end
end
function Com_HoleSlot:getDetailUids()
	local _ENV, ret
	for k = 1, 8 do
		local v = self.fields["Com_RuneSlot" .. k]
		if v:isVisible() then
			ret[tostring(k)] = v:getUid()
		end
	end
	return ret
end
return Com_HoleSlot
