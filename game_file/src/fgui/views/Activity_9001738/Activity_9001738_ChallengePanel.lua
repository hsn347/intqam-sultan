local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_ChallengePanel = class("Activity_9001738_ChallengePanel", baseFguiPanel)
function Activity_9001738_ChallengePanel:ctor(...)
	self.isLRU = true
	Activity_9001738_ChallengePanel.super.ctor(self, ...)
	print("Activity_9001738_ChallengePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_ChallengePanel:onInit()
	print("=======Activity_9001738_ChallengePanel:onInit")
	self.fields.listSelect:setDefaultItem("ui://Activity_9001738/ComItemSelect")
	self.fields.listSelect:setItemRenderer(handler(self, self.itemRenderer_listSelect))
	_ENV = handler(self, self.itemRenderer_listSelect)
	handler(self, self.itemRenderer_listSelect).num = 1
	self.fields.Panel_bg:setString(i18n("memory_flip_text_05", handler(self, self.itemRenderer_listSelect)))
	self.fields.txtTip:setString(i18n("memory_flip_text_09"))
	self.fields.btnChallenge:setTitle(i18n("arena_btn_04"))
	self.fields.btnChallenge:addClickListener(handler(self, self.onClick_btnChallenge))
end
function Activity_9001738_ChallengePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_ChallengePanel:endShow()
	print("=======Activity_9001738_ChallengePanel:endShow")
	self:initData()
end
function Activity_9001738_ChallengePanel:itemRenderer_listSelect(index, obj)
	local data = self.listSelectData[index + 1]
	obj:initData(data, self.selectedItemMap[data.itemID] == true, handler(self, self.onSelectConsumable), index)
end
function Activity_9001738_ChallengePanel:onSelectConsumable(itemID, isSelected, index)
	self.selectedItemMap[itemID] = isSelected or nil
	if not isSelected then
		self.fields.listSelect:RemoveSelection(index)
	end
end
function Activity_9001738_ChallengePanel:getSelectedItemList()
	local _ENV, ret
	if not self.listSelectData then
		_ENV = self.listSelectData
	end
	for _, cfg in ipairs(self.listSelectData) do
		if self.selectedItemMap[cfg.itemID] then
			table.insert(ret, cfg.itemID)
		end
	end
	return ret
end
function Activity_9001738_ChallengePanel:initData()
	self.selectedItemMap, activity_9001738_Ctrl, self.levelID = self.param and self.param.levelID or activity_9001738_Ctrl:getLevelId(), self.param and self.param.levelID or activity_9001738_Ctrl:getLevelId(), self.param and self.param.levelID or activity_9001738_Ctrl:getLevelId()
	self.listSelectData = activity_9001738_Read.getItemList()
	activity_9001738_Ctrl = nil
	;(nil).num = self.levelID
	self.fields.Panel_bg:setString(i18n("memory_flip_text_05", nil))
	self.fields.listSelect:setNumItems(#self.listSelectData)
end
function Activity_9001738_ChallengePanel:onClick_btnChallenge(context)
	SoraDPlaySound()
	activity_9001738_Ctrl:reqEnterMsg(self.levelID, self:getSelectedItemList())
end
return Activity_9001738_ChallengePanel
