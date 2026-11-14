local gametop = gModuleMgr.getObject("gametop")
local cityHorseCtrl = gametop.playertop_:getModule("cityHorseCtrl")
local cityHorseFlagLucky = class("cityHorseFlagLucky", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("cityHorseFlagLucky")
	end
	return target
end)
function cityHorseFlagLucky:ctor()
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("guide_text_158"))
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name:setString(i18n("cityNpc_name_01"))
	self.Button_get = SoraDGetChildByName(self, "Button_get")
	self.Button_get:setTitleText(i18n("common_text_1146"))
	self.Button_get:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function cityHorseFlagLucky:setReward(reward)
	self.reward = reward
end
function cityHorseFlagLucky:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function cityHorseFlagLucky:onExitPanel()
	_ENV = nil
	;(nil).isArray = true
	SoraDOpenGiftView(self.reward, nil)
end
return cityHorseFlagLucky
