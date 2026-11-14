local petDesRead = include("aAReadClass").new()
function petDesRead.init()
	_ENV = nil
	;(nil)[1] = "petdescribe"
	petDesRead:defineValue("base", nil)
	_ENV = nil
	;(nil)[1] = "pet_talk"
	petDesRead:defineValue("talk", nil)
	_ENV = nil
	;(nil)[1] = "pet_skill_describe"
	petDesRead:defineValue("skilldes", nil)
	petDesRead:defineValue("rank", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "icon_pet_ranking_01.png"
		;(nil)[2] = "icon_pet_ranking_02.png"
		;(nil)[3] = "icon_pet_ranking_03.png"
		;(nil)[4] = "icon_pet_ranking_04.png"
		return nil
	end)
	petDesRead:defineValue("bg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1251], (nil).card = nil, nil, "peticon_1251"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1252], (nil).card = nil, nil, "peticon_1252"
		;(nil).normal = "bg_pet_scenery_02.png"
		;(nil).head = "bg_pet_headportrait_01.png"
		_UPVALUE0_, (nil)[1253], (nil).card = nil, nil, "peticon_1253"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1254], (nil).card = nil, nil, "peticon_1254"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1255], (nil).card = nil, nil, "peticon_1255"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1256], (nil).card = nil, nil, "peticon_1256"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1257], (nil).card = nil, nil, "peticon_1257"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1258], (nil).card = nil, nil, "peticon_1258"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1259], (nil).card = nil, nil, "peticon_1259"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1260], (nil).card = nil, nil, "peticon_1260"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1261], (nil).card = nil, nil, "peticon_1261"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1262], (nil).card = nil, nil, "peticon_1262"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1263], (nil).card = nil, nil, "peticon_1263"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1264], (nil).card = nil, nil, "peticon_1264"
		;(nil).normal = "bg_pet_scenery_01.png"
		;(nil).head = "bg_pet_headportrait_02.png"
		_UPVALUE0_, (nil)[1265], (nil).card = nil, nil, "peticon_1265"
		;(nil).normal = "bg_pet_scenery_02.png"
		;(nil).head = "bg_pet_headportrait_01.png"
		_UPVALUE0_, (nil)[1266], (nil).card = nil, nil, "peticon_1266"
		;(nil).normal = "bg_pet_scenery_02.png"
		;(nil).head = "bg_pet_headportrait_01.png"
		_UPVALUE0_, (nil)[1267], (nil).card = nil, nil, "peticon_1267"
		;(nil).normal = "bg_pet_scenery_02.png"
		;(nil).head = "bg_pet_headportrait_01.png"
		;(nil)[1268], (nil).card = nil, "peticon_1268"
		return nil
	end)
	petDesRead:defineValue("petCfg", function()
		local petCfg = require_once("app.localtb.config_read.pet_cfg")
		_ENV = "app.localtb.config_read.pet_cfg"
		;("app.localtb.config_read.pet_cfg")[1251] = petCfg.pet_cfg_horse
		;("app.localtb.config_read.pet_cfg")[1252] = petCfg.pet_cfg_leopard
		;("app.localtb.config_read.pet_cfg")[1253] = petCfg.pet_cfg_eagle
		;("app.localtb.config_read.pet_cfg")[1254] = petCfg.pet_cfg_camel
		;("app.localtb.config_read.pet_cfg")[1255] = petCfg.pet_cfg_wolf
		;("app.localtb.config_read.pet_cfg")[1256] = petCfg.pet_cfg_lion
		;("app.localtb.config_read.pet_cfg")[1257] = petCfg.pet_cfg_caracal
		;("app.localtb.config_read.pet_cfg")[1258] = petCfg.pet_cfg_deer
		;("app.localtb.config_read.pet_cfg")[1259] = petCfg.pet_cfg_elephant
		;("app.localtb.config_read.pet_cfg")[1260] = petCfg.pet_cfg_bear
		;("app.localtb.config_read.pet_cfg")[1261] = petCfg.pet_cfg_eland
		;("app.localtb.config_read.pet_cfg")[1262] = petCfg.pet_cfg_snake
		;("app.localtb.config_read.pet_cfg")[1263] = petCfg.pet_cfg_alpaca
		;("app.localtb.config_read.pet_cfg")[1264] = petCfg.pet_cfg_lizard
		;("app.localtb.config_read.pet_cfg")[1265] = petCfg.pet_cfg_tiger
		;("app.localtb.config_read.pet_cfg")[1266] = petCfg.pet_cfg_horus
		;("app.localtb.config_read.pet_cfg")[1267] = petCfg.pet_cfg_guyanyalong
		petDesRead.petCfg, ("app.localtb.config_read.pet_cfg")[1268] = "app.localtb.config_read.pet_cfg", petCfg.pet_cfg_xingxing
		return petDesRead.petCfg
	end)
	petDesRead:defineValue("sketchPos", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).x = 0
		_UPVALUE0_, (nil)[1251], (nil).y = nil, nil, -10
		;(nil).x = 5
		_UPVALUE0_, (nil)[1252], (nil).y = nil, nil, -5
		;(nil).x = -15
		_UPVALUE0_, (nil)[1253], (nil).y = nil, nil, 0
		;(nil).x = -20
		_UPVALUE0_, (nil)[1254], (nil).y = nil, nil, -10
		;(nil).x = 0
		_UPVALUE0_, (nil)[1255], (nil).y = nil, nil, -5
		;(nil).x = 0
		_UPVALUE0_, (nil)[1256], (nil).y = nil, nil, -5
		;(nil).x = -5
		;(nil)[1257], (nil).y = nil, -5
		return nil
	end)
	petDesRead:defineValue("rankNameCfg", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "pet_text_17"
		;(nil)[2] = "pet_text_18"
		;(nil)[3] = "pet_text_19"
		;(nil)[4] = "pet_text_20"
		return nil
	end)
	petDesRead:defineValue("attrGroupIcon", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "icon_main_powegem.png"
		;(nil)[2] = "icon_passive_skill.png"
		;(nil)[3] = "icon_active_skill.png"
		return nil
	end)
	petDesRead:defineValue("pptOffset", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).x = 0
		_UPVALUE0_, (nil)[1251], (nil).y = nil, nil, 10
		;(nil).x = 0
		_UPVALUE0_, (nil)[1252], (nil).y = nil, nil, 50
		;(nil).x = 0
		_UPVALUE0_, (nil)[1253], (nil).y = nil, nil, 10
		;(nil).x = 0
		_UPVALUE0_, (nil)[1254], (nil).y = nil, nil, 30
		;(nil).x = 0
		_UPVALUE0_, (nil)[1255], (nil).y = nil, nil, 40
		;(nil).x = 0
		_UPVALUE0_, (nil)[1256], (nil).y = nil, nil, 50
		;(nil).x = 0
		_UPVALUE0_, (nil)[1257], (nil).y = nil, nil, 40
		;(nil).x = 0
		_UPVALUE0_, (nil)[1258], (nil).y = nil, nil, 10
		;(nil).x = 0
		_UPVALUE0_, (nil)[1259], (nil).y = nil, nil, 40
		;(nil).x = 0
		_UPVALUE0_, (nil)[1260], (nil).y = nil, nil, 40
		;(nil).x = 0
		_UPVALUE0_, (nil)[1261], (nil).y = nil, nil, 40
		;(nil).x = 0
		_UPVALUE0_, (nil)[1262], (nil).y = nil, nil, 50
		;(nil).x = 0
		;(nil).y = 20
		_UPVALUE0_, (nil)[1263], (nil).scale = nil, nil, 0.7
		;(nil).x = 0
		_UPVALUE0_, (nil)[1264], (nil).y = nil, nil, 30
		;(nil).x = 0
		_UPVALUE0_, (nil)[1265], (nil).y = nil, nil, 30
		;(nil).x = 0
		_UPVALUE0_, (nil)[1266], (nil).y = nil, nil, 30
		;(nil).x = 0
		_UPVALUE0_, (nil)[1267], (nil).y = nil, nil, 30
		;(nil).x = 0
		;(nil)[1268], (nil).y = nil, 30
		return nil
	end)
	petDesRead:defineValue("uiShowCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1251], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1252], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1253], (nil).btnShow = nil, nil, false
		_UPVALUE0_, (nil)[1254], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1255], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1256], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1257], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1258], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1259], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1260], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1261], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1262], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1263], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1264], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1265], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1266], (nil).btnShow = nil, nil, true
		_UPVALUE0_, (nil)[1267], (nil).btnShow = nil, nil, true
		;(nil)[1268], (nil).btnShow = nil, true
		return nil
	end)
