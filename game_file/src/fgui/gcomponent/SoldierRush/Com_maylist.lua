local soldierRushRead = include("soldierRushRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_maylist = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_maylist", Com_maylist)
function Com_maylist:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_gate:fixPos()
end
function Com_maylist:onShow()
end
function Com_maylist:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, 0)
end
function Com_maylist:initData(data, index, curLevelID)
	self.fields.bg:setVisible(index % 2 == 1)
	local lvCfg = soldierRushRead.getLevelCfg(data.LevelID)
	soldierRushRead = nil
	;(nil).num = string.format("%d-%d", lvCfg.Chapter, lvCfg.LevelId)
	self.fields.Text_gate:setString(i18n("soldier_rush_text_122", nil))
	self.fields.Text_gate:setColor(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))
	_UPVALUE2_ = data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135)
	;(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))[1] = "id"
	;(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))[2] = "count"
	self.itemList = serviceFunctions.tableFormat(data.RewardShow, data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))
	self.fields.List:setNumItems(#self.itemList)
end
return Com_maylist
