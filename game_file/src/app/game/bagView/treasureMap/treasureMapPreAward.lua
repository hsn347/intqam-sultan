local itemDesRead = include("itemDesRead")
local treasureMapPreAward = class("treasureMapPreAward", function(target)
	return target or SoraDCreateTouchPanel("treasureMapPreAward")
end)
function treasureMapPreAward:ctor()
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("item_name_825901"))
	self.itemIcon = SoraDGetChildByName(self, "item_Icon")
	self.textItemName = SoraDGetChildByName(self, "Text_ItemName")
	self.textReward = SoraDGetChildByName(self, "Text_Tips")
	self.textReward:setString(i18n("protect_text_10"))
	self.btnGetReard = SoraDGetChildByName(self, "Button_Sure")
	self.btnGetReard:setTitleText(i18n("common_text_204"))
	self.btnGetReard:addTouchEventListener(handler(self, self.close))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
end
function treasureMapPreAward:initData(mapInfo)
	self.textReward:setString(i18n("circus_text_04"))
	self.itemIcon:loadTexture(itemDesRead.getIcon(mapInfo.treasureMapID, false), ccui.TextureResType.plistType)
	self.textItemName:setString(itemDesRead.getName(mapInfo.treasureMapID))
	self.textItemName:setColor(itemDesRead.getColor(mapInfo.treasureMapID))
	_UPVALUE3_ = itemDesRead.getColor(mapInfo.treasureMapID)
	itemDesRead.getColor(mapInfo.treasureMapID)[1] = "id"
	itemDesRead.getColor(mapInfo.treasureMapID)[2] = "count"
	itemDesRead.getColor(mapInfo.treasureMapID)[3] = "rare"
	rewardData = serviceFunctions.tableFormat(mapInfo.reward, itemDesRead.getColor(mapInfo.treasureMapID))
	for i, v in ipairs(rewardData) do
		local item = include("commonItemAward").new()
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(self.nodeAward, 1, "item_" .. i)
	end
	SoraDToCenter(self.nodeAward, 100)
end
return treasureMapPreAward
