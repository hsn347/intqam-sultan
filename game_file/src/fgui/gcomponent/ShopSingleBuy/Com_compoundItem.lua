local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_compoundItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ShopSingleBuy/Com_compoundItem", Com_compoundItem)
function Com_compoundItem:onInit()
end
function Com_compoundItem:onShow()
end
function Com_compoundItem:initData(item)
	self.itemData = item
	self.fields.item:initData(self.itemData.id)
	self:updateCount()
end
function Com_compoundItem:updateCount()
	local resultType = backpackltCtrl:getResultType(self.itemData.id)
	if resultType == gItemEffectDef.MERGE_FRAGMENG then
		self.curItemCount = backpackCtrl:getItemCount(self.itemData.id)
	else
		self.curItemCount = math.min(backpackCtrl:getItemCount(self.itemData.id), backpackltCtrl:getUseMax(self.itemData.id))
	end
	backpackltCtrl = backpackltCtrl:getUseMax(self.itemData.id)
	backpackltCtrl:getUseMax(self.itemData.id).member = self.curItemCount
	backpackltCtrl:getUseMax(self.itemData.id).total = self.itemData.count
	self.fields.Text_num:setString(i18n("common_text_155", backpackltCtrl:getUseMax(self.itemData.id)))
	self.fields.Text_num:setColor(self.curItemCount >= self.itemData.count and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
end
function Com_compoundItem:getMergeCount()
	self:updateCount()
	return math.floor(self.curItemCount / self.itemData.count)
end
return Com_compoundItem
