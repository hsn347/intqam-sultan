local bit32 = require("bit32")
print("testing bitwise operations")
assert(bit32.band(1, 2) == 0)
assert(bit32.band(-1) == 4294967295)
assert(bit32.band(8.589934591E9) == 4294967295)
assert(bit32.band(-8.589934593E9) == 4294967295)
assert(bit32.band(8.589934593E9) == 1)
assert(bit32.band(-8.589934591E9) == 1)
assert(bit32.band(-1.099511627776E12) == 0)
assert(bit32.band(1.099511627776E12) == 0)
assert(bit32.band(-1.099511627778E12) == 4294967294)
assert(bit32.band(1.099511627772E12) == 4294967292)
assert(bit32.lshift(305419896, 4) == 591751040)
assert(bit32.lshift(305419896, 8) == 878082048)
assert(bit32.lshift(305419896, -4) == 19088743)
assert(bit32.lshift(305419896, -8) == 1193046)
assert(bit32.lshift(305419896, 32) == 0)
assert(bit32.lshift(305419896, -32) == 0)
assert(bit32.rshift(305419896, 4) == 19088743)
assert(bit32.rshift(305419896, 8) == 1193046)
assert(bit32.rshift(305419896, 32) == 0)
assert(bit32.rshift(305419896, -32) == 0)
print("+")
_UPVALUE10_ = print
print[1] = 0
print[2] = 1
print[3] = 2
print[4] = 3
print[5] = 10
print[6] = 2147483648
print[7] = 2863311530
print[8] = 1431655765
print[9] = 4294967295
local print[10], c = 2147483647, print
for _, b in pairs(c) do
	assert(bit32.band(b) == b)
	assert(bit32.band(b, b) == b)
	assert(bit32.band(b, b, b) == b)
	assert(bit32.band(b, bit32.bnot(b)) == 0)
	assert(bit32.bor(b, bit32.bnot(b)) == bit32.bnot(0))
	assert(bit32.bor(b) == b)
	assert(bit32.bor(b, b) == b)
	assert(bit32.bor(b, b, b) == b)
	assert(bit32.bxor(b) == b)
	assert(bit32.bxor(b, b) == 0)
	assert(bit32.bxor(b, 0) == b)
	assert(bit32.bnot(b) ~= b)
	assert(bit32.bnot(bit32.bnot(b)) == b)
	assert(bit32.bnot(b) == 4.294967295E9 - b)
	assert(bit32.lshift(bit32.lshift(b, -4), 4) == bit32.band(b, bit32.bnot(15)))
	assert(bit32.rshift(bit32.rshift(b, 4), -4) == bit32.band(b, bit32.bnot(15)))
	for i = -40, 40 do
		assert(bit32.lshift(b, i) == math.floor(b * 2 ^ i % 4.294967296E9))
	end
end
_ENV = 3
assert(not pcall(bit32.band, 3))
assert(not pcall(bit32.bnot, "a"))
assert(not pcall(bit32.lshift, 45))
assert(not pcall(bit32.lshift, 45, print))
assert(not pcall(bit32.rshift, 45, print))
print("+")
assert(bit32.extract(305419896, 0, 4) == 8)
assert(bit32.extract(305419896, 4, 4) == 7)
assert(bit32.extract(2684358929, 28, 4) == 10)
assert(bit32.extract(2684358929, 31, 1) == 1)
assert(bit32.extract(1342177553, 31, 1) == 0)
assert(bit32.extract(4063516281, 0, 32) == 4063516281)
assert(not pcall(bit32.extract, 0, -1))
assert(not pcall(bit32.extract, 0, 32))
assert(not pcall(bit32.extract, 0, 0, 33))
assert(not pcall(bit32.extract, 0, 31, 2))
print("OK")
