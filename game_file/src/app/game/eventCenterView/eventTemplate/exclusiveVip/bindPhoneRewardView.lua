local bindPhoneRewardView = class("bindPhoneRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("bindPhoneRewardView")
	end
	return target
end)
function bindPhoneRewardView:ctor()
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("privilege_text_169"))
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:addTouchEventListener(handler(self, self.btnOKClick))
	self.Text_ok = SoraDGetChildByName(self, "Text_ok")
	self.Text_ok:setString(i18n("common_text_204"))
end
function bindPhoneRewardView:initData(reward)
	self.reward = reward
	for k, v in ipairs(self.reward) do
		local item = include("commonItemAward").new()
		item:setOwnView(self)
		item:initData(v.id, v.count)
		item:setPosition(0, 0)
		item:addTo(self.Node_items)
	end
	SoraDToCenter(self.Node_items, 120)
end
function bindPhoneRewardView:btnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function bindPhoneRewardView:onExitPanel()
	SoraDMailGainItems(self.reward, true)
end
return bindPhoneRewardView
