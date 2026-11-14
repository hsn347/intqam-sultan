local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroTaskRead = include("heroTaskRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ingHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_ingHead", Com_ingHead)
function Com_ingHead:onInit()
end
function Com_ingHead:onShow()
end
function Com_ingHead:initData(task)
	local cfg = heroTaskRead.getTaskConfig(task.id)
	local heroDesInfo = heroltCtrl.getHeroInfo(tonumber(task.heros[1]))
	self.fields.icon:setIcon(heroDesInfo.herIcon)
	self.fields.timer:beginTime(task.t + cfg.time - serviceFunctions.systemTime())
end
return Com_ingHead
