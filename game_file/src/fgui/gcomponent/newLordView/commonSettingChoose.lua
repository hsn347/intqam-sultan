local baseComponent = require("fgui.base.baseComponent")
local commonSettingChoose = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/commonSettingChoose", commonSettingChoose)
_UPVALUE1_, _ENV = "ui://newLordView/commonSettingChoose", fgui.register_extension
fgui.register_extension.inputBox, ("ui://newLordView/commonSettingChoose")[1] = "ui://newLordView/commonSettingChoose", "System:GameOptionsView:inputBox~integer"
local configKeyTable = fgui.register_extension
function commonSettingChoose:onInit()
	self:fixChildrenPos()
	local curQualityLv = SoraDGetGrapicsQualityLevel()
	for i = 1, 2 do
		self.fields["Check_tick" .. i]:addClickEventListener(handler(self, self.onTick), i)
		self.fields["Check_tick" .. i]:setSelected(i == curQualityLv + 1)
	end
end
function commonSettingChoose:onShow()
end
function commonSettingChoose:initData(switchKey, curValue)
	self.curValue = curValue
	self.switchKey = switchKey
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	local curIndex = SoraDConfigGet(configKeyTable[self.switchKey][1], nil) or 1
	_UPVALUE2_ = nil
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	;(nil)[1] = SoraDConfigGet(configKeyTable[self.switchKey][1], nil)
	;(nil)[2] = self.switchKey
	dump(nil, "commonSettingChoose:initData")
	for i = 1, 2 do
		self.fields["Check_tick" .. i]:setTitle(curValue[i])
		self.fields["Check_tick" .. i]:setSelected(i == curIndex)
	end
end
function commonSettingChoose:setIsNeedToSave(isNeedToSave)
	self.isNeedToSave = isNeedToSave
end
function commonSettingChoose:onHide()
	if self.isNeedToSave then
		self:saveLocalSettings()
	end
end
function commonSettingChoose:saveLocalSettings()
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], self.curIndex, nil)
end
function commonSettingChoose:onTick(sender, tag)
	for i = 1, 2 do
		self.fields["Check_tick" .. i]:setSelected(i == tag)
	end
	local func = self["setConfigValue_" .. self.switchKey]
	if func then
		return func(self, tag)
	else
		if self.curValue.flag then
			self:funToSaveServer(tag, self.curValue.flag)
		end
		if configKeyTable[self.switchKey] then
			configKeyTable = self.curValue.flag
			self.curValue.flag.byUID = configKeyTable[self.switchKey].byUID
			SoraDConfigSet(configKeyTable[self.switchKey][1], tag, self.curValue.flag)
		end
	end
end
function commonSettingChoose:getConfigValue()
	local func = self["getConfigValue_" .. self.switchKey]
	if func then
		return func(self)
	elseif configKeyTable[self.switchKey] then
		configKeyTable = nil
		;(nil).byUID = configKeyTable[self.switchKey].byUID
		return SoraDConfigGet(configKeyTable[self.switchKey][1], nil)
	end
end
function commonSettingChoose:setConfigValue_inputBox(index)
	print("commonSettingChoose:setConfigValue_inputBox", index)
	_ENV = nil
	;(nil).byUID = configKeyTable[self.switchKey].byUID
	SoraDConfigSet(configKeyTable[self.switchKey][1], index, nil)
	FairyGUI.InputTextField.setUseNativeInput(index == 2)
	uiManager:clearLRUCache()
	uiManager:clearCachedInstanceView()
	cocosUIManager:clearCachedInstanceView()
end
return commonSettingChoose
