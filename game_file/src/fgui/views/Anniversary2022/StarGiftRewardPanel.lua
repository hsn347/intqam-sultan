local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarGiftRewardPanel = class("StarGiftRewardPanel", baseFguiPanel)
function StarGiftRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarGiftRewardPanel:ctor", self.viewName)
end
function StarGiftRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarGiftRewardPanel:onInit()
	print("=======StarGiftRewardPanel:onInit")
	self.fields.Button_get:setTitleText(i18n("common_text_204"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_get:addClickListener(handler(self, self.onClickClose))
end
function StarGiftRewardPanel:initData(data)
	dump(data, "fdfjkdjk")
	self.reward = data.reward
	self.fields.title:setString(data.name)
	_ENV = nil
	;(nil).name = data.name
	self.fields.Text_tip:setString(i18n("celebrationgift_text_10", nil))
	self.fields.List_reward:setNumItems(table.nums(self.reward))
	self.fields.Com_box:setIcon(data.icon)
end
function StarGiftRewardPanel:onItemRenderer(index, obj)
	local reward = self.reward[index + 1]
	local itemID = reward.id
	local qualityPng = publicRead.getBg(itemID)
	obj:getChild("Image_quality"):setURL(qualityPng)
	local iconPng = publicRead.getIcon(itemID)
	obj:getChild("Image_icon"):setURL(iconPng)
	obj:getChild("Text_num"):setString(reward.count)
	obj.id = itemID
	obj.num = reward.count
	if not obj.isInit then
		obj.isInit = true
		obj:addLongPressListener(function(button, startPos, endPos)
			SoraDPlaySound()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			;(nil).id = obj.id
			;(nil).num = obj.num
			;(nil).pos = startPos
			SoraDSendMessage(nil)
		end)
	end
end
function StarGiftRewardPanel:onShow()
	print("=======StarGiftRewardPanel:onShow")
	self:initData(self.proxy.param)
end
return StarGiftRewardPanel
