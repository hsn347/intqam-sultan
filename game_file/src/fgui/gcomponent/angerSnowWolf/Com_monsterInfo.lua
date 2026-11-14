local baseComponent = require("fgui.base.baseComponent")
local Com_monsterInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://angerSnowWolf/Com_monsterInfo", Com_monsterInfo)
function Com_monsterInfo:onInit()
	self.fields.LoadingBar_monsterLife:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_monsterInfo:onShow()
end
function Com_monsterInfo:setMonsterName(name)
	self.fields.Text_monsterName:setString(name)
end
function Com_monsterInfo:setBlood(warInfoTbl)
	self.fields.LoadingBar_monsterLife:setMax(warInfoTbl.maxhp)
	self.fields.LoadingBar_monsterLife:setValue(warInfoTbl.maxhp - warInfoTbl.dechp)
	self.fields.Text_lifeNum:setString((warInfoTbl.maxhp - warInfoTbl.dechp) / warInfoTbl.maxhp * 100 .. "%")
end
function Com_monsterInfo:resetBlood()
	self.fields.LoadingBar_monsterLife:setMax(100)
	self.fields.LoadingBar_monsterLife:setValue(0)
	self.fields.Text_lifeNum:setString("0%")
end
return Com_monsterInfo
