local chatFunctions = include("chatFunctions")
local chatConst = include("chatConst")
_ENV = "chatConst"
;("chatConst").fileSysBgL = "frame_chat_dialogue_01.png"
;("chatConst").fileKnoticeBgL = "frame_chat_dialogue_04.png"
;("chatConst").fileChatOtherBgL = "frame_chat_dialogue_02.png"
;("chatConst").fileChatSelfBgL = "frame_chat_dialogue_03.png"
;("chatConst").fileSysBgR = "frame_chat_dialogue_01_2.png"
;("chatConst").fileKnoticeBgR = "frame_chat_dialogue_04_2.png"
;("chatConst").fileChatOtherBgR = "frame_chat_dialogue_02_2.png"
;("chatConst").fileChatSelfBgR = "frame_chat_dialogue_03_2.png"
;("chatConst").fileRedPacketL = "frame_redpacket_text_01.png"
;("chatConst").fileRedPacketR = "frame_redpacket_text_01.png"
;("chatConst").fileKingL = "frame_chat_king_base_01.png"
;("chatConst").fileKingR = "frame_chat_king_base_01.png"
;("chatConst").fileLegendKingL = "frame_talk_legendaryKing_02.png"
;("chatConst").fileLegendKingR = "frame_talk_legendaryKing_01.png"
;("chatConst").fileHegemonL = "frame_talk_hegemon_flip.png"
;("chatConst").fileHegemonR = "frame_talk_hegemon.png"
;("chatConst").fileKingCap = "icon_chat_king_01.png"
;("chatConst").fileKingCorner = "frame_chat_king_arrow_01.png"
;("chatConst").fileLegendKingCap = "icon_legendary_01.png"
;("chatConst").fileKingStarCap = "icon_kingstarbattle_01.png"
;("chatConst").fileLegendKingCorner = "frame_chat_king_arrow_01.png"
;("chatConst").fileAudio = "et_laba_display03.png"
;("chatConst").minWidthBg = 170
;("chatConst").maxWidthBg = 420
;("chatConst").minHbg = 70
;("chatConst").deltaWTextBgArrow = 34
;("chatConst").deltaWSysBgArrow = 30
;("chatConst").deltaWReportBgArrow = 30
;("chatConst").deltaWPaddingTextSys = 6
;("chatConst").deltaWRPBgArrow = 30
;("chatConst").deltaRPBgSide = 10
;("chatConst").deltaHTopRp = 9
;("chatConst").deltaWPaddingTextRP = 6
;("chatConst").widthTextRP = 200
;("chatConst").deltaHTopRPText = 30
;("chatConst").deltaHTopText = 14
;("chatConst").deltaHTopSys = 9
;("chatConst").deltaHTopMailReport = 37
;("chatConst").deltaHBottomText = 10
;("chatConst").deltaHPaddingInfo = 4
;("chatConst").deltaHPaddingInfoRP = 6
;("chatConst").deltaBgSide = 10
;("chatConst").deltaBgReportSide = 10
;("chatConst").deltaKingSide = 10
;("chatConst").deltaLegendKingSide = 0
;("chatConst").deltaHegemonSide = 0
;("chatConst").deltaKingCornerTop = 22
;("chatConst").deltaKingCornerSide = 10
;("chatConst").deltaBgSideLK = 35
;("chatConst").deltaWTextBgArrowLK = 50
;("chatConst").deltaBgSideHK = 35
;("chatConst").deltaWTextBgArrowHK = 50
;("chatConst").deltaLegendKingCornerSide = 40
;("chatConst").deltaHTopTextLK = 40
;("chatConst").deltaHBottomTextLK = 15
;("chatConst").minHbgLK = 110
;("chatConst").deltaHegemonCornerSide = 40
;("chatConst").deltaHTopTextHK = 40
;("chatConst").deltaHBottomTextHK = 30
;("chatConst").minHbgHK = 145
;("chatConst").sizeSysImg = cc.size(53, 31)
;("chatConst").capInsets = cc.rect(45, 42, 1, 6)
;("chatConst").capInsetsKing = cc.rect(42, 40, 12, 10)
;("chatConst").capInsetsLegendKingL = cc.rect(65, 88, 6, 19)
;("chatConst").capInsetsLegendKingR = cc.rect(88, 88, 6, 19)
;("chatConst").capInsetsHegemonL = cc.rect(72, 76, 41, 6)
;("chatConst").capInsetsHegemonR = cc.rect(92, 76, 41, 6)
;("chatConst").capInsetsLegendKing = cc.rect(65, 88, 6, 19)
;("chatConst").capInsetsHegemon = cc.rect(72, 76, 41, 6)
;("chatConst").sizeMailReport = cc.size(36, 23)
;("chatConst").sizeImgEquip = cc.size(22, 22)
;("chatConst").sizeImgMailReport = cc.size(36, 23)
;("chatConst").sizeImgRedPacket = cc.size(41, 70)
;("chatConst").sizeImgAudio = cc.size(24, 32)
;("chatConst").colorAudioOther = cc.c3b(60, 130, 95)
;("chatConst").colorAudioSelf = cc.c3b(255, 255, 255)
;("chatConst").colorText = cc.c3b(255, 255, 255)
;("chatConst").colorTextInfo = cc.c3b(177, 177, 177)
;("chatConst").colorTextLK = cc.c3b(255, 255, 255)
;("chatConst").colorTextInfoLK = cc.c3b(115, 45, 5)
;("chatConst").colorTextHK = cc.c3b(255, 255, 255)
local ("chatConst").colorTextInfoHK, CV = cc.c3b(115, 45, 5), "chatConst"
local playerChatContent = class("playerChatContent", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function playerChatContent:ctor()
	self.imgBg = ccui.ImageView:create("frame_chat_dialogue_02.png", ccui.TextureResType.plistType)
	self.imgBg:setPosition(cc.p(220, 0))
	self.imgBg:setAnchorPoint(cc.p(0.5, 0))
	self.imgBg:setScale9Enabled(true)
	self.imgBg:setCapInsets(CV.capInsets)
	self.imgBg:setContentSize(cc.size(440, 70))
	self.imgBg:ignoreContentAdaptWithSize(false)
	self.imgBg:addTo(self)
	self.singleIsMoved = false
	self.textChat = ccui.Text:create("", "", 20)
	self.textChat:setTextHorizontalAlignment(SoraDFLabelR())
	self.textChat:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textChat:setTextColor(cc.c3b(255, 255, 255))
	self.textChat:setPosition(cc.p(243, 58.5))
	self.textChat:setAnchorPoint(cc.p(0, 1))
	self.textChat:addTo(self)
	self.textInfo = ccui.Text:create("", "", 16)
	self.textInfo:setTextHorizontalAlignment(SoraDFLabelR())
	self.textInfo:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textInfo:setTextColor(cc.c3b(177, 177, 177))
	self.textInfo:setAnchorPoint(SoraDFAP(1, 0))
	self.textInfo:ignoreContentAdaptWithSize(true)
	self.textInfo:addTo(self)
	self.textInfo:setAnchorPoint(cc.p(1, 0))
	self.spriteSys = display.newSprite("#icon_chat_sys.png", 28, 64)
	self.spriteSys:setAnchorPoint(cc.p(0, 1))
	self.spriteSys:addTo(self)
	self.itemWidth = CV.maxWidthBg
	self.itemHeight = CV.minHbg
end
function playerChatContent:getIsTouchPointInPlayer(touchPoint)
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
function playerChatContent:initWithData(data)
	self:setColor(cc.c3b(255, 255, 255))
	local playerId = data.playerId
	local chatId = data.chatId
	local content = data.content
	local info = data.info
	local isSys = data.isSys
	local align = data.align
	self.chatType = data.chatType
	self.playerId = playerId
	self.chatId = chatId
	self.content = data.content
	self.info = info
	self.isSys = data.isSys
	self.align = data.align
	self.isKNotice = data.isKNotice or false
	self.dataType = data.dataType
	self.customData = data.customData
	self.isKing = data.isKing
	self.isLegendKing = data.isLegendKing
	self.isLegendForSepKing = data.isLegendForSepKing
	self.isHegemon = data.isHegemon
	if self.isLegendKing or self.isLegendForSepKing then
		self.isKing = false
		self.isHegemon = false
	end
	self.isSendToAll = data.isSendToAll
	self.textChat:setTextColor(CV.colorText)
	self.textInfo:setTextColor(CV.colorTextInfo)
	self:hideKingCap()
	self:hideShareWidgets()
	if self.label_share_1 then
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
	end
	if self.dataType == gChatDataType.dataType_fightReport then
		self:loadMailReport()
	else
		self:hideMailReport()
	end
	if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
		self:loadEquipInfo()
	else
		self:hideEquipInfo()
	end
	if self.dataType == gChatDataType.dataType_pyramid_share then
		self:loadPyramidShare()
	else
		self:hidePyramidShare()
	end
	if self.dataType == gChatDataType.dataType_rally then
		self:loadRally()
	else
		self:hideRally()
	end
	if self.dataType == gChatDataType.dataType_pet then
		self:loadPet()
	else
		self:hidePet()
	end
	if self.dataType == gChatDataType.dataType_hero_share then
		self:loadHero()
	else
		self:hideHero()
	end
	if self.dataType == gChatDataType.dataType_arms_share then
		self:loadArms()
	else
		self:hideArms()
	end
	if self.dataType == gChatDataType.dataType_red_packet then
		self:loadRedPacket()
	else
		self:hideRedPacket()
	end
	if self.dataType == gChatDataType.dataType_king_of_glorydataType_king_of_glor then
		self:loadKingOfGlory()
	else
		self:hideKingOfGlory()
	end
	if self.dataType == gChatDataType.dataType_hero_prison_share then
		self:loadJailHero()
	else
		self:hideJailHero()
	end
	if self.dataType == gChatDataType.dataType_audio then
		self:loadAudio()
	else
		self:hideAudio()
	end
	if self.dataType == gChatDataType.dataType_groupbuy_good or self.dataType == gChatDataType.dataType_ancient_treasure or self.dataType == gChatDataType.dataType_ancient_treasure_rally then
		self:loadCommonJoin(i18n("common_text_1484"))
	end
	if self.dataType == gChatDataType.dataType_lengendWar or self.dataType == gChatDataType.dataType_hegemonWar or self.dataType == gChatDataType.dataType_starking then
		self:loadCommonJoin(i18n("common_text_477"))
	end
	if self.dataType == gChatDataType.dataType_allianceTreasure then
		self:loadAllianceTreasure()
	else
		self:hideAllianceTreasure()
	end
	if self.dataType == gChatDataType.dataType_open_escort_buff_alliance then
		self:loadCommonJoin(i18n("common_text_477"))
	end
	if self.dataType == gChatDataType.dataType_remains_war_team_invite then
		self:loadCommonJoin(i18n("remains_btn_05"))
	end
	if self.dataType == gChatDataType.dataType_remains_war_share_settle_info or self.dataType == gChatDataType.dataType_remains_war_share_season_info then
		self:loadCommonJoin(i18n("common_text_829"))
	end
	if self.dataType == gChatDataType.dataType_alliance_beast_rally or self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_alliance_beast_trial then
		self:loadCommonJoin(i18n("common_text_477"))
	end
	if self.dataType == gChatDataType.ancient_treasure_build_rally then
		self:loadCommonJoin(i18n("common_text_477"))
	end
	if self.dataType == gChatDataType.dataType_alliance_counter_sys or self.dataType == gChatDataType.dataType_alliance_own_counter_sys then
		self:loadCommonJoin(i18n("common_text_477"))
	end
	if self.isSendToAll and self.isSendToAll == 1 then
		self:loadSendToAll()
	else
		self:hideSendToAll()
	end
	if self.dataType == gChatDataType.dataType_devil_valley_team then
		self:loadCommonJoin(i18n("common_text_1484"))
	end
	if self.dataType == gChatDataType.dataType_eliminateGame_share then
		self:loadEliminateGameShare()
	else
		self:hideEliminateGameShare()
	end
	if self.dataType == gChatDataType.dataType_starsWishGame_share then
		self:loadStarsWishGameShare()
	else
		self:hideStarsWishGameShare()
	end
	self.textChat:setString(data.content)
	if data.labelSize and data.labelSize.width ~= 0 and data.labelSize.height ~= 0 then
		self.textChat:ignoreContentAdaptWithSize(false)
		self.textChat:setTextAreaSize(data.labelSize)
	else
		self.textChat:ignoreContentAdaptWithSize(true)
		self.textChat:setTextAreaSize(cc.size(0, 0))
		if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
			self.label_share_1:ignoreContentAdaptWithSize(true)
			self.label_share_1:setTextAreaSize(cc.size(0, 0))
		end
	end
	local isNeedBgFlipX = false
	local isSelf = chatFunctions.getIsPlayerSelf(self.playerId)
	local fileBgName = ""
	local isShowKing = false
	local isShowLegendKing = false
	local isShowLegendForSepKing = false
	local isShowHegemon = false
	if self.isKNotice == true then
		if self.align == 0 then
			fileBgName = CV.fileKnoticeBgL
		else
			fileBgName = CV.fileKnoticeBgR
		end
		isShowKing = false
		isShowLegendKing = false
		isShowLegendForSepKing = false
		isShowHegemon = false
	elseif self.isSys == true then
		if self.align == 0 then
			fileBgName = CV.fileSysBgL
		else
			fileBgName = CV.fileSysBgR
		end
		isShowKing = false
		isShowLegendKing = false
		isShowLegendForSepKing = false
		isShowHegemon = false
	elseif self.isKing == true then
		if self.align == 0 then
			fileBgName = CV.fileKingL
		else
			fileBgName = CV.fileKingR
		end
		isShowKing = true
	elseif self.isHegemon == true then
		if self.align == 0 then
			fileBgName = CV.fileHegemonL
			CV.capInsetsHegemon = CV.capInsetsHegemonL
		else
			fileBgName = CV.fileHegemonR
			CV.capInsetsHegemon = CV.capInsetsHegemonR
		end
		isShowHegemon = true
	elseif self.isLegendKing == true then
		if self.align == 0 then
			fileBgName = CV.fileLegendKingL
			CV.capInsetsLegendKing = CV.capInsetsLegendKingL
		else
			fileBgName = CV.fileLegendKingR
			CV.capInsetsLegendKing = CV.capInsetsLegendKingR
		end
		isShowLegendKing = true
	elseif self.isLegendForSepKing == true then
		if self.align == 0 then
			fileBgName = CV.fileLegendKingL
			CV.capInsetsLegendKing = CV.capInsetsLegendKingL
		else
			fileBgName = CV.fileLegendKingR
			CV.capInsetsLegendKing = CV.capInsetsLegendKingR
		end
		isShowLegendForSepKing = true
	elseif isSelf then
		fileBgName = CV.fileChatSelfBgL
		if self.align == 0 then
			fileBgName = CV.fileChatSelfBgL
		else
			fileBgName = CV.fileChatSelfBgR
		end
	else
		fileBgName = CV.fileChatOtherBgR
		if self.align == 0 then
			fileBgName = CV.fileChatOtherBgL
		else
			isNeedBgFlipX = false
			fileBgName = CV.fileChatOtherBgR
		end
	end
	if self.dataType == gChatDataType.dataType_red_packet then
		if self.align == 0 then
			fileBgName = CV.fileRedPacketL
			isNeedBgFlipX = true
		else
			fileBgName = CV.fileRedPacketR
		end
		isShowKing = false
		isShowLegendKing = false
		isShowHegemon = false
		isShowLegendForSepKing = false
	end
	if self.textInfo then
		self.textInfo:setString(info)
	end
	local textInfoWidth = self.textInfo:getContentSize().width
	self.imgBg:loadTexture(fileBgName, ccui.TextureResType.plistType)
	if isSys == true then
		local autoRenderSize = self.textChat:getContentSize()
		local minTextWidth = CV.minWidthBg - CV.sizeSysImg.width - CV.deltaBgSide - CV.deltaWSysBgArrow - CV.deltaWPaddingTextSys
		local maxTextWidth = CV.maxWidthBg - CV.sizeSysImg.width - CV.deltaBgSide - CV.deltaWSysBgArrow - CV.deltaWPaddingTextSys
		local textLimitWidth = autoRenderSize.width
		textLimitWidth = math.max(textInfoWidth, textLimitWidth)
		local autoRenderEquipSize = cc.size(0, 0)
		if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
			autoRenderEquipSize = self.label_share_1:getContentSize()
			textLimitWidth = math.max(textLimitWidth, autoRenderEquipSize.width + 25 + 30)
		end
		local autoRenderShareSize = cc.size(0, 0)
		if self.dataType == gChatDataType.dataType_pyramid_share or self.dataType == gChatDataType.dataType_rally or self.dataType == gChatDataType.dataType_eliminateGame_share or self.dataType == gChatDataType.dataType_starsWishGame_share or self.dataType == gChatDataType.dataType_groupbuy_good or self.dataType == gChatDataType.dataType_pet or self.dataType == gChatDataType.dataType_hero_share or self.dataType == gChatDataType.dataType_lengendWar or self.dataType == gChatDataType.dataType_starking or self.dataType == gChatDataType.dataType_allianceTreasure or self.dataType == gChatDataType.dataType_open_escort_buff_alliance or self.dataType == gChatDataType.dataType_hegemonWar or self.dataType == gChatDataType.dataType_alliance_beast_rally or self.dataType == gChatDataType.dataType_remains_war_team_invite or self.dataType == gChatDataType.dataType_remains_war_share_settle_info or self.dataType == gChatDataType.dataType_remains_war_share_season_info or self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_alliance_beast_trial or self.dataType == gChatDataType.dataType_ancient_treasure_rally or self.dataType == gChatDataType.dataType_ancient_treasure or self.dataType == gChatDataType.dataType_devil_valley_team or self.dataType == gChatDataType.dataType_king_of_glory or self.dataType == gChatDataType.dataType_hero_prison_share then
			autoRenderShareSize = self.label_share_1:getContentSize()
			textLimitWidth = math.max(textLimitWidth, autoRenderShareSize.width)
		end
		if minTextWidth > textLimitWidth then
			textLimitWidth = minTextWidth
		elseif maxTextWidth < textLimitWidth then
			textLimitWidth = maxTextWidth
		end
		self.spriteSys:setVisible(true)
		local autoHeight = self.textChat:getContentSize().height
		if maxTextWidth < autoRenderSize.width then
			autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
		elseif autoRenderSize.width == 0 then
			textLimitWidth = maxTextWidth
			autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
		end
		local autoEquipHeight = 0
		if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
			autoEquipHeight = self.label_share_1:getContentSize().height
			if maxTextWidth < autoRenderEquipSize.width then
				autoEquipHeight = SoraDGetAutoHeightLabel(self.label_share_1, textLimitWidth)
			end
		end
		local autoShareHeight = 0
		if self.dataType == gChatDataType.dataType_pyramid_share or self.dataType == gChatDataType.dataType_allianceTreasure or self.dataType == gChatDataType.dataType_king_of_glorydataType_king_of_glor or self.dataType == gChatDataType.dataType_hero_prison_share then
			autoShareHeight = self.label_share_1:getContentSize().height
			if maxTextWidth < autoRenderShareSize.width then
				autoShareHeight = SoraDGetAutoHeightLabel(self.label_share_1, textLimitWidth)
			end
		elseif self.dataType == gChatDataType.dataType_rally or self.dataType == gChatDataType.dataType_eliminateGame_share or self.dataType == gChatDataType.dataType_starsWishGame_share or self.dataType == gChatDataType.dataType_groupbuy_good or self.dataType == gChatDataType.dataType_pet or self.dataType == gChatDataType.dataType_hero_share or self.dataType == gChatDataType.dataType_lengendWar or self.dataType == gChatDataType.dataType_starking or self.dataType == gChatDataType.dataType_hegemonWar or self.dataType == gChatDataType.dataType_open_escort_buff_alliance or self.dataType == gChatDataType.dataType_alliance_beast_rally or self.dataType == gChatDataType.dataType_remains_war_team_invite or self.dataType == gChatDataType.dataType_remains_war_share_settle_info or self.dataType == gChatDataType.dataType_remains_war_share_season_info or self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_ancient_treasure or self.dataType == gChatDataType.dataType_ancient_treasure_rally or self.dataType == gChatDataType.dataType_alliance_beast_trial then
			autoShareHeight = self.label_share_1:getContentSize().height
			if maxTextWidth < autoRenderShareSize.width then
				autoShareHeight = SoraDGetAutoHeightLabel(self.label_share_1, textLimitWidth)
			end
		end
		local accumulateHeight = CV.deltaHTopText + autoHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomText + autoEquipHeight + autoShareHeight
		local accumulateWidth = CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys + textLimitWidth + CV.deltaBgSide
		self.itemWidth = accumulateWidth
		self.itemHeight = accumulateHeight
		self.imgBg:setContentSize(cc.size(accumulateWidth, accumulateHeight))
		if align == 0 then
			local spriteSysSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWSysBgArrow
			self.spriteSys:setAnchorPoint(SoraDFAP(1, 1))
			self.spriteSys:setPosition(SoraDFPoint(accumulateWidth - spriteSysSide, accumulateHeight - CV.deltaHTopSys, accumulateWidth))
			if self.dataType == gChatDataType.dataType_fightReport then
				local btnMailReportSide = SoraDFIsRA() and CV.deltaBgReportSide or CV.deltaWReportBgArrow
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - btnMailReportSide, accumulateHeight - CV.deltaHTopMailReport, accumulateWidth))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 1))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnMailReportSide, accumulateHeight - CV.deltaHTopMailReport, accumulateWidth))
			end
			local textChatSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
			self.textChat:setAnchorPoint(SoraDFAP(1, 1))
			self.textChat:setPosition(SoraDFPoint(accumulateWidth - textChatSide, accumulateHeight - CV.deltaHTopText, accumulateWidth))
			if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
				local textEquipSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight - 6, accumulateWidth))
				local imgEquipSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys + autoRenderEquipSize.width + 36 or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys + autoRenderEquipSize.width + 36
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - imgEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight - 2, accumulateWidth))
				local btnEquipSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderEquipSize.width + 30 + 25, autoRenderEquipSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			end
			if self.dataType == gChatDataType.dataType_pyramid_share or self.dataType == gChatDataType.dataType_allianceTreasure or self.dataType == gChatDataType.dataType_king_of_glory then
				local textPyramidSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textPyramidSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
				local btnPyramidSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderShareSize.width + 30, autoRenderShareSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnPyramidSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			elseif self.dataType == gChatDataType.dataType_rally or self.dataType == gChatDataType.dataType_eliminateGame_share or self.dataType == gChatDataType.dataType_starsWishGame_share or self.dataType == gChatDataType.dataType_groupbuy_good or self.dataType == gChatDataType.dataType_pet or self.dataType == gChatDataType.dataType_hero_share or self.dataType == gChatDataType.dataType_lengendWar or self.dataType == gChatDataType.dataType_starking or self.dataType == gChatDataType.dataType_hegemonWar or self.dataType == gChatDataType.dataType_open_escort_buff_alliance or self.dataType == gChatDataType.dataType_alliance_beast_rally or self.dataType == gChatDataType.dataType_remains_war_team_invite or self.dataType == gChatDataType.dataType_remains_war_share_settle_info or self.dataType == gChatDataType.dataType_remains_war_share_season_info or self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_alliance_beast_trial or self.dataType == gChatDataType.dataType_ancient_treasure or self.dataType == gChatDataType.dataType_ancient_treasure_rally or self.dataType == gChatDataType.dataType_devil_valley_team or self.dataType == gChatDataType.dataType_hero_prison_share then
				local textSahreSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textSahreSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
				local btnTouchSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderShareSize.width + 30, autoRenderShareSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnTouchSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			end
			local textInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
			self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
			self.textInfo:setPosition(SoraDFPoint(textInfoSide, CV.deltaHBottomText, accumulateWidth))
			self.imgBg:setPositionX(accumulateWidth / 2 + (isShowKing and CV.deltaKingSide or 0))
			self.imgBg:setPositionX(accumulateWidth / 2 + (isShowLegendKing and CV.deltaLegendKingSide or 0))
			self.imgBg:setPositionX(accumulateWidth / 2 + (isShowLegendForSepKing and CV.deltaLegendKingSide or 0))
			self.imgBg:setPositionX(accumulateWidth / 2 + (isShowHegemon and CV.deltaHegemonSide or 0))
		elseif align == 1 then
			local spriteSysSide = SoraDFIsRA() and CV.deltaWSysBgArrow or CV.deltaBgSide
			self.spriteSys:setAnchorPoint(SoraDFAP(1, 1))
			self.spriteSys:setPosition(SoraDFPoint(accumulateWidth - spriteSysSide, accumulateHeight - CV.deltaHTopSys, accumulateWidth))
			if self.dataType == gChatDataType.dataType_fightReport then
				local btnMailReportSide = SoraDFIsRA() and CV.deltaWReportBgArrow or CV.deltaBgReportSide
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 1))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnMailReportSide, accumulateHeight - CV.deltaHTopMailReport, accumulateWidth))
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - btnMailReportSide, accumulateHeight - CV.deltaHTopMailReport, accumulateWidth))
			end
			local textChatSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
			self.textChat:setAnchorPoint(SoraDFAP(1, 1))
			self.textChat:setPosition(SoraDFPoint(accumulateWidth - textChatSide, accumulateHeight - CV.deltaHTopText, accumulateWidth))
			if self.dataType == gChatDataType.dataType_equip_create or self.dataType == gChatDataType.dataType_equip_share then
				local textEquipSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight - 6, accumulateWidth))
				local imgEquipSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys + autoRenderEquipSize.width + 36 or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys + autoRenderEquipSize.width + 36
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:ignoreContentAdaptWithSize(false)
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - imgEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight - 2, accumulateWidth))
				local btnEquipSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderEquipSize.width + 30 + 25, autoRenderEquipSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnEquipSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			end
			if self.dataType == gChatDataType.dataType_pyramid_share or self.dataType == gChatDataType.dataType_allianceTreasure or self.dataType == gChatDataType.dataType_king_of_glory then
				local textPyramidSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textPyramidSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
				local btnPyramidSide = SoraDFIsRA() and CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderShareSize.width + 30, autoRenderShareSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnPyramidSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			elseif self.dataType == gChatDataType.dataType_rally or self.dataType == gChatDataType.dataType_eliminateGame_share or self.dataType == gChatDataType.dataType_starsWishGame_share or self.dataType == gChatDataType.dataType_groupbuy_good or self.dataType == gChatDataType.dataType_pet or self.dataType == gChatDataType.dataType_hero_share or self.dataType == gChatDataType.dataType_lengendWar or self.dataType == gChatDataType.dataType_starking or self.dataType == gChatDataType.dataType_hegemonWar or self.dataType == gChatDataType.dataType_open_escort_buff_alliance or self.dataType == gChatDataType.dataType_alliance_beast_rally or self.dataType == gChatDataType.dataType_remains_war_team_invite or self.dataType == gChatDataType.dataType_remains_war_share_settle_info or self.dataType == gChatDataType.dataType_remains_war_share_season_info or self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_alliance_beast_trial or self.dataType == gChatDataType.dataType_ancient_treasure or self.dataType == gChatDataType.dataType_ancient_treasure_rally or self.dataType == gChatDataType.dataType_devil_valley_team or self.dataType == gChatDataType.dataType_hero_prison_share then
				local textSahreSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textSahreSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
				local btnTouchSide = SoraDFIsRA() and CV.deltaBgSide + CV.sizeSysImg.width + CV.deltaWPaddingTextSys or CV.deltaWSysBgArrow + CV.sizeSysImg.width + CV.deltaWPaddingTextSys
				self.btnTouch:setContentSize(cc.size(autoRenderShareSize.width + 30, autoRenderShareSize.height * 2))
				self.btnTouch:setAnchorPoint(SoraDFAP(1, 0.5))
				self.btnTouch:setPosition(SoraDFPoint(accumulateWidth - btnTouchSide, accumulateHeight - CV.deltaHTopText - autoHeight, accumulateWidth))
			end
			local textInfoSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
			self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
			self.textInfo:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
			self.textInfo:setPosition(SoraDFPoint(textInfoSide, CV.deltaHBottomText, accumulateWidth))
			self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowLegendKing or isShowLegendForSepKing or isShowKing or isShowHegemon) and -CV.deltaKingSide or 0))
		end
	else
		local autoRenderSize = self.textChat:getContentSize()
		local minTextWidth = CV.minWidthBg - CV.deltaBgSide - CV.deltaWTextBgArrow
		local maxTextWidth = CV.maxWidthBg - CV.deltaBgSide - CV.deltaWTextBgArrow
		if isShowLegendKing == true then
			minTextWidth = CV.minWidthBg - CV.deltaBgSideLK - CV.deltaWTextBgArrowLK
			maxTextWidth = CV.maxWidthBg - CV.deltaBgSideLK - CV.deltaWTextBgArrowLK
		elseif isShowLegendForSepKing == true then
			minTextWidth = CV.minWidthBg - CV.deltaBgSideLK - CV.deltaWTextBgArrowLK
			maxTextWidth = CV.maxWidthBg - CV.deltaBgSideLK - CV.deltaWTextBgArrowLK
		elseif isShowHegemon == true then
			minTextWidth = CV.minWidthBg - CV.deltaBgSideHK - CV.deltaWTextBgArrowHK
			maxTextWidth = CV.maxWidthBg - CV.deltaBgSideHK - CV.deltaWTextBgArrowHK
		end
		local textLimitWidth = autoRenderSize.width
		textLimitWidth = math.max(textInfoWidth, textLimitWidth)
		local autoRenderShareSize = cc.size(0, 0)
		if self.isSendToAll == 1 then
			autoRenderShareSize = self.label_share_1:getContentSize()
			textLimitWidth = math.max(textLimitWidth, autoRenderShareSize.width)
		end
		if minTextWidth > textLimitWidth then
			textLimitWidth = minTextWidth
		elseif maxTextWidth < textLimitWidth then
			textLimitWidth = maxTextWidth
		end
		self.spriteSys:setVisible(false)
		local autoHeight = self.textChat:getContentSize().height
		local autoRPHeight = CV.sizeImgRedPacket.height
		local autoRPWidth = CV.sizeImgRedPacket.width
		local accumulateHeight = 0
		local accumulateWidth = 0
		if self.dataType == gChatDataType.dataType_red_packet then
			minTextWidth = CV.widthTextRP - (CV.deltaWRPBgArrow + CV.deltaWPaddingTextRP + CV.sizeImgRedPacket.width + CV.deltaBgSide)
			maxTextWidth = CV.maxWidthBg - (CV.deltaWRPBgArrow + CV.deltaWPaddingTextRP + CV.sizeImgRedPacket.width + CV.deltaBgSide)
			if textLimitWidth < minTextWidth then
				textLimitWidth = minTextWidth
			elseif maxTextWidth < textLimitWidth then
				textLimitWidth = maxTextWidth
			end
			if maxTextWidth < autoRenderSize.width then
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			elseif autoRenderSize.width == 0 then
				textLimitWidth = maxTextWidth
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			end
			autoRPHeight = math.max(CV.sizeImgRedPacket.height, autoHeight)
			accumulateHeight = CV.deltaHTopText + autoRPHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfoRP + CV.deltaHBottomText
			accumulateWidth = CV.deltaWRPBgArrow + CV.sizeImgRedPacket.width + CV.deltaWPaddingTextRP + textLimitWidth + CV.deltaBgSide
			local textBottomWidth = self.label_share_1:getContentSize().width + 20 + self.textInfo:getContentSize().width + CV.deltaWRPBgArrow + CV.deltaBgSide
			accumulateWidth = math.max(accumulateWidth, textBottomWidth)
		elseif self.dataType == gChatDataType.dataType_audio then
			local autoAudioHeight = 32
			local audioLen
			if self.customData then
				audioLen = self.customData.audioLen
			end
			audioLen = audioLen or tonumber(self.content)
			if audioLen then
				local percent = audioLen / 59
				percent = math.max(0, math.min(1, percent))
				local addWidth = (maxTextWidth - minTextWidth) * percent
				addWidth = math.floor(addWidth)
				textLimitWidth = textLimitWidth + addWidth
			end
			if maxTextWidth < autoRenderSize.width then
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			elseif autoRenderSize.width == 0 then
				textLimitWidth = maxTextWidth
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			end
			autoAudioHeight = math.max(CV.sizeImgAudio.height, autoHeight)
			if isShowLegendKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoAudioHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowLegendForSepKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoAudioHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowHegemon == true then
				accumulateHeight = CV.deltaHTopTextHK + autoAudioHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextHK
				accumulateWidth = CV.deltaWTextBgArrowHK + textLimitWidth + CV.deltaBgSideHK
			else
				accumulateHeight = CV.deltaHTopText + autoAudioHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomText
				accumulateWidth = CV.deltaWTextBgArrow + textLimitWidth + CV.deltaBgSide
			end
		elseif self.isSendToAll == 1 then
			if maxTextWidth < autoRenderSize.width then
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			elseif autoRenderSize.width == 0 then
				textLimitWidth = maxTextWidth
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			end
			local autoShareHeight = 0
			autoShareHeight = self.label_share_1:getContentSize().height
			if maxTextWidth < autoRenderShareSize.width then
				autoShareHeight = SoraDGetAutoHeightLabel(self.label_share_1, textLimitWidth)
			end
			if isShowLegendKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoHeight + autoShareHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowLegendForSepKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoHeight + autoShareHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowHegemon == true then
				accumulateHeight = CV.deltaHTopTextHK + autoHeight + autoShareHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextHK
				accumulateWidth = CV.deltaWTextBgArrowHK + textLimitWidth + CV.deltaBgSideHK
			else
				accumulateHeight = CV.deltaHTopText + autoHeight + autoShareHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomText
				accumulateWidth = CV.deltaWTextBgArrow + textLimitWidth + CV.deltaBgSide
			end
			local textBottomWidth = self.label_share_1:getContentSize().width + 20 + CV.deltaWTextBgArrow + CV.deltaBgSide
			accumulateWidth = math.max(accumulateWidth, textBottomWidth)
		else
			if maxTextWidth < autoRenderSize.width then
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			elseif autoRenderSize.width == 0 then
				textLimitWidth = maxTextWidth
				autoHeight = SoraDGetAutoHeightLabel(self.textChat, textLimitWidth)
			end
			if isShowLegendKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowLegendForSepKing == true then
				accumulateHeight = CV.deltaHTopTextLK + autoHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextLK
				accumulateWidth = CV.deltaWTextBgArrowLK + textLimitWidth + CV.deltaBgSideLK
			elseif isShowHegemon == true then
				accumulateHeight = CV.deltaHTopTextHK + autoHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomTextHK
				accumulateWidth = CV.deltaWTextBgArrowHK + textLimitWidth + CV.deltaBgSideHK
			else
				accumulateHeight = CV.deltaHTopText + autoHeight + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo + CV.deltaHBottomText
				accumulateWidth = CV.deltaWTextBgArrow + textLimitWidth + CV.deltaBgSide
			end
		end
		if isShowKing then
			accumulateHeight = math.max(75, accumulateHeight)
		end
		if isShowLegendKing == true then
			accumulateHeight = math.max(CV.minHbgLK, accumulateHeight)
		elseif isShowLegendForSepKing == true then
			accumulateHeight = math.max(CV.minHbgLK, accumulateHeight)
		elseif isShowHegemon == true then
			accumulateHeight = math.max(CV.minHbgHK, accumulateHeight)
		end
		if align == 0 then
			if self.dataType == gChatDataType.dataType_red_packet then
				local deltaRPSide = SoraDFIsRA() and CV.deltaRPBgSide or CV.deltaWRPBgArrow
				self.imgIcon:ignoreAnchorPointForPosition(false)
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - deltaRPSide, accumulateHeight - CV.deltaHTopRp, accumulateWidth))
				local deltaChatSide = SoraDFIsRA() and CV.deltaRPBgSide + CV.sizeImgRedPacket.width + CV.deltaWPaddingTextRP or CV.deltaWRPBgArrow + CV.sizeImgRedPacket.width + CV.deltaWPaddingTextRP
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - (CV.deltaHTopText / 2 + (autoRPHeight - autoHeight) / 2), accumulateWidth))
				local deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, CV.deltaHBottomText, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and CV.deltaKingSide or 0))
				if self.img_share_1 then
					self.img_share_1:setAnchorPoint(cc.p(0, 0))
					self.img_share_1:setPosition(cc.p(22, 8))
					self.img_share_1:setContentSize(cc.size(accumulateWidth - 28, CV.deltaHBottomText + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo))
					self.img_share_1:setLocalZOrder(1)
					self.textInfo:setLocalZOrder(2)
					self.textInfo:setTextColor(cc.c3b(0, 0, 0))
				end
				if self.label_share_1 then
					self.label_share_1:setAnchorPoint(SoraDFAP(1, 0))
					local deltaInfoViewSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
					self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - deltaInfoViewSide, CV.deltaHBottomText, accumulateWidth))
					self.label_share_1:setLocalZOrder(2)
				end
			elseif self.dataType == gChatDataType.dataType_audio then
				local deltaChatSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, CV.deltaHBottomText, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and CV.deltaKingSide or 0))
				if self.spriteAudio then
					local deltaAudioSide = SoraDFIsRA() and deltaChatSide or deltaInfoSide
					self.spriteAudio:setAnchorPoint(SoraDFAP(0.5, 1))
					self.spriteAudio:setPosition(SoraDFPoint(deltaAudioSide + CV.sizeImgAudio.width / 2, accumulateHeight - deltaHTop, accumulateWidth))
					self.spriteAudio:setScaleX(-1)
				end
				if self.btnTouch then
					self.btnTouch:setAnchorPoint(SoraDFAP(0.5, 1))
					self.btnTouch:setPosition(cc.p(self.spriteAudio:getPosition()))
				end
			elseif self.isSendToAll == 1 then
				local deltaChatSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, deltaHBottom, accumulateWidth))
				local textSahreSide = deltaChatSide
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textSahreSide, accumulateHeight - deltaHTop - autoHeight, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and CV.deltaKingSide or 0))
			else
				local deltaChatSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, deltaHBottom, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and CV.deltaKingSide or 0))
			end
		elseif align == 1 then
			if self.dataType == gChatDataType.dataType_red_packet then
				local deltaRPSide = SoraDFIsRA() and CV.deltaWRPBgArrow or CV.deltaRPBgSide
				self.imgIcon:ignoreAnchorPointForPosition(false)
				self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
				self.imgIcon:setPosition(SoraDFPoint(accumulateWidth - deltaRPSide, accumulateHeight - CV.deltaHTopRp, accumulateWidth))
				local deltaChatSide = SoraDFIsRA() and CV.deltaWRPBgArrow + CV.sizeImgRedPacket.width + CV.deltaWPaddingTextRP or CV.deltaRPBgSide + CV.sizeImgRedPacket.width + CV.deltaWPaddingTextRP
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - (CV.deltaHTopText / 2 + (autoRPHeight - autoHeight) / 2), accumulateWidth))
				local deltaInfoSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, CV.deltaHBottomText, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2)
				if self.img_share_1 then
					self.img_share_1:setAnchorPoint(cc.p(0, 0))
					self.img_share_1:setPosition(cc.p(4, 8))
					self.img_share_1:setContentSize(cc.size(accumulateWidth - 28, CV.deltaHBottomText + self.textInfo:getContentSize().height + CV.deltaHPaddingInfo))
					self.img_share_1:setLocalZOrder(1)
					self.textInfo:setLocalZOrder(2)
					self.textInfo:setTextColor(cc.c3b(0, 0, 0))
				end
				if self.label_share_1 then
					self.label_share_1:setAnchorPoint(SoraDFAP(1, 0))
					local deltaInfoViewSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
					self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - deltaInfoViewSide, CV.deltaHBottomText, accumulateWidth))
					self.label_share_1:setLocalZOrder(2)
				end
			elseif self.dataType == gChatDataType.dataType_audio then
				local deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaInfoSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, deltaHBottom, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and -CV.deltaKingSide or 0))
				if self.spriteAudio then
					local deltaAudioSide = SoraDFIsRA() and deltaChatSide or deltaInfoSide
					self.spriteAudio:setAnchorPoint(SoraDFAP(0.5, 1))
					self.spriteAudio:setPosition(SoraDFPoint(deltaAudioSide + CV.sizeImgAudio.width / 2, accumulateHeight - deltaHTop, accumulateWidth))
					self.spriteAudio:setScaleX(1)
				end
				if self.btnTouch then
					self.btnTouch:setAnchorPoint(SoraDFAP(0.5, 1))
					self.btnTouch:setPosition(cc.p(self.spriteAudio:getPosition()))
				end
			elseif self.isSendToAll == 1 then
				local deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaInfoSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, deltaHBottom, accumulateWidth))
				local textSahreSide = deltaChatSide
				self.label_share_1:setAnchorPoint(SoraDFAP(1, 1))
				self.label_share_1:setPosition(SoraDFPoint(accumulateWidth - textSahreSide, accumulateHeight - deltaHTop - autoHeight, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and -CV.deltaKingSide or 0))
			else
				local deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrow or CV.deltaBgSide
				local deltaInfoSide = SoraDFIsRA() and CV.deltaBgSide or CV.deltaWTextBgArrow
				local deltaHTop = CV.deltaHTopText
				local deltaHBottom = CV.deltaHBottomText
				if isShowLegendKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowLegendForSepKing == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowLK or CV.deltaBgSideLK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideLK or CV.deltaWTextBgArrowLK
					deltaHTop = CV.deltaHTopTextLK
					deltaHBottom = CV.deltaHBottomTextLK
					self.textChat:setTextColor(CV.colorTextLK)
					self.textInfo:setTextColor(CV.colorTextInfoLK)
				elseif isShowHegemon == true then
					deltaChatSide = SoraDFIsRA() and CV.deltaWTextBgArrowHK or CV.deltaBgSideHK
					deltaInfoSide = SoraDFIsRA() and CV.deltaBgSideHK or CV.deltaWTextBgArrowHK
					deltaHTop = CV.deltaHTopTextHK
					deltaHBottom = CV.deltaHBottomTextHK
					self.textChat:setTextColor(CV.colorTextHK)
					self.textInfo:setTextColor(CV.colorTextInfoHK)
				end
				self.textChat:setAnchorPoint(SoraDFAP(1, 1))
				self.textChat:setPosition(SoraDFPoint(accumulateWidth - deltaChatSide, accumulateHeight - deltaHTop, accumulateWidth))
				self.textInfo:setAnchorPoint(SoraDFAP(0, 0))
				self.textInfo:setPosition(SoraDFPoint(deltaInfoSide, deltaHBottom, accumulateWidth))
				self.imgBg:setPositionX(accumulateWidth / 2 + ((isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon) and -CV.deltaKingSide or 0))
			end
		end
		self.itemWidth = accumulateWidth
		self.itemHeight = accumulateHeight
		self.imgBg:setContentSize(cc.size(accumulateWidth, accumulateHeight))
	end
	self.imgBg:setFlippedX(isNeedBgFlipX)
	if isShowKing or isShowLegendKing or isShowLegendForSepKing or isShowHegemon then
		if isShowLegendKing then
			self.imgBg:setCapInsets(CV.capInsetsLegendKing)
			self:showLegendKingCap(align)
			self.imgBg:setContentSize(cc.size(self.itemWidth, self.itemHeight + 5))
		elseif isShowLegendForSepKing then
			self.imgBg:setCapInsets(CV.capInsetsLegendKing)
			self:showLegendKingCap(align)
			self.imgBg:setContentSize(cc.size(self.itemWidth, self.itemHeight + 5))
		elseif isShowHegemon then
			self.imgBg:setCapInsets(CV.capInsetsHegemon)
			self:showHegemonCap(align)
			self.imgBg:setContentSize(cc.size(self.itemWidth, self.itemHeight + 5))
		elseif isShowKing then
			self.imgBg:setCapInsets(CV.capInsetsKing)
			self:showKingCap(align)
			self.imgBg:setContentSize(cc.size(self.itemWidth, self.itemHeight + 5))
		end
	else
		self.imgBg:setCapInsets(CV.capInsets)
	end
