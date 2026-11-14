local magicFlipRead = include("aAReadClass").new()
function magicFlipRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "magicflipreward"
	;(nil)[2] = true
	magicFlipRead:defineValue("magicflipreward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "magicflipnum"
	;(nil)[2] = true
	magicFlipRead:defineValue("magicflipnum", nil)
end
function magicFlipRead.getRewardConfig()
	return magicFlipRead.magicflipreward
end
function magicFlipRead.getStageConfig()
	return magicFlipRead.magicflipnum
end
function magicFlipRead.getRewadByType(type)
	for i, v in ipairs(magicFlipRead.magicflipreward) do
		if v.type == type then
			return v.reward
		end
	end
	_ENV = (for generator)
	return ipairs(magicFlipRead.magicflipreward)
end
function magicFlipRead.getNextCount(count)
	for i, v in ipairs(magicFlipRead.magicflipnum) do
		if count < v.num then
			return v.num
		end
	end
	return magicFlipRead.magicflipnum[#magicFlipRead.magicflipnum].num
end
magicFlipRead.init()
return magicFlipRead
