local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local worldMapWarDef = include("worldMapWarDef")
_ENV = "worldMapWarDef"
;("worldMapWarDef").activityExpPlus = i18n("activityname_11")
;("worldMapWarDef").buffExpPlus = i18n("npc_text_04")
;("worldMapWarDef").catchUpExpPlus = i18n("npc_text_01")
;("worldMapWarDef").conquestWarExpPlus = i18n("npc_text_05")
local ("worldMapWarDef").terrExpPlus, EXPDES = i18n("npc_text_03"), "worldMapWarDef"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldMapMonsterInfoPanel = class("worldMapMonsterInfoPanel", baseFguiPanel)
function worldMapMonsterInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("worldMapMonsterInfoPanel:ctor", self.viewName)
end
function worldMapMonsterInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldMapMonsterInfoPanel:onInit()
	print("=======worldMapMonsterInfoPanel:onInit")
	self.catchUpIsOpen = false
	self.buffDes, _ENV, self.buffTable, _ENV, self.buffNum = print, print, print, print, 0
	self.curKillSemlukNum = 0
	self.curKillIceHuntingNum = 0
	self.monster = nil
	self.tableVerifySprite, _ENV, self.tilePoint = print, print, nil
	local kingdomID = gametop.playertop_:getMapID()
	if self.param and self.param.mapView then
		kingdomID = self.param.mapView.kingdomID
	end
	self.isSelfKindom = kingdomID == gametop.playertop_:getMapID()
	self.attackButton = SoraDGetChildByName(self, "Button_attack")
	if self.attackButton then
		self.attackButton:setVisible(false)
	end
	self.attackNumText = SoraDGetChildByName(self, "attack_num")
	self.attackNumText:setVisible(false)
	self.text_Name = SoraDGetChildByName(self, "Text_monterName")
	self.text_talk = SoraDGetChildByName(self, "Text_monterTalk")
	self.text_talk:setNeedAutoFix(false)
	self.text_talk:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	self.text_Info = SoraDGetChildByName(self, "Text_info")
	if self.text_Info then
		self.text_Info:setVisible(false)
	end
	self.text_activityTip = SoraDGetChildByName(self, "Text_activity_tip")
	if self.text_activityTip then
		self.text_activityTip:setVisible(false)
	end
	local imgMostet = SoraDGetChildByName(self, "Image_monster")
	self.imageMonster = imgMostet
	local randomInfoLabel = SoraDGetChildByName(self, "Text_randomInfo")
	randomInfoLabel:setString(i18n("common_text_488"))
	self.nodeAddExp = SoraDGetChildByName(self, "Node_addExp")
	self.txtAddExp = SoraDGetChildByName(self, "Text_addExp")
	self.btnAddExp = SoraDGetChildByName(self, "Button_addExp")
	self.btnAddExp:addTouchEventListener(handler(self, self.btnAddExpClick))
	self.nodeAddExp:setVisible(false)
	self.txtBelong = SoraDGetChildByName(self, "Text_belong")
	self.fields.list:setItemRenderer(handler(self, self.onRewardRenderer))
	self.nodeVerify = SoraDGetChildByName(self, "Center_Node_verify")
	self.nodeVerify.fields = fguiHelper.get_fields(self.nodeVerify)
	self.btnVerify = SoraDGetChildByName(self.nodeVerify, "Button_verify")
	self.btnVerify:setTitle(i18n("common_text_204"))
	self.btnVerify:setVisible(false)
	self.nodeVerify:setVisible(false)
	self.labelVerifyNotice = SoraDGetChildByName(self.nodeVerify, "Text_verifyNotice")
	self.labelVerifyNotice:setString(i18n("common_text_2866"))
	_UPVALUE4_ = self.labelVerifyNotice.setString
	self.tableVerifySprite, self.labelVerifyNotice.setString[1] = self.labelVerifyNotice.setString, self.nodeVerify.fields.Button_monster_1
	self.tableVerifySprite, self.labelVerifyNotice.setString[2] = self.labelVerifyNotice.setString, self.nodeVerify.fields.Button_monster_2
	self.tableVerifySprite, self.labelVerifyNotice.setString[3] = self.labelVerifyNotice.setString, self.nodeVerify.fields.Button_monster_3
	self.tableVerifySprite, self.labelVerifyNotice.setString[4] = self.labelVerifyNotice.setString, self.nodeVerify.fields.Button_monster_4
	self.verifyMonsterAnis = nil
	self.btnVerify:addClickEventListener(handler(self, self.verifySendButtonCallFun))
	self.ccs_bg = SoraDGetChildByName(self.nodeVerify, "Panel_bg")
	self.ccs_bg:setTitle(i18n("verification_title_01"))
	self.nodeVerifySlider = SoraDGetChildByName(self, "Center_Node_verify_slider")
	self.nodeVerifySlider.fields = fguiHelper.get_fields(self.nodeVerifySlider)
	self.nodeVerifySlider:setVisible(false)
	self.verifySlider = SoraDGetChildByName(self.nodeVerifySlider, "Slider_slider")
	self.verifySlider:setValue(0)
	self.verifySlider:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnSliderChangeEnd))
	self.verifySlider:addEventListener(fgui.UIEventType.TouchBegin, function(eventContext)
		self:OnSliderTouchClick(eventContext, fgui.UIEventType.TouchBegin)
	end)
	self.verifySlider:addEventListener(fgui.UIEventType.TouchEnd, function(eventContext)
		self:OnSliderTouchClick(eventContext, fgui.UIEventType.TouchEnd)
	end)
	local ballNode = fguiHelper.get_fields(self.verifySlider).grip
	ballNode:addEventListener(fgui.UIEventType.TouchBegin, function(eventContext)
		self:OnSliderTouchClick(eventContext, fgui.UIEventType.TouchBegin)
	end)
	ballNode:addEventListener(fgui.UIEventType.TouchEnd, function(eventContext)
		self:OnSliderTouchClick(eventContext, fgui.UIEventType.TouchEnd)
	end)
	self.ballNode = ballNode
	self.nodeSliderBg = SoraDGetChildByName(self.nodeVerifySlider, "Node_sliderBg")
	self.nodeSliderBg.fields = fguiHelper.get_fields(self.nodeSliderBg)
	self.imgVerify = SoraDGetChildByName(self.nodeSliderBg, "Image_verify")
	self.ccs_bg = SoraDGetChildByName(self.nodeVerifySlider, "Panel_bg")
	self.ccs_bg:setTitle(i18n("verification_title_01"))
	self.spriteBegan = SoraDGetChildByName(self.nodeSliderBg, "Sprite_began")
	self.spriteBegan:setPositionX(60)
	self.spriteEnd = SoraDGetChildByName(self.nodeSliderBg, "Sprite_end")
	self.labelVerifyNoticeSlider = SoraDGetChildByName(self.nodeVerifySlider, "Text_verifyNoticeSlider")
	self.labelVerifyNoticeSlider:setString(i18n("verification__text_01"))
