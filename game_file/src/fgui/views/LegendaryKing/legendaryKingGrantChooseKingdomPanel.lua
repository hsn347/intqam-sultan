local legendLordCtrl = SoraDGetCtrl("legendLordCtrl")
local kingStarCtrl = SoraDGetCtrl("kingStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendaryKingGrantChooseKingdomPanel = class("legendaryKingGrantChooseKingdomPanel", baseFguiPanel)
function legendaryKingGrantChooseKingdomPanel:ctor(...)
	self.super.ctor(self, ...)
	print("legendaryKingGrantChooseKingdomPanel:ctor", self.viewName)
end
function legendaryKingGrantChooseKingdomPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function legendaryKingGrantChooseKingdomPanel:onInit()
	print("=======legendaryKingGrantChooseKingdomPanel:onInit")
	self.kingdomTitleLimitList = self.proxy.param.kingdomTitleLimitList
	self.mapid = self.proxy.param.mapid
	self.fields.Panel_bg:setTitle(self.proxy.param.name)
end
function legendaryKingGrantChooseKingdomPanel:onShow()
	print("=======legendaryKingGrantChooseKingdomPanel:onShow")
	SoraDShowLoading()
	if worldMapDefine.isKingStarMapId(self.mapid) then
		kingStarCtrl:reqLegendKingList(worldMapDefine.getKingStarActivityID(self.mapid))
		return
	end
	legendLordCtrl:reqLegendKingList()
end
function legendaryKingGrantChooseKingdomPanel:initKingdomList(kingdomList)
	table.sort(kingdomList, function(l, r)
		return l < r
	end)
	local _ENV, ret = table.sort, table.sort
	local groupID = 1
	for i, v in ipairs(kingdomList) do
		if not ret[groupID] then
			_ENV = ret[groupID]
		end
		ret[groupID] = ret[groupID]
		table.insert(ret[groupID], v)
		if 50 <= #ret[groupID] then
			groupID = groupID + 1
		end
	end
	self.kingdomList = ret
	self.curGroupID = 1
	self.fields.List_group:setItemRenderer(handler(self, self.onGroupItemRenderer))
	self.fields.List_group:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickGroupItem))
	self.fields.List_group:setNumItems(#self.kingdomList)
	self.fields.List_kid:setItemRenderer(handler(self, self.onKidItemRenderer))
	self.fields.List_kid:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickKidItem))
	local list = self.kingdomList[self.curGroupID]
	self.fields.List_kid:setNumItems(#list)
end
function legendaryKingGrantChooseKingdomPanel:onGroupItemRenderer(index, obj)
	local groupID = index + 1
	local list = self.kingdomList[groupID]
	local kidMin = list[1]
	local kidMax = list[#list]
	obj:setString(string.format("%d-%d", kidMin, kidMax))
	if self.curGroupID == groupID then
		obj:setSelected(true)
	end
end
function legendaryKingGrantChooseKingdomPanel:onClickGroupItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_group:getChildIndex(obj)
	local itemIndex = self.fields.List_group:childIndexToItemIndex(childIndex)
	local groupID = itemIndex + 1
	if self.curGroupID == groupID then
		return
	end
	self.curGroupID = groupID
	local list = self.kingdomList[self.curGroupID]
	self.fields.List_kid:setNumItems(#list)
end
function legendaryKingGrantChooseKingdomPanel:onKidItemRenderer(index, obj)
	local list = self.kingdomList[self.curGroupID]
	local kid = list[index + 1]
	obj:setString("#" .. kid)
	local hasTreasure = self:checkHasTreasure(kid)
	obj:getController("c_select"):setSelectedIndex(hasTreasure and 1 or 0)
end
function legendaryKingGrantChooseKingdomPanel:onClickKidItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_kid:getChildIndex(obj)
	local itemIndex = self.fields.List_kid:childIndexToItemIndex(childIndex)
	print("==onClickKidItem childIndex, itemIndex==", childIndex, itemIndex)
	local list = self.kingdomList[self.curGroupID]
	local kid = list[itemIndex + 1]
	_ENV = itemIndex
	itemIndex.msg = "MESSAGE_WORLD_MAP_KINGDOM_CHANGE"
	itemIndex.kid = kid
	SoraDSendMessage(itemIndex)
end
function legendaryKingGrantChooseKingdomPanel:checkHasTreasure(kid)
	for _, v in pairs(self.kingdomTitleLimitList) do
		if tonumber(v) == tonumber(kid) then
			return true
		end
	end
	return false
end
return legendaryKingGrantChooseKingdomPanel
