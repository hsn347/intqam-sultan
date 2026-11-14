local baseComponent = require("fgui.base.baseComponent")
local AllianceWarRallyMember = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/AllianceWarRallyMember", AllianceWarRallyMember)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local queueTimeUtil = include("queueTimeUtil")
function AllianceWarRallyMember:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.tableMemberData, _ENV, self.type = gAWarRallyMemberType.LOCK, gAWarRallyMemberType.LOCK, gAWarRallyMemberType.LOCK
	self.isLaunched = false
	self.isCaptain = false
	self.closeBtn = false
	self.tableArmy, _ENV, self.timer = gAWarRallyMemberType.LOCK, gAWarRallyMemberType.LOCK, nil
	self.maxCount = 0
	self.ownTeam = false
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.layerTouch = self.fields.imgBg
	self.layerTouch:setSwallowTouches(false)
	self.spriteArr = self.fields.Sprite_arr
	self.labelTroops = self.fields.Text_troops
	self.labelName = self.fields.Text_name
	self.labelState = self.fields.Text_state
	self.imgFrame = self.fields.Image_frame
	self.imgFrame:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickHead))
	self.spriteIcon = self.fields.Sprite_icon
	self.labelNotice = self.fields.Text_notice
	self.layerMember = self.fields.Panel_member
	self.nodeSpeedUp = self.fields.Node_speedUp
	self.btnSpeedUp = self.fields.Button_speedUp
	self.btnSpeedUp:setTitle(i18n("common_text_018"))
	self.btnSpeedUp:setVisible(false)
	self.loadingBarTime = self.fields.LoadingBar_bar
	self.labelTime = fguiHelper.get_fields(self.loadingBarTime).txtTitle
	self.btnRepatriate = self.fields.Button_repatriate
	self.btnRepatriate:setVisible(false)
	self.btnRepatriate:setSwallowTouches(false)
	self.layerTouch:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
	self.btnSpeedUp:addClickEventListener(handler(self, self.btnSpeedUpClickCallBack))
	self.btnRepatriate:addClickEventListener(handler(self, self.btnRepatriateClickCallBack))
	self.spriteArr:setRotation(SoraDFPosX(90, 0))
end
function AllianceWarRallyMember:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE", function(target, data)
		if data.maxMassNum and data.massNum then
			self.maxCount = data.maxMassNum - data.massNum
			if self.dispatchPanel and SoraDSearchPanelFromManager(self.dispatchPanel) then
				self.dispatchPanel:updateMaxCount(self.maxCount)
			else
				self.dispatchPanel = nil
			end
		end
		if data.ownTeam ~= nil and self.ownTeam ~= data.ownTeam then
			self.tableMemberData.ownTeam = data.ownTeam
			if self.isLaunched then
				self:initArmy()
			end
		end
	end)
end
function AllianceWarRallyMember:setScroll(scroll)
	self.scroll = scroll
end
function AllianceWarRallyMember:getSingleH()
end
function AllianceWarRallyMember:setClickCallBack(handle)
	self.handle = handle
end
function AllianceWarRallyMember:initData(data, type, index, isLaunched)
	self.index = index
	self.tableMemberData = data
	self.type = type
	if self.type == gAWarRallyMemberType.LOCK then
		self:showLockSingle()
	elseif self.type == gAWarRallyMemberType.OPEN then
		self:showOpenSingle()
	elseif self.type == gAWarRallyMemberType.FULL then
		self.isLaunched = isLaunched
		self:showMemberSingle()
	elseif self.type == gAWarRallyMemberType.CLOSED then
		self:showClosedSingle()
	elseif self.type == gAWarRallyMemberType.NO_SPACE then
		self:showNoSpaceSingle()
	end
end
function AllianceWarRallyMember:showMember(isShow)
	self.controllers.c1:setSelectedIndex(isShow and 1 or 0)
	if not isShow then
		self:showQueue(isShow)
		self:setState(isShow)
	end
	self.imgFrame:setTouchEnabled(isShow)
