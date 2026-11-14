local soldierRushRead = include("soldierRushRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_exlist = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_exlist", Com_exlist)
function Com_exlist:onInit()
	self.fields.List_res:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_gate:fixPos()
end
function Com_exlist:onShow()
end
function Com_exlist:onItemRenderer(index, obj)
	obj:initData(self.resList[index + 1], 1)
end
function Com_exlist:initData(data, curLevelID)
	local lvCfg = soldierRushRead.getLevelCfg(data.LevelID)
	soldierRushRead = nil
	;(nil).num = string.format("%d-%d", lvCfg.Chapter, lvCfg.LevelId)
	self.fields.Text_gate:setString(i18n("soldier_rush_text_122", nil))
	self.fields.Text_gate:setColor(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))
	_UPVALUE2_ = data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135)
	;(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))[1] = "id"
	;(data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))[2] = "count"
	self.resList = serviceFunctions.tableFormat(data.ResourceShow, data.LevelID == curLevelID and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))
	self.fields.List_res:setNumItems(#self.resList)
end
return Com_exlist
