local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local alliancePBLMatchView = class("alliancePBLMatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLMatchView")
	end
	return target
end)
function alliancePBLMatchView:ctor()
	TopNodeBar = SoraDGetChildByName(self, "Top_Node_bar")
	self.nodeOut = SoraDGetChildByName(self, "Node_out")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	_ENV = nil
	;(nil).num = pyramidWarCtrl.peakSeasonNo
	self.nodeTitle:setTitle(i18n("pyramid_text_47", nil))
	self.nodePBLIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_alliancePBLBigIconNode_pbl")
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.btnVideo = SoraDGetChildByName(self, "Button_video")
	self.btnVideo:setVisible(false)
	BottomNodeButtons = SoraDGetChildByName(self, "Bottom_Node_buttons")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.spriteBottomLine0 = SoraDGetChildByName(self, "Sprite_bottom_line_0")
	self.spriteRDog = SoraDGetChildByName(self, "Sprite_rDog")
	self.spriteLDog = SoraDGetChildByName(self, "Sprite_lDog")
	CenterNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeSelList = SoraDGetChildByName(self, "Node_SelList")
	self.dropDownBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonDropDownBox_sel")
	self.dropDownBox:setDir(0)
	self.dropDownBox:setIsCustom(true)
	_ENV = self.dropDownBox.setIsCustom
	self.dropDownBox.setIsCustom.scrollOffsetY = -5
	_UPVALUE4_, self.dropDownBox.setIsCustom.borderOffsetY = self.dropDownBox, 30
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[1] = self.dropDownBox, 15
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[2] = self.dropDownBox, 20
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[3] = self.dropDownBox, 15
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[4] = self.dropDownBox, 5
	local customParam = self.dropDownBox.setIsCustom
	self.dropDownBox:setCustomParam(customParam)
	self.dropDownBox:setOffset(cc.p(-72, -5))
	self.dropDownBox:setSelectSingleTarget("Image_select")
	self.dropDownBox:setTouchClose()
	_ENV = "Image_select"
	;("Image_select").maxHeight = 250
	_ENV, pyramidWarCtrl, ("Image_select").childSize = 300, cc.size(300, 42), cc.size(300, 42)
	;(300).title = "test"
	;(300).tag = 1
	;("Image_select").childData, cc.size(300, 42)[1] = cc.size(300, 42), 300
	self.dropDownBox:initData("Image_select")
	self.dropDownBox:addEventListener(handler(self, self.onSelDropDownBox))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.labelTitle = SoraDGetChildByName(self.nodeTime, "Text_title")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.btnDraw = SoraDGetChildByName(self, "Button_draw")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeBlock = SoraDGetChildByName(self, "Node_block")
	self.labelBlock1 = SoraDGetChildByName(self, "Text_block_1")
	self.labelBlock2 = SoraDGetChildByName(self, "Text_block_2")
	self.labelWait = SoraDGetChildByName(self, "Text_wait")
	self.Text_finalIns = SoraDGetChildByName(self, "Text_finalIns")
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeRound = SoraDGetChildByName(self, "Node_round")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.Text_finalIns:setString(i18n("pyramid_tips_16"))
	SoraDChangeTextToHtml(self.labelNum)
	_ENV, _ENV, _ENV = i18n("pyramid_tips_16")
	i18n("pyramid_tips_16").__default, i18n("pyramid_tips_16").u = i18n("pyramid_tips_16")
	self.labelNum:setString(i18n_html("pyramid_text_81", i18n("pyramid_tips_16")))
	self.labelNum:setTouchEnabled(true)
	self.labelNum:addTouchEventListener(handler(self, self.btnClickText))
	self.centerNodeMatch = SoraDGetChildByName(self, "Center_Node_match")
	self.centerNodeBg = SoraDGetChildByName(self, "Center_Node_bg")
	self.nodeUp = SoraDGetChildByName(self, "Node_up")
	self.nodeDown = SoraDGetChildByName(self, "Node_down")
	self.nodeSelList:setVisible(false)
	self.labelBlock1:setString(i18n("pyramid_text_39"))
	_ENV = i18n("pyramid_text_39")
	i18n("pyramid_text_39").time = ""
	self.labelTitle:setString(i18n("pyramid_text_52", i18n("pyramid_text_39")))
	self.labelDes:setString(i18n("pyramid_text_54"))
	SoraDSetTextWidthHeight(self.Text_finalIns, cc.size(600, 60))
	self.Text_finalIns:setPositionY(self.labelBlock1:getPositionY())
	self.matchData = pyramidWarCtrl.battleResult
	self:initLine()
	self:initMatchSingle()
	self:hiddleLine()
	self:initView()
	if self.btnDraw then
		self.btnDraw:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnVideo:addTouchEventListener(handler(self, self.btnVideoCallBack))
	end
	SoraDTestButton(self, function(...)
		self.nodeSelList:setVisible(true)
	end)
	pyramidWarCtrl:getWatchList()
	SoraDCreatAnimationEx(self.__cname, self, true)
	for i = 1, 4 do
		local particle = SoraDGetChildByName(self, "Particle_out_" .. i)
		if particle then
			particle:setAutoCull(false)
		end
	end
	if display.height < 1195 then
		local scale = (display.height - 45 - 110) / 1040
		self.centerNodeMatch:setScale(scale)
		self.centerNodeMatch:setPositionY(scale * 605 + 45)
		self.centerNodeBg:setPositionY(scale * 605 + 45)
	elseif self.centerNodeMatch:getPositionY() < 650 then
		self.centerNodeMatch:setPositionY(650)
		self.centerNodeBg:setPositionY(650)
	end
