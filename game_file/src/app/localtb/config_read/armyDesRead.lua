local armyDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	armyDesRead = nil
	;(nil)[1] = "armymodel"
	armyDesRead:defineValue("tableArmyModel", nil)
	armyDesRead = nil
	;(nil)[1] = "specialitydescribe"
	armyDesRead:defineValue("tableArmySkill", nil)
	armyDesRead:defineValue("armyInfoMap", function()
		local tableArmyInfo = require("app." .. LocalTblPath .. ".config_server.armyinfo")
		local _ENV, armyInfoMap = "app." .. LocalTblPath .. ".config_server.armyinfo", "app." .. LocalTblPath .. ".config_server.armyinfo"
		for k, v in pairs(tableArmyInfo) do
			armyInfoMap[v.armyID] = v.freeWeight
		end
		return armyInfoMap
	end)
	armyDesRead:defineValue("specailArmyConfig", function()
		_ENV, _ENV, _ENV = nil, nil, nil
		;(nil).spine = "spine/soldiersV4/11bubing.skel"
		_ENV, (nil)[110], (nil).pos = nil, nil, cc.p(0, 55)
		;(nil).spine = "spine/soldiersV4/11_5bubing.skel"
		_ENV, (nil)[115], (nil).pos = nil, nil, cc.p(-20, 20)
		;(nil).spine = "spine/soldiersV4/12bubing.skel"
		_ENV, (nil)[120], (nil).pos = nil, nil, cc.p(0, 10)
		;(nil).spine = "spine/soldiersV4/12_5bubing.skel"
		_ENV, (nil)[125], (nil).pos = nil, nil, cc.p(0, 0)
		;(nil).spine = "spine/soldiersV4/13bubing.skel"
		_ENV, (nil)[130], (nil).pos = nil, nil, cc.p(0, 30)
		;(nil).spine = "spine/soldiersV4/13bubing.skel"
		_ENV, (nil)[135], (nil).pos = nil, nil, cc.p(0, 30)
		;(nil).spine = "spine/soldiersV4/14bubing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 0, cc.p(0, 10), cc.p(0, 10)
		_ENV, (nil)[140], (nil).prefabCfg, cc.p(0, 10).futoutexiao, (0)[1] = nil, nil, cc.p(0, 10), 0, "fx_14bubing_01"
		;(nil).spine = "spine/soldiersV4/14bubing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 0, cc.p(0, 10), cc.p(0, 10)
		_ENV, _ENV, (nil).infantry, (nil)[145], (nil).prefabCfg, cc.p(0, 10).futoutexiao, (0)[1] = nil, nil, nil, nil, cc.p(0, 10), 0, "fx_14bubing_01"
		;(nil).spine = "spine/soldiersV4/11qibing.skel"
		_ENV, (nil)[110], (nil).pos = nil, nil, cc.p(-70, 15)
		;(nil).spine = "spine/soldiersV4/11_5qibing.skel"
		_ENV, (nil)[115], (nil).pos = nil, nil, cc.p(10, -15)
		;(nil).spine = "spine/soldiersV4/12qibing.skel"
		_ENV, (nil)[120], (nil).pos = nil, nil, cc.p(-65, 10)
		;(nil).spine = "spine/soldiersV4/12_5qibing.skel"
		_ENV, (nil)[125], (nil).pos = nil, nil, cc.p(-5, 15)
		;(nil).spine = "spine/soldiersV4/13qibing.skel"
		_ENV, (nil)[130], (nil).pos = nil, nil, cc.p(30, -60)
		;(nil).spine = "spine/soldiersV4/13qibing.skel"
		_ENV, (nil)[135], (nil).pos = nil, nil, cc.p(30, -60)
		;(nil).spine = "spine/soldiersV4/14qibing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 45, cc.p(45, 60), cc.p(45, 60)
		_UPVALUE1_, cc.p(45, 60).xiongzuoshou4, (45)[1] = 45, 45, "fx_14qibing_02"
		_UPVALUE1_, cc.p(45, 60).bone17, (45)[1] = 45, 45, "fx_14qibing_01"
		_UPVALUE1_, cc.p(45, 60).bone18, (45)[1] = 45, 45, "fx_14qibing_01"
		_ENV, (nil)[140], (nil).prefabCfg, cc.p(45, 60).bone19, (45)[1] = nil, nil, cc.p(45, 60), 45, "fx_14qibing_01"
		;(nil).spine = "spine/soldiersV4/14qibing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 45, cc.p(45, 60), cc.p(45, 60)
		_UPVALUE1_, cc.p(45, 60).xiongzuoshou4, (45)[1] = 45, 45, "fx_14qibing_02"
		_UPVALUE1_, cc.p(45, 60).bone17, (45)[1] = 45, 45, "fx_14qibing_01"
		_UPVALUE1_, cc.p(45, 60).bone18, (45)[1] = 45, 45, "fx_14qibing_01"
		_ENV, _ENV, (nil).cavalry, (nil)[145], (nil).prefabCfg, cc.p(45, 60).bone19, (45)[1] = nil, nil, nil, nil, cc.p(45, 60), 45, "fx_14qibing_01"
		;(nil).spine = "spine/soldiersV4/11gongbing.skel"
		_ENV, (nil)[110], (nil).pos = nil, nil, cc.p(0, 10)
		;(nil).spine = "spine/soldiersV4/11_5gongbing.skel"
		_ENV, (nil)[115], (nil).pos = nil, nil, cc.p(-5, -25)
		;(nil).spine = "spine/soldiersV4/12gongbing.skel"
		_ENV, (nil)[120], (nil).pos = nil, nil, cc.p(0, 15)
		;(nil).spine = "spine/soldiersV4/12_5gongbing.skel"
		_ENV, (nil)[125], (nil).pos = nil, nil, cc.p(0, 20)
		;(nil).spine = "spine/soldiersV4/13gongbing.skel"
		_ENV, (nil)[130], (nil).pos = nil, nil, cc.p(-35, 25)
		;(nil).spine = "spine/soldiersV4/13gongbing.skel"
		_ENV, (nil)[135], (nil).pos = nil, nil, cc.p(-35, 25)
		;(nil).spine = "spine/soldiersV4/14gongbing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 0, cc.p(0, 50), cc.p(0, 50)
		_ENV, (nil)[140], (nil).prefabCfg, cc.p(0, 50).bone18, (0)[1] = nil, nil, cc.p(0, 50), 0, "fx_14gongbing_01"
		;(nil).spine = "spine/soldiersV4/14gongbing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 0, cc.p(0, 50), cc.p(0, 50)
		_ENV, _ENV, (nil).archer, (nil)[145], (nil).prefabCfg, cc.p(0, 50).bone18, (0)[1] = nil, nil, nil, nil, cc.p(0, 50), 0, "fx_14gongbing_01"
		;(nil).spine = "spine/soldiersV4/11chebing.skel"
		_ENV, (nil)[110], (nil).pos = nil, nil, cc.p(32, 33)
		;(nil).spine = "spine/soldiersV4/11_5chebing.skel"
		_ENV, (nil)[115], (nil).pos = nil, nil, cc.p(50, 0)
		;(nil).spine = "spine/soldiersV4/12chebing.skel"
		_ENV, (nil)[120], (nil).pos = nil, nil, cc.p(0, 33)
		;(nil).spine = "spine/soldiersV4/12_5chebing.skel"
		_ENV, (nil)[125], (nil).pos = nil, nil, cc.p(13, 30)
		;(nil).spine = "spine/soldiersV4/13chebing.skel"
		_ENV, (nil)[130], (nil).pos = nil, nil, cc.p(45, 30)
		;(nil).spine = "spine/soldiersV4/13chebing.skel"
		_ENV, (nil)[135], (nil).pos = nil, nil, cc.p(45, 30)
		;(nil).spine = "spine/soldiersV4/14chebing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 45, cc.p(45, 30), cc.p(45, 30)
		_UPVALUE1_, cc.p(45, 30).beikuijia, (45)[1] = 45, 45, "fx_14chebing_01"
		_UPVALUE1_, cc.p(45, 30).bone12, (45)[1] = 45, 45, "fx_14chebing_02"
		_UPVALUE1_, cc.p(45, 30).bone10, (45)[1] = 45, 45, "fx_14chebing_03"
		_UPVALUE1_, cc.p(45, 30).bone9, (45)[1] = 45, 45, "fx_14chebing_05"
		_ENV, (nil)[140], (nil).prefabCfg, cc.p(45, 30).bone11, (45)[1] = nil, nil, cc.p(45, 30), 45, "fx_14chebing_06"
		;(nil).spine = "spine/soldiersV4/14chebing.skel"
		_UPVALUE1_, _ENV, (nil).pos = 45, cc.p(45, 30), cc.p(45, 30)
		_UPVALUE1_, cc.p(45, 30).beikuijia, (45)[1] = 45, 45, "fx_14chebing_01"
		_UPVALUE1_, cc.p(45, 30).bone12, (45)[1] = 45, 45, "fx_14chebing_02"
		_UPVALUE1_, cc.p(45, 30).bone10, (45)[1] = 45, 45, "fx_14chebing_03"
		_UPVALUE1_, cc.p(45, 30).bone9, (45)[1] = 45, 45, "fx_14chebing_05"
		;(nil).charists, (nil)[145], (nil).prefabCfg, cc.p(45, 30).bone11, (45)[1] = nil, nil, cc.p(45, 30), 45, "fx_14chebing_06"
		return nil
	end)
	armyDesRead:defineValue("tableArmyTypeName", function()
		_ENV = nil
		;(nil)[tostring(BUILDID.CHARIOT_PLANT)] = i18n("common_text_143")
		;(nil)[tostring(BUILDID.STABLES)] = i18n("common_text_144")
		;(nil)[tostring(BUILDID.RANGE)] = i18n("common_text_145")
		;(nil)[tostring(BUILDID.BARRACKS)] = i18n("common_text_146")
		return nil
	end)
	armyDesRead:defineValue("armybattlelogshow", function()
		armyDesRead.armybattlelogshow, armyDesRead = nil, nil
		local _t = require("app." .. LocalTblPath .. ".config_client.armybattlelogshow")
		for _, v in ipairs(_t) do
			if not armyDesRead.armybattlelogshow[v.armyType] then
				armyDesRead.armybattlelogshow[v.armyType], armyDesRead = nil, nil
			end
			armyDesRead.armybattlelogshow[v.armyType][v.ifStar] = v.armyBattleShow
		end
		return armyDesRead.armybattlelogshow
	end)
