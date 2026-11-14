local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local equipDesRead = include("equipDesRead")
local publicRead = include("publicRead")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactViewPanel = class("ArtifactViewPanel", baseFguiPanel)
function ArtifactViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactViewPanel:ctor", self.viewName)
end
function ArtifactViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactViewPanel:onInit()
	print("=======ArtifactViewPanel:onInit")
	self.costStoneId = 240201
	self.advancedStoneId = 240301
	self.tableEXPLabelSpare, _ENV, self.tableEXPActionData, _ENV, self.oldLevel = print, print, print, print, nil
	self.armsData = godArmsCtrl:getArmsList()
	self.curIndex = self.proxy.param and self.proxy.param.index or 1
	self.curData = self.armsData[self.curIndex]
	self.attrList = self:getAttrList()
	self.fields.Com_skill:fixPos()
	self.fields.Com_awakenSkill:fixPos()
	self.fields.List_attr:fixPos()
	self.fields.Effect_bj:fixPos()
	self.fields.Load_Exp:fixPos()
	self.fields.Com_title:initData(i18n("artifact_title_01"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.fields.Label_load:setString(i18n("common_text_3853"))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareClickCallBack))
	self.fields.Button_snapshot:addClickListener(handler(self, self.btnSnapshotClickCallBack))
	self.fields.Button_left:addClickListener(handler(self, self.btnLeftClickCallBack))
	self.fields.Button_right:addClickListener(handler(self, self.btnRightClickCallBack))
	self.fields.Com_skill:addClickListener(handler(self, self.btnSkillClickCallBack))
	self.fields.Com_awakenSkill:addClickListener(handler(self, self.btnAwakeSkillClickCallBack))
	self.fields.Button_rune:setString(i18n("Weapon_Rune_title_001"))
	self.fields.Button_rune:addClickListener(handler(self, self.btnRuneClickCallBack))
	self.fields.Text_powerTitle:setString(i18n("common_text_090"))
	self.fields.Label_attrTitle:setString(i18n("artifact_title_02"))
	self.fields.Button_awake:setString(i18n("artifact_btn_04"))
	self.fields.Button_awake:addClickListener(handler(self, self.btnAwakenClickCallBack))
	self.fields.Button_up:setString(i18n("artifact_btn_03"))
	self.fields.Button_upFree:setFreeTitle(i18n("artifact_text_05"))
	self.fields.Button_upFree:setString(i18n("artifact_btn_02"))
	_ENV = i18n("artifact_btn_02")
	i18n("artifact_btn_02").num = 10
	self.fields.Button_upTen:setString(i18n("artifact_text_11", i18n("artifact_btn_02")))
	self.fields.Button_unLock:setFreeTitle(i18n("weapon_btn_01"))
	self.fields.Button_unLock:setString(i18n("weapon_btn_01"))
	self.fields.Button_unLock:addClickListener(handler(self, self.btnUnlockClickCallBack))
	self.fields.Button_up:addClickListener(handler(self, self.btnUpLvClickCallBack))
	self.fields.Button_upTen:addClickListener(handler(self, self.btnUpLvTenClickCallBack))
	self.fields.Button_upFree:addClickListener(handler(self, self.btnUpFreeClickCallBack))
	self.fields.Label_itemNum:getChild("Btn_add"):addClickListener(handler(self, self.btnAddItemClickCallBack))
	self.fields.Bar_Power:fixChildrenPos()
	self.fields.Text_lv:fixPos()
	self.nodeShader3 = display.newNode()
	self.fields.Load_Shader3:displayObject():addChild(self.nodeShader3)
	self.Node_Exp = display.newNode()
	self.fields.Load_Exp:displayObject():addChild(self.Node_Exp)
	self.fields.Effect_bj:setIsLoop(false)
	self.fields.Effect_bj:setVisible(false)
end
function ArtifactViewPanel:onShow()
	print("=======ArtifactViewPanel:onShow")
	self.soundId = SoraDPlaySound("uicontrol", 59)
	self:updateView()
end
function ArtifactViewPanel:updateView()
	if self.curData == nil then
		return
	end
	if self.curData.isLock then
		self.controllers.c1:setSelectedIndex(0)
		self:updateUnlock()
	elseif self.curData.info.level == ARMS_MAX_LEVEL_NORMAL and self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL then
		self:updateAwaken()
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Text_Tips:setString(i18n("artifact_text_25"))
	else
		self:updateLevelUp()
		if self.curData.info.level == ARMS_MAX_LEVEL_ADVANCE then
			self.controllers.c1:setSelectedIndex(3)
			self.fields.Text_Tips:setString(i18n("artifact_text_21"))
		else
			local count, weight = equipDesRead.calcMustCritTimes(self.curData.info.curRefineTimes)
			_ENV = i18n("artifact_text_21")
			i18n("artifact_text_21").num1 = count
			i18n("artifact_text_21").num2 = weight
			self.fields.Text_Tips:setString(i18n("artifact_text_13", i18n("artifact_text_21")))
			self.controllers.c1:setSelectedIndex(1)
		end
	end
	self:updateArtifactAction()
	self:updatePublic()
end
function ArtifactViewPanel:updateUnlock(...)
	local str = ""
	local ret = false
	local canUnlock = 0
	self.canFreeUnlock = false
	for i, v in ipairs(self.curData.unlockCondition) do
		if v.type == ARMS_UNLOCK_TYPE.UNLOCK_CASTLE then
			_ENV = ARMS_UNLOCK_TYPE.UNLOCK_CASTLE
			ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.condtype = gCondType.buildlv
			ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.id = v.id
			ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.condvalue = v.value
			ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_CASTLE)
		elseif v.type == ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL then
			_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condtype = gCondType.artifactlv
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.id = v.id
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condvalue = v.value
			ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL)
		elseif v.type == ARMS_UNLOCK_TYPE.UNLOCK_ITEM then
			_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ITEM
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condtype = gCondType.itemcount
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.id = v.id
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condvalue = v.value
			ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ITEM)
		end
		if ret then
			canUnlock = canUnlock + 1
		end
	end
	self.canFreeUnlock = canUnlock >= #self.curData.unlockCondition and 0 < canUnlock
	if 0 < #self.curData.unlockCondition then
		self.fields.Button_unLock:setCost(gIDDef.GOLD, 0)
	elseif self.canFreeUnlock then
		self.fields.Button_unLock:setCost(gIDDef.GOLD, 0)
	else
		local immedCondition = self.curData.immedCondition[1]
		if immedCondition.type == ARMS_UNLOCK_TYPE.UNLOCK_GOLD then
			self.fields.Button_unLock:setCostIcon(publicRead.getIcon(gIDDef.GOLD))
			self.fields.Button_unLock:setNumTotal2(SoraDGetGold(), immedCondition.value, "#E02B2B")
		else
			self.fields.Button_unLock:setCostIcon(publicRead.getIcon(immedCondition.id))
			self.fields.Button_unLock:setNumTotal2(backpackCtrl:getItemCount(immedCondition.id), immedCondition.value, "#E02B2B")
		end
	end
