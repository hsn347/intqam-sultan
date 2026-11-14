local allianceActiveGiftView = class("allianceActiveGiftView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceActiveGiftView")
	end
	return target
end)
function allianceActiveGiftView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2658"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceActiveGiftSingle")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("graft_text_02"))
end
function allianceActiveGiftView:initData(reward)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local itemList = serviceFunctions.tableFormat(reward, nil)
	for k, v in ipairs(itemList) do
		v.index = k
	end
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(520, 60), itemList, 1, nil)
end
return allianceActiveGiftView
