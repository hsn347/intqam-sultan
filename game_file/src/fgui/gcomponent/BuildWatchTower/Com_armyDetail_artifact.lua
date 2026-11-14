local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_artifact = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_artifact", Com_armyDetail_artifact)
local equipDesRead = include("equipDesRead")
function Com_armyDetail_artifact:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.myTbl, _ENV = self.fixChildrenPos, self.fixChildrenPos
end
function Com_armyDetail_artifact:onShow()
end
function Com_armyDetail_artifact:initData(tbl)
	self.myTbl = tbl
	self:initView()
end
function Com_armyDetail_artifact:initView(...)
	if self.myTbl and next(self.myTbl) and self.myTbl[1] then
		self.fields.labelName:setString(equipDesRead.getArtifactName(self.myTbl[1].armsID))
		self.fields.spriteSkill:setURL(equipDesRead.getArtifactIcon(self.myTbl[1].armsID))
		_ENV = equipDesRead.getArtifactIcon(self.myTbl[1].armsID)
		equipDesRead.getArtifactIcon(self.myTbl[1].armsID).lv = self.myTbl[1].level
		self.fields.labelLv:setString(i18n("common_text_100", equipDesRead.getArtifactIcon(self.myTbl[1].armsID)))
	end
end
return Com_armyDetail_artifact
