local activity_9001736_Read = include("activity_9001736_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_BondPanel = class("Activity_9001736_BondPanel", baseFguiPanel)
function Activity_9001736_BondPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_BondPanel.super.ctor(self, ...)
	print("Activity_9001736_BondPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_BondPanel:onInit()
	print("=======Activity_9001736_BondPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("football_match_text_029"))
	self.fields.Text_tip:setString(i18n("football_match_text_030"))
	self.fields.Text_tip2:setString(i18n("football_match_text_033"))
end
function Activity_9001736_BondPanel:endShow()
	print("=======Activity_9001736_BondPanel:endShow")
	self.activiBondIdx = self.param.activiBondIdx or 0
	self.bondConfig = activity_9001736_Read:getBondConfig()
	self.fields.List:setNumItems(#self.bondConfig)
end
function Activity_9001736_BondPanel:itemRenderer_List(index, obj)
	local cfg = self.bondConfig[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).num = cfg.bondNum
	local nameStr = i18n("football_match_text_031", nil)
	_fields.Text_name:setString(nameStr)
	local powerUp = cfg.powerUp
	local powerUpStr = string.format("+%s%%", tostring(powerUp / 100))
	_ENV = tostring(powerUp / 100)
	tostring(powerUp / 100).num = powerUpStr
	local valueStr = i18n("football_match_text_032", tostring(powerUp / 100))
	_fields.Text_value:setString(valueStr)
	local showSelect = index + 1 == self.activiBondIdx
	_fields.Image_select:setVisible(showSelect)
	local showLight = index % 2 ~= 0
	_fields.Image_light:setVisible(showLight)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
return Activity_9001736_BondPanel
