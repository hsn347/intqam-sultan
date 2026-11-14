local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local endlessTrialsRankAward = class("endlessTrialsRankAward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("endlessTrialsRankAward")
	end
	return target
end)
function endlessTrialsRankAward:ctor()
	self.itemSize = cc.size(536, 100)
	self.chooseColor = cc.c3b(237, 226, 154)
	self.unChooseColor = cc.c3b(108, 102, 92)
	self:initWidget()
end
function endlessTrialsRankAward:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.txtTip = SoraDGetChildByName(self, "text_tip")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	self.ccs_bg:setTitleName(i18n("common_text_2194"))
	self.Button_1 = SoraDGetChildByName(self, "Button_1")
	_ENV, _ENV, self.Button_2 = self, SoraDGetChildByName(self, "Button_2"), SoraDGetChildByName(self, "Button_2")
	self.title = i18n("god_beast_text_08")
	_ENV, SoraDGetChildByName(self, "Button_2")[1], self.handle = self, self, handler(self, self.btn_onClick_btns)
	self.title = i18n("Endless_trial_text_14")
	SoraDGetChildByName(self, "Button_2")[2], self.handle = self, handler(self, self.btn_onClick_btns)
	local tabsetArray = SoraDGetChildByName(self, "Button_2")
	_UPVALUE2_ = handler(self, self.btn_onClick_btns)
	handler(self, self.btn_onClick_btns)[1] = self.Button_1
	handler(self, self.btn_onClick_btns)[2] = self.Button_2
	for i, v in ipairs((handler(self, self.btn_onClick_btns))) do
		v:addTouchEventListener(tabsetArray[i].handle)
		v:setTitleText(tabsetArray[i].title)
		v:setTag(i)
		SoraDAutoSizeButtonText(v, cc.size(220, 36))
	end
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf01")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(self.scaleActTarget)
	effect:setPosition(0, -116)
	effect:setScaleY(self.ccs_bg:getSize().height / 635)
end
function endlessTrialsRankAward:initData(rType)
	self:switchTab(rType)
end
function endlessTrialsRankAward:refreshData(rType)
	local rankData = endlessTrialsCtrl:getRewardsConfig(rType)
	endlessTrialsCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = self.itemSize
	self.scroll:updateScrollView(self.itemSize, rankData, 1, nil)
end
function endlessTrialsRankAward:btn_onClick_btns(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTab(target:getTag())
	end
end
function endlessTrialsRankAward:switchTab(index)
	_ENV = nil
	;(nil).num = index == 1 and 100 or 10
	self.txtTip:setString(i18n("rides_text_14", nil))
	if index == 1 then
		self:setSelectState(self.Button_1)
		self:setUnSelectState(self.Button_2)
	else
		self:setSelectState(self.Button_2)
		self:setUnSelectState(self.Button_1)
	end
	self:refreshData(index)
end
function endlessTrialsRankAward:setUnSelectState(btn)
	btn:setTouchEnabled(true)
	btn:setBright(false)
	btn:setTitleColor(self.unChooseColor)
end
function endlessTrialsRankAward:setSelectState(btn)
	btn:setTouchEnabled(false)
	btn:setBright(true)
	btn:setTitleColor(self.chooseColor)
end
return endlessTrialsRankAward
