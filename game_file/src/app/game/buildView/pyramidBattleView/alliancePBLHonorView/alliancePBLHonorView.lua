local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorView = class("alliancePBLHonorView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLHonorView")
	end
	return target
end)
function alliancePBLHonorView:ctor()
	self.isHideCurrentSceneView = true
	self.curSeason = 1
	self.curData, _ENV, self.curNode = nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.imgBg = SoraDGetChildByName(self, "Image_bigBg")
	self.imgBg:setScale(math.max(1, display.height / self.imgBg:getContentSize().height))
	self.scroll = SoraDGetChildByName(self, "ScrollView_round")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.btnGroupInfo = SoraDGetChildByName(self, "Button_groupInfo")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelKname = SoraDGetChildByName(self, "Text_kname")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.nodeClick = SoraDGetChildByName(self, "Node_click")
	self.nodeClick:retain()
	self.labelTitle = SoraDGetChildByName(self.centerNode, "Text_title")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeName = SoraDGetChildByName(self, "Node_name")
	self.bflRound = SoraDGetChildByName(self, "BitmapFontLabel_round")
	self.nodeBottom = SoraDGetChildByName(self, "Node_bottom")
	self.btnOwn = SoraDGetChildByName(self, "Button_own")
	self.labelOwn = SoraDGetChildByName(self, "Text_own")
	self.btnGroup = SoraDGetChildByName(self, "Button_group")
	self.labelGroup = SoraDGetChildByName(self, "Text_group")
	self.btnTop = SoraDGetChildByName(self, "Button_top")
	self.labelTop = SoraDGetChildByName(self, "Text_top")
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.btnGroupInfo:addTouchEventListener(handler(self, self.btnInfoClickCallBack))
	self.btnGroup:addTouchEventListener(handler(self, self.btnGroupClickCallBack))
	self.btnTop:addTouchEventListener(handler(self, self.btnTopClickCallBack))
	self.btnOwn:addTouchEventListener(handler(self, self.btnOwnClickCallBack))
	self.nodeTitle:setTitle(i18n("pyramid_title_08"))
	self.labelOwn:setString(i18n("pyramid_title_11"))
	self.labelGroup:setString(i18n("pyramid_title_13"))
	self.labelTop:setString(i18n("pyramid_btn_33"))
	self.labelTitle:setString(i18n("pyramid_text_98"))
	self.labelDes:setString(i18n("pyramid_text_99"))
	self:initScroll()
	self:initView()
	pyramidWarCtrl:pinnaclePraiseInitReq()
	SoraDCreatAnimationEx(self.__cname, self, true)
	if display.height < 986 then
		local scale = (display.height - 198 - 158) / 630
		self.centerNode:setScale(scale)
		self.centerNode:setPositionY(scale * 365 + 198)
	else
		local scale = math.min((display.height - 198 - 158) / 630, 1.3)
		self.centerNode:setScale(scale)
	end
	SoraDPlaySound("pyramidBattle", 4)
end
function alliancePBLHonorView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_HONOR_EDIT_BACK", handler(self, self.updateContent))
end
function alliancePBLHonorView:createSingle()
	local single = self.nodeClone:clone()
	single.imgPoint = SoraDGetChildByName(single, "Image_point")
	single.nodeRound = SoraDGetChildByName(single, "Node_round")
	single.btnRound = SoraDGetChildByName(single, "Button_round")
	single.spriteClick = SoraDGetChildByName(single, "Sprite_click")
	single.spriteS = SoraDGetChildByName(single, "Sprite_S")
	single.bflRound = SoraDGetChildByName(single, "BitmapFontLabel_round")
	single.btnRound:addTouchEventListener(handler(self, self.btnRoundClickCallBack))
	single.btnRound:setSwallowTouches(false)
	return single
end
function alliancePBLHonorView:refreshSingle(single, data, otherData)
	single.nodeRound:setVisible(not data.isPoint)
	single.imgPoint:setVisible(data.isPoint)
	if not data.isPoint then
		single.btnRound:setTag(single:getTag())
		single.spriteClick:setVisible(self.curSeason == data.season)
		if self.curSeason == data.season then
			self.nodeClick:removeFromParent(false)
			self.nodeClick:addTo(single.nodeRound)
			self.nodeClick:setPosition(0, 0)
		end
		if self.curSeason == data.season then
			self.curNode = single
		end
		self:updateSeasonIcon(single, data.season)
	end
end
function alliancePBLHonorView:onExitPanel()
	self.nodeClick:release()