end
function petDesRead.getPetPPTOffset(pid)
	if pid then
		if not petDesRead.pptOffset[pid] then
			petDesRead = petDesRead.pptOffset[pid]
			petDesRead.pptOffset[pid].x = 0
			petDesRead.pptOffset[pid].y = 0
		end
		return petDesRead.pptOffset[pid]
	end
end
function petDesRead.getIsNeedShowBtnShow(pid)
	if petDesRead.uiShowCfg[pid] then
		return petDesRead.uiShowCfg[pid].btnShow
	else
		return false
	end
end
function petDesRead.getPetCfg(pid, rank)
	pid = tonumber(pid)
	rank = tonumber(rank)
	if not petDesRead.petCfg[pid] then
		return nil
	end
	return petDesRead.petCfg[pid][rank]
end
function petDesRead.getName(pid)
	pid = tonumber(pid)
	if petDesRead.base[pid] == nil or petDesRead.base[pid].name == nil or i18n(petDesRead.base[pid].name) == nil then
		return "???"
	else
		return i18n(petDesRead.base[pid].name)
	end
end
function petDesRead.getBg(pid)
	pid = tonumber(pid)
	if petDesRead.bg[pid] == nil then
		return "bg_black_01.png"
	else
		return petDesRead.bg[pid].normal
	end
