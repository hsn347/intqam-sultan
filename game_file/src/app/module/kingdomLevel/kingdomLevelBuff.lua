local kingdomLevelltCtrl = include("kingdomLevelltCtrl")
local _ENV, kingdomLevelBuff = "kingdomLevelltCtrl", "kingdomLevelltCtrl"
function kingdomLevelBuff:initialize()
end
function kingdomLevelBuff:getBuffEffect(kingdomLevel, effectType)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if not kingdomLevelltCtrl:buffValid(effectType, kingdomLevel, castleLevel) then
		return
	end
	return kingdomLevelltCtrl:getBuff(kingdomLevel, effectType)
end
function kingdomLevelBuff:dispatchBuffChange(kingdomLevel)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local effectType
	local _ENV, changeBuffTypeListOpen = BUILDID.CASTLE, BUILDID.CASTLE
	local buffList = kingdomLevelltCtrl:getBuffList(kingdomLevel)
	if buffList then
		for k, v in pairs(buffList) do
			if kingdomLevelltCtrl:buffValid(effectType, kingdomLevel, castleLevel) then
				changeBuffTypeListOpen[k] = v
			end
		end
	end
	local _ENV, changeBuffTypeListClose = (for generator), pairs(buffList)
	local preLevel = kingdomLevel - 1
	if 0 <= preLevel then
		local buffList = kingdomLevelltCtrl:getBuffList(preLevel)
		if buffList then
			for k, v in pairs(buffList) do
				if not changeBuffTypeListOpen[k] and kingdomLevelltCtrl:buffValid(effectType, kingdomLevel, castleLevel) then
					changeBuffTypeListClose[k] = v
				end
			end
		end
	end
	local gametop = gModuleMgr.getObject("gametop")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	for effectType, effect in pairs(changeBuffTypeListOpen) do
		print("kingdomLevelBuff open", effectType, effect)
		buffCtrl:dispatchBuffEvent(effectType, gBuffSource.KINGDOM_LEVEL)
	end
	for effectType, effect in pairs(changeBuffTypeListClose) do
		print("kingdomLevelBuff close", effectType, effect)
		buffCtrl:dispatchBuffEvent(effectType, gBuffSource.KINGDOM_LEVEL)
	end
end
return kingdomLevelBuff
