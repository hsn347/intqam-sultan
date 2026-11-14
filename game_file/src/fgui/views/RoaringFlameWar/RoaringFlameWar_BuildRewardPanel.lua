local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_BuildRewardPanel = class("RoaringFlameWar_BuildRewardPanel", baseFguiPanel)
function RoaringFlameWar_BuildRewardPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_BuildRewardPanel.super.ctor(self, ...)
	print("RoaringFlameWar_BuildRewardPanel:ctor", self.viewName)
	self.totalTime = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CITY_BOX_TIME", 7200)
end
function RoaringFlameWar_BuildRewardPanel:onInit()
	print("=======RoaringFlameWar_BuildRewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_text_0019"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlameWar_BuildRewardPanel:endShow()
	print("=======RoaringFlameWar_BuildRewardPanel:endShow")
	local defaultClick = self.param.defaultClick or 1
	_ENV, self.buildLv = self.param.buildLv or 0, self.param.buildLv or 0
	_ENV, _ENV, (self.param.buildLv or 0).defaultClick = nil, nil, defaultClick
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("flames_dunes_text252")
	;(self.param.buildLv or 0).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("flames_dunes_text253")
	local (self.param.buildLv or 0).callback, param = handler(self, self.onClickTab), self.param.buildLv or 0
	self.fields.com_TabW:initView(param)
end
function RoaringFlameWar_BuildRewardPanel:onClickTab(tag)
	self.curTag = tag
	if self.curTag == 1 then
		_ENV = nil
		;(nil).time = math.floor(self.totalTime / 3600)
		self.fields.Text_tip:setString(i18n("flames_dunes_text254", nil))
	else
		self.fields.Text_tip:setString(i18n("flames_dunes_text255"))
	end
	local maxLv = roaringFlameWarRead.getCityBoxMaxLv()
	self.fields.List:setNumItems(maxLv)
end
function RoaringFlameWar_BuildRewardPanel:onItemRenderer(index, obj)
	local level = index + 1
	local roaringFlameWarRead, awardList
	if self.curTag == 1 then
		awardList = roaringFlameWarRead.getCityBoxReward(level)
	else
		awardList = roaringFlameWarRead.getCityFirstReward(level)
	end
	local _fidlds = fguiHelper.get_fields(obj)
	roaringFlameWarRead = nil
	;(nil).isSelect = true
	roaringFlameWarRead = nil
	;(nil).lv = level
	;(nil).rankStr = i18n("common_text_2567", nil)
	;(nil).awardList = awardList
	_fidlds.base:initCustomData(nil)
	if level == self.buildLv then
		obj:getController("c1"):setSelectedIndex(1)
	else
		obj:getController("c1"):setSelectedIndex(0)
	end
end
return RoaringFlameWar_BuildRewardPanel
