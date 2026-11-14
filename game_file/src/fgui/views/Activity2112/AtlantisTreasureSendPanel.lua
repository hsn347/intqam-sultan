local AST = require_data("atlantiswar_season_treasure", true).data
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisTreasureSendPanel = class("AtlantisTreasureSendPanel", baseFguiPanel)
function AtlantisTreasureSendPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisTreasureSendPanel:ctor", self.viewName)
	if not atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData then
		_ENV = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	end
	self.atlantisWarTreasureData = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
end
function AtlantisTreasureSendPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function AtlantisTreasureSendPanel:onInit()
	print("=======AtlantisTreasureSendPanel:onInit")
	self.treasureType = self.param.treasureType
	_ENV = nil
	;(nil).var = atlantisActivityCtrl:getTreasureName(self.treasureType)
	self.fields.Panel_bg:setString(i18n("atlantiswar_text_0389", nil))
	self:initKingdomList()
end
function AtlantisTreasureSendPanel:onShow()
	print("=======AtlantisTreasureSendPanel:onShow")
end
function AtlantisTreasureSendPanel:initKingdomList(...)
	local kingdomList = atlantisActivityCtrl:getKingdomsList()
	local atlantisActivityCtrl, ret = atlantisActivityCtrl, atlantisActivityCtrl
	local groupID = 1
	for i, v in ipairs(kingdomList) do
		if not ret[groupID] then
			atlantisActivityCtrl = ret[groupID]
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
function AtlantisTreasureSendPanel:onGroupItemRenderer(index, obj)
	local groupID = index + 1
	local list = self.kingdomList[groupID]
	local kidMin = list[1]
	local kidMax = list[#list]
	obj:setString(string.format("%d-%d", kidMin, kidMax))
	if self.curGroupID == groupID then
		obj:setSelected(true)
	end
end
function AtlantisTreasureSendPanel:onClickGroupItem(EventContext)
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
function AtlantisTreasureSendPanel:onKidItemRenderer(index, obj)
	local list = self.kingdomList[self.curGroupID]
	local kid = list[index + 1]
	obj:setString("#" .. kid)
	local hasTreasure = self:checkHasTreasure(kid)
	obj:getController("c_select"):setSelectedIndex(hasTreasure and 1 or 0)
end
function AtlantisTreasureSendPanel:onClickKidItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_kid:getChildIndex(obj)
	local itemIndex = self.fields.List_kid:childIndexToItemIndex(childIndex)
	local list = self.kingdomList[self.curGroupID]
	local kid = list[itemIndex + 1]
	if self:checkHasTreasure(kid) then
		SoraDShowMsgTip(i18n("atlantiswar_text_0381"))
		return
	end
	if atlantisActivityCtrl:getTreasureRemainTime() <= 0 then
		SoraDShowMsgTip(i18n("atlantiswar_text_0383"))
		self:closePanel()
		return
	end
	_ENV = i18n("atlantiswar_text_0383")
	i18n("atlantiswar_text_0383").treasure = atlantisActivityCtrl:getTreasureName(self.treasureType)
	i18n("atlantiswar_text_0383").kid = kid
	SoraDShowMsgBox(i18n("atlantiswar_text_0382", i18n("atlantiswar_text_0383")), nil, nil, function(exitType)
		if MSGBOX_CALLBACK_YES == exitType then
			atlantisActivityCtrl:reqSendTreasure(kid, self.treasureType)
		end
	end)
end
function AtlantisTreasureSendPanel:checkHasTreasure(kid)
	for k, v in pairs(self.atlantisWarTreasureData) do
		if v[tostring(kid)] then
			return true
		end
	end
	return false
end
function AtlantisTreasureSendPanel:refreshTreasureData(...)
	if not atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData then
		atlantisActivityCtrl = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	end
	self.atlantisWarTreasureData = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	local AST = require_data("atlantiswar_season_treasure", true).data
	local countMax = AST[self.treasureType].count
	if not self.atlantisWarTreasureData[tostring(self.treasureType)] then
		local atlantisActivityCtrl, typeData = self.atlantisWarTreasureData[tostring(self.treasureType)], self.atlantisWarTreasureData[tostring(self.treasureType)]
	end
	typeData = table.keys(typeData)
	local count = math.max(0, countMax - #typeData)
	if count <= 0 then
		self:closePanel()
		return
	end
	local list = self.kingdomList[self.curGroupID]
	self.fields.List_kid:setNumItems(#list)
end
return AtlantisTreasureSendPanel