end
function alliancePBLMatchView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDPOSTSEASON_WATCHLIST", handler(self, self.refreshBtnLook))
end
function alliancePBLMatchView:onSelDropDownBox(tag)
	print("选择了---------", tag)
	self.curlegion = self.legionList[tag]
	self:updateView()
end
function alliancePBLMatchView:initView()
	self.groupType = gPinnacleSeasonAllianceState.NOT_APPLY
	self.seasonState = pyramidWarCtrl.pinnacleSeasonState
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.ownlegion = pyramidWarCtrl:getOwnLegion()
	self.curlegion = self.ownlegion
	self.curMatchType = pyramidWarCtrl.curMatchType
	self:publicView()
	self:updateView()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	SoraDCloseLoading(self)
end
function alliancePBLMatchView:openTimeUp()
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(pyramidWarCtrl.pinnacleSeasonState)
	if nowTimeLeft and 0 <= nowTimeLeft then
		self.labelTime:setString(SoraDConvertSecondToString(nowTimeLeft))
	end
	if self.ownlegion and self.ownlegion.pinnacleCompetitionGroup == 1 then
		local groupType = self.ownlegion.pinnacleSeasonAllianceState
		local data = self.ownlegion.queue[tostring(groupType)]
		local leftTime = 0
		if data then
			leftTime = data.starttime + data.totaltime - serviceFunctions.systemTime()
		end
		if groupType == gPinnacleSeasonAllianceState.PREPARE then
			self.labelTime:setString(SoraDConvertSecondToString(leftTime))
			pyramidWarCtrl = SoraDConvertSecondToString(leftTime)
			SoraDConvertSecondToString(leftTime).time = ""
			self.labelTitle:setString(i18n("common_text_3308", SoraDConvertSecondToString(leftTime)))
			self.nodeTime:setVisible(true)
		elseif groupType == gPinnacleSeasonAllianceState.RUNNING then
			self.labelTime:setString(SoraDConvertSecondToString(leftTime))
			pyramidWarCtrl = SoraDConvertSecondToString(leftTime)
			SoraDConvertSecondToString(leftTime).time = ""
			self.labelTitle:setString(i18n("common_text_3309", SoraDConvertSecondToString(leftTime)))
			self.nodeTime:setVisible(true)
		else
			self.nodeTime:setVisible(self.nodeSelList:isVisible())
		end
	end
