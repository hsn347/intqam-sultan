local baseFguiPanel = require("fgui.base.baseFguiPanel")
local caveExploreRead = include("caveExploreRead")
local caveExploreCtrl = include("caveExploreCtrl")
local CaveExploreRewradPreviewPanel = class("CaveExploreRewradPreviewPanel", baseFguiPanel)
function CaveExploreRewradPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CaveExploreRewradPreviewPanel:ctor", self.viewName)
end
function CaveExploreRewradPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CaveExploreActivity"
	end
	return self._packageList
end
function CaveExploreRewradPreviewPanel:onInit()
	print("=======CaveExploreRewradPreviewPanel:onInit")
	self.fields.panel_normal:setString(i18n("decrypt_text_03"))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function CaveExploreRewradPreviewPanel:onShow()
	print("=======CaveExploreRewradPreviewPanel:onShow")
	local rewardCfgs = caveExploreCtrl:getRewards()
	table.sort(rewardCfgs, function(l, r)
		return l.Order < r.Order
	end)
	self.rewards, _ENV = table.sort, table.sort
	for i, v in ipairs(rewardCfgs) do
		if v.Order ~= 0 then
			_ENV = nil
			;(nil).id = v.Item[1]
			;(nil).count = v.Item[2]
			;(nil).isHightLight = v.ItemEffects == 1
			table.insert(self.rewards, nil)
		end
	end
	self.fields.scroll:setNumItems(#self.rewards)
end
function CaveExploreRewradPreviewPanel:onHide()
	print("=======CaveExploreRewradPreviewPanel:onHide")
end
function CaveExploreRewradPreviewPanel:onDispose()
	print("=======CaveExploreRewradPreviewPanel:onDispose")
end
function CaveExploreRewradPreviewPanel:onNormalItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
	obj:setMovieBorder(item.isHightLight, cc.c3b(255, 207, 157))
end
return CaveExploreRewradPreviewPanel
