local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local chatSkinRead = include("chatSkinRead")
local dressltCtrl = include("dressltCtrl")
local chatHeadNode = class("chatHeadNode", function(target)
	local target = include("chatBaseNode").new("chatHeadNode")
	return target
end)
_ENV = "chatHeadNode"
;("chatHeadNode").width = 132
;("chatHeadNode").height = 132
;("chatHeadNode").whitebg = "progressbar_white.png"
local _ENV, ("chatHeadNode").flagscale, _defaultParam = function(target)
	local target = include("chatBaseNode").new("chatHeadNode")
	return target
end, 0.5, "chatHeadNode"
;(function(target)
	local target = include("chatBaseNode").new("chatHeadNode")
	return target
end).normal = 1
chatHeadNode.headType, (function(target)
	local target = include("chatBaseNode").new("chatHeadNode")
	return target
end).alliance = function(target)
	local target = include("chatBaseNode").new("chatHeadNode")
	return target
end, 2
function chatHeadNode:ctor()
	self.singleIsMoved = false
	self.isDebug = gChatDebug
	self.imgPlayerBg = ccui.ImageView:create(_defaultParam.whitebg, ccui.TextureResType.plistType)
	self.imgPlayerBg:setColor(cc.c3b(0, 0, 0))
	self.imgPlayerBg:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.imgPlayerBg:setContentSize(cc.size(90, 90))
	self.imgPlayerBg:ignoreContentAdaptWithSize(false)
	self.imgPlayerBg:addTo(self, 0)
	self.imgPlayer = ccui.ImageView:create("head_m_001.png", ccui.TextureResType.plistType)
	self.imgPlayer:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.imgPlayer:setContentSize(cc.size(88, 88))
	self.imgPlayer:ignoreContentAdaptWithSize(false)
	self.imgPlayer:addTo(self, 0)
	self.imgAvatarFrame = ccui.ImageView:create("bg_transparent.png", ccui.TextureResType.plistType)
	self.imgAvatarFrame:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgAvatarFrame:setPosition(cc.p(self.imgPlayer:getContentSize().width / 2, self.imgPlayer:getContentSize().height / 2))
	self.imgAvatarFrame:setContentSize(cc.size(_defaultParam.width, _defaultParam.height))
	self.imgAvatarFrame:ignoreContentAdaptWithSize(false)
	self.imgAvatarFrame:addTo(self.imgPlayer)
	self.imgAvatarFramePosY = self.imgPlayer:getContentSize().height / 2
	self.btnPlayer = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnPlayer:setAnchorPoint(cc.p(0, 0))
	self.btnPlayer:ignoreContentAdaptWithSize(false)
	self.btnPlayer:setContentSize(cc.size(_defaultParam.width, _defaultParam.height))
	self.btnPlayer:addTo(self, 2)
	self.btnPlayer:setSwallowTouches(false)
	self.btnPlayer:setTouchEnabled(true)
	self.btnPlayer:addTouchEventListener(handler(self, self.btnPlayerEvent))
	self.addedH = 0
	self.width = _defaultParam.width
	self.height = _defaultParam.height
end
function chatHeadNode:reset()
	self.addedH = 0
	self.width = _defaultParam.width
	self.height = _defaultParam.height
	self.imgPlayer:setVisible(true)
	self.imgPlayerBg:setVisible(true)
	if self.spriteFlag then
		self.spriteFlag:setVisible(false)
	end
	if self.imgHeadWear then
		self.imgHeadWear:setVisible(false)
	end
	if self.alvBg ~= nil then
		self.alvBg:setVisible(false)
	end
	if self.alvIcon ~= nil then
		self.alvIcon:setVisible(false)
	end
	self.imgAvatarFrame:loadTexture("bg_transparent.png", ccui.TextureResType.plistType)
