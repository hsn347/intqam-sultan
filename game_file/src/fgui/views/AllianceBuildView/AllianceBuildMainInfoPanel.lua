local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildMainInfoPanel = class("AllianceBuildMainInfoPanel", baseFguiPanel)
function AllianceBuildMainInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceBuildMainInfoPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.curState = gAllianceBuildingStatus.NONE
end
function AllianceBuildMainInfoPanel:onInit()
	print("=======AllianceBuildMainInfoPanel:onInit")
	self.fields.Com_title:setCloseCallback(handler(self, self.onClickClose))
	self.fields.Button_point:setBright(allianceDesRead.checkRank(gAllianceRank.R4))
	self.fields.Text_fireTitle:setString(i18n("common_text_398"))
	self.fields.Text_staminaTitle:setString(i18n("common_text_2996"))
	self.fields.Text_notice:setString(i18n("common_text_2992"))
	self.fields.Button_recycle:setString(i18n("common_text_2993"))
	_ENV = i18n("common_text_2993")
	i18n("common_text_2993").rank = "R4"
	self.fields.Text_noticeRank:setString(i18n("common_text_3011", i18n("common_text_2993")))
	self.fields.Text_noticeFire:setString(i18n("common_text_3001"))
	self.fields.Text_coldTitle:setString(i18n("common_text_3000"))
	self.fields.Button_gold:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.Button_point:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.Button_recycle:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.Button_help:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.fields.Button_gold:setItemID(gIDDef.GOLD)
	self.fields.Button_point:setItemID(gIDDef.ALLIANCE_SCORE)
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function AllianceBuildMainInfoPanel:onShow()
	print("=======AllianceBuildMainInfoPanel:onShow")
	local data = self.param and self.param.data
	if data then
		self:initData(data)
	end
end
function AllianceBuildMainInfoPanel:initData(data)
	dump(data, "==AllianceBuildMainInfoPanel:initData==")
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
	self.fields.Com_title:setTitle(allianceDesRead.getBuildName(self.tableSingleData.bid))
	self.fields.Text_des:setString(allianceDesRead.getBuildDes(self.tableSingleData.bid))
	if self.nodeFlag then
		self.nodeFlag:removeFromParent()
	end
	self.fields.Image_build:setURL(allianceDesRead.getBuildIcon(self.tableSingleData.bid))
	if self.tableSingleData.bid == gAllianceBuilding.FLAG then
		local nodeFlag = allianceDesRead.getFlagNode()
		nodeFlag:addTo(self.fields.Node_flag:displayObject())
		self.nodeFlag = nodeFlag
	end
	self.fields.Button_help:setVisible(gAllianceBuilding.PRIMARY_PALACE ~= self.tableSingleData.bid)
	_ENV = self.fields.Node_flag:displayObject()
	self.fields.Node_flag:displayObject().member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
	self.fields.Node_flag:displayObject().total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
	self.fields.Text_stamina:setString(i18n("common_text_155", self.fields.Node_flag:displayObject()))
end
function AllianceBuildMainInfoPanel:hiddleAll()
	self.fields.Node_cantBuild:setVisible(false)
	self.fields.Text_coldTitle:setVisible(false)
	self.fields.Text_coldTime:setVisible(false)
	self.fields.Node_build:setVisible(false)
	self.fields.Node_staminaChange:setVisible(false)
	self.fields.Node_fire:setVisible(false)
	self.fields.Text_recoverPerTime:setVisible(false)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function AllianceBuildMainInfoPanel:showBuild()
	self.fields.Node_cantBuild:setVisible(true)
	if gAllianceBuilding.ALTAR ~= self.tableSingleData.bid and self.curState == gAllianceBuildingStatus.DESTROY then
		_ENV = nil
		;(nil).member = self.tableSingleData.currentHP
		;(nil).total = self.tableSingleData.HPMax or self.tableSingleData.HP
		self.fields.Text_notice:setString(i18n("common_text_2992") .. " " .. i18n("common_text_155", nil))
		self.fields.Button_recycle:setVisible(true)
	else
		self.fields.Text_notice:setString(i18n("common_text_2992"))
		self.fields.Button_recycle:setVisible(false)
	end
	if self.curState == gAllianceBuildingStatus.DESTROY and self.timer == nil and self.tableSingleData.remainCDTime > 0 then
		self.fields.Text_coldTitle:setVisible(true)
		self.fields.Text_coldTime:setVisible(true)
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
	self.fields.Button_recycle:setEnabled(false)
