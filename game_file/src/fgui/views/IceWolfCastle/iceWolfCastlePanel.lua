local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local iceWolfCastleCtrl = SoraDGetCtrl("iceWolfCastleCtrl")
local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local basePanel = require("fgui.base.baseFguiPanel")
local iceWolfCastlePanel = class("iceWolfCastlePanel", basePanel)
function iceWolfCastlePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function iceWolfCastlePanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
	end
	return self._packageList
end
function iceWolfCastlePanel:onInit()
	self.fields.Com_title:initData(i18n("activity_name_9001396"), handler(self, self.onClickClose))
	self.fields.textTips:setString(i18n("snowwolf_text_01"))
	self.fields.GetRank:initData(2)
	self.fields.GiveRank:initData(1)
	self.fields.GetRank:fixPos()
	self.fields.GiveRank:fixPos()
	self.fields.com_ItemNum:setString(i18n("common_text_3893"))
	self.fields.com_ItemNum:initData(843801)
end
function iceWolfCastlePanel:onShow()
	SoraDShowLoading()
	iceWolfCastleCtrl:reqRamadanShiningCastleActivityData4()
	self:initActivityTime()
end
function iceWolfCastlePanel:initActivityTime()
	self.fields.Labe_Time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RAMADAN_SHINING_CASTLE_4)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.Labe_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function iceWolfCastlePanel:updateRankInfo()
	self.fields.GetRank:updateRankInfo()
	self.fields.GiveRank:updateRankInfo()
end
return iceWolfCastlePanel