end
function AllianceWarRallyMember:updateMemberSingle()
	SoraDGetHeadFromManager(self.spriteIcon, self.tableMemberData.data.headid, self.tableMemberData.data.avatar)
	self.labelName:setString(self.tableMemberData.data.name)
	local armyCount = 0
	if not self.tableMemberData.data.army then
		_ENV = self.tableMemberData.data.army
	end
	for _, v in ipairs(self.tableMemberData.data.army) do
		armyCount = armyCount + v.num
	end
	_ENV = nil
	;(nil).cur = string.formatnumberthousands(armyCount)
	self.labelTroops:setString(i18n("common_text_297", nil))
	local status = self.tableMemberData.data.status or self.tableMemberData.queue.status
	if status == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		self.labelState:setVisible(true)
		if self.tableMemberData.teamStatus == gAWarViewMemberType.ATTACKER or self.tableMemberData.teamStatus == gAWarViewMemberType.NONE then
			self.labelState:setString(i18n("common_text_298"))
		else
			self.labelState:setString(i18n("common_text_2608"))
		end
		self:showQueue(false)
		self.nodeSpeedUp:setVisible(false)
	elseif status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		self.labelState:setVisible(false)
		self:showQueue(true)
		self.nodeSpeedUp:setVisible(true)
		local isForbid = worldMapDefine.isInWarForbidSpeed(self.tableMemberData.queue, true)
		if isForbid then
			self.btnSpeedUp:setVisible(false)
		else
			self.btnSpeedUp:setVisible(self.ownTeam)
		end
	else
		self.labelState:setVisible(false)
		self:showQueue(false)
		self.nodeSpeedUp:setVisible(false)
	end
end
function AllianceWarRallyMember:showQueue(isShow)
	if isShow then
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:openTimeUp()
	elseif self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		if self.isLaunched then
			self:initArmy()
		end
	end
end
function AllianceWarRallyMember:openTimeUp(dt)
	local leftTime = queueTimeUtil.getRemainTime(self.tableMemberData.queue)
	local totalTime = queueTimeUtil.getTotalTime(self.tableMemberData.queue)
	queueTimeUtil = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelTime:setString(i18n("common_text_295", nil))
	self.loadingBarTime:setPercent((totalTime - leftTime) / totalTime)
	if leftTime <= 0 then
		local status = self.tableMemberData.data.status or self.tableMemberData.queue.status
		if status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.tableMemberData.data.status = gMapMoveLineStatusType.moveLineStatusTypeWorking
			self:updateMemberSingle()
		end
	end
end
function AllianceWarRallyMember:showMemberSingle()
	self:showMember(true)
	self:setState(self.isLaunched)
	self.isCaptain = self.tableMemberData.isCaptain
	self.closeBtn = self.tableMemberData.mainStatus == gMapMoveLineStatusType.moveLineStatusTypeMoving
	self.ownTeam = self.tableMemberData.ownTeam
	self.isSelfTeam = lordInfoCtrl:getLordInfo().base.uid == self.tableMemberData.data.uid and self.tableMemberData.teamStatus == gAWarViewMemberType.NONE
	self.isShowDetail = false
	if (self.isSelfTeam or self.isCaptain) and not self.closeBtn then
		self.isShowDetail = true
	end
	dump(self.isShowDetail, "self.isShowDetail")
	self:updateMemberSingle()
	if not self.tableMemberData.queue or not self.tableMemberData.queue.attr then
		local _ENV, attr = self.tableMemberData.queue.attr, self.tableMemberData.queue.attr
	end
	if attr[tostring(gAttributeEnum.MASS_SLAVE_ATTACK_RATE)] then
		if not self.skillNode then
			self.skillNode = self:createSkillNode()
		end
		self.skillNode:setVisible(true)
	elseif self.skillNode then
		self.skillNode:setVisible(false)
	end
	if self.tableMemberData.data.allianceRank then
		local allianceDesRead = include("allianceDesRead")
		local iconName = allianceDesRead.getIcon(self.tableMemberData.data.allianceRank)
		self.rankSprite = self.fields.rankSprite
		self.rankSprite:setVisible(true)
		self.rankSprite:setSpriteFrame(iconName)
	elseif self.rankSprite then
		self.rankSprite:setVisible(false)
	end
end
function AllianceWarRallyMember:createSkillNode(...)
	local node = display.newNode()
	self.fields.skillNodeLoader:setContent(node)
	node:setPosition(self.imgFrame:getPositionX() + 30, self.imgFrame:getPositionY() + 30)
	local talentSkillCtrl = SoraDGetCtrl("talentSkillCtrl")
	local icon = talentSkillCtrl:getSkillIcon(2)
	local sprite = display.newSprite("#" .. icon)
	sprite:addTo(node)
	sprite:setScale(0.3)
	local sprite = display.newSprite("#frame_lantutianfu_shaixuan_kuan.png")
	sprite:addTo(node)
	sprite:setScale(0.4)
	return node
