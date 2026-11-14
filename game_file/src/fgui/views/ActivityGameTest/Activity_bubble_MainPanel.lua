local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_bubble_MainPanel = class("Activity_bubble_MainPanel", baseFguiPanel)
function Activity_bubble_MainPanel:ctor(...)
	Activity_bubble_MainPanel.super.ctor(self, ...)
	print("Activity_bubble_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
	self.debug = true
end
function Activity_bubble_MainPanel:onInit()
	print("=======Activity_bubble_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickBtnExchange))
end
function Activity_bubble_MainPanel:onShow()
	print("=======Activity_bubble_MainPanel:onShow")
	_UPVALUE8_, _UPVALUE5_ = "=======Activity_bubble_MainPanel:onShow", print
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[1] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[2] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[3] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[4] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[5] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[6] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[7] = 1, 1
	_UPVALUE7_, ("=======Activity_bubble_MainPanel:onShow")[8] = 1, 1
	_UPVALUE8_, (1)[1] = 1, 1
	_UPVALUE8_, (1)[2] = 1, 1
	_UPVALUE8_, (1)[3] = 1, 1
	_UPVALUE8_, (1)[4] = 1, 1
	_UPVALUE8_, (1)[5] = 1, 1
	_UPVALUE8_, (1)[6] = 1, 1
	_UPVALUE8_, (1)[7] = 1, 1
	_UPVALUE7_, (1)[1] = 1, 1
	_UPVALUE7_, (1)[2] = 1, 1
	_UPVALUE7_, (1)[3] = 1, 1
	_UPVALUE7_, (1)[4] = 1, 1
	_UPVALUE7_, (1)[5] = 1, 0
	_UPVALUE7_, (1)[6] = 1, 0
	_UPVALUE7_, (1)[7] = 1, 1
	_UPVALUE7_, (1)[8] = 1, 1
	_UPVALUE8_, (1)[1] = 0, 0
	_UPVALUE8_, (1)[2] = 0, 1
	_UPVALUE8_, (1)[3] = 0, 1
	_UPVALUE8_, (1)[4] = 0, 1
	_UPVALUE8_, (1)[5] = 0, 1
	_UPVALUE8_, (1)[6] = 0, 0
	_UPVALUE8_, (1)[7] = 0, 1
	;(0)[1] = 0
	;(0)[2] = 0
	;(0)[3] = 0
	;(0)[4] = 0
	;(0)[5] = 0
	;(0)[6] = 1
	;(0)[7] = 0
	;(0)[8] = 0
	print[1] = "=======Activity_bubble_MainPanel:onShow"
	print[2] = 1
	print[3] = 1
	print[4] = 1
	local print[5], mapData = 0, print
	self.fields.Com_map:initMapData(mapData)
	self:initCheatButtons()
end
function Activity_bubble_MainPanel:onClickBtnExchange(...)
	SoraDPlaySound()
	self.fields.Com_map:exhcangeMyBubble()
end
function Activity_bubble_MainPanel:initCheatButtons(...)
	self.fields.Button_cheat1:setString("恢复场景")
	self.fields.Button_cheat1:addClickListener(handler(self, self.onClickBtnCheat))
	self.fields.Button_cheat2:setString("重置颜色")
	self.fields.Button_cheat2:addClickListener(handler(self, self.onClickBtnCheat))
	self.fields.Button_cheat3:setString("点击泡泡改变颜色")
	self.fields.Button_cheat3:addClickListener(handler(self, self.onClickBtnCheat))
end
function Activity_bubble_MainPanel:onClickBtnCheat(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.fields.Button_cheat1 then
		self.fields.Com_map:resetMyBubble()
		self.fields.Com_map:recoverMap()
	elseif button == self.fields.Button_cheat2 then
		self.fields.Com_map:resetMyBubble()
		self.fields.Com_map:resetBubbleSelect()
		self.fields.Com_map:resetBubbleColor()
	elseif button == self.fields.Button_cheat3 then
		self.fields.Com_map:reverseChangeModel()
		if self.fields.Com_map:getIsChangeModel() then
			self.fields.Button_cheat3:setString("再点一次结束改变颜色")
		else
			self.fields.Button_cheat3:setString("点击泡泡改变颜色")
		end
	end
end
return Activity_bubble_MainPanel
