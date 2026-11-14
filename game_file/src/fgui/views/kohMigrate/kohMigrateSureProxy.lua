local baseProxy = require("fgui.base.baseProxy")
local kohMigrateSureProxy = class("kohMigrateSureProxy", baseProxy)
function kohMigrateSureProxy:onRegisterEvent()
	print("=======kohMigrateSureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, event)
		local itemMap = event and event.itemMap
		if not itemMap then
			return
		end
		for i, v in ipairs(self.view.itemIDList) do
			if itemMap[v] then
				self.view:refreshItemCount()
				break
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST_PRIVILEGE_CLOSE", function()
		if self.view.isPrivilege then
			self.view:removeFromParent()
		end
	end)
end
return kohMigrateSureProxy
