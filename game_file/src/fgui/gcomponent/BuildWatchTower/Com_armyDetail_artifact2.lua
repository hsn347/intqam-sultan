local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_artifact2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_artifact2", Com_armyDetail_artifact2)
local equipDesRead = include("equipDesRead")
function Com_armyDetail_artifact2:onInit()
end
function Com_armyDetail_artifact2:onShow()
end
function Com_armyDetail_artifact2:initData(tbl)
	self.myTbl = tbl
	self:initView()
end
function Com_armyDetail_artifact2:initView(...)
	if self.myTbl and next(self.myTbl) and self.myTbl[1] then
		self.fields.spriteSkill:setURL(equipDesRead.getArtifactIcon(self.myTbl[1].armsID))
	end
end
return Com_armyDetail_artifact2
