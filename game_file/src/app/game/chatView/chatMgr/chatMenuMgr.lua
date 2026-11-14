local chatBaseMgr = include("chatBaseMgr")
local chatMenuMgr = class("chatMenuMgr", chatBaseMgr)
local chatConst = include("chatConst")
local condParser = include("condParser")
function chatMenuMgr:initMenuCfg()
	local OpId = chatConst.OpId
	chatConst = nil
	_UPVALUE3_ = nil
	;(nil)[gMenuType.chat_self], (nil)[1] = nil, OpId.OpCopy
	;(nil)[gMenuType.chat_self], (nil)[2] = nil, OpId.OpQuote
	;(nil)[gMenuType.chat_self], (nil)[3] = nil, OpId.OpCommonView
	_UPVALUE17_ = nil
	;(nil)[gMenuType.chat_other], (nil)[1] = nil, OpId.OpCopy
	;(nil)[gMenuType.chat_other], (nil)[2] = nil, OpId.OpQuote
	;(nil)[gMenuType.chat_other], (nil)[3] = nil, OpId.OpTranslate
	;(nil)[gMenuType.chat_other], (nil)[4] = nil, OpId.OpOriginText
	;(nil)[gMenuType.chat_other], (nil)[5] = nil, OpId.OpCommonView
	;(nil)[gMenuType.chat_other], (nil)[6] = nil, OpId.OpUnShield
	;(nil)[gMenuType.chat_other], (nil)[7] = nil, OpId.OpShield
	;(nil)[gMenuType.chat_other], (nil)[8] = nil, OpId.OpReport
	;(nil)[gMenuType.chat_other], (nil)[9] = nil, OpId.OpReportHeadImg
	;(nil)[gMenuType.chat_other], (nil)[10] = nil, OpId.OpInvite
	;(nil)[gMenuType.chat_other], (nil)[11] = nil, OpId.OpJoin
	;(nil)[gMenuType.chat_other], (nil)[12] = nil, OpId.OpForbidLord
	;(nil)[gMenuType.chat_other], (nil)[13] = nil, OpId.OpBuy
	;(nil)[gMenuType.chat_other], (nil)[14] = nil, OpId.OpUnShieldThisLord
	;(nil)[gMenuType.chat_other], (nil)[15] = nil, OpId.OpShieldThisLord
	;(nil)[gMenuType.chat_other], (nil)[16] = nil, OpId.OpUnShieldThisAlliance
	;(nil)[gMenuType.chat_other], (nil)[17] = nil, OpId.OpShieldThisAlliance
	;(nil)[gMenuType.chat_other], (nil)[18] = nil, OpId.OpDeleteMsg
	_ENV = nil
	;(nil)[gMenuType.escort_log], (nil)[1] = nil, OpId.OpViewPlayer
	_UPVALUE8_ = nil
	;(nil)[gMenuType.chat_dj], (nil)[1] = nil, OpId.OpCopy
	;(nil)[gMenuType.chat_dj], (nil)[2] = nil, OpId.OpTranslate
	;(nil)[gMenuType.chat_dj], (nil)[3] = nil, OpId.OpOriginText
	;(nil)[gMenuType.chat_dj], (nil)[4] = nil, OpId.OpCommonView
	;(nil)[gMenuType.chat_dj], (nil)[5] = nil, OpId.OpUnShield
	;(nil)[gMenuType.chat_dj], (nil)[6] = nil, OpId.OpShield
	;(nil)[gMenuType.chat_dj], (nil)[7] = nil, OpId.OpReport
	;(nil)[gMenuType.chat_dj], (nil)[8] = nil, OpId.OpReportHeadImg
	_UPVALUE17_ = nil
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[1] = nil, nil, OpId.OpCopy
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[2] = nil, nil, OpId.OpQuote
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[3] = nil, nil, OpId.OpTranslate
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[4] = nil, nil, OpId.OpOriginText
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[5] = nil, nil, OpId.OpCommonView
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[6] = nil, nil, OpId.OpReportHeadImg
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[7] = nil, nil, OpId.OpInvite
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[8] = nil, nil, OpId.OpJoin
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[9] = nil, nil, OpId.OpShield
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[10] = nil, nil, OpId.OpUnShield
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[11] = nil, nil, OpId.OpReport
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[12] = nil, nil, OpId.OpForbidLord
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[13] = nil, nil, OpId.OpBuy
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[14] = nil, nil, OpId.OpUnShieldThisLord
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[15] = nil, nil, OpId.OpShieldThisLord
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[16] = nil, nil, OpId.OpUnShieldThisAlliance
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[17] = nil, nil, OpId.OpShieldThisAlliance
	self.menuCfgs, (nil)[gMenuType.chat_team], (nil)[18] = nil, nil, OpId.OpDeleteMsg
	if SoraDFIsRA() then
		chatConst = SoraDFIsRA()
		_UPVALUE3_ = nil
		SoraDFIsRA()[gMenuType.chat_self], (nil)[1] = nil, OpId.OpCopy
		SoraDFIsRA()[gMenuType.chat_self], (nil)[2] = nil, OpId.OpQuote
		SoraDFIsRA()[gMenuType.chat_self], (nil)[3] = nil, OpId.OpCommonView
		_UPVALUE17_ = nil
		SoraDFIsRA()[gMenuType.chat_other], (nil)[1] = nil, OpId.OpCopy
		SoraDFIsRA()[gMenuType.chat_other], (nil)[2] = nil, OpId.OpQuote
		SoraDFIsRA()[gMenuType.chat_other], (nil)[3] = nil, OpId.OpTranslate
		SoraDFIsRA()[gMenuType.chat_other], (nil)[4] = nil, OpId.OpOriginText
		SoraDFIsRA()[gMenuType.chat_other], (nil)[5] = nil, OpId.OpCommonView
		SoraDFIsRA()[gMenuType.chat_other], (nil)[6] = nil, OpId.OpUnShield
		SoraDFIsRA()[gMenuType.chat_other], (nil)[7] = nil, OpId.OpReport
		SoraDFIsRA()[gMenuType.chat_other], (nil)[8] = nil, OpId.OpShield
		SoraDFIsRA()[gMenuType.chat_other], (nil)[9] = nil, OpId.OpReportHeadImg
		SoraDFIsRA()[gMenuType.chat_other], (nil)[10] = nil, OpId.OpInvite
		SoraDFIsRA()[gMenuType.chat_other], (nil)[11] = nil, OpId.OpJoin
		SoraDFIsRA()[gMenuType.chat_other], (nil)[12] = nil, OpId.OpForbidLord
		SoraDFIsRA()[gMenuType.chat_other], (nil)[13] = nil, OpId.OpBuy
		SoraDFIsRA()[gMenuType.chat_other], (nil)[14] = nil, OpId.OpUnShieldThisLord
		SoraDFIsRA()[gMenuType.chat_other], (nil)[15] = nil, OpId.OpShieldThisLord
		SoraDFIsRA()[gMenuType.chat_other], (nil)[16] = nil, OpId.OpUnShieldThisAlliance
		SoraDFIsRA()[gMenuType.chat_other], (nil)[17] = nil, OpId.OpShieldThisAlliance
		SoraDFIsRA()[gMenuType.chat_other], (nil)[18] = nil, OpId.OpDeleteMsg
		_ENV = nil
		SoraDFIsRA()[gMenuType.escort_log], (nil)[1] = nil, OpId.OpViewPlayer
		_UPVALUE9_ = nil
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[1] = nil, OpId.OpCopy
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[2] = nil, OpId.OpQuote
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[3] = nil, OpId.OpTranslate
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[4] = nil, OpId.OpOriginText
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[5] = nil, OpId.OpCommonView
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[6] = nil, OpId.OpUnShield
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[7] = nil, OpId.OpReport
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[8] = nil, OpId.OpShield
		SoraDFIsRA()[gMenuType.chat_dj], (nil)[9] = nil, OpId.OpReportHeadImg
		_UPVALUE17_ = nil
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[1] = SoraDFIsRA(), nil, OpId.OpCopy
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[2] = SoraDFIsRA(), nil, OpId.OpQuote
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[3] = SoraDFIsRA(), nil, OpId.OpTranslate
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[4] = SoraDFIsRA(), nil, OpId.OpOriginText
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[5] = SoraDFIsRA(), nil, OpId.OpCommonView
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[6] = SoraDFIsRA(), nil, OpId.OpReportHeadImg
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[7] = SoraDFIsRA(), nil, OpId.OpInvite
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[8] = SoraDFIsRA(), nil, OpId.OpJoin
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[9] = SoraDFIsRA(), nil, OpId.OpShield
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[10] = SoraDFIsRA(), nil, OpId.OpUnShield
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[11] = SoraDFIsRA(), nil, OpId.OpReport
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[12] = SoraDFIsRA(), nil, OpId.OpForbidLord
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[13] = SoraDFIsRA(), nil, OpId.OpBuy
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[14] = SoraDFIsRA(), nil, OpId.OpUnShieldThisLord
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[15] = SoraDFIsRA(), nil, OpId.OpShieldThisLord
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[16] = SoraDFIsRA(), nil, OpId.OpUnShieldThisAlliance
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[17] = SoraDFIsRA(), nil, OpId.OpShieldThisAlliance
		self.menuCfgs, SoraDFIsRA()[gMenuType.chat_team], (nil)[18] = SoraDFIsRA(), nil, OpId.OpDeleteMsg
	end
