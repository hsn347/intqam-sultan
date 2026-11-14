local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local itemLogic = include("itemLogic")
local itemDesRead = include("itemDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local quickuseitem = require_data("quickuseitem").data
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonQuickUseViewPanel = class("commonQuickUseViewPanel", baseFguiPanel)
function commonQuickUseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonQuickUseViewPanel:ctor", self.viewName)
end
function commonQuickUseViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonQuickUseViewPanel:onInit()
	print("=======commonQuickUseViewPanel:onInit")
	self.singleList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("quick_use_01"))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Text_has:fixPos()
	self.fields.Sprite_item:fixPos()
end
function commonQuickUseViewPanel:onShow()
	print("=======commonQuickUseViewPanel:onShow")
	self.needID = self.param.needID
	self.needCount = self.param.needCount
	if not quickuseitem[self.needID] then
		SoraDShowMsgTip(i18n("Glory_text_61"))
		self:close()
		return
	end
	self.fields.Sprite_item:setSpriteFrame(publicRead.getIcon(self.needID))
	self:refreshTextHas()
	local _ENV, config = self.refreshTextHas, self.refreshTextHas
	local associatedItem = quickuseitem[self.needID].associatedItem
	publicRead = publicRead.getIcon(self.needID)
	publicRead.getIcon(self.needID)[1] = "id"
	publicRead.getIcon(self.needID)[2] = "type"
	associatedItem = serviceFunctions.tableFormat(associatedItem, publicRead.getIcon(self.needID))
	for i, data in ipairs(associatedItem) do
		local itemID = data.id
		local showType = data.type
		local itemCount = backpackCtrl:getItemCount(itemID)
		if showType == 1 or showType == 2 and 0 < itemCount then
			_ENV = publicRead.getIcon(self.needID)
			publicRead.getIcon(self.needID).id = itemID
			publicRead.getIcon(self.needID).count = itemCount
			table.insert(config, publicRead.getIcon(self.needID))
		end
	end
	self.config = config
	self:initScroll()
end
function commonQuickUseViewPanel:onListRenderer(index, obj)
	obj:initData(self.singleList[index + 1], self.needID)
end
function commonQuickUseViewPanel:initScroll()
	self.singleList, _ENV = nil, nil
	for i, data in ipairs(self.config) do
		_ENV = nil
		;(nil).id = data.id
		;(nil).count = backpackCtrl:getItemCount(data.id)
		table.insert(self.singleList, nil)
	end
	self.fields.List:setNumItems(#self.singleList)
end
function commonQuickUseViewPanel:refreshTextHas()
	local hasCount = backpackCtrl:getItemCount(self.needID)
	backpackCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(hasCount >= self.needCount and "#F0C882" or "#FF0000", string.formatnumberthousands(hasCount))
	;(nil).var2 = string.formatnumberthousands(self.needCount)
	self.fields.Text_has:setString(i18n("%{var1}/%{var2}", nil))
end
function commonQuickUseViewPanel:itemCountChange(target, data)
	if data and data.itemMap and data.itemMap[self.needID] then
		self:refreshTextHas()
	end
	self:initScroll()
end
return commonQuickUseViewPanel
