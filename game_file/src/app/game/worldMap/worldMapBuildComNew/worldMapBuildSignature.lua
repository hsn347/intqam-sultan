local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildSignature = class("worldMapBuildSignature", worldMapBuildComNew)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapBuildSignature:ctor(...)
	worldMapBuildSignature.super.ctor(self, ...)
end
function worldMapBuildSignature:_initData(...)
	self.isOnClick = false
	self.signature = nil
end
function worldMapBuildSignature:_initUI(...)
end
function worldMapBuildSignature:updateData(data)
	if data.signature then
		self.signature = data.signature
		self.signatureBox = data.signatureBox
	end
	self:refreshSignText()
end
function worldMapBuildSignature:refreshSignShow(isShow)
	if self.signNode and tolua.isnull(self.signNode) then
		return
	end
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidShowSign() then
		if self.signNode then
			self.signNode:setVisible(false)
		end
		return
	end
	if self.signature and self.signature ~= "" then
		if not self.signNode then
			self:createSignShow()
		end
		self.signNode:setVisible(isShow)
	elseif self.signNode then
		self.signNode:setVisible(false)
	end
end
function worldMapBuildSignature:createSignShow()
	local signNode = display.newNode()
	signNode:addTo(self.target_, 4)
	signNode:setPosition(cc.p(self.centerPoint.x + 40, self.centerPoint.y - 0))
	self.signNode = signNode
	signNode:setGroupID(GROU_ID.group_sign)
	signNode:setGroupAuto(true)
	local image = ccui.ImageView:create("frame_ssdt_qmk01.png", ccui.TextureResType.plistType)
	image:setScale9Enabled(true)
	image:setCapInsets(cc.rect(40, 40, 10, 10))
	image:addTo(signNode)
	image:setOpacity(204.0)
	self.signImage = image
	local label = ccui.Text:create()
	label:setColor(cc.c3b(80, 50, 0))
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:addTo(signNode)
	SoraDSetTextWidthHeight(label, cc.size(130, 35))
	label:setPosition(0, 12)
	label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	label:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	label:setFontSize(20)
	self.signText = label
end
function worldMapBuildSignature:refreshSignText()
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidShowSign() then
		self:refreshSignShow(false)
		return
	end
	if self.signature and self.signature ~= "" then
		self:refreshSignShow(not self.isOnClick)
		self.signText:setString(self.signature)
		if self.signatureBox and self.signatureBox == 1 then
			self.signText:setPosition(0, -10)
			self.signImage:loadTexture("frame_shmc_signature.png", ccui.TextureResType.plistType)
			self.signImage:setContentSize(cc.size(160, 110))
		else
			self.signText:setPosition(0, 12)
			self.signImage:loadTexture("frame_ssdt_qmk01.png", ccui.TextureResType.plistType)
			self.signImage:setContentSize(cc.size(150, 62))
		end
	else
		self:refreshSignShow(false)
	end
end
function worldMapBuildSignature:setIsOnClick(isOnClick)
	self.isOnClick = isOnClick
	self:refreshSignShow(not self.isOnClick)
end
function worldMapBuildSignature:getSignature(...)
	return self.signature
end
function worldMapBuildSignature:setSignNodeGroupID(groupID)
	if self.signNode then
		self.signNode:setGroupID(groupID)
	end
end
return worldMapBuildSignature
