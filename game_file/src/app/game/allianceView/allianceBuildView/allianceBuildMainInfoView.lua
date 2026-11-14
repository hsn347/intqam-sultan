local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local AllianceBuildMainInfoView = class("allianceBuildMainInfoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildMainInfoView")
	end
	return target
end)
function AllianceBuildMainInfoView:ctor()
	self.tableSingleData = nil
	self.timer = nil
	self.curState = gAllianceBuildingStatus.NONE
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_des")
	self.nodeBuildInfo = SoraDGetChildByName(self, "Node_buildInfo")
	local scrollH = self.scroll:getContentSize().height
	self.scroll:setBounceEnabled(scrollH < 390)
	self.scroll:setInnerContainerSize(cc.size(640, math.max(scrollH, 390)))
	self.nodeBuildInfo:setPositionY(math.max(scrollH, 390))
	self.imgBuildBg = SoraDGetChildByName(self, "Image_buildBg")
	self.imgBuildBg:setContentSize(cc.size(610, math.max(245, self.scroll:getContentSize().height - 145)))
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeCantBuild = SoraDGetChildByName(self, "Node_cantBuild")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelColdTitle = SoraDGetChildByName(self, "Text_coldTitle")
	self.labelColdTime = SoraDGetChildByName(self, "Text_coldTime")
	self.nodeBuild = SoraDGetChildByName(self, "Node_build")
	self.labelStaminaTitle = SoraDGetChildByName(self, "Text_staminaTitle")
	self.labelStamina = SoraDGetChildByName(self, "Text_stamina")
	self.nodeFire = SoraDGetChildByName(self, "Node_fire")
	self.nodeStaminaChange = SoraDGetChildByName(self, "Node_staminaChange")
	self.labelFireTitle = SoraDGetChildByName(self, "Text_fireTitle")
	self.labelFireTime = SoraDGetChildByName(self, "Text_fireTime")
	self.labelFirePerTime = SoraDGetChildByName(self, "Text_firePerTime")
	self.labelRecoverPerTime = SoraDGetChildByName(self, "Text_recoverPerTime")
	self.labelNoticeFire = SoraDGetChildByName(self, "Text_noticeFire")
	self.labelNoticeRank = SoraDGetChildByName(self, "Text_noticeRank")
	self.btnPoint = SoraDGetChildByName(self, "Button_point")
	self.btnPoint:setTouchEnabled(allianceDesRead.checkRank(gAllianceRank.R4))
	self.btnPoint:setBright(allianceDesRead.checkRank(gAllianceRank.R4))
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.btnGold = SoraDGetChildByName(self, "Button_gold")
	self.labelGold = SoraDGetChildByName(self, "Text_gold")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.imgBuild = SoraDGetChildByName(self, "Image_build")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeFlag:setVisible(false)
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnRecycle = SoraDGetChildByName(self, "Button_recycle")
	self.btnGold:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnPoint:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnRecycle:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.labelFireTitle:setString(i18n("common_text_398"))
	self.labelStaminaTitle:setString(i18n("common_text_2996"))
	self.labelNotice:setString(i18n("common_text_2992"))
	self.btnRecycle:setTitleText(i18n("common_text_2993"))
	_ENV = i18n("common_text_2993")
	i18n("common_text_2993").rank = "R4"
	self.labelNoticeRank:setString(i18n("common_text_3011", i18n("common_text_2993")))
	self.labelNoticeFire:setString(i18n("common_text_3001"))
	self.labelColdTitle:setString(i18n("common_text_3000"))
	self.labelColdTime:setPositionX(self.labelColdTitle:getPositionX() - SoraDFSign(self.labelColdTitle:getContentSize().width + 10))
end
function AllianceBuildMainInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", function(target, data)
		if self.tableSingleData and data.bid == self.tableSingleData.bid then
			self:initData(self.tableSingleData)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_DESTROY", handler(self, self.judgeCloseView))
end
function AllianceBuildMainInfoView:judgeCloseView(target, data)
	if data.id == self.tableSingleData.id then
		self:removeFromParent()
	end
