local gametop = gModuleMgr.getObject("gametop")
local lordSpineDef = include("lordSpineDef")
local funUnlockRead = include("funUnlockRead")
local exclusiveVipRead = include("exclusiveVipRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local achievementctrl = SoraDGetCtrl("achievementctrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local guardianCtrl = SoraDGetCtrl("guardianCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local equipmentCtrl = include("equipmentCtrl")
local equipmentMgr = include("equipmentMgr")
local lordLocalData = include("lordLocalData")
local equipmentltCtrl = include("equipmentltCtrl")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordViewPanel = class("lordViewPanel", baseFguiPanel)
function lordViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordViewPanel:ctor", self.viewName)
end
function lordViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordViewPanel:onInit()
	print("=======lordViewPanel:onInit")
	self.ownOperateList, _ENV, self.tablePlayerInfo, _ENV = print, print, print, print
	self.needCallBack2SDK = true
	self.isHideCurrentSceneView = true
	self.isReqed = false
	self.isSelfView = true
	self.friendType = 1
	self.isFirstIn = true
	self.fields.Com_title:initData(i18n("common_text_1536"), handler(self, self.onClickClose))
	self.fields.Button_portrait:addClickListener(handler(self, self.portraitClick))
	self.fields.Button_pigeon:addClickListener(handler(self, self.pigeonClick))
	self.fields.Button_operate:addClickListener(handler(self, self.operateClick))
	self.fields.Button_weaponEnhance:setString(i18n("strengthen_resonance_1"))
	self.fields.Button_weaponEnhance:addClickListener(handler(self, self.weaponEnhanceClick))
	self.fields.Button_weaponEnhance:setVisible(false)
	self.fields.Button_setting:setString(i18n("common_text_713"))
	self.fields.Button_setting:addClickListener(handler(self, self.settingClick))
	self.fields.Button_skill:setString(i18n("common_title_03"))
	self.fields.Button_skill:addClickListener(handler(self, self.skillClick))
	self.fields.Button_honour:setString(i18n("common_text_1752"))
	self.fields.Button_honour:addClickListener(handler(self, self.btnHonourClick))
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Button_rank:addClickListener(handler(self, self.rankClick))
	self.fields.Button_alliance:setString(i18n("common_text_069"))
	self.fields.Button_alliance:addClickListener(handler(self, self.btnAllianceClickCallBack))
	self.fields.Button_sendMail:setString(i18n("chat_text_69"))
	self.fields.Button_sendMail:addClickListener(handler(self, self.btnSendMailClickCallBack))
	self.fields.Button_friend:setString(i18n("friend_btn_07"))
	self.fields.Button_friend:addClickListener(handler(self, self.btnFriendClickCallBack))
	self.fields.Button_info:setString(i18n("common_text_368"))
	self.fields.Button_info:addClickListener(handler(self, self.infoClick))
	self.fields.achi:addClickListener(handler(self, self.btnAchiClickCallBack))
	self.fields.Button_hisGuardian:setVisible(false)
	self.fields.btn_firstKingdom:addClickListener(handler(self, self.onFirstKingdomClick))
	_ENV, _ENV = self.fields.btn_firstKingdom, self.fields.btn_firstKingdom.addClickListener
	self.fields.btn_firstKingdom.index = 1
	self.fields.btn_firstKingdom.title = i18n("common_text_2302")
	self.fields.btn_firstKingdom.icon = "icon_lord_flowers.png"
	_ENV, self.fields.btn_firstKingdom.addClickListener[1], self.fields.btn_firstKingdom.handle = self.fields.btn_firstKingdom, self.fields.btn_firstKingdom, handler(self, self.flowerClick)
	self.fields.btn_firstKingdom.index = 2
	self.fields.btn_firstKingdom.title = i18n("privilege_text_06")
	self.fields.btn_firstKingdom.icon = "icon_lord_enjoy.png"
	_ENV, self.fields.btn_firstKingdom.addClickListener[2], self.fields.btn_firstKingdom.handle = self.fields.btn_firstKingdom, self.fields.btn_firstKingdom, handler(self, self.vipClick)
	self.fields.btn_firstKingdom.index = 3
	self.fields.btn_firstKingdom.title = i18n("common_text_368")
	self.fields.btn_firstKingdom.icon = "icon_lord_data.png"
	_ENV, self.fields.btn_firstKingdom.addClickListener[3], self.fields.btn_firstKingdom.handle = self.fields.btn_firstKingdom, self.fields.btn_firstKingdom, handler(self, self.infoClick)
	self.fields.btn_firstKingdom.index = 4
	self.fields.btn_firstKingdom.title = i18n("common_text_701")
	self.fields.btn_firstKingdom.icon = "frame_protect_01.png"
	self.fields.btn_firstKingdom.scale = 0.7
	_ENV, self.fields.btn_firstKingdom.addClickListener[4], self.fields.btn_firstKingdom.handle = self.fields.btn_firstKingdom, self.fields.btn_firstKingdom, handler(self, self.guardianClick)
	self.fields.btn_firstKingdom.index = 5
	self.fields.btn_firstKingdom.title = i18n("Anchor_text_69")
	self.fields.btn_firstKingdom.icon = "icon_lord_livestreaming.png"
	self.operateList, self.fields.btn_firstKingdom.addClickListener[5], self.fields.btn_firstKingdom.handle = self.fields.btn_firstKingdom.addClickListener, self.fields.btn_firstKingdom, handler(self, self.djListClick)
	self.fields.List_own:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Com_equipInfoPop:setVisible(false)
	self.fields.Button_operate:fixPos()
	self.fields.Button_weaponEnhance:fixPos()
	self.fields.Button_setting:fixPos()
	self.fields.Button_skill:fixPos()
	self.fields.Button_honour:fixPos()
	self.fields.Button_rank:fixPos()
	self.fields.Button_info:fixPos()
	self.fields.Button_friend:fixPos()
	self.fields.Button_sendMail:fixPos()
	self.fields.Button_alliance:fixPos()
	self.fields.Button_hisGuardian:fixPos()
	for i = 1, 8 do
		self.fields["equip_" .. i]:fixPos()
	end
end
function lordViewPanel:onShow()
	print("=======lordViewPanel:onShow")
	self.tablePlayerInfo = self.param and self.param.playerInfo or lordInfoCtrl:getLordInfo()
	self.isSelfView = self.tablePlayerInfo.base.uid == lordInfoCtrl:getLordInfo().base.uid
	self.isKingdomBattle = self.tablePlayerInfo.isKingdomBattle or false
	self.controllers.c1:setSelectedIndex(self.isSelfView and 0 or 1)
	premiumStoreCtrl:sendOpenPage()
	self:initData()
	self:checkEquipSlot()
end
function lordViewPanel:endShow()
	local guideStep = SoraDIsGameGuide()
	if guideStep and guideStep == 7002 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		;(nil).step = 7003
		SoraDSendMessage(nil)
	end
end
function lordViewPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_LORDINFO_BIND_AWARD"
	SoraDSendMessage(nil)
end
function lordViewPanel:checkOperateBtns()
	if self.isSelfView then
		self.ownOperateList, _ENV = self.isSelfView, self.isSelfView
		for k, v in ipairs(self.operateList) do
			if v.index == 1 and SoraDGetCastleLv() >= funUnlockRead.getUnlockLevel(gFunBuildKey.FLOWER) then
				table.insert(self.ownOperateList, v)
			end
			if v.index == 2 and self:checkExclusiveVip() then
				table.insert(self.ownOperateList, v)
			end
			if v.index == 3 then
				table.insert(self.ownOperateList, v)
			end
			if v.index == 4 and SoraDGetCastleLv() >= funUnlockRead.getUnlockLevel(gFunBuildKey.GUARDIAN) then
				table.insert(self.ownOperateList, v)
			end
			if v.index == 5 and IsArClient and djCtrl:isChatDJChannelOpen() then
				table.insert(self.ownOperateList, v)
			end
		end
		self.fields.List_own:setNumItems(#self.ownOperateList)
	end
end
function lordViewPanel:updateVipFlag(target, data)
	local isNewTotal = exaltedPrivilegeCtrl:isNewFlagTotalJudge()
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	local birthdayYearSet = exaltedPrivilegeCtrl:hasBirthdayYearSet()
	local myVip = self:getOwnVip()
	if myVip then
		myVip:setNewRet(isNewTotal)
		myVip:setRed(not isNewTotal and (table.nums(welfareInfo) > 0 or not birthdayYearSet))
	end
end
function lordViewPanel:checkExclusiveVip()
	return exaltedPrivilegeCtrl:checkExclusiveVip()
end
function lordViewPanel:onItemRenderer(index, obj)
	obj:initData(self.ownOperateList[index + 1])
end
function lordViewPanel:initData(target, data)
	self:showPublicInfo()
	self.fields.Button_operate:setIcon(self.isSelfView and "icon_lord_equipment.png" or "icon_lord_flowers.png")
	if self.isSelfView then
		_ENV = nil
		;(nil).num = ""
		if i18n("lordequip_text_08", nil) then
			goto lbl_30
		end
	end
	::lbl_30::
	self.fields.Button_operate:setString((i18n("common_text_2309")))
	if self.isSelfView then
		self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
		self.setID = equipmentCtrl:getActiveSet()
		self:checkOperateBtns()
		self.fields.Bar_hp:initData(self.tablePlayerInfo.physicalUpper, self.tablePlayerInfo.base.health)
		self:updateSkillPoint()
		self:updateHonourReward()
		self:updateVipFlag()
		self:initEquipWeaponEnhance(true)
		self:updateRedPoint()
		self:showGuardian()
		self:updateFirstKingdom()
	else
		self:initEquipWeaponEnhance(false)
		self:updateBtnAlliance()
		local itemCount = backpackCtrl:getItemCount(501901)
		if not IsArClient then
			itemCount = itemCount + backpackCtrl:getItemCount(511701)
		end
		self.fields.Button_pigeon:setVisible(lordInfoCtrl:getLordInfo().base.partition == self.tablePlayerInfo.base.partition and 0 < itemCount)
		local showAchi = self.tablePlayerInfo.achieveInfo and self.tablePlayerInfo.achieveInfo.showAchieveID ~= 0 and self.tablePlayerInfo.achieveInfo.isShow
		self.fields.achi:setVisible(showAchi)
		self.fields.achi:initData(self.tablePlayerInfo.achieveInfo)
		self:updataGuardian()
		if not target then
			self:updateFriendBtn()
		end
		self.controllers.c2:setSelectedIndex(self.isKingdomBattle and 1 or 0)
	end
end
function lordViewPanel:updateBtnAlliance()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local kid = self.tablePlayerInfo.base.partition or 0
	local teamId = self.tablePlayerInfo.base.teamId
	if teamId and worldMapDefine.isLegendLordKingdomID(kid) then
		self.fields.Button_alliance:setEnabled(true)
		self.fields.Button_alliance:setString(i18n("remains_text_85"))
	elseif worldMapDefine.isInTeamWarForbid() then
		self.fields.Button_alliance:setEnabled(false)
		self.fields.Button_alliance:setString(i18n("common_text_069"))
	else
		self.fields.Button_alliance:setEnabled(true)
		self.fields.Button_alliance:setString(i18n("common_text_069"))
		local aid = tonumber(self.tablePlayerInfo.aid)
		if aid == nil or self.tablePlayerInfo.base.partition ~= lordInfoCtrl:getLordInfo().base.partition then
			if allianceMgr:hasJoinAlliance() and ownRank >= gAllianceRank.R4 and self.tablePlayerInfo.base.partition == lordInfoCtrl:getLordInfo().base.partition and self.tablePlayerInfo.base.sourceKid == 0 then
				self.fields.Button_alliance:setString(i18n("common_text_202"))
			else
				self.fields.Button_alliance:setEnabled(false)
			end
		end
	end
end
function lordViewPanel:updateSkillPoint()
	local lordSkillModuleAPI = include("lordSkillModuleAPI")
	local skillPoint = lordSkillModuleAPI:getRemainPoint() or 0
	self.fields.Button_skill:setRed(0 < skillPoint, SoraDConvertNum(skillPoint))
end
function lordViewPanel:updateHonourReward()
	local honourNum = achievementctrl:getTipNum() or 0
	self.fields.Button_honour:setRed(0 < honourNum, SoraDConvertNum(honourNum))
end
function lordViewPanel:updateFriendBtn(target, data)
	SoraDCloseLoading()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		self.fields.Button_friend:setEnabled(false)
		return
	end
	if not self.isSelfView and self.tablePlayerInfo.base.castlelv < CASTLE_LV6_LIMITED then
		return
	end
	if not target and not self.isReqed then
		contactCtrl:reqGetData(true, true, false)
		self.isReqed = true
	else
		self.fields.Button_friend:setTime(false)
		local uid = self.tablePlayerInfo.base.uid
		local isFriend = contactCtrl:isFriend(uid)
		if isFriend then
			self.fields.Button_friend:setString(i18n("friend_btn_06"))
			self.friendType = 3
		else
			local isSent = contactCtrl:isSendInvite(uid)
			if isSent then
				self.fields.Button_friend:setString(i18n("common_text_3092"))
				self.friendType = 2
			else
				self.fields.Button_friend:setString(i18n("friend_btn_07"))
				self.friendType = 1
			end
		end
	end
end
function lordViewPanel:showPublicInfo()
	self.fields.Com_lord:initData(self.tablePlayerInfo.base.imageId)
	self.fields.com_name:initData(self.tablePlayerInfo, self.isSelfView)
	self.fields.com_detail:initData(self.tablePlayerInfo, self.isSelfView)
	local isNextMaxLv = nebulaActivityCtrl:isNebulaActivityOpen() and self.tablePlayerInfo.base.isReachFullExp and lordLocalData.getRealMaxLordLevel() > self.tablePlayerInfo.base.level
	if self.tablePlayerInfo.base.isReachFullExp then
		self.fields.Bar_exp:setFull(isNextMaxLv)
	else
		self.fields.Bar_exp:initData(self.tablePlayerInfo.expUpper, self.tablePlayerInfo.base.exp)
	end
	self.fields.Bar_exp:updateAddBtn(self.isSelfView)
	self:initEquip()
end
function lordViewPanel:showGuardian()
	if not self.isSelfView then
		return
	end
	if #self.ownOperateList == 0 then
		self:checkOperateBtns()
	end
	if SoraDGetCastleLv() >= funUnlockRead.getUnlockLevel(gFunBuildKey.GUARDIAN) then
		_UPVALUE3_ = SoraDGetCastleLv()
		_UPVALUE4_, SoraDGetCastleLv()[1] = "frame_protect_01.png", "frame_protect_01.png"
		_UPVALUE4_, SoraDGetCastleLv()[2] = "frame_protect_01.png", "frame_protect_02.png"
		local _UPVALUE4_, SoraDGetCastleLv()[3], iconName = "frame_protect_01.png", "frame_protect_03.png", SoraDGetCastleLv()
		;("frame_protect_01.png")[1] = "common_text_699"
		;("frame_protect_01.png")[2] = "protect_name_01"
		;("frame_protect_01.png")[3] = "protect_name_02"
		local ("frame_protect_01.png")[4], textName = "protect_name_03", "frame_protect_01.png"
		local guardianType = guardianCtrl:getGuardType()
		local indexType = guardianType == 0 and 1 or guardianType
		local myGuardianBtn = self:getOwnGuardian()
		myGuardianBtn:setRed(guardianCtrl:getIsCanReceive())
		myGuardianBtn:setIcon(iconName[indexType])
		myGuardianBtn:setTitle(i18n(textName[guardianType == 0 and 2 or guardianType + 1]))
		myGuardianBtn:setStatus(guardianType == 0)
	end
end
function lordViewPanel:updataGuardian()
	if self.tablePlayerInfo.isShowGuardType then
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.GUARDIAN)
		self.fields.Button_hisGuardian:setVisible(unlockLv <= SoraDGetCastleLv())
		if unlockLv <= SoraDGetCastleLv() then
			_UPVALUE3_ = SoraDGetCastleLv()
			_UPVALUE4_, SoraDGetCastleLv()[1] = "frame_protect_01.png", "frame_protect_01.png"
			_UPVALUE4_, SoraDGetCastleLv()[2] = "frame_protect_01.png", "frame_protect_02.png"
			local _UPVALUE4_, SoraDGetCastleLv()[3], iconName = "frame_protect_01.png", "frame_protect_03.png", SoraDGetCastleLv()
			;("frame_protect_01.png")[1] = "common_text_699"
			;("frame_protect_01.png")[2] = "protect_name_01"
			;("frame_protect_01.png")[3] = "protect_name_02"
			local ("frame_protect_01.png")[4], textName = "protect_name_03", "frame_protect_01.png"
			local indexType = self.tablePlayerInfo.guardType == 0 and 1 or self.tablePlayerInfo.guardType
			self.fields.Button_hisGuardian:setIcon(iconName[indexType])
			self.fields.Button_hisGuardian:setStatus(self.tablePlayerInfo.guardType == 0)
			self.fields.Button_hisGuardian:setTitle(i18n(textName[self.tablePlayerInfo.guardType + 1]))
			self.fields.Button_hisGuardian:setRed(false)
		end
	else
		self.fields.Button_hisGuardian:setVisible(false)
	end
end
function lordViewPanel:updateFirstKingdom()
	local mergeHistory = lordInfoCtrl:getMergeHistory()
	self.fields.btn_firstKingdom:setVisible(mergeHistory[1] ~= nil)
	if mergeHistory[1] ~= nil then
		self.fields.Com_firstKindom:setTitle(string.format("%s#%d", i18n("CombineServers_23"), mergeHistory[1]))
	end
end
function lordViewPanel:getAnchorBtn()
	for k, v in ipairs(self.fields.List_own:getChildren()) do
		if v:getIndex() == 5 then
			return v
		end
	end
end
function lordViewPanel:getOwnGuardian()
	for k, v in ipairs(self.fields.List_own:getChildren()) do
		if v:getIndex() == 4 then
			return v
		end
	end
end
function lordViewPanel:getOwnVip()
	for k, v in ipairs(self.fields.List_own:getChildren()) do
		if v:getIndex() == 2 then
			return v
		end
	end
end
function lordViewPanel:checkEquipSlot()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EQUIP_SLOT)
	for i = 1, 8 do
		self.fields["equip_" .. i]:setVisible(unlockLv <= SoraDGetCastleLv())
	end
end
function lordViewPanel:initEquip()
	if self.isSelfView then
		self.setID = equipmentCtrl:getActiveSet()
		for i = 1, 8 do
			self.fields["equip_" .. i]:initData(i, equipmentMgr.getPartEquipment(i), self.setID, self.isSelfView)
		end
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EQUIP_GROUP)
		self.fields.Button_operate:setVisible(unlockLv <= SoraDGetCastleLv())
	else
		self.setID = nil
		self.fields.Button_operate:setVisible(true)
		for i = 1, 8 do
			if i <= gEquipmentPart.HAND then
				if self.tablePlayerInfo.eInfo.allowShow then
					self.fields["equip_" .. i]:initData(i, self.tablePlayerInfo.eInfo[i])
				else
					self.fields["equip_" .. i]:initData(i)
				end
			else
				self.fields["equip_" .. i]:initData(i, self.tablePlayerInfo.eInfo[i])
			end
		end
	end
