local castleSkinConfigRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	castleSkinConfigRead = nil
	;(nil)[1] = "castleskinconfig"
	castleSkinConfigRead:defineValue("skinconfig", nil)
	castleSkinConfigRead = nil
	;(nil)[1] = "worldmapskinconfig"
	castleSkinConfigRead:defineValue("worldconfig", nil)
	castleSkinConfigRead = nil
	;(nil)[1] = "worldmapNameBoxConfig"
	castleSkinConfigRead:defineValue("worldmapNameBoxConfig", nil)
end
init()
function castleSkinConfigRead.getCastleConfig(model)
	return castleSkinConfigRead.skinconfig[model]
end
function castleSkinConfigRead.getWorldCastleConfig(model)
	return castleSkinConfigRead.worldconfig[model]
end
function castleSkinConfigRead.getCastleTexture(castleModel)
	return castleSkinConfigRead.skinconfig[castleModel].texture
end
function castleSkinConfigRead.getSkinWarLvConfig(castleModel, warLv)
	local ret, rs
	if castleSkinConfigRead.worldconfig[castleModel] and castleSkinConfigRead.worldconfig[castleModel].warlvConfig then
		rs, castleSkinConfigRead = castleSkinConfigRead.worldconfig[castleModel].warlvConfig, castleSkinConfigRead.worldconfig[castleModel].warlvConfig
		ret = castleSkinConfigRead.worldconfig[castleModel].warlvConfig
		rs.scale = ret[warLv * 3 - 2]
		rs.offset = cc.p(ret[warLv * 3 - 1], ret[warLv * 3])
	end
	return rs
end
function castleSkinConfigRead.getSkinOffset(castleModel)
	local ret
	if castleSkinConfigRead.worldconfig[castleModel] then
		ret = cc.p(castleSkinConfigRead.worldconfig[castleModel].offsetX, castleSkinConfigRead.worldconfig[castleModel].offsetY)
	end
	return ret
end
function castleSkinConfigRead.getSkinPreViewOffset(castleModel)
	local ret
	local config = castleSkinConfigRead.worldconfig[castleModel]
	if config then
		ret = cc.p(config.preOffsetX or 0, config.preOffsetY or 0)
	end
	return ret
end
function castleSkinConfigRead.getTransferY(castleModel)
	local ret
	if castleSkinConfigRead.worldconfig[castleModel] then
		ret = castleSkinConfigRead.worldconfig[castleModel].transferY
	end
	return ret
end
function castleSkinConfigRead.getTransferX(castleModel)
	local ret
	if castleSkinConfigRead.worldconfig[castleModel] then
		ret = castleSkinConfigRead.worldconfig[castleModel].transferX
	end
	return ret
end
function castleSkinConfigRead.getNameBoxCfg(subType)
	return castleSkinConfigRead.worldmapNameBoxConfig[subType]
end
return castleSkinConfigRead
