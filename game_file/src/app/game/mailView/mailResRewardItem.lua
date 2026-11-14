local publicRead = include("publicRead")
local mailResRewardItem = class("mailResRewardItem", function()
	return ccui.Layout:create()
end)
local totalWidth = gMailDetaiViewWidth
function mailResRewardItem:ctor()
	self:setCascadeOpacityEnabled(true)
	self.img_item = ccui.ImageView:create()
	self.img_item:setName("Image_item")
	self.img_item:loadTexture("1001.png", ccui.TextureResType.plistType)
	self.img_item:setContentSize(cc.size(50, 50))
	self.img_item:setAnchorPoint(cc.p(0.5, 0.5))
	self.img_item:setPosition(SoraDFPoint(580, 29, totalWidth))
	self.img_item:ignoreContentAdaptWithSize(false)
	self:addChild(self.img_item)
	self.labelDes = ccui.Text:create()
	self.labelDes:setFontSize(20)
	self.labelDes:setColor(cc.c3b(102, 50, 12))
	self.labelDes:setTextHorizontalAlignment(SoraDFLabelR())
	self.labelDes:setAnchorPoint(SoraDFAP(1, 0.5))
	self.labelDes:setPosition(SoraDFPoint(545, 29, totalWidth))
	self:addChild(self.labelDes)
	self.labelOwnNum = ccui.Text:create()
	self.labelOwnNum:setFontSize(20)
	self.labelOwnNum:setColor(cc.c3b(102, 50, 12))
	self.labelOwnNum:setTextHorizontalAlignment(SoraDFLabelR())
	self.labelOwnNum:setAnchorPoint(SoraDFAP(1, 0.5))
	self:addChild(self.labelOwnNum)
	self.labelOwnNum:setPosition(SoraDFPoint(380, 29, totalWidth))
	self.labelUnCollectNum = ccui.Text:create()
	self.labelUnCollectNum:setFontSize(20)
	self.labelUnCollectNum:setColor(cc.c3b(160, 60, 60))
	self.labelUnCollectNum:setTextHorizontalAlignment(SoraDFLabelL())
	self.labelUnCollectNum:setAnchorPoint(SoraDFAP(0, 0.5))
	self:addChild(self.labelUnCollectNum)
	self.labelUnCollectNum:setPosition(SoraDFPoint(40, 29, totalWidth))
	self:setContentSize(cc.size(totalWidth, 58))
end
function mailResRewardItem:initData(resInfo)
	local iconName = publicRead.getIcon(resInfo.id, false)
	self.img_item:loadTexture(iconName, ccui.TextureResType.plistType)
	local itemDes = publicRead.getName(resInfo.id)
	self.labelDes:setString(itemDes)
	if resInfo.ownNum then
		local strOwnNum = string.formatnumberthousands(resInfo.ownNum)
		if resInfo.ownNum > 0 then
			local strOwnNum = strOwnNum .. " +"
		end
		self.labelOwnNum:setString(strOwnNum)
		local strUnCollectNum = string.formatnumberthousands(resInfo.unCollectNum)
		if resInfo.id == gIDDef.METEOR_CRYSTAL and 0 >= resInfo.unCollectNum then
			self.labelUnCollectNum:setString("")
		else
			self.labelUnCollectNum:setString(strUnCollectNum)
		end
	else
		local strGetNum = string.formatnumberthousands(resInfo.num)
		local color = cc.c3b(160, 60, 60)
		if 0 < resInfo.num then
			local strGetNum = strGetNum .. " +"
			color = cc.c3b(0, 110, 0)
		end
		self.labelUnCollectNum:setString(strGetNum)
		self.labelOwnNum:setVisible(false)
		self.labelUnCollectNum:setColor(color)
	end
end
return mailResRewardItem