end
function armyDesRead.getName(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return i18n(ADFD.data[aid].armyName)
end
function armyDesRead.getDes(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return i18n(ADFD.data[aid].armyDes)
end
function armyDesRead.getTip(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return i18n(ADFD.data[aid].tip)
end
function armyDesRead.getBg(iid)
	return "frame_item_base_01.png"
end
function armyDesRead.getCostFood(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return ADFD.data[aid].costFood
end
function armyDesRead.getSkill(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return ADFD.data[aid].speciality
end
function armyDesRead.getLvImg(aid, fromMemory)
	aid = tonumber(aid)
	local armyLogic = include("armyLogic")
	local alv = armyLogic.getArmyLV(aid)
	if fromMemory then
		if alv == 13 then
			return "#icon_army_armour_01.png"
		elseif alv == 14 then
			return "#icon_army_armour_02.png"
		else
			return "#" .. (SoraDFIsRA() and "icon_army_level_" or "icon_army_level_Roman_") .. alv .. ".png"
		end
	end
	if alv == 13 then
		return "icon_army_armour_01.png"
	elseif alv == 14 then
		return "icon_army_armour_02.png"
	else
		return (SoraDFIsRA() and "icon_army_level_" or "icon_army_level_Roman_") .. alv .. ".png"
	end
end
function armyDesRead.getTrapLvImg(aid, fromMemory)
	aid = tonumber(aid)
	local armyLogic = include("armyLogic")
	local alv = armyLogic.getTrapLV(aid)
	if fromMemory then
		return "#" .. (SoraDFIsRA() and "icon_army_level_" or "icon_army_level_Roman_") .. alv .. ".png"
	end
	return (SoraDFIsRA() and "icon_army_level_" or "icon_army_level_Roman_") .. alv .. ".png"
end
function armyDesRead:getArmyDesCfg(factionId)
	local factionCtrl = SoraDGetCtrl("factionCtrl")
	local factionId = factionId or factionCtrl:getFactionId()
	local ADFD
	if factionId == FACTION_TYPE.FACTION_NORMAL then
		ADFD = require_data("armydescribe")
	else
		local alias = factionCtrl:getFactionAlias(factionId)
		ADFD = require_data("army_describe_" .. alias)
	end
	return ADFD
end
function armyDesRead.getPortrait(aid, fromMemory)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	if fromMemory then
		return "#" .. ADFD.data[aid].armyPic
	end
	return ADFD.data[aid].armyPic
end
function armyDesRead.getStarchange(aid)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	return ADFD.data[aid].starchange
end
function armyDesRead.getIcon(aid, fromMemory)
	aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg()
	if fromMemory then
		return "#" .. ADFD.data[aid].armySmallPic
	end
	return ADFD.data[aid].armySmallPic
end
function armyDesRead.getWarLv(aid)
	aid = tonumber(aid)
	local warLv = math.floor(aid / 1000)
	if warLv ~= 0 then
		warLv = warLv % 10000 + 1
	end
	return warLv
end
function armyDesRead.getModelType(aid, factionId)
	local aid = tonumber(aid)
	local ADFD = armyDesRead.getArmyDesCfg(factionId)
	return ADFD.data[aid].modelType
end
function armyDesRead.getModelImage(armyModel, factionId)
	local factionId = factionId or SoraDGetCtrl("factionCtrl"):getFactionId()
	local armyModel = tonumber(armyModel)
	local modelId = armyModel + FACTION_MODEL_IMGID_OFFSET[factionId]
	if armyDesRead.tableArmyModel[modelId] then
		return armyDesRead.tableArmyModel[modelId].modelImage
	end
	return armyDesRead.tableArmyModel[armyModel].modelImage
end
function armyDesRead.getSkillIcon(sid)
	sid = tonumber(sid)
	return armyDesRead.tableArmySkill[sid] and armyDesRead.tableArmySkill[sid].specialityPic or nil, ccui.TextureResType.plistType
end
function armyDesRead.getSkillName(sid)
	sid = tonumber(sid)
	_ENV = nil
	;(nil).lv = armyDesRead.getSkillLv(sid)
	return i18n(armyDesRead.tableArmySkill[sid].specialityName, nil)
end
function armyDesRead.getSkillDes(sid)
	sid = tonumber(sid)
	return i18n(armyDesRead.tableArmySkill[sid].specialityDes)
end
function armyDesRead.getSkillLv(sid)
	sid = tonumber(sid)
	return armyDesRead.tableArmySkill[sid].specialityLv
end
function armyDesRead.getFreeWeight(sid)
	sid = tonumber(sid)
	return armyDesRead.armyInfoMap[sid]
end
function armyDesRead.getFreeWeightAndSp(sid, extraAdd)
	local armyltCtrl = include("armyltCtrl")
	sid = tonumber(sid)
	local fW = armyltCtrl.getArmyAttrAndSp(sid, ARMY_ATTR.FREE_WEIGHT, extraAdd)
	return fW
end
function armyDesRead.getBuildID(aid)
	aid = tonumber(aid)
	local armyLogic = include("armyLogic")
	_UPVALUE6_ = "armyLogic"
	;("armyLogic")[1] = BUILDID.STABLES
	;("armyLogic")[2] = BUILDID.RANGE
	;("armyLogic")[3] = BUILDID.CHARIOT_PLANT
	;("armyLogic")[4] = BUILDID.BARRACKS
	;("armyLogic")[5] = BUILDID.FORTRESS
	local ("armyLogic")[6], bidList = BUILDID.ELITE_PALACE, "armyLogic"
	for i, v in ipairs(bidList) do
		if armyLogic.armyIdMatchBid(v, aid) then
			return v
		end
	end
	return BUILDID.STABLES
end
function armyDesRead.getArmyTpyeName(bid)
	return armyDesRead.tableArmyTypeName[tostring(bid)]
end
function armyDesRead.getSpecialArmyCfg(armyID, isSpine)
	local armyLv = serviceFunctions.getArmyViewLev(armyID)
	local armyClass = serviceFunctions.getArmyClassByArmyId(armyID)
	print("armyClass,armyLv=====", armyClass, armyLv)
	local spine
	if isSpine then
		local spineInfo = armyDesRead.specailArmyConfig[armyClass][armyLv]
		if spineInfo then
			local atlasPath = string.gsub(spineInfo.spine, "%.%w+$", ".atlas")
			spine = sp.SkeletonAnimation:create(spineInfo.spine, atlasPath, 1)
			spine:setPosition(spineInfo.pos.x, -spineInfo.pos.y)
		end
	end
	return armyDesRead.specailArmyConfig[armyClass] and armyDesRead.specailArmyConfig[armyClass][armyLv], spine
end
armyDesRead:defineValue("npc", function()
	local _ENV, config
	local npc = require_data("npc", true).data
	for i, v in ipairs(npc) do
		config[v.id] = v
	end
	return config
end)
function armyDesRead.getNpcArmy(npcId, keys)
