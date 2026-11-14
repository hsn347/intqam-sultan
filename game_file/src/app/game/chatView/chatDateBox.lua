local chatDateBox = class("chatDateBox", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatDateBox:ctor()
	self.imgDateBg = ccui.ImageView:create("frame_mailinfo_10.png", ccui.TextureResType.plistType)
	self.imgDateBg:setPosition(cc.p(300, 40))
	self.imgDateBg:setScale9Enabled(true)
	self.imgDateBg:setCapInsets(cc.rect(10, 10, 72, 14))
	self.imgDateBg:setContentSize(cc.size(160, 34))
	self.imgDateBg:addTo(self)
	_ENV = self.imgDateBg
	self.imgDateBg.text = ""
	self.imgDateBg.font = "res/Default/defaultBMFont.fnt"
	self.imgDateBg.align = cc.TEXT_ALIGNMENT_CENTER
	self.imgDateBg.x = 80
	self.imgDateBg.y = 17
	self.text_date = display.newBMFontLabel(self.imgDateBg)
	self.text_date:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_date:addTo(self.imgDateBg)
end
function chatDateBox:initWithData(data)
	local dateString = data.date
	self.text_date:setString(dateString)
end
function chatDateBox:getItemWidth()
	return 600
end
function chatDateBox:getItemHeight()
	return 90
end
return chatDateBox
