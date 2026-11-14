local chatFunctions = include("chatFunctions")
local chatDesRead = include("chatDesRead")
local fileSysBgL = "frame_chat_dialogue_01.png"
local fileKnoticeBgL = "frame_chat_dialogue_04.png"
local fileChatOtherBgL = "frame_chat_dialogue_02.png"
local fileChatSelfBgL = "frame_chat_dialogue_03.png"
local fileSysBgR = "frame_chat_dialogue_01_2.png"
local fileKnoticeBgR = "frame_chat_dialogue_04_2.png"
local fileChatOtherBgR = "frame_chat_dialogue_02_2.png"
local fileChatSelfBgR = "frame_chat_dialogue_03_2.png"
local fileKingL = "frame_chat_king_base_01.png"
local fileKingR = "frame_chat_king_base_01.png"
local fileLegendKingL = "frame_talk_legendaryKing_02.png"
local fileLegendKingR = "frame_talk_legendaryKing_01.png"
local fileHegemonL = "frame_talk_hegemon_flip.png"
local fileHegemonR = "frame_talk_hegemon.png"
local fileKingCap = "icon_chat_king_01.png"
local fileKingCorner = "frame_chat_king_arrow_01.png"
local fileLegendKingCap = "icon_legendary_01.png"
local fileLegendKingCorner = "frame_chat_king_arrow_01.png"
local minWidthBg = 140
local maxWidthBg = 420
local minHbg = 70
local deltaWEmotionBgArrow = 34
local deltaWEmotionBgArrowLK = 50
local deltaWEmotionBgArrowHK = 50
local deltaHTop = 14
local deltaHBottom = 10
local deltaHPaddingInfo = 2
local maxWidthEmotion = 100
local deltaBgSide = 10
local deltaKingSide = 10
local deltaKingCornerTop = 22
local deltaKingCornerSide = 10
local deltaHTopLK = 40
local deltaBgSideLK = 35
local deltaHBottomLK = 15
local deltaHTopHK = 40
local deltaBgSideHK = 35
local deltaHBottomHK = 30
local capInsets = cc.rect(45, 42, 1, 6)
local capInsetsKing = cc.rect(42, 40, 12, 10)
local capInsetsLegendKingL = cc.rect(65, 88, 6, 19)
local capInsetsLegendKingR = cc.rect(88, 88, 6, 19)
local capInsetsLegendKing = capInsetsLegendKingL
local capInsetsHegemonL = cc.rect(72, 76, 41, 6)
local capInsetsHegemonR = cc.rect(92, 76, 41, 6)
local capInsetsHegemon = capInsetsHegemonL
local colorText = cc.c3b(255, 255, 255)
local colorTextInfo = cc.c3b(177, 177, 177)
local colorTextLK = cc.c3b(255, 255, 255)
local colorTextHK = cc.c3b(255, 255, 255)
local colorTextInfoLK = cc.c3b(115, 45, 5)
local colorTextInfoHK = cc.c3b(115, 45, 5)
local playerChatEmotion = class("playerChatEmotion", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function playerChatEmotion:ctor()
	self.imgBg = ccui.ImageView:create("frame_chat_dialogue_02.png", ccui.TextureResType.plistType)
	self.imgBg:setPosition(cc.p(220, 0))
	self.imgBg:setAnchorPoint(cc.p(0.5, 0))
	self.imgBg:setScale9Enabled(true)
	self.imgBg:setCapInsets(capInsets)
	self.imgBg:setContentSize(cc.size(440, 70))
	self.imgBg:ignoreContentAdaptWithSize(false)
	self.imgBg:addTo(self)
	self.textInfo = ccui.Text:create("", "", 18)
	self.textInfo:setTextHorizontalAlignment(SoraDFLabelR())
	self.textInfo:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textInfo:setTextColor(cc.c3b(177, 177, 177))
	self.textInfo:setAnchorPoint(SoraDFAP(1, 0))
	self.textInfo:ignoreContentAdaptWithSize(true)
	self.textInfo:addTo(self)
	self.textInfo:setAnchorPoint(cc.p(1, 0))
	self.imgEmotion = ccui.ImageView:create("chat_face_1.png", ccui.TextureResType.plistType)
	self.imgEmotion:setAnchorPoint(SoraDFAP(0, 1))
	self.imgEmotion:setPosition(SoraDFPoint(390, 62, 440))
	self.imgEmotion:addTo(self)
	self.itemWidth = 0
	self.itemHeight = 0
end
function playerChatEmotion:getIsTouchPointInPlayer(touchPoint)
	local bRet = false
	local btn = self.imgBg
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
function playerChatEmotion:initWithData(data)
	local playerId = data.playerId
	local chatId = data.chatId
	local content = data.content
	local info = data.info
	self.playerId = playerId
	self.chatId = chatId
	self.content = data.content
	self.info = data.info
	self.align = data.align
	self.isKing = data.isKing
	self.isLegendKing = data.isLegendKing
	self.isLegendForSepKing = data.isLegendForSepKing
	self.isHegemon = data.isHegemon
	self.textInfo:setTextColor(colorTextInfo)
	if self.isLegendKing or data.isLegendForSepKing then
		self.isKing = false
		self.isHegemon = false
	elseif self.isHegemon then
		self.isKing = false
	end
	self.isSendToAll = data.isSendToAll
	self:hideShareWidgets()
	if not self.imgEmotion then
		return
	end
	if self.isSendToAll and self.isSendToAll == 1 then
		self:loadSendToAll()
	else
		self:hideSendToAll()
	end
	local isSelf = chatFunctions.getIsPlayerSelf(self.playerId)
	local fileBgName = fileChatSelfBgL
	local isNeedBgFlipX = false
	local isShowKing = false
	local isShowLegendKing = false
	local isShowHegemon = false
	local isShowLegendForSepKing = false
	if self.isKing == true then
		isShowKing = true
	end
	if self.isHegemon == true then
		isShowHegemon = true
	end
	if self.isLegendKing == true then
		isShowLegendKing = true
	end
	if self.isLegendForSepKing == true then
		isShowLegendForSepKing = true
	end
	if isShowLegendKing == true then
		if self.align == 0 then
			fileBgName = fileLegendKingL
		else
			fileBgName = fileLegendKingR
		end
	elseif isShowLegendForSepKing == true then
		if self.align == 0 then
			fileBgName = fileLegendKingL
		else
			fileBgName = fileLegendKingR
		end
	elseif isShowHegemon == true then
		if self.align == 0 then
			fileBgName = fileHegemonL
		else
			fileBgName = fileHegemonR
		end
	elseif isShowKing == true then
		if self.align == 0 then
			fileBgName = fileKingL
		else
			fileBgName = fileKingR
		end
	elseif isSelf then
		fileBgName = fileChatSelfBgL
		if self.align == 0 then
			fileBgName = fileChatSelfBgL
		else
			fileBgName = fileChatSelfBgR
		end
	else
		fileBgName = fileChatOtherBgR
		if self.align == 0 then
			fileBgName = fileChatOtherBgL
		else
			isNeedBgFlipX = false
			fileBgName = fileChatOtherBgR
		end
	end
	self:hideKingCap()
	self.imgBg:loadTexture(fileBgName, ccui.TextureResType.plistType)
	if self.imgEmotion then
		local imgid = content
		if imgid == nil then
			return
		end
		local imgName = chatDesRead.getEmotionImgById(imgid)
		self.imgEmotion:loadTexture(imgName, ccui.TextureResType.plistType)
		local emotionSize = self.imgEmotion:getContentSize()
		if emotionSize.width > maxWidthEmotion then
			self.imgEmotion:setContentSize(cc.size(maxWidthEmotion, maxWidthEmotion / emotionSize.width * emotionSize.height))
			self.imgEmotion:ignoreContentAdaptWithSize(false)
		end
	end
	if self.textInfo then
		self.textInfo:setString(info)
	end
	local autoRenderShareSize = cc.size(0, 0)
	if self.isSendToAll and self.isSendToAll == 1 then
		autoRenderShareSize = self.label_share_1:getContentSize()
	end
	local contentWidth = self.imgEmotion:getContentSize().width + self.textInfo:getContentSize().width
	if contentWidth < autoRenderShareSize.width then
		contentWidth = autoRenderShareSize.width
	end
	local accumulateHeight = deltaHTop + self.imgEmotion:getContentSize().height + deltaHPaddingInfo + autoRenderShareSize.height + self.textInfo:getContentSize().height + deltaHBottom
	local accumulateWidth = deltaWEmotionBgArrow + contentWidth + deltaBgSide
	if isShowLegendKing == true then
		accumulateHeight = deltaHTopLK + self.imgEmotion:getContentSize().height + deltaHPaddingInfo + autoRenderShareSize.height + self.textInfo:getContentSize().height + deltaHBottomLK
		accumulateWidth = deltaWEmotionBgArrowLK + contentWidth + deltaBgSideLK
	elseif isShowLegendForSepKing == true then
		accumulateHeight = deltaHTopLK + self.imgEmotion:getContentSize().height + deltaHPaddingInfo + autoRenderShareSize.height + self.textInfo:getContentSize().height + deltaHBottomLK
		accumulateWidth = deltaWEmotionBgArrowLK + contentWidth + deltaBgSideLK
	elseif isShowHegemon == true then
		accumulateHeight = deltaHTopHK + self.imgEmotion:getContentSize().height + deltaHPaddingInfo + autoRenderShareSize.height + self.textInfo:getContentSize().height + deltaHBottomHK
		accumulateWidth = deltaWEmotionBgArrowHK + contentWidth + deltaBgSideHK
	end
	if accumulateWidth < minWidthBg then
		accumulateWidth = minWidthBg
	elseif accumulateWidth > maxWidthBg then
		accumulateWidth = maxWidthBg
	end
	self.imgBg:setContentSize(cc.size(accumulateWidth, accumulateHeight))
	if self.align == 0 then
		local imgEmotionSide = SoraDFIsRA() and deltaBgSide or deltaWEmotionBgArrow
		local deltaInfoSide = SoraDFIsRA() and deltaWEmotionBgArrow or deltaBgSide
		local _deltaHTop = deltaHTop
		local _deltaHBottom = deltaHBottom
		if isShowLegendKing == true then
			imgEmotionSide = SoraDFIsRA() and deltaBgSideLK or deltaWEmotionBgArrowLK
			deltaInfoSide = SoraDFIsRA() and deltaWEmotionBgArrowLK or deltaBgSideLK
			_deltaHTop = deltaHTopLK
			_deltaHBottom = deltaHBottomLK
			self.textInfo:setTextColor(colorTextInfoLK)
		elseif isShowLegendForSepKing == true then
			imgEmotionSide = SoraDFIsRA() and deltaBgSideLK or deltaWEmotionBgArrowLK
			deltaInfoSide = SoraDFIsRA() and deltaWEmotionBgArrowLK or deltaBgSideLK
			_deltaHTop = deltaHTopLK
			_deltaHBottom = deltaHBottomLK
			self.textInfo:setTextColor(colorTextInfoLK)
		elseif isShowHegemon == true then
			imgEmotionSide = SoraDFIsRA() and deltaBgSideHK or deltaWEmotionBgArrowHK
			deltaInfoSide = SoraDFIsRA() and deltaWEmotionBgArrowHK or deltaBgSideHK
			_deltaHTop = deltaHTopHK
			_deltaHBottom = deltaHBottomHK
			self.textInfo:setTextColor(colorTextInfoHK)
		end
		self.imgEmotion:setAnchorPoint(SoraDFAP(1, 1))
		self.imgEmotion:setPosition(SoraDFPoint(accumulateWidth - imgEmotionSide, accumulateHeight - _deltaHTop, accumulateWidth))
		self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
		self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, _deltaHBottom, accumulateWidth))
		if isShowLegendKing == true then
			self.imgBg:setCapInsets(capInsetsLegendKing)
		elseif isShowLegendForSepKing == true then
			self.imgBg:setCapInsets(capInsetsLegendKing)
		elseif isShowHegemon == true then
			self.imgBg:setCapInsets(capInsetsHegemon)
		elseif isShowKing == true then
			self.imgBg:setCapInsets(capInsetsKing)
		else
			self.imgBg:setCapInsets(capInsets)
		end
		self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and deltaKingSide or 0))
		if self.isSendToAll and self.isSendToAll == 1 then
			self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
			self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - imgEmotionSide, accumulateHeight - _deltaHTop - self.imgEmotion:getContentSize().height, accumulateWidth))
		end
	else
		local imgEmotionSide = SoraDFIsRA() and deltaWEmotionBgArrow or deltaBgSide
		local deltaInfoSide = SoraDFIsRA() and deltaBgSide or deltaWEmotionBgArrow
		local _deltaHTop = deltaHTop
		local _deltaHBottom = deltaHBottom
		if isShowLegendKing == true then
			imgEmotionSide = SoraDFIsRA() and deltaWEmotionBgArrowLK or deltaBgSideLK
			deltaInfoSide = SoraDFIsRA() and deltaBgSideLK or deltaWEmotionBgArrowLK
			_deltaHTop = deltaHTopLK
			_deltaHBottom = deltaHBottomLK
			self.textInfo:setTextColor(colorTextInfoLK)
		elseif isShowLegendForSepKing == true then
			imgEmotionSide = SoraDFIsRA() and deltaWEmotionBgArrowLK or deltaBgSideLK
			deltaInfoSide = SoraDFIsRA() and deltaBgSideLK or deltaWEmotionBgArrowLK
			_deltaHTop = deltaHTopLK
			_deltaHBottom = deltaHBottomLK
			self.textInfo:setTextColor(colorTextInfoLK)
		elseif isShowHegemon == true then
			imgEmotionSide = SoraDFIsRA() and deltaWEmotionBgArrowHK or deltaBgSideHK
			deltaInfoSide = SoraDFIsRA() and deltaBgSideHK or deltaWEmotionBgArrowHK
			_deltaHTop = deltaHTopHK
			_deltaHBottom = deltaHBottomHK
			self.textInfo:setTextColor(colorTextInfoHK)
		end
		self.imgEmotion:setAnchorPoint(SoraDFAP(1, 1))
		self.imgEmotion:setPosition(SoraDFPoint(accumulateWidth - imgEmotionSide, accumulateHeight - _deltaHTop, accumulateWidth))
		self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
		self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, _deltaHBottom, accumulateWidth))
		if isShowLegendKing == true then
			self.imgBg:setCapInsets(capInsetsLegendKing)
		elseif isShowLegendForSepKing == true then
			self.imgBg:setCapInsets(capInsetsLegendKing)
		elseif isShowHegemon == true then
			self.imgBg:setCapInsets(capInsetsHegemon)
		elseif isShowKing == true then
			self.imgBg:setCapInsets(capInsetsKing)
		else
			self.imgBg:setCapInsets(capInsets)
		end
		self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and -deltaKingSide or 0))
		if self.isSendToAll and self.isSendToAll == 1 then
			self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
			self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - imgEmotionSide, accumulateHeight - _deltaHTop - self.imgEmotion:getContentSize().height, accumulateWidth))
		end
	end
	self.itemWidth = accumulateWidth
	self.itemHeight = accumulateHeight
	if isShowLegendKing then
		self:showLegendKingCap(self.align)
	elseif isShowLegendForSepKing then
		self:showLegendKingCap(self.align)
	elseif isShowHegemon then
		self:showHegemonCap(self.align)
	elseif isShowKing then
		self:showKingCap(self.align)
	end
