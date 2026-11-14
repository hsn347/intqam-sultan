local remainsWarRead = include("remainsWarRead")
local RemainsSegmentSingle = class("remainsSegmentSingle", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("remainsSegmentSingle")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function RemainsSegmentSingle:ctor()
	self.imgBg = SoraDGetChildByName(self, "Image_background")
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.labelSegment = SoraDGetChildByName(self, "Text_segment")
	self.btn = SoraDGetChildByName(self, "Button_single")
	self.btn:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btn:setSwallowTouches(false)
	self.callBack = nil
	self:setScale(0.3, 0.9)
end
function RemainsSegmentSingle:initData(data)
	self.segmentID = data.dan
	self.labelSegment:setString(i18n(data.name))
	self.imgIcon:loadTexture(data.icon, ccui.TextureResType.plistType)
end
function RemainsSegmentSingle:setHighLight()
	if G_IS_UNITY then
		self:setCascadeColorEnabled(true)
	end
	self:setColor(cc.c3b(255, 255, 255))
end
function RemainsSegmentSingle:setDark()
	if G_IS_UNITY then
		self:setCascadeColorEnabled(true)
	end
	self:setColor(cc.c3b(115, 115, 115))
end
function RemainsSegmentSingle:setHandle(handle)
	self.callBack = handle
end
function RemainsSegmentSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setHighLight()
		self.callBack(self.segmentID, self)
	end
end
return RemainsSegmentSingle
