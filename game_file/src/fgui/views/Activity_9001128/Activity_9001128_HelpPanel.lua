local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001128_HelpPanel = class("Activity_9001128_HelpPanel", baseFguiPanel)
function Activity_9001128_HelpPanel:ctor(...)
	Activity_9001128_HelpPanel.super.ctor(self, ...)
	print("Activity_9001128_HelpPanel:ctor", self.viewName)
end
function Activity_9001128_HelpPanel:onInit()
	print("=======Activity_9001128_HelpPanel:onInit")
	self.cfgList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("activityname_24"))
	self.fields.Text_msg:setString(i18n("lucky_text_01"))
	self.fields.Label_title:setString(i18n("lucky_text_25"))
	self.fields.Text_discount:setString(i18n("lucky_text_05"))
	self.fields.Text_bless:setString(i18n("alliance_beast_btn_08"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_discount:fixPos()
	self.fields.Text_bless:fixPos()
end
function Activity_9001128_HelpPanel:onShow()
	print("=======Activity_9001128_HelpPanel:onShow")
	local classtype = SoraDGetActivityClassType(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY)
	_ENV = gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY
	gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY[1] = i18n("daily_reward_name_05")
	gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY[2] = i18n("daily_reward_name_06")
	gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY[3] = i18n("limitactivities_sectiontitle_03")
	gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY[4] = i18n("daily_reward_name_20")
	local gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY[5], configMsg = i18n("cat_common_05"), gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY
	local config = require("app." .. LocalTblPath .. ".config_server.lucky_blessing_config")
	self.cfgList, _ENV = "app." .. LocalTblPath .. ".config_server.lucky_blessing_config", "app." .. LocalTblPath .. ".config_server.lucky_blessing_config"
	for i, v in ipairs(config) do
		if v.group == classtype then
			local _ENV, single = v.group, v.group
			_ENV = nil
			;(nil).num = string.format("%d%%", v.value / 10)
			single.msgLeft = i18n("lucky_text_06", nil)
			single.msgRight = configMsg[v.type]
			single.index = i
			_ENV = nil
			;(nil).num = string.format("%d%%", v.value / 10)
			local discountStr = i18n("lucky_text_06", nil)
			if v.type == gLuckyBlessActivityEffectType.MAKE_A_WISH then
				_ENV = string.format("%d%%", v.value / 10)
				string.format("%d%%", v.value / 10).num = string.format("%d%%", v.value / 10)
				discountStr = i18n("common_text_4858", (string.format("%d%%", v.value / 10)))
			end
			_ENV = string.format("%d%%", v.value / 10)
			string.format("%d%%", v.value / 10).discount = discountStr
			string.format("%d%%", v.value / 10).bless = configMsg[v.type]
			table.insert(self.cfgList, (string.format("%d%%", v.value / 10)))
		end
	end
	self.fields.List:setNumItems(#self.cfgList)
end
function Activity_9001128_HelpPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgList[index + 1], index + 1)
end
return Activity_9001128_HelpPanel
