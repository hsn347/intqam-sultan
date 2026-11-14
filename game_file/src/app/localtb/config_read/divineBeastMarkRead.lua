local divineBeastMarkRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_mark"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_mark", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_mark_lvup"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_mark_lvup", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_mark_starup"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_mark_starup", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_slot"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_slot", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_randombuff"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_randombuff", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_elements"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_elements", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_elements_effect"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_elements_effect", nil)
_UPVALUE1_ = nil
;(nil)[1] = "screening"
divineBeastMarkRead:defineValue("screening", nil)
_UPVALUE1_ = nil
;(nil)[1] = "divine_beast_special_buff"
divineBeastMarkRead:defineValue("divine_beast_special_buff", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_mark_suit_buff"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_mark_suit_buff", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_mark_random_pool"
;(nil)[2] = true
divineBeastMarkRead:defineValue("divine_beast_mark_random_pool", nil)
_UPVALUE1_ = nil
;(nil)[1] = "divine_beast_mark_text_pool"
divineBeastMarkRead:defineValue("divine_beast_mark_text_pool", nil)
divineBeastMarkRead:defineValue("lvCfgs", function()
	local _ENV, lvCfgs
	local _ENV, totalExp
	for i, v in ipairs(divineBeastMarkRead.divine_beast_mark_lvup) do
		if not lvCfgs[v.mark_id] then
			_ENV = lvCfgs[v.mark_id]
		end
		lvCfgs[v.mark_id] = lvCfgs[v.mark_id]
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		lvCfgs[v.mark_id][v.lv] = v
		totalExp[v.mark_id] = totalExp[v.mark_id] or 0
		totalExp[v.mark_id] = totalExp[v.mark_id] + v.exp
		v.totalExp = totalExp[v.mark_id]
	end
	return lvCfgs
end)
divineBeastMarkRead:defineValue("starCfgs", function()
	local _ENV, starCfgs
	for i, v in ipairs(divineBeastMarkRead.divine_beast_mark_starup) do
		starCfgs[v.star] = v
	end
	return starCfgs
end)
divineBeastMarkRead:defineValue("randomBuff", function()
	local _ENV, randomBuff
	for i, v in ipairs(divineBeastMarkRead.divine_beast_randombuff) do
		if not randomBuff[v.BUFF] then
			_ENV = randomBuff[v.BUFF]
		end
		randomBuff[v.BUFF] = randomBuff[v.BUFF]
		if not randomBuff[v.BUFF][v.quality_levle[1]] then
			_ENV = randomBuff[v.BUFF][v.quality_levle[1]]
		end
		randomBuff[v.BUFF][v.quality_levle[1]] = randomBuff[v.BUFF][v.quality_levle[1]]
		randomBuff[v.BUFF][v.quality_levle[1]][v.quality_levle[2]] = v
	end
	return randomBuff
end)
divineBeastMarkRead:defineValue("randomBuffList", function()
	local _ENV, randomBuffList
	for i, v in ipairs(divineBeastMarkRead.divine_beast_randombuff) do
		if not randomBuffList[v.BUFF] then
			randomBuffList[v.BUFF], _ENV = nil, nil
		end
		if not randomBuffList[v.BUFF][v.quality_levle[1]] then
			randomBuffList[v.BUFF][v.quality_levle[1]], _ENV = nil, nil
		end
		if not randomBuffList[v.BUFF][v.quality_levle[1]].name then
			randomBuffList[v.BUFF][v.quality_levle[1]].name = v.introduce
		end
		randomBuffList[v.BUFF][v.quality_levle[1]].maxLv = math.max(randomBuffList[v.BUFF][v.quality_levle[1]].maxLv or 0, v.quality_levle[2])
		randomBuffList[v.BUFF][v.quality_levle[1]][v.quality_levle[2]] = v.value
	end
	return randomBuffList
end)
divineBeastMarkRead:defineValue("filterCfg", function()
	local _ENV, filterCfg
	for i, v in ipairs(divineBeastMarkRead.screening) do
		if not filterCfg[v.type] then
			_ENV = filterCfg[v.type]
		end
		filterCfg[v.type] = filterCfg[v.type]
		table.insert(filterCfg[v.type], v)
	end
	return filterCfg
end)
divineBeastMarkRead:defineValue("elementsEffect", function()
	local _ENV, elementsEffect
	for i, v in ipairs(divineBeastMarkRead.divine_beast_elements_effect) do
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		if not elementsEffect[v.divineID] then
			_ENV = elementsEffect[v.divineID]
		end
		elementsEffect[v.divineID] = elementsEffect[v.divineID]
		if not elementsEffect[v.divineID][v.type] then
			_ENV = elementsEffect[v.divineID][v.type]
		end
		elementsEffect[v.divineID][v.type] = elementsEffect[v.divineID][v.type]
		elementsEffect[v.divineID][v.type][v.lv] = v
	end
	return elementsEffect
end)
divineBeastMarkRead:defineValue("specialBuff", function()
	local _ENV, specialBuff
	for i, v in ipairs(divineBeastMarkRead.divine_beast_special_buff) do
		specialBuff[v.special_buff] = v
	end
	return specialBuff
end)
divineBeastMarkRead:defineValue("suitBuff", function()
	local _ENV, suitBuff
	for i, v in ipairs(divineBeastMarkRead.divine_beast_mark_suit_buff) do
		if not suitBuff[v.divineID] then
			_ENV = suitBuff[v.divineID]
		end
		suitBuff[v.divineID] = suitBuff[v.divineID]
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		table.insert(suitBuff[v.divineID], v)
	end
	return suitBuff
end)
divineBeastMarkRead:defineValue("randomPool", function()
	local _ENV, randomPool
	for i, v in ipairs(divineBeastMarkRead.divine_beast_mark_random_pool) do
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "rate"
		v.pool = serviceFunctions.tableFormat(v.pool, nil)
		randomPool[v.ID] = v
	end
	return randomPool
end)
divineBeastMarkRead:defineValue("textPool", function()
	local _ENV, textPool
	for i, v in ipairs(divineBeastMarkRead.divine_beast_mark_text_pool) do
		textPool[v.ID] = v.pool
	end
	return textPool
end)
divineBeastMarkRead:defineValue("beast_slot", function()
	local _ENV, beastSlot
	for i, v in ipairs(divineBeastMarkRead.divine_beast_slot) do
		if not beastSlot[v.divineID] then
			local _ENV, slots = beastSlot[v.divineID], beastSlot[v.divineID]
		end
		beastSlot[v.divineID] = slots
		slots[#slots + 1] = v.caste
	end
	return beastSlot
end)
function divineBeastMarkRead.getDbMarkCfgs()
	return divineBeastMarkRead.divine_beast_mark
end
function divineBeastMarkRead.getDbMarkCfg(markId)
	return divineBeastMarkRead.divine_beast_mark[tonumber(markId)]
end
function divineBeastMarkRead.getMarkCfgList(type)
	local _ENV, markCfgList
	for i, v in pairs(divineBeastMarkRead.divine_beast_mark) do
		if v.type == type then
			table.insert(markCfgList, v)
		end
	end
	return markCfgList
end
function divineBeastMarkRead.getRandomEffect(buff, quality, lv)
	if buff == 0 or divineBeastMarkRead.randomBuff[buff] == nil then
		return nil
	end
	local randomBuffLvs = divineBeastMarkRead.randomBuff[buff][quality]
	lv = lv or #randomBuffLvs
	local randomEffect = randomBuffLvs[lv]
	return randomEffect
end
function divineBeastMarkRead.getRandomBuffList()
	return divineBeastMarkRead.randomBuffList
end
function divineBeastMarkRead.getElementsEffect(divineID, type, count)
	if count ~= nil then
		local ret
		local isMax = false
		_UPVALUE2_ = nil
		;(nil)[1] = type
		;(nil)[2] = count
		dump(nil, "type, count")
		if not divineBeastMarkRead.elementsEffect[divineID] or not divineBeastMarkRead.elementsEffect[divineID][type] then
			local _ENV, elementEffects = divineBeastMarkRead.elementsEffect[divineID][type], divineBeastMarkRead.elementsEffect[divineID][type]
		end
		for i, v in ipairs(elementEffects) do
			if count >= v.need_elements then
				ret = v
			else
				break
			end
		end
		return ret, ret == elementEffects[#elementEffects]
	else
		return divineBeastMarkRead.elementsEffect[divineID][type]
	end
end
function divineBeastMarkRead.getElementIcon(element)
	return divineBeastMarkRead.divine_beast_elements[element].icon
end
function divineBeastMarkRead.getIcon(markId, fromMemory)
	local dbMarkCfg = divineBeastMarkRead.divine_beast_mark[tonumber(markId)]
	if fromMemory then
		return "#" .. dbMarkCfg.icon
	end
	return dbMarkCfg.icon
end
function divineBeastMarkRead.getName(markId)
	local dbMarkCfg = divineBeastMarkRead.divine_beast_mark[tonumber(markId)]
	return i18n(dbMarkCfg.name)
end
function divineBeastMarkRead.getQuality(markId)
	local dbMarkCfg = divineBeastMarkRead.divine_beast_mark[tonumber(markId)]
	return dbMarkCfg.quality
end
function divineBeastMarkRead.getMarkRandomBuffType(markId)
	local dbMarkCfg = divineBeastMarkRead.divine_beast_mark[tonumber(markId)]
	return dbMarkCfg.randombuff_type
end
function divineBeastMarkRead.getBg(markId)
	local quality = divineBeastMarkRead.getQuality(markId)
	return string.format("frame_item_base_0%d.png", quality + 1)
end
local maxQuality = 4
function divineBeastMarkRead.getMaxQuality()
	return maxQuality
end
function divineBeastMarkRead.getLvCfg(markId, lv)
	local lvCfgs = divineBeastMarkRead.lvCfgs[markId]
	if not lvCfgs then
		return nil
	end
	return lvCfgs[lv]
end
function divineBeastMarkRead.getMaxLv(markId, star)
	local tmpLvCfgs = divineBeastMarkRead.lvCfgs[markId]
	for _, v in ipairs(tmpLvCfgs) do
		if v.need_star == star + 1 then
			return v.lv - 1
		end
	end
	return tmpLvCfgs[#tmpLvCfgs].lv
end
function divineBeastMarkRead.getMaxLvCfg(markId)
	local tmpLvCfgs = divineBeastMarkRead.lvCfgs[markId]
	return tmpLvCfgs[#tmpLvCfgs]
end
function divineBeastMarkRead.getFilterCfg(fType)
	return divineBeastMarkRead.filterCfg[fType]
end
function divineBeastMarkRead.getElementCfg(element)
	return divineBeastMarkRead.divine_beast_elements[element]
end
function divineBeastMarkRead.getElements()
	return divineBeastMarkRead.divine_beast_elements
end
_ENV, divineBeastMarkRead.getElementsSort = function()
	_UPVALUE4_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 3
	;(nil)[3] = 1
	;(nil)[4] = 2
	return nil
end, function()
	_UPVALUE4_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 3
	;(nil)[3] = 1
	;(nil)[4] = 2
	return nil
end
;(function()
	_UPVALUE4_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 3
	;(nil)[3] = 1
	;(nil)[4] = 2
	return nil
end)[1900] = "frame_ssyj_albarq.png"
local (function()
	_UPVALUE4_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 3
	;(nil)[3] = 1
	;(nil)[4] = 2
	return nil
end)[1901], beastSlotIcon = "frame_ssyj_asad.png", function()
	_UPVALUE4_ = nil
	;(nil)[1] = 4
	;(nil)[2] = 3
	;(nil)[3] = 1
	;(nil)[4] = 2
	return nil
end
function divineBeastMarkRead.getBeastSlotIcon(beastId)
	return beastSlotIcon[beastId]
end
function divineBeastMarkRead.getSlotUnlock(divineID, slot)
	return divineBeastMarkRead.beast_slot[divineID][slot] or 0
end
function divineBeastMarkRead.sSplitKey(key)
	if type(key) == "table" then
		if next(key) == nil then
			return nil
		end
		local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
		return divineBeastMarkCtrl:getMarkFromBagDirectly(0, key)
	end
	if key == "" then
		return nil
	end
	local arr = serviceFunctions.split(key, "-")
	local markId = tonumber(arr[1]) or 0
	local level = tonumber(arr[2]) or 0
	local lock = tonumber(arr[3]) or 0
	local randomElem = tonumber(arr[4]) or 0
	local randomBuff1Buff2 = tonumber(arr[5]) or 0
	local randomBuff1 = math.floor(randomBuff1Buff2 / 10000)
	local randomBuff2 = randomBuff1Buff2 % 10000
	local star = tonumber(arr[6]) or 0
	local lvCfg = divineBeastMarkRead.getLvCfg(markId, level)
	local markCfg = divineBeastMarkRead.getDbMarkCfg(markId)
	_ENV = markId
	markId.key = key
	markId.markId = markId
	markId.lv = level
	markId.lock = lock
	markId.star = star
	markId.randomElem = randomElem
	markId.randomBuff1 = randomBuff1
	markId.randomBuff2 = randomBuff2
	markId.randomBuffCfg1 = divineBeastMarkRead.getRandomEffect(randomBuff1, markCfg.quality, level)
	markId.randomBuffCfg2 = divineBeastMarkRead.getRandomEffect(randomBuff2, markCfg.quality, level)
	markId.lvCfg = lvCfg
	markId.isCanChange = lock ~= 1 and markCfg.ChangeSelling_itemid ~= 0
	markId.markCfg = markCfg
	return markId
end
function divineBeastMarkRead.sCombineKey(markId, level, lock, randomElem, randomBuff1, randomBuff2, star)
	_ENV = nil
	;(nil).level = tonumber(level)
	_UPVALUE2_, (nil).markId = tonumber(markId), tonumber(markId)
	;(nil).randomBuffs, tonumber(markId)[1] = tonumber(markId), tonumber(randomBuff1) or 0
	;(nil).randomBuffs, tonumber(markId)[2] = tonumber(markId), tonumber(randomBuff2) or 0
	;(nil).randomElem = tonumber(randomElem) or 0
	local (nil).star, mark = tonumber(star), nil
	return mark
end
function divineBeastMarkRead:getSpecialBuffCfg(buffType)
	return divineBeastMarkRead.specialBuff[buffType]
end
function divineBeastMarkRead.getStarCfg(star)
	return divineBeastMarkRead.starCfgs[star]
end
function divineBeastMarkRead.getMaxStar()
	return divineBeastMarkRead.starCfgs[#divineBeastMarkRead.starCfgs].star
end
function divineBeastMarkRead.getStarByLv(lv)
	local star = 0
	for k, v in ipairs(divineBeastMarkRead.divine_beast_mark_starup) do
		if lv >= v.need_lv then
			star = v.star
		end
	end
	return star
end
function divineBeastMarkRead.getSuitBuffCfgs(quality, divineID)
	local _ENV, list
	if not divineBeastMarkRead.suitBuff[divineID] then
		_ENV = divineBeastMarkRead.suitBuff[divineID]
	end
	for k, v in ipairs(divineBeastMarkRead.suitBuff[divineID]) do
		if v.quality == quality then
			table.insert(list, v)
		end
	end
	return list
end
function divineBeastMarkRead.getSuitBuffList(quality, lv, divineID)
	local _ENV, list
	if not divineBeastMarkRead.suitBuff[divineID] then
		_ENV = divineBeastMarkRead.suitBuff[divineID]
	end
	for k, v in ipairs(divineBeastMarkRead.suitBuff[divineID]) do
		if v.quality == quality and lv >= v.need_lv then
			table.insert(list, v)
		end
	end
	return list
end
function divineBeastMarkRead.getSuitBuffCfg(quality, lv, divineID)
	if not divineBeastMarkRead.suitBuff[divineID] then
		_ENV = divineBeastMarkRead.suitBuff[divineID]
	end
	for k, v in ipairs(divineBeastMarkRead.suitBuff[divineID]) do
		if v.quality == quality and v.need_lv == lv then
			return v
		end
	end
end
function divineBeastMarkRead.getRandomPool(id)
	return divineBeastMarkRead.randomPool[id]
end
function divineBeastMarkRead.getTextPoolText(id)
	return divineBeastMarkRead.textPool[id]
end
function divineBeastMarkRead.getRecycleData(marks, ignoreSelf)
	local constantRead = include("constantRead")
	local recyclePercent = constantRead.getConstValue("DIVINE_BEAST_MARK_EXP_RETAIN")
	local recountNum = 0
	local recountNum2 = 0
	local _ENV, recycleMarkMap
	for k, v in pairs(marks) do
		recountNum = recountNum + v.lvCfg.totalExp
		for i = 1, v.star do
			local starCfg = divineBeastMarkRead.getStarCfg(i)
			local count = recycleMarkMap[v.markId] or 0
			recycleMarkMap[v.markId] = count + starCfg.need_mark
		end
	end
	recountNum = math.floor(recountNum * recyclePercent / 100.0)
	for k, v in pairs(marks) do
		if not ignoreSelf then
			recountNum = recountNum + v.markCfg.exp
			recountNum2 = recountNum2 + v.markCfg.EnergienNum
		end
	end
	local _ENV, recycleMarks = (for generator), pairs(marks)
	for k, v in pairs(recycleMarkMap) do
		_ENV = nil
		;(nil).markId = k
		;(nil).count = v
		table.insert(recycleMarks, nil)
	end
	return recountNum, recountNum2, recycleMarks
end
return divineBeastMarkRead
