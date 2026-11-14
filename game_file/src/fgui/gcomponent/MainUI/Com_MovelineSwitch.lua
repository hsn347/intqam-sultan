local baseComponent = require("fgui.base.baseComponent")
local Com_MovelineSwitch = fgui.extension_class(fgui.GButton, baseComponent)
local settingCtrl = SoraDGetCtrl("settingCtrl")
local dailyRemindManager = include("dailyRemindManager")
fgui.register_extension("ui://MainUI/Com_MovelineSwitch", Com_MovelineSwitch)
function Com_MovelineSwitch:onInit()
	self:addClickEventListener(handler(self, self.onSwitchClick))
	self.fields.title:setString(i18n("common_text_4853"))
	self.remindKey = "SimpleMoveLineSettingPanel:dailyRemind:saveTime~integer"
end
function Com_MovelineSwitch:onShow()
end
function Com_MovelineSwitch:updateSwitch(data, isWorldMap)
	local isNextVisible = false
	local isNowVisible = self:isVisible()
	dump(data, "Com_MovelineSwitch:updateSwitch data")
	if data and data.isShow and isWorldMap then
		isNextVisible = true
		self:updateSelectResult(true)
	else
		isNextVisible = worldMapDefine.moveLineAutoHideOption.isSwitchShow
		self:updateSelectResult(false)
	end
	if isNextVisible ~= isNowVisible then
		self:setVisible(isNextVisible)
		worldMapDefine.moveLineAutoHideOption.isSwitchShow = isNextVisible
	end
	return isNextVisible ~= isNowVisible
end
function Com_MovelineSwitch:updateSelectResult(isShow)
	if isShow and not SoraDIsGameGuide() then
		self.recordTime = SoraDConfigGet(self.remindKey) or 0
		if worldMapDefine.moveLineAutoHideOption.isAutoPopWindow and not serviceFunctions.isSameDay(self.recordTime) then
			worldMapDefine.moveLineAutoHideOption.isAutoPopWindow = false
			worldMapDefine.moveLineAutoHideOption.isCastleHideSkin = true
			worldMapDefine.moveLineAutoHideOption.isMoveLineHideArmy = true
			worldMapDefine.moveLineAutoHideOption.isMoveLineHideOther = false
			uiManager:show("SimpleMoveLineSetting")
			_ENV = uiManager
			uiManager.msg = "MESSAGE_LOCAL_OPTION_CATLE_WAR_LV_SHOW"
			SoraDSendMessage(uiManager)
			_ENV = uiManager
			uiManager.data, _ENV, uiManager.msg = "SimpleMoveLineSetting", "SimpleMoveLineSetting", "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW"
			SoraDSendMessage(uiManager, nil)
		end
	end
end
function Com_MovelineSwitch:onSwitchClick()
	SoraDPlaySound()
	uiManager:show("SimpleMoveLineSetting")
end
return Com_MovelineSwitch
