local StorageBoxResolveView = class("storageBoxResolveView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("storageBoxResolveView")
	end
	return target
end)
function StorageBoxResolveView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:bindBtnClose()
	self.tabelMaterialData, _ENV = self.bindBtnClose, self.bindBtnClose
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self.centerNode, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1356"))
	self.labelNotice = SoraDGetChildByName(self.centerNode, "Text_notice")
	self.btnClose = SoraDGetChildByName(self.centerNode, "Button_close")
	self.btnClose:setTitleText(i18n("common_text_204"))
	self.scroll = SoraDGetChildByName(self.centerNode, "ScrollView_have")
end
function StorageBoxResolveView:initData(mData)
	self.tabelMaterialData = mData
	local count = 0
	for i, v in ipairs(self.tabelMaterialData) do
		count = v.count + count
	end
	_ENV = nil
	;(nil).value = count
	self.labelNotice:setString(i18n("common_text_1357", nil))
	self:initScroll()
end
function StorageBoxResolveView:initScroll()
	local totalH = math.max(#self.tabelMaterialData * 110, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(530, totalH))
	for i, v in ipairs(self.tabelMaterialData) do
		local single = SoraDCreatePanel("storageBoxResolveSingle")
		single:initData(v)
		single:setPosition(SoraDFPoint(450, totalH - 110 * (i - 1) - 55, 530))
		single:addTo(self.scroll)
	end
end
return StorageBoxResolveView