end
function ArtifactViewPanel:updateLevelUp(...)
	local maxRefineTimes = equipDesRead.getArtifactMaxRefineTimes()
	equipDesRead = nil
	;(nil).num = maxRefineTimes - self.curData.info.advanceRefineTimes
	self.fields.Label_LvCount:setString(i18n("artifact_text_08", nil))
	if self.curData.info.normalRefineTimes >= ARMS_FREE_REFINE then
		equipDesRead = i18n("artifact_text_08", nil)
		i18n("artifact_text_08", nil).num = backpackCtrl:getItemCount(self.costStoneId)
		self.fields.Label_itemNum:setString(i18n("artifact_text_04", i18n("artifact_text_08", nil)))
		self.fields.Label_itemNum:setIcon(publicRead.getIcon(self.costStoneId))
		self.fields.Label_itemNum:getController("c1"):setSelectedIndex(1)
		self.fields.Button_upFree:setCost(self.costStoneId, 10)
	else
		self.fields.Label_itemNum:getController("c1"):setSelectedIndex(0)
		equipDesRead = publicRead.getIcon(self.costStoneId)
		publicRead.getIcon(self.costStoneId).num = ARMS_FREE_REFINE
		self.fields.Label_itemNum:setString(i18n("artifact_text_03", publicRead.getIcon(self.costStoneId)))
		self.fields.Button_upFree:setCost(self.costStoneId, 0)
	end
	self.fields.Button_up:setCost(self.advancedStoneId, equipDesRead.getRefineCost(self.curData.info.advanceRefineTimes + 1, 1))
	self.fields.Button_upTen:setCost(self.advancedStoneId, equipDesRead.getRefineCost(self.curData.info.advanceRefineTimes + 1, 10))
end
function ArtifactViewPanel:updateAwaken(...)
	local itemInfo = equipDesRead.getArtifactAwakeInfo(self.curData.weaponID)
	self.fields.Button_awake:setCostIcon(publicRead.getIcon(itemInfo[1]))
	self.fields.Button_awake:setNumTotal2(backpackCtrl:getItemCount(itemInfo[1]), itemInfo[2], "#E02B2B")
