do
	local check_int = function(n)
		if n - math.floor(n) > 0 then
			error("trying to use bitwise operation on non-integer!")
		end
	end
	local function to_bits(n)
		check_int(n)
		if n < 0 then
			return to_bits(bit.bnot(math.abs(n)) + 1)
		end
		local check_int, tbl = to_bits, to_bits
		local cnt = 1
		while 0 < n do
			local last = math.fmod(n, 2)
			if last == 1 then
				tbl[cnt] = 1
			else
				tbl[cnt] = 0
			end
			n = (n - last) / 2
			cnt = cnt + 1
		end
		return tbl
	end
	local tbl_to_number = function(tbl)
		local n = table.getn(tbl)
		local rslt = 0
		local power = 1
		for i = 1, n do
			rslt = rslt + tbl[i] * power
			power = power * 2
		end
		return rslt
	end
	local expand = function(tbl_m, tbl_n)
		local _ENV, big
		local _ENV, small
		if table.getn(tbl_m) > table.getn(tbl_n) then
			big = tbl_m
			small = tbl_n
		else
			big = tbl_n
			small = tbl_m
		end
		for i = table.getn(small) + 1, table.getn(big) do
			small[i] = 0
		end
	end
	local bit_or = function(m, n)
		local tbl_m = to_bits(m)
		local tbl_n = to_bits(n)
		expand(tbl_m, tbl_n)
		local to_bits, tbl = expand, expand
		local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
		for i = 1, rslt do
			if tbl_m[i] == 0 and tbl_n[i] == 0 then
				tbl[i] = 0
			else
				tbl[i] = 1
			end
		end
		return tbl_to_number(tbl)
	end
	local bit_and = function(m, n)
		local tbl_m = to_bits(m)
		local tbl_n = to_bits(n)
		expand(tbl_m, tbl_n)
		local to_bits, tbl = expand, expand
		local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
		for i = 1, rslt do
			if tbl_m[i] == 0 or tbl_n[i] == 0 then
				tbl[i] = 0
			else
				tbl[i] = 1
			end
		end
		return tbl_to_number(tbl)
	end
	local bit_not = function(n)
		local tbl = to_bits(n)
		local size = math.max(table.getn(tbl), 32)
		for i = 1, size do
			if tbl[i] == 1 then
				tbl[i] = 0
			else
				tbl[i] = 1
			end
		end
		return tbl_to_number(tbl)
	end
	local bit_xor = function(m, n)
		local tbl_m = to_bits(m)
		local tbl_n = to_bits(n)
		expand(tbl_m, tbl_n)
		local to_bits, tbl = expand, expand
		local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
		for i = 1, rslt do
			if tbl_m[i] ~= tbl_n[i] then
				tbl[i] = 1
			else
				tbl[i] = 0
			end
		end
		return tbl_to_number(tbl)
	end
	local bit_rshift = function(n, bits)
		check_int(n)
		local high_bit = 0
		if n < 0 then
			n = bit_not(math.abs(n)) + 1
			high_bit = 2147483648
		end
		for i = 1, bits do
			n = n / 2
			n = bit_or(math.floor(n), high_bit)
		end
		return math.floor(n)
	end
	local bit_logic_rshift = function(n, bits)
		check_int(n)
		if n < 0 then
			n = bit_not(math.abs(n)) + 1
		end
		for i = 1, bits do
			n = n / 2
		end
		return math.floor(n)
	end
	local bit_lshift = function(n, bits)
		check_int(n)
		if n < 0 then
			n = bit_not(math.abs(n)) + 1
		end
		for i = 1, bits do
			n = n * 2
		end
		return bit_and(n, 4294967295)
	end
	local bit_xor2 = function(m, n)
		local rhs = bit_or(bit_not(m), bit_not(n))
		local lhs = bit_or(m, n)
		local rslt = bit_and(lhs, rhs)
		return rslt
	end
	_ENV = nil
	;(nil).bnot = bit_not
	;(nil).band = bit_and
	;(nil).bor = bit_or
	;(nil).bxor = bit_xor
	;(nil).brshift = bit_rshift
	;(nil).blshift = bit_lshift
	;(nil).bxor2 = bit_xor2
	;(nil).blogic_rshift = bit_logic_rshift
	;(nil).tobits = to_bits
	bit, (nil).tonumb = nil, tbl_to_number
end
