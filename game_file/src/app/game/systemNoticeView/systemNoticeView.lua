local chatDesRead = include("chatDesRead")
local systemNoticeView = class("systemNoticeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("systemNoticeView")
	end
	return target
end)
function systemNoticeView:ctor()
	self.layout_content = SoraDGetChildByName(self, "Top_Size_layout_content")
	self.layout_content:setSwallowTouches(false)
	self:setSwallowTouches(false)
	self:setTouchEnabled(false)
	self.arrayVerticalPosY, _ENV, self.tableNoticeShow, _ENV, self.tableNoticeOthers, _ENV, self.tableNoticeKingdomAll, _ENV = self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled, self.setTouchEnabled
	table.insert(self.arrayVerticalPosY, #self.arrayVerticalPosY + 1, self.layout_content:getContentSize().height - 235)
	table.insert(self.arrayVerticalPosY, #self.arrayVerticalPosY + 1, self.layout_content:getContentSize().height / 2)
	table.insert(self.arrayVerticalPosY, #self.arrayVerticalPosY + 1, 175)
end
function systemNoticeView:getIsMsgFull()
	local ret = false
	if #self.tableNoticeShow >= 3 then
		ret = true
	end
	return ret
end
function systemNoticeView:getShowMsg()
	return self.tableNoticeShow
end
function systemNoticeView:getPickMsg(number)
	local pickedNumber = 0
	local _ENV, pickTable
	local hasAnyNoticeKingdomAll = self:getHasNoticeKingdomAll()
	local isNoticeKingdomAllPicked = false
	if hasAnyNoticeKingdomAll == false and 0 < #self.tableNoticeKingdomAll then
		table.insert(pickTable, #pickTable + 1, self.tableNoticeKingdomAll[1])
		table.remove(self.tableNoticeKingdomAll, 1)
		pickedNumber = pickedNumber + 1
		isNoticeKingdomAllPicked = true
		if pickedNumber == number then
			return pickTable
		end
	end
	if number == 1 and hasAnyNoticeKingdomAll == false and isNoticeKingdomAllPicked == false then
		return pickTable
	end
	while number > pickedNumber and 0 < #self.tableNoticeOthers do
		for i, v in ipairs(self.tableNoticeOthers) do
			table.insert(pickTable, #pickTable + 1, self.tableNoticeOthers[1])
			table.remove(self.tableNoticeOthers, 1)
			pickedNumber = pickedNumber + 1
			return pickTable
		end
	end
	return pickTable
end
function systemNoticeView:getHasNoticeKingdomAll()
	local ret = false
	local showMsg = self:getShowMsg()
	for i, v in ipairs(showMsg) do
		if v.isShow and v.isShow == true then
			local boxNode = v.node
			if boxNode and v.sysNoticeType == gSystemNoticeTypeDef.sys_notice_kingdom_all then
				ret = true
				break
			end
		end
	end
	return ret
end
function systemNoticeView:pickMsg()
	local showMsg = self:getShowMsg()
	local _ENV, pickTable = self, self
	if #showMsg == 2 then
		return
	elseif #showMsg == 1 then
		pickTable = self:getPickMsg(1)
	elseif #showMsg == 0 then
		pickTable = self:getPickMsg(2)
	end
	for i, v in ipairs(pickTable) do
		table.insert(self.tableNoticeShow, v)
	end
end
function systemNoticeView:showMsg()
	for i, v in ipairs(self.tableNoticeShow) do
		if v.isShow == nil or v.isShow == false then
			_ENV = nil
			;(nil).data = v
			self:showNotice(nil)
		else
		end
	end
end
function systemNoticeView:arrangeMsg()
	local vertialAlign = 1
	local isNoticeKingdomAllExist = false
	local indexNoticeKingdomAllExist = 0
	for i, v in ipairs(self.tableNoticeShow) do
		if v.isShow and v.isShow == true then
			local boxNode = v.node
			if boxNode then
				if v.sysNoticeType == gSystemNoticeTypeDef.sys_notice_kingdom_all then
					isNoticeKingdomAllExist = true
					indexNoticeKingdomAllExist = i
					vertialAlign = 1
					self:arrangeNodeOnPos(boxNode, vertialAlign)
					vertialAlign = vertialAlign + 1
					break
				else
					self:arrangeNodeOnPos(boxNode, vertialAlign)
					vertialAlign = vertialAlign + 1
				end
			end
		end
	end
	if true == isNoticeKingdomAllExist then
		for i, v in ipairs(self.tableNoticeShow) do
			if v.isShow and v.isShow == true then
				local boxNode = v.node
				if boxNode and i ~= indexNoticeKingdomAllExist then
					self:arrangeNodeOnPos(boxNode, vertialAlign)
					vertialAlign = vertialAlign + 1
				end
			end
		end
	end
end
function systemNoticeView:arrangeNodeOnPos(node, vertialAlign)
	local posY = self.arrayVerticalPosY[vertialAlign]
	if node then
		node:setPositionY(posY)
	end
end
function systemNoticeView:msgRemoveMsg(target, data)
	local data = data.data
	self:removeMsg(data)
end
function systemNoticeView:removeMsg(data)
	local data = data
	for i, v in ipairs(self.tableNoticeShow) do
		if v == data then
			table.remove(self.tableNoticeShow, i)
			break
		end
	end
	self:updateSystemNoticeView()
end
function systemNoticeView:updateSystemNoticeView()
	if #self.tableNoticeShow == 3 then
		return
	end
	if #self.tableNoticeKingdomAll > 0 or 0 < #self.tableNoticeOthers then
		self:pickMsg()
		self:showMsg()
		self:arrangeMsg()
	end
end
function systemNoticeView:showNotice(data)
	local data = data.data
	local sysNoticeType = data.sysNoticeType
	if nil == sysNoticeType then
		return
	end
	if sysNoticeType == gSystemNoticeTypeDef.sys_notice_kingdom_all then
		local systemNoticeBoxType1 = include("systemNoticeBoxType1")
		local boxNode = systemNoticeBoxType1.new()
		boxNode:initWithData(data)
		self.layout_content:addChild(boxNode)
		boxNode:setSwallowTouches(false)
		boxNode:setPosition(cc.p(0, self.layout_content:getContentSize().height - 200))
		data.node = boxNode
		data.isShow = true
	elseif sysNoticeType == gSystemNoticeTypeDef.sys_notice_server then
		local systemNoticeBoxType2 = include("systemNoticeBoxType2")
		local boxNode = systemNoticeBoxType2.new()
		boxNode:initWithData(data)
		self.layout_content:addChild(boxNode)
		boxNode:setSwallowTouches(false)
		boxNode:setPosition(cc.p(0, self.layout_content:getContentSize().height - 200))
		data.node = boxNode
		data.isShow = true
	elseif sysNoticeType == gSystemNoticeTypeDef.sys_notice_kingdom_msg then
		if data.content.npcImgId ~= nil then
			local systemNoticeBoxType2 = include("systemNoticeBoxType2")
			local boxNode = systemNoticeBoxType2.new()
			data.content.npcImgId = nil
			boxNode:initWithData(data)
			self.layout_content:addChild(boxNode)
			boxNode:setSwallowTouches(false)
			boxNode:setPosition(cc.p(0, self.layout_content:getContentSize().height - 200))
			data.node = boxNode
			data.isShow = true
		else
			local systemNoticeBoxType3 = include("systemNoticeBoxType3")
			local boxNode = systemNoticeBoxType3.new()
			boxNode:initWithData(data)
			self.layout_content:addChild(boxNode)
			boxNode:setSwallowTouches(false)
			boxNode:setPosition(cc.p(0, self.layout_content:getContentSize().height - 200))
			data.node = boxNode
			data.isShow = true
		end
	elseif sysNoticeType == gSystemNoticeTypeDef.sys_notice_other then
		local ui_type = data.ui_type
		local language_key = data.language_key
		local value_table = data.value_table
		if ui_type == nil then
			ui_type = 2
		end
		if language_key ~= nil and value_table ~= nil then
			local strContent = i18n(language_key, value_table)
			_ENV = language_key
			data.content, language_key.content = language_key, strContent
		end
		local boxNode
		if ui_type == 1 then
			local systemNoticeBoxType1 = include("systemNoticeBoxType1")
			boxNode = systemNoticeBoxType1.new()
		elseif ui_type == 2 then
			local systemNoticeBoxType2 = include("systemNoticeBoxType2")
			boxNode = systemNoticeBoxType2.new()
		elseif ui_type == 3 then
			local systemNoticeBoxType3 = include("systemNoticeBoxType3")
			boxNode = systemNoticeBoxType3.new()
		else
			print("not defined! boxNode is nil, ui_type = ", ui_type)
		end
		boxNode:initWithData(data)
		self.layout_content:addChild(boxNode)
		boxNode:setSwallowTouches(false)
		boxNode:setPosition(cc.p(0, self.layout_content:getContentSize().height - 200))
		data.node = boxNode
		data.isShow = true
	end
end
function systemNoticeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SYSTEM_NOTICE_UI_SHOW_NOTICE", handler(self, self.msgShowNotice))
	SoraDAddMessage(self, "MESSAGE_SYSTEM_NOTICE_UI_CLOSE_VIEW", handler(self, self.removeNoticeView))
	SoraDAddMessage(self, "MESSAGE_SYSTEM_NOTICE_UI_REMOVE_NOTICE", handler(self, self.msgRemoveMsg))
	SoraDAddMessage(self, "MESSAGE_SYSTEM_NOTICE_UI_CLEAN_NOTICE", handler(self, self.msgCleanMsg))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.msgLoginFinish))
end
function systemNoticeView:msgShowNotice(target, data)
	dump(data, "公告数据")
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:getCurMainCityGuideStep() ~= nil then
		return
	end
	local data = data.data
	local sysNoticeType = data.sysNoticeType
	if worldMapDefine.isInAnchorMode() then
		return
	end
	if worldMapDefine.isInNebula() then
		_ENV = worldMapDefine.isInNebula()
		worldMapDefine.isInNebula()[gSystemNoticeKingdomMsgTypeDef.nebula_war_finish_occupy_build] = true
		worldMapDefine.isInNebula()[gSystemNoticeKingdomMsgTypeDef.nebula_war_occupy_palace] = true
		worldMapDefine.isInNebula()[gSystemNoticeKingdomMsgTypeDef.nebula_war_palace_protected_end] = true
		local worldMapDefine.isInNebula()[gSystemNoticeKingdomMsgTypeDef.nebula_war_finish_occupy_common], config = true, worldMapDefine.isInNebula()
		if config[data.kingdomMsgType] and SoraDConfigGet("Game:GameOptionsView:shieldNebula~bool") then
			print("设置屏蔽了星云之战跑马灯")
			return
		end
		if data.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.nebula_war_mine_npc then
			local nebulaWarRead = include("nebulaWarRead")
			local nebulaWarUtil = include("nebulaWarUtil")
			local build2 = data.sysContent.values.build2
			local buildType = nebulaWarRead.getBuildTypeByBuildId(build2)
			if not nebulaWarUtil.checkBuildCanAttack2(buildType) then
				return
			end
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		_ENV = worldMapDefine.isInNebulaAllStar()
		worldMapDefine.isInNebulaAllStar()[gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_star_value] = 1
		worldMapDefine.isInNebulaAllStar()[gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_rob_support_value] = 2
		worldMapDefine.isInNebulaAllStar()[gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_star_value] = 1
		local worldMapDefine.isInNebulaAllStar()[gSystemNoticeKingdomMsgTypeDef.nebula_allstar_war_support_value], config = 2, worldMapDefine.isInNebulaAllStar()
		local value = config[data.kingdomMsgType]
		if value then
			local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
			local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
			if (value ~= 1 or not myTeamInfo:getIsSuperTeam()) and (value ~= 2 or not myTeamInfo:getIsBackupTeam()) then
				return
			end
		end
	end
	local worldMapDefine = include("worldMapDefine")
	local isInWar = worldMapDefine.isInWar()
	if isInWar then
		data.closeable = true
	else
		local kingdomMsgType = data.kingdomMsgType
		if kingdomMsgType then
			if gSystemNoticeKingdomMsgTypeDef.chat_anchor_privilege_debut == kingdomMsgType then
				if not worldMapDefine.isInDJChatView then
					return
				end
				_ENV = myTeamInfo:getIsBackupTeam()
				myTeamInfo:getIsBackupTeam().msg = "MESSAGE_CHAT_DJ_SHOW_EFFECT"
				SoraDSendMessage((myTeamInfo:getIsBackupTeam()))
			end
			local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
			if cfg and cfg.close == 1 then
				data.closeable = true
			end
		end
	end
	data.startTime = os.time()
	if data.content == "Undefined" or data.content == nil or data.content.content == "Undefined" or data.content.content == nil then
		return
	end
	if data.chatType and data.chatType == gChatTypeDef.chat_camp_horn then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		data.chatCamp = nebulaActivityCtrl:getSelfCamp()
	end
	if sysNoticeType == gSystemNoticeTypeDef.sys_notice_kingdom_all then
		table.insert(self.tableNoticeKingdomAll, #self.tableNoticeKingdomAll + 1, data)
		print("现有喇叭数量:begin--------------------------")
		dump(self.tableNoticeKingdomAll)
		print("现有喇叭数量:end--------------------------")
	else
		if self:canInsertNotice(data) then
			table.insert(self.tableNoticeOthers, #self.tableNoticeOthers + 1, data)
		end
		if data.content and type(data.content) == "table" and not data.content.weight then
			data.content.weight = 1
		end
		table.sort(self.tableNoticeOthers, function(a, b)
			return a.content.weight > b.content.weight
		end)
	end
	self:updateSystemNoticeView()
end
function systemNoticeView:canInsertNotice(data)
	local num = 0
	if data.kingdomMsgType ~= gSystemNoticeKingdomMsgTypeDef.solomonKey_rewardNotify then
		return true
	end
	for k, v in ipairs(self.tableNoticeOthers) do
		if v.kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.solomonKey_rewardNotify then
			num = num + 1
		end
		if 10 <= num then
			return false
		end
	end
	if num < 10 then
		return true
	end
end
function systemNoticeView:removeNoticeView(target, data)
	self:close(nil, ccui.TouchEventType.ended)
end
function systemNoticeView:msgLoginFinish(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_SYSTEM_NOTICE_UI_CLEAN_NOTICE"
	SoraDSendMessage(nil)
end
function systemNoticeView:msgCleanMsg(target, data)
	local curTime = os.time()
	local i, max
	local accuNum = 0
	i = 1
	max = #self.tableNoticeKingdomAll
	while i <= max do
		if self.tableNoticeKingdomAll[i].startTime and self.tableNoticeKingdomAll[i].startTime - curTime <= -gSystemNoticeExpireTime then
			table.remove(self.tableNoticeKingdomAll, i)
			i = i - 1
			accuNum = accuNum + 1
			max = max - 1
		end
		i = i + 1
	end
	i = 1
	max = #self.tableNoticeOthers
	while i <= max do
		if self.tableNoticeOthers[i].startTime and self.tableNoticeOthers[i].startTime - curTime <= -gSystemNoticeExpireTime then
			table.remove(self.tableNoticeOthers, i)
			i = i - 1
			accuNum = accuNum + 1
			max = max - 1
		end
		i = i + 1
	end
	i = 1
	max = #self.tableNoticeShow
	while i <= max do
		if self.tableNoticeShow[i].startTime and self.tableNoticeShow[i].node and self.tableNoticeShow[i].startTime and self.tableNoticeShow[i].startTime - curTime <= -gSystemNoticeExpireTime then
			self.tableNoticeShow[i].node:removeFromParent(true)
			table.remove(self.tableNoticeShow, i)
			i = i - 1
			accuNum = accuNum + 1
			max = max - 1
		end
		i = i + 1
	end
end
return systemNoticeView