end
function ArtifactViewPanel:updatePublic(...)
	self.fields.Label_name:setString(i18n(self.curData.name))
	self.fields.Label_name:setIcon(self.curData.typeIcon)
	self.fields.List_attr:setNumItems(#self.attrList)
	self:updatePower()
	self:updateSkill()
	self:updateAwakenSkill()
	self:checkRune()
end
function ArtifactViewPanel:updatePower()
	local lv = self.curData.info.level
	if lv <= 0 then
		return
	end
	if lv == ARMS_MAX_LEVEL_NORMAL and self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL or lv == ARMS_MAX_LEVEL_ADVANCE then
		self:stopActionByTag(111)
		local exp = equipDesRead.getArtifactExp(self.curData.weaponID, lv - 1)
		self.fields.Bar_Power:setMax(exp + 1)
		self.fields.Bar_Power:setValue(exp + 1)
		self.fields.Bar_Power:getChild("title"):setString("MAX")
		_ENV = nil
		;(nil).lv = lv
		self.fields.Text_lv:setString(i18n("common_text_100", nil))
	elseif self.oldLevel and self.oldLevel ~= 0 and lv > self.oldLevel then
		self:setProgressByAction()
	else
		self.oldLevel = lv
		self.fields.Bar_Power:setMax(equipDesRead.getArtifactExp(self.curData.weaponID, lv))
		self.fields.Bar_Power:setValue(0)
		self.fields.Bar_Power:tweenValue(self.curData.info.exp, 0.5)
		_ENV = equipDesRead.getArtifactExp(self.curData.weaponID, lv)
		equipDesRead.getArtifactExp(self.curData.weaponID, lv).lv = lv
		self.fields.Text_lv:setString(i18n("common_text_100", equipDesRead.getArtifactExp(self.curData.weaponID, lv)))
	end
	local power_weapon = equipDesRead.getArtifactPower(self.curData.weaponID, lv)
	local power_rune = godArmsRuneCtrl:getRunePower(self.curData.weaponID)
	self.fields.Text_power:setString(string.formatnumberthousands(power_weapon + power_rune))
end
function ArtifactViewPanel:updateSkill()
	if not self.curData.info or not self.curData.info.activeSkillList[1] then
		local equipDesRead, skillData = self.curData.info.activeSkillList[1], self.curData.info.activeSkillList[1]
	end
	local isLock = not skillData.isActive or self.curData.isLock
	self.curSkillData = equipDesRead.getArtifactActiveSkill(self.curData.weaponID)
	self.fields.Com_skill:setIcon(self.curSkillData.icon)
	self.fields.Com_skill:getController("c1"):setSelectedIndex(isLock and 1 or 0)
	self:endCDTime()
	if isLock then
		equipDesRead = nil
		;(nil).num = skillData.activeLevel
		self.fields.Com_skill:setString(i18n("artifact_text_01", nil))
	else
		local isInCD, cdTime = godArmsCtrl:skillInCD(self.curSkillData.skillID, self.curSkillData.skillCD)
		if isInCD then
			self:beginCDTime()
		else
			self.fields.Com_skill:setString(i18n(self.curSkillData.name))
		end
	end
end
function ArtifactViewPanel:updateAwakenSkill()
	local awakenInfo = equipDesRead.getArtifactAwakeSkillInfo(self.curData.weaponID)
	self.fields.Com_awakenSkill:setIcon(awakenInfo.icon)
	self.fields.Com_awakenSkill:getController("c1"):setSelectedIndex(self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE and 0 or 1)
	if self.curData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE then
		self.fields.Com_awakenSkill:setString(i18n(awakenInfo.name))
	else
		self.fields.Com_awakenSkill:setString(i18n("artifact_text_22"))
	end
	self.fields.Com_awakenSkill:setVisible(self.curData.info.level >= ARMS_MAX_LEVEL_NORMAL)
end
function ArtifactViewPanel:updateArtifactAction()
	local _, isExist = SoraDIsFileExistByFileName(self.curData.actionNode.png, true)
	if isExist then
		self.fields.Load_artifact:setURL(string.format("ui://ArtifactView/Com_%s", self.curData.weaponID))
		if self.curData.isLock then
			self:updateUnlockEquip()
			self.shenqi14Bg:setVisible(true)
			self.fields.Load_artifact:setVisible(false)
		else
			self.fields.Load_artifact:getComponent():getTransition("t0"):play(-1, 0, 0, -1)
			if self.shenqi14Bg then
				self.shenqi14Bg:setVisible(false)
			end
			self.fields.Load_artifact:setVisible(true)
		end
		self.fields.Label_load:setVisible(false)
	else
		self.fields.Load_artifact:setVisible(false)
		self.fields.Label_load:setVisible(true)
	end
end
function ArtifactViewPanel:selectArtifact(index)
	self.tableEXPActionData, _ENV = nil, nil
	self:stopActionByTag(111)
	self.curIndex = index
	self.curData = self.armsData[self.curIndex]
	self.oldLevel = self.curData.info.level
	self.attrList = self:getAttrList()
	dump(self.curData, "sldkjfsldkjflsd")
	self:updateView()
	self.fields.List_attr:jumpToTop()
	SoraDPlaySound("artifactSound", self.curData.actionNode.sound)
end
function ArtifactViewPanel:btnUnlockClickCallBack()
	SoraDPlaySound()
	if self.isRunUnlockAction or self.curData == nil then
		return
	end
	if #self.curData.unlockCondition > 0 then
		_ENV = nil
		;(nil).handle = function(...)
			self.isRunUnlockAction = true
		end
		;(nil).data = self.curData
		uiManager:show("ArtifactUnlock", nil)
	elseif self.canFreeUnlock then
		self.isRunUnlockAction = true
		godArmsCtrl:reqUnlock(self.curData.weaponID)
		SoraDShowLoading()
	else
		local unlockFun = function(...)
			self.isRunUnlockAction = true
			godArmsCtrl:reqUnlock(self.curData.weaponID)
			SoraDShowLoading()
		end
		local immedCondition = self.curData.immedCondition[1]
		if immedCondition.type == ARMS_UNLOCK_TYPE.UNLOCK_GOLD then
			_ENV = nil
			;(nil).gold = immedCondition.value
			;(nil).name = i18n(self.curData.name)
			SoraDShowBuyBox(i18n("artifact_text_36", nil), immedCondition.value, i18n("common_text_740"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					unlockFun()
				end
			end)
		else
			_ENV = i18n("artifact_text_36", nil)
			i18n("artifact_text_36", nil).condtype = gCondType.itemcount
			i18n("artifact_text_36", nil).id = immedCondition.id
			i18n("artifact_text_36", nil).condvalue = immedCondition.value
			do
				local ret = condParser.verify((i18n("artifact_text_36", nil)))
				if ret then
					unlockFun()
				elseif self.curData.actionNode.unlockShopItem then
					SoraDShowMsgBox(i18n("artifact_text_40"), i18n("common_text_477"), nil, function(type)
						if type == MSGBOX_CALLBACK_YES then
							_ENV = nil
							;(nil).type = 1
							;(nil).mid = self.curData.actionNode.unlockShopItem
							uiManager:show("bagView", nil)
						end
					end)
				elseif self.curData.actionNode.unlockByGift then
					if self.curData.info.armsID == 6500131 or self.curData.info.armsID == 6400131 then
						local immedCondition = self.curData.immedCondition[1]
						_ENV = i18n("artifact_text_40")
						function _ENV(type)
							if type == MSGBOX_CALLBACK_YES then
								_ENV = nil
								;(nil).type = 1
								;(nil).mid = self.curData.actionNode.unlockShopItem
								uiManager:show("bagView", nil)
							end
						end
						;(function(type)
							if type == MSGBOX_CALLBACK_YES then
								_ENV = nil
								;(nil).type = 1
								;(nil).mid = self.curData.actionNode.unlockShopItem
								uiManager:show("bagView", nil)
							end
						end).name = include("itemDesRead").getName(immedCondition.id)
						i18n("artifact_text_40").title = i18n("equip_text_27", function(type)
							if type == MSGBOX_CALLBACK_YES then
								_ENV = nil
								;(nil).type = 1
								;(nil).mid = self.curData.actionNode.unlockShopItem
								uiManager:show("bagView", nil)
							end
						end)
						_ENV, i18n("artifact_text_40").defaultBtnTitle = i18n("common_text_477"), i18n("common_text_477")
						i18n("common_text_477")[1] = i18n("return_lcks_text_036")
						_ENV, i18n("artifact_text_40").itemTitle, i18n("common_text_477")[2] = i18n("common_text_477"), i18n("common_text_477"), i18n("activity_name_9001168")
						i18n("common_text_477")[1] = function()
							_ENV = nil
							;(nil).type = 1
							;(nil).jumpStore = "btnOther"
							uiManager:show("bagView", nil)
						end
						_ENV, i18n("artifact_text_40").btnCallBack, i18n("common_text_477")[2] = i18n("common_text_477"), i18n("common_text_477"), function()
							local _eventState = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.WRATH_BEAST_ACTIVITY)
							if clientEventMgr.judgeIsOnShow(_eventState) then
								local panel = SoraDCreatePanel("wrathBeastMainView")
								panel.ccs_tab:clickByTag(2)
								panel:show()
							else
								SoraDShowMsgTip(i18n("devilvalley_text_08"))
							end
						end
						i18n("common_text_477")[1] = nil
						i18n("artifact_text_40").btnCallBackParam, i18n("common_text_477")[2] = i18n("common_text_477"), nil
						local i18n("artifact_text_40").size, param = 2, i18n("artifact_text_40")
						uiManager:show("GetWayPopBox", param)
					else
						SoraDShowMsgTip(i18n("artifact_text_37"))
					end
				else
					SoraDShowMsgTip(i18n("artifact_text_19"))
				end
			end
		end
	end
end
function ArtifactViewPanel:btnAwakenClickCallBack()
	if self.isRunAwakeAction then
		return
	end
	SoraDPlaySound()
	if self.fields.Button_awake:getBtnCheck() then
		self.isRunAwakeAction = true
		godArmsCtrl:reqAwake(self.curData.weaponID)
		SoraDShowLoading()
	elseif self.curData.actionNode.awakenShopItem or self.curData.actionNode.awakenByGift then
		if self.curData.weaponID == 6500131 then
			local giftID = 13502
			if SoraDCheckShow(giftID) then
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).id = giftID
					;(nil).fromCenter = gRechargeActiveFromEnum.ROAD47
					uiManager:show("rechargePopFrame", nil)
				else
					local panel = SoraDCreatePanel("rechargePopFrame")
					panel:initData(giftID, gRechargeActiveFromEnum.ROAD47)
					panel:show()
				end
			else
				SoraDShowMsgTip(i18n("artifact_text_38"))
			end
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT) then
			SoraDShowMsgBox(i18n("artifact_text_39"), i18n("common_text_477"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).id = gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT
					uiManager:show("ExchangeEventPage", nil)
				end
			end)
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW) then
			SoraDShowMsgBox(i18n("artifact_text_39"), i18n("common_text_477"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).id = gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW
					uiManager:show("ExchangeEventPage", nil)
				end
			end)
		else
			SoraDShowMsgTip(i18n("artifact_text_41"))
		end
	else
		SoraDShowMsgTip(i18n("artifact_text_24"))
	end
end
function ArtifactViewPanel:btnRuneClickCallBack()
	SoraDPlaySound()
	local cfgCastleLv, cfgArtifactLv = artifactRuneRead.getUnlockCfg()
	if cfgArtifactLv <= self.curData.info.level then
		uiManager:show("RuneMain", self.curData)
	else
		_ENV = self.curData
		self.curData.name1 = i18n(self.curData.name)
		self.curData.lv = cfgArtifactLv
		self.curData.name2 = i18n("Weapon_Rune_title_001")
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_036", self.curData))
	end
end
function ArtifactViewPanel:btnLeftClickCallBack()
	SoraDPlaySound()
	if self.isRunUnlockAction or self.isRunAwakeAction then
		return
	end
	self.curIndex = self.curIndex - 1
	if self.curIndex < 1 then
		self.curIndex = #self.armsData
	elseif self.curIndex > #self.armsData then
		self.curIndex = 1
	end
	self:selectArtifact(self.curIndex)
