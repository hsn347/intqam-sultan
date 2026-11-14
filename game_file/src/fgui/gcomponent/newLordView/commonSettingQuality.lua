local baseComponent = require("fgui.base.baseComponent")
local commonSettingQuality = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/commonSettingQuality", commonSettingQuality)
function commonSettingQuality:onInit()
	self.configKey = "System:GameOptionsView:grapicsQuality~integer"
	self:fixChildrenPos()
	local curQualityLv = SoraDGetGrapicsQualityLevel()
	for i = 1, 3 do
		self.fields["Check_tick" .. i]:addClickEventListener(handler(self, self.onTick), i)
		self.fields["Check_tick" .. i]:setSelected(i == curQualityLv + 1)
	end
	self.fields.txt_1:setString(i18n("kingBuild_text_09"))
	self.fields.txt_2:setString(i18n("kingBuild_text_10"))
	self.fields.txt_3:setString(i18n("kingBuild_text_11"))
end
function commonSettingQuality:onShow()
end
function commonSettingQuality:initData()
end
function commonSettingQuality:setIsNeedToSave()
end
function commonSettingQuality:onTick(sender, tag)
	for i = 1, 3 do
		self.fields["Check_tick" .. i]:setSelected(i == tag)
	end
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	devicePerformanceUtil.setQualityLevel(tag - 1)
	SoraDConfigSet(self.configKey, tag - 1)
	_ENV = self.configKey
	self.configKey.msg = "MESSAGE_SETTING_QUALITY_CHANGE"
	SoraDSendMessage(self.configKey)
end
return commonSettingQuality