end
function playerChatContent:getLabelSize()
	return self.textChat:getTextAreaSize()
end
function playerChatContent:getItemWidth()
	return self.itemWidth
end
function playerChatContent:getItemHeight()
	return self.itemHeight
end
function playerChatContent:loadMailReport()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:loadTexture("icon_mail_report.png", ccui.TextureResType.plistType)
	self.imgIcon:ignoreContentAdaptWithSize(true)
	self.imgIcon:setPosition(cc.p(0, 0))
	self.btnTouch:setContentSize(cc.size(CV.sizeImgMailReport.width + 20, CV.sizeImgMailReport.height + 20))
	self.btnTouch:setPosition(cc.p(0, 0))
	self.btnTouch:addTouchEventListener(handler(self, self.btnMailReportCallBack))
end
function playerChatContent:hideMailReport()
end
function playerChatContent:loadEquipInfo()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:loadTexture("icon_chat_equip.png", ccui.TextureResType.plistType)
	self.imgIcon:ignoreContentAdaptWithSize(true)
	self.imgIcon:setPosition(cc.p(0, 0))
	self.btnTouch:setContentSize(cc.size(CV.sizeImgEquip.width + 20, CV.sizeImgEquip.height + 20))
	self.btnTouch:setPosition(cc.p(0, 0))
	self.btnTouch:setAnchorPoint(SoraDFAP(1, 1))
	self.btnTouch:addTouchEventListener(handler(self, self.btnEquipCallBack))
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(SoraDFLabelR())
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(255, 255, 255))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(SoraDFAP(0, 1))
		self.label_share_1:addTo(self)
	end
	self.label_share_1:setPosition(cc.p(0, 0))
	local customData = self.customData
	local equipDesRead = include("equipDesRead")
	local eid = customData.eid
	local quality = customData.qly
	local equipName = equipDesRead.getName(eid)
	local color = equipDesRead.getAttrColor(quality)
	self.equipName = equipName
	self.equpColor = color
	self.label_share_1:setString(self.equipName)
	self.label_share_1:setColor(self.equpColor)
