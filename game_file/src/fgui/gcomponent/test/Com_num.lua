local baseComponent = require("fgui.base.baseComponent")
local Com_num = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/Com_num", Com_num)
function Com_num:onInit()
	for r = 3, 17 do
		if r <= 10 then
			self.fields["Text_" .. r]:setString(r)
		elseif r == 11 then
			self.fields["Text_" .. r]:setString("J")
		elseif r == 12 then
			self.fields["Text_" .. r]:setString("Q")
		elseif r == 13 then
			self.fields["Text_" .. r]:setString("K")
		elseif r == 14 then
			self.fields["Text_" .. r]:setString("A")
		elseif r == 15 then
			self.fields["Text_" .. r]:setString("2")
		elseif r == 16 then
			self.fields["Text_" .. r]:setString([[
J
K]])
		elseif r == 17 then
			self.fields["Text_" .. r]:setString([[
J
K]])
		end
	end
end
function Com_num:onShow()
end
function Com_num:initData(playerPokerList)
	local _ENV, count
	for p = 1, 3 do
		for _, card in ipairs(playerPokerList[p]) do
			count[card.rank] = (count[card.rank] or 0) + 1
		end
	end
	for r = 3, 17 do
		self.fields["Text_val_" .. r]:setString(count[r] or 0)
	end
end
return Com_num
