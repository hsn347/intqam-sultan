local baseProxy = require("fgui.base.baseProxy")
local NbulaMileStoneProxy = class("NbulaMileStoneProxy", baseProxy)
function NbulaMileStoneProxy:onRegisterEvent()
	print("=======NbulaMileStoneProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_NEBULA_MILESTONE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.judgeClose))
end
function NbulaMileStoneProxy:updateView()
	local nebulaWarUtil = include("nebulaWarUtil")
	if not nebulaWarUtil.checkMilepostState() then
		self.view:close()
	else
		self.view:updateView()
	end
end
function NbulaMileStoneProxy:judgeClose()
	local nebulaWarUtil = include("nebulaWarUtil")
	if not nebulaWarUtil.checkMilepostState() then
		self.view:close()
	end
end
return NbulaMileStoneProxy
