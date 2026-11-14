local baseComponent = require("fgui.base.baseComponent")
local Com_monsterInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001660/Com_monsterInfo", Com_monsterInfo)
function Com_monsterInfo:onInit()
end
function Com_monsterInfo:onShow()
end
function Com_monsterInfo:setMonsterName(name)
	self.fields.Text_monsterName:setString(name)
end
function Com_monsterInfo:setBlood(warInfoTbl)
	self.fields.Bar:setMax(warInfoTbl.maxhp)
	self.fields.Bar:setValue(warInfoTbl.maxhp - warInfoTbl.dechp)
end
function Com_monsterInfo:resetBlood()
	self.fields.Bar:setMax(100)
	self.fields.Bar:setValue(0)
end
return Com_monsterInfo