end
function chatHeadNode:init(data)
	self:setName("chatHeadNode")
	self.data = data
	self.playerId = data.playerId
	self.chatType = data.chatType
	self.alv = data.alv
	self.imageId = data.imageId
	self.avatar = data.avatarUrl
	self.isRobot = data.isRobot
	self.flag = data.allianceFlag
	self.aid = data.aid
	self.avatarFrameId = data.avatarFrameId
	self.headWearId = data.headWearId
	self.imgName = data.imgPlayer
	self.kid = data.kid
	self.isKohMigrateChatRoom = data.isKohMigrateChatRoom
	if data.isDebug ~= nil then
		self:setIsDebug(data.isDebug)
	end
	self:reset()
	if self.flag == nil then
		self:initHead()
	else
		self:initFlag()
	end
	self:initDebugView()
end
function chatHeadNode:initHead()
	if self.imageId and self.avatar and self.avatar ~= "" then
		self.imgPlayer.curlKey = nil
		SoraDGetHeadFromManager(self.imgPlayer, self.imageId, self.avatar)
	elseif self.imageId then
		local imgName = lordLocalData.getHead(self.imageId)
		self.imgPlayer:loadTexture(imgName, ccui.TextureResType.plistType)
	elseif self.imgPlayer then
		self.imgPlayer:loadTexture(self.imgName, ccui.TextureResType.plistType)
	end
	self:initAvatarFrame()
	self:initHeadWear()
	self:checkAndCreateALV()
	self:initImgLeader()
end
function chatHeadNode:initImgLeader()
	local isShow = self.isKohMigrateChatRoom and self.data.isAllianceLeader
	if isShow then
		if not self.imgLeader then
			self.imgLeader = ccui.ImageView:create("icon_room_owner.png", ccui.TextureResType.plistType)
			self.imgLeader:setAnchorPoint(cc.p(1, 1))
			self.imgLeader:setPosition(cc.p(self.imgPlayer:getContentSize().width + 10, self.imgPlayer:getContentSize().height + 5))
			self.imgLeader:addTo(self.imgPlayer)
		end
		self.imgLeader:setVisible(true)
	elseif self.imgLeader then
		self.imgLeader:setVisible(false)
	end
end
function chatHeadNode:initFlag()
	if self.imgPlayer then
		self.imgPlayer:setVisible(false)
	end
	self.imgPlayerBg:setVisible(false)
	self.imgAvatarFrame:setVisible(false)
	self:checkAndCreateaFlag()
