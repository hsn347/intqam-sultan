local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarBarrageSettingPanel = class("NebulaAllStarBarrageSettingPanel", baseFguiPanel)
function NebulaAllStarBarrageSettingPanel:ctor(...)
	NebulaAllStarBarrageSettingPanel.super.ctor(self, ...)
	print("NebulaAllStarBarrageSettingPanel:ctor", self.viewName)
	self.curSetting = nebulaAllStarUtil.getBarrageSetting()
end
function NebulaAllStarBarrageSettingPanel:onHide()
	print("=======NebulaAllStarBarrageSettingPanel:onHide")
	local dirty = false
	local value = self._fields1.List:getSelectedIndex() + 1
	if self.curSetting[1] ~= value then
		self.curSetting[1] = value
		dirty = true
	end
	local value = self._fields2.List:getSelectedIndex() + 1
	if self.curSetting[2] ~= value then
		self.curSetting[2] = value
		dirty = true
	end
	local value = self._fields3.Check_tick:isSelected()
	if self.curSetting[3] ~= value then
		self.curSetting[3] = value
		dirty = true
	end
	if dirty then
		nebulaAllStarUtil.setBarrageSetting(self.curSetting)
		_ENV = self.curSetting
		self.curSetting.msg = "MESSAGE_NEBULA_ALLSTAR_BARRAGE_SETTING"
		SoraDSendMessage(self.curSetting)
	end
end
function NebulaAllStarBarrageSettingPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "ChatSetting"
	return nil
end
function NebulaAllStarBarrageSettingPanel:onInit()
	print("=======NebulaAllStarBarrageSettingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("NebulaAllstar_195"))
	local _fields = fguiHelper.get_fields(self.fields.Com_setting1)
	self._fields1 = _fields
	_fields.Com_base:setString(i18n("NebulaAllstar_196"))
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer1))
	_UPVALUE3_ = _fields.List.setItemRenderer
	self.setting1, _fields.List.setItemRenderer[1] = _fields.List.setItemRenderer, "1/4"
	self.setting1, _fields.List.setItemRenderer[2] = _fields.List.setItemRenderer, i18n("NebulaAllstar_197")
	self.setting1, _fields.List.setItemRenderer[3] = _fields.List.setItemRenderer, "3/4"
	self.setting1, _fields.List.setItemRenderer[4] = _fields.List.setItemRenderer, i18n("NebulaAllstar_198")
	self.setting1, _fields.List.setItemRenderer[5] = _fields.List.setItemRenderer, i18n("NebulaAllstar_198")
	_fields.List:setNumItems(#self.setting1)
	_fields.List:setSelectedIndex(self.curSetting[1] - 1)
	local _fields = fguiHelper.get_fields(self.fields.Com_setting2)
	self._fields2 = _fields
	_fields.Com_base:setString(i18n("NebulaAllstar_199"))
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer2))
	_UPVALUE2_ = _fields.List.setItemRenderer
	self.setting2, _fields.List.setItemRenderer[1] = _fields.List.setItemRenderer, i18n("NebulaAllstar_200")
	self.setting2, _fields.List.setItemRenderer[2] = _fields.List.setItemRenderer, i18n("NebulaAllstar_201")
	self.setting2, _fields.List.setItemRenderer[3] = _fields.List.setItemRenderer, i18n("NebulaAllstar_202")
	self.setting2, _fields.List.setItemRenderer[4] = _fields.List.setItemRenderer, i18n("NebulaAllstar_202")
	_fields.List:setNumItems(#self.setting2)
	_fields.List:setSelectedIndex(self.curSetting[2] - 1)
	local _fields = fguiHelper.get_fields(self.fields.Com_setting3)
	self._fields3 = _fields
	_fields.Com_base:setString(i18n("NebulaAllstar_203"))
	_fields.Text_setting:setString(i18n("NebulaAllstar_204"))
	if self.curSetting[3] then
		_fields.Check_tick:setSelected(true)
	end
end
function NebulaAllStarBarrageSettingPanel:onShow()
	print("=======NebulaAllStarBarrageSettingPanel:onShow")
end
function NebulaAllStarBarrageSettingPanel:onItemRenderer1(index, obj)
	local text = self.setting1[index + 1]
	obj:setString(text)
end
function NebulaAllStarBarrageSettingPanel:onItemRenderer2(index, obj)
	local text = self.setting2[index + 1]
	obj:setString(text)
end
return NebulaAllStarBarrageSettingPanel
