local heroTrialltCtrl = include("heroTrialltCtrl")
local htMapMgr = include("htMapMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_area = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_area", Com_area)
function Com_area:onInit()
end
function Com_area:onShow()
end
function Com_area:initData(page, areaId)
	self.fields.p10:setVisible(page == 1)
	for i = 1, 10 do
		local gateId = i + 10 * (page - 1) + 20 * (areaId - 1)
		local mapId = gateId + heroTrialltCtrl.getInitFirst() - 1
		self.fields["n" .. i]:initData(gateId, mapId)
		self.fields["p" .. i]:setColor(htMapMgr.getIsPass(mapId) and cc.c3b(244, 238, 149) or cc.c3b(57, 37, 17))
	end
end
return Com_area
