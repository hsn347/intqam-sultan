local ancientTreasureRead = include("ancientTreasureRead")
local eventAncientSecretAwardView = class("eventAncientSecretAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventAncientSecretAwardView")
	end
	return target
end)
function eventAncientSecretAwardView:ctor()
	self.rewardArray, _ENV = nil, nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("AncienTreasure_text_05"))
	self.Icon_box = SoraDGetChildByName(self, "Icon_box")
	self.Text_boxName = SoraDGetChildByName(self, "Text_boxName")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("AncienTreasure_text_09"))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(536, 56))
	self.ccs_tab:setChoosePng("btn_secondarybtn_long_01.png")
	self.ccs_tab:setUnChoosePng("btn_secondarybtn_long_02.png")
	_ENV = "btn_secondarybtn_long_02.png"
	_ENV, _ENV, ("btn_secondarybtn_long_02.png").tabNum = cc.size(536, 56)
	cc.size(536, 56).title = i18n(ancientTreasureRead.getBoxInfoByIndex(1).name)
	_ENV, cc.size(536, 56)[1], cc.size(536, 56).handle = cc.size(536, 56)
	cc.size(536, 56).title = i18n(ancientTreasureRead.getBoxInfoByIndex(2).name)
	_ENV, cc.size(536, 56)[2], cc.size(536, 56).handle = cc.size(536, 56)
	cc.size(536, 56).title = i18n(ancientTreasureRead.getBoxInfoByIndex(3).name)
	;("btn_secondarybtn_long_02.png").tabsetArray, cc.size(536, 56)[3], cc.size(536, 56).handle = cc.size(536, 56)
	self.ccs_tab:initView("btn_secondarybtn_long_02.png")
end
function eventAncientSecretAwardView:initData(tag)
	self.ccs_tab:setDefaultClick(tag)
end
function eventAncientSecretAwardView:onTagClick(tag)
	local info = ancientTreasureRead.getBoxInfoByIndex(tag)
	self.Icon_box:setSpriteFrame(info.box)
	self.Text_boxName:setString(i18n(info.name))
	self.Text_des:setString(i18n(info.describe))
	for k, v in ipairs(info.reward) do
		if self.rewardArray[k] then
			self.rewardArray[k]:setVisible(true)
		else
			self.rewardArray[k] = include("commonItemAward").new()
			self.rewardArray[k]:setPosition(0, 0)
			self.rewardArray[k]:setScale(0.9)
			self.rewardArray[k]:setBaseScale(1.0)
			self.rewardArray[k]:setOwnView(self)
			self.rewardArray[k]:addTo(self.Node_award)
		end
		self.rewardArray[k]:initData(v, 1)
		self.rewardArray[k]:hideNum()
	end
	if #self.rewardArray > #info.reward then
		for k = #info.reward + 1, #self.rewardArray do
			self.rewardArray[k]:setVisible(false)
		end
	end
	SoraDToCenter(self.Node_award, 100, not SoraDFIsRA())
end
return eventAncientSecretAwardView