end
function chatMenuMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self:reset()
	self:initMenuCfg()
end
function chatMenuMgr:reset()
end
function chatMenuMgr:clean()
	self:reset()
end
function chatMenuMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatMenuMgr:registerMessageListener()
	self:removeMessageListener()
end
function chatMenuMgr:getMenus(data)
	dump(data, "chatMenuMgr:getMenus", 10)
	local chatFunctions = include("chatFunctions")
	local menuType = gMenuType.chat_self
	local chatChannel = data.chatChannel
	if chatChannel == gChatChannel.ESCORTKINGDOM or chatChannel == gChatChannel.ESCORTALLIANCE then
		menuType = gMenuType.escort_log
	elseif chatFunctions.getIsPlayerSelf(data.playerId) then
		menuType = gMenuType.chat_self
	elseif chatChannel == gChatChannel.DJ then
		menuType = gMenuType.chat_dj
	elseif chatChannel == gChatChannel.TEAM or chatChannel == gChatChannel.TEAMMSG then
		menuType = gMenuType.chat_team
	else
		menuType = gMenuType.chat_other
	end
	local _ENV, menus = gMenuType, gMenuType
	local _ENV, menuData = data.playerId, data.playerId
	local menuCfg = self.menuCfgs[menuType]
	if not menuCfg then
		return menus, menuData
	end
	if menuCfg and data.npcId == 1000 then
		local OpId = chatConst.OpId
		menuCfg, _ENV = menuData, menuData
	end
	for _, opId in ipairs(menuCfg) do
		local opCfg = chatConst.OpConfig[tostring(opId)]
		if opCfg then
			local opName = opCfg.name
			local condFunc = self["cond_" .. opName]
			if condFunc and condFunc(self, menuType, opId, data) then
				if not opCfg.isCustom then
					table.insert(menus, opId)
				else
					self:createCustomMenu(opId, data, menus, menuData)
				end
			else
			end
		end
	end
	return menus, menuData