end
function petDesRead.getPetCard(pid, rank)
	rank = rank and rank or 1
	pid = tonumber(pid)
	if petDesRead.bg[pid] == nil then
		return "peticon_1251_01.png"
	else
		local icon = petDesRead.base[pid].icon[rank]
		return icon
	end
end
function petDesRead.getRankName(rank)
	local name = petDesRead.rankNameCfg[rank]
	if not name then
		petDesRead = nil
		;(nil).rank = rank
		;(nil).name = ""
		name = i18n("common_text_2917", nil)
	else
		name = i18n(name)
	end
	return name
end
function petDesRead.getHeadBg(pid)
	pid = tonumber(pid)
	if petDesRead.bg[pid] == nil then
		return "bg_black_01.png"
	else
		return petDesRead.bg[pid].head
	end
end
function petDesRead.getIcon(pid, rank, fromMemory)
	pid = tonumber(pid)
	local fileName = "icon_item_common.png"
	if petDesRead.base[pid] and petDesRead.base[pid].icon and petDesRead.base[pid].icon[rank] then
		fileName = petDesRead.base[pid].icon[rank]
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function petDesRead.getRankIcon(rank, fromMemory)
	rank = tonumber(rank)
	local fileName = "icon_pet_ranking_01.png"
	if petDesRead.rank[rank] then
		fileName = petDesRead.rank[rank]
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function petDesRead.getAttrAdd(data, add, isDifference)
	local ret = 0
	if isDifference then
		ret = add - data.value
	else
		ret = add
	end
	if data.valueType == 1 then
		ret = tostring(ret / 10) .. "%"
	elseif data.valueType == 2 then
		_UPVALUE2_ = data.valueType
		data.valueType[1] = 85
		local data.valueType[2], spArray = 86, data.valueType
		if data.attrType == 36 or data.attrType == 35 then
			ret = SoraDConvertSecondToString(ret)
		elseif SoraDisInList(data.attrType, spArray) then
			ret = string.formatnumberthousands(ret / 1000)
		else
			ret = string.formatnumberthousands(ret)
		end
	end
	return ret
end
function petDesRead.isFly(pid)
	_ENV, pid = tonumber(pid), tonumber(pid)
	local tonumber(pid)[1253], flyPet = true, tonumber(pid)
	if flyPet[pid] then
		return true
	else
		return false
	end
end
function petDesRead.getSkillDesByType(attrType)
	for i, v in ipairs(petDesRead.skilldes) do
		if v.type == attrType then
			return v.des
		end
	end
end
function petDesRead.getAttrStr(data)
	local ret = ""
	if petDesRead.getSkillDesByType(data.attrType) == nil and data.goodid == nil then
		return "error ID: " .. data.attrType .. " value: " .. data.value
	end
	print("data.goodid = ", data.goodid)
	if data.goodid then
		if data.goodid < 9999 then
			petDesRead = data.goodid
			data.goodid.count = string.formatnumberthousands(data.count)
			data.goodid.item = include("resDesRead").getName(data.goodid)
			ret = i18n("common_text_2928", data.goodid)
		else
			petDesRead = data.goodid
			data.goodid.count = string.formatnumberthousands(data.count)
			data.goodid.item = include("itemDesRead").getName(data.goodid)
			ret = i18n("common_text_2928", data.goodid)
		end
	elseif data.valueType == 1 then
		local symbol = " +"
		_UPVALUE7_ = "common_text_2928"
		;("common_text_2928")[1] = 16
		;("common_text_2928")[2] = 24
		;("common_text_2928")[3] = 32
		;("common_text_2928")[4] = 37
		;("common_text_2928")[5] = 39
		;("common_text_2928")[6] = 48
		local ("common_text_2928")[7], deBuffArray = 51, "common_text_2928"
		if SoraDisInList(data.attrType, deBuffArray) then
			symbol = " -"
		end
		ret = i18n(petDesRead.getSkillDesByType(data.attrType)) .. symbol .. tostring(data.value / 10) .. "%"
	elseif data.valueType == 2 then
		_UPVALUE2_ = data.valueType
		data.valueType[1] = 85
		local data.valueType[2], spArray = 86, data.valueType
		if data.attrType == 36 or data.attrType == 35 then
			ret = i18n(petDesRead.getSkillDesByType(data.attrType)) .. " +" .. string.formatnumberthousands(data.value) .. "(s)"
		elseif SoraDisInList(data.attrType, spArray) then
			ret = i18n(petDesRead.getSkillDesByType(data.attrType)) .. " +" .. string.formatnumberthousands(data.value / 1000)
		else
			ret = i18n(petDesRead.getSkillDesByType(data.attrType)) .. " +" .. string.formatnumberthousands(data.value)
		end
	end
	return ret
