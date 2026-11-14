local allianceDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceDesRead = nil
	;(nil)[1] = "allianceDescribe"
	allianceDesRead:defineValue("base", nil)
	allianceDesRead = nil
	;(nil)[1] = "alliance_science_describe"
	allianceDesRead:defineValue("science", nil)
	allianceDesRead = nil
	;(nil)[1] = "permission_describe"
	allianceDesRead:defineValue("permission", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_flag"
	;(nil)[2] = true
	allianceDesRead:defineValue("allianceFlag", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_official_config"
	;(nil)[2] = true
	allianceDesRead:defineValue("official", nil)
	allianceDesRead = nil
	;(nil)[1] = "alliance_buff_data"
	allianceDesRead:defineValue("scienceBuff", nil)
end
init()
function allianceDesRead.getBuildConditionIcon(id, fromMemory)
	id = tonumber(id)
	if fromMemory then
		return "#" .. allianceDesRead.base.condition[id].icon
	end
	return allianceDesRead.base.condition[id].icon
end
function allianceDesRead.getBuildConditionDes(id, aim)
	id = tonumber(id)
	_ENV = nil
	;(nil).name = i18n(allianceDesRead.base.condition[id].des)
	;(nil).point = aim
	return i18n("common_text_2172", nil)
end
function allianceDesRead.getBuildClassName(bcid)
	bcid = tonumber(bcid)
	return allianceDesRead.base.buildList[bcid] and i18n(allianceDesRead.base.buildList[bcid].name) or nil
end
function allianceDesRead.getBuildClassDes(bcid)
	bcid = tonumber(bcid)
	return allianceDesRead.base.buildList[bcid] and i18n(allianceDesRead.base.buildList[bcid].des) or nil
end
function allianceDesRead.getBuildName(bid)
	bid = tonumber(bid)
	return allianceDesRead.base.build[bid] and i18n(allianceDesRead.base.build[bid].name) or nil
end
function allianceDesRead.getMineBuildName(bid)
	bid = tonumber(bid)
	return allianceDesRead.base.mineBuild[bid] and i18n(allianceDesRead.base.mineBuild[bid].name) or nil
end
function allianceDesRead.getBuildIcon(bid, fromMemory)
	bid = tonumber(bid)
	if fromMemory then
		return "#" .. allianceDesRead.base.build[bid].icon
	end
	return allianceDesRead.base.build[bid].icon
end
function allianceDesRead.getBuildMiniIcon(bid, fromMemory)
	bid = tonumber(bid)
	if fromMemory then
		return "#" .. allianceDesRead.base.build[bid].miniicon
	end
	return allianceDesRead.base.build[bid].miniicon
end
function allianceDesRead.getBuildDes(bid)
	bid = tonumber(bid)
	return allianceDesRead.base.build[bid] and i18n(allianceDesRead.base.build[bid].des) or nil
end
function allianceDesRead.getBuildNewDes(bid)
	bid = tonumber(bid)
	return allianceDesRead.base.build[bid] and i18n(allianceDesRead.base.build[bid].newDes) or i18n(allianceDesRead.base.build[bid].des)
end
function allianceDesRead.isScience(sid)
	sid = tonumber(sid)
	return allianceDesRead.science[sid] ~= nil
end
function allianceDesRead.getScienceName(sid)
	sid = tonumber(sid)
	return allianceDesRead.science[sid] and i18n(allianceDesRead.science[sid].name) or "???"
end
function allianceDesRead.getScienceDes(sid)
	sid = tonumber(sid)
	if not allianceDesRead.science[sid] or not i18n(allianceDesRead.science[sid].describe) then
		_ENV = nil
		;(nil).des = "??????"
	end
	return (i18n("common_text_1437", nil))
end
function allianceDesRead.getScienceDesByScitype(scitype)
	local allianceltCtrl = include("allianceltCtrl")
	local ret = allianceltCtrl.getScienceIDListByScitype(scitype)
	local des
	if ret and next(ret) then
		des = allianceDesRead.getScienceDes(ret[1])
	end
	return des
end
function allianceDesRead.getScienceIcon(sid, fromMemory)
	sid = tonumber(sid)
	local fileName = "icon_item_common.png"
	if allianceDesRead.science[sid] then
		fileName = allianceDesRead.science[sid].icon
	end
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function allianceDesRead.getFlg(rankID, fromMemory)
	rankID = tonumber(rankID)
	if fromMemory then
		return "#" .. allianceDesRead.base.rank[rankID].flg
	end
	return allianceDesRead.base.rank[rankID].flg
end
function allianceDesRead.getIcon(rankID, fromMemory)
	rankID = tonumber(rankID)
	if fromMemory then
		return "#" .. allianceDesRead.base.rank[rankID].icon
	end
	return allianceDesRead.base.rank[rankID].icon
end
function allianceDesRead.getCrown(rankID, fromMemory)
	rankID = tonumber(rankID)
	if fromMemory then
		return "#" .. allianceDesRead.base.rank[rankID].crown
	end
	return allianceDesRead.base.rank[rankID].crown
end
function allianceDesRead.getPermissionName(pID)
	pID = tonumber(pID)
	return allianceDesRead.permission[pID] and i18n(allianceDesRead.permission[pID].name) or nil
end
function allianceDesRead.getPermissionDes(pID)
	pID = tonumber(pID)
	return allianceDesRead.permission[pID] and i18n(allianceDesRead.permission[pID].des) or nil
end
function allianceDesRead.getPermissionIcon(pID, fromMemory)
	pID = tonumber(pID)
	if fromMemory then
		return "#" .. allianceDesRead.permission[pID].icon
	end
	return allianceDesRead.permission[pID].icon
end
function allianceDesRead.getManageName(mID)
	mID = tonumber(mID)
	return allianceDesRead.base.manage[mID] and i18n(allianceDesRead.base.manage[mID].name) or nil
end
function allianceDesRead.getManageIcon(mID, fromMemory)
	mID = tonumber(mID)
	if fromMemory then
		return "#" .. allianceDesRead.base.manage[mID].icon
	end
	return allianceDesRead.base.manage[mID].icon
end
function allianceDesRead.getSettingsName(tag)
	tag = tonumber(tag)
	return allianceDesRead.base.settings[tag] and i18n(allianceDesRead.base.settings[tag].name) or nil
end
function allianceDesRead.getSettingsIcon(tag, fromMemory)
	tag = tonumber(tag)
	if fromMemory then
		return "#" .. allianceDesRead.base.settings[tag].icon
	end
	return allianceDesRead.base.settings[tag].icon
end
function allianceDesRead.getFlagIcon(fid, fromMemory)
	if fid == nil then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		fid = allianceMgr:getAllianceProperty("flag")
	end
	fid = tonumber(fid)
	if fid == nil or allianceDesRead.base.flag[fid] == nil then
		fid = 1
	end
	if fromMemory then
		return "#" .. allianceDesRead.base.flag[fid].icon
	end
	return allianceDesRead.base.flag[fid].icon
end
function allianceDesRead.getFlagWithParticle(fid, node)
	if fid == nil then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		fid = allianceMgr:getAllianceProperty("flag")
	end
	fid = tonumber(fid)
	if fid == nil or allianceDesRead.base.flag[fid] == nil then
		fid = 1
	end
	local nodeFlag = SoraDGetAllianceFlagByFid(fid)
	if node then
		nodeFlag:addTo(node, 2)
	end
	return node, nodeFlag
end
function allianceDesRead.getFlagNode(fid)
	if fid == nil then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		fid = allianceMgr:getAllianceProperty("flag")
	end
	fid = tonumber(fid)
	if fid == nil or allianceDesRead.base.flag[fid] == nil then
		fid = 1
	end
	return SoraDGetAllianceFlagByFid(fid)
end
function allianceDesRead.getFlagList(isTeam)
	_UPVALUE15_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	;(nil)[4] = 4
	;(nil)[5] = 5
	;(nil)[6] = 6
	;(nil)[7] = 7
	;(nil)[8] = 8
	;(nil)[9] = 9
	;(nil)[10] = 10
	;(nil)[11] = 11
	;(nil)[12] = 12
	;(nil)[13] = 13
	;(nil)[14] = 14
	local (nil)[15], flagList = 15, nil
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownalliance = allianceMgr:getAlliance()
	if ownalliance and ownalliance:isInBestAllianceTime() then
		table.insert(flagList, 2, 16)
	end
	if isTeam then
		return flagList
	end
	if ownalliance and ownalliance:isMobiBestAlliance() then
		table.insert(flagList, 2, 17)
	end
	if ownalliance then
		local rank = ownalliance:isRamadanMobiTopAlliance()
		if rank ~= nil and rank < 4 then
			table.insert(flagList, 2, 17 + rank)
		end
	end
	return flagList
end
function allianceDesRead.getLanguageName(lid)
	lid = tonumber(lid)
	return allianceDesRead.base.language[lid] and i18n(allianceDesRead.base.language[lid].name) or ""
end
function allianceDesRead.getAllianceConquestWarMigration(showMsg)
	if showMsg == nil then
		showMsg = true
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownalliance = allianceMgr:getAlliance()
	if ownalliance:getProperty("isMigration") then
		if showMsg then
			SoraDShowMsgBox(i18n("common_text_2167"), i18n("common_text_204"))
		end
		return true
	else
		return false
	end
end
function allianceDesRead.getPlayerBattleGroundMigration(showMsg)
	if showMsg == nil then
		showMsg = true
	end
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.getPlayerBattleGroundMigration() then
		if showMsg then
			SoraDShowMsgBox(i18n("common_text_3302"), i18n("common_text_204"))
		end
		return true
	else
		return false
	end
end
function allianceDesRead.getPlayerConquestWarMigration(showMsg)
	if showMsg == nil then
		showMsg = true
	end
	if worldMapDefine.isInKingdomBattle() and not SoraDGetCtrl("conquestWarCtrl"):isHelperInReinforceKingdom() then
		if showMsg then
			SoraDShowMsgBox(i18n("common_text_2166"), i18n("common_text_204"))
		end
		return true
	else
		return false
	end
end
function allianceDesRead.checkRank(needRank, showTip, msg)
	local ret
	needRank = needRank and needRank or gAllianceRank.R4
	local ownRank = allianceDesRead.getOwnRank()
	if ownRank == gAllianceRank.OFFICIAL then
		ownRank = gAllianceRank.R4
	end
	ret = needRank <= ownRank
	if showTip and not ret then
		SoraDShowMsgTip(msg and msg or i18n("notice_0073"))
	end
	return ret
end
function allianceDesRead.getOwnRank()
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	return ownmember:getProperty("rank")
end
function allianceDesRead.getAllianceFlagPrice(flagid)
	local price = 0
	if flagid and allianceDesRead.allianceFlag and allianceDesRead.allianceFlag[flagid] then
		price = allianceDesRead.allianceFlag[flagid].price or 0
	end
	return price
end
function allianceDesRead.checkAlliancePackStatus()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownAlliance = allianceMgr:getAlliance()
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	local isKing = KWKingdomCtrl:isKing() or KWKingdomCtrl:isProxyKing()
	if isKing then
		return true
	end
	if ownAlliance and ownAlliance:getAlliancePackStatus() == gKingPacksStatus.PACKS_GIVE_BEGIN then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local myRank = kingdomMapCtrl:getKingWarRank()
		local packCount = include("KWPacksCell").sharedInstance():getLeftCountByType(myRank)
		_ENV = nil
		;(nil).count = packCount
		SoraDShowMsgTip(i18n("common_text_3210", nil))
		return false
	else
		return true
	end
end
function allianceDesRead.showPyramidPlayoffsTop3(aid, target)
	local btn = SoraDGetChildByName(target, "Button_postSeasonBg")
	local icon = SoraDGetChildByName(target, "Sprite_postSeason")
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	_UPVALUE3_ = gametop.playertop_
	gametop.playertop_[1] = "icon_battlefield_playoff_gold.png"
	gametop.playertop_[2] = "icon_battlefield_playoff_silver.png"
	local gametop.playertop_[3], tableIcon = "icon_battlefield_playoff_cuprum.png", gametop.playertop_
	if btn and icon then
		local rank = pyramidWarCtrl:getPostSeasonTop3Rank(aid)
		if 0 < rank and rank < 4 then
			btn:setVisible(true)
			btn:addTouchEventListener(function(button, type)
				if type == ccui.TouchEventType.ended then
					SoraDPlaySound()
					SoraDCreatePanel("pyramidBattleHonourBoard"):show()
				end
			end)
			icon:setSpriteFrame(tableIcon[rank])
		else
			btn:setVisible(false)
		end
	end
end
function allianceDesRead.getOfficialBg(officialId)
	local config = allianceDesRead.base.officailConfig[officialId]
	if config then
		return config.img
	end
end
function allianceDesRead.getOfficialName(officialId)
	local config = allianceDesRead.base.officailConfig[officialId]
	if config then
		return i18n(config.name)
	end
end
function allianceDesRead.getOfficialDes(officialId)
	local config = allianceDesRead.base.officailConfig[officialId]
	if config then
		return i18n(config.des)
	end
end
function allianceDesRead.getOfficialAttribute(officialId)
	local attribute = ""
	local attributeVal
	local buffDesRead = include("buffDesRead")
	for k, v in ipairs(allianceDesRead.official) do
		if v.official == officialId then
			attribute = buffDesRead.getTitleWithValue(v.attribute[1], v.attribute[2])
			attributeVal = v.attribute
			break
		end
	end
	return attribute, attributeVal
end
function allianceDesRead.getTitleBase(eid, needData)
	eid = tonumber(eid)
	if allianceDesRead.scienceBuff[eid] == nil then
		eid = 1
	end
	local key = allianceDesRead.scienceBuff[eid].title
	if needData then
		return i18n(key), allianceDesRead.scienceBuff[eid]
	else
		return i18n(key)
	end
end
function allianceDesRead.getTitleWithValue(eid, value)
	eid = tonumber(eid)
	local base, data = allianceDesRead.getTitleBase(eid, true)
	if data.effectType == 1 then
		value = allianceDesRead.addSign(value * 100, data.isIncrease) .. "%"
	elseif data.effectType == 2 then
		value = allianceDesRead.addSign(value, data.isIncrease)
	else
		value = allianceDesRead.addSign(value, data.isIncrease)
	end
	_ENV = data.isIncrease
	data.isIncrease.num = ""
	data.isIncrease.char = value
	return i18n("common_text_1470", data.isIncrease)
end
function allianceDesRead.addSign(value, isIncrease)
	if isIncrease == 1 then
		value = "+" .. value
	elseif isIncrease == 2 then
		if value < 0 then
			value = tostring(value)
		else
			value = "-" .. value
		end
	else
		value = tostring(value)
	end
	return value
end
allianceDesRead.landcolor = require_data("alliance_landcolor", true).data
function allianceDesRead.getTerritoryColor(colorId)
	local data = allianceDesRead.landcolor[colorId]
	if data then
		local color = data.color
		return cc.c3b(color[1] * 255, color[2] * 255, color[3] * 255)
	end
end
function allianceDesRead.getManorlineColorArray(...)
	if not allianceDesRead.manorlineColorArray then
		_UPVALUE17_ = allianceDesRead.manorlineColorArray
		allianceDesRead.manorlineColorArray[1] = 0.0
		allianceDesRead.manorlineColorArray[2] = 1.0
		allianceDesRead.manorlineColorArray[3] = 1.0
		allianceDesRead.manorlineColorArray[4] = 1.0
		allianceDesRead.manorlineColorArray[5] = 1.0
		allianceDesRead.manorlineColorArray[6] = 0.0
		allianceDesRead.manorlineColorArray[7] = 1.0
		allianceDesRead.manorlineColorArray[8] = 0.0
		allianceDesRead.manorlineColorArray[9] = 0.0
		allianceDesRead.manorlineColorArray[10] = 0.0
		allianceDesRead.manorlineColorArray[11] = 0.4941
		allianceDesRead.manorlineColorArray[12] = 1.0
		allianceDesRead.manorlineColorArray[13] = 0.98
		allianceDesRead.manorlineColorArray[14] = 0.98
		allianceDesRead.manorlineColorArray[15] = 0.98
		allianceDesRead.manorlineColorArray[16] = 0.65
		allianceDesRead.manorlineColorArray[17] = 0.65
		local allianceDesRead.manorlineColorArray[18], ret = 0.65, allianceDesRead.manorlineColorArray
		for i, v in ipairs(allianceDesRead.landcolor) do
			ret[#ret + 1] = v.color[1]
			ret[#ret + 1] = v.color[2]
			ret[#ret + 1] = v.color[3]
		end
		allianceDesRead.manorlineColorArray = ret
	end
	return allianceDesRead.manorlineColorArray
end
return allianceDesRead
