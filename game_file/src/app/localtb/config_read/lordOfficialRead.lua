local _ENV, lordOfficialRead
function lordOfficialRead.getOfficialInfo(officialType, officialId)
	if officialType == gShowOfficialType.KING then
		local officialInfoRead = include("officialInfoRead")
		return officialInfoRead.getInfoByType(officialId)
	elseif officialType == gShowOfficialType.HEGEMON then
		local hegemonRead = include("hegemonRead")
		return hegemonRead.getOfficialInfo(officialId)
	elseif officialType == gShowOfficialType.LEGEND then
		local legendKingRead = include("legendKingRead")
		return legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, officialId)
	elseif officialType == gShowOfficialType.KINGSTAR then
		local legendKingRead = include("legendKingRead")
		return legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, officialId, worldMapDefine.KINGSTAR_KINGDOM_ID)
	elseif officialType == gShowOfficialType.ATLANTIS then
		local atlantisActivityRead = include("atlantisActivityRead")
		return atlantisActivityRead.getOfficialInfoByType(officialId)
	elseif officialType == gShowOfficialType.NEBULA or officialType == gShowOfficialType.NEBULA2 then
		local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
		return nebulaPrivilegelRead.getOfficerInfo(officialId)
	elseif officialType == gShowOfficialType.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		return nebulaEmperorRead.getOfficerConfig(officialId)
	end
end
function lordOfficialRead.getOfficialIcon(officialType, officialId)
	local officialInfo = lordOfficialRead.getOfficialInfo(officialType, officialId)
	if not officialInfo then
		return "NA"
	end
	if officialType == gShowOfficialType.HEGEMON then
		return officialInfo.Image
	else
		return officialInfo.img
	end
end
function lordOfficialRead.getOfficialName(officialType, officialId)
	local officialInfo = lordOfficialRead.getOfficialInfo(officialType, officialId)
	if not officialInfo then
		return "NA"
	end
	if officialType == gShowOfficialType.HEGEMON then
		return i18n(officialInfo.Name)
	else
		return i18n(officialInfo.name)
	end
end
function lordOfficialRead.getOfficialBuff(officialType, officialId)
	local officialInfo = lordOfficialRead.getOfficialInfo(officialType, officialId)
	if not officialInfo then
		return "NA"
	end
	if officialType == gShowOfficialType.HEGEMON then
		return officialInfo.Buff
	else
		return officialInfo.buff
	end
end
function lordOfficialRead.getOfficialBuffDes(officialType, officialId)