end
function AllianceBuildMainInfoView:initData(data)
	self.tableSingleData = data
	if self.tableSingleData.update then
		self.tableSingleData:update()
	end
	self.curState = self.tableSingleData.status
	self:hiddleAll()
	if self.curState == gAllianceBuildingStatus.NONE or self.curState == gAllianceBuildingStatus.DESTROY then
		self:showBuild()
	else
		self:showNoraml()
	end
	self.nodeTitle:setTitle(allianceDesRead.getBuildName(self.tableSingleData.bid))
	self.labelDes:setString(allianceDesRead.getBuildDes(self.tableSingleData.bid))
	self.nodeFlag:removeAllChildren()
	self.imgBuild:loadTexture(allianceDesRead.getBuildIcon(self.tableSingleData.bid), ccui.TextureResType.plistType)
	if self.tableSingleData.bid == gAllianceBuilding.FLAG then
		self.nodeFlag:setVisible(true)
		allianceDesRead.getFlagWithParticle(nil, self.nodeFlag)
	end
	self.btnHelp:setVisible(gAllianceBuilding.PRIMARY_PALACE ~= self.tableSingleData.bid)
	_ENV = allianceDesRead.getBuildDes(self.tableSingleData.bid)
	allianceDesRead.getBuildDes(self.tableSingleData.bid).member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
	allianceDesRead.getBuildDes(self.tableSingleData.bid).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
	self.labelStamina:setString(i18n("common_text_155", allianceDesRead.getBuildDes(self.tableSingleData.bid)))
end
function AllianceBuildMainInfoView:hiddleAll()
	self.nodeCantBuild:setVisible(false)
	self.labelColdTitle:setVisible(false)
	self.labelColdTime:setVisible(false)
	self.nodeBuild:setVisible(false)
	self.nodeStaminaChange:setVisible(false)
	self.nodeFire:setVisible(false)
	self.labelRecoverPerTime:setVisible(false)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function AllianceBuildMainInfoView:showBuild()
	self.nodeCantBuild:setVisible(true)
	if gAllianceBuilding.ALTAR ~= self.tableSingleData.bid and self.curState == gAllianceBuildingStatus.DESTROY then
		_ENV = nil
		;(nil).member = self.tableSingleData.currentHP
		;(nil).total = self.tableSingleData.HPMax or self.tableSingleData.HP
		self.labelNotice:setString(i18n("common_text_2992") .. " " .. i18n("common_text_155", nil))
		self.btnRecycle:setVisible(true)
	else
		self.labelNotice:setString(i18n("common_text_2992"))
		self.btnRecycle:setVisible(false)
	end
	if self.curState == gAllianceBuildingStatus.DESTROY and self.timer == nil and self.tableSingleData.remainCDTime > 0 then
		self.labelColdTitle:setVisible(true)
		self.labelColdTime:setVisible(true)
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
	self.btnRecycle:setTouchEnabled(false)
	self.btnRecycle:setBright(false)
end
function AllianceBuildMainInfoView:showNoraml()
	if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
		self.nodeBuild:setVisible(false)
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownRank = memberMgr:getOwnMember():getProperty("rank")
		if not allianceBuildingltCtrl:canRankMemberDestory(self.tableSingleData.bid, ownRank) then
			self.btnRecycle:setVisible(false)
		else
			self.btnRecycle:setVisible(true)
		end
	else
		self.nodeBuild:setVisible(true)
	end
	self.btnRecycle:setTouchEnabled(self.curState ~= gAllianceBuildingStatus.BURNING or self.tableSingleData.bid ~= gAllianceBuilding.PALACE)
	self.btnRecycle:setBright(self.curState ~= gAllianceBuildingStatus.BURNING or self.tableSingleData.bid ~= gAllianceBuilding.PALACE)
	if self.curState == gAllianceBuildingStatus.BURNING or self.curState == gAllianceBuildingStatus.RECOVERING then
		self.nodeStaminaChange:setVisible(true)
		if self.curState == gAllianceBuildingStatus.BURNING then
			self.nodeFire:setVisible(true)
			self.labelFirePerTime:setString(tostring(-self.tableSingleData.burningSpeed) .. "/h")
		else
			self.labelRecoverPerTime:setVisible(true)
			self.labelRecoverPerTime:setString(tostring(self.tableSingleData.recoverSpeed) .. "/h")
		end
		self.labelPoint:setString(string.formatnumberthousands(allianceTerritoryAPI:getRestoreBonus()))
		self.labelGold:setString(string.formatnumberthousands(allianceTerritoryAPI:getRestoreGold()))
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
			self:openTimeUp()
		end
	end
