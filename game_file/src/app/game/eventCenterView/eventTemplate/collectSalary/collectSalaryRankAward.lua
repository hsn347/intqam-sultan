local collectSalaryRead = include("collectSalaryRead")
local collectSalaryRankAward = class("collectSalaryRankAward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("collectSalaryRankAward")
	end
	return target
end)
function collectSalaryRankAward:ctor()
	self.itemSize = cc.size(536, 100)
	self.chooseColor = cc.c3b(237, 226, 154)
	self.unChooseColor = cc.c3b(108, 102, 92)
	self:initWidget()
end
function collectSalaryRankAward:initWidget()
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
	end
end
function collectSalaryRankAward:initData(rType)
	self:switchTab(rType)
end
function collectSalaryRankAward:refreshData(rType)
	local rankData = collectSalaryRead.getRankAward(rType)
	if rType == 1 then
		collectSalaryRead = nil
		;(nil).num = 100
		self.txtTip:setString(i18n("rides_text_14", nil))
	else
		collectSalaryRead = i18n("rides_text_14", nil)
		i18n("rides_text_14", nil).num = 10
		self.txtTip:setString(i18n("rides_text_14", i18n("rides_text_14", nil)))
	end
	collectSalaryRead = i18n("rides_text_14", i18n("rides_text_14", nil))
	i18n("rides_text_14", i18n("rides_text_14", nil)).scroll = self.scroll
	i18n("rides_text_14", i18n("rides_text_14", nil)).view = self
	i18n("rides_text_14", i18n("rides_text_14", nil)).singleSize = self.itemSize
	self.scroll:updateScrollView(self.itemSize, rankData, 1, i18n("rides_text_14", i18n("rides_text_14", nil)))
	self.scroll:jumpToTop()
end
function collectSalaryRankAward:btn_onClick_btns(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTab(target:getTag())
	end
end
function collectSalaryRankAward:switchTab(index)
	if index == 1 then
		self:setSelectState(self.Button_1)
		self:setUnSelectState(self.Button_2)
	else
		self:setSelectState(self.Button_2)
		self:setUnSelectState(self.Button_1)
	end
	self:refreshData(index)
end
function collectSalaryRankAward:setUnSelectState(btn)
	btn:setTouchEnabled(true)
	btn:setBright(false)
	btn:setTitleColor(self.unChooseColor)
end
function collectSalaryRankAward:setSelectState(btn)
	btn:setTouchEnabled(false)
	btn:setBright(true)
	btn:setTitleColor(self.chooseColor)
end
return collectSalaryRankAward
