local commonSettingBtnView = class("commonSettingBtnView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonSettingBtnView")
	end
	return target
end)
function commonSettingBtnView:ctor()
	self:initControls()
end
function commonSettingBtnView:initControls()
	self.Text_content = SoraDGetChildByName(self, "textContent")
	self.CommonBtn = SoraDGetChildByName(self, "Button_common")
end
function commonSettingBtnView:initLableAndBtn(curValue)
	self.Text_content:setString(curValue.content)
	self.CommonBtn:setTitleText(curValue.btnName)
	self.CommonBtn:addTouchEventListener(curValue.handle)
end
return commonSettingBtnView
