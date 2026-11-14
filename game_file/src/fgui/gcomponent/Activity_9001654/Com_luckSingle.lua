local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_luckSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001654/Com_luckSingle", Com_luckSingle)
function Com_luckSingle:onInit()
	self:fixChildrenPos()
end
function Com_luckSingle:initData(index, data)
	self.fields.bg_white:setVisible(bit.band(index, 1) == 0 and true or false)
	if data.luckyPointGear[2] then
		self.fields.Text_luck:setString(string.format("%d-%d", data.luckyPointGear[1], data.luckyPointGear[2]))
	else
		self.fields.Text_luck:setString(string.format("%d+", data.luckyPointGear[1]))
	end
	_UPVALUE2_ = string.format("%d+", data.luckyPointGear[1])
	string.format("%d+", data.luckyPointGear[1])[1] = "id"
	string.format("%d+", data.luckyPointGear[1])[2] = "count"
	local itemList = serviceFunctions.tableFormat(data.gearReward, string.format("%d+", data.luckyPointGear[1]))
	local str = ""
	for ki, vi in ipairs(itemList) do
		if ki == #itemList then
			str = str .. string.format("%s*%d", publicRead.getName(vi.id), vi.count)
		else
			str = str .. string.format("%s*%d,", publicRead.getName(vi.id), vi.count) .. "\n"
		end
	end
	self.fields.Text_reward:setString(str)
end
function Com_luckSingle:onShow()
end
return Com_luckSingle