end
function alliancePBLHonorView:initScroll()
	local totalSeason = pyramidWarCtrl.peakSeasonNo - 1
	if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.NOT_OPEN then
		totalSeason = totalSeason + 1
	end
	self.curSeason = totalSeason
	self.tototalSeason = totalSeason
	local pyramidWarCtrl, data = pyramidWarCtrl.pinnacleSeasonState, pyramidWarCtrl.pinnacleSeasonState
	for i = 1, 2 * totalSeason - 1 do
		if i % 2 == 1 then
			pyramidWarCtrl = nil
			;(nil).isPoint = false
			;(nil).season = math.ceil(i / 2)
			table.insert(data, nil)
		else
			pyramidWarCtrl = nil
			;(nil).isPoint = true
			table.insert(data, nil)
		end
	end
	pyramidWarCtrl = data
	data.isAR = SoraDFIsRA()
	self.scroll:updateScrollView(cc.size(58, 70), data, #data, data)
	if SoraDFIsRA() then
		self.scroll:jumpToLeft()
	else
		self.scroll:jumpToRight()
	end
end
function alliancePBLHonorView:btnRoundClickCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.curNode then
			self.curNode.spriteClick:setVisible(false)
		end
		self.curNode = self.scroll:getChildByIndex(target:getTag())
		self.curNode.spriteClick:setVisible(true)
		self.nodeClick:removeFromParent(false)
		self.nodeClick:addTo(self.curNode.nodeRound)
		self.nodeClick:setPosition(0, 0)
		self.curSeason = math.ceil(target:getTag() / 2)
		self:updateView()
		pyramidWarCtrl:newGloryRankReq(gGloryRankTypeDef.ADVANCE_16_LEGION, self.curSeason)
		print("target:getTag()", target:getTag(), self.curSeason * 2)
		self.scroll:jumpIndexToCenter_X(SoraDFPosX(target:getTag(), self.tototalSeason * 2))
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function alliancePBLHonorView:initView()
	pyramidWarCtrl:newGloryRankReq(gGloryRankTypeDef.ADVANCE_16_LEGION, self.curSeason)
	self:updateView()
end
function alliancePBLHonorView:updateContent()
	local selfContent = pyramidWarCtrl:checkContent(self.curData, self.curSeason)
	if selfContent then
		self.labelDes:setString(selfContent)
	else
		self.labelDes:setString(i18n("pyramid_text_99"))
	end
end
function alliancePBLHonorView:updateView(target, data)
	local curData = pyramidWarCtrl:getPBLHistoryTop16Group(self.curSeason)
	self.bflRound:setString(self.curSeason)
	if data or curData then
		if curData and curData[1] then
			self.curData = curData[1]
			self.nodeFlag:removeAllChildren()
			allianceDesRead.getFlagWithParticle(self.curData.flag, self.nodeFlag)
			self.labelKname:setString(self.curData.kingname or "")
			pyramidWarCtrl = nil
			;(nil).abbr = self.curData.abbr
			;(nil).name = self.curData.legionName
			self.labelName:setString(i18n("common_text_186", nil))
			self:updateContent()
		end
		SoraDCloseLoading(self)
	else
		SoraDShowLoading(self)
		pyramidWarCtrl:newGloryRankReq(gGloryRankTypeDef.ADVANCE_16_LEGION, self.curSeason)
	end
end
function alliancePBLHonorView:updateSeasonIcon(single, season)
	if 10 <= season then
		single.spriteS:setPositionX(-18.0)
		single.spriteS:setScale(0.69)
		single.bflRound:setPositionX(-5.8)
		single.bflRound:setScale(0.27)
	else
		single.spriteS:setPositionX(-16)
		single.spriteS:setScale(0.9)
		single.bflRound:setPositionX(1.2)
		single.bflRound:setScale(0.34)
	end
	single.bflRound:setString(season)
end
function alliancePBLHonorView:btnInfoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorGroupInfoView")
		panel:initData(self.curData, 1, self.curSeason, gGloryRankTypeDef.ADVANCE_16_LEGION, 1)
		panel:show()
	end
end
function alliancePBLHonorView:btnGroupClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorRankView")
		panel:initData(self.curSeason)
		panel:show()
	end
end
function alliancePBLHonorView:btnTopClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorTopRankView")
		panel:initData(self.curSeason)
		panel:show()
	end
end
function alliancePBLHonorView:btnOwnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorPersonalRankView")
		panel:initData(self.curSeason)
		panel:show()
	end
end
return alliancePBLHonorView