end
function worldMapMonsterInfoPanel:onShow()
	print("=======worldMapMonsterInfoPanel:onShow")
	self.catchUpIsOpen = false
	self.buffDes, _ENV, self.buffTable, _ENV, self.buffNum = print, print, print, print, 0
	self.curKillSemlukNum = 0
	self.curKillIceHuntingNum = 0
	self.monster = nil
	self.tilePoint = nil
	_ENV = nil
	;(nil).belong = "???"
	self.txtBelong:setString(i18n("common_text_3069", nil))
end
function worldMapMonsterInfoPanel:onHide()
	SoraDCloseLoading(self)
	self.nodeVerify:setVisible(false)
	self.nodeVerifySlider:setVisible(false)
	self.attackButton:setVisible(true)
end
function worldMapMonsterInfoPanel:OnSliderTouchClick(button, type)
	if type == fgui.UIEventType.TouchEnd then
		local killMonsterVerifyCtrl = gametop.playertop_:getModule("killMonsterVerifyCtrl")
		killMonsterVerifyCtrl:reqAnsterQuestion(self.verifySlider:getValue() * 0.8)
		SoraDShowLoading(self)
	elseif type == fgui.UIEventType.TouchBegin then
		self.labelVerifyNoticeSlider:setVisible(false)
	end
end
function worldMapMonsterInfoPanel:showGuideAction()
	local spriteFinger = self.verifySliderFigner
	local endPosX = (self.spriteEnd:getPositionX() - 60) * 5.5 / 4.4
	if spriteFinger then
		spriteFinger:removeFromParent()
		self.verifySliderFigner = nil
	end
	if guideCtrl:isGuideNotCompleted(gGuideModule.ATTACK_MONSTER) then
		spriteFinger = SoraDFingerAction()
		spriteFinger:setName("Sprite_guideFinger")
		spriteFinger:addTo(self.verifySlider)
		_UPVALUE3_ = nil
		;(nil)[1] = cca.callFunc(function(...)
			spriteFinger:setPosition(self.verifySlider:getValue() * 5.5, 30)
			spriteFinger:setVisible(math.abs(self.verifySlider:getValue() * 5.5 - endPosX) >= 5)
		end)
		;(nil)[2] = cca.fadeIn(0.5)
		;(nil)[3] = cca.moveTo(1, endPosX, 30)
		;(nil)[4] = cca.fadeOut(0.5)
		;(nil)[5] = cca.fadeOut(0.5)
		;(nil)[6] = cca.fadeOut(0.5)
		spriteFinger:runAction(cca.repeatForever(cca.seq(nil)))
		self.isRunGuide = true
		self.verifySliderFigner = spriteFinger
	end
end
function worldMapMonsterInfoPanel:OnSliderChangeEnd(slider, eventType)
	self.spriteBegan:setPositionX(60 + self.verifySlider:getValue() * 4.4)
	self.ballNode:setPositionX(4 + self.verifySlider:getValue() * 4.3)
end
function worldMapMonsterInfoPanel:createPuzzle(posX)
	local posY = SoraDGetRandNum(1, 80, 180)
	local rotate = SoraDGetRandNum(1, 0, 4)
	self.spriteBegan:setPositionY(posY[1])
	self.spriteEnd:setPositionY(posY[1])
	self.spriteEnd:setPositionX(self:sliderMD5(posX))
	self.spriteBegan:setRotation(90 * rotate[1])
	self.spriteEnd:setRotation(90 * rotate[1])
	self.imgVerify:setIcon(include("commonEventRead").getActivityShowByRand())
	self.verifySlider:setValue(0)
	self.ballNode:setPositionX(4)
	self.spriteBegan:setPositionX(60)
	self.labelVerifyNoticeSlider:setVisible(true)
	self:showGuideAction()
end
function worldMapMonsterInfoPanel:sliderMD5(data)
	local base = data[1]
	local x = data[2] % 10
	if x == 0 then
		x = 1
	end
	return base * x + x