end
function AllianceWarRallyMember:showLockSingle()
	self:showMember(false)
	self:setState(false)
	self.fields.lock:setURL("icon_fight_block.png")
	self.labelNotice:setString(i18n("common_text_304"))
end
function AllianceWarRallyMember:showNoSpaceSingle()
	self:showMember(false)
	self:setState(false)
	self.fields.text_noSpace:setString(i18n("mass_ui_text4"))
	self.controllers.c1:setSelectedIndex(2)
end
function AllianceWarRallyMember:showClosedSingle()
	self:showMember(false)
	self:setState(false)
	self.fields.lock:setURL("icon_fight_block.png")
	self.labelNotice:setString(i18n("common_text_300"))
end
function AllianceWarRallyMember:showOpenSingle()
	self:showMember(false)
	self:setState(false)
	self.fields.lock:setURL("frame_LegendaryKing_green_add.png")
	self.labelNotice:setString(i18n("common_text_303"))
end
function AllianceWarRallyMember:getState()
	return self.isLaunched
end
function AllianceWarRallyMember:setState(state)
	if tolua.isnull(self) then
		return
	end
	if not state then
		self:removeArmy()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:initArmy()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceWarRallyMember:initArmy()
	self.fields.Panel_member:setVisible(true)
	self.fields.Panel_member:initMemberData(self.tableMemberData.data)
	self.ownTeam = self.tableMemberData.ownTeam
	if self.isShowDetail then
		self.fields.Panel_member:setBottomHeight(100)
		self.btnRepatriate:setVisible(true)
		if self.isSelfTeam then
			self.btnRepatriate:setTitle(i18n("common_text_017"))
		else
			self.btnRepatriate:setTitle(i18n("common_text_302"))
		end
	else
		self.fields.Panel_member:setBottomHeight(0)
		self.btnRepatriate:setVisible(false)
	end
	self:setSize(636, 130 + self.fields.Panel_member:getSize().height)
end
function AllianceWarRallyMember:removeArmy()
	self.tableArmy, _UPVALUE0_ = nil, nil
	self.btnRepatriate:setVisible(false)
	self.layerMember:setVisible(false)
	self:setSize(636, 130)
end
function AllianceWarRallyMember:btnRepatriateClickCallBack(button, type)
	SoraDPlaySound()
	if self.isSelfTeam then
		_ENV = nil
		_ENV, (nil).itemType = gItemType.MARCH_BACK, gItemType.MARCH_BACK
		;(nil).troopData, gItemType.MARCH_BACK.troopsID = gItemType.MARCH_BACK, self.tableMemberData.queue.id
		uiManager:show("speedUpReCallBuyView", nil)
	else
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqBackQueueById(self.tableMemberData.queue.id)
	end
end
function AllianceWarRallyMember:btnSpeedUpClickCallBack(button, type)
	if self.type == gAWarRallyMemberType.FULL then
		SoraDPlaySound()
		if not self.tableMemberData.queue:isCanUseSpeedInQueue() then
			print(i18n("common_text_4513"))
			SoraDShowMsgTip(i18n("common_text_4513"))
			return
		end
		if not self.tableMemberData.queue:isCanUseSpeedInAtlantis() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0276"))
			return
		end
		_ENV = i18n("atlantiswar_text_0276")
		_ENV, i18n("atlantiswar_text_0276").itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
		i18n("atlantiswar_text_0276").troopData, gItemType.MARCH_SPEED_UP.troopsID = gItemType.MARCH_SPEED_UP, self.tableMemberData.queue.id
		uiManager:show("speedUpReCallBuyView", i18n("atlantiswar_text_0276"))
	end
