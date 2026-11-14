local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mailFunctions = include("mailFunctions")
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local chatConst = include("chatConst")
local worldMapDefine = include("worldMapDefine")
local publicRead = include("publicRead")
local chatFunctions = include("chatFunctions")
local allianceDesRead = include("allianceDesRead")
local chatSkinRead = include("chatSkinRead")
local alliancePetRead = include("alliancePetRead")
local textParser = include("textParser")
local chatDesRead = include("chatDesRead")
local itemDesRead = include("itemDesRead")
local _ENV, chatDataParser = "itemDesRead", "itemDesRead"
local defaultPacketId = "chat_face"
local defaultEmotionWidth = 118
local defaultEmotionHeight = 118
local HexColor = function(c)
	local r = string.format("%02x", c.r)
	local g = string.format("%02x", c.g)
	local b = string.format("%02x", c.b)
	return r .. g .. b
end
_ENV = nil
;(nil).red = cc.c3b(255, 0, 0)
;(nil).green = cc.c3b(0, 255, 0)
;(nil).blue = cc.c3b(0, 0, 255)
local (nil).participate, ColorList = cc.c3b(55, 105, 139), nil
function chatDataParser.wrapServerDataArray(dataList, isSDK)
	local _ENV, dataArray
	for i, v in ipairs(dataList) do
		table.insert(dataArray, #dataArray + 1, chatDataParser.wrapServerData(v, isSDK))
	end
	return dataArray
end
function chatDataParser.wrapChatData(chatTypeUI, data, isSDK, custom)
	local wrapFunc = chatDataParser.wrapDataFunc[chatTypeUI]
	if not wrapFunc then
		assert(wrapFunc, "wrapFunc should not be nil,chatTypeUI=" .. chatTypeUI)
		return
	end
	return wrapFunc(data, isSDK, custom)
end
function chatDataParser.wrapServerData(dataItem, isSDK)
	_ENV = nil
	;(nil).chatType = gChatTypeUI.kingdom
	;(nil).dataType = 0
	;(nil).align = -1
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isKNotice = false
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = nil
	;(nil).alliance = nil
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = "2015-5-15"
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).labelSize, localData
	localData.bubbleId = gBubbleId.BUBBLE_ID_NORMAL
	if dataItem.content and dataItem.content.requestId then
		localData.requestId = dataItem.content.requestId
	elseif dataItem.content and dataItem.content.chatIndex then
		localData.requestId = dataItem.content.chatIndex
	end
	if dataItem.content and dataItem.content.chatIndex then
		localData.chatIndex = dataItem.content.chatIndex
	end
	if dataItem.chatType == gChatTypeDef.chat_kingDom_message or dataItem.chatType == gChatTypeDef.chat_kingDom_type then
		localData.chatType = gChatTypeUI.kingdom
		localData.kid = dataItem.kid
	elseif dataItem.chatType == gChatTypeDef.chat_alliance_message or dataItem.chatType == gChatTypeDef.chat_alliance_type then
		localData.chatType = gChatTypeUI.alliance
		if not worldMapDefine.isInTeamStatus() then
			localData.alv = dataItem.alv
		end
	elseif dataItem.chatType == gChatTypeDef.chat_team_message or dataItem.chatType == gChatTypeDef.chat_team_type then
		localData.chatType = gChatTypeUI.team
	end
	if dataItem.chatType == gChatTypeDef.chat_send_message_prop or dataItem.chatType == gChatTypeDef.chat_send_message_gold then
		localData.isKNotice = true
		localData.chatType = gChatTypeUI.kingdom
		localData.kid = dataItem.kid
	end
	if dataItem.contentType == gChatTypeDef.chat_content_expression then
		localData.dataType = gChatDataType.dataType_emotion
		if type(dataItem.content) == "string" then
			_ENV = type(dataItem.content)
			type(dataItem.content).packetId = defaultPacketId
			type(dataItem.content).emoticonId = dataItem.content
			type(dataItem.content).width = defaultEmotionWidth
			localData.customData, type(dataItem.content).height = type(dataItem.content), defaultEmotionHeight
		elseif type(dataItem.content) == "table" then
			_ENV = type(dataItem.content)
			type(dataItem.content).emoticonId = dataItem.content.text
			type(dataItem.content).packetId = dataItem.content.packetId or defaultPacketId
			type(dataItem.content).width = dataItem.content.width or defaultEmotionWidth
			localData.customData, type(dataItem.content).height = type(dataItem.content), dataItem.content.height or defaultEmotionHeight
		end
		localData.packetId = localData.customData.packetId
		localData.emoticonId = localData.customData.emoticonId
	elseif dataItem.contentType == gChatTypeDef.chat_content_text then
		localData.dataType = gChatDataType.dataType_text
		if dataItem.content and dataItem.content.chatSysMsgType ~= nil then
			local chatSysMsgType = dataItem.content.chatSysMsgType
			if dataItem.content.chatSysMsgType == gChatSysMsgType.boss_rally or dataItem.content.chatSysMsgType == gChatSysMsgType.player_rally or dataItem.content.chatSysMsgType == gChatSysMsgType.build_rally or dataItem.content.chatSysMsgType == gChatSysMsgType.wrath_beast_rally then
				localData.dataType = gChatDataType.dataType_rally
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.groupbuy_good then
				localData.dataType = gChatDataType.dataType_groupbuy_good
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.pet_upgrade_rank or dataItem.content.chatSysMsgType == gChatSysMsgType.pet_reach_max_level or dataItem.content.chatSysMsgType == gChatSysMsgType.pet_share then
				localData.dataType = gChatDataType.dataType_pet
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.hero_share then
				localData.dataType = gChatDataType.dataType_hero_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_feast_share then
				localData.dataType = gChatDataType.dataType_feast_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.eid_celebration_activity then
				localData.dataType = gChatDataType.eid_celebration_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.frosty_market_share then
				localData.dataType = gChatDataType.frosty_market_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.bubble_carnival_exchange_post then
				localData.dataType = gChatDataType.dataType_bubble_post
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.arms_share then
				localData.dataType = gChatDataType.dataType_arms_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.share_voice_room then
				localData.dataType = gChatDataType.dataType_share_voice_room
				localData.customData = dataItem.content.values
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.legendking_enter_battle or dataItem.content.chatSysMsgType == gChatSysMsgType.legendking_war_begin then
				localData.dataType = gChatDataType.dataType_lengendWar
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.hegemon_enter_battle or dataItem.content.chatSysMsgType == gChatSysMsgType.hegemon_war_begin then
				localData.dataType = gChatDataType.dataType_hegemonWar
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_treasure then
				localData.dataType = gChatDataType.dataType_allianceTreasure
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_official_appoint then
				localData.dataType = gChatDataType.dataType_allianceOfficial
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_beast_rally then
				localData.dataType = gChatDataType.dataType_alliance_beast_rally
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.ancient_treasure_build_rally then
				localData.dataType = gChatDataType.ancient_treasure_build_rally
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_beast_call then
				localData.dataType = gChatDataType.dataType_alliance_beast_call
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_beast_trial then
				localData.dataType = gChatDataType.dataType_alliance_beast_trial
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.remains_war_team_invite then
				localData.dataType = gChatDataType.dataType_remains_war_team_invite
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.solomonKey_reward then
				localData.dataType = gChatDataType.dataType_solomonKey_reward
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.remains_war_share_settle_info then
				localData.dataType = gChatDataType.dataType_remains_war_share_settle_info
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.remains_war_share_season_info then
				localData.dataType = gChatDataType.dataType_remains_war_share_season_info
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.ancient_treasure_building then
				localData.dataType = gChatDataType.dataType_ancient_treasure
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.ancient_treasure_build_rally then
				localData.dataType = gChatDataType.dataType_ancient_treasure_rally
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.collect_torch_require then
				localData.dataType = gChatDataType.dataType_collect_torch_require
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.ann_campfire_position then
				localData.checkSelfMap = true
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_counter_sys then
				localData.dataType = gChatDataType.dataType_alliance_counter_sys
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.alliance_own_counter_sys then
				localData.dataType = gChatDataType.dataType_alliance_own_counter_sys
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.hero_prison_share then
				localData.dataType = gChatDataType.dataType_hero_prison_share
				localData.customData = dataItem.content
			elseif dataItem.content.chatSysMsgType == gChatSysMsgType.starking_enter_battle or dataItem.content.chatSysMsgType == gChatSysMsgType.starking_war_begin then
				localData.dataType = gChatDataType.dataType_starking
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.nebula_viewer_gift then
				localData.dataType = gChatDataType.dataType_viewer_gift
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.nebula_allstar_system then
				localData.dataType = gChatDataType.dataType_chatroom_sys_op
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.plant_data_palm_up_lv then
				localData.dataType = gChatDataType.dataType_9001594
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.lion_paradise_up_lv then
				localData.dataType = gChatDataType.dataType_9001720
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.bubble_grange_up_lv then
				localData.dataType = gChatDataType.dataType_9001661
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.honor_back_activity then
				localData.dataType = gChatDataType.dataType_honor_back_activity
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.korean_chess_room_invite then
				localData.dataType = gChatDataType.dataType_korean_chess_room_invite
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.corban_market_reward then
				localData.dataType = gChatDataType.dataType_corban_market_reward
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.roaring_flame_system then
				local flameChatMsgType = dataItem.content.flameChatMsgType
				if flameChatMsgType == gRoaringFlameChatMsgType.decree_gift_user_num then
					localData.dataType = gChatDataType.decree_gift_user_num
					localData.customData = dataItem.content
				elseif flameChatMsgType == gRoaringFlameChatMsgType.camp_decree_gift_user_num then
					localData.dataType = gChatDataType.roaring_flame_war_decree_gift
					localData.customData = dataItem.content
				end
			elseif chatSysMsgType == gChatSysMsgType.simulated_drill_room_share then
				localData.dataType = gChatDataType.dataType_9001725
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.flying_chess then
				localData.dataType = gChatDataType.dataType_9001731
				localData.customData = dataItem.content
			elseif chatSysMsgType == gChatSysMsgType.manor_banquet then
				localData.dataType = gChatDataType.dataType_manor_banquet
				localData.customData = dataItem.content
			else
				localData.customData = dataItem.content
			end
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_fightReport then
		localData.dataType = gChatDataType.dataType_fightReport
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_equip_create then
		localData.dataType = gChatDataType.dataType_equip_create
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_equip_share then
		localData.dataType = gChatDataType.dataType_equip_share
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_pyramid_share then
		localData.dataType = gChatDataType.dataType_pyramid_share
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_red_packet then
		localData.dataType = gChatDataType.dataType_red_packet
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_audio then
		localData.dataType = gChatDataType.dataType_audio
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_eliminateGame_share then
		localData.dataType = gChatDataType.dataType_eliminateGame_share
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_starsWishGame_share then
		localData.dataType = gChatDataType.dataType_starsWishGame_share
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_party_share then
		localData.dataType = gChatDataType.dataType_party_share
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_devil_valley_team then
		localData.dataType = gChatDataType.dataType_devil_valley_team
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_devil_valley_battle then
		localData.dataType = gChatDataType.dataType_devil_valley_battle
		localData.customData = dataItem.content
	elseif dataItem.contentType == gChatTypeDef.chat_content_postion then
		if dataItem.content.chatSysMsgType == gChatSysMsgType.pos_share then
			localData.dataType = gChatDataType.dataType_pos_share
			localData.customData = dataItem.content
		end
	elseif dataItem.contentType == gChatTypeDef.chat_king_of_glory then
		localData.dataType = gChatDataType.dataType_king_of_glory
		localData.customData = dataItem.content
	end
	if dataItem.content and type(dataItem.content) == "table" and dataItem.content.kingdomMsgType and dataItem.content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.open_escort_buff_alliance then
		localData.dataType = gChatDataType.dataType_open_escort_buff_alliance
	end
	localData.content = chatDataParser.parseChatContent(dataItem, isSDK)
	if localData.content == nil then
		localData.content = ""
	end
	localData.isGM = dataItem.isGM
	localData.isKing = dataItem.isKing
	localData.isLegendKing = dataItem.isLegendKing
	localData.isLegendForSepKing = dataItem.isLegendForSepKing
	localData.isHegemon = dataItem.isHegemon
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if chatFunctions.getIsPlayerSelf(dataItem.from) then
			localData.isSelf = true
			localData.align = SoraDFIsRA() and 0 or 1
		else
			localData.isSelf = false
			localData.align = SoraDFIsRA() and 1 or 0
		end
	else
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	dataItem.translation = nil
	localData.translation = dataItem.translation
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local oriCurl = settingCtrl:getTranslateLanguage()
	localData.isShowTranslate = false
	if not localData.isSelf and oriCurl and dataItem.translation then
		if dataItem.translation.tText ~= nil then
			local isNeedTranslate, tText = translateCtrl:needTranslate(dataItem.translation)
			if isNeedTranslate == false then
				if tText == nil then
					localData.isShowTranslate = false
				elseif dataItem.translation.sl then
					local langAbbrRead = include("langAbbrRead")
					local abbrName = langAbbrRead.getAbbrName(dataItem.translation.sl)
					if abbrName then
						abbrName = i18n(abbrName)
					else
						abbrName = dataItem.translation.sl
					end
					_ENV = nil
					;(nil).language = abbrName
					local prefix = i18n("common_text_1635", nil)
					prefix = prefix or "from " .. dataItem.translation.sl
					dataItem.translation.translateInfo = prefix
					localData.isShowTranslate = true
				end
			else
				localData.isShowTranslate = false
			end
		else
			localData.isShowTranslate = false
		end
	end
	localData.chatId = dataItem.msgID
	localData.playerId = dataItem.from
	localData.imageId = dataItem.imageId
	if localData.imageId == 0 or localData.imageId == nil then
		localData.imageId = 1503
	end
	localData.nickName = dataItem.nickName
	if localData.playerId == nil then
		localData.playerId = 0
	end
	if localData.nickName == nil then
		localData.nickName = i18n("mail_text_26")
	end
	localData.npcId = dataItem.npcId
	if localData.npcId and localData.npcId ~= 0 then
		localData.nickName = chatFunctions:getNpcName(localData.npcId)
		localData.imageId = nil
		localData.imgPlayer = chatFunctions:getNpcHead(localData.npcId)
	end
	localData.isSysMsg = false
	localData.sysType = 0
	if type(dataItem.content) == "string" then
		localData.requestId = nil
	elseif type(dataItem.content) == "table" then
		localData.requestId = dataItem.content.requestId
	end
	if dataItem.sysType ~= nil and dataItem.sysType ~= 0 then
		localData.isSysMsg = true
		localData.sysType = dataItem.sysType
	end
	localData.vipLv = dataItem.vip
	if localData.vipLv == nil or localData.vipLv == 0 then
		localData.isVip = false
	else
		localData.isVip = true
	end
	localData.date = dataItem.date
	localData.time = os.date("%m-%d %H:%M", dataItem.date)
	localData.bottomText = localData.time
	localData.alliance = dataItem.allianceName
	localData.allianceId = dataItem.allianceId
	localData.serverMsg = dataItem
	localData.textType = localData.serverMsg.content and localData.serverMsg.content.textType or gChatTextType.text_plain
	if localData.dataType == gChatDataType.dataType_audio then
	end
	if localData.isSelf == true then
		localData.readStatus = gChatReadStatus.normal
	elseif localData.dataType == gChatDataType.dataType_audio then
		if not dataItem.status or dataItem.status == gMsgStatus.UNREAD then
			localData.readStatus = gChatReadStatus.unread
		else
			localData.readStatus = gChatReadStatus.normal
		end
	else
		localData.readStatus = gChatReadStatus.normal
	end
	if localData.content == nil then
		localData.content = ""
	end
	if localData.dataType == gChatDataType.dataType_audio then
	end
	localData.customProperty, _ENV = gChatDataType.dataType_audio, gChatDataType.dataType_audio
	localData.customProperty.sysBubbleId = dataItem.bubbleId
	localData.customProperty.sysHeadWearId = dataItem.headWearId
	localData.customProperty.sysAvatarFrameId = dataItem.avatarFrameId
	localData.bubbleId = dataItem.bubbleId and chatSkinRead.getBubbleIDByCid(dataItem.bubbleId) or gBubbleId.BUBBLE_ID_NORMAL
	localData.headWearId = dataItem.headWearId and chatSkinRead.getHeadWearIDByCid(dataItem.headWearId) or gHeadWearId.HEAD_ID_NORMAL
	localData.avatarFrameId = dataItem.avatarFrameId and chatSkinRead.getHeadIDByCid(dataItem.avatarFrameId) or gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
	if localData.isSysMsg == true then
		localData.bubbleId = gBubbleId.BUBBLE_ID_SYSTEM
	end
	if localData.bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
	end
	if localData.isKing == true and localData.headWearId == gHeadWearId.HEAD_ID_NORMAL then
		localData.headWearId = gHeadWearId.HEAD_ID_KING
	end
	if localData.dataType == gChatDataType.dataType_red_packet then
		localData.bubbleId = gBubbleId.BUBBLE_ID_RED_PACKET
		if localData.customData.redPacketInfo and localData.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			localData.bubbleId = gBubbleId.BUBBLE_ID_SUPER_PACKET
		elseif localData.customData.redPacketInfo and localData.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			localData.bubbleId = gBubbleId.BUBBLE_ID_DROP_BOX
		elseif localData.customData.redPacketInfo and localData.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			localData.bubbleId = gBubbleId.BUBBLE_ID_ICE_RED_PACKET
		end
	end
	if localData.dataType == gChatDataType.dataType_collect_torch_require then
		localData.bubbleId = gBubbleId.BUBBLE_ID_COLLECT_SALARY
		localData.topText = i18n("treasuremap_text_11")
	end
	if localData.isKNotice == true or dataItem.chatType == gChatTypeDef.chat_camp_horn then
		localData.bubbleId = gBubbleId.BUBBLE_ID_HORN
	end
	localData.isReaded = dataItem.isReaded
	localData.avatarUrl = dataItem.avatar
	if localData.dataType == gChatDataType.dataType_audio then
		localData.audioLen = localData.customData.audioLen
		localData.audioId = localData.customData.audioId
	end
	localData.nodeType = chatDataParser.getNodeType(localData)
	_ENV, localData.oriBubbleId = "oriBubbleId", localData.bubbleId
	;("oriBubbleId").checkRes = false
	local ("oriBubbleId").data, bubbleParam = localData, "oriBubbleId"
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	localData.showBubbleId = localData.bubbleId
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	if localData.isShowTranslate == true then
		print("----------需要显示翻译内容-----------------")
		local tl = settingCtrl:getTranslateLanguage()
		local tContent = localData.translation.tText[tl] and localData.translation.tText[tl].text or ""
		localData.tHtmlText = chatDataParser.wrapHtmlRichText(localData, tContent)
		localData.text = localData.tHtmlText
	end
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	if localData.chatChannel == gChatChannel.ALLIANCE then
		localData.name = localData.nickName
	else
		localData.name = mailFunctions:getWrappedName(localData.alliance, localData.nickName)
	end
	localData.name = SoraCheckUtf8String(localData.name)
	if type(dataItem.content) == "table" and dataItem.content.replyMsg then
		chatDataParser.applyReplyMsg(localData, dataItem.content.replyMsg)
	elseif dataItem.replyMsg then
		chatDataParser.applyReplyMsg(localData, dataItem.replyMsg)
	elseif type(localData.customData) == "table" and localData.customData.replyMsg then
		chatDataParser.applyReplyMsg(localData, localData.customData.replyMsg)
	end
	if type(dataItem.content) == "table" then
		localData.officialType = dataItem.content.officialType
		localData.officialTitle = dataItem.content.officialTitle
	end
	return localData