end
function playerChatContent:hideEquipInfo()
end
function playerChatContent:loadPyramidShare()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnParticipate))
	end
	self.label_share_1:setString(i18n("common_text_1484"))
end
function playerChatContent:hidePyramidShare()
end
function playerChatContent:loadEliminateGameShare()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.onEliminateGameParticipate))
	end
	self.label_share_1:setString(i18n("common_text_1484"))
end
function playerChatContent:hideEliminateGameShare()
end
function playerChatContent:loadStarsWishGameShare()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.onEliminateGameParticipate))
	end
	self.label_share_1:setString(i18n("common_text_1484"))
end
function playerChatContent:hideStarsWishGameShare()
end
function playerChatContent:onEliminateGameParticipate(target, event)
	if event == ccui.TouchEventType.ended then
	end
end
function playerChatContent:loadRally()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnRally))
	end
	self.label_share_1:setString(i18n("common_text_477"))
end
function playerChatContent:hideRally()
end
function playerChatContent:loadPet()
	print("显示宠物---------")
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnPet))
	end
	if self.customData and self.customData.values and self.customData.values.petid then
		local petDesRead = include("petDesRead")
		local petName = petDesRead.getName(self.customData.values.petid)
		self.label_share_1:setString(petName)
	end
end
function playerChatContent:hidePet()
end
function playerChatContent:loadArms()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(255, 190, 60))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnArms))
	end
	if self.customData and self.customData.values and self.customData.values.armsID then
		self.label_share_1:setString(include("equipDesRead").getArtifactName(self.customData.values.armsID))
	end
