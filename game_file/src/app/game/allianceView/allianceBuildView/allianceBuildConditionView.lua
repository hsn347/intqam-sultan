local AllianceBuildConditionView = class("allianceBuildConditionView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceBuildConditionView")
	end
	return target
end)
function AllianceBuildConditionView:ctor()
	self.buildSingle, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch"), SoraDGetChildByName(self, "Center_Panel_touch")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2126"))
	self.scrollInfo = SoraDGetChildByName(self, "ScrollView_info")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
end
function AllianceBuildConditionView:initData(buildSingle)
	self.buildSingle = buildSingle
	_ENV = nil
	;(nil).build = i18n("common_text_2126")
	self.labelDes:setString(i18n("common_text_2170", nil))
	self:initScroll()
end
function AllianceBuildConditionView:initScroll()
	self.scrollInfo:removeAllChildren()
	local scrollH = math.max(self.scrollInfo:getContentSize().height, 110 * #self.buildSingle:getCondOfSetBuilding())
	self.scrollInfo:setInnerContainerSize(cc.size(520, scrollH))
	for i, v in ipairs(self.buildSingle:getCondOfSetBuilding()) do
		local single = SoraDCreatePanel("allianceBuildConditionSingle")
		single:setPosition(cc.p(260.0, scrollH - 110 * (i - 1) - 5))
		single:initData(v)
		single:addTo(self.scrollInfo)
	end
end
return AllianceBuildConditionView