end
function lordViewPanel:updateEquip(target, data)
	if self.isSelfView then
		self:initEquip()
		self:initEquipWeaponEnhance(true)
	end
end
function lordViewPanel:updateOffcial(target, data)
	local uid = data.msg == "MESSAGE_LORDINFO_DISMISS_TITLE_BACK" and data.uid or data.redata.uid
	if self.tablePlayerInfo.base.uid == uid then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function lordViewPanel:updateRedPoint()
	if self.isSelfView then
		self.fields.com_detail:setRed()
		local anchorBtn = self:getAnchorBtn()
		if anchorBtn then
			anchorBtn:setReddot(djCtrl:isBeInvite())
		end
	end
end
function lordViewPanel:updateEquipPop(target, data)
	if data.data then
		self.fields.Com_equipInfoPop:setVisible(true)
		local equipInfo = self.isSelfView and equipmentMgr.getAllPartEquipment() or self.tablePlayerInfo.eInfo
		self.fields.Com_equipInfoPop:initData(data.data, equipInfo)
		local line = math.ceil(data.index / 2) - 1
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(data.data:getEID())
		if isSuitEquip then
			self.fields.Com_equipInfoPop:setPositionY(line * 110 + self.fields.Com_equipInfoPop:getRealHeight() / 2 + 45)
		else
			self.fields.Com_equipInfoPop:setPositionY(line * 110 + self.fields.Com_equipInfoPop:getRealHeight() / 2 + 100)
		end
	else
		self.fields.Com_equipInfoPop:setVisible(false)
	end
