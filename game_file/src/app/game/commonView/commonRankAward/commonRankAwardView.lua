local commonRankAwardView = class("commonRankAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonRankAwardView")
	end
	return target
end)
function commonRankAwardView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgDownBg = SoraDGetChildByName(self, "Image_1")
	self.txtTip = SoraDGetChildByName(self, "text_tip")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
end
function commonRankAwardView:setTitle(str)
	self.ccs_bg:setTitleName(str or i18n("hero_title_02"))
end
function commonRankAwardView:setDownTip(str)
	self.imgDownBg:setVisible(true)
	self.txtTip:setString(str or i18n("donate_text_16"))
	self.txtTip:setFontSize(18)
	SoraDSetTextWidthHeight(self.txtTip, cc.size(500, 50))
	self.scroll:setContentSize(cc.size(536, 500))
	self.scroll:setPositionY(self.scroll:getPositionY() + 36)
end
function commonRankAwardView:initData(data, otherData)
	local singleSize = otherData and otherData.singleSize or cc.size(536, 80)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = singleSize
	;(nil).param = otherData
	self.scroll:updateScrollView(singleSize, data, 1, nil)
	dump(otherData, "skdjfksldjflsd")
end
function commonRankAwardView:setSingleCCS(singleName)
	self.scroll:setSingleCCS(singleName)
end
return commonRankAwardView
