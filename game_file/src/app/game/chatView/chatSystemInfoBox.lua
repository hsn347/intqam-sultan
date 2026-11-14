local chatSystemInfoBox = class("chatSystemInfoBox", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatSystemInfoBox:ctor()
	self.imgSysBg = ccui.ImageView:create("frame_mailinfo_10.png", ccui.TextureResType.plistType)
	self.imgSysBg:setPosition(cc.p(300, 40))
	self.imgSysBg:setScale9Enabled(true)
	self.imgSysBg:setCapInsets(cc.rect(10, 10, 72, 14))
	self.imgSysBg:setContentSize(cc.size(160, 34))
	self.imgSysBg:addTo(self)
	self.textContent = ccui.Text:create("", "", 20)
	self.textContent:setTextHorizontalAlignment(SoraDFLabelR())
	self.textContent:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textContent:setColor(cc.c3b(255, 255, 255))
	self.textContent:setPosition(cc.p(300, 40))
	self.textContent:setAnchorPoint(SoraDFAP(0.5, 0.5, 1))
	self.textContent:addTo(self.imgSysBg)
	self.itemWidth = 600
	self.itemHeight = 90
end
function chatSystemInfoBox:initWithData(data)
	self.itemData = data
	if dataType ~= gChatDataType.dataType_chat_sys_op then
		print("格式错误，不是聊天操作的系统提示")
		return
	end
	self.textContent:ignoreContentAdaptWithSize(true)
	self.textContent:setTextAreaSize(cc.size(0, 0))
	self.textContent:setString(self.itemData.content)
	local autoRenderSize = self.textContent:getContentSize()
	local autoHeight = autoRenderSize.height
	local maxTextWidth = 400
	if maxTextWidth < autoRenderSize.width then
		autoHeight = SoraDGetAutoHeightLabel(self.textContent, maxTextWidth)
	elseif autoRenderSize.width == 0 then
		textLimitWidth = maxTextWidth
		autoHeight = SoraDGetAutoHeightLabel(self.textContent, maxTextWidth)
	end
	local imgWidth = self.textContent:getContentSize().width + 32
	local imgHeight = self.textContent:getContentSize().height + 12
	self.imgSysBg:setContentSize(cc.size(imgWidth, imgHeight))
	self.textContent:setAnchorPoint(SoraDFAP(0.5, 0.5, 1))
	self.textContent:setPosition(cc.p(imgWidth / 2, imgHeight / 2))
	self.itemWidth = 600
	self.itemHeight = self.imgSysBg:getContentSize().height + 20
	self.imgSysBg:setPosition(cc.p(self.itemWidth / 2, self.itemHeight / 2))
end
function chatSystemInfoBox:getItemWidth()
	return self.itemWidth
end
function chatSystemInfoBox:getItemHeight()
	return self.itemHeight
end
return chatSystemInfoBox