end
function ArtifactViewPanel:btnRightClickCallBack()
	SoraDPlaySound()
	if self.isRunUnlockAction or self.isRunAwakeAction then
		return
	end
	self.curIndex = self.curIndex + 1
	if self.curIndex < 1 then
		self.curIndex = #self.armsData
	elseif self.curIndex > #self.armsData then
		self.curIndex = 1
	end
	self:selectArtifact(self.curIndex)
end
function ArtifactViewPanel:btnSkillClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	;(nil).skillType = 2
	uiManager:show("ArtifactSkillInfo", nil)
end
function ArtifactViewPanel:btnAwakeSkillClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	;(nil).skillType = 1
	uiManager:show("ArtifactSkillInfo", nil)
end
function ArtifactViewPanel:btnShareClickCallBack()
	SoraDPlaySound()
	if self.curData.isLock then
		SoraDShowMsgTip(i18n("artifact_tips_03"))
	else
		_ENV = i18n("artifact_tips_03")
		i18n("artifact_tips_03").shareAid = self.curData.weaponID
		uiManager:show("ArtifactsShareBox", i18n("artifact_tips_03"))
	end
end
function ArtifactViewPanel:btnSnapshotClickCallBack()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("commonSharePic")
	panel:initData(SoraDCreateScreenShot(), 1)
	panel:show()
end
function ArtifactViewPanel:btnHelpClickCallBack()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ARTIFACT)
end
function ArtifactViewPanel:btnUpFreeClickCallBack()
	SoraDPlaySound()
	if self.curData.info.normalRefineTimes >= ARMS_FREE_REFINE then
		local count = backpackCtrl:getItemCount(self.costStoneId)
		if count < ARMS_FREE_REFINE then
			if count <= 0 then
				SoraDShowMsgTip(i18n("artifact_text_07"))
			else
				_ENV = i18n("artifact_text_07")
				i18n("artifact_text_07").num = count
				SoraDShowMsgBox(i18n("artifact_text_06", i18n("artifact_text_07")), i18n("common_text_204"), nil, function(callBack)
					if callBack == MSGBOX_CALLBACK_YES then
						godArmsCtrl:reqRefine(self.curData.weaponID, ARMS_REFINE_TYPE.NORMAL_REFINE, count)
					end
				end)
			end
		else
			godArmsCtrl:reqRefine(self.curData.weaponID, ARMS_REFINE_TYPE.NORMAL_REFINE, 10)
		end
	else
		godArmsCtrl:reqRefine(self.curData.weaponID, ARMS_REFINE_TYPE.NORMAL_REFINE, ARMS_FREE_REFINE - self.curData.info.normalRefineTimes)
	end
end
function ArtifactViewPanel:btnUpLvClickCallBack()
	SoraDPlaySound()
	self:lvUpByItem(1)
end
function ArtifactViewPanel:btnUpLvTenClickCallBack()
	SoraDPlaySound()
	self:lvUpByItem(10)
end
function ArtifactViewPanel:btnAddItemClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.costStoneId
	uiManager:show("CommonSourceGuide", nil)
end
function ArtifactViewPanel:lvUpByItem(times, needCount)
	local maxRefineTimes = equipDesRead.getArtifactMaxRefineTimes() - self.curData.info.advanceRefineTimes
	if maxRefineTimes <= 0 then
		SoraDShowMsgTip(i18n("artifact_text_10"))
		return
	end
	local checkCount = function(count)
		local itemCount = backpackCtrl:getItemCount(self.advancedStoneId)
		local needCount = equipDesRead.getRefineCost(self.curData.info.advanceRefineTimes + 1, count)
		if itemCount < needCount then
			local gold = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(1000198)
			if gold then
				gold = gold * (needCount - itemCount)
				backpackCtrl = nil
				;(nil).gold = gold
				;(nil).weaponID = self.curData.weaponID
				;(nil).count = count
				uiManager:show("ArtifactBuyPop", nil)
			end
		else
			godArmsCtrl:reqRefine(self.curData.weaponID, ARMS_REFINE_TYPE.ADVANCE_REFINE, count)
		end
	end
	if times > maxRefineTimes then
		equipDesRead = i18n("artifact_text_10")
		equipDesRead = i18n("artifact_text_10")
		i18n("artifact_text_10").num2 = maxRefineTimes
		i18n("artifact_text_10").num1 = equipDesRead.getRefineCost(self.curData.info.advanceRefineTimes + 1, maxRefineTimes)
		i18n("artifact_text_10").content = i18n("artifact_text_12", i18n("artifact_text_10"))
		i18n("artifact_text_10").confirmFunc = function()
			checkCount(maxRefineTimes)
		end
		uiManager:show("MessageBox", i18n("artifact_text_10"))
	else
		checkCount(times)
	end
end
function ArtifactViewPanel:getAttrList()
	if self.curData and self.curData.info then
		local skillData = self.curData.info.skillList
		if self.curData.info.skillList[1] == nil then
			skillData, _ENV = self.curData.info.skillList[1], self.curData.info.skillList[1]
			for k, v in pairs(self.curData.info.skillList) do
				table.insert(skillData, v)
			end
			table.sort(skillData, function(l, r)
				return l.activeLevel < r.activeLevel
			end)
			self.curData.info.skillList = skillData
			self.armsData[self.curIndex].info.skillList = skillData
		end
		return skillData
	end
	_ENV = skillData
	return self.curData.info.skillList
end
function ArtifactViewPanel:updateCDTime()
	local isInCD, cdTime = godArmsCtrl:skillInCD(self.curSkillData.skillID, self.curSkillData.skillCD)
	if isInCD then
		godArmsCtrl = nil
		;(nil).time = SoraDConvertSecondToString(cdTime)
		self.fields.Com_skill:setString(i18n("common_text_725", nil))
	elseif isInCD == false or cdTime == 0 or cdTime == nil then
		self:endCDTime()
		self.fields.Com_skill:setString(i18n(self.curSkillData.name))
	end
end
function ArtifactViewPanel:beginCDTime()
	self.timerCD = SoradCreateTimer(self, handler(self, self.updateCDTime))
	self:updateCDTime()
end
function ArtifactViewPanel:endCDTime()
	if self.timerCD then
		SoraDManagerRemoveTimer(self, self.timerCD)
		self.timerCD = nil
	end
end
function ArtifactViewPanel:checkRune()
	local isUnlock = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_WAR_LINE_SYS, nil, lordInfoCtrl:getMapSourceKid()) ~= nil
	local cfgCastleLv, cfgArtifactLv = artifactRuneRead.getUnlockCfg()
	if not artifactRuneRead.getHoleInfo(self.curData.weaponID) then
		local nebulaMileStoneCtrl, holeCfg = artifactRuneRead.getHoleInfo(self.curData.weaponID), artifactRuneRead.getHoleInfo(self.curData.weaponID)
	end
	local isHoleCfg = next(holeCfg) and true or false
	local isVisible = isUnlock and cfgCastleLv <= SoraDGetCastleLv() and isHoleCfg and not self.curData.isLock
	self.fields.Button_rune:setVisible(isVisible)
	local isShow = isVisible and cfgArtifactLv <= self.curData.info.level
	local ret = godArmsRuneCtrl:isDoneGuide()
	if isShow and not ret then
		nebulaMileStoneCtrl = lordInfoCtrl:getMapSourceKid()
		lordInfoCtrl:getMapSourceKid().msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		lordInfoCtrl:getMapSourceKid().step = 91001
		SoraDSendMessage(lordInfoCtrl:getMapSourceKid())
	end
