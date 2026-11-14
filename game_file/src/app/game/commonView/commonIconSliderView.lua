_ENV = nil
;(nil).music = "icon_set_music_open.png"
local _ENV, (nil).sound, openTotalIcon = nil, "icon_set_sound_open.png", nil
;(nil).music = "icon_set_music_close.png"
local _ENV, (nil).sound, closeTotalIcon = nil, "icon_set_sound_close.png", nil
;(nil).music = "System:GameOptionsView:musicVolume~float"
local (nil).sound, localSettings = "System:GameOptionsView:soundVolume~float", nil
local ON_PERCENTAGE_CHANGED = 0
local commonIconSliderView = class("commonIconSliderView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonIconSliderView")
	end
	return target
end)
function commonIconSliderView:ctor()
	self:initControls()
end
function commonIconSliderView:initControls()
	self.Panel_slider = SoraDGetChildByName(self, "Panel_slider")
	self.Image_sliderBg = SoraDGetChildByName(self, "Image_sliderBg")
	self.Sprite_slider = SoraDGetChildByName(self, "Sprite_slider")
	self.Slider_common = SoraDGetChildByName(self, "Slider_common")
	self.Slider_common:setScale9Enabled(true)
	self.Slider_common:setCapInsets(cc.rect(20, 25, 1, 1))
	self.Slider_common:addEventListener(handler(self, self.sliderCommonValueChange))
	self.commonKey = ""
end
function commonIconSliderView:resetSpriteIcon(spriteKey, isOpenIcon, configKey)
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
	if spriteName ~= nil then
		self.commonKey = spriteKey
		self:readLocalSettings(configKey)
		self.Sprite_slider:setSpriteFrame(spriteName)
	else
		print("spriteName is nil, please check the spriteKey and the table first", spriteKey)
	end
end
function commonIconSliderView:sliderCommonValueChange(slider, eventType)
	if eventType == ON_PERCENTAGE_CHANGED then
		if not VoiceChatSDKManager:getInstance().isInVoiceRoom and self.commonKey == "music" then
			AudioEngine.setMusicVolume(slider:getPercent() / 100)
		end
		if self.commonKey == "sound" then
			AudioEngine.setEffectsVolume(slider:getPercent() / 100)
		end
		self:switchIcon(slider, slider:getPercent(), self.commonKey)
	end
end
function commonIconSliderView:switchIcon(slider, sliderPercentValue, commonKey)
	if type(sliderPercentValue) ~= "number" then
		return
	end
	if commonKey == nil or commonKey == "" or type(commonKey) ~= "string" then
		return
	end
	if slider == nil then
		return
	end
	if commonKey == "music" then
		if slider:getPercent() > 0 then
			self.Sprite_slider:setSpriteFrame(openTotalIcon.music)
		else
			self.Sprite_slider:setSpriteFrame(closeTotalIcon.music)
		end
	elseif commonKey == "sound" then
		if slider:getPercent() > 0 then
			self.Sprite_slider:setSpriteFrame(openTotalIcon.sound)
		else
			self.Sprite_slider:setSpriteFrame(closeTotalIcon.sound)
		end
	end
end
function commonIconSliderView:readLocalSettings(configKey)
	self.Slider_common:setPercent(SoraDConfigGet(configKey) * 100)
end
function commonIconSliderView:saveLocalSettings(configKey)
	SoraDConfigSet(configKey, self.Slider_common:getPercent() / 100)
end
return commonIconSliderView
