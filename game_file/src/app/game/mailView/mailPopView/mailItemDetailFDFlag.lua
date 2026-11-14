local mailItemDetailFDFlag = class("mailItemDetailFDFlag", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailFDFlag"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailFDFlag:ctor()
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.colorTopBg = SoraDGetChildByName(self, "img_bg")
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailFDFlag:initWithData(data)
	if data.flagType == 0 then
		self.colorTopBg:loadTexture("frame_yjyh_bt_hong.png", ccui.TextureResType.plistType)
		self.colorTopBg:setCapInsets(cc.rect(129, 0, 0, 0))
	else
		self.colorTopBg:loadTexture("frame_yjyh_bt_lan.png", ccui.TextureResType.plistType)
		self.colorTopBg:setCapInsets(cc.rect(123, 0, 0, 0))
	end
	self.text_title:setString(data.strType)
end
function mailItemDetailFDFlag:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFDFlag:getItemHeight()
	return self.itemHeight
end
return mailItemDetailFDFlag
