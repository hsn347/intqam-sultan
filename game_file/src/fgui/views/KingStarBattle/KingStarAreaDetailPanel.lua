local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingStarAreaDetailPanel = class("KingStarAreaDetailPanel", baseFguiPanel)
function KingStarAreaDetailPanel:ctor(...)
	KingStarAreaDetailPanel.super.ctor(self, ...)
	print("KingStarAreaDetailPanel:ctor", self.viewName)
end
function KingStarAreaDetailPanel:onInit()
	print("=======KingStarAreaDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("king_star_rank_text13"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function KingStarAreaDetailPanel:onShow()
	print("=======KingStarAreaDetailPanel:onShow")
	_ENV, _ENV = "=======KingStarAreaDetailPanel:onShow", print
	;("=======KingStarAreaDetailPanel:onShow").kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID_9001646
	_ENV = nil
	;(nil).ranklist = i18n("remains_name_01")
	_ENV, print[1], ("=======KingStarAreaDetailPanel:onShow").name = "=======KingStarAreaDetailPanel:onShow", "=======KingStarAreaDetailPanel:onShow", i18n("king_star_rank_text2", nil)
	;("=======KingStarAreaDetailPanel:onShow").kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID_9001647
	_ENV = nil
	;(nil).ranklist = i18n("king_star_rank_text3")
	_ENV, print[2], ("=======KingStarAreaDetailPanel:onShow").name = "=======KingStarAreaDetailPanel:onShow", "=======KingStarAreaDetailPanel:onShow", i18n("king_star_rank_text2", nil)
	;("=======KingStarAreaDetailPanel:onShow").kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID
	self.areaCfg, print[3], ("=======KingStarAreaDetailPanel:onShow").name = print, "=======KingStarAreaDetailPanel:onShow", i18n("kingstarbattle_text_20")
	self.fields.List:setNumItems(#self.areaCfg)
end
function KingStarAreaDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.areaCfg[index + 1])
end
return KingStarAreaDetailPanel