end
function playerChatEmotion:getItemWidth()
	return self.itemWidth
end
function playerChatEmotion:getItemHeight()
	return self.itemHeight
end
function playerChatEmotion:showKingCap(align)
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
	else
		self.imgKing = display.newSprite("#icon_chat_king_01.png")
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	self.imgKing:setScale(0.6)
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(fileKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(10)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
end
function playerChatEmotion:showLegendKingCap(align)
	do return end
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
	else
		self.imgKing = display.newSprite("#" .. fileLegendKingCap)
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	self.imgKing:setScale(0.36)
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(fileLegendKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(10)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
end
function playerChatEmotion:showHegemonCap(align)
	do return end
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
	else
		self.imgKing = display.newSprite("#" .. fileLegendKingCap)
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	self.imgKing:setScale(0.36)
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(fileLegendKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(10)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 15))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - deltaKingCornerSide, self.itemHeight - deltaKingCornerTop)
	end
end
function playerChatEmotion:hideKingCap()
	if self.imgKing ~= nil then
		self.imgKing:setVisible(false)
	end
	if self.imgKingCorner then
		self.imgKingCorner:setVisible(false)
	end
end
function playerChatEmotion:loadSendToAll()
	print("对全体发送-------添加标识")
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(0, 30.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	self.label_share_1:setString(i18n("common_text_083"))
end
function playerChatEmotion:hideSendToAll()
end
function playerChatEmotion:hideShareWidgets()
	if self.label_share_1 then
		self.label_share_1:setVisible(false)
	end
end
return playerChatEmotion