end
function ArtifactViewPanel:onItemRederer(index, target)
	target:initData(self.attrList[index + 1], self.curData.info.level, self.curData.info.awakeStatus)
end
function ArtifactViewPanel:onHide()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
end
function ArtifactViewPanel:updateUnlockEquip()
	if self.shenqi14Bg == nil then
		local shenqi14Shader = require("app.game.smithyView.artifactView.shader.shenqi14_shader")
		local _ENV, shenqi14MeshParam = "app.game.smithyView.artifactView.shader.shenqi14_shader", "app.game.smithyView.artifactView.shader.shenqi14_shader"
		local shenqi14MeshData = require("app.game.smithyView.artifactView.meshData.shenqi14_meshData")
		for i, v in ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param) do
			table.insert(shenqi14MeshParam, v)
		end
		_ENV = ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param)
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).attr = "#texture"
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).name = "_Texture_SB"
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).value = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture()
		_UPVALUE4_, ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).hasMipmap = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture(), false
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).texParam, cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture()[1] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture(), gl.LINEAR
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).texParam, cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture()[2] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture(), gl.LINEAR
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).texParam, cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture()[3] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture(), gl.REPEAT
		ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param).texParam, cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture()[4] = cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture(), gl.REPEAT
		table.insert(shenqi14MeshParam, ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi14_shaderCfg").param))
		_ENV = table.insert
		table.insert.size = cc.size(1, 1)
		_ENV, table.insert.meshData = cc.size(1, 1), shenqi14MeshData
		cc.size(1, 1).vertBytes = shenqi14Shader.vertBytes
		table.insert.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), shenqi14Shader.fragBytes
		table.insert.param = shenqi14MeshParam
		local table.insert.pos, shenqi14Data = cc.p(0, 0), table.insert
		self.shenqi14Bg = SoraDCreateMeshNode(shenqi14Data.meshData, shenqi14Data.size, shenqi14Data.shader, shenqi14Data.param)
		self.shenqi14Bg:setPosition(cc.p(shenqi14Data.pos))
		self.shenqi14Bg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.shenqi14Bg:addTo(self.nodeShader3, 1)
	end
	self.shenqi14Bg:getGLProgramState():setUniformTexture("_Texture_SB", cc.SpriteFrameCache:getInstance():getSpriteFrame(self.curData.actionNode.png):getTexture())
	self.shenqi14Bg:setScale(self.curData.actionNode.scale.x, self.curData.actionNode.scale.y)
end
function ArtifactViewPanel:unlockAction(...)
	self:updateUnlockEquip()
	if self.unlockRenderTexture == nil then
		self.unlockRenderTexture = cc.RenderTexture:create(display.size.width, display.size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
		self.unlockRenderTexture:addTo(self)
		self.unlockRenderTexture:setPosition(cc.p(display.cx, display.cy))
		self.unlockRenderTexture:setVisible(false)
	end
	local shenqi15Shader = require("app.game.smithyView.artifactView.shader.shenqi15_shader")
	local _ENV, shenqi15MeshParam = "app.game.smithyView.artifactView.shader.shenqi15_shader", "app.game.smithyView.artifactView.shader.shenqi15_shader"
	local shenqi15MeshData = require("app.game.smithyView.artifactView.meshData.shenqi15_meshData")
	for i, v in ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param) do
		table.insert(shenqi15MeshParam, v)
	end
	_ENV = ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param)
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param).attr = "#texture"
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param).name = "_GrabTexture"
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param).value = self.unlockRenderTexture:getSprite():getTexture()
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param).hasMipmap = false
	table.insert(shenqi15MeshParam, ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi15_shaderCfg").param))
	_ENV = table.insert
	table.insert.size = cc.size(1, 1)
	_ENV, table.insert.meshData = cc.size(1, 1), shenqi15MeshData
	cc.size(1, 1).vertBytes = shenqi15Shader.vertBytes
	table.insert.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), shenqi15Shader.fragBytes
	table.insert.param = shenqi15MeshParam
	_ENV, table.insert.pos = cc.p(0, 0), cc.p(0, 0)
	cc.p(0, 0).x = 0.4
	table.insert.scale, cc.p(0, 0).y = cc.p(0, 0), 0.4
	local shenqi15Data = table.insert
	self.shenqi15Bg = SoraDCreateMeshNode(shenqi15Data.meshData, shenqi15Data.size, shenqi15Data.shader, shenqi15Data.param)
	self.shenqi15Bg:setPosition(cc.p(shenqi15Data.pos))
	self.shenqi15Bg:setScale(shenqi15Data.scale.x, shenqi15Data.scale.y)
	self.shenqi15Bg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.shenqi15Bg:addTo(self.nodeShader3, 1)
	self:createShaderAction(2, 1, 0, "_Control", self.shenqi14Bg)
	self:createShaderAction(2.1, 0, 5, "_Control", self.shenqi15Bg, function(...)
		SoraDManagerRemoveTimer(self, self.updateUnlockTimer)
		self.shenqi14Bg:removeFromParent()
		self.shenqi15Bg:removeFromParent()
		self.shenqi14Bg = nil
		self.shenqi15Bg = nil
		self.fields.Load_artifact:setVisible(true)
		self:updateView()
		self.isRunUnlockAction = false
	end)
	self:unlockUpdate()
	self.updateUnlockTimer = SoradCreateTimer(self, function(dt)
		self:unlockUpdate()
	end, true)
end
function ArtifactViewPanel:unlockUpdate()
	self.shenqi15Bg:setVisible(false)
	self.controllers.c2:setSelectedIndex(1)
	self.unlockRenderTexture:beginWithClear(0, 0, 0, 0, 1, 0)
	self:displayObject():visit()
	self.unlockRenderTexture:endToLua()
	self.controllers.c2:setSelectedIndex(0)
	self.shenqi15Bg:setVisible(true)
end
function ArtifactViewPanel:createShaderActions(arr, key, shaderNode, handle)
	shaderNode["shaderSingleAction_" .. key] = function(oldData)
		if 0 < #arr then
			local data = table.remove(arr, 1)
			local sdt = data.sdt
			local starV = data.starV
			local endV = data.endV
			if oldData then
				sdt = sdt - oldData.sdt
				starV = oldData.endV
			end
			self:createShaderAction(sdt, starV, endV, key, shaderNode, function(_shaderNode, _key)
				_shaderNode["shaderSingleAction_" .. _key](data)
			end)
		elseif handle then
			handle()
		end
	end
	shaderNode["shaderSingleAction_" .. key]()