end
function chatHeadNode:initAvatarFrame()
	if not self.avatarFrameId then
		self.imgAvatarFrame:setVisible(false)
		return
	end
	local chatFunctions = include("chatFunctions")
	_ENV = "chatFunctions"
	;("chatFunctions").data = self.data
	local ("chatFunctions").checkRes, param = true, "chatFunctions"
	local cfg = chatSkinRead.getAvatarFrameCfg(self.avatarFrameId)
	if not cfg then
		self.imgAvatarFrame:setVisible(false)
		return
	end
	self.avatarFrameId = chatFunctions.getShowAvatarFrameId(param)
	dump(cfg, "framecfg", 10)
	self.imgAvatarFrame:removeAllChildren()
	self.imgAvatarFrame:loadTexture(cfg.img, ccui.TextureResType.plistType)
	self.imgAvatarFrame:setName("imgAvatarFrame")
	self.imgAvatarFrame:ignoreContentAdaptWithSize(false)
	self.imgAvatarFrame:setVisible(true)
	self.imgAvatarFrame:setScale(1)
	self.imgAvatarFrame:setPosition(cc.p(self.imgPlayer:getContentSize().width / 2, self.imgPlayer:getContentSize().height / 2))
	if cfg.index then
		local fixCfg = dressltCtrl.getAvatarFrameCfg(cfg.index)
		if fixCfg then
			self.imgAvatarFrame:setPositionY(self.imgAvatarFramePosY + fixCfg.offsetY)
			self.imgAvatarFrame:setScale(fixCfg.scale or 1)
		end
		if cfg.index == 107 then
			local et_avatar = display.newSprite("#dh_lttxk_01.png")
			SoraDMixtureGLONE(et_avatar)
			et_avatar:setPosition(self.imgAvatarFrame:getContentSize().width / 2, self.imgAvatarFrame:getContentSize().height / 2)
			et_avatar:addTo(self.imgAvatarFrame)
			local frames = display.newFrames("dh_lttxk_%.2d.png", 1, 24)
			local animation = display.newAnimation(frames, 2 / #frames)
			et_avatar:playAnimationForever(animation)
		end
		if cfg.index == 110 then
			local et_avatar = display.newSprite("#dh_yqzcltzb_txk_01.png")
			SoraDMixtureGLONE(et_avatar)
			et_avatar:setPosition(self.imgAvatarFrame:getContentSize().width / 2, self.imgAvatarFrame:getContentSize().height / 2)
			et_avatar:addTo(self.imgAvatarFrame)
			local frames = display.newFrames("dh_yqzcltzb_txk_%.2d.png", 1, 24)
			local animation = display.newAnimation(frames, 2 / #frames)
			et_avatar:playAnimationForever(animation)
		end
	end
end
function chatHeadNode:initHeadWear()
	if not self.headWearId then
		if self.imgHeadWear then
			self.imgHeadWear:setVisible(false)
		end
		return
	end
	local cfg = chatSkinRead.getHeadWearCfg(self.headWearId)
	if not cfg then
		if self.imgHeadWear then
			self.imgHeadWear:setVisible(false)
		end
		return
	end
	local chatFunctions = include("chatFunctions")
	chatSkinRead = "chatFunctions"
	;("chatFunctions").data = self.data
	local ("chatFunctions").checkRes, param = true, "chatFunctions"
	self.headWearId = chatFunctions.getShowHeadWearId(param)
	if not self.imgHeadWear then
		self.imgHeadWear = ccui.ImageView:create("bg_transparent.png", ccui.TextureResType.plistType)
		self.imgHeadWear:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height))
		self.imgHeadWear:ignoreContentAdaptWithSize(false)
		self.imgHeadWear:addTo(self, 2)
	end
	self.imgHeadWear:setName("imgHeadWear")
	self.imgHeadWear:setVisible(true)
	self.imgHeadWear:ignoreContentAdaptWithSize(true)
	self.imgHeadWear:loadTexture(cfg.img, ccui.TextureResType.plistType)
	self.imgHeadWear:setScale(cfg.scale)
	self.imgHeadWear:setPositionX(_defaultParam.width / 2 + cfg.offset[1])
	self.imgHeadWear:setPositionY(_defaultParam.height + cfg.offset[2])
	self.addedH = cfg.scale * cfg.imgHeight / 2 + cfg.offset[2]
	self.height = _defaultParam.height + self.addedH
end
function chatHeadNode:checkAndCreateaFlag()
	if self.flag ~= nil then
		if self.spriteFlag then
			self.spriteFlag:removeFromParent()
			self.spriteFlag = nil
		end
		if not self.spriteFlag then
			local spriteFlag = SoraDGetAllianceFlagByFid(self.flag)
			self:addChild(spriteFlag, 4)
			spriteFlag:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
			local scale = (_defaultParam.width - 10) / spriteFlag:getContentSize().width
			spriteFlag:setScale(_defaultParam.flagscale)
			self.spriteFlag = spriteFlag
		end
		self.spriteFlag:setVisible(true)
	end