end
function chatDataParser.applyReplyMsg(localData, replyMsg)
	if not replyMsg or not localData then
		return
	end
	localData.replyMsg = replyMsg
	if not localData.topText then
		localData.topText = chatDataParser.buildReplyTopText(replyMsg)
	end
end
function chatDataParser.buildReplyTopText(replyMsg)
	if not replyMsg then
		return nil
	end
	local chatFunctions = include("chatFunctions")
	local displayText = chatFunctions.getReplyDisplayText(replyMsg)
	return displayText
end
function chatDataParser.wrapHtmlRichText(localData, text)
	local retStr
	if localData.isSysMsg == true then
		retStr = text
		if localData.customData and localData.customData.chatSysMsgType == gChatSysMsgType.collect_torch_require then
			_ENV = nil
			;(nil).name1 = itemDesRead.getName(localData.customData.values.mapID)
			_ENV, _ENV, (nil).name2 = localData.customData.values.fragmentID, itemDesRead.getName(localData.customData.values.fragmentID), itemDesRead.getName(localData.customData.values.fragmentID)
			_ENV, itemDesRead.getName(localData.customData.values.fragmentID).name1, localData.customData.values.fragmentID.color = localData.customData.values.fragmentID, localData.customData.values.fragmentID, itemDesRead.getColor(localData.customData.values.mapID)
			_ENV, itemDesRead.getName(localData.customData.values.fragmentID).name2, localData.customData.values.fragmentID.color = localData.customData.values.fragmentID, localData.customData.values.fragmentID, itemDesRead.getColor(localData.customData.values.fragmentID)
			itemDesRead.getName(localData.customData.values.fragmentID)._default, localData.customData.values.fragmentID.color = localData.customData.values.fragmentID, "#ffffff"
			retStr = i18n_html("treasuremap_text_01", nil, (itemDesRead.getName(localData.customData.values.fragmentID)))
		end
	else
		retStr = string.htmlspecialchars(text)
		retStr = RemoveStringSpecial(retStr)
	end
	retStr = chatDataParser.wrapTexCoord(localData, retStr)
	if chatDataParser.needWrapSystem(localData) then
		retStr = chatDataParser.wrapSystem(localData, retStr)
	elseif chatDataParser.needWrapDJChat(localData) then
		retStr = chatDataParser.wrapDJChat(localData, retStr)
	end
	return retStr
end
function chatDataParser.needWrapDJChat(localData)
	return localData.dataType == gChatDataType.dataType_dj
end
function chatDataParser.wrapDJChat(localData, text)
	local customData = localData.customData
	if localData.itemID then
		local ret = ""
		local fromname = localData.name
		if localData.kid then
			fromname = fromname .. "#" .. localData.kid
		end
		if localData.isSelf then
			_ENV = localData.kid
			_ENV, _ENV, localData.kid.gift = nil, localData.content, localData.content
			localData.content.gift, (nil).color = nil, "#ffd43e"
			ret = i18n_html("Anchor_text_54", localData.kid, localData.content)
		elseif SoraDGetCtrl("djCtrl").isBroadcastDJ then
			_ENV = localData.kid
			localData.kid.name = fromname
			_ENV, _ENV, localData.kid.gift = nil, localData.content, localData.content
			localData.content.gift, (nil).color = nil, "#ffd43e"
			ret = i18n_html("Anchor_text_62", localData.kid, localData.content)
		else
			_ENV = localData.kid
			localData.kid.name = fromname
			localData.kid.dj = SoraDGetCtrl("djCtrl"):getDJName()
			_ENV, _ENV, localData.kid.item = SoraDGetCtrl("djCtrl"), localData.content, localData.content
			localData.content.gift, SoraDGetCtrl("djCtrl").color = SoraDGetCtrl("djCtrl"), "#ffd43e"
			ret = i18n_html("Anchor_text_63", localData.kid, localData.content)
		end
		return ret
	end
	local name = localData.name
	if localData.kid then
		name = _p(name) .. _p(" #" .. localData.kid .. ": ")
	end
	_ENV = " #" .. localData.kid .. ": "
	;(" #" .. localData.kid .. ": ").text = name
	;(" #" .. localData.kid .. ": ").linkcolor = SoraDRGB2HtmlColor(cc.c3b(0, 255, 255))
	;(" #" .. localData.kid .. ": ").c = false
	local nameInfo = chatDataParser.wrapSystemRich_text(localData, " #" .. localData.kid .. ": ")
	local ret = ""
	ret = nameInfo .. text
	return ret
end
function chatDataParser.needWrapSystem(localData)
	if localData.isSysMsg == true then
		if localData.dataType == gChatDataType.dataType_collect_torch_require then
			return false
		else
			return true
		end
	end
	if localData.dataType == gChatDataType.dataType_red_packet and localData.customData.redPacketInfo and localData.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.GIFT_PACKAGE_ACTIVIT then
		return true
	end
	if localData.dataType == gChatDataType.dataType_pos_share then
		return true
	end
	if localData.dataType == gChatDataType.roaring_flame_war_decree_gift or localData.dataType == gChatDataType.decree_gift_user_num then
		return true
	end
	return false
end
function chatDataParser.wrapSystem(localData, text)
	local headInfo = chatDataParser.wrapSytemHead(localData, text)
	local ret = text
	if localData.customData and localData.customData.chatSysMsgType ~= gChatSysMsgType.pos_share and not localData.customData.chatroom then
		ret = headInfo .. text
	end
	if gChatDataTypeCfg[localData.dataType] and gChatDataTypeCfg[localData.dataType].tailType then
		local tailInfo = chatDataParser.wrapSystemTail(localData, ret)
		ret = ret .. tailInfo
	end
	return ret
end
function chatDataParser.wrapSytemHead(localData, text)
	local dataTypeCfg = gChatDataTypeCfg[localData.dataType]
	local headType = dataTypeCfg and dataTypeCfg.headType or gChatHeadType.system
	local headInfo
	if headType == gChatHeadType.custom then
		local funcName = "wrapSystemHead_" .. dataTypeCfg.name
		local func = chatDataParser[funcName]
		if func then
			headInfo = func(localData, text)
		else
			print("localData.dataType ", localData.dataType, "的自定义头部类型没有定义")
			local headTypeCfg = gChatHeadTypeCfg[headType]
			headInfo = chatDataParser.wrapSystemRich(localData, headTypeCfg)
		end
		return headInfo
	else
		local headTypeCfg = gChatHeadTypeCfg[headType]
		return chatDataParser.wrapSystemRich(localData, headTypeCfg)
	end
end
function chatDataParser.wrapSystemTail(localData, text)
	local dataTypeCfg = gChatDataTypeCfg[localData.dataType]
	if not dataTypeCfg then
		print("chatDataParser.wrapSystemTail 类型未定义: localData.dataType = ", localData.dataType)
		return ""
	end
	local tailInfo
	if dataTypeCfg.tailType == gChatTailType.custom then
		local funcName = "wrapSystemTail_" .. dataTypeCfg.name
		local func = chatDataParser[funcName]
		if func then
			tailInfo = func(localData, text)
		else
			local tailCfg = gChatTailTypeCfg[gChatTailType.default]
			tailInfo = chatDataParser.wrapSystemRich(localData, tailCfg)
		end
	elseif dataTypeCfg.tailType == gChatTailType.common then
		_ENV = dataTypeCfg.tailType
		dataTypeCfg.tailType.richType = gChatRichType.text
		local dataTypeCfg.tailType.des, tailCfg = "common_text_477", dataTypeCfg.tailType
		if dataTypeCfg and dataTypeCfg.tailDes then
			tailCfg.des = dataTypeCfg.tailDes
		end
		if dataTypeCfg.underline then
			tailCfg.u = true
		end
		tailInfo = chatDataParser.wrapSystemRich(localData, tailCfg)
	else
		local tailCfg = gChatTailTypeCfg[dataTypeCfg.tailType]
		if tailCfg then
			tailInfo = chatDataParser.wrapSystemRich(localData, tailCfg)
		end
	end
	return tailInfo
end
function chatDataParser.wrapSystemRich(localData, richCfg)
	local richType = richCfg.richType
	local richName = "wrapSystemRich_" .. (gChatRichType2Str[richType] or "")
	local richFunc = chatDataParser[richName]
	if richFunc then
		return richFunc(localData, richCfg)
	else
		print(" chatDataParser.wrapSystemRich(richCfg), richType = ", richType, " not found")
		return ""
	end
end
function chatDataParser.wrapSystemRich_text(localData, tbInfo)
	local bubbleCfg = chatSkinRead.getBubbleCfg(localData.bubbleId)
	local linkcolor = bubbleCfg.linkcolor
	chatSkinRead = nil
	;(nil).c = true
	;(nil).i = tbInfo.i
	;(nil).u = tbInfo.u
	;(nil).color = tbInfo.linkcolor or linkcolor
	;(nil).name = tbInfo.name or tostring(localData.dataType)
	local (nil).custom, style = tbInfo.custom or tostring(localData.dataType), nil
	if tbInfo.c ~= nil then
		style.c = tbInfo.c
	end
	return SoraDWrapHtmlTagByStyle(tbInfo.text or i18n(tbInfo.des), style)
end
function chatDataParser.wrapSystemRich_icon(localData, tbInfo)
	_ENV = nil
	;(nil).param = tbInfo.icon or "#icon_chat_sys.png"
	;(nil).name = tbInfo.name or "iconSys"
	;(nil).width = tbInfo.width or 53
	;(nil).height = tbInfo.height or 31
	;(nil).custom = tbInfo.custom or "Sprite"
	;(nil).offsetcx = tbInfo.offsetcx or 0
	;(nil).offsetcy = tbInfo.offsetcy or 0
	;(nil).offsety = tbInfo.offsety or 0
	;(nil).scale = tbInfo.scale or 1.0
	return SoraDWrapReplaceTag(nil)
end
function chatDataParser.wrapSystemTail_dataType_pet(localData, text)
	if localData.customData and localData.customData.values and localData.customData.values.petid then
		local petDesRead = include("petDesRead")
		local petName = petDesRead.getName(localData.customData.values.petid)
		_ENV = nil
		;(nil).text = petName
		return chatDataParser.wrapSystemRich_text(localData, nil)
	end
	return ""
end
function chatDataParser.wrapSystemTail_dataType_pos_share(localData, text)
	local customData = localData.customData
	local color = cc.c3b(0, 190, 30)
	local posStr
	if (not customData.values or not customData.values) and not customData.data.content then
		local _ENV, info = customData.data.content, customData.data.content
	end
	if worldMapDefine.isWarKingdomID(info.mapId) then
		local worldMapWarDef = include("worldMapWarDef")
		local name = worldMapWarDef.getKingdomNameByKid(info.mapId) or ""
		posStr = string.format("（%s,X:%d,Y:%d）", name, info.x, info.y)
	else
		posStr = string.format("（K:%d,X:%d,Y:%d）", info.mapId, info.x, info.y)
	end
	_ENV = info.mapId
	info.mapId.text = posStr
	info.mapId.linkcolor = SoraDRGB2HtmlColor(color)
	local textInfo = chatDataParser.wrapSystemRich_text(localData, info.mapId)
	local iconName = "#icon_zbfx_dw.png"
	if info.markType then
		local AMM = require_data("alliancemapmark", true).data
		if AMM[info.markType] then
			iconName = "#" .. AMM[info.markType].icon
		end
	elseif info.markId then
		local activity_9001573_Read = include("activity_9001573_Read")
		iconName = "#" .. activity_9001573_Read.getCampMarkIcon(info.markId)
	end
	_ENV = activity_9001573_Read.getCampMarkIcon(info.markId)
	activity_9001573_Read.getCampMarkIcon(info.markId).icon = iconName
	activity_9001573_Read.getCampMarkIcon(info.markId).name = "iconSharePos"
	activity_9001573_Read.getCampMarkIcon(info.markId).width = 51
	activity_9001573_Read.getCampMarkIcon(info.markId).height = 59
	activity_9001573_Read.getCampMarkIcon(info.markId).offsetX = 15
	local iconInfo = chatDataParser.wrapSystemRich_icon(localData, (activity_9001573_Read.getCampMarkIcon(info.markId)))
	return textInfo .. iconInfo
end
function chatDataParser.wrapSystemTail_dataType_equip_create(localData, text)
	dump(localData, "chatDataParser.wrapSystemTail_dataType_equip_create", 10)
	local customData = localData.customData
	local equipDesRead = include("equipDesRead")
	local eid = customData.eid
	local quality = customData.qly
	local equipName = equipDesRead.getName(eid)
	local color = equipDesRead.getAttrColor(quality)
	_ENV = nil
	;(nil).text = equipName
	;(nil).linkcolor = SoraDRGB2HtmlColor(color)
	local textInfo = chatDataParser.wrapSystemRich_text(localData, nil)
	_ENV = SoraDRGB2HtmlColor(color)
	SoraDRGB2HtmlColor(color).icon = "#icon_chat_equip.png"
	SoraDRGB2HtmlColor(color).name = "iconEquip"
	SoraDRGB2HtmlColor(color).width = 34
	SoraDRGB2HtmlColor(color).height = 34
	SoraDRGB2HtmlColor(color).offsety = 6
	local iconInfo = chatDataParser.wrapSystemRich_icon(localData, (SoraDRGB2HtmlColor(color)))
	return textInfo .. iconInfo
end
function chatDataParser.wrapSystemTail_dataType_hero_share(localData, text)
	if localData.customData and localData.customData.values and localData.customData.values.heroID then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroExInfo = heroltCtrl.getHeroInfo(localData.customData.values.heroID)
		local heroName = "???"
		if heroExInfo then
			heroName = i18n(heroExInfo.herName)
		end
		_ENV = nil
		;(nil).text = heroName
		local textInfo = chatDataParser.wrapSystemRich_text(localData, nil)
		return textInfo
	end
	return ""
end
function chatDataParser.wrapSystemTail_dataType_hero_prison_share(localData, text)
	local customData = localData.customData
	customData = customData.values and customData or customData.data.content
	if customData and customData.values and customData.values.heroID then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroExInfo = heroltCtrl.getHeroInfo(customData.values.heroID)
		local heroName = "???"
		if heroExInfo then
			heroName = i18n(heroExInfo.herName)
		end
		_ENV = nil
		;(nil).text = heroName
		local textInfo = chatDataParser.wrapSystemRich_text(localData, nil)
		return textInfo
	end
	return ""
end
function chatDataParser.wrapSystemTail_dataType_arms_share(localData, text)
	if localData.customData and localData.customData.values and localData.customData.values.armsID then
		local armsName = include("equipDesRead").getArtifactName(localData.customData.values.armsID)
		_ENV = nil
		;(nil).text = armsName
		;(nil).linkcolor = SoraDRGB2HtmlColor(cc.c3b(255, 0, 255))
		local textInfo = chatDataParser.wrapSystemRich_text(localData, nil)
		return textInfo
	end
	return ""
end
function chatDataParser.wrapTexCoord(localData, text)
	local limitX = 1200
	local limitY = 1200
	local patternDD = "((%d+)%s*:%s*(%d+)[:]*(%d*))"
	local patternXY = "([xX]%s*:?%s*(%d+)[^yY]*[yY]%s*:?%s*(%d+))"
	local patternYX = "([yY]%s*:?%s*(%d+)[^xX]*[xX]%s*:?%s*(%d+))"
	local patternKXY = "([kK]%s*:?%s*(%d+)[^xX]*[xX]%s*:?%s*(%d+)[^yY]*[yY]%s*:?%s*(%d+))"
	local str = ""
	local finded = false
	local parseXY = function(text, pattern, flip)
	end
	local parseKXY = function(text, pattern, flip)
	end
	parseKXY(text, patternKXY)
	if not finded then
		parseXY(text, patternDD)
	end
	if not finded then
		parseXY(text, patternXY)
	end
	if not finded then
		parseXY(text, patternYX, true)
	end
	if finded then
		text = str
	end
	return text