end
function ArtifactViewPanel:createShaderAction(sdt, starV, endV, key, shaderNode, handle)
	local step = (endV - starV) / sdt
	local sign = endV < starV and -1 or 1
	if step == 0 then
		sign = 0
	end
	local shaderTimerCallBack = function(dt)
		if 0 < sign and starV < endV or sign < 0 and starV > endV or sign == 0 and 0 < sdt then
			shaderNode:getGLProgramState():setUniformFloat(key, starV)
		else
			shaderNode:getGLProgramState():setUniformFloat(key, endV)
			SoraDManagerRemoveTimer(self, shaderNode["shaderTimer_" .. key])
			if handle then
				handle(shaderNode, key)
			end
		end
	end
	shaderNode["shaderTimer_" .. key] = SoradCreateTimer(self, shaderTimerCallBack, true)
	shaderTimerCallBack(0)
end
function ArtifactViewPanel:awakeShader(...)
	local shenqi13Shader = require("app.game.smithyView.artifactView.shader.shenqi13_shader")
	local shenqi13MeshParam = require("app.game.smithyView.artifactView.shaderCfg.shenqi13_shaderCfg")
	local shenqi13MeshData = require("app.game.smithyView.artifactView.meshData.shenqi13_meshData")
	_ENV = "app.game.smithyView.artifactView.meshData.shenqi13_meshData"
	;("app.game.smithyView.artifactView.meshData.shenqi13_meshData").size = cc.size(1, 1)
	_ENV, ("app.game.smithyView.artifactView.meshData.shenqi13_meshData").meshData = cc.size(1, 1), shenqi13MeshData
	cc.size(1, 1).vertBytes = shenqi13Shader.vertBytes
	;("app.game.smithyView.artifactView.meshData.shenqi13_meshData").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), shenqi13Shader.fragBytes
	;("app.game.smithyView.artifactView.meshData.shenqi13_meshData").param = shenqi13MeshParam.param
	_ENV, ("app.game.smithyView.artifactView.meshData.shenqi13_meshData").pos = cc.p(0, 0), cc.p(0, 0)
	cc.p(0, 0).x = 0.45
	;("app.game.smithyView.artifactView.meshData.shenqi13_meshData").scale, cc.p(0, 0).y = cc.p(0, 0), 0.45
	local shenqi13Data = "app.game.smithyView.artifactView.meshData.shenqi13_meshData"
	local shenqi13Bg = SoraDCreateMeshNode(shenqi13Data.meshData, shenqi13Data.size, shenqi13Data.shader, shenqi13Data.param)
	shenqi13Bg:setPosition(cc.p(shenqi13Data.pos))
	shenqi13Bg:setScale(shenqi13Data.scale.x, shenqi13Data.scale.y)
	shenqi13Bg:setBlendFunc(gl.ONE, gl.ONE)
	shenqi13Bg:addTo(self.nodeShader3, 1)
	_ENV, _UPVALUE6_ = shenqi13Bg, shenqi13Bg.addTo
	shenqi13Bg.sdt = 0.8333333333333334
	shenqi13Bg.starV = 0
	_ENV, shenqi13Bg.endV = self.nodeShader3, 0.464
	self.nodeShader3.sdt = 1.05
	_ENV, self.nodeShader3.endV = 1, 0.6488
	;(1).sdt = 1.2166666666666666
	_ENV, (1).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 1.2333333333333334
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 1.5333333333333334
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 2.5833333333333335
	cc.p(shenqi13Data.pos).endV = 0
	_ENV, _UPVALUE6_, shenqi13Bg.addTo[1] = self.nodeShader3, shenqi13Bg, shenqi13Bg
	_ENV, _UPVALUE6_, shenqi13Bg.addTo[2] = self.nodeShader3, shenqi13Bg, self.nodeShader3
	_ENV, _UPVALUE6_, shenqi13Bg.addTo[3] = self.nodeShader3, shenqi13Bg, 1
	_ENV, _UPVALUE6_, shenqi13Bg.addTo[4] = self.nodeShader3, shenqi13Bg, cc.p(shenqi13Data.pos)
	_ENV, _UPVALUE6_, shenqi13Bg.addTo[5] = self.nodeShader3, shenqi13Bg, cc.p(shenqi13Data.pos)
	local _ENV, _UPVALUE6_, shenqi13Bg.addTo[6], shenqi13_Data_1 = self.nodeShader3, shenqi13Bg, cc.p(shenqi13Data.pos)
	self.nodeShader3.sdt = 0.8333333333333334
	self.nodeShader3.starV = -1
	_ENV, self.nodeShader3.endV = 1, -0.12
	;(1).sdt = 1.05
	_ENV, (1).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 1.2333333333333334
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 1.5333333333333334
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 2.5833333333333335
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 2.8
	cc.p(shenqi13Data.pos).endV = -1
	_ENV, _UPVALUE3_, shenqi13Bg[1] = 1, self.nodeShader3, self.nodeShader3
	_ENV, _UPVALUE3_, shenqi13Bg[2] = 1, self.nodeShader3, 1
	_ENV, _UPVALUE3_, shenqi13Bg[3] = 1, self.nodeShader3, cc.p(shenqi13Data.pos)
	_ENV, _UPVALUE3_, shenqi13Bg[4] = 1, self.nodeShader3, cc.p(shenqi13Data.pos)
	_ENV, _UPVALUE3_, shenqi13Bg[5] = 1, self.nodeShader3, cc.p(shenqi13Data.pos)
	local _ENV, _UPVALUE3_, shenqi13Bg[6], shenqi13_Data_2 = 1, self.nodeShader3, cc.p(shenqi13Data.pos)
	;(1).sdt = 1.5333333333333334
	;(1).starV = 0
	_ENV, (1).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 2.5833333333333335
	_ENV, cc.p(shenqi13Data.pos).endV = cc.p(shenqi13Data.pos)
	cc.p(shenqi13Data.pos).sdt = 2.8
	cc.p(shenqi13Data.pos).endV = 0
	self.nodeShader3[1] = 1
	self.nodeShader3[2] = cc.p(shenqi13Data.pos)
	local self.nodeShader3[3], shenqi13_Data_3 = cc.p(shenqi13Data.pos)
	self:createShaderActions(shenqi13_Data_1, "_ld", shenqi13Bg)
	self:createShaderActions(shenqi13_Data_3, "_light_value", shenqi13Bg)
	self:createShaderActions(shenqi13_Data_2, "_light_ST_w", shenqi13Bg, function(...)
		shenqi13Bg:removeFromParent()
	end)
	local shenqi11Shader = require("app.game.smithyView.artifactView.shader.shenqi11_shader")
	local shenqi11MeshParam = require("app.game.smithyView.artifactView.shaderCfg.shenqi11_shaderCfg")
	local shenqi11MeshData = require("app.game.smithyView.artifactView.meshData.shenqi11_meshData")
	_ENV = "app.game.smithyView.artifactView.meshData.shenqi11_meshData"
	;("app.game.smithyView.artifactView.meshData.shenqi11_meshData").size = cc.size(1, 1)
	_ENV, ("app.game.smithyView.artifactView.meshData.shenqi11_meshData").meshData = cc.size(1, 1), shenqi11MeshData
	cc.size(1, 1).vertBytes = shenqi11Shader.vertBytes
	;("app.game.smithyView.artifactView.meshData.shenqi11_meshData").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), shenqi11Shader.fragBytes
	;("app.game.smithyView.artifactView.meshData.shenqi11_meshData").param = shenqi11MeshParam.param
	_ENV, ("app.game.smithyView.artifactView.meshData.shenqi11_meshData").pos = cc.p(0, 0), cc.p(0, 0)
	cc.p(0, 0).x = 0.5
	;("app.game.smithyView.artifactView.meshData.shenqi11_meshData").scale, cc.p(0, 0).y = cc.p(0, 0), 0.5
	local shenqi11Data = "app.game.smithyView.artifactView.meshData.shenqi11_meshData"
	self.shenqi11Bg = SoraDCreateMeshNode(shenqi11Data.meshData, shenqi11Data.size, shenqi11Data.shader, shenqi11Data.param)
	self.shenqi11Bg:setPosition(cc.p(shenqi11Data.pos))
	self.shenqi11Bg:setScale(shenqi11Data.scale.x, shenqi11Data.scale.y)
	self.shenqi11Bg:setBlendFunc(gl.ONE, gl.ONE)
	self.shenqi11Bg:addTo(self.nodeShader3, 1)
	_ENV, _UPVALUE4_ = self.shenqi11Bg, self.shenqi11Bg.addTo
	self.shenqi11Bg.sdt = 2.033333333333333
	self.shenqi11Bg.starV = 0
	_ENV, self.shenqi11Bg.endV = self.nodeShader3, 0
	self.nodeShader3.sdt = 2.05
	_ENV, self.nodeShader3.endV = 1, 0.82
	;(1).sdt = 2.45
	_ENV, (1).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.7333333333333334
	cc.p(shenqi11Data.pos).endV = 0
	_ENV, _UPVALUE6_, self.shenqi11Bg.addTo[1] = self.nodeShader3, self.shenqi11Bg, self.shenqi11Bg
	_ENV, _UPVALUE6_, self.shenqi11Bg.addTo[2] = self.nodeShader3, self.shenqi11Bg, self.nodeShader3
	_ENV, _UPVALUE6_, self.shenqi11Bg.addTo[3] = self.nodeShader3, self.shenqi11Bg, 1
	local _ENV, _UPVALUE6_, self.shenqi11Bg.addTo[4], shenqi11_Data_1 = self.nodeShader3, self.shenqi11Bg, cc.p(shenqi11Data.pos)
	self.nodeShader3.sdt = 0.15
	self.nodeShader3.starV = 0
	_ENV, self.nodeShader3.endV = 1, 0
	;(1).sdt = 0.4166666666666667
	_ENV, (1).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 1.8
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.033333333333333
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.6333333333333333
	cc.p(shenqi11Data.pos).endV = 0
	_ENV, _UPVALUE3_, self.shenqi11Bg[1] = 1, self.nodeShader3, self.nodeShader3
	_ENV, _UPVALUE3_, self.shenqi11Bg[2] = 1, self.nodeShader3, 1
	_ENV, _UPVALUE3_, self.shenqi11Bg[3] = 1, self.nodeShader3, cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE3_, self.shenqi11Bg[4] = 1, self.nodeShader3, cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE3_, self.shenqi11Bg[5] = 1, self.nodeShader3, cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE3_, self.shenqi11Bg[6], shenqi11_Data_2 = 1, self.nodeShader3, cc.p(shenqi11Data.pos)
	;(1).sdt = 2.05
	;(1).starV = 0
	_ENV, (1).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.15
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.816666666666667
	cc.p(shenqi11Data.pos).endV = 0
	_ENV, _UPVALUE3_, self.nodeShader3[1] = cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE3_, self.nodeShader3[2] = cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE3_, self.nodeShader3[3], shenqi11_Data_3 = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.033333333333333
	cc.p(shenqi11Data.pos).starV = 0
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.816666666666667
	cc.p(shenqi11Data.pos).endV = 0
	_ENV, _UPVALUE2_, (1)[1] = cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE2_, (1)[2] = cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE2_, (1)[3], shenqi11_Data_4 = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	cc.p(shenqi11Data.pos).starV = 0
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.816666666666667
	cc.p(shenqi11Data.pos).endV = -0.05
	_ENV, _UPVALUE3_, cc.p(shenqi11Data.pos)[1] = cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE3_, cc.p(shenqi11Data.pos)[2], shenqi11_Data_5 = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	cc.p(shenqi11Data.pos).starV = -0.02
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.15
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.816666666666667
	cc.p(shenqi11Data.pos).endV = -0.3
	_ENV, _UPVALUE3_, cc.p(shenqi11Data.pos)[1] = cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE3_, cc.p(shenqi11Data.pos)[2] = cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE3_, cc.p(shenqi11Data.pos)[3], shenqi11_Data_6 = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 0.15
	cc.p(shenqi11Data.pos).starV = 0.3
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.033333333333333
	cc.p(shenqi11Data.pos).starV = 0.3
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	cc.p(shenqi11Data.pos).endV = -0.21
	_ENV, _UPVALUE2_, cc.p(shenqi11Data.pos)[1] = cc.p(shenqi11Data.pos)
	_ENV, _UPVALUE2_, cc.p(shenqi11Data.pos)[2] = cc.p(shenqi11Data.pos)
	local _ENV, _UPVALUE2_, cc.p(shenqi11Data.pos)[3], shenqi11_Data_7 = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.05
	cc.p(shenqi11Data.pos).starV = 0.48
	_ENV, cc.p(shenqi11Data.pos).endV = cc.p(shenqi11Data.pos)
	cc.p(shenqi11Data.pos).sdt = 2.85
	cc.p(shenqi11Data.pos).endV = 0.3
	cc.p(shenqi11Data.pos)[1] = cc.p(shenqi11Data.pos)
	local cc.p(shenqi11Data.pos)[2], shenqi11_Data_8 = cc.p(shenqi11Data.pos)
	self:createShaderActions(shenqi11_Data_1, "_ld", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_2, "_ld1", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_3, "_light_qd", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_4, "_qq_ld", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_5, "_qq_ST_z", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_6, "_qq_ST_w", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_7, "_v1", self.shenqi11Bg)
	self:createShaderActions(shenqi11_Data_8, "_zz_ST_w", self.shenqi11Bg)
	_UPVALUE5_ = "_zz_ST_w"
	;("_zz_ST_w")[1] = cca.delay(0.4166666666666667)
	;("_zz_ST_w")[2] = cca.scaleTo(1.6333333333333333, 0.59)
	;("_zz_ST_w")[3] = cca.callFunc(function(...)
		self.fields.Particle_awaken:setVisible(true)
		self.fields.Particle_awaken:resetSystem()
	end)
	;("_zz_ST_w")[4] = cca.scaleTo(0.4166666666666667, 0.589)
	;("_zz_ST_w")[5] = cca.scaleTo(1.6166666666666667, 0.6)
	;("_zz_ST_w")[6] = cca.callFunc(function(...)
		self.shenqi11Bg:removeFromParent()
		self:updateView()
		self.isRunAwakeAction = false
		self.fields.Particle_awaken:setVisible(false)
	end)
	;("_zz_ST_w")[7] = cca.callFunc(function(...)
		self.shenqi11Bg:removeFromParent()
		self:updateView()
		self.isRunAwakeAction = false
		self.fields.Particle_awaken:setVisible(false)
	end)
	self.shenqi11Bg:runAction(cca.seq("_zz_ST_w"))
