local manorTechRead = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "garden_tech_show"
manorTechRead:defineValue("garden_tech_show", nil)
manorTechRead:defineValue("garden_tech_showCfg", function()
	local _ENV, ret
	for _, v in ipairs(manorTechRead.garden_tech_show) do
		ret[v.technologyID] = v
	end
	return ret
end)
function manorTechRead.getTechTree()
	return manorTechRead.garden_tech_show
end
function manorTechRead.getTechShowCfg(technologyID)
	return manorTechRead.garden_tech_showCfg[tonumber(technologyID)]
end
function manorTechRead.getName(technologyID)
	local cfg = manorTechRead.getTechShowCfg(technologyID)
	return cfg and i18n(cfg.techName)
end
return manorTechRead
