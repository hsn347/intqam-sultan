local gametop = gModuleMgr.getObject("gametop")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local spiritualGiftAreaView = class("spiritualGiftAreaView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("spiritualGiftAreaView")
	end
	return target
end)
singleAreaNodeH = 35
function spiritualGiftAreaView:ctor()
	self:initControls()
	self:initScroll()
end
function spiritualGiftAreaView:initControls()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.ccs_bg:setTitleName(i18n("godGift_title_03"))
	self.areaList = spiritualGiftCtrl:getOpenAreaList()
end
function spiritualGiftAreaView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, singleAreaNodeH * #self.areaList)
	self.scroll:setInnerContainerSize(cc.size(518, scrollH))
	for i, v in ipairs(self.areaList) do
		local single = self.nodeSingle:clone()
		single:setPosition(259, scrollH - (i - 1) * singleAreaNodeH)
		single:addTo(self.scroll)
		local imgBg = SoraDGetChildByName(single, "Image_6")
		imgBg:setVisible(i % 2 == 0)
		local txtName = SoraDGetChildByName(single, "Text_name")
		_ENV = cc.size(518, scrollH)
		cc.size(518, scrollH).num = v
		txtName:setString(i18n("godGift_text_17", cc.size(518, scrollH)))
	end
end
return spiritualGiftAreaView
