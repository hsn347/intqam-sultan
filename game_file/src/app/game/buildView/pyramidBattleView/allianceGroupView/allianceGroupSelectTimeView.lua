local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local AllianceGroupSelectTimeView = class("allianceGroupSelectTimeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceGroupSelectTimeView")
	end
	return target
end)
function AllianceGroupSelectTimeView:ctor()
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self.curLegionInfo = pyramidWarCtrl:getOwnLegion()
	self.curTab = 1
	if self.curLegionInfo then
		self.curTab = self.curLegionInfo.legionIndex
	end
	if pyramidWarCtrl:getGroupManagerRank() >= 2 then
		for i, v in ipairs(self.legionInfoList) do
			if v.number == 0 then
				self.curTab = v.legionIndex
				break
			end
		end
	end
	self.timeList = pyramidWarltCtrl.getMatchtimeList()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidBattleHistory")
	self.nodeTitle:setTitle(i18n("common_text_2517"))
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.imgBar = SoraDGetChildByName(self, "Image_bar")
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelEmpty = SoraDGetChildByName(self, "Center_Text_Empty")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node_panel")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.spriteLDog = SoraDGetChildByName(self, "Sprite_lDog")
	self.spriteRDog = SoraDGetChildByName(self, "Sprite_rDog")
	self.imgRBottomBg = SoraDGetChildByName(self, "Image_rBottomBg")
	self.imgLBottomBg = SoraDGetChildByName(self, "Image_lBottomBg")
	self.labelBottom = SoraDGetChildByName(self, "Text_bottom")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.nodeClone.labelNum = SoraDGetChildByName(self, "Text_num")
	self.labelDes:setString(i18n("common_text_3324"))
	self.labelBottom:setString(i18n("common_text_3325"))
	self.labelEmpty:setString(i18n("common_text_3254"))
	self.labelEmpty:setVisible(false)
	self:initTab()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
	include("allianceDesRead").getFlagWithParticle(nil, self.nodeFlag)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_APPLYTIMEBACK", handler(self, self.initTimeList))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_APPLY_BACK", handler(self, self.updateView))
	self.selectAction = SoraDCreatAnimationEx(self.__cname, self, true, 0.5).action
end
function AllianceGroupSelectTimeView:openTimeUp()
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(gRegularSeasonState.APPLY_ING)
	if nowTimeLeft and 0 <= nowTimeLeft then
		pyramidWarCtrl = nil
		;(nil).time = SoraDConvertSecondToString(nowTimeLeft)
		self.labelTime:setString(i18n("common_text_3305", nil))
	else
		pyramidWarCtrl = i18n("common_text_3305", nil)
		i18n("common_text_3305", nil).time = SoraDConvertSecondToString(0)
		self.labelTime:setString(i18n("common_text_3305", i18n("common_text_3305", nil)))
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function AllianceGroupSelectTimeView:createSingle()
	local ocx = self.nodeClone:clone()
	ocx.btnFlag = SoraDGetChildByName(ocx, "Button_flag")
	ocx.btnFlag:setTouchEnabled(false)
	ocx.btnFlag:setBright(true)
	ocx.btnSelect = SoraDGetChildByName(ocx, "Button_select")
	ocx.btnSelect:setTitleText(i18n("common_text_3315"))
	ocx.btnSelect:addTouchEventListener(handler(self, self.btnSelectClickCallBack))
	ocx.nodeGroup = SoraDGetChildByName(ocx, "Node_group")
	ocx.spriteFlag = SoraDGetChildByName(ocx, "Sprite_flag")
	ocx.labelTime = SoraDGetChildByName(ocx, "Text_time")
	ocx.labelNum = SoraDGetChildByName(ocx, "Text_num")
	ocx.labelIndex = SoraDGetChildByName(ocx, "Text_index")
	ocx.labelState = SoraDGetChildByName(ocx, "Text_state")
	ocx.effect1 = SoraDGetChildByName(ocx, "Node_effect_1")
	ocx.effect2 = SoraDGetChildByName(ocx, "Node_effect_2")
	ocx.effect1:setVisible(false)
	ocx.effect2:setVisible(false)
	return ocx
end
function AllianceGroupSelectTimeView:refreshSingle(single, data, otherData)
	single.btnSelect:setTag(data.number)
	_ENV = nil
	;(nil).num = data.member
	single.labelNum:setString(i18n("common_text_3327", nil))
	if data.member >= self.totalMember then
		single.btnSelect:setVisible(false)
		single.labelNum:setColor(display.COLOR_RED)
		single.labelState:setVisible(true)
		single.labelState:setColor(cc.c3b(120, 120, 120))
		single.labelState:setString(i18n("pyramid_text_102"))
	else
		single.btnSelect:setTouchEnabled(pyramidWarCtrl:getGroupManagerRankEX(data.legionIndex) > 0)
		single.btnSelect:setVisible(true)
		single.labelNum:setColor(self.nodeClone.labelNum:getColor())
		single.labelState:setVisible(false)
	end
	single.labelIndex:setString(data.number)
	single.labelTime:setString(pyramidWarltCtrl.getWeedTimeStr(data.number, true, "\n"))
	single.effect1:setVisible(false)
	single.effect2:setVisible(false)
	if 0 < self.curLegionInfo.number then
		if self.curLegionInfo.number == data.number then
			single.labelState:setVisible(true)
			single.labelState:setColor(single.labelTime:getColor())
			single.labelState:setString(i18n("pyramid_text_66"))
			single.btnSelect:setVisible(false)
			single.effect1:setVisible(true)
			single.effect2:setVisible(true)
			SoraDMixtureGLONEByParent(single.effect1)
			SoraDMixtureGLONEByParent(single.effect2)
			single:stopAllActions()
			single:runAction(self.selectAction)
		else
			single.btnSelect:setVisible(false)
		end
	end