end
function playerChatContent:hideArms()
end
function playerChatContent:loadHero()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnHero))
	end
	if self.customData and self.customData.values and self.customData.values.heroID then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroExInfo = heroltCtrl.getHeroInfo(self.customData.values.heroID)
		self.label_share_1:setString(i18n(heroExInfo.herName))
	end
end
function playerChatContent:hideHero()
end
function playerChatContent:loadJailHero()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnHero))
	end
	if self.customData and self.customData.values and self.customData.values.heroID then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroExInfo = heroltCtrl.getHeroInfo(self.customData.values.heroID)
		self.label_share_1:setString(i18n(heroExInfo.herName))
	end
end
function playerChatContent:hideJailHero()
end
function playerChatContent:loadAllianceTreasure()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnCommonJoin))
	end
	self.label_share_1:setString(i18n("common_text_477"))
end
function playerChatContent:hideAllianceTreasure()
end
function playerChatContent:loadRedPacket()
	self:loadImgIconAndBtnTouch()
	self.btnTouch:setVisible(false)
	local isSelfClaimed = false
	if self.customData and self.customData.redPacketInfo then
		local getStatus = self.customData.redPacketInfo.getStatus
		if getStatus == gUserRedEnvelopesStatus.ALREADY_GET then
			isSelfClaimed = true
		end
	end
	if self.imgIcon then
		dump(self.customData.redPacketInfo, "红包内容")
		if self.customData and self.customData.redPacketInfo and self.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.imgIcon:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif self.customData and self.customData.redPacketInfo and self.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.imgIcon:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif self.customData and self.customData.redPacketInfo and self.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.imgIcon:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif self.customData and self.customData.redPacketInfo and self.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.imgIcon:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		else
			self.imgIcon:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.imgIcon:ignoreContentAdaptWithSize(true)
		self.imgIcon:setPosition(cc.p(0, 0))
		self.imgIcon:setVisible(true)
	end
	if self.img_share_1 then
		self.img_share_1:setVisible(true)
		self.img_share_1:loadTexture("frame_redpacket_text_02.png", ccui.TextureResType.plistType)
		self.img_share_1:setScale9Enabled(true)
		self.img_share_1:setCapInsets(cc.rect(10, 10, 50, 16))
	else
		self.img_share_1 = ccui.ImageView:create()
		self.img_share_1:loadTexture("frame_redpacket_text_02.png", ccui.TextureResType.plistType)
		self.img_share_1:setScale9Enabled(true)
		self.img_share_1:setCapInsets(cc.rect(10, 10, 50, 16))
		self.img_share_1:ignoreContentAdaptWithSize(true)
		self.img_share_1:setContentSize(cc.size(22, 22))
		self.img_share_1:ignoreAnchorPointForPosition(false)
		self.img_share_1:addTo(self, 1)
		self.img_share_1:setAnchorPoint(SoraDFAP(1, 1))
	end
	self.img_share_1:setPosition(cc.p(0, 0))
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
		self.label_share_1:setColor(cc.c3b(0, 0, 0))
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(SoraDFLabelR())
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(0, 0, 0))
		self.label_share_1:setPosition(cc.p(0, 0))
		self.label_share_1:setAnchorPoint(SoraDFAP(0, 1))
		self.label_share_1:addTo(self)
	end
	self.label_share_1:setCascadeColorEnabled(false)
	self.label_share_1:setCascadeOpacityEnabled(false)
	self.imgBg:setCascadeColorEnabled(true)
	if isSelfClaimed then
		self.label_share_1:setString(i18n("common_text_1892"))
		self:setCascadeColorEnabled(true)
		self:setColor(cc.c3b(125, 125, 125))
		self:setCascadeOpacityEnabled(true)
		self:setOpacity(155)
		self.label_share_1:setColor(cc.c3b(0, 0, 0))
		self.label_share_1:setOpacity(255)
	else
		self:setColor(cc.c3b(255, 255, 255))
		self.label_share_1:setString(i18n("common_text_1776"))
		self:setOpacity(0)
	end
	self.label_share_1:setPosition(cc.p(0, 0))
