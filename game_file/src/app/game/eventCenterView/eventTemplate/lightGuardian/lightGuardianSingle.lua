local lightGuardianSingle = class("lightGuardianSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("lightGuardianSingle")
end)
_UPVALUE3_ = "lightGuardianSingle"
_UPVALUE3_, ("lightGuardianSingle")[1] = "icon_guardian_occupy01.png", "icon_guardian_occupy01.png"
_UPVALUE3_, ("lightGuardianSingle")[2] = "icon_guardian_occupy01.png", "icon_guardian_war.png"
local _UPVALUE3_, ("lightGuardianSingle")[3], getWayIconConfig = "icon_guardian_occupy01.png", "icon_guardian_occupy02.png", "lightGuardianSingle"
_UPVALUE3_, ("icon_guardian_occupy01.png")[1] = "guardLight_text_04", "guardLight_text_04"
_UPVALUE3_, ("icon_guardian_occupy01.png")[2] = "guardLight_text_04", "guardLight_text_06"
local _UPVALUE3_, ("icon_guardian_occupy01.png")[3], getWayDesConfig = "guardLight_text_04", "guardLight_text_08", "icon_guardian_occupy01.png"
;("guardLight_text_04")[1] = "guardLight_text_03"
;("guardLight_text_04")[2] = "guardLight_text_05"
local ("guardLight_text_04")[3], getWayTitleConfig = "guardLight_text_07", "guardLight_text_04"
function lightGuardianSingle:ctor(properties)
	self.imgIcon = SoraDGetChildByName(self, "Image_Icon")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textDetail = SoraDGetChildByName(self, "Text_Detail")
	self.btnSingle = SoraDGetChildByName(self, "Button_Single")
	self.btnSingle:addTouchEventListener(handler(self, self.btnSingleClick))
	self.frame = SoraDGetChildByName(self, "G_dh_Tex_gmsh01")
	local frames = display.newFrames("dh_Tex_gmsh01_0%.2d.png", 0, 15)
	local animation = display.newAnimation(frames, 1.8 / #frames)
	self.frame:playAnimationForever(animation)
	local cssFileName = "lightGuardianSingle"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0)
	self:runAction(action)
end
function lightGuardianSingle:initData(index)
	self.imgIcon:loadTexture(getWayIconConfig[index], ccui.TextureResType.plistType)
	self.textTitle:setString(i18n(getWayTitleConfig[index]))
	self.textDetail:setString(i18n(getWayDesConfig[index]))
end
function lightGuardianSingle:btnSingleClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDCreatePanel("lightGuardianExplainView"):show()
	end
end
return lightGuardianSingle
