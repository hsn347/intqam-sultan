local commonSettingSwitchView = class("commonSettingSwitchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSettingSwitchView")
	end
	return target
end)
function commonSettingSwitchView:ctor()
	self:initControls()
end
function commonSettingSwitchView:initControls()
	self.Text_content = SoraDGetChildByName(self, "Text_content")
	self.CommonSwitch = SoraDGetExtendChildFromCCSByName(self, "CCS_gameSettingCommonSwitch_common")
end
function commonSettingSwitchView:initLabelAndSwitch(curValue, curIndex, curConfigValue)
	self.Text_content:setString(curValue.content)
	self.CommonSwitch:setVal(curConfigValue)
	self.CommonSwitch:setCallBack(curValue.handle)
	self.CommonSwitch:setTag(curIndex)
	self.CommonSwitch:setIsEqup(curValue.isEquip or false)
end
function commonSettingSwitchView:saveLocalSettings(configKey, configValue)
	SoraDConfigSet(configKey, configValue)
end
function commonSettingSwitchView:setVal(value)
	self.CommonSwitch:setVal(value)
end
return commonSettingSwitchView