end
function AllianceBuildMainInfoPanel:showNoraml()
	if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
		self.fields.Node_build:setVisible(false)
		local ownRank = memberMgr:getOwnMember():getProperty("rank")
		if not allianceBuildingltCtrl:canRankMemberDestory(self.tableSingleData.bid, ownRank) then
			self.fields.Button_recycle:setVisible(false)
		else
			self.fields.Button_recycle:setVisible(true)
		end
	else
		self.fields.Node_build:setVisible(true)
	end
	self.fields.Button_recycle:setEnabled(self.curState ~= gAllianceBuildingStatus.BURNING or self.tableSingleData.bid ~= gAllianceBuilding.PALACE)
	if self.curState == gAllianceBuildingStatus.BURNING or self.curState == gAllianceBuildingStatus.RECOVERING then
		self.fields.Node_staminaChange:setVisible(true)
		if self.curState == gAllianceBuildingStatus.BURNING then
			self.fields.Node_fire:setVisible(true)
			self.fields.Text_firePerTime:setString(tostring(-self.tableSingleData.burningSpeed) .. "/h")
		else
			self.fields.Text_recoverPerTime:setVisible(true)
			self.fields.Text_recoverPerTime:setString(tostring(self.tableSingleData.recoverSpeed) .. "/h")
		end
		self.fields.Button_point:setTitleGold(string.formatnumberthousands(allianceTerritoryAPI:getRestoreBonus()))
		self.fields.Button_gold:setTitleGold(string.formatnumberthousands(allianceTerritoryAPI:getRestoreGold()))
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
			self:openTimeUp()
		end
	end
end
function AllianceBuildMainInfoPanel:openTimeUp()
	if self.tableSingleData.update then
		self.tableSingleData:update()
	end
	if self.curState ~= self.tableSingleData.status then
		self:initData(self.tableSingleData)
	elseif self.curState == gAllianceBuildingStatus.BURNING then
		self.fields.Text_fireTime:setString(SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))
		_ENV = SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)
		SoraDConvertSecondToString(self.tableSingleData.remainBurningTime).member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
		SoraDConvertSecondToString(self.tableSingleData.remainBurningTime).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.fields.Text_stamina:setString(i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)))
	elseif self.curState == gAllianceBuildingStatus.RECOVERING then
		_ENV = i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))
		i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)).member = string.formatnumberthousands(self.tableSingleData.currentHP or self.tableSingleData.HP)
		i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime)).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.fields.Text_stamina:setString(i18n("common_text_155", i18n("common_text_155", SoraDConvertSecondToString(self.tableSingleData.remainBurningTime))))
	elseif self.curState == gAllianceBuildingStatus.DESTROY then
		self.fields.Text_coldTime:setString(SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
		if self.tableSingleData.remainCDTime <= 0 then
			self:initData(self.tableSingleData)
		end
	end
end
function AllianceBuildMainInfoPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	if button == self.fields.Button_gold then
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
	elseif button == self.fields.Button_point then
		local havePoint = allianceMgr:getAllianceProperty("bonus")
		if havePoint < allianceTerritoryAPI:getRestoreBonus() then
			SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					if GLOBAL_GAME_ALLIANCE_MODE then
						uiManager:show("AllianceScience")
					else
						SoraDCreatePanel("allianceScienceView"):show()
					end
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
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end, function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end
			;(function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end).isNeedJudge = false
			;(function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end).width = 40
			i18n("common_text_1684").parameter, (function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end).icon = function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					allianceTerritoryAPI:restoreAllianceBuilding(self.tableSingleData.id, self.tableSingleData.bid, gAllianceBuildingRestoreCostType.BONUS)
				end
			end, "icon_alliance_point.png"
			SoraDShowBuyBoxNew((i18n("common_text_1684")))
		end
	elseif button == self.fields.Button_recycle then
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
	elseif button == self.fields.Button_help then
		if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_BUILD)
		end
	end
end
function AllianceBuildMainInfoPanel:initTestData(...)
	_ENV = nil
	;(nil).HPMax = 7200
	_ENV, (nil).bid = gAllianceBuilding.PALACE, gAllianceBuilding.PALACE
	gAllianceBuilding.PALACE.buildFinishTime = 1697075512
	gAllianceBuilding.PALACE.buildSpeed = 2166.27
	gAllianceBuilding.PALACE.buildSpeedTime = 1697075507
	gAllianceBuilding.PALACE.buildStartTime = 1697075487
	gAllianceBuilding.PALACE.surplusPoint = 0
	;(nil).buildingData, gAllianceBuilding.PALACE.totalPoint = gAllianceBuilding.PALACE, 10000
	;(nil).burningSpeed = 0
	;(nil).currentHP = 7200
	_ENV, (nil).id = gAllianceBuilding.PALACE, "1_66_613"
	gAllianceBuilding.PALACE.x = 65
	;(nil).pos, gAllianceBuilding.PALACE.y = gAllianceBuilding.PALACE, 612
	;(nil).recoverSpeed = 20
	;(nil).remainBurningTime = 0
	;(nil).remainCDTime = 0
	local (nil).status, data = 1, nil
	local data6 = clone(data)
	data6.bid = 6
	local data8 = clone(data)
	_ENV, data8.bid = data, 8
	data.HPMax = 7200
	data.bid = 9
	data.currentHP = 7200
	data.remainCDTime = 0
	local data.status, data9 = 4, data
	self:initData(data6)
end
return AllianceBuildMainInfoPanel
