local publicRead = include("publicRead")
local cheatItemGetView = class("cheatItemGetView", function()
	return SoraDCreateTouchPanel("cheatItemGetView")
end)
function cheatItemGetView:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Image_item_bg = SoraDGetChildByName(self, "Image_item_bg")
	self.Image_item = SoraDGetChildByName(self, "Image_item")
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelDenominator = SoraDGetChildByName(self, "Text_denominator")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.btnGet:setTitleText("来一波")
	self.btnGet:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.tableItemData, _ENV = self.btnGet.addTouchEventListener, self.btnGet.addTouchEventListener
end
function cheatItemGetView:setHandle(handle)
	self.handle = handle
end
function cheatItemGetView:initData(itemId)
	self.itemId = tonumber(itemId)
	self.Text_name:setString(publicRead.getName(self.itemId))
	self.Image_item_bg:loadTexture(publicRead.getBg(self.itemId), ccui.TextureResType.plistType)
	self.Image_item:loadTexture(publicRead.getIcon(self.itemId), ccui.TextureResType.plistType)
	_ENV = publicRead.getIcon(self.itemId)
	publicRead.getIcon(self.itemId).maxValue = 999999
	publicRead.getIcon(self.itemId).minValue = 1
	publicRead.getIcon(self.itemId).curValue = 1
	self.itemUseSlider:initData((publicRead.getIcon(self.itemId)))
	self.labelDenominator:setString("/999999")
end
function cheatItemGetView:initSubmitData(data)
	if data.btnText then
		self.btnGet:setTitleText(data.btnText)
	end
	if data.msg then
		SoraDGetChildByName(self, "Text_tip"):setString(data.msg)
	end
	_ENV = data.msg
	data.msg.maxValue = data.maxValue
	data.msg.minValue = data.minValue or 1
	data.msg.curValue = data.curValue
	self.itemUseSlider:initData(data.msg)
end
function cheatItemGetView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.itemUseSlider:getSliderCurValue())
			self:removeFromParent()
			return
		end
		local gametop = gModuleMgr.getObject("gametop")
		local cheatCtrl = gametop.playertop_:getModule("cheatCtrl")
		_ENV, _UPVALUE1_ = self.itemUseSlider:getSliderCurValue()
		self.itemUseSlider:getSliderCurValue().id = self.itemId
		self.itemUseSlider:getSliderCurValue().count = self.itemUseSlider:getSliderCurValue()
		self.itemUseSlider:getSliderCurValue()[1] = self.itemUseSlider:getSliderCurValue()
		cheatCtrl:reqAddGameItem(self.itemUseSlider:getSliderCurValue())
		SoraDPopGainItem(self.itemId, self.itemUseSlider:getSliderCurValue())
		self:removeFromParent()
	end
end
return cheatItemGetView
