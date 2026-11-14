local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarEnterActionPanel = class("NebulaWarEnterActionPanel", baseFguiPanel)
function NebulaWarEnterActionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarEnterActionPanel:ctor", self.viewName)
	self.isCantCloseByReturn = true
	self.debug = device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop()
	self.isHideCurrentSceneView = true
end
function NebulaWarEnterActionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarEnterActionPanel:onInit()
	print("=======NebulaWarEnterActionPanel:onInit")
	_ENV, _ENV = "=======NebulaWarEnterActionPanel:onInit", print
	_UPVALUE4_, ("=======NebulaWarEnterActionPanel:onInit").text = i18n("nebula_war_text_0254"), i18n("nebula_war_text_0254")
	_ENV, print[1], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0254")[1] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0254"), 12
	_ENV, print[1], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0254")[2] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0254"), 23
	_ENV, print[1], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0254")[3] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0254"), 44
	_ENV, print[1], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0254")[4] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0254"), 55
	_UPVALUE4_, ("=======NebulaWarEnterActionPanel:onInit").text = i18n("nebula_war_text_0255"), i18n("nebula_war_text_0255")
	_ENV, print[2], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0255")[1] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0255"), 54
	_ENV, print[2], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0255")[2] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0255"), 65
	_ENV, print[2], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0255")[3] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0255"), 175
	_ENV, print[2], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0255")[4] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0255"), 194
	_UPVALUE4_, ("=======NebulaWarEnterActionPanel:onInit").text = i18n("nebula_war_text_0256"), i18n("nebula_war_text_0256")
	_ENV, print[3], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0256")[1] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0256"), 194
	_ENV, print[3], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0256")[2] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0256"), 215
	_ENV, print[3], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0256")[3] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0256"), 289
	_ENV, print[3], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0256")[4] = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0256"), 306
	_UPVALUE2_, ("=======NebulaWarEnterActionPanel:onInit").text = i18n("nebula_war_text_0257"), i18n("nebula_war_text_0257")
	print[4], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0257")[1] = "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0257"), 308
	print[4], ("=======NebulaWarEnterActionPanel:onInit").frames, i18n("nebula_war_text_0257")[2] = "=======NebulaWarEnterActionPanel:onInit", i18n("nebula_war_text_0257"), 326
	local config = print
	self.framesMap, _ENV, self.config = "=======NebulaWarEnterActionPanel:onInit", "=======NebulaWarEnterActionPanel:onInit", config
	for i, v in ipairs(self.config) do
		self.framesMap[tostring(v.frames[1])] = v
	end
	self.fields.Usm_bg:setCompleteCallback(handler(self, self.completeCallback))
	self.fields.Usm_bg:setPrepareCallback(handler(self, self.prepareCallback))
	if self.debug then
		self.fields.Button_cheat:setString("作弊跳过")
		self.fields.Button_cheat:addClickListener(handler(self, self.onClickBtnCheat))
	else
		self.fields.Button_cheat:setVisible(false)
	end
end
function NebulaWarEnterActionPanel:onShow()
	print("=======NebulaWarEnterActionPanel:onShow")
	SoraDPlayMusic(nil, "nebula_sound", true)
end
function NebulaWarEnterActionPanel:onHide()
	SoraDResetBackGroundMusic()
end
function NebulaWarEnterActionPanel:completeCallback(...)
	if self.param and self.param.handler then
		self.param.handler()
	end
	self:closePanel()
end
function NebulaWarEnterActionPanel:prepareCallback(target)
	target:start()
	for i, v in ipairs(self.config) do
		_ENV = nil
		;(nil).frame = v.frames[1]
		target:addFrameEventData(nil)
	end
	target:setFrameEventCallback(handler(self, self.frameEventCallback))
end
function NebulaWarEnterActionPanel:frameEventCallback(event)
	dump(event, "==frameEventCallback==")
	local data = self.framesMap[tostring(event.frame)]
	self.fields.Text_des:setString(data.text)
	local frames = data.frames
	_ENV = self.fields.Text_des
	self.fields.Text_des[1] = ffa.fadeIn((frames[2] - frames[1]) / 30)
	self.fields.Text_des[2] = ffa.fadeIn((frames[2] - frames[1]) / 30)
	self.fields.Text_des[3] = ffa.fadeIn((frames[2] - frames[1]) / 30)
	self.fields.Text_des[4] = ffa.fadeIn((frames[2] - frames[1]) / 30)
	local self.fields.Text_des[5], actionList = ffa.fadeIn((frames[2] - frames[1]) / 30)
	if frames[3] and frames[4] then
		table.insert(actionList, ffa.delay((frames[3] - frames[2]) / 30))
		table.insert(actionList, ffa.fadeOut((frames[4] - frames[3]) / 30))
	end
	self.fields.Text_des:runAction(ffa.seq(actionList))
end
function NebulaWarEnterActionPanel:onClickBtnCheat(...)
	SoraDPlaySound()
	if self.debug then
		self:completeCallback()
	end
end
return NebulaWarEnterActionPanel