end
function worldMapMonsterInfoPanel:doMonsterAnimation(sprite, imgName)
	dump(sprite, "worldMapMonsterInfoPanel:doMonsterAnimation")
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local needFlipX = math.random(1, 2) == 1
	local animationIndex = math.random(1, 3)
	local frames = display.newFrames(imgName .. "_dj_" .. "ws" .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.15)
	sprite:setSpriteFrame(imgName .. "_dj_" .. "ws" .. "_01.png")
	sprite:stopAllActions()
	if animationIndex == 1 then
		frames = display.newFrames(imgName .. "_gj_" .. "ws" .. "_0%d.png", 1, 8)
		animation = display.newAnimation(frames, 0.125)
	elseif animationIndex == 2 then
		frames = display.newFrames(imgName .. "_sw_" .. "ws" .. "_0%d.png", 1, 8)
		animation = display.newAnimation(frames, 0.125)
	end
	sprite:playAnimationOnce(animation)
	sprite:setFlippedX(needFlipX)
	_UPVALUE1_ = 8
	;(8)[1] = cca.delay(1.2 + math.random() * 0.5)
	;(8)[2] = cca.callFunc(function(...)
		self:doMonsterAnimation(sprite, imgName)
	end)
	;(8)[3] = cca.callFunc(function(...)
		self:doMonsterAnimation(sprite, imgName)
	end)
	sprite:runAction(cca.seq(8))
end
function worldMapMonsterInfoPanel:showVerify(questionIdList)
	if questionIdList then
		self.attackButton:setVisible(false)
		if 2 < #questionIdList then
			self.isRunGuide = false
			self.nodeVerifySlider:setVisible(false)
			self.nodeVerify:setVisible(true)
			self.btnVerify:setVisible(false)
			self.btnVerify:setTag(0)
			if self.verifyMonsterAnis == nil then
				self.verifyMonsterAnis, _ENV = self.verifyMonsterAnis, self.verifyMonsterAnis
				for i, v in ipairs(self.tableVerifySprite) do
					v:addClickEventListener(handler(self, self.verifyButtonCallFun))
					v:setTag(i)
					local loader = fguiHelper.get_fields(v).monster
					local sp = display.newSprite("#anbs_dj_ws_07.png")
					loader:setContent(sp)
					table.insert(self.verifyMonsterAnis, sp)
				end
			end
			for i, v in ipairs(questionIdList) do
				if self.tableVerifySprite[i] then
					self.tableVerifySprite[i]:setTag(v)
					self:doMonsterAnimation(self.verifyMonsterAnis[i], worldMapDefine.getMonsterImageName(v))
				end
			end
		else
			self.nodeVerifySlider:setVisible(true)
			self.nodeVerify:setVisible(false)
			self:createPuzzle(questionIdList)
		end
		self.enableTouchCloseSelf = true
		self.isCantCloseByReturn = true
	else
		self.nodeVerify:setVisible(false)
		self.nodeVerifySlider:setVisible(false)
		if self.isSelfKindom then
			self.attackButton:setVisible(true)
		end
		self.enableTouchCloseSelf = false
		self.isCantCloseByReturn = false
		if self.isRunGuide then
			guideCtrl:CompleteGuideStep(48001)
		end
	end
end
function worldMapMonsterInfoPanel:initMonsterFiesta(mapNpc)
	self.monster = mapNpc
	if self.isSelfKindom then
		self.attackButton:setVisible(true)
		self.attackButton:setTitle(i18n("common_text_008"))
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel < CASTLE_LV6_LIMITED then
			self.attackButton:setTouchEnabled(false)
			self.attackButton:setBright(false)
			self.text_Info:setVisible(true)
			_ENV = i18n("common_text_008")
			i18n("common_text_008").lv = CASTLE_LV6_LIMITED
			self.text_Info:setString(i18n("common_text_2749", i18n("common_text_008")))
		else
			self.text_Info:setVisible(false)
			self.attackButton:setTouchEnabled(true)
			self.attackButton:setBright(true)
			self.attackButton:removeEventListener(fgui.UIEventType.Click)
			self.attackButton:addClickEventListener(handler(self, self.attackButtonCallFun))
		end
	end
	self.text_activityTip:setVisible(false)
	self.nodeAddExp:setVisible(false)
	self.txtBelong:setVisible(false)
	self:requestInstanceInfo()
end
function worldMapMonsterInfoPanel:initData(mapNpc)
	self.attackNumText:setVisible(false)
	self.monster = mapNpc
	local isCanKill = self.monster.isCanKill or worldMapWarDef.isMonsterCanKill()
	self.attackButton:setVisible(isCanKill and self.isSelfKindom)
	if isCanKill and self.isSelfKindom then
		self.attackButton:setTitle(i18n("common_text_008"))
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		local stealInfo = lordSkillModuleAPI:getSkillCDData(lordSkillIDDefine.steal)
		local isNormalMonster = self.monster.monsterClassID >= 3000 and self.monster.monsterClassID < 3100
		if stealInfo.isOpened and isNormalMonster then
			local buffid = include("lordSkillDesRead").getBuffID(lordSkillIDDefine.steal)
			local isOpen, buff = SoraDGetCtrl("buffCtrl"):isBuffOpen(buffid)
			print("isOpen", isOpen, buffid)
			if isOpen then
				local health = SoraDGetCtrl("lordInfoCtrl"):getLordInfo().base.health
				self.attackNumText:setVisible(true)
				self.attackNumText:setString("x" .. math.min(math.floor(health / 5), 20))
			end
		end
		self.text_Info:setVisible(false)
	elseif self.isSelfKindom then
		self.text_Info:setVisible(true)
		self.attackButton:setTitle(i18n("common_text_2179"))
	else
		self.text_Info:setVisible(false)
	end
	if worldMapDefine.isRemainsKingdomID() then
		self.txtBelong:setVisible(false)
		self.text_activityTip:setVisible(false)
	end
	if worldMapDefine.isRoaringFlameKingdomID() then
		self:initRoaringFlameInfo()
	end
	self:requestInstanceInfo()
