local _ENV, mathBit
function mathBit.__andBit(left, right)
	return left == 1 and right == 1 and 1 or 0
end
function mathBit.__orBit(left, right)
	return (left == 1 or right == 1) and 1 or 0
end
function mathBit.__xorBit(left, right)
	return left + right == 1 and 1 or 0
end
function mathBit.__base(left, right, op)
	if left < right then
		left, right = right, left
	end
	local res = 0
	local shift = 1
	while left ~= 0 do
		local ra = left % 2
		local rb = right % 2
		res = shift * op(ra, rb) + res
		shift = shift * 2
		left = math.modf(left / 2)
		right = math.modf(right / 2)
	end
	return res
end
function mathBit.andOp(left, right)
	return mathBit.__base(left, right, mathBit.__andBit)
end
function mathBit.xorOp(left, right)
	return mathBit.__base(left, right, mathBit.__xorBit)
end
function mathBit.orOp(left, right)
	return mathBit.__base(left, right, mathBit.__orBit)
end
function mathBit.notOp(left)
	return 0 < left and -(left + 1) or -left - 1
end
function mathBit.lShiftOp(left, num)
	return left * 2 ^ num
end
function mathBit.rShiftOp(left, num)
	return math.floor(left / 2 ^ num)
end
return mathBit
