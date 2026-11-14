local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local MythicalCreaturesStarPanel = class("MythicalCreaturesStarPanel", baseFguiPanel)
function MythicalCreaturesStarPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MythicalCreaturesStarPanel:ctor", self.viewName)
end
function MythicalCreaturesStarPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MythicalCreaturesStarPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MythicalCreaturesStarPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_text_28"))
	self.divineID = self.param.divineID
	self.beastCfg = divineBeastRead.getDbCfg(self.divineID)
	self.beastData = divineBeastCtrl:getBeastData(self.divineID)
	self.starCfg = divineBeastRead.getStarCfg(self.divineID, self.beastData.starLv or 0)
	self.starCfgs = divineBeastRead.getStarCfgs(self.divineID)
	self.fields.txt_tips:setString(i18n("Divine_beast_text_29"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list_star:setItemRenderer(handler(self, self.onStarItemRenderer))
	self:updateView()
end
function MythicalCreaturesStarPanel:onShow()
	print("=======MythicalCreaturesStarPanel:onShow")
	self:updateView()
end
function MythicalCreaturesStarPanel:updateView()
	self.starLv = self.beastData.starLv or 0
	self.fields.list_star:setNumItems(self.starLv)
	self.fields.Com_MC_head:setIcon(self.beastCfg.divineIcon)
	self.fields.list:setNumItems(table.nums(self.starCfgs) - 1)
end
function MythicalCreaturesStarPanel:onItemRenderer(index, object)
	local growDesCfgs = divineBeastRead.getGrowDes(self.divineID, index + 1)
	object:initData(growDesCfgs, self.starCfgs[index + 1])
end
function MythicalCreaturesStarPanel:onStarItemRenderer(index, obj)
	local i = index + 1
	obj:initData(i <= self.starLv, i == self.starLv + 1)
end
return MythicalCreaturesStarPanel