end
function chatDataParser.parseCoordinate(strCoordinate)
	local k, x, y = string.match(strCoordinate, "k:(%d+),x:(%d+),y:(%d+)")
	if k == nil then
		x, y = string.match(strCoordinate, "x:(%d+),y:(%d+)")
	end
	_ENV = string.match(strCoordinate, "x:(%d+),y:(%d+)")
	string.match(strCoordinate, "x:(%d+),y:(%d+)").k = tonumber(k)
	string.match(strCoordinate, "x:(%d+),y:(%d+)").x = x
	string.match(strCoordinate, "x:(%d+),y:(%d+)").y = y
	return string.match(strCoordinate, "x:(%d+),y:(%d+)")
end
function chatDataParser.getNodeType(localData)
	local dataType = localData.dataType
	local nodeType = gChatDataType2NodeType[dataType]
	if nodeType == nil then
		if localData.isSysMsg then
			nodeType = gChatNodeType.group_sys_text
		else
			nodeType = gChatNodeType.group_text
		end
	end
	return nodeType
end
function chatDataParser.wrapRichText(text, color, isAction)
	if not text then
		text = ""
		return text
	end
	local hexColorStr = HexColor(color)
	local result = string.format("[#%s%s]%s[#GGGGGG]", hexColorStr, isAction and "@action" or "", text)
	return result
