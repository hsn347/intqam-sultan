local publicRead = include("publicRead")
local rewardDetailView = class("rewardDetailView", function(target)
	return SoraDCreateTouchPanel("rewardDetailView")
end)
function rewardDetailView:ctor()
	_ENV = nil
	;(nil).noReach = 1
	;(nil).received = 2
	self.btnState, (nil).canReceive = nil, 3
	self.imgBg = SoraDGetChildByName(self, "Image_mbg")
	self.imgBg:setColor(cc.c3b(0, 0, 0))
	self.imgBg:setOpacity(127.5)
	self.line_up = SoraDGetChildByName(self, "frame_line_up")
	self.line_down = SoraDGetChildByName(self, "frame_line_down")
	self.btn_receive = SoraDGetChildByName(self, "Button_receive")
	self.btn_receive:setVisible(false)
	self.btn_receive:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.panel_touch:setTouchEnabled(false)
end
function rewardDetailView:setHandle(handle)
	self.handle = handle
	self.btn_receive:setVisible(true)
	self.panel_touch:setTouchEnabled(true)
end
function rewardDetailView:setBtnStatus(status)
	if status == self.btnState.noReach then
		self.btn_receive:setBright(false)
		self.btn_receive:setTouchEnabled(false)
		self.btn_receive:setTitleText(i18n("common_text_1146"))
	elseif status == self.btnState.received then
		self.btn_receive:setBright(false)
		self.btn_receive:setTouchEnabled(false)
		self.btn_receive:setTitleText(i18n("common_text_1892"))
	elseif status == self.btnState.canReceive then
		self.btn_receive:setBright(true)
		self.btn_receive:setTouchEnabled(true)
		self.btn_receive:setTitleText(i18n("common_text_1146"))
	end
end
function rewardDetailView:initData(reward)
	if #reward % 2 ~= 0 then
		print("参数非法======")
		return
	end
	local totalHeight = 80 * (#reward / 2)
	self.imgBg:setContentSize(cc.size(display.width, totalHeight))
	self.panel_touch:setContentSize(cc.size(self.panel_touch:getContentSize().width, totalHeight + 85))
	self.line_up:setPositionY(totalHeight / 2)
	self.line_down:setPositionY(-totalHeight / 2)
	local index = 1
	for i = 1, #reward - 1, 2 do
		local Panel_item = SoraDGetChildByName(self, "Panel_item"):clone()
		SoraDGetChildByName(Panel_item, "Image_itemBg"):loadTexture(publicRead.getBg(reward[i]), ccui.TextureResType.plistType)
		SoraDGetChildByName(Panel_item, "Image_item"):loadTexture(publicRead.getIcon(reward[i]), ccui.TextureResType.plistType)
		SoraDGetChildByName(Panel_item, "Text_name"):setString(publicRead.getName(reward[i]))
		SoraDGetChildByName(Panel_item, "Text_count"):setString("x" .. string.formatnumberthousands(reward[i + 1]))
		Panel_item:setPosition(cc.p(display.cx, totalHeight - 80 * index))
		index = index + 1
		Panel_item:addTo(self.imgBg)
		if i == #reward - 1 then
			SoraDGetChildByName(Panel_item, "Image_line"):setVisible(false)
		end
	end
end
function rewardDetailView:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle()
		end
		self:removeFromParent()
	end
end
return rewardDetailView
