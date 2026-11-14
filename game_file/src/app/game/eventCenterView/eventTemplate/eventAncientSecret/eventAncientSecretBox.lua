local ancientTreasureRead = include("ancientTreasureRead")
local eventAncientSecretBox = class("eventAncientSecretBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretBox")
	end
	return target
end)
function eventAncientSecretBox:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.icon_box = SoraDGetChildByName(self, "icon_box")
	self.Button_award = SoraDGetChildByName(self, "Button_award")
	self.Button_award:addTouchEventListener(handler(self, self.onBtnAward))
end
function eventAncientSecretBox:initData(tag)
	self.tag = tag
	local info = ancientTreasureRead.getBoxInfoByIndex(self.tag)
	self.Text_name:setString(i18n(info.name))
	self.icon_box:setSpriteFrame(info.box)
end
function eventAncientSecretBox:onBtnAward(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("弹奖励展示弹窗")
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(self.tag)
		panel:show()
	end
end
return eventAncientSecretBox