end
function chatDataParser.parseChatContent(dataItem, isSDK)
	local result = i18n("common_text_4425")
	dump(dataItem, "chatDataParser.parseChatContent")
	local isHtmlCheck = false
	if dataItem.contentType == gChatTypeDef.chat_content_fightReport then
		result = chatDataParser.parseChatFightReport(dataItem, isSDK)
		isHtmlCheck = true
	elseif dataItem.contentType == gChatTypeDef.chat_content_equip_create then
		result = i18n("common_text_1284")
		if isSDK then
			local quality = dataItem.content.qly
			local eid = dataItem.content.eid
			local equipDesRead = include("equipDesRead")
			local equipName = equipDesRead.getName(eid)
			local color = equipDesRead.getAttrColor(quality)
			result = result .. chatDataParser.wrapRichText(equipName, color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_equip_share then
		result = "i share a equip!"
	elseif dataItem.contentType == gChatTypeDef.chat_content_pyramid_share then
		result = chatDataParser.parsePyramidShare(dataItem) or ""
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_audio then
		if dataItem.content.audioLen then
			result = tostring(dataItem.content.audioLen) .. "''"
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_eliminateGame_share then
		result = chatDataParser.parseEliminateGameShare(dataItem)
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_starsWishGame_share then
		result = chatDataParser.parseStarsWishGameShare(dataItem)
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_party_share then
		result = chatDataParser.parsePartyShare(dataItem)
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_devil_valley_team then
		result = chatDataParser.parseDevilValleyShare(dataItem)
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	elseif dataItem.contentType == gChatTypeDef.chat_content_devil_valley_battle then
		local DMD = _G.require_data("devilvalley_message")
		if dataItem.content then
			local index = tonumber(dataItem.content.message)
			if index then
				result = i18n(DMD.data[index].message)
			end
		end
	elseif dataItem.contentType == gChatTypeDef.chat_king_of_glory then
		result = chatDataParser.parseKingOfGlory(dataItem) or ""
		if isSDK then
			local color = ColorList.participate
			result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
		end
	else
		local resultParam
		result, resultParam = chatDataParser.parseChatContentText(dataItem.content, dataItem)
		if result == nil then
			result = ""
		end
		if not resultParam or type(resultParam) == "table" then
		end
		if isSDK then
			if dataItem.content and dataItem.content.chatSysMsgType ~= nil then
				local chatSysMsgType = dataItem.content.chatSysMsgType
				if chatSysMsgType == gChatSysMsgType.groupbuy_good or chatSysMsgType == gChatSysMsgType.worldcup_puzzle then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_1484"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.boss_rally or chatSysMsgType == gChatSysMsgType.player_rally or chatSysMsgType == gChatSysMsgType.build_rally or chatSysMsgType == gChatSysMsgType.legendking_enter_battle or chatSysMsgType == gChatSysMsgType.hegemon_enter_battle or chatSysMsgType == gChatSysMsgType.wrath_beast_rally then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_477"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.pet_upgrade_rank or chatSysMsgType == gChatSysMsgType.pet_reach_max_level or chatSysMsgType == gChatSysMsgType.pet_share then
					local color = ColorList.participate
					local petDesRead = include("petDesRead")
					result = result .. chatDataParser.wrapRichText(petDesRead.getName(dataItem.content.values.petid), color, true)
				elseif chatSysMsgType == gChatSysMsgType.hero_share then
					local color = ColorList.participate
					local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
					local heroExInfo = heroltCtrl.getHeroInfo(dataItem.content.values.heroID)
					local heroName = i18n(heroExInfo.herName)
					result = result .. chatDataParser.wrapRichText(heroName, color, true)
				elseif chatSysMsgType == gChatSysMsgType.arms_share then
					local color = ColorList.participate
					local armsName = include("equipDesRead").getArtifactName(dataItem.content.values.armsID)
					result = result .. chatDataParser.wrapRichText(armsName, color, true)
				elseif chatSysMsgType == gChatSysMsgType.share_voice_room then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_068"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.alliance_treasure then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_477"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.alliance_beast_rally or chatSysMsgType == gChatSysMsgType.alliance_beast_call or chatSysMsgType == gChatSysMsgType.alliance_beast_trial then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_477"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.ancient_treasure_build_rally then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_477"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.remains_war_team_invite then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("remains_btn_05"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.remains_war_share_settle_info then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_829"), color, true)
				elseif chatSysMsgType == gChatSysMsgType.remains_war_share_season_info then
					local color = ColorList.participate
					result = result .. chatDataParser.wrapRichText(i18n("common_text_829"), color, true)
				end
			end
			if dataItem.content and dataItem.content.kingdomMsgType ~= nil and dataItem.content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.open_escort_buff_alliance then
				local color = ColorList.participate
				result = result .. chatDataParser.wrapRichText(i18n("common_text_477"), color, true)
			end
		end
	end
	if isHtmlCheck then
		result = string.htmlspecialchars(result)
	end
	return result
end
function chatDataParser.parseChatContentText(content)
	if content == nil then
		content = ""
	end
	local result = i18n("common_text_4425")
	local _ENV, resultParam = "common_text_4425", "common_text_4425"
	dump(content, "chatDataParser.parseChatContentText")
	if type(content) == "string" then
		result = content
		return result, resultParam
	end
	local textType = content.textType
	if textType == gChatTextType.text_auto then
		if not content.values or not textParser.parseValues(content.values) then
			local _ENV, valueMap = textParser.parseValues(content.values), textParser.parseValues(content.values)
		end
		if content.kingdomMsgType ~= nil then
			local cfg = chatDesRead.getChatNoticeCfg(content.kingdomMsgType)
			if cfg then
				result = i18n(cfg.des, valueMap)
			end
		elseif content.chatSysMsgType ~= nil then
			local cfg = chatDesRead.getChatSysCfg(content.chatSysMsgType)
			if cfg and valueMap then
				result = i18n(cfg.des, valueMap)
			elseif content.text and content.text ~= "" then
				result = i18n(content.text, valueMap)
			else
				local _result = chatDataParser.parseChatContentText2(content)
				if _result then
					result = _result
				end
			end
		end
		return result
	elseif textType == gChatTextType.text_plain then
		result = content.text
	elseif textType == gChatTextType.text_id then
		result = string.len(content.text) > 0 and i18n(content.text, content.values) or "NA"
		if content.kingdomMsgType ~= nil then
			if gSystemNoticeKingdomMsgTypeDef.world_new_treasure_box == content.kingdomMsgType then
				if content.class ~= nil then
					local chestpackshow = include("chestpackshow")
					if chestpackshow and chestpackshow[content.class] and chestpackshow[content.class].notice1 then
						result = i18n(chestpackshow[content.class].notice1)
					end
				end
			elseif gSystemNoticeKingdomMsgTypeDef.world_new_treasure_bowl == content.kingdomMsgType then
				if content.class ~= nil then
					local chestpackshow = include("treasurebowlshow")
					if chestpackshow and chestpackshow[content.class] and chestpackshow[content.class].notice1 then
						result = i18n(chestpackshow[content.class].notice1)
					end
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.castle_occupy then
				local nickName = content.values.nickName
				if content.values.sourceKid and 0 ~= content.values.sourceKid then
					nickName = nickName .. "#" .. content.values.sourceKid
				end
				nickName = SoraCheckUtf8String(nickName)
				_ENV = content.values.sourceKid
				content.values.sourceKid.abr = SoraCheckUtf8String(content.values.abr)
				content.values.sourceKid.nickName = nickName
				result = i18n(content.text, content.values.sourceKid)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.plunder_necklace then
				local equipDesRead = include("equipDesRead")
				local valueMap = textParser.parseValues(content.values)
				valueMap.equipname = equipDesRead.getName(content.values.eid)
				result = i18n(content.text, valueMap)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.get_necklace then
				local equipDesRead = include("equipDesRead")
				_ENV = "equipDesRead"
				;("equipDesRead").username = textParser.formatPlayerName(content.values.abbr, content.values.username)
				local ("equipDesRead").kindom, valueMap = content.values.kindom, "equipDesRead"
				valueMap.equipname = equipDesRead.getName(content.values.eid)
				result = i18n(content.text, valueMap)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.castle_occupy_with_7 or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.castle_occupy_with_7_50 then
				local allianceName = content.values.allianceName or ""
				allianceName = SoraCheckUtf8String(allianceName)
				if content.values.sourceKid and 0 ~= content.values.sourceKid then
					allianceName = allianceName .. "#" .. content.values.sourceKid
				end
				_ENV = content.values.sourceKid
				content.values.sourceKid.time = content.values.time
				content.values.sourceKid.alliance = allianceName
				result = i18n(content.text, content.values.sourceKid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.atlantis_war_boss_will_end then
				local bossType = content.values.bossType
				if bossType == gBossType.atlantisWarWlyn then
					result = i18n("atlantiswar_text_0187")
				elseif bossType == gBossType.atlantisWarSd then
					result = i18n("atlantiswar_text_0188")
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.atlantis_war_own_fort_cmd_post then
				local values = content.values
				local AMBC = require_data("atlantiswar_map_build_config").data
				local buildName = i18n(AMBC[values.buildId].name)
				if values.kid and 0 < values.kid then
					local kingdomName = serviceFunctions.getKingdomFormatName(values.kingdomName, values.kid)
					_ENV = nil
					;(nil).var = kingdomName
					;(nil).buildName = buildName
					result = i18n("atlantiswar_text_0194", nil)
				else
					_ENV = "atlantiswar_text_0194"
					;("atlantiswar_text_0194").buildName = buildName
					result = i18n("atlantiswar_text_0197", "atlantiswar_text_0194")
				end
			end
		end
	elseif textType == gChatTextType.text_custom then
		if content.kingdomMsgType ~= nil then
			local kingdomMsgType = content.kingdomMsgType
			if gSystemNoticeKingdomMsgTypeDef.adjust_res == content.kingdomMsgType then
				local publicRead = include("publicRead")
				local resName = "not define"
				if content.values.resId then
					resName = publicRead.getName(content.values.resId)
				end
				_ENV = "atlantiswar_text_0194"
				;("atlantiswar_text_0194").nickNameKing = SoraCheckUtf8String(content.values.nickNameKing)
				;("atlantiswar_text_0194").resName = resName
				;("atlantiswar_text_0194").resNameOut = resName
				result = i18n(content.text, "atlantiswar_text_0194")
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.new_officer then
				local officialInfoRead = include("officialInfoRead")
				if officialInfoRead then
					local officialName = "not define"
					if content.values.officialPos then
						local officialInfo = officialInfoRead.getInfoByType(content.values.officialPos)
						officialName = i18n(officialInfo.name)
					end
					local isKing = content.values.isKing
					_ENV = SoraCheckUtf8String(content.values.nickNameKing)
					SoraCheckUtf8String(content.values.nickNameKing).status = isKing and i18n("official_name_1") or i18n("official_name_2")
					SoraCheckUtf8String(content.values.nickNameKing).nickNameKing = SoraCheckUtf8String(content.values.nickNameKing)
					SoraCheckUtf8String(content.values.nickNameKing).nickNameOther = SoraCheckUtf8String(content.values.nickNameOther)
					SoraCheckUtf8String(content.values.nickNameKing).officialPos = officialName
					result = i18n(content.text, (SoraCheckUtf8String(content.values.nickNameKing)))
				else
					_ENV = i18n(content.text, (SoraCheckUtf8String(content.values.nickNameKing)))
					i18n(content.text, (SoraCheckUtf8String(content.values.nickNameKing))).nickNameKing = SoraCheckUtf8String(content.values.nickNameKing)
					i18n(content.text, (SoraCheckUtf8String(content.values.nickNameKing))).nickNameOther = SoraCheckUtf8String(content.values.nickNameOther)
					result = i18n(content.text, (i18n(content.text, (SoraCheckUtf8String(content.values.nickNameKing)))))
				end
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.world_treasure_box_end then
				local time = content.values.time
				local timeStr = os.date("%H:%M:%S", time)
				local chestpackshow = include("chestpackshow")
				if content.class ~= nil and chestpackshow and chestpackshow[content.class] and chestpackshow[content.class].notice2 then
					_ENV = content.values.nickNameOther
					content.values.nickNameOther.time = timeStr
					result = i18n(chestpackshow[content.class].notice2, content.values.nickNameOther)
				else
					_ENV = content.values.nickNameOther
					content.values.nickNameOther.time = timeStr
					result = i18n(content.text, content.values.nickNameOther)
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.world_treasure_bowl_end then
				local time = content.values.time
				local timeStr = os.date("%H:%M:%S", time)
				local chestpackshow = include("treasurebowlshow")
				if content.class ~= nil and chestpackshow and chestpackshow[content.class] and chestpackshow[content.class].notice2 then
					_ENV = content.values.nickNameOther
					content.values.nickNameOther.time = timeStr
					result = i18n(chestpackshow[content.class].notice2, content.values.nickNameOther)
				else
					_ENV = content.values.nickNameOther
					content.values.nickNameOther.time = timeStr
					result = i18n(content.text, content.values.nickNameOther)
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.big_red_gift or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.cash_red_gift then
				local channel = content.values.channel
				local channelName = "unknown"
				if channel == 1 then
					channelName = i18n("common_text_069")
				elseif channel == 2 then
					channelName = i18n("common_text_070")
				end
				local strName = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				strName = SoraCheckUtf8String(strName)
				_ENV = content.values.name
				content.values.name.name = strName
				content.values.name.channel = channelName
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.conquest_war_invade then
				if content.values.abbr ~= nil then
					local playerName = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
					playerName = SoraCheckUtf8String(playerName)
					_ENV = content.values.name
					content.values.name.name = playerName
					content.values.name.kingDomNum = content.values.kingDomNum
					result = i18n(content.text, content.values.name)
				else
					_ENV = content.text
					content.text.name = SoraCheckUtf8String(content.values.name)
					content.text.kingDomNum = content.values.kingDomNum
					result = i18n(content.text, content.text)
				end
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.radiance_war_gate then
				if content.values.abbr ~= nil then
					local playerName = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
					playerName = SoraCheckUtf8String(playerName)
					_ENV = content.values.name
					content.values.name.name = playerName
					content.values.name.kingdomNum = content.values.kingdomNum
					content.values.name.x = content.values.x
					content.values.name.y = content.values.y
					result = i18n(content.text, content.values.name)
				else
					_ENV = content.text
					content.text.name = SoraCheckUtf8String(content.values.name)
					content.text.kingdomNum = content.values.kingdomNum
					content.text.x = content.values.x
					content.text.y = content.values.y
					result = i18n(content.text, content.text)
				end
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.radiance_war_end_fail then
				local name = content.values.kingdom
				if 0 >= content.values.kingdomNum then
					name = i18n("alliance_office_text_15")
				end
				_ENV = content.values.y
				content.values.y.name = name
				result = i18n(content.text, content.values.y)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.flower_large_gift then
				local nameSend = mailFunctions:getWrappedName(content.values.abbrSend, content.values.nameSend, content.sndKID)
				local nameReceive = mailFunctions:getWrappedName(content.values.abbrReceive, content.values.nameReceive)
				nameSend = SoraCheckUtf8String(nameSend)
				nameReceive = SoraCheckUtf8String(nameReceive)
				_ENV = content.values.nameReceive
				content.values.nameReceive.nameSend = nameSend
				content.values.nameReceive.nameReceive = nameReceive
				content.values.nameReceive.num = content.values.num
				result = i18n(content.text, content.values.nameReceive)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.marshal_online then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.marshal_offline then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.open_escort_buff_kingdom then
				local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.values.time)
				_ENV = content.values.kid
				content.values.kid.abbr = SoraDCheckHtmlUtf8Str(content.values.abbr)
				content.values.kid.time = timeStr
				content.values.kid.allianceName = SoraDCheckHtmlUtf8Str(content.values.allianceName or "")
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.open_escort_buff_alliance then
				local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.values.time)
				_ENV = content.values.kid
				content.values.kid.time = timeStr
				result = i18n(content.text, content.values.kid)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.open_group_buy_good then
				local itemDesRead = include("itemDesRead")
				local itemName = ""
				if content.values.itemId then
					itemName = publicRead.getName(content.values.itemId)
				end
				_ENV = SoraDCheckHtmlUtf8Str(content.values.allianceName or "")
				SoraDCheckHtmlUtf8Str(content.values.allianceName or "").name = itemName
				SoraDCheckHtmlUtf8Str(content.values.allianceName or "").itemNum = content.values.itemNum
				SoraDCheckHtmlUtf8Str(content.values.allianceName or "").num = content.values.num
				SoraDCheckHtmlUtf8Str(content.values.allianceName or "").gold = content.values.gold
				result = i18n(content.text, (SoraDCheckHtmlUtf8Str(content.values.allianceName or "")))
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.monsterfiesta_refresh then
				result = i18n(content.text)
				if content.values.time then
					local nextTime = tostring(content.values.time) .. ":00"
					_ENV = content.text
					content.text.hours = nextTime
					local nextTimeStr = i18n("master_text_04", content.text)
					result = result .. nextTimeStr
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.war_conquer_atk then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				content.values.name.kingdomNum = content.values.kingdomNum
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.war_conquer_def then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name, content.values.kingdomNum)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.auction_good_item_begin then
				local itemDesRead = include("itemDesRead")
				local itemName = ""
				if content.values.item then
					itemName = publicRead.getName(content.values.item)
				end
				_ENV = content.values.kingdomNum
				content.values.kingdomNum.item = itemName
				content.values.kingdomNum.num = content.values.num
				result = i18n(content.text, content.values.kingdomNum)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.auction_good_item_will_end then
				local itemDesRead = include("itemDesRead")
				local itemName = ""
				if content.values.item then
					itemName = publicRead.getName(content.values.item)
				end
				_ENV = content.values.kingdomNum
				content.values.kingdomNum.item = itemName
				content.values.kingdomNum.remainTime = content.values.remainTime
				content.values.kingdomNum.num = content.values.num
				result = i18n(content.text, content.values.kingdomNum)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.monsterpalce_superaward_normal or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.monsterpalce_superaward_elite then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.snowwolf_superaward_normal or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.snowwolf_superaward_elite then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n("Challenge_SnowWolf_text_12", content.values.name)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.tentacles_superaward_normal or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.tentacles_superaward_elite then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n("mutated_tentacles_text11", content.values.name)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build then
				local build = content.values.build
				_ENV = gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[1] = "common_text_3212"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[2] = "common_text_3212"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[3] = "common_text_3212"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[4] = "common_text_3213"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[5] = "common_text_3214"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[6] = "common_text_3215"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[7] = "common_text_3216"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[8] = "common_text_3217"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[9] = "common_text_3218"
				gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[10] = "pyramid_text_07"
				local gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build[13], keyTable = "common_text_4878", gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_build
				local key = keyTable[build]
				if key then
					local campName = worldMapDefine.getPyramidWarCampName(content.values.name)
					_ENV = SoraCheckUtf8String(content.values.nickNameOther)
					SoraCheckUtf8String(content.values.nickNameOther).name = campName
					SoraCheckUtf8String(content.values.nickNameOther).build = worldMapDefine.getPyramidbuildingName(build, content.values.buildId)
					SoraCheckUtf8String(content.values.nickNameOther).num = content.values.num
					result = i18n(key, (SoraCheckUtf8String(content.values.nickNameOther)))
				else
					result = "undefine! build = " .. tostring(build)
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.pyramid_attack_build or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.pyramid_occupy_all_build then
				local build = content.values.build
				local campName = ""
				build = build and worldMapDefine.getPyramidbuildingName(build, content.values.buildId)
				if content.values.name then
					campName = worldMapDefine.getPyramidWarCampName(content.values.name)
				end
				local time = content.values.time
				_ENV = build
				build.name = campName
				build.build = build
				build.time = time
				result = i18n(content.text, build)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.legendking_attack_build then
				local build = i18n("common_text_4242")
				_ENV = i18n(content.text, build)
				i18n(content.text, build).abbr = content.values.abbr or ""
				i18n(content.text, build).name = content.values.name
				local name = i18n("common_text_186", (i18n(content.text, build)))
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				content.values.kid.build = build
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.legendking_first_kill or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.legendking_new_king or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.legendking_will_end_early then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.starking_attack_build then
				local build = i18n("kingstarbattle_text_64")
				_ENV = content.values.kid
				content.values.kid.abbr = content.values.abbr or ""
				content.values.kid.name = content.values.name
				local name = i18n("common_text_186", content.values.kid)
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				content.values.kid.build = build
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.starking_first_kill or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.starking_new_king or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.starking_will_end_early then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.hegemon_attack_build then
				local hegemonRead = include("hegemonRead")
				local subMapType = content.values.subMapType
				local build = ""
				if subMapType then
					build = hegemonRead.getNameBySubMaptype(subMapType)
				end
				local name = ""
				if content.values.abbr then
					_ENV = SoraCheckUtf8String(content.values.nickNameOther)
					SoraCheckUtf8String(content.values.nickNameOther).abbr = content.values.abbr or ""
					SoraCheckUtf8String(content.values.nickNameOther).name = content.values.name
					name = i18n("common_text_186", (SoraCheckUtf8String(content.values.nickNameOther)))
				else
					name = content.values.name
				end
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				content.values.kid.build = build
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.hegemon_first_kill or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.hegemon_new_king or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.hegemon_will_end_early then
				local hegemonRead = include("hegemonRead")
				local subMapType = content.values.subMapType
				local build = ""
				if subMapType then
					build = hegemonRead.getNameBySubMaptype(subMapType)
				end
				local name
				if content.values.abbr then
					_ENV = content.values.kid
					content.values.kid.abbr = content.values.abbr or ""
					content.values.kid.name = content.values.name
					name = i18n("common_text_186", content.values.kid)
				else
					name = content.values.name or ""
				end
				name = SoraCheckUtf8String(name)
				if content.values.kid then
					name = name .. "#" .. content.values.kid
				end
				_ENV = content.values.kid
				content.values.kid.name = name
				content.values.kid.build = build
				result = i18n(content.text, content.values.kid)
				resultParam.isHtmlCheck = true
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.hegemon_build_will_begin then
				local hegemonRead = include("hegemonRead")
				local bid = hegemonRead.getBuildIdByActivityID(content.values.activityID)
				local build = "NA"
				if bid then
					build = hegemonRead.getName(bid)
				end
				local strKey = content.text
				if strKey == "" or strKey == nil then
					strKey = "NA"
				end
				_ENV = content.values.kid
				content.values.kid.build = build
				result = i18n(strKey, content.values.kid)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.remains_war_occupation then
				local remainsWarRead = include("remainsWarRead")
				local teamName = remainsWarRead.getCampName(content.values.camp or 1)
				local teamId = content.values.teamId
				if teamId and teamId == allianceMgr:getOwnTeamID() then
					_ENV = strKey
					strKey.teamName = teamName
					result = i18n("remains_text_104", strKey)
				else
					_ENV = strKey
					strKey.teamName = teamName
					result = i18n("remains_text_305", strKey)
				end
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nafu_luky_number then
				_ENV = content.values.teamId
				content.values.teamId.lord = content.values.name
				content.values.teamId.num = content.values.luckyNumber
				content.values.teamId.coin = content.values.luckyGold
				result = i18n("godGift_text_13", content.values.teamId)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nafu_gold_pool_reach then
				_ENV = content.values.teamId
				content.values.teamId.var = content.values.gold
				result = i18n("godGift_text_26", content.values.teamId)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.koh_migrate_spec_invited_player_move_in then
				_ENV = content.values.teamId
				content.values.teamId.var1 = content.values.nickname
				result = i18n("announcement_acrossMove_text05", content.values.teamId)
			elseif content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_king_publish_policy or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_king_publish_decree or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_trick_fail or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_king_recall_official or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_king_monitor or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_king_allocate or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_tax_from_kingdom or content.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.parliament_tax_to_kingdom then
				result = nil
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_finish_occupy_common then
				local values = content.values
				local nebulaWarRead = include("nebulaWarRead")
				local buildName = nebulaWarRead.getBuildNameByBuildId(values.buildId)
				if values.camp == NEBULA_WAR_CAMP.NORTH then
					_ENV = strKey
					strKey.build = buildName
					strKey.name = values.name
					result = i18n("nebula_war_text_0442", strKey)
				else
					_ENV = strKey
					strKey.build = buildName
					strKey.name = values.name
					result = i18n("nebula_war_text_0443", strKey)
				end
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_will_end_early then
				local values = content.values
				local round = values.round
				local time = math.floor(values.totalSecs / 60)
				local constantRead = include("constantRead")
				local time1 = constantRead.getConstValue("NEBULA_WARS_EARLY_TERMINATION_HINTTIME", 0)
				time1 = math.floor(time1 / 60)
				if round and 4 <= round then
					_ENV = content.values.name
					content.values.name.name = values.name
					content.values.name.time = time
					content.values.name.time1 = time1
					result = i18n("nebula_war_text_0336", content.values.name)
				else
					_ENV = content.values.name
					content.values.name.name = values.name
					content.values.name.time = time
					content.values.name.time1 = time1
					result = i18n("nebula_war_text_0335", content.values.name)
				end
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_palace_protected_end then
				local nebulaWarRead = include("nebulaWarRead")
				local campName = nebulaWarRead.getWarCampName(content.values.camp)
				_ENV = math.floor(time1 / 60)
				math.floor(time1 / 60).camp = campName
				result = i18n("nebula_war_text_0334", (math.floor(time1 / 60)))
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.remains_war_kill_army_score_limit then
				local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
				if cfg then
					local remainsWarRead = include("remainsWarRead")
					local teamName = remainsWarRead.getCampName(content.values.camp or 1)
					_ENV = i18n("nebula_war_text_0335", content.values.name)
					i18n("nebula_war_text_0335", content.values.name).teamName = teamName
					result = i18n(cfg.des, (i18n("nebula_war_text_0335", content.values.name)))
				end
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_emperor_war_palace_begin then
				local nebulaEmperorRead = include("nebulaEmperorRead")
				local buildName = nebulaEmperorRead.getBuildName(content.values.build)
				_ENV = cfg.des
				cfg.des.build = buildName
				result = i18n("nebulaemperor_text_160", cfg.des)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_emperor_war_occupy_palace then
				local nebulaWarRead = include("nebulaWarRead")
				local nebulaEmperorRead = include("nebulaEmperorRead")
				local areaAbbr = nebulaWarRead.getAreaAbbr(content.values.area)
				_ENV = i18n("nebula_war_text_0335", content.values.name)
				i18n("nebula_war_text_0335", content.values.name).abbr = areaAbbr
				i18n("nebula_war_text_0335", content.values.name).name = content.values.name
				local name = i18n("common_text_186", (i18n("nebula_war_text_0335", content.values.name)))
				local buildName = nebulaEmperorRead.getBuildName(content.values.build)
				_ENV = content.values.name
				content.values.name.name = name
				content.values.name.build = buildName
				result = i18n("nebulaemperor_text_156", content.values.name)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_emperor_war_winner then
				local nebulaWarRead = include("nebulaWarRead")
				local areaID = content.values.area
				local areaName = nebulaWarRead.getAreaName(areaID)
				local areaAbbr = nebulaWarRead.getAreaAbbr(areaID)
				_ENV = "nebulaemperor_text_156"
				;("nebulaemperor_text_156").abbr = areaAbbr
				;("nebulaemperor_text_156").name = content.values.name
				local name = i18n("common_text_186", "nebulaemperor_text_156")
				_ENV = content.values.name
				content.values.name.area = areaName
				content.values.name.name = name
				result = i18n("nebulaemperor_text_157", content.values.name)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_refresh_npc then
				local nebulaWarRead = include("nebulaWarRead")
				local monsterName = nebulaWarRead.getMonsterName(content.values.npcId)
				_ENV = i18n("common_text_186", "nebulaemperor_text_156")
				i18n("common_text_186", "nebulaemperor_text_156").name = monsterName
				i18n("common_text_186", "nebulaemperor_text_156").num = content.values.score
				result = i18n("nebula_war_text_0558", (i18n("common_text_186", "nebulaemperor_text_156")))
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_mine_npc then
				local nebulaWarRead = include("nebulaWarRead")
				local build1 = nebulaWarRead.getBuildNameByBuildId(content.values.build1)
				local build2 = nebulaWarRead.getBuildNameByBuildId(content.values.build2)
				_ENV = content.values.score
				content.values.score.build1 = build1
				content.values.score.build2 = build2
				result = i18n("nebula_war_text_0559", content.values.score)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_will_end then
				_ENV = nebulaWarRead.getBuildNameByBuildId(content.values.build2)
				nebulaWarRead.getBuildNameByBuildId(content.values.build2).time = content.values.min
				result = i18n("nebulaemperor_text_158", (nebulaWarRead.getBuildNameByBuildId(content.values.build2)))
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_defence_activity_kill_build then
				local activity_9001573_Read = include("activity_9001573_Read")
				dump(content.values, "content.values")
				local buildName = activity_9001573_Read.getBuildName(content.values.buildID)
				_ENV = "buildID"
				;("buildID").x = content.values.x - 1
				;("buildID").y = content.values.y - 1
				;("buildID").name = buildName
				dump("buildID", "content.values.buildID")
				_ENV = "content.values.buildID"
				;("content.values.buildID").x = content.values.x - 1
				;("content.values.buildID").y = content.values.y - 1
				;("content.values.buildID").name = buildName
				result = i18n("Celestial_defense_text_032", "content.values.buildID")
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.ramadan_salyut_super_reward then
				local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
				if cfg then
					_ENV = "getSplitName"
					;("getSplitName").nickName = content.values.name
					;("getSplitName").allianceAbb = content.values.abbr
					local showName = lordInfoCtrl:getSplitName("getSplitName")
					_ENV = "allianceAbb"
					;("allianceAbb").name = showName
					;("allianceAbb").num = content.values.sultanCoinValue
					result = i18n(cfg.des, "allianceAbb")
				end
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.pyramid_supply_arrival then
				local campName = worldMapDefine.getPyramidWarCampName(content.values.camp)
				_ENV = cfg.des
				cfg.des.camp = campName
				result = i18n("pyramid_text_123", cfg.des)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_occupy_palace or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_winner or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_star_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_support_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_star_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_support_value or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_viewer_gift then
				local nebulaAllStarUtil = include("nebulaAllStarUtil")
				result = nebulaAllStarUtil.parseChatContentText(content)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_start or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_stop or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_end or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_success or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_defence_faild or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_initCity or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_owner_change or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_palace or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_create_cave or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_cave_explore_finish or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_notice or kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_decree_gift then
				local roaringFlameWarUtil = include("roaringFlameWarUtil")
				result = roaringFlameWarUtil.parseChatContentText(content)
			elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.simulated_drill_camp_score_reach then
				local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
				if cfg then
					local values = content.values
					local simulatedDrillUtil = include("simulatedDrillUtil")
					local campName = simulatedDrillUtil.getCampName(values.camp)
					_ENV = "sultanCoinValue"
					;("sultanCoinValue").camp = campName
					;("sultanCoinValue").num = values.score
					result = i18n(cfg.des, "sultanCoinValue")
				end
			else
				local cfg = chatDesRead.getChatNoticeCfg(content.kingdomMsgType)
				if cfg and cfg.des and cfg.des ~= "" then
					if not content.values or not textParser.parseValues(content.values) then
						local _ENV, valueMap = textParser.parseValues(content.values), textParser.parseValues(content.values)
					end
					result = i18n(cfg.des, valueMap)
				else
					result = i18n(content.text, content.values)
				end
			end
		elseif content.chatSysMsgType ~= nil then
			if content.chatSysMsgType == gChatSysMsgType.res_placement then
				local superRes = content.values.superRes
				local allianceDesRead = include("allianceDesRead")
				local superResName = allianceDesRead.getBuildName(superRes)
				_ENV = valueMap
				valueMap.name = SoraCheckUtf8String(content.values.name)
				valueMap.superRes = superResName
				valueMap.k = content.values.mapId
				valueMap.x = content.values.x
				valueMap.y = content.values.y
				result = i18n(content.text, valueMap)
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.remains_war_team_invite then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraDCheckHtmlUtf8Str(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.boss_rally then
				local bossType = content.values.bossType
				local bossName = worldMapDefine.getWorldBossName(bossType, content.values.lv)
				bossName = bossName and i18n(bossName)
				_ENV = "lv"
				;("lv").name = i18n("common_text_142")
				;("lv").lv = content.values.lv
				;("lv").bossName = bossName or "unDefined"
				result = i18n(content.text, "lv")
				if bossType == gBossType.atlantisWarWlyn or bossType == gBossType.atlantisWarSd then
					_ENV = "lv"
					;("lv").bossName = bossName
					result = i18n("atlantiswar_text_0264", "lv")
				end
			elseif content.chatSysMsgType == gChatSysMsgType.player_rally then
				local name = mailFunctions:getWrappedName(content.values.abbr, content.values.name)
				name = SoraCheckUtf8String(name)
				_ENV = content.values.name
				content.values.name.name = name
				result = i18n(content.text, content.values.name)
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.ancient_treasure_build_rally then
				_ENV = "ancient_treasure_build_rally"
				;("ancient_treasure_build_rally").k = content.values.mapId
				;("ancient_treasure_build_rally").x = content.values.buildX
				;("ancient_treasure_build_rally").y = content.values.buildY
				result = i18n(content.text, "ancient_treasure_build_rally")
			elseif content.chatSysMsgType == gChatSysMsgType.ancient_treasure_building then
				_ENV = "ancient_treasure_building"
				;("ancient_treasure_building").k = content.values.mapId
				;("ancient_treasure_building").x = content.values.buildX
				;("ancient_treasure_building").y = content.values.buildY
				result = i18n(content.text, "ancient_treasure_building")
			elseif content.chatSysMsgType == gChatSysMsgType.build_rally then
				local buildName = "unDefined"
				local mapObjType = content.values.mapObjType
				if mapObjType == gMapObjTypeDef.mapObjTypeBattery then
					if content.values.buildId then
						local palaceInfoRead = include("palaceInfoRead")
						buildName = palaceInfoRead.getBatteryName(content.values.buildId)
					else
						buildName = i18n("common_text_840")
					end
				elseif mapObjType == gMapObjTypeDef.mapObjTypeCastale then
					buildName = i18n("common_text_839")
				elseif mapObjType == gMapObjTypeDef.mapObjTypeLegendLord then
					if content.values.buildType then
						local hegemonRead = include("hegemonRead")
						buildName = hegemonRead.getNameBySubMaptype(content.values.buildType)
					elseif worldMapDefine.isKingStarMapId(content.values.mapId) then
						buildName = i18n("kingstarbattle_text_64")
					else
						buildName = i18n("common_text_4242")
					end
					if buildName == "" or buildName == nil then
						buildName = i18n("common_text_4242")
					end
				elseif mapObjType == gMapObjTypeDef.mapObjTypeRemainsWar then
					buildName = i18n("remains_name_04")
				elseif mapObjType == gMapObjTypeDef.mapTypeRadianceWarPalace or mapObjType == gMapObjTypeDef.mapTypeRadianceWarGate or mapObjType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
					local radianceWarRead = include("radianceWarRead")
					buildName = radianceWarRead.getBuildName(mapObjType, content.values.buildId)
				elseif mapObjType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
					local buildType = content.values.buildType
					if buildType then
						buildName = worldMapDefine.getPyramidbuildingName(buildType, content.values.buildId)
					end
				elseif mapObjType == gMapObjTypeDef.mapObjTypeFortress then
					buildName = i18n("common_text_2859")
				elseif mapObjType == gMapObjTypeDef.mapObjNewTrialCity then
					local buildType = content.values.buildType
					if buildType == _G.gMapNewTrialBuildType.subMapTypeDVWBattery then
						buildName = i18n("common_text_840")
					else
						buildName = i18n("devilvalley_text_48")
					end
				elseif mapObjType == gMapObjTypeDef.mapTypeATBuilding then
					buildName = i18n("AncienTreasure_buildname_01")
				elseif mapObjType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
					local AMBC = require_data("atlantiswar_map_build_config").data
					buildName = i18n(AMBC[content.values.buildId].name)
				elseif mapObjType == gMapObjTypeDef.stronghold then
					local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
					local buildId = content.values.buildId
					local buildInfo = allianceStrongholdMineRead.getGateClientCfg(buildId)
					buildName = i18n(buildInfo.name)
				else
					local mapObjUtil = include("mapObjUtil")
					buildName = mapObjUtil.getBuildName(mapObjType, content.values.buildType, content.values.buildId)
				end
				_ENV = mapObjType
				mapObjType.name = buildName
				result = i18n(content.text, mapObjType)
			elseif content.chatSysMsgType == gChatSysMsgType.res_complete then
				local superRes = content.values.superRes
				local allianceDesRead = include("allianceDesRead")
				local superResName = allianceDesRead.getBuildName(superRes)
				_ENV = content.values.buildType
				content.values.buildType.superRes = superResName
				content.values.buildType.k = content.values.mapId
				content.values.buildType.x = content.values.x
				content.values.buildType.y = content.values.y
				result = i18n(content.text, content.values.buildType)
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_feast_share then
				result = i18n("tips_place_feast_unionChat_desc")
			elseif content.chatSysMsgType == gChatSysMsgType.pet_upgrade_rank then
				_ENV = "pet_upgrade_rank"
				;("pet_upgrade_rank").rank = content.values.rank
				result = i18n("common_text_2964", "pet_upgrade_rank")
			elseif content.chatSysMsgType == gChatSysMsgType.pet_reach_max_level then
				result = i18n("common_text_2965")
			elseif content.chatSysMsgType == gChatSysMsgType.pet_share then
				result = i18n("common_text_2966")
			elseif content.chatSysMsgType == gChatSysMsgType.hero_share then
				result = i18n("hero_text_103")
			elseif content.chatSysMsgType == gChatSysMsgType.arms_share then
				result = i18n("artifact_text_33")
			elseif content.chatSysMsgType == gChatSysMsgType.remains_war_share_settle_info then
				local remainsWarRead = include("remainsWarRead")
				local remainsWarltCtrl = include("remainsWarltCtrl")
				local point = content.values.gradePoints or 0
				local strpoint = string.formatnumberthousands(point)
				local score = remainsWarltCtrl.getRuinsWarGrade(point)
				local strScore = remainsWarRead.getScoreName(score)
				_ENV = "mapId"
				;("mapId").title = strScore
				;("mapId").point = strpoint
				result = i18n("remains_text_200", "mapId")
			elseif content.chatSysMsgType == gChatSysMsgType.remains_war_share_season_info then
				local danID = content.values.seasonInfo.segment
				local remainsWarRead = include("remainsWarRead")
				local strTitle = remainsWarRead.getDanName(danID)
				_ENV = remainsWarRead.getScoreName(score)
				remainsWarRead.getScoreName(score).title = strTitle
				result = i18n("remains_text_187", (remainsWarRead.getScoreName(score)))
			elseif content.chatSysMsgType == gChatSysMsgType.pyramid_register_success or content.chatSysMsgType == gChatSysMsgType.pyramid_post_season_time then
				local beginTime = content.values.beginTime
				local endTime = content.values.endTime
				local beginTimeStr = os.date("!%Y-%m-%d %H:%M:%S", beginTime)
				local endTimeStr = os.date("!%Y-%m-%d %H:%M:%S", endTime)
				_ENV = "title"
				;("title").beginTime = beginTimeStr
				;("title").endTime = endTimeStr
				result = i18n(content.text, "title")
			elseif content.chatSysMsgType == gChatSysMsgType.share_voice_room then
				_ENV = "share_voice_room"
				;("share_voice_room").roomName = content.values.roomName
				result = i18n("common_text_3298", "share_voice_room")
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_treasure then
				local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
				local name = allianceTreasureltCtrl.getTreasureName(content.values.teasureID, content.values.quality)
				_ENV = "quality"
				;("quality").name = name
				result = i18n("allitreas_text_21", "quality")
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_official_appoint then
				local allianceDesRead = include("allianceDesRead")
				local officialName = allianceDesRead.getOfficialName(content.values.official)
				_ENV = "quality"
				;("quality").name = SoraDCheckHtmlUtf8Str(content.values.name)
				;("quality").office = officialName
				result = i18n("alliance_office_text_23", "quality")
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_player_gift then
				local v = content.values
				local aAbbr = SoraDCheckHtmlUtf8Str(v.aAbbr or "")
				local bAbbr = SoraDCheckHtmlUtf8Str(v.bAbbr or "")
				local aName = SoraDCheckHtmlUtf8Str(v.aName or "")
				local bName = SoraDCheckHtmlUtf8Str(v.bName or "")
				local kingPacksRead = include("kingPacksRead")
				local packName = i18n(kingPacksRead.getItem(v.id).name)
				_ENV = "point"
				;("point").aalliance = aAbbr
				;("point").alord = aName
				;("point").balliance = bAbbr
				;("point").blord = bName
				;("point").giftName = packName
				result = i18n(content.text, "point")
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.hero_prison_execute then
				local tb = content.values
				local mailFunctions = include("mailFunctions")
				local name = mailFunctions:getWrappedName(tb.abbr, tb.name, tb.kid)
				name = SoraDCheckHtmlUtf8Str(name)
				local target = mailFunctions:getWrappedName(tb.targetAbbr, tb.targetName, tb.targetKid)
				target = SoraDCheckHtmlUtf8Str(target)
				local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
				local heroID = tb.heroID
				local heroInfo = heroltCtrl.getHeroInfo(heroID)
				local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
				local quality = heroltCtrl.getHeroQuality2Word(tb.quality)
				_ENV = nil
				;(nil).name = name
				;(nil).target = target
				;(nil).hero = heroName
				;(nil).quality = quality
				result = i18n(content.text, nil)
				resultParam.isHtmlCheck = true
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_counter_sys then
				local tb = content.values
				if tb.uid then
					local mailFunctions = include("mailFunctions")
					local name = mailFunctions:getWrappedName(tb.abbr, tb.name)
					name = SoraDCheckHtmlUtf8Str(name)
					local member = SoraDCheckHtmlUtf8Str(tb.member)
					_ENV = heroltCtrl.getHeroInfo(heroID)
					heroltCtrl.getHeroInfo(heroID).name1 = name
					heroltCtrl.getHeroInfo(heroID).name2 = member
					result = i18n(content.text, (heroltCtrl.getHeroInfo(heroID)))
					resultParam.isHtmlCheck = true
				end
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_own_counter_sys then
				dump(content, "gChatSysMsgType.alliance_own_counter_sys", 10)
				local tb = content.values
				if tb.uid and content.text ~= "" then
					local mailFunctions = include("mailFunctions")
					local name = mailFunctions:getWrappedName(tb.abbr, tb.nickName)
					name = SoraDCheckHtmlUtf8Str(name)
					_ENV = tb.nickName
					tb.nickName.name = name
					result = i18n(content.text, tb.nickName)
					resultParam.isHtmlCheck = true
				end
			elseif content.chatSysMsgType == gChatSysMsgType.alliance_beast_rally or content.chatSysMsgType == gChatSysMsgType.alliance_beast_call or content.chatSysMsgType == gChatSysMsgType.alliance_beast_trial then
				local petType = content.values.beastType
				local petName = alliancePetRead.getName(petType)
				_ENV = content.text
				content.text.PetName = petName
				result = i18n(content.text, content.text)
			elseif content.chatSysMsgType == gChatSysMsgType.ancient_treasure_build_rally then
				_ENV = "ancient_treasure_build_rally"
				;("ancient_treasure_build_rally").k = content.values.mapId
				;("ancient_treasure_build_rally").x = content.values.buildX
				;("ancient_treasure_build_rally").y = content.values.buildY
				result = i18n(content.text, "ancient_treasure_build_rally")
			elseif content.chatSysMsgType == gChatSysMsgType.monsterfiesta_refresh then
				result = i18n(content.text)
				if content.values.time then
					local nextTime = tostring(content.values.time) .. ":00"
					_ENV = content.values.buildY
					content.values.buildY.hours = nextTime
					local nextTimeStr = i18n("master_text_04", content.values.buildY)
					result = result .. nextTimeStr
				end
			elseif content.chatSysMsgType == gChatSysMsgType.wrath_beast_rally then
				local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
				local beastData = wrathBeastCtrl:getWrathBeastData(content.values.bossType)
				local bossType = beastData.bossType
				local bossName = worldMapDefine.getWorldBossName(bossType)
				_ENV = heroltCtrl.getHeroInfo(heroID)
				heroltCtrl.getHeroInfo(heroID).lv = content.values.lv
				heroltCtrl.getHeroInfo(heroID).bossName = i18n(bossName)
				result = i18n(content.text, (heroltCtrl.getHeroInfo(heroID)))
			elseif content.chatSysMsgType == gChatSysMsgType.collect_torch_require then
				local itemDesRead = include("itemDesRead")
				_ENV = worldMapDefine.getWorldBossName(bossType)
				worldMapDefine.getWorldBossName(bossType).name1 = itemDesRead.getName(content.values.fragmentID)
				worldMapDefine.getWorldBossName(bossType).name2 = itemDesRead.getName(content.values.mapID)
				result = i18n("treasuremap_text_01", (worldMapDefine.getWorldBossName(bossType)))
			elseif content.chatSysMsgType == gChatSysMsgType.ann_campfire_position then
				_ENV = "ann_campfire_position"
				;("ann_campfire_position").x = content.values.pos.x - 1
				;("ann_campfire_position").y = content.values.pos.y - 1
				result = i18n(content.text, "ann_campfire_position")
			elseif content.chatSysMsgType == gChatSysMsgType.pos_share then
				result = chatDataParser.playerchatRoomSharePosData(content.values)
			elseif content.chatSysMsgType == gChatSysMsgType.hero_prison_share then
				local tb = content.values
				if tb then
					local mailFunctions = include("mailFunctions")
					local target = mailFunctions:getWrappedName(tb.targetAbbr, tb.targetName, tb.targetKid)
					target = SoraDCheckHtmlUtf8Str(target)
					_ENV = tb.targetName
					tb.targetName.var = target
					tb.targetName.var1 = i18n("common_name_01")
					result = i18n("capture_heroes_text_01", tb.targetName)
					resultParam.isHtmlCheck = true
				end
			elseif content.chatSysMsgType == gChatSysMsgType.nebula_allstar_system then
				local nebulaAllStarUtil = include("nebulaAllStarUtil")
				result = nebulaAllStarUtil.parseChatSysText(content)
			elseif content.chatSysMsgType == gChatSysMsgType.plant_data_palm_up_lv then
				_ENV = "plant_data_palm_up_lv"
				;("plant_data_palm_up_lv").level = content.values.lv
				result = i18n("datepalm_tree_text37", "plant_data_palm_up_lv")
			elseif content.chatSysMsgType == gChatSysMsgType.lion_paradise_up_lv then
				_ENV = "lion_paradise_up_lv"
				;("lion_paradise_up_lv").level = content.values.lv
				result = i18n("lion_park_text22", "lion_paradise_up_lv")
			elseif content.chatSysMsgType == gChatSysMsgType.bubble_grange_up_lv then
				_ENV = "bubble_grange_up_lv"
				;("bubble_grange_up_lv").level = content.values.lv
				;("bubble_grange_up_lv").activity = ""
				result = i18n("bubble_farm_mail5", "bubble_grange_up_lv")
			elseif content.chatSysMsgType == gChatSysMsgType.honor_back_activity then
				result = i18n("Honor_return_chat_text1")
			elseif content.chatSysMsgType == gChatSysMsgType.corban_market_reward then
				local itemID = include("constantRead").getConstValue("EIDAL_MARKET_BROADCAST_ITEM")
				_ENV = "activity"
				;("activity").item = publicRead.getName(itemID)
				;("activity").num = content.values.count
				result = i18n("eidal_market_text7", "activity")
			elseif content.chatSysMsgType == gChatSysMsgType.eid_celebration_activity then
				local taskID = content.values.taskID
				local cfg = include("activity_9001643_Read").getTaskCfg(taskID)
				_ENV = content.values.count
				content.values.count.taskname = i18n(cfg.task_name)
				result = i18n("eidal_celebration_text28", content.values.count)
			elseif content.chatSysMsgType == gChatSysMsgType.roaring_flame_system then
				local roaringFlameWarUtil = include("roaringFlameWarUtil")
				result = roaringFlameWarUtil.parseChatSysText(content)
			else
				if not content.values or not textParser.parseValues(content.values) then
					local _ENV, valueMap = textParser.parseValues(content.values), textParser.parseValues(content.values)
				end
				local cfg = chatDesRead.getChatSysCfg(content.chatSysMsgType)
				if cfg and valueMap and #cfg.des > 0 then
					result = i18n(cfg.des, valueMap)
				elseif content.text and content.text ~= "" then
					result = i18n(content.text, valueMap)
				else
					local _result = chatDataParser.parseChatContentText2(content)
					if _result then
						result = _result
					end
				end
			end
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RED_PACKAGE_ACTIVITY then
			local rechargeRead = include("rechargeRead")
			local giftid = content.values.giftid
			local giftStyle = rechargeRead.getPageViewData(giftid)
			local giftname = ""
			if giftStyle and giftStyle.activeName ~= nil and giftStyle.activeName ~= "" then
				giftname = i18n(giftStyle.activeName)
			end
			_ENV = i18n(cfg.task_name)
			i18n(cfg.task_name).giftname = giftname
			result = i18n(content.text, (i18n(cfg.task_name)))
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			result = ""
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			if type(content.text) == "table" then
				result = content.text[GameLanguageCopy] or content.text.en or "undefined"
			end
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			if type(content.text) == "table" then
				result = content.text[GameLanguageCopy] or content.text.en or "undefined"
			end
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.GIFT_PACKAGE_ACTIVIT then
			if type(content.text) == "table" then
				result = content.text[GameLanguageCopy] or content.text.en or "undefined"
			end
		elseif content.redPacketInfo and content.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			result = i18n(content.text)
		else
			dump("not define")
		end
	end
	return result
end
function chatDataParser.parseChatContentText2(content)
	if content.chatSysMsgType ~= nil then
		local chatSysMsgType = content.chatSysMsgType
		if chatSysMsgType == gChatSysMsgType.gathering_feast_2024_position then
			_ENV = nil
			;(nil).x = content.values.x
			;(nil).y = content.values.y
			local posStr = i18n("common_text_2155", nil)
			_ENV = content.values.y
			content.values.y.coord = posStr
			return i18n("gathering_activity_text8", content.values.y)
		end
		if chatSysMsgType == gChatSysMsgType.bubble_carnival_exchange_post then
			local need = content.values.need
			local offer = content.values.offer
			_ENV = nil
			;(nil).item1 = publicRead.getName(offer)
			_ENV, _ENV, (nil).item2 = need, publicRead.getName(need), publicRead.getName(need)
			_ENV, publicRead.getName(need).item1, need.color = need, need, "#BE2828"
			publicRead.getName(need).item2, need.color = need, "#BE2828"
			return i18n_html("bubble_party_text_32", nil, (publicRead.getName(need)))
		end
	end
	if content.text and content.text ~= "" then
		return i18n(content.text, content.values)
	end
end
function chatDataParser.parseChatFightReport(dataItem, isSDK)
	local result = "I share a fight report.(to be open)"
	local mail = include("mail").new(dataItem.content)
	if mail == nil then
		return result .. " error "
	end
	local mailType = mail.property.mailType
	local source = mail.property.source
	if mailType == gMailType.BATTLE_REPORT or mailType == gMailType.SCOUT_REPORT then
		if gMailSetTypeFunc.checkIsScoutMailSource(source) then
			local contentData
			local isFromBrief = false
			if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
				contentData = mail.property.brief
				isFromBrief = true
				print("检测是到战斗简报")
			else
				contentData = mail.property.data
			end
			local strName
			if source == gMailSource.SCOUT_FORTRESS_SUCCESS then
				_ENV = nil
				;(nil).name = i18n("common_text_2859")
				result = i18n("common_text_933", nil)
			elseif source == gMailSource.SCOUT_ALLIANCEBUILD_SUCCESS or source == gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS or source == gMailSource.SCOUT_RADIANCE_BUILD_SUCCESS or source == gMailSource.SCOUT_LEGENDLORD_SUCCESS then
				local targetMapObj = contentData.targetMapObj
				local buildName = mailFunctions:getMapBuildName(targetMapObj)
				local allianceInfo = contentData.allianceInfo
				if allianceInfo == nil then
					allianceInfo, _ENV = targetMapObj, targetMapObj
				end
				if not contentData.uinfo then
					contentData.uinfo, _ENV = contentData.uinfo, contentData.uinfo
				end
				local nickName = contentData.uinfo.nickName
				strName = mailFunctions:getWrappedName(allianceInfo.abbr, nickName, contentData.uinfo.kid)
				strName = SoraCheckUtf8String(strName)
				_ENV = allianceInfo.abbr
				allianceInfo.abbr.name = strName .. " " .. buildName
				result = i18n("common_text_933", allianceInfo.abbr)
			else
				if contentData.allianceInfo then
					strName = mailFunctions:getWrappedName(contentData.allianceInfo.abbr, contentData.uinfo.nickName)
				else
					strName = contentData.uinfo.nickName
				end
				strName = SoraCheckUtf8String(strName)
				_ENV = contentData.allianceInfo.abbr
				contentData.allianceInfo.abbr.name = strName
				result = i18n("common_text_933", contentData.allianceInfo.abbr)
			end
		elseif gMailSetTypeFunc.checkIsBattleMailSource(source) then
			local contentData
			local isFromBrief = false
			if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
				contentData = mail.property.brief
				isFromBrief = true
				print("检测是到战斗简报")
			else
				contentData = mail.property.data
			end
			local mailSender = dataItem.from
			local isAttack = true
			if isFromBrief == true then
				isAttack = contentData.isSelfInAttack
			else
				isAttack = mailFunctions:getIsPlayerAttack(mailSender, contentData.battleInfo)
			end
			mail.sender = mailSender
			local fightSuccess = i18n("mail_text_13")
			local fightFailure = i18n("mail_text_14")
			allianceDesRead = contentData.battleInfo
			contentData.battleInfo[1] = isAttack
			contentData.battleInfo[2] = source
			dump(contentData.battleInfo, "isAttack,source")
			if isAttack then
				local otherName
				if source == gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS or source == gMailSource.ATTACK_ALLIANCEBUILD_FAILED then
					local buildId = contentData.subMapType
					local buildName = allianceDesRead.getBuildName(buildId)
					local otherPlayer = contentData.playerInfo2
					if otherPlayer.allianceInfo then
						otherName = mailFunctions:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
					else
						otherName = buildName
					end
					result = otherName
				elseif source == gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS or source == gMailSource.ATTACK_PYRAMIDBUILD_FAILED then
					local buildName = mailFunctions:getMapBuildName(contentData)
					otherName = buildName
					result = otherName
				elseif source == gMailSource.ATTACK_LEGENDLORD_SUCCESS or source == gMailSource.ATTACK_LEGENDLORD_FAILED then
					local buildName = mailFunctions:getMapBuildName(contentData)
					local otherPlayer = contentData.playerInfo2
					if otherPlayer.allianceInfo then
						otherName = mailFunctions:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
					else
						otherName = buildName
					end
					result = otherName
				elseif source == gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS or source == gMailSource.ATTACK_RADIANCE_BUILD_FAILED then
					local buildName = mailFunctions:getMapBuildName(contentData)
					local otherPlayer = contentData.playerInfo2
					if otherPlayer.allianceInfo then
						otherName = mailFunctions:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
					else
						otherName = buildName
					end
					result = otherName
				elseif source == gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS or source == gMailSource.ATTACK_NEBULA_DEFENCE_FAILED then
					if contentData.mapType == gWorldTypeServerDef.mapTypeKingdomLevelBuild then
						local buildName = i18n("Celestial_defense_text_076")
						otherName = buildName
					else
						local activity_9001573_Read = include("activity_9001573_Read")
						local buildName = activity_9001573_Read.getBuildName(contentData.objId)
						otherName = buildName
					end
					dump(contentData.objId, "gMailSource.ATTACK_NEBULA_DEFENCE_FAILED contentData", 10)
				else
					local otherPlayer = contentData.playerInfo2
					if otherPlayer.allianceInfo then
						otherName = mailFunctions:getWrappedName(otherPlayer.allianceInfo.abbr, otherPlayer.uinfo.nickName)
					else
						otherName = otherPlayer.uinfo.nickName
					end
				end
				local fightResult = fightSuccess
				if contentData.result == 1 then
					fightResult = fightFailure
				end
				otherName = SoraCheckUtf8String(otherName)
				_ENV = otherPlayer.allianceInfo.abbr
				otherPlayer.allianceInfo.abbr.name = otherName
				otherPlayer.allianceInfo.abbr.result = fightResult
				result = i18n("common_text_932", otherPlayer.allianceInfo.abbr)
			else
				local otherPlayer = contentData.playerInfo1
				local otherName
				if otherPlayer.allianceInfo then
					otherName = mailFunctions:getWrappedName(otherPlayer.allianceInfo.abbr, otherPlayer.uinfo.nickName)
				else
					otherName = otherPlayer.uinfo.nickName
				end
				if source == gMailSource.NEBULA_DEFENCE_USER_DEFENCE_SUCCESS or source == gMailSource.NEBULA_DEFENCE_USER_DEFENCE_FAILED then
					local buildName = i18n("Celestial_defense_text_076")
					otherName = buildName
				end
				local fightResult = fightSuccess
				if contentData.result == 0 then
					fightResult = fightFailure
				end
				otherName = SoraCheckUtf8String(otherName)
				_ENV = otherPlayer.uinfo.nickName
				otherPlayer.uinfo.nickName.name = otherName
				otherPlayer.uinfo.nickName.result = fightResult
				result = i18n("common_text_934", otherPlayer.uinfo.nickName)
			end
		end
	end
	return result
end
function chatDataParser.parsePyramidShare(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		local itemDesRead = include("itemDesRead")
		local itemid = content.item
		local itemName = itemDesRead.getName(tonumber(itemid))
		local num = content.num
		local multiple = content.multiple or 0
		local floor = content.floor or 0
		if floor == 6 and 1 < multiple then
			_ENV = tonumber(itemid)
			tonumber(itemid).multiple = multiple
			tonumber(itemid).item = itemName
			tonumber(itemid).num = num
			result = i18n("common_text_2612", tonumber(itemid))
		elseif 1 < multiple then
			_ENV = tonumber(itemid)
			tonumber(itemid).multiple = multiple
			tonumber(itemid).item = itemName
			tonumber(itemid).num = num
			result = i18n("common_text_2610", tonumber(itemid))
		else
			_ENV = tonumber(itemid)
			tonumber(itemid).item = itemName
			tonumber(itemid).num = num
			result = i18n("common_text_1483", tonumber(itemid))
		end
	end
	return result
end
function chatDataParser.parseEliminateGameShare(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		_ENV = nil
		;(nil).step = content.totalUsedSteps
		result = i18n("common_text_2558", nil)
	end
	return result
end
function chatDataParser.parseStarsWishGameShare(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		_ENV = nil
		;(nil).step = content.totalUsedSteps
		result = i18n("nebula_stars_wishing_text36", nil)
	end
	return result
end
function chatDataParser.parseRedPacket(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		local name = SoraCheckUtf8String(content.uinfo.nickName)
		_ENV = nil
		;(nil).name = name
		result = i18n("common_text_1788", nil)
	end
	return result
end
function chatDataParser.parseDevilValleyShare(dataItem)
	local result = ""
	local newTrialRead = include("newTrialRead")
	local content = dataItem.content
	if content then
		local name = newTrialRead.getName(content.challengeLv)
		local info = newTrialRead.getChallengeInfo(content.challengeLv)
		if not info then
			_ENV = nil
			;(nil).des = ""
			return i18n("common_text_1437", nil)
		end
		local hexColorStr = SoraDRGB2HtmlColor(info.color)
		_ENV = nil
		;(nil).color = hexColorStr
		local nameRich = SoraDWrapHtmlTagByStyle(name, nil)
		_ENV = nil
		;(nil).name = nameRich
		result = i18n("devilvalley_message_01", nil)
	end
	return result
end
function chatDataParser.parseKingOfGlory(dataItem)
	local result = ""
	local content = dataItem.content
	if content and content.reward then
		_ENV, result = content.reward, "kingglory_text_02"
		local content.reward.value, parTable = content.power, content.reward
		for k, v in pairs(content.reward) do
			local itemName = ""
			if not SoraDJudgeResOrItem(v.id) then
				local resDesRead = include("resDesRead")
				itemName = resDesRead.getName(v.id)
			else
				local itemDesRead = include("itemDesRead")
				itemName = itemDesRead.getName(v.id)
			end
			parTable["item" .. k] = itemName
			parTable["num" .. k] = v.count
		end
		result = i18n(result, parTable)
	end
	return result
end
function chatDataParser.parseChatRoomSysOp(dataItem)
	local strFormat = ""
	local systemType = dataItem.data.systemType
	if systemType == gChatRoomSystemType.ADD_MEMBER then
		strFormat = "common_text_2039"
	elseif systemType == gChatRoomSystemType.DEL_MEMBER then
		strFormat = "common_text_2041"
	elseif systemType == gChatRoomSystemType.QUIT_MEMBER then
		strFormat = "common_text_2048"
	elseif systemType == gChatRoomSystemType.MODIFY_NAME then
		strFormat = "common_text_2042"
	elseif systemType == gChatRoomSystemType.CREATE then
		strFormat = "common_text_3525"
	end
	if not dataItem.data.opPlayer then
		return strFormat
	end
	local strPlayer = dataItem.data.opPlayer.nickName
	if chatFunctions.getIsPlayerSelf(dataItem.data.opPlayer.uid) then
		strPlayer = i18n("common_text_2043")
	end
	local strTargets = ""
	if dataItem.data.targetPlayers then
		for i, v in ipairs(dataItem.data.targetPlayers) do
			local nickName = v.nickName or ""
			if chatFunctions.getIsPlayerSelf(v.uid) then
				nickName = i18n("common_text_2043")
			end
			strTargets = strTargets .. nickName
			if i < #dataItem.data.targetPlayers then
				strTargets = strTargets .. ","
			end
		end
	end
	local opType
	if opType == gChatRoomSystemType.MODIFY_NAME then
		strTargets = dataItem.data.newname or ""
	end
	strPlayer = SoraCheckUtf8String(strPlayer)
	strTargets = SoraCheckUtf8String(strTargets)
	if systemType == gChatRoomSystemType.ADD_MEMBER or systemType == gChatRoomSystemType.DEL_MEMBER or systemType == gChatRoomSystemType.CREATE then
		_ENV = nil
		;(nil).owner = strPlayer
		;(nil).targets = strTargets
		strFormat = i18n(strFormat, nil)
	elseif systemType == gChatRoomSystemType.QUIT_MEMBER then
		_ENV = nil
		;(nil).owner = strPlayer
		strFormat = i18n(strFormat, nil)
	elseif systemType == gChatRoomSystemType.MODIFY_NAME then
		_ENV = nil
		;(nil).owner = strPlayer
		;(nil).newName = dataItem.data.newName
		strFormat = i18n(strFormat, nil)
	end
	return strFormat
end
function chatDataParser.wrapDateData(dataItem)
	_ENV = nil
	;(nil).chatType = gChatTypeUI.kingdom
	;(nil).dataType = 0
	;(nil).align = -1
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = 0
	;(nil).alliance = "NoA"
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = 0
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).labelSize, localData
	localData.nodeType = gChatNodeType.date
	localData.chatType = dataItem.chatType
	localData.dataType = gChatDataType.dataType_date
	localData.content = "2015-5-15"
	localData.align = 0
	if dataItem.chatId == nil then
		dump(dataItem, "chatDataParser.wrapDateData(dataItem)")
	end
	localData.chatId = dataItem.chatId
	localData.playerId = dataItem.playerId
	localData.imageId = dataItem.imageId
	localData.nickName = SoraCheckUtf8String(dataItem.nickName)
	localData.isSysMsg = false
	localData.sysType = 0
	localData.vipLv = dataItem.vip
	if localData.vipLv == 0 then
		localData.isVip = false
	else
		localData.isVip = true
	end
	localData.date = os.date("%Y-%m-%d", dataItem.date or os.time())
	localData.time = dataItem.time
	localData.alliance = dataItem.alliance or "NoA"
	return localData
end
function chatDataParser.wrapMailData(mailData)
	_ENV = nil
	;(nil).chatType = gChatTypeUI.mail
	;(nil).dataType = 0
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = nil
	;(nil).alliance = nil
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = "2015-5-15"
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).align, localData = -1, nil
	dump(mailData.data, "chatDataParserwrapMailData", 10)
	localData.customData = mailData.data
	localData.content = mailData.data.content
	localData.textType = gChatTextType.text_plain
	if mailData.data.contentType == gChatMailContentType.content_text then
		localData.dataType = gChatDataType.dataType_text
	elseif mailData.data.contentType == gChatMailContentType.content_emo then
		localData.dataType = gChatDataType.dataType_emotion
		localData.packetId = localData.customData.packetId or defaultPacketId
		localData.emoticonId = localData.customData.content
	elseif mailData.data.contentType == gChatMailContentType.content_audio then
		localData.dataType = gChatDataType.dataType_audio
		localData.audioLen = mailData.data.audioLen
		localData.audioId = mailData.data.audioId
	elseif mailData.data.contentType == gMailNPCContentType.Content_Share_Mail then
		localData.dataType = gChatDataType.dataType_fightReport
		localData.customData = mailData.data.values
		localData.customData.playerInfo = mailData.data.playerInfo
		_ENV = mailData.data.playerInfo
		mailData.data.playerInfo.content = mailData.data.values
		mailData.data.playerInfo.from = mailData.sender
		local result = chatDataParser.parseChatFightReport(mailData.data.playerInfo)
		localData.content = string.htmlspecialchars(result)
		localData.isSysMsg = true
	end
	localData.chatIndex = mailData.data.chatIndex
	if mailData.data.chatSysMsgType == gChatSysMsgType.pos_share then
		localData.dataType = gChatDataType.dataType_pos_share
		localData.content = chatDataParser.parseChatContentText(mailData.data)
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.hero_prison_share then
		localData.dataType = gChatDataType.dataType_hero_prison_share
		localData.isSysMsg = true
		local result = chatDataParser.parseChatContentText(mailData.data)
		localData.content = result
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.common then
		localData.content = chatDataParser.parseChatContentText(mailData.data)
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.korean_chess_room_invite then
		localData.content = chatDataParser.parseChatContentText(mailData.data)
		localData.dataType = gChatDataType.dataType_korean_chess_room_invite
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.simulated_drill_room_share then
		localData.content = chatDataParser.parseChatContentText(mailData.data)
		localData.dataType = gChatDataType.dataType_9001725
		localData.isSysMsg = true
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.flying_chess then
		localData.content = chatDataParser.parseChatContentText(mailData.data)
		localData.dataType = gChatDataType.dataType_9001731
		localData.isSysMsg = true
	elseif mailData.data.chatSysMsgType == gChatSysMsgType.manor_banquet then
		localData.content = chatDataParser.parseChatContentText(mailData.data)
		localData.dataType = gChatDataType.dataType_manor_banquet
		localData.isSysMsg = true
	end
	localData.mid = mailData.mid
	localData.isKing = mailData.data.isKing
	localData.isLegendKing = mailData.data.isLegendKing
	localData.isLegendForSepKing = mailData.data.isLegendForSepKing
	localData.isHegemon = mailData.data.isHegemon
	if mailData.data.playerInfo and mailData.data.playerInfo.sourceKID then
		localData.kid = mailData.data.playerInfo.sourceKID
	end
	local dataItem = mailData.data
	localData.customProperty, _ENV = mailData.data, mailData.data
	localData.customProperty.sysBubbleId = dataItem.bubbleId
	localData.customProperty.sysHeadWearId = dataItem.headWearId
	localData.customProperty.sysAvatarFrameId = dataItem.avatarFrameId
	localData.bubbleId = dataItem.bubbleId and chatSkinRead.getBubbleIDByCid(dataItem.bubbleId) or gBubbleId.BUBBLE_ID_NORMAL
	localData.headWearId = dataItem.headWearId and chatSkinRead.getHeadWearIDByCid(dataItem.headWearId) or gHeadWearId.HEAD_ID_NORMAL
	localData.avatarFrameId = dataItem.avatarFrameId and chatSkinRead.getHeadIDByCid(dataItem.avatarFrameId) or gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
	if localData.bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
	end
	if localData.isKing == true and localData.headWearId == gHeadWearId.HEAD_ID_NORMAL then
		localData.headWearId = gHeadWearId.HEAD_ID_KING
	end
	print("wrap mailData: sender:" .. mailData.sender)
	localData.imageId = mailData.data.playerInfo.iconID
	localData.avatarUrl = mailData.data.playerInfo.avatar
	localData.isSendToAll = mailData.data.isSendToAll
	localData.isGM = mailData.data.playerInfo.isGM
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if lordInfoCtrl:getLordInfo().base.uid == mailData.sender then
			print("It's self")
			localData.isSelf = true
			localData.align = SoraDFIsRA() and 0 or 1
			localData.imageId = lordInfoCtrl:getLordInfo().base.imageId
			localData.avatarUrl = lordInfoCtrl:getLordInfo().base.avatar
			if allianceMgr:getAlliance() then
				localData.alliance = allianceMgr:getAlliance():getProperty("abbr")
				localData.allianceId = allianceMgr:getOwnAid()
			end
			localData.kid = chatFunctions:getSelfSourceKID()
			localData.nickName = SoraCheckUtf8String(chatFunctions:getSelfNickName())
			local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
			localData.isGM = accountExtCtrl:getIsGM()
			local vipDetail = lordInfoCtrl:getVipDetails()
			local isVipActivated = vipDetail.isActivated
			local vipLv = vipDetail.level
			localData.vipLv = vipLv
			if isVipActivated == true then
				localData.isVip = true
			else
				localData.isVip = false
			end
		else
			localData.align = SoraDFIsRA() and 1 or 0
			localData.alliance = mailData.data.playerInfo.allianceAbbr
			localData.allianceId = mailData.data.playerInfo.aid
			if localData.allianceId == 0 then
				localData.allianceId = nil
			end
			localData.nickName = SoraCheckUtf8String(mailData.data.playerInfo.nickName)
			localData.vipLv = mailData.data.playerInfo.vipLv
			if localData.vipLv ~= nil then
				localData.isVip = true
			end
		end
	else
		print("align not settted!!!!!!!!!!")
	end
	localData.translation = mailData.data.translation
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local oriCurl = settingCtrl:getTranslateLanguage()
	localData.isShowTranslate = false
	if not localData.isSelf and oriCurl and dataItem.translation then
		if dataItem.translation.tText ~= nil then
			local isNeedTranslate, tText = translateCtrl:needTranslate(dataItem.translation)
			if isNeedTranslate == false and tText == nil then
				localData.isShowTranslate = false
			elseif isNeedTranslate == false and tText ~= nil and dataItem.translation.sl then
				local langAbbrRead = include("langAbbrRead")
				local abbrName = langAbbrRead.getAbbrName(dataItem.translation.sl)
				if abbrName then
					abbrName = i18n(abbrName)
				else
					abbrName = dataItem.translation.sl
				end
				_ENV = chatFunctions:getSelfNickName()
				chatFunctions:getSelfNickName().language = abbrName
				local prefix = i18n("common_text_1635", chatFunctions:getSelfNickName())
				prefix = prefix or "from " .. dataItem.translation.sl
				dataItem.translation.translateInfo = prefix
				localData.isShowTranslate = true
			end
		else
			localData.isShowTranslate = false
		end
	end
	localData.chatId = localData.mid
	localData.playerId = mailData.sender
	localData.sysType = 0
	localData.date = mailData.time
	localData.time = os.date("%m-%d %H:%M", mailData.time)
	local isVMsgView = mailData.isVMsgView
	if localData.dataType == gChatDataType.dataType_audio and not isVMsgView == gStatus.YES then
		localData.readStatus = gChatReadStatus.unread
	else
		localData.readStatus = gChatReadStatus.normal
	end
	if localData.content == nil then
		localData.content = ""
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	localData.bottomText = localData.time
	_ENV, localData.oriBubbleId = localData.bubbleId, localData.bubbleId
	localData.bubbleId.checkRes = false
	local localData.bubbleId.data, bubbleParam = localData, localData.bubbleId
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	localData.showBubbleId = localData.bubbleId
	localData.nodeType = chatDataParser.getNodeType(localData)
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	localData.name = SoraCheckUtf8String(mailFunctions:getWrappedName(localData.alliance, localData.nickName))
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	if mailData.data.replyMsg then
		chatDataParser.applyReplyMsg(localData, mailData.data.replyMsg)
	end
	return localData
end
function chatDataParser.wrapAllianceMsgData(allianceMsg, isSDK, custom)
	local content = allianceMsg.content
	_ENV = nil
	;(nil).chatType = gChatTypeUI.allianceMsg
	;(nil).dataType = 0
	;(nil).align = -1
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = nil
	;(nil).allianceFlag = nil
	;(nil).alliance = nil
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = "2015-5-15"
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).labelSize, localData
	localData.isShowTranslate = false
	if content.contentType == gAllianceChatMsgType.text then
		localData.dataType = gChatDataType.dataType_text
	elseif content.contentType == gAllianceChatMsgType.emoticon then
		localData.dataType = gChatDataType.dataType_emotion
	end
	localData.content = content.content
	localData.targetAllianceId = custom.target
	localData.imageId = allianceMsg.iconID
	localData.avatarUrl = allianceMsg.avatar
	localData.playerId = allianceMsg.uid
	localData.nickName = SoraCheckUtf8String(allianceMsg.nickName)
	localData.allianceId = allianceMsg.aid
	localData.alliance = allianceMsg.aname
	localData.allianceFlag = allianceMsg.flag
	localData.member = allianceMsg.member
	localData.chatId = allianceMsg.msgID
	localData.isGM = allianceMsg.isGM
	if localData.targetAllianceId == localData.allianceId then
		localData.align = SoraDFIsRA() and 0 or 1
	else
		localData.align = SoraDFIsRA() and 1 or 0
	end
	localData.isSysMsg = false
	localData.sysType = 0
	localData.vipLv = false
	localData.date = allianceMsg.time
	localData.time = os.date("%m-%d %H:%M", allianceMsg.time)
	if localData.content == nil then
		localData.content = ""
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	localData.bottomText = localData.time
	localData.nodeType = chatDataParser.getNodeType(localData)
	localData.bubbleId = gBubbleId.BUBBLE_ID_NORMAL
	_ENV, localData.oriBubbleId = localData.bubbleId, localData.bubbleId
	localData.bubbleId.checkRes = false
	local localData.bubbleId.data, bubbleParam = localData, localData.bubbleId
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	localData.showBubbleId = localData.bubbleId
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	localData.name = SoraCheckUtf8String(mailFunctions:getWrappedName(localData.alliance, localData.nickName))
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	return localData
end
function chatDataParser.wrapTeamMsg(allianceMsg, isSDK, custom)
	local content = allianceMsg.content
	local sender = allianceMsg.sender
	if not sender.userInfo then
		local _ENV, userInfo = sender.userInfo, sender.userInfo
	end
	_ENV = nil
	;(nil).chatType = gChatTypeUI.teamMsg
	;(nil).dataType = 0
	;(nil).align = -1
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = nil
	;(nil).allianceFlag = nil
	;(nil).alliance = nil
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = "2015-5-15"
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).labelSize, localData
	localData.isShowTranslate = false
	if content.formatType == _G.gChatMsgContentFormatType.PLAIN_TEXT then
		localData.dataType = gChatDataType.dataType_text
		localData.content = content.content
	elseif content.formatType == _G.gChatMsgContentFormatType.EMOTICON then
		localData.dataType = gChatDataType.dataType_emotion
		localData.packetId = content.packetId or _G.gDefaultPackageId
		localData.emoticonId = content.content
	end
	localData.targetAllianceId = custom.target
	localData.imageId = userInfo.iconID
	localData.avatarUrl = userInfo.avatar
	localData.playerId = userInfo.uid
	localData.nickName = SoraCheckUtf8String(userInfo.nickName)
	localData.allianceId = userInfo.alliance
	localData.alliance = userInfo.allianceAbbr
	localData.allianceFlag = userInfo.flag
	localData.member = userInfo.member
	localData.chatId = allianceMsg.msgID
	localData.isGM = userInfo.isGM
	localData.isAllianceLeader = userInfo.isAllianceLeader
	local teamDef = include("teamDef")
	_ENV = "teamDef"
	;("teamDef")[teamDef.teamAreaEnum.KOH_MIGRATE] = true
	local ("teamDef")[teamDef.teamAreaEnum.ACTIVITY_9001657], config = true, "teamDef"
	if config[content.teamType] then
		localData.isKohMigrateChatRoom = true
	end
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if localData.playerId == lordInfoCtrl:getLordInfo().base.uid then
			localData.isSelf = true
			localData.align = SoraDFIsRA() and 0 or 1
		else
			localData.isSelf = false
			localData.align = SoraDFIsRA() and 1 or 0
		end
	else
	end
	localData.isKing = userInfo.isKing
	localData.isLegendKing = userInfo.isLegendKing
	localData.isLegendForSepKing = userInfo.isLegendForSepKing
	localData.isHegemon = userInfo.isHegemon
	localData.bubbleId = userInfo.bubbleId
	localData.avatarFrameId = userInfo.avatarFrameId
	localData.headWearId = userInfo.headWearId
	localData.bubbleId = localData.bubbleId and chatSkinRead.getBubbleIDByCid(localData.bubbleId) or gBubbleId.BUBBLE_ID_NORMAL
	localData.headWearId = localData.headWearId and chatSkinRead.getHeadWearIDByCid(localData.headWearId) or gHeadWearId.HEAD_ID_NORMAL
	localData.avatarFrameId = localData.avatarFrameId and chatSkinRead.getHeadIDByCid(localData.avatarFrameId) or gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
	localData.kid = userInfo.kid
	if localData.bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
	end
	if localData.isKing == true and localData.headWearId == gHeadWearId.HEAD_ID_NORMAL then
		localData.headWearId = gHeadWearId.HEAD_ID_KING
	end
	localData.isSysMsg = false
	localData.sysType = 0
	localData.vipLv = false
	localData.date = allianceMsg.time
	localData.time = os.date("%m-%d %H:%M", allianceMsg.time)
	if localData.content == nil then
		localData.content = ""
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	localData.bottomText = localData.time
	localData.nodeType = chatDataParser.getNodeType(localData)
	_ENV, localData.oriBubbleId = localData.bubbleId, localData.bubbleId
	localData.bubbleId.checkRes = false
	local localData.bubbleId.data, bubbleParam = localData, localData.bubbleId
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	localData.showBubbleId = localData.bubbleId
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	localData.name = SoraCheckUtf8String(mailFunctions:getWrappedName(localData.alliance, localData.nickName))
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	local key = custom.key
	local translateCtrl = SoraDGetCtrl("translateCtrl")
	local translation = translateCtrl:getTranslationByChatId(key, localData.chatId)
	if translation then
		translation.translateInfo = chatDataParser.getTranlsateInfo(translation)
		localData.translation = translation
		localData.isShowTranslate = translateCtrl:getIsShowTranslate(key, localData.chatId)
	end
	if localData.isShowTranslate == true then
		print("----------需要显示翻译内容-----------------")
		local settingCtrl = SoraDGetCtrl("settingCtrl")
		local tl = settingCtrl:getTranslateLanguage()
		local tContent = localData.translation.tText[tl] and localData.translation.tText[tl].text or ""
		localData.tHtmlText = chatDataParser.wrapHtmlRichText(localData, tContent)
		localData.text = localData.tHtmlText
	end
	return localData
end
function chatDataParser.wrapDJMsg(djMsg, isSDK, custom)
	local content = djMsg
	_ENV = nil
	;(nil).chatType = gChatTypeUI.djMsg
	;(nil).dataType = 0
	;(nil).align = -1
	;(nil).chatId = 0
	;(nil).playerId = 0
	;(nil).imageId = 0
	;(nil).nickName = "sam"
	;(nil).isSysMsg = false
	;(nil).sysType = 0
	;(nil).isVip = false
	;(nil).vipLv = 0
	;(nil).allianceId = nil
	;(nil).allianceFlag = nil
	;(nil).alliance = nil
	;(nil).content = "this is chat test,you should not see this."
	;(nil).translateContent = " this is translate content, you should not see this"
	;(nil).date = "2015-5-15"
	;(nil).time = "11:30"
	;(nil).itemNode = nil
	;(nil).itemWidth = 0
	;(nil).itemHeight = 0
	;(nil).itemPosX = 0
	;(nil).itemPosY = 0
	local (nil).labelSize, localData
	localData.isShowTranslate = false
	localData.chatIndex = content.chatIndex
	localData.chatId = content.chatIndex
	localData.content = content.text
	localData.messageType = content.messageType
	localData.bubbleId = localData.bubbleId and chatSkinRead.getBubbleIDByCid(localData.bubbleId) or gBubbleId.BUBBLE_ID_NORMAL
	localData.castlelv = content.castlelv
	localData.contribute = content.contribute
	localData.dataType = gChatDataType.dataType_dj
	if content.count then
		localData.count = content.count
		localData.itemID = content.itemID
		localData.shopItemID = content.shopItemID
	end
	localData.playerId = content.uid
	localData.nickName = SoraCheckUtf8String(content.nickName)
	localData.alliance = content.allianceAbbr
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if localData.playerId == lordInfoCtrl:getLordInfo().base.uid then
			localData.isSelf = true
			localData.align = SoraDFIsRA() and 1 or 0
		else
			localData.isSelf = false
			localData.align = SoraDFIsRA() and 1 or 0
		end
	else
	end
	localData.translation = content.translation
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local oriCurl = settingCtrl:getTranslateLanguage()
	localData.isShowTranslate = false
	if not localData.isSelf and oriCurl and content.translation then
		if content.translation.tText ~= nil then
			local isNeedTranslate, tText = translateCtrl:needTranslate(content.translation)
			if isNeedTranslate == false then
				if tText == nil then
					localData.isShowTranslate = false
				elseif content.translation.sl then
					local langAbbrRead = include("langAbbrRead")
					local abbrName = langAbbrRead.getAbbrName(content.translation.sl)
					if abbrName then
						abbrName = i18n(abbrName)
					else
						abbrName = content.translation.sl
					end
					_ENV = nil
					;(nil).language = abbrName
					local prefix = i18n("common_text_1635", nil)
					prefix = prefix or "from " .. content.translation.sl
					content.translation.translateInfo = prefix
					localData.isShowTranslate = true
				end
			else
				localData.isShowTranslate = false
			end
		else
			localData.isShowTranslate = false
		end
	end
	localData.kid = content.kid
	localData.name = SoraCheckUtf8String(mailFunctions:getWrappedName(localData.alliance, localData.nickName))
	if localData.itemID then
		local gift = SoraDFIsRA() and include("itemDesRead").getName(localData.itemID) .. " " .. localData.count .. "x" or include("itemDesRead").getName(localData.itemID) .. " x" .. localData.count
		localData.content = gift
	end
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	localData.nodeType = chatDataParser.getNodeType(localData)
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	return localData
end
function chatDataParser.playerchatRoomSharePosData(content)
	dump(content, "chatDataParser.playerchatRoomSharePosData")
	local result = ""
	local strName = ""
	if content.markType then
		local AMM = require_data("alliancemapmark", true).data
		if AMM[content.markType] then
			strName = i18n(AMM[content.markType].name)
		end
	elseif content.markId then
		local activity_9001573_Read = include("activity_9001573_Read")
		strName = activity_9001573_Read.getCampMarkName(content.markId)
	elseif content.mapType == gMapObjTypeDef.mapObjTypePlayer then
		local mapId = content.mapId
		if mapId and worldMapDefine.isGardenKingdomID(mapId) then
			_ENV = nil
			;(nil).name = content.name
			strName = i18n("garden_text_21", nil)
		else
			_ENV = nil
			;(nil).name = content.name
			strName = i18n("devilvalley_text_45", nil)
		end
	elseif content.mapType == gMapObjTypeDef.mapTypePlain then
		strName = i18n("position_share_03")
	elseif content.mapType == gMapObjTypeDef.mapTypeEndlessTrialsPortal then
		local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
		local infoData = endlessTrialsCtrl:getProtalInfo()
		local id = 1
		for k, v in pairs(infoData) do
			if v.x == content.x and v.y == content.y then
				id = tonumber(k)
				break
			end
		end
		local config = endlessTrialsCtrl:getMountainConfig(id)
		strName = i18n(config.name)
	elseif content.mapType == gMapObjTypeDef.mapObjTypeEscort then
		strName = i18n("common_text_2465")
	elseif content.mapType == gMapObjTypeDef.mapObjTypeFortress then
		strName = i18n("common_text_2859")
	elseif content.mapType == gMapObjTypeDef.mapObjTypeBattery then
		strName = i18n("common_text_840")
	elseif content.mapType == gMapObjTypeDef.mapObjTypeCastale then
		strName = i18n("common_text_839")
	elseif content.mapType == gMapObjTypeDef.mapTypeFireTreasure then
		strName = i18n("activity_name_9001206")
	elseif content.mapType == gMapObjTypeDef.mapTypeWarTreasure then
		strName = i18n("activity_name_9001243")
	elseif content.mapType == gMapObjTypeDef.mapTypeATBuilding then
		strName = i18n("activity_name_9001201")
	elseif content.mapType == gMapObjTypeDef.mapObjTypeCampsite then
		strName = i18n("position_share_05")
	elseif content.mapType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		if content.subMapType == gWorldTypeServerDef.subTypeAlliancePalace then
			strName = i18n("common_text_2902")
		elseif content.subMapType == gWorldTypeServerDef.subTypeAllianceAltar then
			strName = i18n("alliance_beast_text_31")
		elseif content.subMapType == gWorldTypeServerDef.subTypeAllianceFlag then
			strName = i18n("common_text_2903")
		elseif content.subMapType == gWorldTypeServerDef.subTypeAlliancePriPalace then
			strName = i18n("alliance_stronghold_text_009")
		end
	elseif content.mapType == gMapObjTypeDef.mapObjTypeSuperResource then
		if content.subMapType == gWorldTypeServerDef.subMapTypeSuperResFood then
			strName = i18n("common_text_2127")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeSuperResWood then
			strName = i18n("common_text_2128")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeSuperResIron then
			strName = i18n("common_text_2129")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeSuperResMithril then
			strName = i18n("common_text_2130")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeSuperResCrystal then
			strName = i18n("alliance_build_name_05")
		end
	elseif content.mapType == gMapObjTypeDef.mapObjTypeResource then
		if content.subMapType == gWorldTypeServerDef.subMapTypeResWood then
			strName = i18n("res_name_famuchang")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeResFood then
			strName = i18n("res_name_nongtian")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeResGold then
			strName = i18n("res_name_jinkuang")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeResIron then
			strName = i18n("res_name_tiekuangchang")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeResMithril then
			strName = i18n("res_name_miyinkuangchang")
		elseif content.subMapType == gWorldTypeServerDef.subMapTypeResCrystal then
			strName = i18n("common_text_3969")
		end
	elseif content.mapType == gMapObjTypeDef.mapObjTypeRelics then
		strName = i18n("res_name_yiji")
	elseif content.mapType == gMapObjTypeDef.mapTypeMine then
		local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
		strName = allianceStrongholdMineRead.getMineName(content.subMapType)
	elseif content.mapType == gMapObjTypeDef.stronghold then
		local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
		local cfg = allianceStrongholdMineRead.getGateClientCfg(content.subMapType)
		if cfg then
			strName = i18n(cfg.name)
		end
	elseif content.mapType == gMapObjTypeDef.mapObjTypeLegendLord and worldMapDefine.isKingStarMapId(content.mapId) then
		strName = i18n("kingstarbattle_text_64")
	elseif content.mapType == gMapObjTypeDef.ramadanSylyut then
		strName = i18n("Ramadan_2024_text8")
	elseif content.mapType == gMapObjTypeDef.dailySaluteBribe then
		strName = i18n("activity_name_9001689")
	else
		local mapObjUtil = include("mapObjUtil")
		strName = mapObjUtil.getBuildName(content.mapType, content.subMapType, content.mapId)
	end
	_ENV = content.mapType
	content.mapType.var = strName
	result = i18n("position_share_02", content.mapType)
	return result
end
function chatDataParser.wrapChatRoomData(dataItem)
	dump(dataItem, "聊天室的数据----")
	_ENV = dump
	dump.chatType = gChatTypeUI.chatRoom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = ""
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = "2015-5-15"
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	localData.customData = dataItem
	localData.chatId = dataItem.msgid
	if dataItem.msgType == gChatRoomMsgType.CHAT then
		localData.playerId = dataItem.user.uid
		localData.imageId = dataItem.user.imageId
		localData.avatarUrl = dataItem.user.avatar
		localData.nickName = SoraCheckUtf8String(dataItem.user.nickName)
		localData.isSysMsg = false
		localData.sysType = 0
		localData.chatIndex = dataItem.data.chatIndex
		if dataItem.data.content and type(dataItem.data.content) == "table" then
			localData.chatIndex = dataItem.data.content.chatIndex
		end
		localData.vipLv = dataItem.user.vipLv
		if dataItem.user.isVip ~= nil then
			localData.isVip = true
		end
		localData.isGM = dataItem.user.isGM
		localData.isKing = dataItem.user.isKing
		localData.isLegendKing = dataItem.data.isLegendKing
		localData.isLegendForSepKing = dataItem.data.isLegendForSepKing
		localData.isHegemon = dataItem.data.isHegemon
		localData.bubbleId = dataItem.data.bubbleId
		localData.avatarFrameId = dataItem.data.avatarFrameId
		localData.customProperty, _ENV, localData.headWearId = dataItem.data.headWearId, dataItem.data.headWearId, dataItem.data.headWearId
		localData.customProperty.sysBubbleId = dataItem.data.bubbleId
		localData.customProperty.sysHeadWearId = dataItem.data.headWearId
		localData.customProperty.sysAvatarFrameId = dataItem.data.avatarFrameId
		localData.bubbleId = dataItem.data.bubbleId and chatSkinRead.getBubbleIDByCid(dataItem.data.bubbleId) or gBubbleId.BUBBLE_ID_NORMAL
		localData.headWearId = dataItem.data.headWearId and chatSkinRead.getHeadWearIDByCid(dataItem.data.headWearId) or gHeadWearId.HEAD_ID_NORMAL
		localData.avatarFrameId = dataItem.data.avatarFrameId and chatSkinRead.getHeadIDByCid(dataItem.data.avatarFrameId) or gAvatarFrameId.AVATAR_FRAME_ID_NORMAL
		if localData.bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
		end
		if localData.isKing == true and localData.headWearId == gHeadWearId.HEAD_ID_NORMAL then
			localData.headWearId = gHeadWearId.HEAD_ID_KING
		end
		localData.date = dataItem.t
		if type(localData.date) == "string" then
			localData.date = 0
		end
		localData.time = os.date("%m-%d %H:%M", dataItem.t)
		localData.alliance = dataItem.user.alliance
		localData.allianceId = dataItem.user.allianceId
		localData.content = dataItem.data.content
		if dataItem.data.chatType == gChatRoomChatType.TEXT then
			localData.dataType = gChatDataType.dataType_text
		elseif dataItem.data.chatType == gChatRoomChatType.EMOJI then
			localData.dataType = gChatDataType.dataType_emotion
			localData.packetId = dataItem.data.packetId or gDefaultPackageId
			localData.emoticonId = dataItem.data.content
		elseif dataItem.data.chatType == gChatRoomChatType.VOICE then
			localData.dataType = gChatDataType.dataType_audio
			if dataItem.data.content then
				localData.content = tostring(dataItem.data.content.audioLen) .. "''"
				localData.customData = dataItem.data.content
				localData.audioLen = dataItem.data.content.audioLen
				localData.audioId = dataItem.data.content.audioId
			else
				localData.content = tostring(dataItem.data.audioLen) .. "''"
				localData.customData = dataItem.data
				localData.audioLen = dataItem.data.audioLen
				localData.audioId = dataItem.data.audioId
			end
		elseif dataItem.data.chatType == gChatRoomChatType.CUSTOM then
			if dataItem.data.chatSysMsgType == gChatSysMsgType.share_mail or dataItem.data.content.mailData then
				localData.dataType = gChatDataType.dataType_fightReport
				dataItem.data.content.textType = gChatTextType.text_custom
				localData.customData = dataItem.data.content.mailData
				localData.customData.chatroom = dataItem.chatroom
				_ENV = dataItem.chatroom
				dataItem.chatroom.content = dataItem.data.content.mailData
				dataItem.chatroom.from = localData.playerId
				local result = chatDataParser.parseChatFightReport(dataItem.chatroom)
				localData.content = string.htmlspecialchars(result)
				localData.isSysMsg = true
			elseif dataItem.data.content.chatSysMsgType and dataItem.data.content.chatSysMsgType == gChatSysMsgType.hero_prison_share then
				localData.dataType = gChatDataType.dataType_hero_prison_share
				localData.isSysMsg = true
				local result = chatDataParser.parseChatContentText(dataItem.data.content)
				localData.content = result
			else
				localData.dataType = gChatDataType.dataType_pos_share
				dataItem.data.content.textType = gChatTextType.text_custom
				dataItem.data.content.chatSysMsgType = gChatSysMsgType.pos_share
				localData.content = chatDataParser.playerchatRoomSharePosData(dataItem.data.content)
			end
		else
			localData.dataType = gChatDataType.dataType_text
		end
		if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
			if chatFunctions.getIsPlayerSelf(localData.playerId) then
				localData.isSelf = true
				localData.align = SoraDFIsRA() and 0 or 1
			else
				localData.isSelf = false
				localData.align = SoraDFIsRA() and 1 or 0
			end
		else
		end
		localData.translation = dataItem.data.translation
		local settingCtrl = gametop.playertop_:getModule("settingCtrl")
		local translateCtrl = gametop.playertop_:getModule("translateCtrl")
		local oriCurl = settingCtrl:getTranslateLanguage()
		localData.isShowTranslate = false
		if not localData.isSelf and oriCurl and dataItem.data.translation then
			if dataItem.data.translation.tText ~= nil then
				local isNeedTranslate, tText = translateCtrl:needTranslate(dataItem.data.translation)
				if isNeedTranslate == false and tText == nil then
					localData.isShowTranslate = false
				elseif isNeedTranslate == false and tText ~= nil and dataItem.data.translation.sl then
					local langAbbrRead = include("langAbbrRead")
					local abbrName = langAbbrRead.getAbbrName(dataItem.data.translation.sl)
					if abbrName then
						abbrName = i18n(abbrName)
					else
						abbrName = dataItem.data.translation.sl
					end
					_ENV = nil
					;(nil).language = abbrName
					local prefix = i18n("common_text_1635", nil)
					prefix = prefix or "from " .. dataItem.data.translation.sl
					dataItem.data.translation.translateInfo = prefix
					localData.isShowTranslate = true
				end
			else
				localData.isShowTranslate = false
			end
		end
	elseif dataItem.msgType == gChatRoomMsgType.SYSTEM then
		localData.dataType = gChatDataType.dataType_chatroom_sys_op
		localData.content = chatDataParser.parseChatRoomSysOp(dataItem)
		localData.date = dataItem.t
		localData.time = os.date("%m-%d %H:%M", dataItem.t)
	end
	if localData.content == nil then
		localData.content = ""
	end
	localData.serverMsg = dataItem
	if localData.isSelf == true then
		localData.readStatus = gChatReadStatus.normal
	elseif localData.dataType == gChatDataType.dataType_audio then
		if not dataItem.status or dataItem.status == gMsgStatus.UNREAD then
			localData.readStatus = gChatReadStatus.unread
		end
	else
		localData.readStatus = gChatReadStatus.normal
	end
	localData.nodeType = chatDataParser.getNodeType(localData)
	if localData.align == 0 then
		localData.direction = gChatDirection.left
	else
		localData.direction = gChatDirection.right
	end
	localData.bottomText = localData.time
	_ENV, localData.oriBubbleId = localData.bubbleId, localData.bubbleId
	localData.bubbleId.checkRes = false
	local localData.bubbleId.data, bubbleParam = localData, localData.bubbleId
	localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	localData.showBubbleId = localData.bubbleId
	localData.htmlText = chatDataParser.wrapHtmlRichText(localData, localData.content)
	localData.text = localData.htmlText
	localData.name = SoraCheckUtf8String(mailFunctions:getWrappedName(localData.alliance, localData.nickName))
	localData.chatChannel = gChatTypeUI2ChatChannel[localData.chatType]
	return localData
end
function chatDataParser.parseEscortMsg(msg)
	local content = "undefined"
	local isRobbed = false
	local intelType = msg.data.intelType
	if intelType == gEscortIntelType.ESCORT_WITH_MAX_LEVEL_CART then
		local name = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
		_ENV = mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName)
		mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName).name = name
		content = i18n("mail_text_237", mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
	elseif intelType == gEscortIntelType.OPEN_ALLIANCE_GAIN_PLUS then
		dump(msg, "开启了联盟押运加成----------------", 10)
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", msg.t)
		local name = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
		_ENV = mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName)
		mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName).name = name
		mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName).time = timeStr
		mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName).addValue = msg.data.alliancePlus * 100
		content = i18n("mail_text_240", mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
	elseif intelType == gEscortIntelType.ESCORT_ROB then
		if allianceMgr:getAlliance() then
			local ownAid = allianceMgr:getOwnAid()
			if msg.data.targetPlayers ~= nil and type(msg.data.targetPlayers[1]) == "table" and #msg.data.targetPlayers > 0 then
				if msg.data.opPlayer.allianceId and msg.data.opPlayer.allianceId ~= 0 and msg.data.opPlayer.allianceId == ownAid then
					local nameAtk = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
					local nameDef = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
					_ENV = mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName)
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameAtk = nameAtk
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameDef = nameDef
					content = i18n("mail_text_239", mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
				elseif msg.data.targetPlayers[1].allianceId and msg.data.targetPlayers[1].allianceId ~= 0 and msg.data.targetPlayers[1].allianceId == ownAid then
					local nameAtk = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
					local nameDef = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
					_ENV = mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName)
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameAtk = nameAtk
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameDef = nameDef
					content = i18n("mail_text_238", mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
					isRobbed = true
				else
					local nameAtk = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
					local nameDef = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
					_ENV = mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName)
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameAtk = nameAtk
					mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameDef = nameDef
					content = i18n("mail_text_239", mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
				end
			end
		elseif msg.data.targetPlayers ~= nil and type(msg.data.targetPlayers[1]) == "table" and #msg.data.targetPlayers > 0 then
			local nameAtk = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.opPlayer.alliance, msg.data.opPlayer.nickName))
			local nameDef = SoraCheckUtf8String(mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
			_ENV = mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName)
			mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameAtk = nameAtk
			mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName).nameDef = nameDef
			content = i18n("mail_text_239", mailFunctions:getWrappedName(msg.data.targetPlayers[1].alliance, msg.data.targetPlayers[1].nickName))
		end
	end
	return content, isRobbed