end
function ArtifactViewPanel:showFeedHitTimes(add_history)
	local expStr = ""
	for i = 1, #add_history do
		local addItem = add_history[i]
		expStr = addItem.baseExp .. "x" .. addItem.times
		_ENV = addItem.times
		addItem.times.text = expStr
		addItem.times.actType = 1 < addItem.times and 1 or 0
		table.insert(self.tableEXPActionData, addItem.times)
	end
	self:createEXPAction()
end
function ArtifactViewPanel:createEXPAction()
	if not self.isRunAction and self.tableEXPActionData[1] then
		self.isRunAction = true
		local actionData = table.remove(self.tableEXPActionData, 1)
		_UPVALUE2_ = 1
		;(1)[1] = ffa.callFunc(function()
			self:SoraDCreateWaveBMP(actionData)
		end)
		;(1)[2] = ffa.delay(0.1)
		;(1)[3] = ffa.callFunc(function()
			self.isRunAction = false
			self:createEXPAction()
		end)
		;(1)[4] = ffa.callFunc(function()
			self.isRunAction = false
			self:createEXPAction()
		end)
		local action = ffa.seq(1)
		self:runAction(action)
	end
end
function ArtifactViewPanel:SoraDCreateWaveBMP(actionData)
	local _ENV, text = nil, actionData.text or "NA"
	;(nil).color = cc.c3b(255, 255, 0)
	;(nil).fontSize = 18
	;(nil).pos = cc.p(0, 50)
	;(nil).zOrder = 10
	;(nil).duration = 0.4
	;(nil).moveH = 155
	;(nil).scale = 1.2
	local (nil).font, param = "res/fonts/baojishuzi0-9.fnt", nil
	local waveLabel
	if #self.tableEXPLabelSpare >= 20 then
		waveLabel = table.remove(self.tableEXPLabelSpare, 1)
		waveLabel:stopAllActions()
		waveLabel:setOpacity(255)
		waveLabel:setVisible(true)
		waveLabel:setString(text)
	else
		_ENV = waveLabel
		waveLabel.text = text
		waveLabel.font = param.font
		waveLabel = display.newBMFontLabel(waveLabel)
		waveLabel:addTo(self.Node_Exp, param.zOrder)
	end
	table.insert(self.tableEXPLabelSpare, waveLabel)
	waveLabel:setCascadeColorEnabled(false)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
	if actionData.actType == 1 then
		self.fields.Effect_bj:setVisible(true)
		self.fields.Effect_bj:playOnce()
		waveLabel:setScale(0.1 * baseScale)
		waveLabel:setOpacity(0)
		_UPVALUE6_ = waveLabel
		_UPVALUE1_ = 0.24
		;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
		;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
		waveLabel[1] = cca.delay(0.06666666666666667)
		waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
		waveLabel[3] = cca.spawn(0.24)
		waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
		waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
		waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
		waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		local seqPrepare = cca.seq(waveLabel)
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local fadeTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = fadeTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE3_ = fadeTo
		fadeTo[1] = seqPrepare
		fadeTo[2] = spawn
		fadeTo[3] = callFunc
		local seq = cca.seq(fadeTo)
		waveLabel:runAction(seq)
		self:showCritical(param)
	else
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local tintTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = tintTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE2_ = tintTo
		tintTo[1] = spawn
		tintTo[2] = callFunc
		local seq = cca.seq(tintTo)
		waveLabel:runAction(seq)
	end
	return waveLabel