end
function worldMapMonsterInfoPanel:requestInstanceInfo()
	if self.monster and self.monster.__cname then
		local tilePoint = self.monster:getTilePoint()
		local instanceID = self.monster:getInstanceID()
		local kingdomID = self.monster:getKingdomID()
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
	end
end
function worldMapMonsterInfoPanel:serverMessage_RequestVerifyBack(target, data)
	if data.lastAnsterResult then
		self:requestInstanceInfo()
	else
		self:showVerify(data.retdata.questionIdList)
		SoraDCloseLoading(self)
	end
end
function worldMapMonsterInfoPanel:serverMessage_RequestAllianceBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	SoraDOpenAllianceInfoView(alliance)
end
function worldMapMonsterInfoPanel:serverMessage_RequestMapInstaceInfo(target, data)
	if not data.data then
		return
	end
	if tolua.isnull(self.monster) then
		self:close(nil, ccui.TouchEventType.ended)
		return
	end
	local monsterType = self.monster:getInstanceType()
	if data.data.npc and (monsterType == gMapObjTypeDef.mapObjTypeNpc or monsterType == gMapObjTypeDef.nebulaNpc or monsterType == gMapObjTypeDef.mapTypeFortyThieves or monsterType == gMapObjTypeDef.mapTypeSemluk or monsterType == gMapObjTypeDef.footballMonster or monsterType == gMapObjTypeDef.mapTypeHuntFair or monsterType == gMapObjTypeDef.roaringFlameWarNpc) then
		self:serverMessage_RequestMapInstaceInfo_npc(data)
	end
	if data.data.monsterFiesta and monsterType == gMapObjTypeDef.mapTypeMonsterFiesta then
		self:serverMessage_RequestMapInstaceInfo_MonsterFiesta(data)
	end
	if data.data.npc and monsterType == gMapObjTypeDef.mapObjSeaMonsterInvade then
		self:serverMessage_RequestMapInstaceInfo_seaMonsterInvade(data)
	end