end
_ENV, chatDataParser.wrapEscortMsg = function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end, function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.kingdom] = chatDataParser.wrapServerData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.alliance] = chatDataParser.wrapServerData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.team] = chatDataParser.wrapServerData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.mail] = chatDataParser.wrapMailData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.allianceMsg] = chatDataParser.wrapAllianceMsgData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.chatRoom] = chatDataParser.wrapChatRoomData
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.escortKingdom] = chatDataParser.wrapEscortMsg
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.escortAlliance] = chatDataParser.wrapEscortMsg
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.teamMsg] = chatDataParser.wrapTeamMsg
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.djMsg] = chatDataParser.wrapDJMsg
;(function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.camp] = chatDataParser.wrapServerData
chatDataParser.wrapDataFunc, (function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end)[gChatTypeUI.viewer] = function(msg)
	print("chatDataParser.wrapEscortMsg(msg)-----")
	dump(msg, "chatDataParser.wrapEscortMsg(msg)", 10)
	_ENV = dump
	dump.chatType = gChatTypeUI.escortKingdom
	dump.dataType = 0
	dump.align = -1
	dump.chatId = 0
	dump.playerId = 0
	dump.imageId = 0
	dump.nickName = "sam"
	dump.isKNotice = false
	dump.isSysMsg = false
	dump.sysType = 0
	dump.isVip = false
	dump.vipLv = 0
	dump.allianceId = nil
	dump.alliance = nil
	dump.content = "this is chat test,you should not see this."
	dump.translateContent = " this is translate content, you should not see this"
	dump.date = 0
	dump.time = "11:30"
	dump.itemNode = nil
	dump.itemWidth = 0
	dump.itemHeight = 0
	dump.itemPosX = 0
	dump.itemPosY = 0
	local dump.labelSize, localData = nil, dump
	if msg.channel == gEscortIntelChannel.KINGDOM then
		localData.chatType = gChatTypeUI.escortKingdom
	elseif msg.channel == gEscortIntelChannel.ALLIANCE then
		localData.chatType = gChatTypeUI.escortAlliance
	end
	localData.serverMsg = msg
	localData.content, localData.isRobbed = chatDataParser.parseEscortMsg(msg)
	return localData