end
function lordViewPanel:initEquipWeaponEnhance(isOwn)
	if isOwn then
		if commonCheck.STRENGTHEN then
			local ret, qualityTable = equipmentMgr.isWearWeaponEnhance()
			local isBtnShow = next(qualityTable) and true or false
			self.fields.Button_weaponEnhance:setVisible(isBtnShow)
		end
	else
		self.fields.Button_weaponEnhance:setVisible(false)
	end
end
function lordViewPanel:portraitClick()
	if self.isSelfView then
		SoraDPlaySound()
		uiManager:show("lordChangeHeadView")
	end
end
function lordViewPanel:pigeonClick()
	SoraDPlaySound()
	local itemID = 501901
	local pigeonID = 511701
	if backpackCtrl:getItemCount(itemID) > 0 and backpackCtrl:getItemCount(pigeonID) > 0 then
		_ENV = nil
		;(nil).name = self.tablePlayerInfo.base.nickName
		;(nil).abbr = self.tablePlayerInfo.abbr
		uiManager:show("mailGivePop", nil)
		return
	end
	if not IsArClient and backpackCtrl:getItemCount(pigeonID) > 0 then
		itemID = pigeonID
	end
	_ENV = nil
	;(nil).name = self.tablePlayerInfo.base.nickName
	;(nil).abbr = self.tablePlayerInfo.abbr
	;(nil).itemID = itemID
	uiManager:show("mailGivePresent", nil)
