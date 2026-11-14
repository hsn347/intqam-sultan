local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local playerAvatarBox = class("playerAvatarBox", function(target)
	if target == nil then
		local child = display.newNode()
		local size = child:getContentSize()
		return include("baseView").new(size, false, child)
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function playerAvatarBox:ctor()
	self.singleIsMoved = false
	self.imgPlayerFrmBg = ccui.ImageView:create("frame_square_black_06.png", ccui.TextureResType.plistType)
	self.imgPlayerFrmBg:setPosition(cc.p(50, 50))
	self.imgPlayerFrmBg:setContentSize(cc.size(80, 80))
	self.imgPlayerFrmBg:ignoreContentAdaptWithSize(false)
	self.imgPlayerFrmBg:addTo(self, -1)
	self.imgPlayerBg = ccui.ImageView:create("frame_LegendaryKing_head_square.png", ccui.TextureResType.plistType)
	self.imgPlayerBg:setPosition(cc.p(50, 50))
	self.imgPlayerBg:setContentSize(cc.size(88, 88))
	self.imgPlayerBg:ignoreContentAdaptWithSize(false)
	self.imgPlayerBg:addTo(self, 1)
	self.imgPlayer = ccui.ImageView:create("head_m_001.png", ccui.TextureResType.plistType)
	self.imgPlayer:setPosition(cc.p(50, 50))
	self.imgPlayer:setContentSize(cc.size(80, 80))
	self.imgPlayer:ignoreContentAdaptWithSize(false)
	self.imgPlayer:addTo(self, 0)
	self.btnPlayer = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnPlayer:setAnchorPoint(cc.p(0, 0))
	self.btnPlayer = include("scrollNode").new(self.btnPlayer)
	self.btnPlayer:ignoreContentAdaptWithSize(false)
	self.btnPlayer:setContentSize(cc.size(100, 100))
	self.btnPlayer:addTo(self, 2)
	if self.btnPlayer then
		self.btnPlayer:setSwallowTouches(false)
		self.btnPlayer:addTouchEventListener(handler(self, self.btnPlayerEvent))
	end
	self.itemWidth = self.imgPlayerBg:getContentSize().width
	self.itemHeight = self.imgPlayerBg:getContentSize().height
end
function playerAvatarBox:initWithData(data)
	local playerId = data.playerId
	local imageId = data.imageId
	local imgPlayer = data.imgPlayer
	local alv = data.alv
	local flag = data.flag
	local avatar = data.avatar
	local isRobot = data.isRobot
	local battleType = data.battleType
	self.playerId = playerId
	self.chatType = data.chatType
	self.alv = alv
	self.imageId = imageId
	self.avatar = avatar
	self.isRobot = isRobot
	self.imgPlayer:setVisible(true)
	self.imgPlayerBg:setVisible(true)
	self.imgPlayerFrmBg:setVisible(true)
	if self.spriteFlag then
		self.spriteFlag:setVisible(false)
	end
	if self.imageId and self.avatar and self.avatar ~= "" then
		self.imgPlayer.curlKey = nil
		SoraDGetHeadFromManager(self.imgPlayer, self.imageId, self.avatar)
	elseif self.imageId then
		imgPlayer = lordLocalData.getHead(self.imageId)
		self.imgPlayer:loadTexture(imgPlayer, ccui.TextureResType.plistType)
	elseif self.imgPlayer then
		self.imgPlayer:loadTexture(imgPlayer, ccui.TextureResType.plistType)
	end
	if flag ~= nil then
		self.imgPlayerFrmBg:setVisible(false)
		self.imgPlayer:setVisible(false)
		self.imgPlayerBg:setVisible(false)
		if self.spriteFlag then
			self.spriteFlag:removeFromParent()
			self.spriteFlag = nil
		end
		if not self.spriteFlag then
			local spriteFlag = SoraDGetAllianceFlagByFid(flag)
			self:addChild(spriteFlag, 2)
			spriteFlag:setPosition(cc.p(50, 38))
			spriteFlag:setScale(0.45)
			self.spriteFlag = spriteFlag
		end
	end
	if data.isLegendKing == true then
		if self.imgKing ~= nil then
			self.imgKing:setVisible(true)
		else
			self.imgKing = display.newSprite("#icon_legendary_01.png")
			self.imgKing:ignoreAnchorPointForPosition(false)
			self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
			self.imgKing:setPosition(SoraDFPoint(self.itemWidth / 2, 88, self.itemWidth))
			self.imgKing:setScale(0.6)
			self.imgKing:addTo(self)
		end
	elseif data.isLegendForSepKing == true then
		if self.imgKing ~= nil then
			self.imgKing:setVisible(true)
		else
			self.imgKing = display.newSprite("#icon_kingstarbattle_01.png")
			self.imgKing:ignoreAnchorPointForPosition(false)
			self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
			self.imgKing:setPosition(SoraDFPoint(self.itemWidth / 2, 88, self.itemWidth))
			self.imgKing:setScale(0.6)
			self.imgKing:addTo(self)
		end
	elseif data.isHegemon == true then
		if self.imgKing ~= nil then
			self.imgKing:setVisible(true)
		else
			self.imgKing = display.newSprite("#icon_bazhuzhizhan_01.png")
			self.imgKing:ignoreAnchorPointForPosition(false)
			self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
			self.imgKing:setPosition(SoraDFPoint(self.itemWidth / 2, 88, self.itemWidth))
			self.imgKing:setScale(0.5)
			self.imgKing:addTo(self)
		end
	elseif data.isKing == true then
		if self.imgKing ~= nil then
			self.imgKing:setVisible(true)
		else
			self.imgKing = display.newSprite("#icon_chat_king_01.png")
			self.imgKing:ignoreAnchorPointForPosition(false)
			self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
			self.imgKing:setPosition(SoraDFPoint(self.itemWidth / 2, 93, self.itemWidth))
			self.imgKing:setScale(1.0)
			self.imgKing:addTo(self)
		end
	elseif self.imgKing ~= nil then
		self.imgKing:setVisible(false)
	end
	if alv ~= nil and alv ~= 0 then
		if self.alvBg ~= nil then
			self.alvBg:setVisible(true)
		end
		if self.alvIcon ~= nil then
			self.alvIcon:setVisible(true)
		end
		if self.alvBg == nil then
			self.alvBg = display.newSprite("#frame_round_16.png")
			self.alvBg:ignoreAnchorPointForPosition(false)
			self.alvBg:setAnchorPoint(SoraDFAP(0, 0))
			self.alvBg:setPosition(SoraDFPoint(0, 0, self.itemWidth))
			self.alvBg:setScale(40 / self.alvBg:getContentSize().width)
			self.alvBg:addTo(self, 2)
		end
		if self.alvIcon == nil then
			self.alvIcon = display.newSprite("#icon_alliance_R1.png")
			self.alvIcon:setScale(28 / self.alvIcon:getContentSize().width)
			self.alvIcon:addTo(self, 2)
			self.alvIcon:setPosition(SoraDFPoint(20, 20, self.itemWidth))
		end
		local strIconName = string.format("icon_alliance_R%d.png", alv)
		if alv == gAllianceRank.OFFICIAL then
			strIconName = "icon_alliance_office.png"
		end
		local spriteFrame = display.newSpriteFrame(strIconName)
		if spriteFrame then
			self.alvIcon:setSpriteFrame(spriteFrame)
		end
	else
		if self.alvBg ~= nil then
			self.alvBg:setVisible(false)
		end
		if self.alvIcon ~= nil then
			self.alvIcon:setVisible(false)
		end
	end
end
function playerAvatarBox:initWithAllianceData(data)
	self.playerId = data.playerId
	self.chatType = data.chatType
	local allianceId = data.allianceId
	local allianceFlag = data.allianceFlag
	if self.imgPlayer then
		self.imgPlayer:setVisible(false)
	end
	if self.spriteFlag then
		self.spriteFlag:removeFromParent()
		self.spriteFlag = nil
	end
	if not self.spriteFlag then
		local spriteFlag = SoraDGetAllianceFlagByFid(allianceFlag)
		self:addChild(spriteFlag, 2)
		spriteFlag:setPosition(cc.p(50, 50))
		spriteFlag:setScale(0.45)
		self.spriteFlag = spriteFlag
	end
	self.imgPlayerFrmBg:setVisible(allianceFlag == nil)
	self.imgPlayerBg:setVisible(allianceFlag == nil)
end
function playerAvatarBox:getItemWidth()
	return self.itemWidth
end
function playerAvatarBox:getItemHeight()
	return self.itemHeight
end
function playerAvatarBox:btnPlayerEvent(target, event)
	if event == ccui.TouchEventType.began then
		self.imgPlayerBg:setScale(1.1)
		self.imgPlayer:setScale(1.1)
	elseif event == ccui.TouchEventType.ended then
		self.imgPlayerBg:setScale(1.0)
		self.imgPlayer:setScale(1.0)
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("点击了头像!!!!")
		SoraDPlaySound()
		if self.playerId == nil then
			return
		end
		if self.chatType ~= nil then
		elseif not self.isRobot then
			_ENV = "点击了头像!!!!"
			;("点击了头像!!!!").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;("点击了头像!!!!").playerID = self.playerId
			SoraDSendMessage("点击了头像!!!!")
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.imgPlayerBg:setScale(1.0)
		self.imgPlayer:setScale(1.0)
		self.singleIsMoved = false
	end
end
function playerAvatarBox:getIsTouchPointInPlayer(touchPoint)
	local bRet = false
	local btn = self.btnPlayer
	local parent = btn:getParent()
	local boundingBox = btn:getBoundingBox()
	local btnPosBL = cc.p(boundingBox.x, boundingBox.y)
	local posTouchToNode = parent:convertToNodeSpace(touchPoint)
	local posBtn = parent:convertToNodeSpace(parent:convertToWorldSpace(btnPosBL))
	boundingBox.x = posBtn.x
	boundingBox.y = posBtn.y
	if cc.rectContainsPoint(boundingBox, posTouchToNode) then
		bRet = true
	end
	return bRet
end
function playerAvatarBox:showGM()
	if self.spriteGM then
		self.spriteGM:setVisible(true)
	else
		self.spriteGM = display.newSprite("#" .. "icon_chat_gm.png")
		self.spriteGM:addTo(self)
		self.spriteGM:setAnchorPoint(SoraDFAP(0, 0))
		self.spriteGM:setPosition(SoraDFPoint(50, 0, self.itemWidth))
	end
end
function playerAvatarBox:hideGM()
	if self.spriteGM then
		self.spriteGM:setVisible(false)
	end
end
function playerAvatarBox:setBtnTouchEnabled(enable)
	if enable == false then
		self.btnPlayer:setTouchEnabled(false)
	else
		self.btnPlayer:setTouchEnabled(true)
		self.btnPlayer:setSwallowTouches(false)
		self.btnPlayer:addTouchEventListener(handler(self, self.btnPlayerEvent))
	end
end
function playerAvatarBox:setScroll(scroll)
	if scroll then
		self.btnPlayer:setScroll(scroll)
	end
end
function playerAvatarBox:setMailR(alv)
	if alv ~= nil and alv ~= 0 then
		if self.alvBg == nil then
			self.alvBg = ccui.ImageView:create()
			self.alvBg:loadTexture("frame_djzs_di.png", ccui.TextureResType.plistType)
			self.alvBg:ignoreContentAdaptWithSize(false)
			self.alvBg:setContentSize(cc.size(93, 35))
			self.alvBg:setAnchorPoint(SoraDFAP(0, 0))
			self.alvBg:setPosition(SoraDFPoint(10, 8, 8))
			self.alvBg:setFlippedX(not SoraDFIsRA())
			self.alvBg:addTo(self, 2)
		end
		if self.alvIcon == nil then
			self.alvIcon = display.newSprite("#icon_alliance_R1.png")
			self.alvIcon:addTo(self, 2)
			self.alvIcon:setPosition(SoraDFPoint(32, 20, 104))
		end
		local strIconName = string.format("icon_alliance_R%d.png", alv)
		if alv == gAllianceRank.OFFICIAL then
			strIconName = "icon_alliance_office.png"
			self.alvIcon:setPosition(SoraDFPoint(22, 20, 100))
		end
		local spriteFrame = display.newSpriteFrame(strIconName)
		if spriteFrame then
			self.alvIcon:setSpriteFrame(spriteFrame)
		end
		self.alvIcon:setScale(43 / self.alvIcon:getContentSize().width)
	else
		if self.alvBg ~= nil then
			self.alvBg:setVisible(false)
		end
		if self.alvIcon ~= nil then
			self.alvIcon:setVisible(false)
		end
	end
end
return playerAvatarBox
