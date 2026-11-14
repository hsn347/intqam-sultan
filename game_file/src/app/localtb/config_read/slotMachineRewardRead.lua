local slotMachineRewardRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "slot_machine_reward"
	;(nil)[2] = true
	slotMachineRewardRead:defineValue("reward", nil)
	slotMachineRewardRead:defineValue("imgList", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "icon_slotmachine_A.png"
		;(nil)[2] = "icon_slotmachine_B.png"
		;(nil)[3] = "icon_slotmachine_C.png"
		;(nil)[4] = "icon_slotmachine_D.png"
		;(nil)[5] = "icon_slotmachine_E.png"
		return nil
	end)
end
init()
function slotMachineRewardRead.getRewardByID(id)
	for k, v in pairs(slotMachineRewardRead.reward) do
		if v.ID == id then
			return v
		end
	end
end
function slotMachineRewardRead.getSlotID(index)
	if slotMachineRewardRead.reward[index] then
		return slotMachineRewardRead.reward[index].ID
	end
	return nil
end
function slotMachineRewardRead.getRewardData(sType, index)
	local realIndex = index
	if sType and sType == 2 then
		realIndex = index + 17
	end
	if slotMachineRewardRead.reward[realIndex] then
		return slotMachineRewardRead.reward[realIndex]
	end
	return nil
end
function slotMachineRewardRead.getSlotShowNum()
	return #slotMachineRewardRead.imgList
end
function slotMachineRewardRead.getRandomImgIndex()
	local imgNum = #slotMachineRewardRead.imgList
	return math.random(1, imgNum)
end
function slotMachineRewardRead.getSlotShowImg(index)
	return slotMachineRewardRead.imgList[index] or slotMachineRewardRead.imgList[1]
end
function slotMachineRewardRead.getRandList(n)
	local _ENV, t
	for i = 1, n do
		table.insert(t, i)
	end
	for i = 1, n do
		local r = math.random(i, n)
		t[i], t[r] = t[r], t[i]
	end
	return t
end
function slotMachineRewardRead.getFinalShowList(id)
	local get_rand_list = slotMachineRewardRead.getRandList
	local key = math.floor(id % 100 / 10)
	local value = id % 10
	_UPVALUE5_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0
	;(nil)[3] = 0
	;(nil)[4] = 0
	local (nil)[5], results = 0, nil
	local slotMachineRewardRead, marks = 0, 0
	if key == 0 then
		if value == 1 then
			_UPVALUE5_, results = get_rand_list(5), get_rand_list(5)
			marks, get_rand_list(5)[1] = get_rand_list(5), 2
			marks, get_rand_list(5)[2] = get_rand_list(5), 2
			marks, get_rand_list(5)[3] = get_rand_list(5), 2
			marks, get_rand_list(5)[4] = get_rand_list(5), 2
			marks, get_rand_list(5)[5] = get_rand_list(5), 2
			return results, marks
		else
			local list1 = get_rand_list(5)
			local list2 = get_rand_list(5)
			local random = math.random(1, 2)
			for i = 1, random do
				results[list1[i * 2 - 1]] = list2[i]
				results[list1[i * 2]] = list2[i]
			end
			for i, v in ipairs(results) do
				if v == 0 then
					random = random + 1
					results[i] = list2[random]
				end
			end
			return results, marks
		end
	end
	local randList = get_rand_list(5)
	for i, v in ipairs(randList) do
		if value >= i then
			results[v] = key
			marks[v] = 1
		else
			local list = get_rand_list(5)
			if list[1] ~= key then
				results[v] = list[1]
			else
				results[v] = list[2]
			end
		end
	end
	return results, marks
end
function slotMachineRewardRead.getShowType(id)
	local reward = slotMachineRewardRead.getRewardByID(id)
	return reward and reward.showType or 0
end
return slotMachineRewardRead