end
function lordViewPanel:operateClick()
	SoraDPlaySound()
	if self.isSelfView then
		uiManager:show("lordEquipView")
	else
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FLOWER)
		if unlockLv > SoraDGetCastleLv() then
			_ENV = nil
			;(nil).level = unlockLv
			SoraDShowMsgTip(i18n("common_text_2417", nil))
			return
		end
		_ENV = i18n("common_text_2417", nil)
		i18n("common_text_2417", nil).playerInfo = self.tablePlayerInfo
		uiManager:show("flowerSendView", i18n("common_text_2417", nil))
	end
end
function lordViewPanel:weaponEnhanceClick()
	SoraDPlaySound()
	uiManager:show("WeaponEnhance")
end
function lordViewPanel:djListClick()
	SoraDPlaySound()
	if worldMapDefine.isInWar() or not lordInfoCtrl:isInSelfKid() then
		SoraDShowMsgTip(i18n("Anchor_text_201"))
		return
	end
	VoiceChatSDKManager:getInstance():req4Permission()
	if djCtrl.curListenUid then
		_ENV = i18n("Anchor_text_201")
		i18n("Anchor_text_201").djUid = djCtrl.curListenUid
		uiManager:show("DjView", i18n("Anchor_text_201"))
	else
		uiManager:show("DjList")
	end
	djCtrl:resetBeInvite()
	self:updateRedPoint()
