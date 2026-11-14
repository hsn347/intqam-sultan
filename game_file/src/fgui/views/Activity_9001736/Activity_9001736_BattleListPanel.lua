local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_BattleListPanel = class("Activity_9001736_BattleListPanel", baseFguiPanel)
function Activity_9001736_BattleListPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_BattleListPanel.super.ctor(self, ...)
	print("Activity_9001736_BattleListPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_BattleListPanel:onInit()
	print("=======Activity_9001736_BattleListPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("football_match_text_012"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClick_Button_refresh))
	self.fields.Button_record:setTitle(i18n("football_match_text_013"))
	self.fields.Button_record:addClickListener(handler(self, self.onClick_Button_record))
end
function Activity_9001736_BattleListPanel:endShow()
	print("=======Activity_9001736_BattleListPanel:endShow")
	self:updateData()
end
function Activity_9001736_BattleListPanel:updateData()
	self:updateRefreshTimes()
	self:updateChallengeTimes()
	activity_9001736_Ctrl:reqBattleList()
end
function Activity_9001736_BattleListPanel:onClick_Button_refresh(context)
	SoraDPlaySound()
	activity_9001736_Ctrl:reqBattleList(true)
end
function Activity_9001736_BattleListPanel:onClick_Button_record(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001736_BattleRecord")
end
function Activity_9001736_BattleListPanel:updateRefreshTimes()
	local curTimes = activity_9001736_Ctrl:getBattleListRefreshTimes()
	local maxTimes = activity_9001736_Ctrl:getMaxFreeRefreshTimes()
	local leftTimes = math.max(0, maxTimes - curTimes)
	activity_9001736_Ctrl = nil
	;(nil).member = leftTimes
	;(nil).total = maxTimes
	local numStr = i18n("common_text_155", nil)
	activity_9001736_Ctrl = nil
	;(nil).num = numStr
	local refreshStr = i18n("football_match_text_014", nil)
	self.fields.Button_refresh:setTitle(refreshStr)
	self.fields.Button_refresh:setEnabled(0 < leftTimes)
end
function Activity_9001736_BattleListPanel:updateChallengeTimes()
	local leftTimes = activity_9001736_Ctrl:getChallengeLeftTimes()
	activity_9001736_Ctrl = nil
	;(nil).num = leftTimes
	local titleStr = i18n("football_match_text_007", nil)
	self.fields.Label_title:setString(titleStr)
end
function Activity_9001736_BattleListPanel:onMsgUpdateBattleList(target, event)
	local battleList = event.battleList
	table.sort(battleList, function(a, b)
		return a.rank < b.rank
	end)
	self.battleList = battleList
	self.fields.List:setNumItems(#self.battleList)
	self:updateRefreshTimes()
end
function Activity_9001736_BattleListPanel:itemRenderer_List(index, obj)
	local data = self.battleList[index + 1]
	obj:initData(data)
end
function Activity_9001736_BattleListPanel:onMsgUpdateData()
	self:updateData()
end
return Activity_9001736_BattleListPanel