end
function chatMenuMgr:createCustomMenu(opId, data, outMenus, outMenuDataData)
	local opCfg = chatConst.OpConfig[tostring(opId)]
	local opName = opCfg.name
	local createCustomMenuFunc = self["createCustomMenu_" .. opName]
	if createCustomMenuFunc then
		return createCustomMenuFunc(opId, data, outMenus, outMenuDataData)
	else
		print("createCustomMenu_" .. opName .. " not implemented!")
	end
end
function chatMenuMgr:createCustomMenu_OpCoordinate(opId, data, outMenus, outMenuDataData)
	local chatFunctions = include("chatFunctions")
	local content = data.content
	local coordinates = SoraDGetCoordinateFromText(content, chatFunctions.mapWidth, chatFunctions.mapHeight)
	if coordinates and 0 < #coordinates then
		for i = 1, #coordinates do
			if 1 < i then
				break
			end
			table.insert(outMenus, #outMenus + 1, opId)
		end
	end
	if outMenuDataData.players then
		table.insertto(outMenuDataData.coordinates, coordinates)
	else
		outMenuDataData.coordinates = coordinates
	end
end
function chatMenuMgr:createCustomMenu_OpViewPlayer(opId, data, outMenus, outMenuDataData)
	local msg = data.serverMsg
	local intelType = msg.data.intelType
	local _ENV, players
	if intelType == gEscortIntelType.ESCORT_WITH_MAX_LEVEL_CART then
		_ENV = nil
		;(nil).uid = msg.data.opPlayer.uid
		;(nil).alliance = msg.data.opPlayer.alliance
		;(nil).nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, nil)
		table.insert(outMenus, #outMenus + 1, opId)
	elseif intelType == gEscortIntelType.OPEN_ALLIANCE_GAIN_PLUS then
		_ENV = opId
		opId.uid = msg.data.opPlayer.uid
		opId.alliance = msg.data.opPlayer.alliance
		opId.nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, opId)
		table.insert(outMenus, #outMenus + 1, opId)
	elseif intelType == gEscortIntelType.ESCORT_ROB then
		_ENV = opId
		opId.uid = msg.data.targetPlayers[1].uid
		opId.alliance = msg.data.targetPlayers[1].alliance
		opId.nickName = msg.data.targetPlayers[1].nickName
		table.insert(players, #players + 1, opId)
		table.insert(outMenus, #outMenus + 1, opId)
		_ENV = opId
		opId.uid = msg.data.opPlayer.uid
		opId.alliance = msg.data.opPlayer.alliance
		opId.nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, opId)
		table.insert(outMenus, #outMenus + 1, opId)
	end
	if outMenuDataData.players then
		table.insertto(outMenuDataData.players, players)
	else
		outMenuDataData.players = players
	end
end
function chatMenuMgr:cond_OpCopy(menuType, opId, data)
	local dataType = data.dataType or gChatDataType.dataType_text
	local dataTypeCfg = gChatDataTypeCfg[dataType]
	if dataTypeCfg.noMenuCopy then
		return false
	end
	if data.isSysMsg == true or data.isSysMsg == 1 then
		return false
	end
	return true
end
function chatMenuMgr:cond_OpQuote(menuType, opId, data)
	local dataType = data.dataType or gChatDataType.dataType_text
	if dataType ~= gChatDataType.dataType_text and dataType ~= gChatDataType.dataType_emotion then
		return false
	end
	if data.isSysMsg == true or data.isSysMsg == 1 then
		return false
	end
	return true
end
function chatMenuMgr:cond_OpCommonView(menuType, opId, data)
	local dataType = data.dataType
	local cfg = gChatDataTypeCfg[dataType]
	if not cfg then
		return false
	end
	if cfg.needCommonView then
		return true
	end
	return false
end
function chatMenuMgr:cond_OpTranslate(menuType, opId, data)
	local dataType = data.dataType
	local textType = data.textType
	if (dataType == 0 or dataType == gChatDataType.dataType_dj and data.messageType == gChatTypeDef.chat_content_dj_text) and (textType == nil or textType == 0 or textType == gChatTextType.text_plain) and (not data.isSysMsg or data.isSysMsg == 0) and (data.isShowTranslate == false or data.isShowTranslate == nil or data.isShowTranslate == 0) then
		return true
	end
	return false
end
function chatMenuMgr:cond_OpOriginText(menuType, opId, data)
	local dataType = data.dataType
	local textType = data.textType
	if (dataType == 0 or dataType == gChatDataType.dataType_dj and data.messageType == gChatTypeDef.chat_content_dj_text) and (textType == nil or textType == 0 or textType == gChatTextType.text_plain) and (not data.isSysMsg or data.isSysMsg == 0) then
		if data.isShowTranslate == false or data.isShowTranslate == nil or data.isShowTranslate == 0 then
			return false
		else
			return true
		end
	end
	return false
end
function chatMenuMgr:cond_OpShield(menuType, opId, data)
	condParser = nil
	;(nil).condtype = gCondType.playerInShiled
	;(nil).condvalue = data.playerId
	return not condParser.verify(nil)
end
function chatMenuMgr:cond_OpUnShield(menuType, opId, data)
	condParser = nil
	;(nil).condtype = gCondType.playerInShiled
	;(nil).condvalue = data.playerId
	return condParser.verify(nil)
end
function chatMenuMgr:cond_OpReportHeadImg(menuType, opId, data)
	if data.avatarUrl and data.avatarUrl ~= "" then
		return true
	end
	return false
end
function chatMenuMgr:cond_OpInvite(menuType, opId, data)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local playerAlliance = allianceMgr:getAlliance()
	if (data.allianceId == nil or data.allianceId == 0) and playerAlliance ~= nil then
		_ENV = nil
		;(nil).condtype = gCondType.alliancePermission
		;(nil).condvalue = gAPermission.RECRUIT
		return condParser.verify(nil)
	end
end
function chatMenuMgr:cond_OpJoin(menuType, opId, data)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local playerAlliance = allianceMgr:getAlliance()
	if data.allianceId ~= nil and data.allianceId ~= 0 and playerAlliance == nil then
		return true
	end
	return false
end
function chatMenuMgr:cond_OpReport(menuType, opId, data)
	if data.isSysMsg == true or data.isSysMsg == 1 then
		return false
	end
	local dataType = data.dataType
	if gChatDataType.dataType_emotion == dataType then
		return false
	end
	return true
end
function chatMenuMgr:cond_OpForbidLord(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel == gChatChannel.ALLIANCE then
		_ENV = nil
		;(nil).condtype = gCondType.allianceRank
		;(nil).condvalue = gAllianceRank.R5
		if condParser.verify(nil) then
			_ENV = nil
			;(nil).condtype = gCondType.playerInAllianceShiled
			;(nil).condvalue = data.playerId
			if not condParser.verify(nil) then
				local serverMsg = data.serverMsg
				if data.isSysMsg and serverMsg.content and type(serverMsg.content) == "table" and serverMsg.content.textType == gChatTextType.text_id and serverMsg.content.text == "alliance_chat_notice_02" then
					return false
				end
				return true
			end
		end
	end
	return false
end
function chatMenuMgr:cond_OpBuy(menuType, opId, data)
	if not self.checkBubbleTbl then
		_UPVALUE7_ = self.checkBubbleTbl
		self.checkBubbleTbl, self.checkBubbleTbl[1] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_NORMAL
		self.checkBubbleTbl, self.checkBubbleTbl[2] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_SYSTEM
		self.checkBubbleTbl, self.checkBubbleTbl[3] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_KING
		self.checkBubbleTbl, self.checkBubbleTbl[4] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_RED_PACKET
		self.checkBubbleTbl, self.checkBubbleTbl[5] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_SUPER_PACKET
		self.checkBubbleTbl, self.checkBubbleTbl[6] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_HORN
		self.checkBubbleTbl, self.checkBubbleTbl[7] = self.checkBubbleTbl, gBubbleId.BUBBLE_ID_LEGEND_KING
	end
	local isFiltered = false
	for _, v in ipairs(self.checkBubbleTbl) do
		if v == data.bubbleId then
			isFiltered = true
		end
	end
	if not isFiltered and data.customProperty and data.customProperty.sysBubbleId and data.customProperty.sysBubbleId > 0 then
		return true
	end
	return false
end
function chatMenuMgr:cond_OpUnShieldThisLord(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel ~= gChatChannel.ALLIANCEMSG then
		return false
	end
	_ENV = nil
	;(nil).condtype = gCondType.allianceRank
	;(nil).condvalue = gAllianceRank.R5
	if condParser.verify(nil) then
		_ENV = nil
		;(nil).condtype = gCondType.playerInAllianceShiled
		;(nil).condvalue = data.playerId
		if condParser.verify(nil) then
			return true
		end
	end
	return false
end
function chatMenuMgr:cond_OpShieldThisLord(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel ~= gChatChannel.ALLIANCEMSG then
		return false
	end
	_ENV = nil
	;(nil).condtype = gCondType.allianceRank
	;(nil).condvalue = gAllianceRank.R5
	if condParser.verify(nil) then
		_ENV = nil
		;(nil).condtype = gCondType.playerInAllianceShiled
		;(nil).condvalue = data.playerId
		if not condParser.verify(nil) then
			return true
		end
	end
	return false
end
function chatMenuMgr:cond_OpUnShieldThisAlliance(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel ~= gChatChannel.ALLIANCEMSG then
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local playerAlliance = allianceMgr:getAlliance()
	if data.allianceId ~= nil and data.allianceId ~= 0 and playerAlliance ~= nil then
		_ENV = nil
		;(nil).condtype = gCondType.allianceRank
		;(nil).condvalue = gAllianceRank.R5
		if condParser.verify(nil) then
			_ENV = nil
			;(nil).condtype = gCondType.allianceInShield
			;(nil).condvalue = data.allianceId
			if condParser.verify(nil) then
				return true
			end
		end
	end
	return false
end
function chatMenuMgr:cond_OpDeleteMsg(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel ~= gChatChannel.ALLIANCEMSG then
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local playerAlliance = allianceMgr:getAlliance()
	local chatFunctions = include("chatFunctions")
	if data.allianceId ~= nil and playerAlliance ~= nil then
		_ENV = nil
		;(nil).condtype = gCondType.allianceRank
		;(nil).condvalue = gAllianceRank.R5
		if not condParser.verify(nil) then
			_ENV = nil
			;(nil).condtype = gCondType.allianceRank
			;(nil).condvalue = gAllianceRank.OFFICIAL
			if not condParser.verify(nil) then
				goto lbl_50
			end
		end
		return true
	end
	::lbl_50::
	return false
end
function chatMenuMgr:cond_OpShieldThisAlliance(menuType, opId, data)
	local chatChannel = data.chatChannel
	if chatChannel ~= gChatChannel.ALLIANCEMSG then
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local playerAlliance = allianceMgr:getAlliance()
	if data.allianceId ~= nil and data.allianceId ~= 0 and playerAlliance ~= nil then
		_ENV = nil
		;(nil).condtype = gCondType.allianceRank
		;(nil).condvalue = gAllianceRank.R5
		if condParser.verify(nil) then
			_ENV = nil
			;(nil).condtype = gCondType.allianceInShield
			;(nil).condvalue = data.allianceId
			if not condParser.verify(nil) then
				return true
			end
		end
	end
	return false
end
return chatMenuMgr
