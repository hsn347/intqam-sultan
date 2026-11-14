local baseComponent = require("fgui.base.baseComponent")
local Com_chatRet = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_chatRet", Com_chatRet)
function Com_chatRet:onInit()
	_UPVALUE4_ = nil
	self.imgList, (nil)[1] = nil, self.fields.img_chatR
	self.imgList, (nil)[2] = nil, self.fields.img_chatC
	self.imgList, (nil)[3] = nil, self.fields.img_chatL
	self.imgList, (nil)[4] = nil, self.fields.img_chat4
end
function Com_chatRet:onShow()
end
function Com_chatRet:setShowType(index)
	local width = self:getWidth()
	self.fields.img_chat_current:setPositionX(SoraDFPosX(width - 30 - index * 44, width))
end
function Com_chatRet:initChannelList(channelList)
	local channelCount = #channelList
	for i, v in ipairs(self.imgList) do
		v:setVisible(i <= channelCount)
	end
	self:setSize(18 + channelCount * 43, self:getHeight())
end
return Com_chatRet