end
function AllianceWarRallyMember:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.type == gAWarRallyMemberType.LOCK then
	elseif self.type == gAWarRallyMemberType.OPEN then
		if self.tableMemberData.isSelfIn then
			SoraDShowMsgTip(i18n("common_text_652"))
			return
		end
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = i18n("common_text_652")
		i18n("common_text_652").massData = self.tableMemberData.data
		if not worldMapWarDef.checkCanJoinMass(i18n("common_text_652")) then
			return
		end
		local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
		if worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) and legendTeamCtrl:isTeamCommander() then
			if legendTeamCtrl:isTeamCommander() then
				SoraDShowMsgTip(i18n("legendary_commander_text26"))
				return
			end
			if not legendTeamCtrl:isHasTeam() then
				SoraDShowMsgTip(i18n("legendary_commander_text30"))
				return
			end
		end
		if self.maxCount <= 0 then
		end
		if SoraDEnoughTroops() then
			_ENV = SoraDEnoughTroops()
			_ENV, SoraDEnoughTroops().toPoint = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y)
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massId = self.tableMemberData.id
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).endTime = self.tableMemberData.endTime
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveForbidArmyClass = self.tableMemberData.massSlaveForbidArmyClass
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinLv = self.tableMemberData.massSlaveArmyMinLv
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).mainInstanceType = self.tableMemberData.mainObjType
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinNum = self.tableMemberData.massSlaveArmyMinNum
			cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMaxNum = self.tableMemberData.massSlaveArmyMaxNum
			SoraDEnoughTroops().otherData, cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).isForbidSpeed = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), self.tableMemberData.isForbidSpeed
			SoraDEnoughTroops().instanceID = self.tableMemberData.data.mapObjId
			SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
			SoraDEnoughTroops().instanceType = gMapObjTypeDef.mapObjTypePlayer
			SoraDEnoughTroops().maxCount = self.maxCount
			SoraDEnoughTroops().isJoinMass = true
			local SoraDEnoughTroops().attr, dispatchData = self.tableMemberData.attr, SoraDEnoughTroops()
			local dispatchFun = function(callType)
				if callType == nil or callType == MSGBOX_CALLBACK_YES then
					if not self.__cname then
						print("对象已经被释放")
						return
					end
					dispatchData.maxCount = self.maxCount
					self.dispatchPanel = uiManager:show("WorldDispatchArmyView")
					self.dispatchPanel:initData(dispatchData)
				end
			end
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			if kingdomMapCtrl:reqIsSafe() and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapObjTypeBoss and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss1 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss2 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeATBuilding and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWerewolf and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWrathBeast and self.tableMemberData.mainObjType ~= gMapObjTypeDef.wastelandBoss and self.tableMemberData.mainObjType ~= gMapObjTypeDef.sweetMeatRobber and self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeAllianceBuild and self.tableMemberData.mainObjId ~= gMapAllianceBuildType.subTypeAllianceAltar then
				local showMsg = i18n("notice_0160")
				SoraDShowMsgBox(showMsg, i18n("common_text_490"), i18n("common_text_185"), dispatchFun)
			elseif self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeBoss or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf then
				local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
				local bossType = self.tableMemberData.mainObjId
				local limitType = _G.gBossType2LimitType[bossType] or bossType
				if self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf then
					limitType = gBossType.werewolf
				end
				local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
				local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
				if not isAttackReward then
					local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
					if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
						_ENV = i18n("legendary_commander_text30")
						i18n("legendary_commander_text30").maxAttack = maxAttack
						SoraDShowMsgBox(i18n("herobattle_text_19", i18n("legendary_commander_text30")), i18n("common_text_204"), nil, dispatchFun)
					else
						_ENV = nil
						;(nil).maxAttack = maxAttack
						SoraDShowMsgBox(i18n("common_text_2151", nil), i18n("common_text_204"), nil, dispatchFun)
					end
				elseif not isKillReward then
					local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
					if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
						_ENV = nil
						;(nil).maxKill = maxKill
						SoraDShowMsgBox(i18n("herobattle_text_20", nil), i18n("common_text_204"), nil, dispatchFun)
					else
						_ENV = nil
						;(nil).maxKill = maxKill
						SoraDShowMsgBox(i18n("common_text_2152", nil), i18n("common_text_204"), nil, dispatchFun)
					end
				else
					dispatchFun()
				end
			else
				dispatchFun()
			end
		end
	elseif self.type == gAWarRallyMemberType.FULL then
		self:setState(not self.isLaunched)
		if self.handle then
			self.handle(self.index, self.isLaunched)
		end
	elseif self.type == gAWarRallyMemberType.CLOSED then
	end
end
function AllianceWarRallyMember:btnClickHead(button, type)
	if self.type == gAWarRallyMemberType.FULL then
		SoraDPlaySound()
		_ENV = gAWarRallyMemberType.FULL
		gAWarRallyMemberType.FULL.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		gAWarRallyMemberType.FULL.playerID = self.tableMemberData.data.uid
		SoraDSendMessage(gAWarRallyMemberType.FULL)
	end
end
return AllianceWarRallyMember
