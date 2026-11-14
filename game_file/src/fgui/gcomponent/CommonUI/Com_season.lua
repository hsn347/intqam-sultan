local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_season = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_season", Com_season)
function Com_season:onInit()
	self.fields.season:setVisible(false)
	self.fields.season:fixPos()
end
function Com_season:onShow()
end
function Com_season:initData(id)
	self.fields.season:setVisible(false)
	local itemType = backpackltCtrl:getItemType(id)
	if itemType == gItemType.WAR_PARTERN_FRAGMENT then
		local mergeID = backpackltCtrl:getItemIDByMaterial(id)
		if mergeID then
			local subscript = artifactRuneRead.getRuneSubscript(mergeID)
			print("subscript======xxx", subscript, mergeID)
			if subscript then
				self.fields.season:setVisible(true)
				self.fields.season:setIcon(subscript)
			end
		end
	else
		local subscript = artifactRuneRead.getRuneSubscript(id)
		print("subscript======yyy", subscript, id)
		if subscript then
			self.fields.season:setVisible(true)
			self.fields.season:setIcon(subscript)
		end
	end
end
return Com_season
