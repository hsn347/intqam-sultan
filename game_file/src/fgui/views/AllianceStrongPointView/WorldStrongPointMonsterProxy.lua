local baseProxy = require("fgui.base.baseProxy")
local WorldStrongPointMonsterProxy = class("WorldStrongPointMonsterProxy", baseProxy)
function WorldStrongPointMonsterProxy:onRegisterEvent()
	print("=======WorldStrongPointMonsterProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_WORLDMAPHOLD_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self.view:removeFromParent()
	end)
end
function WorldStrongPointMonsterProxy:updateData(...)
	self.view:updateData(...)
end
return WorldStrongPointMonsterProxy
