local _UPVALUE13_, _ENV, anchorSwitch
;(nil)[1] = "fix_worldMapViewDef"
;(nil)[2] = "fix_worldMapView"
;(nil)[3] = "fix_remainsMapView"
;(nil)[4] = "fix_remainsWarResultView"
;(nil)[5] = "fix_mainUI"
;(nil)[6] = "fix_worldMapBuilding"
;(nil)[7] = "fix_worldMapRemainsWar"
;(nil)[8] = "fix_worldMapTip"
;(nil)[9] = "fix_allianceWarView"
;(nil)[10] = "fix_watchTowerView"
;(nil)[11] = "fix_mailView"
;(nil)[12] = "fix_mailCtrl"
local (nil)[13], fixTable = "fix_lordView", nil
local anchorFixPath = "app.module.anchor.anchorFix."
function anchorSwitch.doSwitch(isAnchor)
	if isAnchor then
		for _, v in ipairs(fixTable) do
			local path = anchorFixPath .. v
			requireLocal(path)
		end
	end
end
return anchorSwitch
