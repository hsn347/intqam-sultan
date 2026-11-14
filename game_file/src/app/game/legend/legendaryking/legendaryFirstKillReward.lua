local legendaryFirstKillReward = class("legendaryFirstKillReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendaryFirstKillReward")
	elseif type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function legendaryFirstKillReward:ctor()
	self:bindBtnClose()
	self.myInfo, _ENV = self.bindBtnClose, self.bindBtnClose
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.itemCopy = SoraDGetChildByName(self, "Image_item")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	if self.txtTitle ~= nil then
		self.txtTitle:setString(i18n("common_text_4241"))
	else
		self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_node")
		self.ccs_bg:setTitleName(i18n("common_text_4241"))
	end
	SoraDGetChildByName(self, "Text_itemNumTip"):setString(i18n("common_text_2709"))
	SoraDGetChildByName(self, "Text_itemNameTip"):setString(i18n("common_text_3155"))
	local Image_bg = SoraDGetChildByName(self, "Image_bg")
	if Image_bg then
		Image_bg:setFillType(1)
	end
end
function legendaryFirstKillReward:initData(bid)
	self.buildID = bid
	local hegemonRead = include("hegemonRead")
	local priceConfig
	if not hegemonRead.isLegendLordBuilding(self.buildID) then
		priceConfig = hegemonRead.getFirstKillReward()
	else
		local legendLordWarltCtrl = include("legendLordWarltCtrl")
		priceConfig = legendLordWarltCtrl.getLegendLordWarFirstKillReward(nil, worldMapDefine.currentMapKindomID)
	end
	dump(priceConfig)
	self.myInfo = priceConfig
	self:initView()
end
function legendaryFirstKillReward:initView(...)
	if next(self.myInfo) then
		local publicRead = include("publicRead")
		local itemList = self.myInfo
		local sSize = self.scroll:getContentSize()
		local sH = math.max(sSize.height, #itemList * 82)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		for i, v in ipairs(itemList) do
			local single = self.itemCopy:clone()
			single:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			single:getChildByName("Text_itemNum"):setString("x" .. v.count)
			single:getChildByName("Image_itemBg"):loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			single:getChildByName("Image_itemIcon"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			single:addTo(self.scroll)
			single:setPosition(sSize.width / 2, sH - (i - 1) * 82)
		end
	end
end
return legendaryFirstKillReward
