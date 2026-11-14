local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_harvestSeason = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_harvestSeason", Btn_harvestSeason)
function Btn_harvestSeason:onInit()
	self.fields.lab_red:fixPos()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_harvestSeason:onShow()
end
function Btn_harvestSeason:initData(data)
	self.actIDList = data.actIDList
	local remainTime = 0
	for actID, v in pairs(config) do
		if clientEventMgr.judgeIsOpen(actID) then
			local eventTime = activityShowCtrl:getTimeInfoByID(actID)
			if eventTime then
				local tmp = eventTime.timerNode.timer:getRemainTime()
				if remainTime < tmp then
					remainTime = tmp
				end
			end
		end
	end
	if 0 < remainTime then
		self.Text_Time:beginTime(remainTime)
	end
end
function Btn_harvestSeason:setRed(num)
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setString(num)
end
function Btn_harvestSeason:onBtnClick()
	SoraDPlaySound()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewList2Msg(self.actIDList)
	self.fields.lab_red:setVisible(false)
	uiManager:show("HarvestSeasonMain")
end
return Btn_harvestSeason