end, chatDataParser.wrapServerData
function chatDataParser.getTranlsateInfo(translation)
	if translation.sl then
		local langAbbrRead = include("langAbbrRead")
		local abbrName = langAbbrRead.getAbbrName(translation.sl)
		if abbrName then
			abbrName = i18n(abbrName)
		else
			abbrName = translation.sl
		end
		_ENV = nil
		;(nil).language = abbrName
		local prefix = i18n("common_text_1635", nil)
		prefix = prefix or "from " .. translation.sl
		return prefix
	end
	return nil
end
function chatDataParser.parsePartyShare(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		local partyLv = content.partyLv
		local partyID = content.partyID
		local FAD = require_data("feastattribute", true)
		if not FAD.data[partyLv] then
			local _ENV, selectData = FAD.data[partyLv], FAD.data[partyLv]
		end
		_ENV = nil
		;(nil).feast = i18n(selectData.FeastName)
		result = i18n("feast_text_34", nil)
	end
	return result
end
function chatDataParser.parseChristmasTreeShare(dataItem)
	local result = ""
	local content = dataItem.content
	if content then
		result = i18n("christmas_tree_text_22")
	end
	return result
end
function chatDataParser.getChatMailTitle(data)
	local mailTitle
	if data.chatChannel == gChatChannel.CHATROOM then
		mailTitle = data.serverMsg.chatroom.crName
	else
		mailTitle = mailFunctions:getWrappedName(data.customData.playerInfo.allianceAbbr, data.customData.playerInfo.nickName)
		if data.customData.playerInfo.sourceKID then
			local sourceKID = chatFunctions:getSelfSourceKID()
			if sourceKID ~= data.customData.playerInfo.sourceKID then
				mailTitle = mailTitle .. "#" .. data.customData.playerInfo.sourceKID
			end
		end
	end
	if mailTitle == nil or string.len(mailTitle) == 0 then
		mailTitle = "unDefined"
	end
	return mailTitle
end
function chatDataParser.wrapOfficialData(content)
	if "table" ~= type(content) then
		return
	end
	local settingCtrl = SoraDGetCtrl("settingCtrl")
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	if settingCtrl:checkValue(gSettingKeyType.chatTitleShow) then
		local officialType, officialId = lordInfoCtrl:getShowOfficialTypeAndId()
		if officialType then
			content.officialType = officialType
			content.officialTitle = officialId
		end
	end
end
return chatDataParser