end
function lordViewPanel:flowerClick()
	SoraDPlaySound()
	uiManager:show("flowerOwnView")
end
function lordViewPanel:vipClick()
	SoraDPlaySound()
	uiManager:show("exclusiveVipView")
end
function lordViewPanel:infoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).playerInfo = self.tablePlayerInfo
	uiManager:show("lordInfoView", nil)
end
function lordViewPanel:btnAchiClickCallBack()
	if self.isKingdomBattle then
		return
	end
	SoraDPlaySound()
	SoraDShowLoading(self)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_BY_UID", handler(self, self.serverMessageGetLordInfo))
	achievementctrl:sendOtherLordMetalInfo(gametop.playertop_:getKingdomID(), self.tablePlayerInfo.base.uid)
end
function lordViewPanel:onFirstKingdomClick()
	SoraDPlaySound()
	local isVisible = self.fields.Com_firstKindom:isVisible()
	self.fields.Com_firstKindom:setVisible(not isVisible)
end
function lordViewPanel:hideFirstKingdom()
	self.fields.Com_firstKindom:setVisible(false)
end
function lordViewPanel:serverMessageGetLordInfo(target, data)
	_ENV = nil
	;(nil).otherData = data.data
	uiManager:show("honourWallView", nil)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_HONOUR_BY_UID")
	SoraDCloseLoading(self)
