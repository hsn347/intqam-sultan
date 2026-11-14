local accountExtCtrl = SoraDGetCtrl("accountExtCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local CommonH5ActivityPanel = class("CommonH5ActivityPanel", basePanel)
local _ENV, activityConfig = "CommonH5ActivityPanel", "CommonH5ActivityPanel"
function CommonH5ActivityPanel:ctor(...)
	self.super.ctor(self, ...)
end
function CommonH5ActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonH5Activity"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function CommonH5ActivityPanel:onInit()
	self.fields.btn_Jump:addClickListener(handler(self, self.onClickJump))
	self.fields.btn_Jump:setText(i18n("common_text_477"))
end
function CommonH5ActivityPanel:onShow()
	print(self.proxy.param.activityID, "CommonH5ActivityPanel-ActivityID")
	self.activityID = tonumber(self.proxy.param.activityID)
	self.controllers.activityID:setSelectedIndex(activityConfig[self.activityID].selectIndex)
	self.fields.Panel_bg:setText(i18n(activityConfig[self.activityID].title))
	self.fields.icon:setIcon(activityConfig[self.activityID].bg)
	if activityConfig[self.activityID].tips then
		self.fields.title:setText(i18n(activityConfig[self.activityID].tips))
	end
	self:checkRed()
end
function CommonH5ActivityPanel:checkRed()
	_ENV = "Game:H5Activity:saveTime%d~integer"
	;("Game:H5Activity:saveTime%d~integer").byUID = true
	local _rTime = SoraDConfigGet(string.format("Game:H5Activity:saveTime%d~integer", self.activityID), "Game:H5Activity:saveTime%d~integer") or 0
	print(_rTime, "_rTime", serviceFunctions.isSameDay(_rTime))
	if serviceFunctions.isSameDay(_rTime) then
		self.fields.btn_Jump:setReddot(false)
	else
		self.fields.btn_Jump:setReddot(true)
	end
end
function CommonH5ActivityPanel:onClickJump(target)
	if userSDKManager.isBeta() then
		url = activityConfig[self.activityID].urlBeta
	else
		url = activityConfig[self.activityID].url
	end
	local nowTime = serviceFunctions.systemTime()
	url = string.format(url, nowTime)
	_ENV = self.activityID
	self.activityID.byUID = true
	SoraDConfigSet(string.format("Game:H5Activity:saveTime%d~integer", self.activityID), nowTime, self.activityID)
	self.fields.btn_Jump:setReddot(false, 0)
	print("url====", url)
	userSDKManager.openSDKLink(url)
end
return CommonH5ActivityPanel
