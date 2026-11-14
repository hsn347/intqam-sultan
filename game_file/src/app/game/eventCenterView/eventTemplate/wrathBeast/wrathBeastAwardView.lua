local wrathBeastAwardSingle = include("wrathBeastAwardSingle")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local wrathBeastAwardView = class("wrathBeastAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("wrathBeastAwardView")
	end
	return target
end)
function wrathBeastAwardView:ctor()
	self:initWidget()
end
function wrathBeastAwardView:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("god_beast_text_04"))
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_btns")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	self.Node_sing_2 = SoraDGetChildByName(self, "Node_sing_2")
	self.btns:setContentSize(cc.size(535, 48))
	_UPVALUE2_ = self.btns.setContentSize
	self.btns.setContentSize[1] = i18n("god_beast_text_08")
	self.btns.setContentSize[2] = i18n("god_beast_text_07")
	self.btns.setContentSize[3] = i18n("god_beast_text_06")
	self.btns.setContentSize[4] = i18n("god_beast_text_06")
	self.btns.setContentSize[5] = i18n("god_beast_text_06")
	self.btns.setContentSize[6] = i18n("god_beast_text_06")
	self.btns.setContentSize[7] = i18n("god_beast_text_06")
	self.btns.setContentSize[8] = i18n("god_beast_text_06")
	self.btns.setContentSize[9] = i18n("god_beast_text_06")
	self.btns.setContentSize[10] = i18n("god_beast_text_06")
	self.btns.setContentSize[11] = i18n("god_beast_text_06")
	local self.btns.setContentSize[12], nameConfig = i18n("god_beast_text_06")
	local _ENV, configData = i18n("god_beast_text_08"), i18n("god_beast_text_08")
	configData.tabsetArray, _ENV, configData.tabNum = #nameConfig, #nameConfig, #nameConfig
	for i, v in ipairs(nameConfig) do
		_ENV = i18n("god_beast_text_06")
		i18n("god_beast_text_06").title = v
		i18n("god_beast_text_06").handle = handler(self, self.btnClickCallBack)
		i18n("god_beast_text_06").tag = i
		table.insert(configData.tabsetArray, i18n("god_beast_text_06"))
	end
	self.btns:initView(configData)
end
function wrathBeastAwardView:initData(data)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(536, 100), data, 1, nil)
end
function wrathBeastAwardView:btnClickCallBack(tag, name)
	wrathBeastAwardSingle = nil
	;(nil)[1] = i18n("god_beast_text_11")
	;(nil)[2] = i18n("god_beast_text_10")
	;(nil)[3] = i18n("god_beast_text_09")
	;(nil)[4] = i18n("god_beast_text_09")
	;(nil)[5] = i18n("god_beast_text_09")
	;(nil)[6] = i18n("god_beast_text_09")
	;(nil)[7] = i18n("god_beast_text_09")
	;(nil)[8] = i18n("god_beast_text_09")
	;(nil)[9] = i18n("god_beast_text_09")
	local (nil)[10], tipsConfig = i18n("god_beast_text_09")
	self.Text_tips:setString(tipsConfig[tag] or "")
	self.scroll:resetScroll()
	local _ENV, rankData = self.scroll.resetScroll, self.scroll.resetScroll
	if tag == 1 then
		rankData = wrathBeastCtrl:getRankRewardConfig()
		self.scroll:setSingleCreate(function()
			return SoraDCreatePanel("commonRankAwardSingle")
		end)
		_ENV = i18n("god_beast_text_09")
		i18n("god_beast_text_09").scroll = self.scroll
		i18n("god_beast_text_09").view = self
		i18n("god_beast_text_09").singleSize = cc.size(536, 100)
		self.scroll:updateScrollView(cc.size(536, 100), rankData, 1, i18n("god_beast_text_09"))
	else
		if tag == 2 then
			rankData = wrathBeastCtrl:getLuckyRewardConfig()
		else
			rankData = wrathBeastCtrl:getBoxRewardConfig()
		end
		self.scroll:setSingleCreate(function()
			return wrathBeastAwardSingle.new(self.Node_sing_2:clone())
		end)
		_ENV = i18n("god_beast_text_09")
		i18n("god_beast_text_09").scroll = self.scroll
		i18n("god_beast_text_09").view = self
		i18n("god_beast_text_09").type = tag
		self.scroll:updateScrollView(cc.size(536, 130), rankData, 1, i18n("god_beast_text_09"))
	end
	self.scroll:jumpIndexToTop()
end
return wrathBeastAwardView
