local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleWarSettingPanel = class("kingdomBattleWarSettingPanel", baseFguiPanel)
function kingdomBattleWarSettingPanel:ctor(...)
	self.isLRU = true
	kingdomBattleWarSettingPanel.super.ctor(self, ...)
	print("kingdomBattleWarSettingPanel:ctor", self.viewName)
end
function kingdomBattleWarSettingPanel:onInit()
	print("=======kingdomBattleWarSettingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_195"))
	self.fields.Label_title_area:setString(i18n("NebulaAllstar_196"))
	self.fields.Label_title_speed:setString(i18n("NebulaAllstar_199"))
	self.fields.Label_title_switch:setString(i18n("NebulaAllstar_203"))
	self.fields.Text_switch:setString(i18n("NebulaAllstar_204"))
	self.fields.List_area:setItemRenderer(handler(self, self.onAreaItemRender))
	self.fields.List_speed:setItemRenderer(handler(self, self.onSpeedItemRender))
	self.view:fixChildrenPos()
end
function kingdomBattleWarSettingPanel:onAreaItemRender(index, obj)
	obj:setTitle(self.areaCfg[index + 1])
	obj:setSelected(index == self.areaIndex - 1)
end
function kingdomBattleWarSettingPanel:onSpeedItemRender(index, obj)
	obj:setTitle(self.speedCfg[index + 1])
	obj:setSelected(index == self.speedIndex - 1)
end
function kingdomBattleWarSettingPanel:endShow()
	print("=======kingdomBattleWarSettingPanel:endShow")
	self.mapClassType = self.param and self.param.mapClassType or gKingdomClassType.normal
	self.barrageCfg = worldMapDefine.getBarrageCfg(self.mapClassType)
	if not SoraDConfigGet(self.barrageCfg.localSettingKey) then
		_ENV = SoraDConfigGet(self.barrageCfg.localSettingKey)
	end
	self.settingTb = SoraDConfigGet(self.barrageCfg.localSettingKey)
	self.areaIndex = self.settingTb[1] or self.barrageCfg.defaultSetting[1]
	self.speedIndex = self.settingTb[2] or self.barrageCfg.defaultSetting[2]
	self.switch = self.settingTb[3]
	if self.switch == nil then
		self.switch = self.barrageCfg.defaultSetting[3]
	end
	_UPVALUE3_ = self.barrageCfg.defaultSetting[3]
	_UPVALUE2_, self.areaCfg, self.barrageCfg.defaultSetting[3][1] = self.barrageCfg.defaultSetting[3], self.barrageCfg.defaultSetting[3], "1/4"
	_UPVALUE2_, self.areaCfg, self.barrageCfg.defaultSetting[3][2] = self.barrageCfg.defaultSetting[3], self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_197")
	_UPVALUE2_, self.areaCfg, self.barrageCfg.defaultSetting[3][3] = self.barrageCfg.defaultSetting[3], self.barrageCfg.defaultSetting[3], "3/4"
	_UPVALUE2_, self.areaCfg, self.barrageCfg.defaultSetting[3][4] = self.barrageCfg.defaultSetting[3], self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_198")
	_UPVALUE2_, self.areaCfg, self.barrageCfg.defaultSetting[3][5] = self.barrageCfg.defaultSetting[3], self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_198")
	self.speedCfg, self.barrageCfg.defaultSetting[3][1] = self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_200")
	self.speedCfg, self.barrageCfg.defaultSetting[3][2] = self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_201")
	self.speedCfg, self.barrageCfg.defaultSetting[3][3] = self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_202")
	self.speedCfg, self.barrageCfg.defaultSetting[3][4] = self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_202")
	self.speedCfg, self.barrageCfg.defaultSetting[3][5] = self.barrageCfg.defaultSetting[3], i18n("NebulaAllstar_202")
	self.fields.List_area:setNumItems(#self.areaCfg)
	self.fields.List_speed:setNumItems(#self.speedCfg)
	self.fields.Check_tick_switch:setSelected(self.switch)
end
function kingdomBattleWarSettingPanel:onHide()
	local dirty = false
	local value = self.fields.List_area:getSelectedIndex() + 1
	if self.settingTb[1] ~= value then
		self.settingTb[1] = value
		dirty = true
	end
	local value = self.fields.List_speed:getSelectedIndex() + 1
	if self.settingTb[2] ~= value then
		self.settingTb[2] = value
		dirty = true
	end
	local value = self.fields.Check_tick_switch:isSelected()
	if self.settingTb[3] ~= value then
		self.settingTb[3] = value
		dirty = true
	end
	if dirty then
		SoraDConfigSet(self.barrageCfg.localSettingKey, self.settingTb)
		_ENV = self.barrageCfg.localSettingKey
		self.barrageCfg.localSettingKey.msg = "MESSAGE_WAR_BARRAGE_SETTING"
		SoraDSendMessage(self.barrageCfg.localSettingKey)
	end
end
return kingdomBattleWarSettingPanel