end
function ArtifactViewPanel:showCritical(param)
	if not self.spCritical then
		local spName = SoraDFIsRA() and "#baojialabo.png" or "#baojiyingwen.png"
		self.spCritical = display.newSprite(spName)
		self.spCritical:addTo(self.Node_Exp, 13)
		self.spCritical:setPosition(cc.p(0, 0))
	else
		self.spCritical:setVisible(true)
	end
	local baseScale = param.scale
	self.spCritical:setScale(0.1 * baseScale)
	self.spCritical:setOpacity(0)
	_UPVALUE6_ = self.spCritical
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	self.spCritical[1] = cca.delay(0.06666666666666667)
	self.spCritical[2] = cca.fadeTo(0.016666666666666666, 0.24)
	self.spCritical[3] = cca.spawn(0.24)
	self.spCritical[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	self.spCritical[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	self.spCritical[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	self.spCritical[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(self.spCritical)
	_UPVALUE2_ = cca.delay(0.06666666666666667)
	cca.delay(0.06666666666666667)[1] = seqPrepare
	cca.delay(0.06666666666666667)[2] = cca.delay(param.duration * 0.5)
	cca.delay(0.06666666666666667)[3] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[4] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[5] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[6] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[7] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[8] = cca.fadeOut(param.duration * 0.6)
	local seqAct = cca.seq((cca.delay(0.06666666666666667)))
	self.spCritical:stopAllActions()
	self.spCritical:runAction(seqAct)
end
function ArtifactViewPanel:setProgressByAction()
	local _ENV, actionArray
	local delay = 1 / (self.curData.info.level - self.oldLevel)
	for i = 1, self.curData.info.level - self.oldLevel do
		table.insert(actionArray, ffa.callFunc(function(...)
			if self.oldLevel and self.oldLevel ~= 0 then
				local lv = self.oldLevel + i - 1
				self = nil
				;(nil).lv = lv
				self.fields.Text_lv:setString(i18n("common_text_100", nil))
				local maxExp = equipDesRead.getArtifactExp(self.curData.weaponID, lv)
				self.fields.Bar_Power:setMax(maxExp)
				self.fields.Bar_Power:tweenValue(maxExp, delay)
			end
		end))
		table.insert(actionArray, ffa.delay(delay))
		table.insert(actionArray, ffa.callFunc(function(...)
			if self.oldLevel and self.oldLevel ~= 0 then
				local maxExp = equipDesRead.getArtifactExp(self.curData.weaponID, self.oldLevel + i)
				if maxExp then
					self.fields.Bar_Power:setMax(maxExp)
					self.fields.Bar_Power:setValue(0)
				end
			end
		end))
	end
	table.insert(actionArray, ffa.callFunc(function(...)
		if self.oldLevel and self.oldLevel ~= 0 then
			self.oldLevel = self.curData.info.level
			self:updatePower()
		end
	end))
	local seqProgress = ffa.seq(actionArray)
	seqProgress:setTag(111)
	self:runAction(seqProgress)
end
function ArtifactViewPanel:gameGuide_callFunc(callFunc, data)
	dump(data, "ArtifactViewPanel:gameGuide_callFunc", 10)
	if self[callFunc] then
		self[callFunc](self, data)
	elseif callFunc then
		print(string.format("error:not found funciton %s in ArtifactView", callFunc))
	end
end
function ArtifactViewPanel:jumpToWeapon(weaponID)
	weaponID = tonumber(weaponID)
	print("神器跳转ID:", weaponID, type(weaponID))
	local list = godArmsCtrl:getArmsList()
	for i, v in ipairs(list) do
		if v.weaponID == weaponID then
			self:selectArtifact(i)
			return
		end
	end
end
return ArtifactViewPanel
