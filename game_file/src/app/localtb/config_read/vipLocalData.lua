local vipLocalData = include("aAReadClass").new()
function vipLocalData.init()
	vipLocalData.initVipData()
	vipLocalData.initVipLoginData()
	vipLocalData.initVipBuffData()
	vipLocalData.initVipDesData()
end
function vipLocalData.initVipData()
	vipLocalData:defineValue("vipData", function()
		vipLocalData.vipData, vipLocalData = nil, nil
		local vip = require_once("app." .. LocalTblPath .. ".config_server.vip")
		for _, var in ipairs(vip) do
			vipLocalData.vipData[var.level] = var
		end
		return vipLocalData.vipData
	end)
end
function vipLocalData.initVipLoginData()
	vipLocalData:defineValue("vipLoginData", function()
		vipLocalData.vipLoginData, vipLocalData = nil, nil
		local viplogin = require_once("app." .. LocalTblPath .. ".config_server.viplogin")
		for _, var in ipairs(viplogin) do
			vipLocalData.vipLoginData[tostring(var.loginDay)] = var
		end
		return vipLocalData.vipLoginData
	end)
end
function vipLocalData:initVipBuffData()
	vipLocalData:defineValue("vipBuffData", function()
		vipLocalData.vipBuffData, vipLocalData = nil, nil
		local vipbuff = require_once("app." .. LocalTblPath .. ".config_server.vipbuff")
		for _, var in ipairs(vipbuff) do
			vipLocalData.vipBuffData[tostring(var.level)] = var
		end
		return vipLocalData.vipBuffData
	end)
end
function vipLocalData:initVipDesData()
	vipLocalData:defineValue("vipBuffDes", function()
		vipLocalData.vipBuffDes, vipLocalData = nil, nil
		local vipprivilege = require_once("app." .. LocalTblPath .. ".config_client.vipprivilege")
		for _, var in ipairs(vipprivilege) do
			vipLocalData.vipBuffDes[var.id] = var
		end
		return vipLocalData.vipBuffDes
	end)
end
function vipLocalData:getVipCharNode(num)
	local pNode = cc.Node:create()
	local leftRange = 0
	local totalRange = 0
	local anchor = 0
	local pos = 0
	local posImg = 0
	local posImgY = 0
	if num <= 15 then
		local img = "#icon_SVIP_word_01.png"
		local word = display.newSprite(img)
		word:setAnchorPoint(cc.p(1, 0.5))
		word:setPosition(posImg, posImgY)
		word:addTo(pNode)
		local numChar = cc.Label:createWithCharMap("fonts/font_vip.png", 25, 36, 48)
		numChar:setAnchorPoint(cc.p(anchor, 0.5))
		numChar:setPosition(pos, 0)
		numChar:setString(num)
		numChar:addTo(pNode)
		if G_IS_UNITY then
			numChar:setContentSize(cc.size(25, 36))
			numChar:setFontSize(56)
		end
		leftRange = numChar:getContentSize().width + 7
		totalRange = word:getContentSize().width + leftRange
	else
		local img = "#icon_SVIP_word_02.png"
		local word = display.newSprite(img)
		word:setAnchorPoint(cc.p(1, 0.5))
		word:setPosition(posImg, posImgY)
		word:addTo(pNode)
		local numChar = cc.Label:createWithCharMap("fonts/font_svip.png", 25, 36, 48)
		numChar:setAnchorPoint(cc.p(anchor, 0.5))
		numChar:setPosition(pos, 0)
		numChar:setString(num - 15)
		numChar:addTo(pNode)
		if G_IS_UNITY then
			numChar:setContentSize(cc.size(25, 36))
			numChar:setFontSize(56)
		end
		leftRange = numChar:getContentSize().width + 7
		totalRange = word:getContentSize().width + leftRange
	end
	local fpNode = cc.Node:create()
	pNode:addTo(fpNode)
	pNode:setPositionX(totalRange / 2 - leftRange)
	fpNode:setScale(0.8)
	return fpNode
end
function vipLocalData:getVipImg(vipLv, isFromMemory)
	local img
	if vipLv <= 15 then
		img = SoraDFIsRA() and "icon_SVIP_word_01_ar.png" or "icon_SVIP_word_01.png"
	else
		img = SoraDFIsRA() and "icon_SVIP_word_02_ar.png" or "icon_SVIP_word_02.png"
	end
	if isFromMemory then
		img = "#" .. img
	end
	return img
end
function vipLocalData:getSVipIcon()
end
function vipLocalData:getVipNum(num)
	if num <= VIP_SVIP_LV then
		return num, true
	else
		return num - VIP_SVIP_LV, false
	end
end
function vipLocalData:getVipSmallFntChar(num)
	if num <= VIP_SVIP_LV then
		return "VIP" .. num
	else
		return "SVIP" .. tostring(num - VIP_SVIP_LV)
	end
end
function vipLocalData:getVipSmallChar(num)
	if num <= VIP_SVIP_LV then
		return num
	else
		return "S" .. tostring(num - VIP_SVIP_LV)
	end
