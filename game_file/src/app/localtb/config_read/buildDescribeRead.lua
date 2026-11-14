local buildDescribeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	buildDescribeRead = nil
	;(nil)[1] = "builddescribe"
	buildDescribeRead:defineValue("tableBuildDes", nil)
	buildDescribeRead = nil
	;(nil)[1] = "kipchaks_npcconfig"
	buildDescribeRead:defineValue("kipchaksData", nil)
end
init()
function buildDescribeRead.getName(bid)
	bid = tonumber(bid)
	return i18n(buildDescribeRead.tableBuildDes[bid].name)
end
function buildDescribeRead.getBrief(bid)
	bid = tonumber(bid)
	return i18n(buildDescribeRead.tableBuildDes[bid].build_brief)
end
function buildDescribeRead.getDes(bid)
	bid = tonumber(bid)
	local describe = i18n(buildDescribeRead.tableBuildDes[bid].describe)
	if bid == BUILDID.EMBASSY then
		if SoraDCheckIsOpenBuildStar() then
			describe = describe .. "\n" .. i18n("common_text_4301")
		end
		if SoraDIsBraveOpen() then
			describe = describe .. i18n("common_text_4302")
		end
	end
	return describe
end
function buildDescribeRead.getWarDes(bid)
	bid = tonumber(bid)
	return i18n(buildDescribeRead.tableBuildDes[bid].war_describe)
end
function buildDescribeRead.getStarDes(bid)
	bid = tonumber(bid)
	local starDes = buildDescribeRead.tableBuildDes[bid].star_describe
	if string.utf8len(starDes) > 0 then
		return i18n(starDes)
	end
	return nil
end
function buildDescribeRead.getkipchaks(lv)
	for i, v in ipairs(buildDescribeRead.kipchaksData) do
		if v.npcLevel == lv then
			return v
		end
	end
end
function buildDescribeRead.getUpgradeDes(bid)
	bid = tonumber(bid)
	local upDes = buildDescribeRead.tableBuildDes[bid].upgrade_brief
	if string.utf8len(upDes) > 0 then
		return i18n(upDes)
	end
	return nil
end
function buildDescribeRead.getUpgradeStarDes(bid)
	bid = tonumber(bid)
	local upDes = buildDescribeRead.tableBuildDes[bid].star_brief
	if upDes and string.utf8len(upDes) > 0 then
		return i18n(upDes)
	end
	return nil
end
function buildDescribeRead.getIcon(bid, fromMemory)
	bid = tonumber(bid)
	if fromMemory then
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			return "#" .. buildDescribeRead.tableBuildDes[bid].build_icon_byzantine
		end
		return "#" .. buildDescribeRead.tableBuildDes[bid].build_icon
	end
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return buildDescribeRead.tableBuildDes[bid].build_icon_byzantine
	end
	return buildDescribeRead.tableBuildDes[bid].build_icon
end
function buildDescribeRead.getQueueType(bid)
	local bid = tonumber(bid)
	if bid == BUILDID.HOSTPITAL then
		local worldMapWarDef = include("worldMapWarDef")
		return worldMapWarDef.getHostpitalQueueType()
	elseif bid == BUILDID.CHARIOT_PLANT then
		return gQueueTypeDef.chariot_plant_queue
	elseif bid == BUILDID.STABLES then
		return gQueueTypeDef.stables_queue
	elseif bid == BUILDID.RANGE then
		return gQueueTypeDef.range_queue
	elseif bid == BUILDID.BARRACKS then
		return gQueueTypeDef.barracks_queue
	elseif bid == BUILDID.FORTRESS then
		return gQueueTypeDef.frotress_queue
	elseif bid == BUILDID.COLLEGE then
		return gQueueTypeDef.technology_upgrade_queue
	elseif bid == BUILDID.NEBULA_PALACE then
		return gQueueTypeDef.nebula_palace_technology
	elseif bid == BUILDID.MIRACLE then
		return gQueueTypeDef.war_tech_research
	elseif bid == BUILDID.BLACK_SMITH then
		return gQueueTypeDef.forge_equipment
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		return gQueueTypeDef.stuff_workshop
	elseif bid == BUILDID.ELITE_PALACE then
		return gQueueTypeDef.elite_queue
	elseif bid == BUILDID.STAR_BRAVE_STATUE then
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		if queueCtrl:queryQueue(gQueueTypeDef.armor_forging) then
			return gQueueTypeDef.armor_forging
		else
			return gQueueTypeDef.craft_study
		end
	elseif bid == BUILDID.NEBULA_PALACE then
		return gQueueTypeDef.nebula_palace_technology
	end
	return nil
end
return buildDescribeRead
