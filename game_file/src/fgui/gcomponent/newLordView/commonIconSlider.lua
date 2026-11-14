local baseComponent = require("fgui.base.baseComponent")
local commonIconSlider = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/commonIconSlider", commonIconSlider)
_ENV = fgui.register_extension
fgui.register_extension.music = "icon_set_yinyue01.png"
local _ENV, fgui.register_extension.sound, openTotalIcon = "ui://newLordView/commonIconSlider", "icon_set_shengyin01.png", fgui.register_extension
;("ui://newLordView/commonIconSlider").music = "icon_set_yinyue02.png"
local _ENV, ("ui://newLordView/commonIconSlider").sound, closeTotalIcon = commonIconSlider, "icon_set_shengyin02.png", "ui://newLordView/commonIconSlider"
commonIconSlider.music = "System:GameOptionsView:musicVolume~float"
local commonIconSlider.sound, localSettings = "System:GameOptionsView:soundVolume~float", commonIconSlider
local ON_PERCENTAGE_CHANGED = 0
function commonIconSlider:onInit()
	self:fixChildrenPos()
	self.fields.Com_slider:setMax(100)
	self.fields.Com_slider:setScale(SoraDFIsRA() and -1 or 1)
	self.fields.Com_slider:addEventListener(fgui.UIEventType.Changed, handler(self, self.sliderCommonValueChange))
	self.commonKey = ""
end
function commonIconSlider:onShow()
end
function commonIconSlider:initData(switchKey, data)
	if type(switchKey) ~= "string" then
		return
	end
	if switchKey == nil or switchKey == "" then
		return
	end
	self.commonKey = switchKey
	print("switchKey", switchKey, localSettings[switchKey])
	self.configKey = localSettings[switchKey]
	local isOn = false
	if SoraDConfigGet(self.configKey) > 0.01 then
		isOn = true
	end
	self:resetSpriteIcon(self.commonKey, isOn, self.configKey)
end
function commonIconSlider:resetSpriteIcon(spriteKey, isOpenIcon, configKey)
	if type(spriteKey) ~= "string" then
		return
	end
	if spriteKey == nil or spriteKey == "" then
		return
	end
	local tableName
	if isOpenIcon then
		tableName = openTotalIcon
	else
		tableName = closeTotalIcon
	end
	local spriteName
	for k, v in pairs(tableName) do
		if spriteKey == k then
			spriteName = v
			break
		end
	end
	self.configKey = configKey
	if spriteName ~= nil then
		self.commonKey = spriteKey
		self:readLocalSettings(configKey)
		self.fields.icon:setSpriteFrame(spriteName)
	else
		print("spriteName is nil, please check the spriteKey and the table first", spriteKey)
	end
end
function commonIconSlider:sliderCommonValueChange(Context)
	self.curValue = self.fields.Com_slider:getValue()
	if not VoiceChatSDKManager:getInstance().isInVoiceRoom and self.commonKey == "music" then
		AudioEngine.setMusicVolume(self.curValue / 100)
	end
	if self.commonKey == "sound" then
		AudioEngine.setEffectsVolume(self.curValue / 100)
	end
	self:switchIcon()
end
function commonIconSlider:switchIcon()
	if self.commonKey == nil or self.commonKey == "" or type(self.commonKey) ~= "string" then
		return
	end
	if self.commonKey == "music" then
		if self.curValue > 0 then
			self.fields.icon:setSpriteFrame(openTotalIcon.music)
		else
			self.fields.icon:setSpriteFrame(closeTotalIcon.music)
		end
	elseif self.commonKey == "sound" then
		if self.curValue > 0 then
			self.fields.icon:setSpriteFrame(openTotalIcon.sound)
		else
			self.fields.icon:setSpriteFrame(closeTotalIcon.sound)
		end
	end
end
function commonIconSlider:readLocalSettings(configKey)
	self.fields.Com_slider:setValue(SoraDConfigGet(configKey) * 100)
end
function commonIconSlider:saveLocalSettings(configKey)
	SoraDConfigSet(configKey, self.fields.Com_slider:getValue() / 100)
end
function commonIconSlider:setIsNeedToSave(isNeedToSave)
	self.isNeedToSave = isNeedToSave
end
function commonIconSlider:onHide()
	if self.isNeedToSave then
		self:saveLocalSettings(self.configKey)
	end
end
return commonIconSlider
