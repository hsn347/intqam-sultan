local achiDesRead = include("aAReadClass").new()
achiDesRead.isInit = false
function achiDesRead.init()
	if achiDesRead.isInit then
		return
	end
	achiDesRead.isInit = true
	_UPVALUE1_ = nil
	;(nil)[1] = "achievement_info"
	achiDesRead:defineValue("achievement", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "medal_type"
	achiDesRead:defineValue("medal", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "medal_buff_type"
	achiDesRead:defineValue("medalBuff", nil)
end
achiDesRead.init()
function achiDesRead.getInfoById(id)
	if achiDesRead.achievement[id] then
		return achiDesRead.achievement[id]
	else
		achiDesRead = achiDesRead.achievement[id]
		return achiDesRead.achievement[id]
	end
end
function achiDesRead.getMedalById(id)
	local ret = "common_text_1437"
	if achiDesRead.medal[id] then
		ret = achiDesRead.medal[id]
	end
	return ret
end
function achiDesRead.getTheFirstBuff(id)
	local str = ""
	local index = 0
	local baseID = math.floor(id / 1000) * 1000
	for i = 1, 20 do
		local info = achiDesRead.getInfoById(baseID + i)
		if info.medalBuff and next(info.medalBuff) ~= nil then
			str = achiDesRead.getMedalBuffStr(info.medalBuff)
			index = i
			break
		end
	end
	return str, index
end
function achiDesRead.isTheLastAchi(id)
	id = tonumber(id)
	if achiDesRead.achievement[id + 1] then
		return false
	else
		return true
	end
end
function achiDesRead.getTheNextDiffBuff(id)
	local str = ""
	local tmpBuffArg = achiDesRead.getInfoById(id).medalBuff[2]
	local index = 0
	local baseID = id
	for i = 1, 20 do
		local curID = baseID + i
		local info = achiDesRead.getInfoById(curID)
		if info.medalBuff and next(info.medalBuff) ~= nil and tmpBuffArg ~= info.medalBuff[2] then
			str = achiDesRead.getMedalBuffStr(info.medalBuff)
			index = curID - math.floor(curID / 1000) * 1000
			break
		end
	end
	return str, index
end
function achiDesRead.getMedalBuffStr(tbl)
	if next(tbl) ~= nil then
		local _id = tbl[1]
		local _value = tbl[2]
		if not achiDesRead.medalBuff[_id] then
			local _ENV, buffTbl = achiDesRead.medalBuff[_id], achiDesRead.medalBuff[_id]
		end
		if 1 == buffTbl.buffType then
			_ENV = nil
			;(nil).value = _value / 10
			return i18n(buffTbl.lang, nil)
		elseif 2 == buffTbl.buffType then
			local castleSkinRead = include("castleSkinRead")
			print("_value", _value)
			print("castleSkinRead.getEffectName(_value)", castleSkinRead.getName(_value))
			return castleSkinRead.getName(_value)
		elseif 3 == buffTbl.buffType then
			local marchRead = include("marchRead")
			print("_value", _value)
			print("marchRead.getEffectName(_value)", marchRead.getEffectName(_value))
			return i18n(marchRead.getEffectName(_value))
		else
			_ENV = marchRead.getEffectName(_value)
			marchRead.getEffectName(_value).value = _value
			return i18n(buffTbl.lang, marchRead.getEffectName(_value))
		end
	else
		return ""
	end
end
function achiDesRead.getBuffStrByID(id, star)
	local reStr = ""
	function getFatherNum(id)
		return math.floor(id / 1000) * 1000
	end
	if achiDesRead.achievement[id] then
		local max = achiDesRead.achievement[id].totalSection
		local default = getFatherNum(id)
		for i = 1, max do
			local curID = default + i
			local recordInfo = achiDesRead.achievement[curID]
			if 1 < table.nums(recordInfo.medalBuff) and i == star then
				_ENV = nil
				;(nil).num = recordInfo.section
				;(nil).str = achiDesRead.getMedalBuffStr(recordInfo.medalBuff)
				reStr = i18n("common_text_1980", nil)
				break
			end
		end
	end
	return reStr
end
function achiDesRead.getBuffListStrByID(id)
	local reStr = ""
	function getFatherNum(id)
		return math.floor(id / 1000) * 1000
	end
	if achiDesRead.achievement[id] then
		local max = achiDesRead.achievement[id].totalSection
		local default = getFatherNum(id)
		for i = 1, max do
			local curID = default + i
			local recordInfo = achiDesRead.achievement[curID]
			if 1 < table.nums(recordInfo.medalBuff) then
				_ENV = nil
				;(nil).num = recordInfo.section
				;(nil).str = achiDesRead.getMedalBuffStr(recordInfo.medalBuff)
				reStr = reStr .. i18n("common_text_1980", nil) .. "\n"
			end
		end
	end
	return reStr
end
function achiDesRead.getBuffListTblByID(id)
	local achiDesRead, ret
	if achiDesRead.achievement[id] then
		local max = achiDesRead.achievement[id].totalSection
		local default = math.floor(id / 1000) * 1000
		for i = 1, max do
			local curID = default + i
			local recordInfo = achiDesRead.achievement[curID]
			if 1 < table.nums(recordInfo.medalBuff) then
				local strText, val = achiDesRead.getMedalBuffStr(recordInfo.medalBuff)
				achiDesRead = nil
				achiDesRead = nil
				;(nil).num = recordInfo.section
				;(nil).str = strText
				;(nil).des = i18n("common_text_1980", nil)
				;(nil).section = recordInfo.section
				table.insert(ret, nil)
			end
		end
	end
	return ret
end
function achiDesRead.getMedalPic(_id, _isLight)
	local imgFile = ""
	if achiDesRead.medal[_id] then
		imgFile = achiDesRead.medal[_id].medalPicture
	else
		imgFile = "alliance_science_32001.png"
	end
	return display.newSprite("#" .. imgFile)
end
function achiDesRead.getAllStarCount()
	return table.nums(achiDesRead.achievement)
end
function achiDesRead.getShowMedalPic(achiID, showID, curStar, isShowEffect, isOther)
	local medalObj = include("medalSingle").new()
	showID = showID == 0 and 9003001 or showID
	achiID = achiID == 0 and 5301003 or achiID
	local maxCur = achiDesRead.getInfoById(achiID).totalSection
	local curStar = curStar or achiID - math.floor(achiID / 1000) * 1000
	medalObj:setAchiListModel()
	_ENV = nil
	;(nil).medalID = showID
	;(nil).star = curStar
	medalObj:initData(nil, nil, isShowEffect, isOther)
	return medalObj
end
function achiDesRead.getShowMedalNode(achiID, showID, curStar, isShowEffect, isOther)
	local medalObj = include("medalSingle").new()
	showID = showID == 0 and 9003001 or showID
	achiID = achiID == 0 and 5301003 or achiID
	local maxCur = achiDesRead.getInfoById(achiID).totalSection
	local curStar = curStar or achiID - math.floor(achiID / 1000) * 1000
	_ENV = nil
	;(nil).medalID = showID
	;(nil).star = curStar
	medalObj:initData(nil, nil, isShowEffect, isOther)
	return medalObj
end
function achiDesRead.getSelfShowMedalPic()
	local achiID = 5301003
	local showID = 9003001
	local gametop = gModuleMgr.getObject("gametop")
	local achievementctrl = gametop.playertop_:getModule("achievementctrl")
	local tmpTbl = achievementctrl:getAchievementInfo()
	dump(tmpTbl.showMetalID, "tmpTbl.showMetalID")
	if tmpTbl.showMetalID ~= 0 then
		showID = tmpTbl.showMetalID
	end
	if tmpTbl.showAchieveID ~= 0 then
		achiID = tmpTbl.showAchieveID
	end
	return achiDesRead.getShowMedalPic(achiID, showID)
end
function achiDesRead.getAchiCompleteness(...)
	local gametop = gModuleMgr.getObject("gametop")
	local achievementctrl = gametop.playertop_:getModule("achievementctrl")
	local tmpTbl = achievementctrl:getAchievementData()
	local totalCount = 0
	local count = 0
	for i, v in ipairs(tmpTbl) do
		if v.id then
			totalCount = totalCount + achiDesRead.getInfoById(v.id).totalSection
		end
		if v.maxDoneID ~= 0 then
			count = count + (v.maxDoneID - math.floor(v.maxDoneID / 1000) * 1000)
		end
	end
	print("totalCount", totalCount)
	print("count", count)
	return math.floor(count / totalCount * 100)
end
function achiDesRead.getMedalCount(...)
	local gametop = gModuleMgr.getObject("gametop")
	local achievementctrl = gametop.playertop_:getModule("achievementctrl")
	local tmpTbl = achievementctrl:getAchievementData()
	local count = 0
	for i, v in ipairs(tmpTbl) do
		if v.maxDoneID ~= 0 and v.maxDoneID - math.floor(v.maxDoneID / 1000) * 1000 >= 3 then
			count = count + 1
		end
	end
	return count
end
function achiDesRead.getShowMedalEffectNode(_id, isGray)
	local csbName = string.format("Node_medal_%d", _id)
	if not isGray and getCCSPath(csbName) then
		local node = SoraDCreatAnimation(csbName)
		node:setName("Node_medal_effect")
		local medalImg = achiDesRead.getMedalPic(_id)
		medalImg:setName("Node_medal")
		local Node_image = SoraDGetChildByName(node, "Node_image")
		if Node_image then
			medalImg:addTo(Node_image)
		else
			medalImg:addTo(node, -1)
		end
		return node
	else
		print("no effect csb, id =", _id)
		local node = display.newNode()
		node:setName("Node_medal_effect")
		local medalImg = achiDesRead.getMedalPic(_id)
		medalImg:setName("Node_medal")
		medalImg:addTo(node)
		return node
	end
end
return achiDesRead
