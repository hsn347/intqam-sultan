local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MiningMeteoritesRewradPreviewPanel = class("MiningMeteoritesRewradPreviewPanel", baseFguiPanel)
local miningMeteoritesRead = include("miningMeteoritesRead")
function MiningMeteoritesRewradPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MiningMeteoritesRewradPreviewPanel:ctor", self.viewName)
end
function MiningMeteoritesRewradPreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MiningMeteoritesRewradPreviewPanel:onInit()
	local defaultClick = self.param.type == 0 and 1 or self.param.type
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, defaultClick
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("mining_meteorites_19")
	;(nil).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("mining_meteorites_20")
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(nil)
	self.fields.Text_Title:setString(i18n("mining_meteorites_22"))
	self.fields.panel_normal:setTitle(i18n("decrypt_text_03"))
	print("=======MiningMeteoritesRewradPreviewPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function MiningMeteoritesRewradPreviewPanel:onClickTab(tag)
	self.type = tag
	self:updateScroll()
end
function MiningMeteoritesRewradPreviewPanel:updateScroll()
	self.minRewards, miningMeteoritesRead, self.rewardCfgs, miningMeteoritesRead = nil, nil, nil, nil
	self.cfgs = miningMeteoritesRead.getConfigs()
	for i, v in ipairs(self.cfgs) do
		if v.type == self.type then
			table.insert(self.rewardCfgs, v.meteoriteRewards)
			self.minRewards = v.miningRewards
		end
	end
	self.fields.scroll:setNumItems(#self.rewardCfgs)
	self.fields.com_single:initData(self.minRewards, "mining_meteorites_21")
end
function MiningMeteoritesRewradPreviewPanel:onShow()
	print("=======MiningMeteoritesRewradPreviewPanel:onShow")
	self:updateScroll()
end
function MiningMeteoritesRewradPreviewPanel:onNormalItemRenderer(index, obj)
	local rewardCfg = self.rewardCfgs[index + 1]
	obj:initData(index + 1, rewardCfg)
end
return MiningMeteoritesRewradPreviewPanel