end
function petDesRead.getAttrStrAndValue(data)
	local ret = ""
	local value = ""
	if petDesRead.getSkillDesByType(data.attrType) == nil and data.goodid == nil then
		return "error ID: " .. data.attrType, data.value
	end
	print("data.goodid = ", data.goodid)
	if data.goodid then
		if data.goodid < 9999 then
			ret = i18n("common_text_4339")
			value = string.format("%sX%s", include("resDesRead").getName(data.goodid), string.formatnumberthousands(data.count))
		else
			ret = i18n("common_text_4339")
			value = string.format("%sX%s", include("itemDesRead").getName(data.goodid), string.formatnumberthousands(data.count))
		end
	elseif data.valueType == 1 then
		local symbol = " +"
		_UPVALUE8_ = "%sX%s"
		;("%sX%s")[1] = 16
		;("%sX%s")[2] = 24
		;("%sX%s")[3] = 32
		;("%sX%s")[4] = 37
		;("%sX%s")[5] = 39
		;("%sX%s")[6] = 48
		;("%sX%s")[7] = 51
		local ("%sX%s")[8], deBuffArray = 52, "%sX%s"
		if SoraDisInList(data.attrType, deBuffArray) then
			symbol = " -"
		end
		ret = i18n(petDesRead.getSkillDesByType(data.attrType))
		value = symbol .. tostring(data.value / 10) .. "%"
	elseif data.valueType == 2 then
		_UPVALUE2_ = data.valueType
		data.valueType[1] = 85
		local data.valueType[2], spArray = 86, data.valueType
		if data.attrType == 36 or data.attrType == 35 then
			ret = i18n(petDesRead.getSkillDesByType(data.attrType))
			value = SoraDConvertSecondToString(data.value)
		elseif SoraDisInList(data.attrType, spArray) then
			ret = i18n(petDesRead.getSkillDesByType(data.attrType))
			value = " +" .. string.formatnumberthousands(data.value / 1000)
		else
			ret = i18n(petDesRead.getSkillDesByType(data.attrType))
			value = " +" .. string.formatnumberthousands(data.value)
		end
	end
	return ret, value
end
function petDesRead.getAttrGroupIcon(attrGroup, fromMemory)
	local fileName = petDesRead.attrGroupIcon[attrGroup]
	if fileName and fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function petDesRead.getPetTalk()
	return petDesRead.talk
end
function petDesRead.getPetSketch(pid)
	if petDesRead.base[pid] then
		return petDesRead.base[pid].shadow
	end
end
function petDesRead.getHasPetHDRes(petid, rank)
	local petCfg = petDesRead.getPetCfg(petid, rank)
	if not petCfg then
		return false
	end
	return true
end
function petDesRead.getSketchPos(pid)
	local sketchPos = petDesRead.sketchPos[pid]
	if not sketchPos then
		return cc.p(0, 0)
	end
	return sketchPos
end
function petDesRead.getOrCreateByShaderName(shaderName)
	local SCM = require("app.shader.shader")
	local macco = "#define USE_SPECULAR_LIGHT"
	_ENV, _ENV = nil, nil
	;(nil).vert = "Shaders/3dPositionTex.vsh"
	_ENV, (nil)["3dColorTexAlphaCutout"], (nil).frag = nil, nil, "Shaders/3dColorTexAlphaCutout.fsh"
	;(nil).isByte = true
	;(nil).vert = macco .. SCM.simpleLightSkinnedVertBytes
	;(nil).SHADER_TYPE_SPECULAR_LIGHT, (nil).frag = nil, macco .. SCM.simpleLightFragBytes
	local shaderCfg
	local cfg = shaderCfg[shaderName] or shaderCfg["3dColorTexAlphaCutout"]
	local shaderCache = cc.GLProgramCache:getInstance()
	local shader = shaderCache:getGLProgram(shaderName)
	if not shader then
		if cfg.isByte then
			shader = cc.GLProgram:createWithByteArrays(cfg.vert, cfg.frag)
		else
			shader = cc.GLProgram:createWithFilenames(cfg.vert, cfg.frag)
		end
		shaderCache:addGLProgram(shader, shaderName)
	end
	return shader
end
petDesRead.init()
return petDesRead