end
function alliancePBLMatchView:publicView()
	local pyramidWarCtrl, dropData
	local pyramidWarCtrl, already
	local index
	local ownRank = pyramidWarCtrl:getGroupManagerRank()
	self.btnDraw:setVisible(true)
	self.dropDownBox:setVisible(true)
	for i, v in ipairs(self.legionList) do
		if v.battleSeasonType == gSeasonType.PINNACLE_SEASON and v.pinnacleCompetitionGroup == 1 then
			if 1 < ownRank then
				pyramidWarCtrl = nil
				;(nil).title = v.legionName
				;(nil).tag = i
				table.insert(dropData, nil)
				if v.pinnacleCompetitionIndex == 0 and index == nil then
					index = i
				end
			elseif self.ownlegion and self.ownlegion.legionIndex == v.legionIndex then
				pyramidWarCtrl = nil
				;(nil).title = v.legionName
				;(nil).tag = i
				table.insert(dropData, nil)
				index = i
			end
		end
	end
	if index == nil then
		index = self.ownlegion and self.ownlegion.legionIndex or 1
	end
	if 0 < #dropData and self.seasonState ~= gPinnacleSeasonState.SYSTEM_LOT then
		self.dropDownBox:setChooseTag(index)
		self.dropDownBox:refreshData(dropData)
		self:onSelDropDownBox(index)
	else
		self.dropDownBox:setVisible(false)
		self.btnDraw:setVisible(false)
		self.labelDes:setVisible(false)
	end
end
function alliancePBLMatchView:updateView()
	self.labelWait:setVisible(false)
	self.Text_finalIns:setVisible(false)
	self.groupType = gPinnacleSeasonAllianceState.FINISH
	if self.curlegion then
		self.groupType = self.curlegion.pinnacleSeasonAllianceState
	end
	print("-------self.groupType", self.groupType, self.seasonState)
	if self.seasonState == gPinnacleSeasonState.WAIT_LOT or self.seasonState == gPinnacleSeasonState.SYSTEM_LOT then
		self.nodeSelList:setVisible(true)
		self.nodeBlock:setVisible(false)
		self:updateReadLine()
		self.labelTitle:setString(i18n("pyramid_text_116"))
		_ENV, _ENV, _ENV = i18n("pyramid_text_116")
		i18n("pyramid_text_116").__default, i18n("pyramid_text_116").u = i18n("pyramid_text_116")
		self.labelNum:setString(i18n_html("pyramid_text_81", i18n("pyramid_text_116")))
		self.btnDraw:setVisible(false)
		self.dropDownBox:setVisible(false)
	elseif self.groupType == gPinnacleSeasonAllianceState.WAIT_COMPETITION_LOT then
		self.nodeSelList:setVisible(true)
		self.nodeBlock:setVisible(false)
		print("未抽签")
		self.btnDraw:setTouchEnabled(true)
		self.btnDraw:setTitleText(i18n("pyramid_btn_31"))
		self.nodeRound:setPositionY(305)
		self:updateReadLine()
	elseif self.groupType == gPinnacleSeasonAllianceState.COMPETITION_LOTED then
		self.nodeSelList:setVisible(true)
		self.nodeBlock:setVisible(false)
		print("已经抽签")
		self.btnDraw:setTouchEnabled(false)
		self.btnDraw:setTitleText(i18n("pyramid_text_53"))
		self.nodeRound:setPositionY(305)
		self:updateReadLine()
	elseif self.groupType == gPinnacleSeasonAllianceState.PREPARE or self.groupType == gPinnacleSeasonAllianceState.RUNNING or self.groupType == gPinnacleSeasonAllianceState.FINISH or self.groupType == gPinnacleSeasonAllianceState.APPLY_ED then
		self.nodeSelList:setVisible(false)
		if self.curlegion and self.curlegion.pinnacleArea > 0 then
			self.nodeBlock:setVisible(true)
			self.labelBlock2:setString(self.curlegion.pinnacleCompetitionGroup .. "--" .. pyramidWarltCtrl.getGroupName(self.curlegion.pinnacleCompetitionGroup))
		else
			self.nodeBlock:setVisible(false)
		end
		if table.nums(pyramidWarCtrl.top16Group) == 16 then
			self:updateLine()
		else
			self:updateReadLine()
		end
	else
		print("没有匹配的状态")
		self.nodeBlock:setVisible(false)
		if table.nums(pyramidWarCtrl.top16Group) == 16 then
			self:updateLine()
		else
			self:updateReadLine()
		end
	end
	self.Text_finalIns:setVisible(self.groupType == gPinnacleSeasonAllianceState.FINISH and self.seasonState == gPinnacleSeasonState.FINISH)
	self.nodeTime:setVisible(self.nodeSelList:isVisible())