end
function worldMapMonsterInfoPanel:serverMessage_RequestMapInstaceInfo_seaMonsterInvade(data)
	local npcData = data.data.npc
	local belongAbbr = npcData.terr
	local expPlus = npcData.expPlus
	local isCanKill = npcData.isCanKill or worldMapWarDef.isMonsterCanKill()
	local maxCanKillLevel = npcData.maxCanKillLevel
	self.maxCanKillLevel = maxCanKillLevel
	if self.isSelfKindom and npcData.isCanKill and not worldMapDefine.isInKingdomBattle() then
		self.attackButton:setVisible(true)
		self.attackButton:setTouchEnabled(true)
		self.attackButton:setBright(true)
		self.attackButton:setTitle(i18n("common_text_008"))
		self.attackButton:removeEventListener(fgui.UIEventType.Click)
		self.attackButton:addClickEventListener(handler(self, self.attackButtonCallFun))
		self.text_Info:setVisible(false)
	else
		if self.isSelfKindom and not npcData.isCanKill then
			self.text_Info:setVisible(true)
			worldMapWarDef = true
			;(true).Level = maxCanKillLevel
			local stirngInfo = i18n("common_text_487", true)
			self.text_Info:setString(stirngInfo)
			self.attackButton:setVisible(true)
			self.attackButton:setTouchEnabled(true)
			self.attackButton:setBright(true)
			self.attackButton:setTitle(i18n("common_text_2179"))
			self.attackButton:removeEventListener(fgui.UIEventType.Click)
			self.attackButton:addClickEventListener(function(ref, type)
				if type == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local findMonsterCtrl = gametop.playertop_:getModule("findMonsterCtrl")
					findMonsterCtrl:sendSearchSeaMonstersMsg(maxCanKillLevel, maxCanKillLevel, true)
					self:close(ref, type)
				end
			end)
		else
			self.text_Info:setVisible(false)
		end
		self.text_activityTip:setVisible(false)
		if worldMapDefine.isInKingdomBattle() then
			self.attackButton:setVisible(true)
			self.attackButton:setTouchEnabled(true)
			self.attackButton:setBright(true)
			self.attackButton:setTitle(npcData.isCanKill and i18n("common_text_008") or i18n("common_text_2179"))
			self.attackButton:removeEventListener(fgui.UIEventType.Click)
			self.attackButton:addClickEventListener(function(ref, type)
				SoraDPlaySound()
				SoraDShowMsgTip(i18n("common_text_3302"))
				self:close(ref, type)
			end)
		end
	end
	if belongAbbr and next(belongAbbr) then
		local info = belongAbbr[1]
		worldMapWarDef = i18n("common_text_2179")
		worldMapWarDef = i18n("common_text_2179")
		i18n("common_text_2179").abbr = info.leagueAbbrName
		i18n("common_text_2179").name = info.leagueName
		i18n("common_text_2179").belong = i18n("common_text_186", i18n("common_text_2179"))
		self.txtBelong:setString(i18n("common_text_3069", i18n("common_text_2179")))
		self.txtBelong:setTouchEnabled(true)
		self.txtBelong:addTouchEventListener(function(button, eventType)
			print("====== 2")
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			;(nil).aid = info.leagueID
			;(nil).from = "worldMapMonsterInfoPanel"
			allianceQuery:reqAllianceByID(nil)
		end)
	end
	if expPlus then
		self.buffNum = expPlus.totalPlus / 10
		for k, v in pairs(expPlus) do
			if tonumber(v) > 0 and k ~= "totalPlus" and k ~= "activityExpPlus" then
				v = v / 10
				table.insert(self.buffTable, "+" .. v .. "%")
				table.insert(self.buffDes, EXPDES[k])
			end
		end
		if 0 < expPlus.activityExpPlus then
			local buff = (1000 + expPlus.activityExpPlus) / 10
			table.insert(self.buffTable, "x" .. buff .. "%")
			table.insert(self.buffDes, EXPDES.activityExpPlus)
		end
		self.catchUpIsOpen = 0 < expPlus.catchUpExpPlus
	end
	self.nodeAddExp:setVisible(self.buffNum > 0)
	worldMapWarDef = buff
	buff.percent = self.buffNum
	self.txtAddExp:setString(i18n("common_text_4366", buff))
	self.btnAddExp:setVisible(self.catchUpIsOpen or 1 < #self.buffDes)
	SoraDCloseLoading(self)
end
function worldMapMonsterInfoPanel:serverMessage_RequestMapInstaceInfo_MonsterFiesta(data)
	if data.data.limit and self.isSelfKindom then
		local limitStatus = data.data.limit[_G.gCommonDailyLimitType.MONSTER_FIESTA]
		if limitStatus and limitStatus.status then
			self.attackButton:setTouchEnabled(false)
			self.attackButton:setBright(false)
			self.text_Info:setVisible(true)
			self.text_Info:setString(i18n("common_text_3546"))
		end
	end
	local npcData = data.data.monsterFiesta
	dump(npcData, "monsterFiesta", 10)
	if self.isSelfKindom and data.data.verify and data.data.verify.result and npcData.isCanKill then
		self:showVerify(data.data.verify.data.questionIdList)
		if data.data.verify.data.ansterTrueCount >= 3 then
			self.text_Info:setVisible(false)
		else
			self.text_Info:setString(i18n("common_text_2865"))
			self.text_Info:setVisible(true)
		end
	else
		self:showVerify(false)
	end
	SoraDCloseLoading(self)
end
function worldMapMonsterInfoPanel:serverMessage_RequestMapInstaceInfo_npc(data)
	self.monsterData = data.data
	local npcData = data.data.npc
	local expPlus = npcData.expPlus
	local belongAbbr = data.data.npc.terr
	local isCanKill = npcData.isCanKill or worldMapWarDef.isMonsterCanKill()
	local maxCanKillLevel = npcData.maxCanKillLevel
	if self.isWastelandMonster then
		local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
		maxCanKillLevel = wastelandCtrl:getMaxAttackBossLevel()
		local bossSettingId = self.monster.npcData.bossSettingId
		local config = wastelandCtrl:getBossConfig(bossSettingId)
		isCanKill = maxCanKillLevel >= config.LV
	end
	self.maxCanKillLevel = maxCanKillLevel
	if isCanKill and self.isSelfKindom then
		self.attackButton:setTitle(i18n("common_text_008"))
		self.text_Info:setVisible(false)
		self.attackButton:removeEventListener(fgui.UIEventType.Click)
		self.attackButton:addClickEventListener(handler(self, self.attackButtonCallFun))
	else
		if self.isSelfKindom then
			self.text_Info:setVisible(true)
			if self.isWastelandMonster then
				worldMapWarDef = handler(self, self.attackButtonCallFun)
				handler(self, self.attackButtonCallFun).lv = maxCanKillLevel
				self.text_Info:setString(i18n("wasteland_text_012", handler(self, self.attackButtonCallFun)))
				self.attackButton:setTitle(i18n("common_text_477"))
			else
				worldMapWarDef = i18n("common_text_477")
				i18n("common_text_477").Level = maxCanKillLevel
				self.text_Info:setString(i18n("common_text_487", i18n("common_text_477")))
				self.attackButton:setTitle(i18n("common_text_2179"))
			end
			self.attackButton:removeEventListener(fgui.UIEventType.Click)
			self.attackButton:addClickEventListener(handler(self, self.searchMonsterCallFun))
		else
			self.text_Info:setVisible(false)
		end
		self.text_activityTip:setVisible(false)
	end
	if data.data.mapType == gMapObjTypeDef.mapObjTypeNpc and self.isSelfKindom and data.data.verify and data.data.verify.result and isCanKill then
		self:showVerify(data.data.verify.data.questionIdList)
		if data.data.verify.data.ansterTrueCount >= 3 then
			self.text_Info:setVisible(false)
		else
			self.text_Info:setString(i18n("common_text_2865"))
			self.text_Info:setVisible(true)
		end
	else
		self:showVerify(false)
	end
	if belongAbbr and next(belongAbbr) then
		local info = belongAbbr[1]
		worldMapWarDef = i18n("common_text_2865")
		worldMapWarDef = i18n("common_text_2865")
		i18n("common_text_2865").abbr = info.leagueAbbrName
		i18n("common_text_2865").name = info.leagueName
		i18n("common_text_2865").belong = i18n("common_text_186", i18n("common_text_2865"))
		self.txtBelong:setString(i18n("common_text_3069", i18n("common_text_2865")))
		self.txtBelong:setTouchEnabled(true)
		self.txtBelong:addTouchEventListener(function(button, eventType)
			print("====== 1")
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			;(nil).aid = info.leagueID
			;(nil).from = "worldMapMonsterInfoPanel"
			allianceQuery:reqAllianceByID(nil)
		end)
	end
	if self.isWastelandMonster then
		worldMapWarDef = i18n("common_text_3069", i18n("common_text_2865"))
		i18n("common_text_3069", i18n("common_text_2865")).var = string.format("x%d", self.monster:getLifeCount())
		self.txtBelong:setString(i18n("wasteland_text_011", i18n("common_text_3069", i18n("common_text_2865"))))
	end
	if expPlus then
		self.buffNum = expPlus.totalPlus / 10
		for k, v in pairs(expPlus) do
			if tonumber(v) > 0 and k ~= "totalPlus" and k ~= "activityExpPlus" then
				v = v / 10
				table.insert(self.buffTable, "+" .. v .. "%")
				table.insert(self.buffDes, EXPDES[k])
			end
		end
		if 0 < expPlus.activityExpPlus then
			local buff = (1000 + expPlus.activityExpPlus) / 10
			table.insert(self.buffTable, "x" .. buff .. "%")
			table.insert(self.buffDes, EXPDES.activityExpPlus)
		end
		self.catchUpIsOpen = 0 < expPlus.catchUpExpPlus
	end
	self.nodeAddExp:setVisible(self.buffNum > 0)
	worldMapWarDef = buff
	buff.percent = self.buffNum
	self.txtAddExp:setString(i18n("common_text_4366", buff))
	self.btnAddExp:setVisible(self.catchUpIsOpen or 1 < #self.buffDes)
	if npcData.id and npcData.id > 3121 and npcData.id < 3132 then
		self.txtBelong:setVisible(false)
		self.nodeAddExp:setVisible(false)
	end
	if worldMapDefine.isNebulaKingdomID() then
		worldMapWarDef = i18n("common_text_4366", buff)
		i18n("common_text_4366", buff).num = string.formatnumberthousands(npcData.mapRemainCount)
		self.txtBelong:setString(i18n("nebula_war_text_0553", i18n("common_text_4366", buff)))
		self.text_talk = SoraDCreateTimerLabel(nil, self.text_talk)
		local nebulaWarUtil = include("nebulaWarUtil")
		local remainTime = nebulaWarUtil.getMonsterRemainTime(self.monsterClassID)
		if 0 < remainTime then
			self.nodeAddExp:setVisible(true)
			self.text_talk:setTimeLast(function(timeStr)
				_ENV = nil
				;(nil).time = timeStr
				return i18n("nebula_war_text_0554", nil)
			end)
			self.text_talk:beginTime(remainTime)
		end
		local nebulaWarRead = include("nebulaWarRead")
		local score = nebulaWarRead.getMonsterIntegral(self.monsterClassID)
		worldMapWarDef = i18n("nebula_war_text_0553", i18n("common_text_4366", buff))
		i18n("nebula_war_text_0553", i18n("common_text_4366", buff)).num = score
		self.txtAddExp:setString(i18n("nebula_war_text_0555", i18n("nebula_war_text_0553", i18n("common_text_4366", buff))))
	end
	SoraDCloseLoading(self)
end
function worldMapMonsterInfoPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapMonsterInfoPanel:getTilePoint()
	return self.tilePoint
end
function worldMapMonsterInfoPanel:upateInfoPanel(monsterClassID)
	self.monsterClassID = monsterClassID
	self.isWastelandMonster = worldMapDefine.checkIsWastelandMonster(self.monsterClassID)
	local nameStr = worldMapDefine.getMonsterName(monsterClassID)
	if not self.isWastelandMonster then
		self.fields.Text_LvDes:setString("LEVEL")
		self.fields.Text_Lv:setString(string.format("%02d", self.monster.monsterLevel))
	end
	self.text_Name:setString(nameStr)
	local monsterType = self.monster:getInstanceType()
	if monsterType == gMapObjTypeDef.mapTypeMonsterFiesta then
		self.text_talk:setString(worldMapDefine.getMonstertalk(monsterClassID, 1))
	else
		self.text_talk:setString(worldMapDefine.getMonstertalk(monsterClassID))
	end
	if self.isWastelandMonster then
		self.text_talk:setString(i18n("wasteland_text_018"))
		self.text_activityTip:setVisible(true)
		_ENV = i18n("wasteland_text_018")
		i18n("wasteland_text_018").var = 5
		self.text_activityTip:setString(i18n("wasteland_text_013", i18n("wasteland_text_018")))
		self.text_activityTip:setColor(cc.c3b(230, 140, 140))
		if not self.wasteland_text then
			_ENV = self.text_activityTip
			self.text_activityTip.text = ""
			self.text_activityTip.size = 20
			local text_count = SoraDCreateLabelNoChild(self.text_activityTip)
			text_count:addTo(self.view)
			text_count:setAnchorPoint(0.5, 0.5)
			text_count:setPosition(cc.p(320, 280))
			SoraDChangeTextToHtml(text_count)
			self.wasteland_text = text_count
		else
			self.wasteland_text:setVisible(true)
		end
		local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
		local countStr = wastelandCtrl:getMonsterCountStr()
		self.wasteland_text:setString(countStr)
	elseif self.wasteland_text then
		self.wasteland_text:setVisible(false)
	end
	if worldMapDefine.isNebulaKingdomID() then
		local nebulaWarRead = include("nebulaWarRead")
		self.text_activityTip:setVisible(true)
		local consume = nebulaWarRead.getMonsterConsume(monsterClassID)
		_ENV = cc.p(320, 280)
		cc.p(320, 280).num = consume
		self.text_activityTip:setString(i18n("fierydragon_text_9", cc.p(320, 280)))
	end
	self:initRewdard(monsterClassID)
	local bustName = worldMapDefine.getMonsterBustImageName(monsterClassID)
	self.imageMonster:setIcon(bustName)
end
function worldMapMonsterInfoPanel:onRewardRenderer(index, obj)
	local data = self.rewardDatas[index + 1]
	local fields = fguiHelper.get_fields(obj)
	fields.item:initData()
	fields.item:setIcon(data[1])
	fields.title:setString(data[2])
end
function worldMapMonsterInfoPanel:addRewardOne(img, txt, scale)
	_UPVALUE3_ = nil
	;(nil)[1] = img
	;(nil)[2] = txt
	;(nil)[3] = scale
	table.insert(self.rewardDatas, nil)
end
function worldMapMonsterInfoPanel:initRewdard(monsterClassID)
	local rewardItemId = worldMapDefine.getMonsterReward(monsterClassID)
	local self.rewardDatas, _ENV, limitNum = nil, nil, 4 < #rewardItemId and 4 or #rewardItemId
	for i = 1, limitNum do
		local img = publicRead.getIcon(rewardItemId[i])
		local txt = publicRead.getName(rewardItemId[i])
		self:addRewardOne(img, txt)
	end
	if limitNum == 1 then
		_ENV = publicRead.getName(rewardItemId[i])
		publicRead.getName(rewardItemId[i]).num = "10"
		self:addRewardOne("1024.png", i18n("item_name_102401", (publicRead.getName(rewardItemId[i]))))
		self:addRewardOne("icon_treasure_steel.png", i18n("common_text_025"))
		_ENV = i18n("common_text_025")
		i18n("common_text_025").num = "100"
		self:addRewardOne("1001.png", i18n("item_name_02", i18n("common_text_025")))
	end
	self:addRewardOne("icon_equip_storagebox.png", i18n("common_text_486"), 1.0)
	self.fields.list:setNumItems(#self.rewardDatas)
end
function worldMapMonsterInfoPanel:searchMonsterCallFun(ref, type)
	SoraDPlaySound()
	local killMonsterVerifyCtrl = gametop.playertop_:getModule("killMonsterVerifyCtrl")
	if killMonsterVerifyCtrl:isQuickSearchMonsterLock() then
		SoraDShowMsgTip(i18n("common_text_2863"))
		SoraDRemoveAllPrePanelFromManager(self, true)
		self:close(ref, type)
	else
		self:autoSearch()
	end
end
function worldMapMonsterInfoPanel:attackButtonCallFun(ref, type)
	SoraDPlaySound()
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	if self.monsterClassID and self.monsterClassID == 3121 and 0 < sourceKid then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	if 0 < sourceKid and self.monster:getInstanceType() == gMapObjTypeDef.nebulaNpc then
		SoraDShowMsgTip(i18n("common_text_4646"))
		return
	end
	if self.monsterClassID and self.monsterClassID > 3121 and self.monsterClassID < 3127 then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			_ENV = i18n("common_text_4646")
			i18n("common_text_4646").num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_4646")))
			return
		end
		local totalKill = include("constantRead").getConstValue("SEMRUK_DAY_KILLMAX")
		if totalKill <= self.curKillSemlukNum then
			_ENV = i18n("common_text_1795", i18n("common_text_4646"))
			i18n("common_text_1795", i18n("common_text_4646")).num = 30
			SoraDShowMsgTip(i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646"))))
			return
		end
	end
	if self.monsterClassID and self.monsterClassID == 3127 then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			_ENV = i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646")))
			i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646"))).num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646")))))
			return
		end
		local totalKill = include("constantRead").getConstValue("HUNTFAIR_DAY_KILLMAX")
		if totalKill <= self.curKillIceHuntingNum then
			local limitKill = include("constantRead").getConstValue("HUNTFAIR_DAY_KILLMAX")
			_ENV = i18n("common_text_1795", i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646"))))
			i18n("common_text_1795", i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646")))).num = limitKill
			SoraDShowMsgTip(i18n("Snow_Monster_text_07", i18n("common_text_1795", i18n("Semruk_text_04", i18n("common_text_1795", i18n("common_text_4646"))))))
			return
		end
	end
	local mapType = self.monsterData and self.monsterData.mapType
	if mapType == gMapObjTypeDef.footballMonster then
		if worldMapDefine.isInKingdomBattle() then
			SoraDShowMsgTip(i18n("worldboss_text_06"))
			return
		end
		local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
		local myCamp = activity_9001737_Ctrl:getMyCamp()
		if myCamp == 0 then
			SoraDShowMsgTip(i18n("troublemaker_text_14"))
			return
		end
		local camp = self.monsterData.npc and self.monsterData.npc.subMapType
		if camp and myCamp ~= camp then
			SoraDShowMsgTip(i18n("troublemaker_text_15"))
			return
		end
	end
	local dispatch = function(...)
		if SoraDEnoughTroops() and self.monster and self.monster.__cname then
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV = nil
			;(nil).toPoint = self.tilePoint
			;(nil).dispatchType = worldMapDefine.worldMapTipButtonType_gongJi
			;(nil).instanceID = self.monster:getInstanceID()
			;(nil).instanceType = self.monster:getInstanceType()
			dispatchPanel:initData(nil)
		end
		self:close(ref, type)
	end
	if self.isWastelandMonster then
		local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
		local ret, totalKill = wastelandCtrl:checkKillMonsterCount()
		if not ret then
			local dailyRemindManager = include("dailyRemindManager")
			_ENV = i18n("troublemaker_text_15")
			i18n("troublemaker_text_15").rtype = dailyRemindManager.REMIND_TYPE.wastelandMonster
			_ENV = i18n("troublemaker_text_15")
			i18n("troublemaker_text_15").maxKill = totalKill
			i18n("troublemaker_text_15").content = i18n("wasteland_text_027", i18n("troublemaker_text_15"))
			i18n("troublemaker_text_15").confirmFunc = function()
				dispatch()
			end
			dailyRemindManager.showMessageBox(i18n("troublemaker_text_15"))
		else
			dispatch()
		end
	else
		dispatch()
	end
end
function worldMapMonsterInfoPanel:verifySendButtonCallFun(ref, type)
	local killMonsterVerifyCtrl = gametop.playertop_:getModule("killMonsterVerifyCtrl")
	local tag = self.btnVerify:getTag()
	killMonsterVerifyCtrl:reqAnsterQuestion(tag)
	SoraDShowLoading(self)
end
function worldMapMonsterInfoPanel:btnAddExpClick(button, eventType)
	if self.catchUpIsOpen and #self.buffDes == 1 then
		SoraDShowHelpMsgTip(i18n("common_text_4367"))
	elseif #self.buffDes > 1 then
		SoraDShowHelpMsgTipEX(self.buffDes, self.buffTable, display.COLOR_GREEN)
	end
end
function worldMapMonsterInfoPanel:verifyButtonCallFun(sender, type)
	for i, v in ipairs(self.tableVerifySprite) do
		v:setSelected(sender == v)
	end
	self.btnVerify:setVisible(true)
	self.btnVerify:setTag(sender:getTag())
end
function worldMapMonsterInfoPanel:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function worldMapMonsterInfoPanel:msgBackData(target, redata)
	SoraDCloseLoading(self)
	self:close()
	if redata and redata.retdate then
		if redata.retdate.x ~= -1 and redata.retdate.x ~= -1 then
			SoraDGotoWorldMapPoint(cc.p(redata.retdate.x, redata.retdate.y), true)
		else
			SoraDShowMsgTip(i18n("common_text_2177"))
		end
	elseif redata and redata.err and gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP == redata.err then
		SoraDShowMsgTip(i18n("common_text_2175"))
	end
end
function worldMapMonsterInfoPanel:autoSearch()
	local curPos = SoraDGetDisplayCenterWorldMapPoint()
	if not self.firstSearch then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		curPos = cityCtrl:getCurCityPos()
	end
	local maxCanKillLevel = tonumber(self.maxCanKillLevel)
	local _max = maxCanKillLevel
	local _min = maxCanKillLevel
	local sendServer2Find = function()
		print("走服务")
		local gametop = gModuleMgr.getObject("gametop")
		local findMonsterCtrl = gametop.playertop_:getModule("findMonsterCtrl")
		if self.isWastelandMonster then
			findMonsterCtrl:sendSearchBossMsg(gBossType.wastelandBoss, _min, _max)
		elseif maxCanKillLevel > gMaxNpcLevel then
			findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.nebulaNpc, nil, nil, maxCanKillLevel, maxCanKillLevel)
		else
			local _pos = curPos
			findMonsterCtrl:sendSearchMonstersMsg(_min, _max, _pos.x, _pos.y)
		end
		SoraDShowLoading(self)
	end
	local local2Find = function(_fun)
		print("走客户")
		SoraDShowLoading(self)
		local searchType = self.isWastelandMonster and gMapObjTypeDef.wastelandBoss or gMapObjTypeDef.mapObjTypeNpc
		_ENV = nil
		;(nil).lowLevel = _min
		;(nil).highLevel = _max
		;(nil).point = curPos
		local worldObj = SoraDGetClosestInstanceInWorldMap(searchType, false, false, nil)
		if worldObj then
			local showTilePoint = worldObj:getTilePoint()
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			if not kingdomMapCtrl:isLockByOtherPlayer(showTilePoint.x, showTilePoint.y, searchType) then
				SoraDCloseLoading(self)
				local ref, type
				self:close(ref, type)
				SoraDGotoWorldMapPoint(showTilePoint, true)
			else
				_fun()
			end
		else
			_fun()
		end
	end
	if not self.firstSearch then
		self.firstSearch = true
		local2Find(sendServer2Find)
	else
		sendServer2Find()
	end
end
function worldMapMonsterInfoPanel:initRoaringFlameInfo(...)
	if not self.obj_roaringFlame then
		local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "Com_monsterInfo_main")
		obj:addTo(self.view)
		local pos = self.attackButton:getPosition()
		obj:setPosition(self.view:getWidth() / 2, pos.y + 20)
		self.obj_roaringFlame = obj
	else
		self.obj_roaringFlame:setVisible(true)
	end
	local campName = i18n("sheepFeed_text_18")
	local camp = self.monster.npcData.camp
	if camp then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		campName = roaringFlameWarRead.getCampName(camp)
	end
	_ENV = nil
	;(nil).camp = campName
	self.txtBelong:setString(i18n("flames_dunes_text166", nil))
end
return worldMapMonsterInfoPanel
