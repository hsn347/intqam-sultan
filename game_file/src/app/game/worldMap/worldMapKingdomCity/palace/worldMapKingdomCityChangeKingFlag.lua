local WorldMapKingdomCityChangeKingFlag = class("worldMapKingdomCityChangeKingFlag", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityChangeKingFlag")
	end
	return target
end)
function WorldMapKingdomCityChangeKingFlag:ctor()
	self:setBackGround(216.75)
	self.isHidePrePanel = false
	self.indexOfFlag = 0
	self.singleIsMoved = false
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_flagList")
	self.btnChange = SoraDGetChildByName(self, "Bottom_Button_change")
	self.btnChange:setTitleText(i18n("common_text_1417"))
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_flagChange"):setTitle(i18n("common_text_1192"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", function()
		self:removeFromParent()
	end)
	self.btnChange:addTouchEventListener(handler(self, self.btnChangeClick))
	self:initData()
end
function WorldMapKingdomCityChangeKingFlag:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	self.indexOfFlag = KWKingdomCtrl:getKingdomFlag()
	self:initView()
end
function WorldMapKingdomCityChangeKingFlag:initView()
	local nationalFlagRead = include("nationalFlagRead")
	local flagList = nationalFlagRead.getList()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(math.ceil(#flagList / 4) * 105, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local numx = 4
	for i, v in ipairs(flagList) do
		local newFlag = self:createAFlag(v.image)
		local _line = i % numx == 0 and numx or i % numx
		local _row = math.ceil(i / numx)
		local fX = 90 + (_line - 1) * 140
		local fY = sH - (_row - 1) * 105 - 55
		if i ~= self.indexOfFlag then
			newFlag:getChildByName("Image_selected"):setVisible(false)
		end
		newFlag:setTag(i)
		newFlag:setTouchEnabled(true)
		newFlag:setSwallowTouches(false)
		newFlag:addTouchEventListener(handler(self, self.btnFlagClick))
		newFlag:setPosition(SoraDFPosX(fX, sSize.width), fY)
		newFlag:addTo(self.scroll)
	end
end
function WorldMapKingdomCityChangeKingFlag:createAFlag(img)
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(img) == nil then
		img = "icon_item_common.png"
	end
	local imgFlag = ccui.ImageView:create(img, ccui.TextureResType.plistType)
	imgFlag:setScale(1.65)
	local imgSelected = ccui.ImageView:create("frame_sheer_yellow_04.png", ccui.TextureResType.plistType)
	imgSelected:setName("Image_selected")
	imgSelected:setScale9Enabled(true)
	imgSelected:setCapInsets(cc.rect(17, 17, 19, 19))
	imgSelected:setPosition(imgFlag:getContentSize().width / 2, imgFlag:getContentSize().height / 2)
	imgSelected:setContentSize(cc.size(96, 76))
	imgSelected:addTo(imgFlag)
	return imgFlag
end
function WorldMapKingdomCityChangeKingFlag:btnFlagClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		for _, v in pairs(self.scroll:getChildren()) do
			if v:getTag() == self.indexOfFlag then
				v:getChildByName("Image_selected"):setVisible(false)
			end
		end
		button:getChildByName("Image_selected"):setVisible(true)
		self.indexOfFlag = button:getTag()
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 5 then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function WorldMapKingdomCityChangeKingFlag:btnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		KWKingdomCtrl:changeFlag(self.indexOfFlag)
		print(self.indexOfFlag)
	end
end
return WorldMapKingdomCityChangeKingFlag