end
function playerChatContent:hideRedPacket()
end
function playerChatContent:loadKingOfGlory()
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnKingOfGlory))
	end
	self.label_share_1:setString(i18n("common_text_1484"))
end
function playerChatContent:hideKingOfGlory()
end
function playerChatContent:btnMailReportCallBack(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		dump(self.customData)
		SoraDPlaySound()
		if self.customData.mid then
			local mailFunctions = include("mailFunctions")
			mailFunctions:doRequestMailReport(self.customData.mid, false, self.playerId)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnEquipCallBack(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		_ENV = nil
		;(nil).isOnlyShow = true
		;(nil).singleData = self.customData
		uiManager:show("storageBoxInfoView", nil)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnParticipate(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if not castleBcell then
			return
		end
		local castleLV = castleBcell.info.lv
		if tonumber(castleLV) < CASTLE_LV8_LIMITED then
			local spriteName = "#btn_pyramid.png"
			_ENV = nil
			;(nil).blv = CASTLE_LV8_LIMITED
			SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
		else
			uiManager:show("pyramidMain")
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnRally(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:checkRallyValid()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:checkRemainsWarTeam()
	local remainsWarUtil = include("remainsWarUtil")
	remainsWarUtil.doAllianceInvite(self.customData.values, true)
end
function playerChatContent:checkRallyValid()
	local queueId = self.customData.queueId
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local hasQueue = kingdomMapCtrl.kingdomMapCell:isHasWarHallQueues(queueId)
	if not hasQueue then
		SoraDShowMsgTip(i18n("assembled_text_01"))
		return
	end
	local allianceCtrl = SoraDGetCtrl("allianceCtrl")
	local allianceWarListRallyMgr = allianceCtrl:getAllianceWarListRallyMgr(queueId)
	allianceWarListRallyMgr:onPlusClick()
end
function playerChatContent:btnPet(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local customData = self.customData
		local petDesRead = include("petDesRead")
		local petCfg = petDesRead.getPetCfg(customData.values.petid, customData.values.rank)
		if not petCfg then
			_ENV = nil
			;(nil).des = i18n("common_text_2975")
			SoraDShowMsgTip(i18n("common_text_1437", nil))
			return
		end
		_ENV = i18n("common_text_1437", nil)
		i18n("common_text_1437", nil).petData = customData.values
		uiManager:show("PetShareView", i18n("common_text_1437", nil))
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnArms(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local customData = self.customData
		SoraDShowMsgTip("playerChatContent:btnArms")
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnHero(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local customData = self.customData
		_ENV = nil
		;(nil).heroID = customData.values.heroID
		;(nil).quality = customData.values.quality
		;(nil).level = customData.values.level
		;(nil).dressID = customData.values.dressID
		uiManager:show("HeroIntroduction", nil)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnRedPacket(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("TODO: 馈赠礼袋的点击调用 ")
		local redPacketPanel = SoraDCreatePanel("redPacket")
		redPacketPanel:initWithData()
		redPacketPanel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:btnKingOfGlory(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local castleLV = castleBcell.info.lv
		if tonumber(castleLV) < CASTLE_LV6_LIMITED then
			local spriteName = "#btn_pyramid.png"
			_ENV = nil
			;(nil).blv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY) then
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY, 6)
			return
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:loadImgIconAndBtnTouch()
	if self.imgIcon then
		self.imgIcon:setVisible(true)
	else
		self.imgIcon = ccui.ImageView:create()
		self.imgIcon:loadTexture("icon_chat_equip.png", ccui.TextureResType.plistType)
		self.imgIcon:ignoreContentAdaptWithSize(false)
		self.imgIcon:setContentSize(cc.size(22, 22))
		self.imgIcon:ignoreAnchorPointForPosition(false)
		self.imgIcon:addTo(self, 2)
		self.imgIcon:setAnchorPoint(SoraDFAP(1, 1))
	end
	self.imgIcon:setPosition(cc.p(0, 0))
	if self.btnTouch then
		self.btnTouch:setVisible(true)
	else
		self.btnTouch = ccui.Layout:create()
		self.btnTouch:setOpacity(120)
		self.btnTouch:setSwallowTouches(true)
		self.btnTouch:setTouchEnabled(true)
		self.btnTouch:ignoreContentAdaptWithSize(false)
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:ignoreAnchorPointForPosition(false)
		self.btnTouch:addTo(self, 1)
		self.btnTouch:setAnchorPoint(SoraDFAP(1, 1))
		self.btnTouch:addTouchEventListener(handler(self, self.btnTouchCallBack))
	end
	self.btnTouch:setPosition(cc.p(0, 0))
end
function playerChatContent:hideShareWidgets()
	if self.imgIcon then
		self.imgIcon:setVisible(false)
	end
	if self.btnTouch then
		self.btnTouch:setVisible(false)
	end
	if self.label_share_1 then
		self.label_share_1:setVisible(false)
	end
	if self.img_share_1 then
		self.img_share_1:setVisible(false)
	end
end
function playerChatContent:btnTouchCallBack(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("TODO: function playerChatContent:btnTouchCallBack(target, event)============= ")
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:showKingCap(align)
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
		self.imgKing:setSpriteFrame(CV.fileKingCap)
	else
		self.imgKing = display.newSprite("#" .. CV.fileKingCap)
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(CV.fileKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(-1)
		self.imgKingCorner:setPosition(0, self.itemHeight - CV.deltaKingCornerTop)
	end
	self.imgKing:setScale(0.6)
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	end
end
function playerChatContent:showLegendKingCap(align)
	do return end
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
		self.imgKing:setSpriteFrame(CV.fileLegendKingCap)
	else
		self.imgKing = display.newSprite("#" .. CV.fileLegendKingCap)
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(CV.fileLegendKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(-1)
		self.imgKingCorner:setPosition(0, self.itemHeight - CV.deltaKingCornerTop)
	end
	self.imgKing:setScale(0.36)
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	end
end
function playerChatContent:showHegemonCap(align)
	do return end
	if self.imgKing ~= nil then
		self.imgKing:setVisible(true)
		self.imgKing:setSpriteFrame(CV.fileLegendKingCap)
	else
		self.imgKing = display.newSprite("#" .. CV.fileLegendKingCap)
		self.imgKing:ignoreAnchorPointForPosition(false)
		self.imgKing:setAnchorPoint(SoraDFAP(0.5, 0))
		self.imgKing:setPosition(SoraDFPoint(self.itemWidth, 93, self.itemWidth))
		self.imgKing:addTo(self)
	end
	if self.imgKingCorner ~= nil then
		self.imgKingCorner:setVisible(true)
	else
		self.imgKingCorner = ccui.ImageView:create(CV.fileLegendKingCorner, ccui.TextureResType.plistType)
		self.imgKingCorner:setAnchorPoint(cc.p(0.5, 1))
		self.imgKingCorner:addTo(self)
		self.imgKingCorner:setLocalZOrder(-1)
		self.imgKingCorner:setPosition(0, self.itemHeight - CV.deltaKingCornerTop)
	end
	self.imgKing:setScale(0.36)
	if align == 0 then
		local deltaCap = self.itemWidth - 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(45)
		self.imgKingCorner:setFlippedX(true)
		self.imgKingCorner:setPosition(CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	elseif align == 1 then
		local deltaCap = 8
		self.imgKing:setPosition(cc.p(deltaCap, self.itemHeight - 12))
		self.imgKing:setRotation(-45)
		self.imgKingCorner:setFlippedX(false)
		self.imgKingCorner:setPosition(self.itemWidth - CV.deltaKingCornerSide, self.itemHeight - CV.deltaKingCornerTop)
	end
end
function playerChatContent:hideKingCap()
	if self.imgKing ~= nil then
		self.imgKing:setVisible(false)
	end
	if self.imgKingCorner then
		self.imgKingCorner:setVisible(false)
	end
end
function playerChatContent:loadAudio()
	self:loadImgIconAndBtnTouch()
	if self.spriteAudio ~= nil then
		self.spriteAudio:setVisible(true)
	else
		self.spriteAudio = display.newSprite("#" .. CV.fileAudio)
		self.spriteAudio:setAnchorPoint(SoraDFAP(0.5, 0))
		self.spriteAudio:setPosition(cc.p(0, 0))
		self.spriteAudio:addTo(self)
	end
	local isSelf = chatFunctions.getIsPlayerSelf(self.playerId)
	if isSelf then
		self.spriteAudio:setColor(CV.colorAudioSelf)
	else
		self.spriteAudio:setColor(CV.colorAudioOther)
	end
	self.imgIcon:setVisible(false)
	self.btnTouch:setContentSize(cc.size(CV.sizeImgAudio.width + 20, CV.sizeImgAudio.height))
	self.btnTouch:setPosition(cc.p(0, 0))
	self.btnTouch:addTouchEventListener(handler(self, self.btnAudioCallBack))
	self.btnTouch:setVisible(false)
end
function playerChatContent:hideAudio()
	if self.spriteAudio ~= nil then
		self.spriteAudio:setVisible(false)
	end
end
function playerChatContent:btnAudioCallBack(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("TODO:播放语音--------------------------------")
		dump(self.customData)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function playerChatContent:showPlayAudioAnim()
	if self.spriteAudio then
		local frames = display.newFrames("et_laba_display%02d.png", 1, 3)
		if not frames then
			return
		end
		local frame4 = display.newSpriteFrame("et_laba_display01.png")
		frames[#frames + 1] = frame4
		local animation = display.newAnimation(frames, 0.25)
		self.spriteAudio:playAnimationForever(animation)
	end
end
function playerChatContent:stopPlayAudioAnim()
	if self.spriteAudio then
		self.spriteAudio:stopAllActions()
		local spriteFrameAudio = display.newSpriteFrame("et_laba_display03.png")
		if spriteFrameAudio then
			self.spriteAudio:setSpriteFrame(spriteFrameAudio)
		end
	end
end
function playerChatContent:loadSendToAll()
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
function playerChatContent:hideSendToAll()
end
function playerChatContent:loadCommonJoin(title)
	self:loadImgIconAndBtnTouch()
	self.imgIcon:setVisible(false)
	if self.label_share_1 then
		self.label_share_1:setVisible(true)
	else
		self.label_share_1 = ccui.Text:create("", "", 20)
		self.label_share_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.label_share_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.label_share_1:setColor(cc.c3b(55, 105, 139))
		self.label_share_1:setPosition(cc.p(243, 58.5))
		self.label_share_1:setAnchorPoint(cc.p(0, 1))
		self.label_share_1:addTo(self)
	end
	if self.btnTouch then
		self.btnTouch:setContentSize(cc.size(25, 25))
		self.btnTouch:setAnchorPoint(cc.p(1, 1))
		self.btnTouch:setPosition(cc.p(0, 0))
		self.btnTouch:addTouchEventListener(handler(self, self.btnCommonJoin))
	end
	self.label_share_1:setString(title or i18n("common_text_1484"))
end
function playerChatContent:btnCommonJoin(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("self.dataType===", self.dataType)
		if self.dataType == gChatDataType.dataType_groupbuy_good then
			if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GROUP_BUY) then
				SoraDCreatePanel("groupBuyView"):show()
			else
				SoraDShowMsgTip(i18n("common_text_1859"))
			end
		elseif self.dataType == gChatDataType.dataType_lengendWar then
			local customData = self.customData
			SoraDRemoveAllPanelFromManager()
			local hegemonRead = include("hegemonRead")
			local coordinate = hegemonRead.getBuildCoordinateByType(customData.values.subMapType)
			SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		elseif self.dataType == gChatDataType.dataType_starking then
			SoraDRemoveAllPanelFromManager()
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.KINGSTAR_KINGDOM_ID)
		elseif self.dataType == gChatDataType.dataType_hegemonWar then
			SoraDRemoveAllPanelFromManager()
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		elseif self.dataType == gChatDataType.dataType_party_share then
			if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PARTY_ACTIVITY, true) then
				local gametop = gModuleMgr.getObject("gametop")
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= CASTLE_LV6_LIMITED then
					local partyCtrl = SoraDGetCtrl("partyCtrl", gametop)
					partyCtrl:sendGetOnePartyInfo(customData.partyID)
					SoraDShowLoading(nil, nil, nil, false, nil, true)
				else
					_ENV = nil
					;(nil).num = CASTLE_LV6_LIMITED
					SoraDShowMsgTip(i18n("common_text_1795", nil))
				end
			else
				SoraDShowMsgTip(i18n("common_text_1859"))
			end
		elseif self.dataType == gChatDataType.dataType_allianceTreasure then
			if worldMapDefine.isInWarForbid(false, true) then
				return
			end
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
			local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
			if isInConquestWar then
				SoraDShowMsgTip(i18n("common_text_4264"))
			elseif tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE then
				if GLOBAL_GAME_ALLIANCE_MODE then
					_ENV = i18n("common_text_4264")
					i18n("common_text_4264").tag = 3
					uiManager:show("allianceStoreHouseView", i18n("common_text_4264"))
				else
					local panel = SoraDCreatePanel("allianceStoreHouseView")
					panel:gotoBtn(3)
					panel:show()
				end
			else
				SoraDShowMsgTip(i18n("allitreas_text_03"))
			end
		elseif self.dataType == gChatDataType.dataType_open_escort_buff_alliance then
			worldMapFunction.GotoEscort(function()
				SoraDRemoveAllPanelFromManager()
			end)
		elseif self.dataType == gChatDataType.dataType_alliance_beast_rally then
			self:checkRallyValid()
		elseif self.dataType == gChatDataType.ancient_treasure_build_rally then
			self:checkRallyValid()
		elseif self.dataType == gChatDataType.dataType_remains_war_team_invite then
			self:checkRemainsWarTeam()
		elseif self.dataType == gChatDataType.dataType_alliance_beast_call or self.dataType == gChatDataType.dataType_alliance_beast_trial then
			local allianceTerritoryAPI = include("allianceTerritoryAPI")
			local pos = allianceTerritoryAPI:getMainBuildingPos(gAllianceBuilding.ALTAR)
			if worldMapDefine.inInCrossWar() then
				SoraDShowMsgTip(i18n("common_text_4479"))
			elseif pos and next(pos) then
				SoraDGotoWorldMapPoint(pos, true)
				SoraDRemoveAllPanelFromManager()
			else
				SoraDShowMsgTip(i18n("alliance_beast_notice_04"))
			end
		elseif self.dataType == gChatDataType.dataType_devil_valley_team then
			local gametop = gModuleMgr.getObject("gametop")
			local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
			if devilValleyCtrl:hasTeams() then
				if devilValleyCtrl:getMyTeamIdEx() ~= self.customData.teamIdEx then
					devilValleyCtrl:sendReqJoinTeam(self.customData.teamIdEx, self.customData.challengeLv)
					return
				end
				local teams = devilValleyCtrl:getMyTeams()
				if teams.start then
					if devilValleyCtrl:getSelfIsStart() then
						SoraDShowMsgTip(i18n("devilvalley_text_44"))
						return
					end
					SoraDShowMsgBox(i18n("devilvalley_tips_07"), i18n("devilvalley_btn_14"), i18n("devilvalley_btn_13"), function(eventType)
						if MSGBOX_CALLBACK_YES == eventType and SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
							SoraDGetCtrl("devilValleyCtrl"):sendReqStartChallenge()
						end
					end)
				else
					local panel = SoraDCreatePanel("newTrialMyTeamView")
					panel:initData()
					panel:show()
				end
			else
				devilValleyCtrl:sendReqJoinTeam(self.customData.teamIdEx, self.customData.challengeLv)
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return playerChatContent
