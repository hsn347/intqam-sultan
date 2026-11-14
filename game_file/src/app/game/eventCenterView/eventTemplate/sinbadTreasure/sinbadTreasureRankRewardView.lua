local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local commonRankAwardView = include("commonRankAwardView")
local sinbadTreasureRankRewardView = class("sinbadTreasureRankRewardView", commonRankAwardView)
local sinbadTreasureRead = include("sinbadTreasureRead")
function sinbadTreasureRankRewardView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgDownBg = SoraDGetChildByName(self, "Image_1")
	self.txtTip = SoraDGetChildByName(self, "text_tip")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	local preViewHeight = 960
	local curHeight = display.height
	local setSize = cc.size(self.ccs_bg:getContentSize().width, 600)
	self.ccs_bg:setSize(setSize)
	self.ccs_bg:setPositionY(-setSize.height / 2)
	self.imgDownBg:setPositionX(setSize.width / 2)
	local ccs_tab = SoraDCreatePanel("commonTabBtnEX")
	ccs_tab:addTo(self.scaleActTarget)
	ccs_tab:setPosition(0, self.ccs_bg:getSize().height / 2 - 80)
	ccs_tab:setContentSize(cc.size(530, 56))
	ccs_tab:setNewStyle()
	self.ccs_tab = ccs_tab
end
function sinbadTreasureRankRewardView:setTitle(str, rankType)
	self.ccs_bg:setTitleName(str or i18n("hero_title_02"))
	_ENV, _ENV = self.ccs_bg, self.ccs_bg.setTitleName
	self.ccs_bg.title = i18n("Sinbad_text_23")
	_ENV, self.ccs_bg.setTitleName[1], self.ccs_bg.handle = self.ccs_bg, self.ccs_bg, handler(self, self.btn_onClick_btns)
	self.ccs_bg.title = i18n("Sinbad_text_22")
	self.ccs_bg.setTitleName[2], self.ccs_bg.handle = self.ccs_bg, handler(self, self.btn_onClick_btns)
	local tabConfig = self.ccs_bg.setTitleName
	_ENV = self
	self.tabNum = #tabConfig
	self.defaultClick = rankType == 1 and 2 or 1
	self.tabsetArray = tabConfig
	self.ccs_tab:initView(self)
end
function sinbadTreasureRankRewardView:initData(data, otherData)
	local singleSize = otherData and otherData.singleSize or cc.size(536, 80)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = singleSize
	;(nil).param = otherData
	self.scroll:updateScrollView(singleSize, data, 1, nil)
end
function sinbadTreasureRankRewardView:btn_onClick_btns(tag, name)
	print("sdlkfjskdjf", tag)
	local rankType = tag == 1 and 2 or 3
	local _ENV, data = "sdlkfjskdjf", "sdlkfjskdjf"
	local rankData = sinbadTreasureRead.getRankData(rankType, sinbadTreasureCtrl:getClassType())
	for k, v in ipairs(rankData) do
		sinbadTreasureCtrl, _ENV = sinbadTreasureCtrl:getClassType()
		sinbadTreasureCtrl:getClassType().rank, sinbadTreasureCtrl:getClassType()[1] = sinbadTreasureCtrl:getClassType()
		sinbadTreasureCtrl:getClassType().rank, sinbadTreasureCtrl:getClassType()[2] = sinbadTreasureCtrl:getClassType()
		data[k], sinbadTreasureCtrl:getClassType().reward = sinbadTreasureCtrl:getClassType()
	end
	self:setDownTip(i18n("common_text_2211"))
	_ENV = i18n("common_text_2211")
	self:initData(data, i18n("common_text_2211"))
	self.scroll:setContentSize(cc.size(530, 448))
	self.scroll:setPositionY(-248)
end
return sinbadTreasureRankRewardView
