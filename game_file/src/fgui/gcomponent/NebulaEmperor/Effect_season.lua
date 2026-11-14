local baseComponent = require("fgui.base.baseComponent")
local Effect_season = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperor/Effect_season", Effect_season)
function Effect_season:onInit()
	self.fields.mv_sjs:setAllFrameName("dh_xydwsjs_%02d.png", 1)
end
function Effect_season:onShow()
end
function Effect_season:setSeason(season)
	local basePos = self.fields.mv_sjs:getPosition()
	local fontW = 68
	local seasonStr = tostring(season)
	for i = 1, string.len(seasonStr) do
		local str = string.sub(seasonStr, i, i)
		local mv_sj = self.fields.mv_sj1
		if i ~= 1 then
			mv_sj = fgui.UIPackage:createObject("NebulaEmperor", "MovieClip_sj" .. i)
			mv_sj:addTo(self)
			mv_sj:setPosition(basePos.x + i * fontW, basePos.y)
			mv_sj:setGroup(self.fields.group)
		end
		mv_sj:setAllFrameName("dh_xydwsj" .. str .. "_%02d.png", 1)
	end
	self:setWidth((string.len(seasonStr) + 1) * fontW)
end
function Effect_season:showAction(...)
	if self:isVisible() then
		return
	end
	self:setVisible(true)
	self.transitions.t0:play(-1, 0)
	self.transitions.t_show:play()
end
return Effect_season
