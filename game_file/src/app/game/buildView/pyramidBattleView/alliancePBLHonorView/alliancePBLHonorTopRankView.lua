local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorTopRankView = class("alliancePBLHonorTopRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLHonorTopRankView")
	end
	return target
end)
function alliancePBLHonorTopRankView:ctor()
	self.tableGroupNode, _ENV, self.tableSeasonNode, _ENV = nil, nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.imgBg = SoraDGetChildByName(self, "Image_bigBg")
	self.imgBg:setScale(math.max(1, display.height / self.imgBg:getContentSize().height))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.nodeList = SoraDGetChildByName(self, "Node_list")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.labelTitle3 = SoraDGetChildByName(self, "Text_title_3")
	self.tableSeasonNode = SoraDGetChildsArrayByName(self, "Node_round_", 3, 1)
	self.tableGroupNode = SoraDGetChildsArrayByName(self, "Node_group_", 15, 2, false)
	table.insert(self.tableGroupNode, 1, self.topNode)
	_ENV = 2
	;(2).num = 4
	self.labelTitle1:setString(i18n("pyramid_title_10", 2))
	_ENV = i18n("pyramid_title_10", 2)
	i18n("pyramid_title_10", 2).num = 8
	self.labelTitle2:setString(i18n("pyramid_title_10", i18n("pyramid_title_10", 2)))
	_ENV = i18n("pyramid_title_10", i18n("pyramid_title_10", 2))
	i18n("pyramid_title_10", i18n("pyramid_title_10", 2)).num = 16
	self.labelTitle3:setString(i18n("pyramid_title_10", i18n("pyramid_title_10", i18n("pyramid_title_10", 2))))
	self.nodeList:setPositionY(math.max(self.scroll:getContentSize().height, 1080))
	SoraDCreatAnimationEx(self.__cname, self, true)
end
function alliancePBLHonorTopRankView:initData(season)
	self.curSeason = season
	self.curData = pyramidWarCtrl:getPBLHistoryTop16Group(self.curSeason)
	pyramidWarCtrl = nil
	;(nil).num = self.curSeason
	self.nodeTitle:setTitle(i18n("pyramid_title_09", nil))
	if not self.curData then
		pyramidWarCtrl = self.curData
	end
	for i, v in ipairs(self.curData) do
		if 16 < i then
			break
		end
		local single = self.tableGroupNode[i]
		single.btnGroupInfo = SoraDGetChildByName(single, "Button_groupInfo")
		single.nodeFlag = SoraDGetChildByName(single, "Node_flag")
		single.labelKname = SoraDGetChildByName(single, "Text_kname")
		single.labelName = SoraDGetChildByName(single, "Text_name")
		single.btnGroupInfo:setTag(i)
		single.btnGroupInfo:setSwallowTouches(false)
		single.btnGroupInfo:addTouchEventListener(handler(self, self.btnInfoClickCallBack))
		allianceDesRead.getFlagWithParticle(v.flag, single.nodeFlag)
		single.labelKname:setString(v.kingname or "")
		pyramidWarCtrl = handler(self, self.btnInfoClickCallBack)
		handler(self, self.btnInfoClickCallBack).abbr = v.abbr
		handler(self, self.btnInfoClickCallBack).name = v.legionName
		single.labelName:setString(i18n("common_text_186", handler(self, self.btnInfoClickCallBack)))
		single:setVisible(true)
	end
	for i, v in ipairs(self.tableSeasonNode) do
		v.btnRound = SoraDGetChildByName(v, "Button_round")
		v.btnRound:setTouchEnabled(false)
		v.btnRound:setBright(true)
		v.bflRound = SoraDGetChildByName(v, "BitmapFontLabel_round")
		v.spriteS = SoraDGetChildByName(v, "Sprite_S")
		self:updateSeasonIcon(v, self.curSeason)
	end
end
function alliancePBLHonorTopRankView:updateSeasonIcon(single, season)
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
function alliancePBLHonorTopRankView:btnInfoClickCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		local index = target:getTag()
		if 1 < index and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		if 1 < index and self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLHonorGroupInfoView")
		panel:initData(self.curData[index], index, self.curSeason, gGloryRankTypeDef.ADVANCE_16_LEGION, index)
		panel:show()
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
return alliancePBLHonorTopRankView
