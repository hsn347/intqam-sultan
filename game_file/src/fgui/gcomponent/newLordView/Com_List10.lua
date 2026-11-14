local militaryRankRead = include("militaryRankRead")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_List10 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List10", Com_List10)
function Com_List10:onInit()
	self:fixChildrenPos()
end
function Com_List10:onShow()
end
function Com_List10:initData(data, index, curLv)
	local lv = data.lv
	local effect = data.effect
	if curLv and curLv == lv then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Sprite_rank:setSpriteFrame(militaryRankRead.getRankIconByLv(lv))
	self.fields.Text_name:setString(militaryRankRead.getRankNameByLv(lv))
	local militaryRankRead, buffList = self.fields.Text_name.setString, self.fields.Text_name.setString
	for k, v in ipairs(effect) do
		table.insert(buffList, buffDesRead.getTitleWithValue(v.id, v.num))
	end
	if 0 < #buffList then
		self.fields.Text_des:setString(table.concat(buffList, "\n"))
	else
		self.fields.Text_des:setString(i18n("common_text_2430"))
	end
end
return Com_List10
