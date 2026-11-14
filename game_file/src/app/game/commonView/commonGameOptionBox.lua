local titleCommonPosDifference = 40
local contentCommonSizeDifference = 80
local contentCommonPosDifference = 25
local textCommonPosdifference = 25
local frameCommonSizeDifference = 65
local frameCommonPosDifference = 25
local commonGameOptionBox = class("commonGameOptionBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonGameOptionBox")
	end
	return target
end)
function commonGameOptionBox:ctor()
	self:setAnchorPoint(0.5, 1)
	self:setContentSize(self:getContentSize())
	self:initControls()
end
function commonGameOptionBox:initControls()
	self.PanelBg = SoraDGetChildByName(self, "panelBg")
	self.Image_left = SoraDGetChildByName(self, "Image_4_0")
	self.Image_right = SoraDGetChildByName(self, "Image_4")
	self.Text_title = SoraDGetChildByName(self, "textTitle")
end
function commonGameOptionBox:CustomSize(panelHeight, titleValue)
	if panelHeight <= 0 or panelHeight == nil or type(panelHeight) ~= "number" then
		return
	end
	if titleValue == nil or type(titleValue) ~= "string" then
		return
	end
	self.PanelBg:setContentSize(cc.size(self:getContentSize().width, panelHeight))
	local contentSizeOffset = panelHeight
	local contentPosOffset = panelHeight
	self.Image_left:setContentSize(cc.size(self.Image_left:getContentSize().width, contentSizeOffset))
	self.Image_left:setPosition(cc.p(display.width / 2, contentPosOffset))
	self.Image_right:setContentSize(cc.size(self.Image_right:getContentSize().width, contentSizeOffset))
	self.Image_right:setPosition(cc.p(display.width / 2, contentPosOffset))
	local textOffset = panelHeight - textCommonPosdifference
	self.Text_title:setPosition(cc.p(display.width / 2, textOffset))
	self.Text_title:setString(titleValue)
end
return commonGameOptionBox