end
function lordViewPanel:guardianClick()
	uiManager:show("guardianPopView")
end
function lordViewPanel:settingClick()
	SoraDPlaySound("uicontrol", 34)
	uiManager:show("gameSettingView")
end
function lordViewPanel:skillClick()
	SoraDPlaySound("uicontrol", 36)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.LORD_SKILL)
	if unlockLv > SoraDGetCastleLv() then
		_ENV = nil
		;(nil).name = i18n("common_title_03")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	else
		uiManager:show("skillView")
	end
end
function lordViewPanel:btnHonourClick()
	SoraDPlaySound("uicontrol", 31)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ACHIEVEMENT)
	if unlockLv > SoraDGetCastleLv() then
		_ENV = nil
		;(nil).name = i18n("common_text_1752")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	else
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		end
		_ENV = i18n("common_text_2122", nil)
		i18n("common_text_2122", nil).isToAchi = true
		i18n("common_text_2122", nil).isReqForList = true
		uiManager:show("honourWallView", i18n("common_text_2122", nil))
	end
end
function lordViewPanel:rankClick()
	SoraDPlaySound("uicontrol", 35)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.RANK)
	if unlockLv > SoraDGetCastleLv() then
		_ENV = nil
		;(nil).name = i18n("common_text_851")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	else
		uiManager:show("rankingsView")
	end