end
function AllianceGroupSelectTimeView:initTimeList(target, redata)
	for i, v in ipairs(self.timeList) do
		if redata.info.retdata[tostring(v.number)] then
			self.timeList[i].member = redata.info.retdata[tostring(v.number)]
		end
	end
	self.totalMember = pyramidWarCtrl:getRegularSeasonApplyMaxAllianceNum()
	self:updateTimeList()
	SoraDCloseLoading(self)
end
function AllianceGroupSelectTimeView:btnSelectClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local number = button:getTag()
		if self.timeList[number].type == 2 and pyramidWarCtrl.pinnacleSeasonState >= gPinnacleSeasonState.APPLY_ING_A and pyramidWarCtrl.pinnacleSeasonState ~= gPinnacleSeasonState.FINISH then
			SoraDShowMsgTip(i18n("pyramid_tips_05"))
			return
		end
		SoraDShowMsgBox(i18n("common_text_3694"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				pyramidWarCtrl:newRegularSeasonApplyReq(self.curLegionInfo.legionId, number)
				SoraDShowLoading(self)
			end
		end)
	end
end
function AllianceGroupSelectTimeView:updateTimeList()
	if self.timeList then
		if pyramidWarCtrl:isCanApplyByAid(self.curLegionInfo.legionId) then
			self.scroll:setVisible(true)
			pyramidWarCtrl = nil
			;(nil).isAR = SoraDFIsRA()
			self.scroll:updateScrollView(cc.size(213.3, 275), self.timeList, 3, nil)
			self.labelEmpty:setVisible(false)
			self.labelDes:setVisible(true)
		else
			self.labelEmpty:setVisible(true)
			self.labelDes:setVisible(false)
			self.scroll:setVisible(false)
		end
	end
end
function AllianceGroupSelectTimeView:initTab()
	_ENV, _ENV = nil, nil
	;(nil).title = ""
	_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	_ENV, (nil)[2], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	_ENV, (nil)[3], (nil).handle = nil, nil, handler(self, self.OnBtnChangeClick)
	;(nil).title = ""
	;(nil)[4], (nil).handle = nil, handler(self, self.OnBtnChangeClick)
	local tabData
	for i = 1, 4 do
		if self.legionInfoList[i] then
			tabData[i].title = self.legionInfoList[i].legionName
		end
	end
	_ENV = 1
	;(1).tabNum = 4
	;(1).defaultClick = self.curTab
	;(1).tabsetArray = tabData
	self.nodeTab:initView(1)
	for i = 1, 4 do
		if self.legionInfoList[i] == nil then
			self.nodeTab:setBtnTouchEnabled(i, false)
			self.nodeTab:setOtherSprite(i, "icon_lordskill_lock.png")
		end
	end
end
function AllianceGroupSelectTimeView:updateTab()
	if pyramidWarCtrl:getGroupManagerRank() >= 2 then
		for i, v in ipairs(self.legionInfoList) do
			self.nodeTab:setRedPointState(v.legionIndex, v.number == 0 and pyramidWarCtrl:isCanApplyByAid(v.legionId))
		end
	end
end
function AllianceGroupSelectTimeView:OnBtnChangeClick(tag, name)
	self.curTab = tag
	self:updateView()
end
function AllianceGroupSelectTimeView:initGroupInfo()
	self.labelName:setString(self.curLegionInfo.legionName)
	_ENV = nil
	;(nil).cur = table.nums(self.curLegionInfo.memberList)
	;(nil).max = ALLIANCE_GROUP_MEMBER_MAX
	self.labelMember:setString(i18n("common_text_3408", nil))
	_ENV = i18n("common_text_3408", nil)
	i18n("common_text_3408", nil).num = string.formatnumberthousands(self.curLegionInfo.battleFighting)
	self.labelPower:setString(i18n("pyramid_text_25", i18n("common_text_3408", nil)))
end
function AllianceGroupSelectTimeView:updateView()
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self.curLegionInfo = self.legionInfoList[self.curTab]
	self:initGroupInfo()
	SoraDCloseLoading(self)
	pyramidWarCtrl:regularSeasonGetApplyInfoReq()
	SoraDShowLoading(self)
	self:updateTab()
end
return AllianceGroupSelectTimeView
