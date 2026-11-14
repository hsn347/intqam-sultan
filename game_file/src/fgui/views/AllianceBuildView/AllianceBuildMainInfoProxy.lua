local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildMainInfoProxy = class("AllianceBuildMainInfoProxy", baseProxy)
function AllianceBuildMainInfoProxy:onRegisterEvent()
	print("=======AllianceBuildMainInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", function(target, data)
		local tableSingleData = self.view.tableSingleData
		if tableSingleData and data.bid == tableSingleData.bid then
			self.view:initData(tableSingleData)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", function(target, data)
		local tableSingleData = self.view.tableSingleData
		if tableSingleData and data.id == tableSingleData.id then
			self.view:removeFromParent()
		end
	end)
end
return AllianceBuildMainInfoProxy
