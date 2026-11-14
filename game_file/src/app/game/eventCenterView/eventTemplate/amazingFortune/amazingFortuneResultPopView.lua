local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local publicRead = include("publicRead")
local amazingFortuneResultPopView = class("amazingFortuneResultPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("amazingFortuneResultPopView")
	end
	return target
end)
function amazingFortuneResultPopView:ctor()
	self.rewardInfo, _UPVALUE0_, self.isAddToPopManager = nil, nil, true
	self:bandWidget()
end
function amazingFortuneResultPopView:bandWidget()
	self.Sprite_congratulation = SoraDGetChildByName(self, "Sprite_congratulation")
	local icon = SoraDFIsRA() and "frame_title_congratulation_ar.png" or "frame_title_congratulation_en.png"
	self.Sprite_congratulation:setSpriteFrame(icon)
	self.Node_reward = SoraDGetChildByName(self, "Node_reward")
	self:setCloseCallBack(handler(self, self.exitView))
end
function amazingFortuneResultPopView:initData(rewardInfo)
	self.rewardInfo = rewardInfo
	for k, v in ipairs(self.rewardInfo) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.Node_reward)
		single:setOwnView(self)
		single:initData(v.id, v.count)
	end
	SoraDautoSortPos(self.Node_reward, 4, 1)
end
function amazingFortuneResultPopView:initGemGoodsData(rewardInfo)
	self:initData(rewardInfo)
	SoraDautoSortPos(self.Node_reward, 3, 1, cc.size(146, 126))
	local Node_top = SoraDGetChildByName(self, "Node_top")
	Node_top:setPositionY(Node_top:getPositionY() + 30)
	local Sprite_line = SoraDGetChildByName(self, "frame_lord_line_53_0")
	Sprite_line:setPositionY(Sprite_line:getPositionY() - 60)
	_UPVALUE3_ = Sprite_line
	Sprite_line[1] = "Panel_cut"
	Sprite_line[2] = "Image_44"
	Sprite_line[3] = "Image_44_0"
	for i, v in ipairs(Sprite_line) do
		local widget = SoraDGetChildByName(self, v)
		widget:setContentSize(cc.size(widget:getContentSize().width, widget:getContentSize().height + 90))
	end
	self:addButton()
end
function amazingFortuneResultPopView:addButton(...)
	local Center_Node = SoraDGetChildByName(self, "Center_Node")
	local button = ccui.Button:create()
	button:loadTextures("btn_green_normal_01.png", "btn_green_normal_02.png", "", ccui.TextureResType.plistType)
	button:setPosition(0, -250)
	button:setTitleFontSize(20)
	button:addTo(Center_Node)
	button:addTouchEventListener(handler(self, self.onBtnOk))
	button:setTitleText(i18n("common_text_204"))
end
function amazingFortuneResultPopView:onBtnOk(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:exitView()
		self:close(button, event)
	end
end
function amazingFortuneResultPopView:setExitHandle(exitHandle)
	self.exitHandle = exitHandle
end
function amazingFortuneResultPopView:exitView(...)
	SoraDMailGainItems(self.rewardInfo, true)
	if self.exitHandle then
		self.exitHandle()
	end
end
return amazingFortuneResultPopView