end
function alliancePBLMatchView:updateReadLine()
	_UPVALUE16_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 16
	;(nil)[3] = 8
	;(nil)[4] = 9
	;(nil)[5] = 4
	;(nil)[6] = 13
	;(nil)[7] = 5
	;(nil)[8] = 12
	;(nil)[9] = 2
	;(nil)[10] = 15
	;(nil)[11] = 7
	;(nil)[12] = 10
	;(nil)[13] = 3
	;(nil)[14] = 14
	;(nil)[15] = 6
	local (nil)[16], indexData = 11, nil
	local _ENV, match_data = 1, 1
	for i = 1, 4 do
		local v_1 = self.matchData[tostring(i)]
		if v_1 then
			for j = 1, 8 do
				local v_2 = v_1[tostring(j)]
				if v_2 then
					for k = 1, 2 do
						local v = v_2[tostring(k)]
						if v and v.index and pyramidWarCtrl.top16Group[tostring(v.legionId)] then
							match_data[v.index] = v.legionId
						end
					end
				end
			end
		end
	end
	for i = 1, 16 do
		if match_data[i] then
			self.tableMatchSingle["1_" .. i]:setData(match_data[i])
		else
			self.tableMatchSingle["1_" .. i]:setData(nil, indexData[i])
		end
	end
end
function alliancePBLMatchView:initMatchSingle()
	self.tableMatchSingle, _ENV = nil, nil
	for i_1 = 1, 5 do
		for i_2 = 1, 16 do
			local name = string.format("CCS_alliancePBLMatchSingle_%d_%d", i_1, i_2)
			local node = SoraDGetExtendChildFromCCSByName(self, name)
			if node then
				self.tableMatchSingle[string.format("%d_%d", i_1, i_2)] = node
			end
		end
	end
end
function alliancePBLMatchView:btnClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLScheduleView")
		panel:show()
	end
end
function alliancePBLMatchView:initLine()
	self.tableLine, _ENV = nil, nil
	for i_1 = 1, 4 do
		for i_2 = 1, 16 do
			for i_3 = 0, 2 do
				local name = string.format("Image_light_%d_%d_%d", i_1, i_2, i_3)
				local line = SoraDGetChildByName(self, name)
				if line then
					line:setVisible(false)
					self.tableLine[string.format("%d_%d_%d", i_1, i_2, i_3)] = line
				end
			end
		end
	end
end
function alliancePBLMatchView:hiddleLine()
	for k, v in pairs(self.tableLine) do
		v:setVisible(false)
	end