end
function vipLocalData.getVipPoint(loginDay)
	if "number" == type(loginDay) then
		if 60 < loginDay then
			loginDay = 60
		end
		if vipLocalData.vipLoginData[tostring(loginDay)] then
			local point = vipLocalData.vipLoginData[tostring(loginDay)].point or 0
			local sVipPoint = math.floor(point / gVipToSvipValue)
			return point, sVipPoint
		end
	end
	return 0, 0
end
function vipLocalData.getVipLocalData()
	return vipLocalData.vipData
end
function vipLocalData.queryVipBuffData(vipLevel)
	local vipLocalData, buffRet
	local vipLocalData, buffRetKey
	if vipLocalData.vipData and type(vipLocalData.vipData) == "table" then
		local vipData = vipLocalData.vipData[vipLevel]
		if vipData then
			_UPVALUE3_ = nil
			;(nil)[1] = "buffType"
			;(nil)[2] = "effectType"
			;(nil)[3] = "value"
			buffRet = serviceFunctions.tableFormat(vipData.buffList, nil)
			for k, v in pairs(buffRet) do
				buffRetKey[v.buffType] = v
			end
		end
	end
	return buffRet, buffRetKey
end
function vipLocalData.queryVipBuffDataDif(vipLevel1, vipLevel2)
	local larger1, larger2
	if vipLevel2 <= vipLevel1 then
		larger1 = vipLevel1
		larger2 = vipLevel2
	else
		larger2 = vipLevel1
		larger1 = vipLevel2
	end
	local buff1, buffkey1 = vipLocalData.queryVipBuffData(larger1)
	local buff2, buffkey2 = vipLocalData.queryVipBuffData(larger2)
	local vipLocalData, ret
	for k, v in pairs(buffkey1) do
		local tmpValue = buffkey2[k]
		if tmpValue then
			v.value1 = tmpValue.value
		else
			v.value1 = 0
		end
		local vipShowRank = vipLocalData.vipBuffDes[v.buffType]
		if vipShowRank then
			v.rank = vipShowRank.rank
		else
			v.rank = 999
		end
	end
	return buffkey1
end
function vipLocalData.queryVipBuffDataDifNew(nowlv, bigLv)
	bigLv = bigLv or nowlv
	local buff1, buffkey1 = vipLocalData.queryVipBuffData(bigLv)
	local buff2, buffkey2 = vipLocalData.queryVipBuffData(nowlv)
	local vipLocalData, ret
	for _, v in pairs(buffkey1) do
		local cfg = buffkey2[v.buffType]
		if cfg then
			v.addValue = v.value - cfg.value
			v.isNew = false
			v.weight = 1
		else
			v.addValue = v.value
			v.isNew = true
			v.weight = 0
		end
		local vipShowRank = vipLocalData.vipBuffDes[v.buffType]
		if vipShowRank then
			v.rank = vipShowRank.rank
		else
			v.rank = 999
		end
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		if a.weight ~= b.weight then
			return a.weight < b.weight
		end
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		if a.buffType ~= b.buffType then
			return a.buffType < b.buffType
		end
	end)
	return ret
end
function vipLocalData.getVipPointShowData(vipPoint, maxVipLevel)
	local beginPoint = 0
	local endPoint = 0
	local vipLevel = 0
	local totalPoint = 0
	local completePoint = 0
	vipPoint = vipPoint or 0
	if vipLocalData.vipData and type(vipLocalData.vipData) == "table" then
		for k, v in pairs(vipLocalData.vipData) do
			if vipPoint >= v.point and vipLevel <= v.level and maxVipLevel >= v.level then
				vipLevel = v.level
				beginPoint = v.point
				if vipLocalData.vipData[v.level + 1] then
					endPoint = vipLocalData.vipData[v.level + 1].point
					totalPoint = endPoint
				else
					endPoint = v.point + v.point - vipLocalData.vipData[v.level - 1].point
					totalPoint = endPoint
				end
				completePoint = vipPoint - beginPoint
			end
		end
	end
	if 15 <= vipLevel then
		beginPoint = 3000000
		endPoint = totalPoint
		completePoint = vipPoint - beginPoint
	else
		beginPoint = 0
		endPoint = totalPoint
		completePoint = vipPoint - beginPoint
	end
	print("getVipPointShowData", beginPoint, endPoint, completePoint, vipLevel, vipPoint)
	return beginPoint, endPoint, completePoint, vipLevel
end
function vipLocalData.transPointVip2Svip(point)
	point = tonumber(point)
	return math.floor(point / 3)
end
function vipLocalData.getVipMaxPoint(vipLevel)
	if vipLocalData.vipData[vipLevel] then
		return vipLocalData.vipData[vipLevel].point
	end
	return 0
end
function vipLocalData.vip2kLevel(vlv)
	return vipLocalData.vipData[vlv].kingdomLv
end
function vipLocalData.getMaxVipLev(curServerLev)
	local maxLev = 15
	if vipLocalData.vipData then
		local i = 1
		for i = 15, #vipLocalData.vipData do
			if vipLocalData.vipData[i] and curServerLev >= vipLocalData.vipData[i].kingdomLv and maxLev < vipLocalData.vipData[i].level then
				maxLev = vipLocalData.vipData[i].level
			end
		end
	end
	print("getMaxVipLev", curServerLev, maxLev)
	return maxLev
end
vipLocalData.init()
return vipLocalData