end
function lordViewPanel:btnAllianceClickCallBack()
	SoraDPlaySound()
	local kid = self.tablePlayerInfo.base.partition or 0
	local teamId = self.tablePlayerInfo.base.teamId
	if teamId and worldMapDefine.isLegendLordKingdomID(kid) then
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openPreView(teamId, worldMapDefine.currentMapKindomID)
	else
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local allianceDesRead = include("allianceDesRead")
		local aid = tonumber(self.tablePlayerInfo.aid)
		if aid == nil and not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
			SoraDShowMsgBox(i18n("common_text_2301"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					allianceMgr:reqInviteJoin(self.tablePlayerInfo.base.uid)
					if tolua.isnull(self) then
						return
					end
					self.fields.Button_alliance:setEnabled(false)
				end
			end)
		elseif aid then
			SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
			_ENV = "MESSAGE_ALLIANCE_REQ_INFO_BACK"
			;("MESSAGE_ALLIANCE_REQ_INFO_BACK").aid = aid
			allianceQuery:reqAllianceByID("MESSAGE_ALLIANCE_REQ_INFO_BACK")
		end
	end
end
function lordViewPanel:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	SoraDOpenAllianceInfoView(alliance)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
end
function lordViewPanel:btnSendMailClickCallBack()
	SoraDPlaySound()
	if self.tablePlayerInfo.shiledStranger then
		local ownAid = gametop.playertop_:getModule("allianceMgr"):getOwnAid()
		if not SoraDGetCtrl("contactCtrl"):isFriend(self.tablePlayerInfo.base.uid) and (not ownAid or ownAid ~= self.tablePlayerInfo.aid) then
			SoraDShowMsgTip(i18n("chat_text_66"))
			return
		end
	end
	_ENV = ownAid
	gametop.playertop_:getModule("allianceMgr"):getOwnAid().targetType = gMailType.CHAT
	gametop.playertop_:getModule("allianceMgr"):getOwnAid().target = self.tablePlayerInfo.base.uid
	gametop.playertop_:getModule("allianceMgr"):getOwnAid().nickName = self.tablePlayerInfo.base.nickName
	local gametop.playertop_:getModule("allianceMgr"):getOwnAid().allianceAbbr, data = self.tablePlayerInfo.abbr, gametop.playertop_:getModule("allianceMgr"):getOwnAid()
	SoraDCreateChatView(data)
end
function lordViewPanel:btnFriendClickCallBack(button, event)
	SoraDPlaySound()
	if self.friendType == 1 then
		if self.tablePlayerInfo.base.castlelv < CASTLE_LV6_LIMITED then
			SoraDShowMsgTip(i18n("friend_text_14"))
			return
		end
		if contactCtrl:isFriend(self.tablePlayerInfo.base.uid) then
			SoraDShowMsgTip(i18n("friend_text_05"))
			return
		end
		if contactCtrl:isSendInvite(self.tablePlayerInfo.base.uid) then
			SoraDShowMsgTip(i18n("friend_text_16"))
			return
		end
		if contactCtrl:isOwnFriendMaxLimit() then
			SoraDShowMsgTip(i18n("friend_text_06"))
			return
		end
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.iconID = self.tablePlayerInfo.base.imageId
		SoraDShowMsgTip.avatar = self.tablePlayerInfo.base.avatar
		SoraDShowMsgTip.uid = self.tablePlayerInfo.base.uid
		SoraDShowMsgTip.kid = self.tablePlayerInfo.base.sourceKid > 0 and self.tablePlayerInfo.base.sourceKid or self.tablePlayerInfo.base.partition
		SoraDShowMsgTip.nickName = self.tablePlayerInfo.base.nickName
		local SoraDShowMsgTip.cityLevel, data = self.tablePlayerInfo.base.castlelv, SoraDShowMsgTip
		_ENV = i18n("friend_text_06")
		i18n("friend_text_06").data = data
		i18n("friend_text_06").isIgnore = true
		uiManager:show("friendApplyView", i18n("friend_text_06"))
	elseif self.friendType == 2 then
		if contactCtrl:isFriend(self.tablePlayerInfo.base.uid) then
			SoraDShowMsgTip(i18n("friend_text_05"))
			return
		end
		if not contactCtrl:isSendInvite(self.tablePlayerInfo.base.uid) then
			SoraDShowMsgTip(i18n("friend_text_17"))
			return
		end
		contactCtrl:reqCancelSendFriendInvite(self.tablePlayerInfo.base.uid)
		self.fields.Button_friend:setTime(true)
		self.fields.Button_friend:setString(i18n("friend_btn_02"))
	elseif self.friendType == 3 then
		SoraDShowMsgBox(i18n("friend_text_18"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				contactCtrl:reqDelContact(self.tablePlayerInfo.base.uid)
			end
		end)
	end
end
function lordViewPanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return lordViewPanel