end
function chatHeadNode:checkAndCreateALV()
	if self.alv ~= nil and self.alv ~= 0 then
		if self.alvBg == nil then
			self.alvBg = display.newSprite("#frame_round_16.png")
			self.alvBg:ignoreAnchorPointForPosition(false)
			self.alvBg:setAnchorPoint(SoraDFAP(0, 0))
			self.alvBg:setPosition(SoraDFPoint(0, 0, self.width))
			self.alvBg:setScale(40 / self.alvBg:getContentSize().width)
			self.alvBg:addTo(self, 3)
		end
		if self.alvIcon == nil then
			self.alvIcon = display.newSprite("#icon_alliance_R1.png")
			self.alvIcon:setScale(28 / self.alvIcon:getContentSize().width)
			self.alvIcon:addTo(self, 4)
			self.alvIcon:setPosition(SoraDFPoint(20, 20, self.width))
		end
		local strIconName = string.format("icon_alliance_R%d.png", self.alv)
		self.alvIcon:setPositionY(20)
		if self.alv == gAllianceRank.OFFICIAL then
			strIconName = "icon_alliance_office.png"
			self.alvIcon:setPositionY(23)
		end
		local spriteFrame = display.newSpriteFrame(strIconName)
		if spriteFrame then
			self.alvIcon:setSpriteFrame(spriteFrame)
		end
		self.alvBg:setVisible(true)
		self.alvIcon:setVisible(true)
	end
end
function chatHeadNode:setScroll(scroll)
	self.scroll = scroll
end
function chatHeadNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
function chatHeadNode:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	local lb = cc.p(0, 0)
	local lt = cc.p(0, self.height)
	local rt = cc.p(self.width, self.height)
	local rb = cc.p(self.width, 0)
	_UPVALUE4_ = self.width
	self.width[1] = lb
	self.width[2] = lt
	self.width[3] = rt
	local self.width[4], tbPoints = rb, self.width
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 0, 1))
end
function chatHeadNode:btnPlayerEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("点击了头像!!!!")
		dump(self.data, "聊天数据结构")
		if self.playerId == nil or self.playerId == 0 then
			print("playerId= ", self.playerId)
			return
		end
		if self.data.npcId and self.data.npcId ~= 0 then
			print("这是npc")
			return
		end
		if self.chatType ~= nil then
			if self.scroll then
				if SoraDIsNodeVisibleOnScroll(target, self.scroll) == true then
					local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
					if chatAudioMgr:hasCurPlayAudio() then
						chatAudioMgr:stopCurPlayAudio()
					else
						print("没有在播放的语音")
					end
					SoraDPlaySound()
					print("在滚动框内===")
					_ENV = "在滚动框内==="
					;("在滚动框内===").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
					;("在滚动框内===").playerID = self.playerId
					;("在滚动框内===").kid = self.kid
					SoraDSendMessage("在滚动框内===")
				else
					print("在滚动框外===")
				end
			else
				print("发起请求")
				SoraDPlaySound()
				_ENV = "发起请求"
				;("发起请求").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;("发起请求").playerID = self.playerId
				;("发起请求").kid = self.kid
				SoraDSendMessage("发起请求")
			end
		elseif not self.isRobot then
			SoraDPlaySound()
			_ENV = "发起请求"
			;("发起请求").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;("发起请求").playerID = self.playerId
			;("发起请求").kid = self.kid
			SoraDSendMessage("发起请求")
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
function chatHeadNode:setBtnTouchEnabled(enable)
	if enable == false then
		self.btnPlayer:setTouchEnabled(false)
	else
		self.btnPlayer:setTouchEnabled(true)
		self.btnPlayer:setSwallowTouches(false)
		self.btnPlayer:addTouchEventListener(handler(self, self.btnPlayerEvent))
	end
end
function chatHeadNode.measureSize(data, target)
	local defaultSize = cc.size(_defaultParam.width, _defaultParam.height)
	defaultSize.addedH = 0
	if data.flag then
		return defaultSize
	end
	if not data.headWearId then
		return defaultSize
	else
		local cfg = chatSkinRead.getHeadWearCfg(data.headWearId)
		if not cfg then
			return defaultSize
		end
		local addedH = cfg.scale * cfg.imgHeight / 2 + cfg.offset[2]
		local retSize = cc.size(_defaultParam.width, _defaultParam.height + addedH)
		retSize.addedH = addedH
		return retSize
	end
end
return chatHeadNode