end
function AllianceBuildMainInfoView:openTimeUp()
	if self.tableSingleData.update then
		self.tableSingleData:update()
	end
	if self.curState ~= self.tableSingleData.status then
		self:initData(self.tableSingleData)
	elseif self.curState == gAllianceBuildingStatus.BURNING then
		self.labelFireTime:setString(SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))
		_ENV = SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)
		SoraDConvertSecondToString(self.tableSingleData.remainBurningTime).member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
		SoraDConvertSecondToString(self.tableSingleData.remainBurningTime).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.labelStamina:setString(i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)))
	elseif self.curState == gAllianceBuildingStatus.RECOVERING then
		_ENV = i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))
		i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)).member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
		i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.labelStamina:setString(i18n("common_text_155", i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))))
	elseif self.curState == gAllianceBuildingStatus.DESTROY then
		self.labelColdTime:setString(SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
		if self.tableSingleData.remainCDTime <= 0 then
			self:initData(self.tableSingleData)
		end
	end
end
function AllianceBuildMainInfoView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnGold then
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			local jointime = memberMgr:getOwnMember():getProperty("joinTime")
			local curtime = serviceFunctions.systemTime()
			local needtime = TIME_LIMITED_24_HOURS * 3600
			if needtime > curtime - jointime then
				_ENV = nil
				;(nil).h = TIME_LIMITED_24_HOURS
				SoraDShowMsgTip(i18n("common_text_3027", nil))
			else
				local str = self.curState == gAllianceBuildingStatus.RECOVERING and "common_text_3029" or "common_text_3028"
				_ENV = i18n("common_text_3027", nil)
				_ENV, i18n("common_text_3027", nil).msgKey = i18n("common_text_3027", nil)
				i18n("common_text_3027", nil).name = i18n("common_text_020")
				i18n("common_text_3027", nil).msgParams, i18n("common_text_3027", nil).count = i18n("common_text_3027", nil)
				i18n("common_text_3027", nil).gold = allianceTerritoryAPI:getRestoreGold()
				i18n("common_text_3027", nil).title = i18n("common_text_204")
				i18n("common_text_3027", nil).handle = function(callback)
					if callback == MSGBOX_CALLBACK_YES then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.GOLD)
					end
				end
				SoraDShowBuyBoxNew(i18n("common_text_3027", nil))
			end
		elseif button == self.btnPoint then
			local havePoint = allianceMgr:getAllianceProperty("bonus")
			if havePoint < allianceTerritoryAPI:getRestoreBonus() then
				SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						SoraDCreatePanel("allianceScienceView"):show()
					end
				end)
			else
				local str = self.curState == gAllianceBuildingStatus.RECOVERING and "common_text_3029" or "common_text_3028"
				_ENV = i18n("common_text_1684")
				_ENV, i18n("common_text_1684").msgKey = nil, str
				;(nil).name = i18n("common_text_032")
				i18n("common_text_1684").msgParams, (nil).count = nil, string.formatnumberthousands(allianceTerritoryAPI:getRestoreBonus())
				i18n("common_text_1684").gold = allianceTerritoryAPI:getRestoreBonus()
				i18n("common_text_1684").title = i18n("common_text_204")
				_ENV, i18n("common_text_1684").handle = function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end, function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end
				;(function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end).isNeedJudge = false
				;(function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end).width = 40
				i18n("common_text_1684").parameter, (function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end).icon = function(callback)
					if callback == MSGBOX_CALLBACK_YES and self.tableSingleData then
						allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
					end
				end, "icon_alliance_point.png"
				SoraDShowBuyBoxNew((i18n("common_text_1684")))
			end
		elseif button == self.btnRecycle then
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			local ownRank = memberMgr:getOwnMember():getProperty("rank")
			if not allianceBuildingltCtrl:canRankMemberDestory(self.tableSingleData.bid, ownRank) then
				if self.tableSingleData.bid == gAllianceBuilding.PALACE then
					_ENV = ownRank
					ownRank.name = i18n("common_text_526")
					ownRank.build = allianceDesRead.getBuildName(self.tableSingleData.bid)
					SoraDShowMsgTip(i18n("common_text_2997", ownRank))
				else
					SoraDShowMsgTip(i18n("notice_0073"))
				end
			else
				local msg = ""
				local isMainBuild = allianceBuildingltCtrl:isMainBuilding(self.tableSingleData.bid)
				if isMainBuild then
					if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
						msg = i18n("alliance_beast_notice_01")
					elseif (gAllianceBuilding.PALACE == self.tableSingleData.bid or gAllianceBuilding.PRIMARY_PALACE == self.tableSingleData.bid) and self.tableSingleData.status == gAllianceBuildingStatus.BUILDING then
						msg = i18n("alliance_stronghold_text_091")
					else
						_ENV = i18n("notice_0073")
						i18n("notice_0073").h = TIME_LIMITED_4_HOURS
						msg = i18n("common_text_2998", i18n("notice_0073"))
					end
				else
					msg = i18n("common_text_3026")
				end
				SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(callBack)
					if callBack == MSGBOX_CALLBACK_YES then
						if not self.__cname then
							return
						end
						if self.curState == gAllianceBuildingStatus.BURNING and self.tableSingleData.bid == gAllianceBuilding.PALACE then
							SoraDShowMsgTip(i18n("common_text_3106"))
						else
							allianceTerritoryAPI:demolishAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid)
							self:removeFromParent()
						end
					end
				end)
			end
		elseif button == self.btnHelp then
			if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR)
			else
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_BUILD)
			end
		end
	end
end
return AllianceBuildMainInfoView