end
function alliancePBLMatchView:updateLine()
	self:hiddleLine()
	_ENV, _UPVALUE16_ = self, self.hiddleLine
	_ENV, self.round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	_ENV, (nil).round = nil, 0
	;(nil).round = 0
	self.hiddleLine[1] = self
	self.hiddleLine[2] = nil
	self.hiddleLine[3] = nil
	self.hiddleLine[4] = nil
	self.hiddleLine[5] = nil
	self.hiddleLine[6] = nil
	self.hiddleLine[7] = nil
	self.hiddleLine[8] = nil
	self.hiddleLine[9] = nil
	self.hiddleLine[10] = nil
	self.hiddleLine[11] = nil
	self.hiddleLine[12] = nil
	self.hiddleLine[13] = nil
	self.hiddleLine[14] = nil
	self.hiddleLine[15] = nil
	local self.hiddleLine[16], groupdata = nil, self.hiddleLine
	for i = 2, 5 do
		local v_1 = self.matchData[tostring(i)]
		if v_1 then
			for j = 1, 8 do
				local v_2 = v_1[tostring(j)]
				if v_2 then
					for k = 1, 2 do
						local v = v_2[tostring(k)]
						if v then
							groupdata[v.index].round = i - 1
						end
					end
				end
			end
		end
	end
	local cur_round = table.nums(self.matchData)
	_ENV = self.matchData
	self.matchData[0] = "pyramid_text_81"
	self.matchData[1] = "pyramid_text_60"
	self.matchData[2] = "pyramid_text_61"
	self.matchData[3] = "pyramid_text_62"
	self.matchData[4] = "pyramid_text_63"
	local self.matchData[5], roundStr = "pyramid_text_63", self.matchData
	_ENV, _ENV, _ENV = nil, 1, 8
	;(1).__default, (nil).u = nil, "true"
	self.labelNum:setString(i18n_html(roundStr[cur_round], 8, 1))
	_ENV = i18n_html(roundStr[cur_round], 8, 1)
	i18n_html(roundStr[cur_round], 8, 1).time = ""
	self.labelTitle:setString(i18n("pyramid_text_64", i18n_html(roundStr[cur_round], 8, 1)))
	dump(self.matchData, "self.matchData", 10)
	dump(groupdata, "groupdata", 10)
	if cur_round == 5 then
		self.nodePBLIcon:setVisible(false)
	else
		self.nodePBLIcon:setVisible(true)
	end
	for i_1 = 1, 5 do
		local v_1 = self.matchData[tostring(i_1)]
		if v_1 then
			for i_2 = 1, 8 do
				local v_2 = v_1[tostring(i_2)]
				if v_2 then
					for i_3 = 1, 2 do
						local v_3 = v_2[tostring(i_3)]
						if v_3 then
							local i_x = i_2 * 2 + (i_3 - 2)
							local light = false
							local nodename = string.format("%d_%d", i_1, i_x)
							self.tableMatchSingle[nodename]:setData(v_3.legionId)
							local lineimg = "frame_jztdfs_hstt.png"
							if cur_round == i_1 then
								lineimg = "frame_jztdfs_lxtt.png"
							end
							if groupdata[v_3.index] then
								if i_1 <= groupdata[v_3.index].round then
									if groupdata[v_3.index].round == i_1 then
										local x = math.ceil(i_x / 2)
										if i_1 == 2 then
											if x == 2 then
												x = 3
											elseif x == 3 then
												x = 4
											elseif x == 4 then
												x = 2
											end
										end
										local name = string.format("%d_%d_%d", i_1 + 1, x, 0)
										local line = self.tableLine[name]
										if line then
											line:setVisible(true)
										end
									end
									light = true
								elseif groupdata[v_3.index].round == cur_round - 1 then
									light = true
								end
							end
							if light then
								for i_4 = 0, 2 do
									local name = string.format("%d_%d_%d", i_1, i_x, i_4)
									local line = self.tableLine[name]
									if line then
										line:setVisible(true)
										if 0 < i_4 then
											line:loadTexture(lineimg, ccui.TextureResType.plistType)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if cur_round == i_1 then
			break
		end
	end
end
function alliancePBLMatchView:refreshBtnLook(target, redata)
	if self.matchData["4"] == nil or self.matchData["4"]["1"] == nil or not next(self.matchData["4"]["1"]) then
		return
	end
	dump(self.matchData, "redata", 10)
	local judgeIsOpen = function(info)
		local infoData = self.matchData["4"]["1"]
		if info.aInfo1.aid == infoData["1"].legionId or info.aInfo1.aid == infoData["2"].legionId then
			local nowTime = serviceFunctions.systemTime()
			print("aaaaaa", nowTime)
			if nowTime <= info.endtime and nowTime >= info.starttime and info.status == gPostSeasonWatchState.OPEN then
				print("111111")
				self.kid = info.kid or 1
				self.btnVideo:setVisible(true)
				self.btnVideo:stopAllActions()
				_ENV = nil
				;(nil)[1] = cca.fadeTo(0.5, 0.5)
				;(nil)[2] = cca.fadeTo(0.5, 1)
				;(nil)[3] = cca.fadeTo(0.5, 1)
				;(nil)[4] = cca.fadeTo(0.5, 1)
				self.btnVideo:runAction(cca.repeatForever(cca.seq(nil)))
			else
				self.btnVideo:setVisible(false)
				self.btnVideo:stopAllActions()
				self.kid = nil
			end
		end
	end
	local contorlInfo = redata.redata
	for _, val in pairs(contorlInfo) do
		judgeIsOpen(val)
	end
end
function alliancePBLMatchView:btnVideoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.kid then
			SoraDGotoWorldMapPoint(cc.p(75, 75), false, self.kid, nil, nil, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function alliancePBLMatchView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if pyramidWarCtrl:getGroupManagerRank(self.curlegion.legionIndex) >= 1 then
			pyramidWarCtrl:newDrawFinallistsCompetitionReq(self.curlegion.legionId)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
			self:initView()
		end
	end
end
return alliancePBLMatchView
