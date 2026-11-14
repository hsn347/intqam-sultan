local roaringFlameWarUtil = include("roaringFlameWarUtil")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWarBeAttackPanel = class("RoaringFlameWarBeAttackPanel", baseFguiPanel)
function RoaringFlameWarBeAttackPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWarBeAttackPanel.super.ctor(self, ...)
	print("RoaringFlameWarBeAttackPanel:ctor", self.viewName)
end
function RoaringFlameWarBeAttackPanel:onInit()
	print("=======RoaringFlameWarBeAttackPanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text157"))
	self.fields.Text_msg:setString(i18n("flames_dunes_text158"))
	self.fields.Button_quit:setString(i18n("common_text_3351"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickBtnQuit))
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("flames_dunes_text159", nil)
	end)
	self.fields.Text_time:setTimeEndListener(function()
		self:closePanel()
	end)
end
function RoaringFlameWarBeAttackPanel:endShow()
	print("=======RoaringFlameWarBeAttackPanel:endShow")
	local queueMap = kingdomMapCtrl:getWatchTowerQueue(true):getAllWatchTowerQueue()
	dump(queueMap, "==queueMap==")
	local remain
	for __, queue in pairs(queueMap) do
		local _remain = queue:getStatusRemainTime()
		if not remain or remain > _remain then
			remain = _remain
		end
	end
	if remain then
		self.fields.Text_time:beginTime(remain)
	end
end
function RoaringFlameWarBeAttackPanel:onClickBtnQuit(...)
	SoraDPlaySound()
	roaringFlameWarUtil.quitBattlefield()
end
return RoaringFlameWarBeAttackPanel
