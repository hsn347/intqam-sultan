local baseProxy = require("fgui.base.baseProxy")
local WorldMapBookMarkPopProxy = class("WorldMapBookMarkPopProxy", baseProxy)
function WorldMapBookMarkPopProxy:onRegisterEvent()
	print("=======WorldMapBookMarkPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function()
		if self.view.curType == 2 then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
end
return WorldMapBookMarkPopProxy
