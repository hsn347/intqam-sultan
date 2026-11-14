local masteryUpgradePopView = class("masteryUpgradePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("masteryUpgradePopView")
	end
	return target
end)
local buildRead = include("buildDescribeRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local buildLogic = include("buildLogic")
local cityBuildMgr = include("cityBuildMgr")
local itemDesRead = include("itemDesRead")
function masteryUpgradePopView:ctor()
	self.tableScrollSingles, _ENV = nil, nil
	self:initWidget()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_MASTERY_VIEW_REFRESH", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", function(target, data)
		if BUILD_OPERATE_TYPE.DEMOLISH == data.optype and self.bid == data.bid then
			SoraDRemoveAllPanelFromManager()
		end
	end)
end
function masteryUpgradePopView:initWidget()
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Image_1"
	self.Image_bg = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "Node_build"
	;("Center_Node")[2] = "Image_build"
	self.Image_build = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_buildInfo"
	self.Node_buildInfo = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_buildPower"
	self.Text_buildPower = SoraDGetChildByFullPath(self.Node_buildInfo, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "Node_cur"
	;("Center_Node")[2] = "Text_8"
	SoraDGetChildByFullPath(self.Node_buildInfo, "Center_Node"):setString(i18n("specialization_text_20"))
	_UPVALUE2_ = i18n("specialization_text_20")
	i18n("specialization_text_20")[1] = "Node_cur"
	i18n("specialization_text_20")[2] = "Node_star"
	local Node_star = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_20"))
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(Node_star)
	self.curStarSingle = starSingle
	_UPVALUE2_ = Node_star
	Node_star[1] = "Node_next"
	Node_star[2] = "Text_8"
	SoraDGetChildByFullPath(self.Node_buildInfo, Node_star):setString(i18n("common_text_381"))
	_UPVALUE2_ = i18n("common_text_381")
	i18n("common_text_381")[1] = "Node_next"
	i18n("common_text_381")[2] = "Node_star"
	local Node_star = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("common_text_381"))
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(Node_star)
	self.nextStarSingle = starSingle
	_UPVALUE1_ = Node_star
	Node_star[1] = "Image_left"
	self.Image_left = SoraDGetChildByFullPath(self.Node_content, Node_star)
	_UPVALUE1_ = Node_star
	Node_star[1] = "Text_cond"
	self.Text_cond = SoraDGetChildByFullPath(self.Node_content, Node_star)
	self.Text_cond:setString(i18n("common_text_726"))
	_UPVALUE1_ = i18n("common_text_726")
	i18n("common_text_726")[1] = "Image_right"
	self.Image_right = SoraDGetChildByFullPath(self.Node_content, i18n("common_text_726"))
	_UPVALUE1_ = i18n("common_text_726")
	i18n("common_text_726")[1] = "ScrollView_up"
	self.scrollUp = SoraDGetChildByFullPath(self.Node_content, i18n("common_text_726"))
	_UPVALUE2_ = i18n("common_text_726")
	i18n("common_text_726")[1] = "Node_immed"
	i18n("common_text_726")[2] = "Button_immed"
	self.Button_immed = SoraDGetChildByFullPath(self.Node_content, i18n("common_text_726"))
	self.Button_immed:addTouchEventListener(handler(self, self.onClick_immed))
	_UPVALUE2_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Node_immed"
	handler(self, self.onClick_immed)[2] = "Node_gold"
	self.Node_gold = SoraDGetChildByFullPath(self.Node_content, handler(self, self.onClick_immed))
	_UPVALUE1_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_gold, handler(self, self.onClick_immed))
	_UPVALUE2_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Node_immed"
	handler(self, self.onClick_immed)[2] = "Text_immed"
	SoraDGetChildByFullPath(self.Node_content, handler(self, self.onClick_immed)):setString(i18n("common_text_378"))
	_UPVALUE1_ = i18n("common_text_378")
	i18n("common_text_378")[1] = "Node_upgrade"
	self.Node_upgrade = SoraDGetChildByFullPath(self.Node_content, i18n("common_text_378"))
	_UPVALUE1_ = i18n("common_text_378")
	i18n("common_text_378")[1] = "Button_upgrade"
	self.Button_upgrade = SoraDGetChildByFullPath(self.Node_upgrade, i18n("common_text_378"))
	self.Button_upgrade:addTouchEventListener(handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Node_time"
	self.Node_time = SoraDGetChildByFullPath(self.Node_upgrade, handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Text_time"
	self.Text_time = SoraDGetChildByFullPath(self.Node_time, handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Text_upgrade"
	SoraDGetChildByFullPath(self.Node_upgrade, handler(self, self.onClick_upgrade)):setString(i18n("common_text_055"))
	self.singleCell = SoraDGetChildByName(self, "Node_single_cell")
end
function masteryUpgradePopView:initData(data)
	local specializationRead = include("specializationRead")
	self.bid = data.bid
	self.mid = data.mid
	self.curLv = data.curLv
	self.upgradeCond = buildLogic.isCanMasteryUpgrade(self.bid, self.curLv + 1)
	self.parent = data.parent
	self.commonPopBox:setTitleName(buildRead.getName(self.bid))
	SoraChangeSpriteImage(self.Image_bg, specializationRead.getUpgradeViewBg(self.bid))
	SoraChangeSpriteImage(self.Image_build, specializationRead.getBuildIcon(self.bid))
	_ENV = specializationRead.getBuildIcon(self.bid)
	specializationRead.getBuildIcon(self.bid).lev = self.curLv
	self.curStarSingle:initData(specializationRead.getBuildIcon(self.bid))
	_ENV = specializationRead.getBuildIcon(self.bid)
	specializationRead.getBuildIcon(self.bid).lev = self.curLv + 1
	self.nextStarSingle:initData(specializationRead.getBuildIcon(self.bid))
	local curPower = specializationRead.getMasteryFighting(self.bid, self.curLv)
	local nextPower = specializationRead.getMasteryFighting(self.bid, self.curLv + 1)
	_ENV = specializationRead.getBuildIcon(self.bid)
	specializationRead.getBuildIcon(self.bid).Num = nextPower - curPower
	self.Text_buildPower:setString(i18n("specialization_text_12", specializationRead.getBuildIcon(self.bid)))
	self.Text_gold:setString(tostring(self.upgradeCond._immediatelyGold))
	SoraDToCenter(self.Node_gold, 6)
	self.Text_time:setString(SoraDConvertSecondToString(self.upgradeCond._costtime))
	SoraDToCenter(self.Node_time, 6)
	self:initScroll()
end
function masteryUpgradePopView:initScroll(...)
	for i, v in ipairs(self.tableScrollSingles) do
		v:removeFromParent()
	end
	_ENV, _ENV, self.tableScrollSingles, _ENV = ipairs(self.tableScrollSingles)
	ipairs(self.tableScrollSingles).name = "_masteryQueueList"
	ipairs(self.tableScrollSingles).singleType = 4
	_ENV, ipairs(self.tableScrollSingles)[1], ipairs(self.tableScrollSingles).needJump = ipairs(self.tableScrollSingles)
	ipairs(self.tableScrollSingles).name = "_buildQueueList"
	ipairs(self.tableScrollSingles).singleType = 4
	_ENV, ipairs(self.tableScrollSingles)[2], ipairs(self.tableScrollSingles).needJump = ipairs(self.tableScrollSingles)
	ipairs(self.tableScrollSingles).name = "_retPreCond"
	ipairs(self.tableScrollSingles).singleType = 1
	_ENV, ipairs(self.tableScrollSingles)[3], ipairs(self.tableScrollSingles).needJump = ipairs(self.tableScrollSingles)
	ipairs(self.tableScrollSingles).name = "_retCostTools"
	ipairs(self.tableScrollSingles).singleType = 3
	_ENV, ipairs(self.tableScrollSingles)[4], ipairs(self.tableScrollSingles).needJump = ipairs(self.tableScrollSingles)
	ipairs(self.tableScrollSingles).name = "_retCostRes"
	ipairs(self.tableScrollSingles).singleType = 2
	ipairs(self.tableScrollSingles)[5], ipairs(self.tableScrollSingles).needJump = ipairs(self.tableScrollSingles)
	local condConfig = ipairs(self.tableScrollSingles)
	local isreach = true
	local cellH = 40
	local totalCount = 0
	for i, v in ipairs(condConfig) do
		totalCount = totalCount + #self.upgradeCond[v.name]
	end
	local totaH = totalCount * cellH
	totaH = math.max(totaH, self.scrollUp:getContentSize().height)
	self.scrollUp:setInnerContainerSize(cc.size(self.scrollUp:getContentSize().width, totaH))
	self.scrollUp:setBounceEnabled(totalCount > self.scrollUp:getContentSize().height / cellH)
	local buildCreateSingle = include("buildCreateSingle")
	local createSingleItem = function(data, singleData)
		local singleInfo = buildCreateSingle.new(self.singleCell:clone())
		singleInfo:setPosition(270, totaH)
		buildCreateSingle = 270
		;(270).singleType = data.singleType
		;(270).singleData = singleData
		singleInfo:initData(270)
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		table.insert(self.tableScrollSingles, singleInfo)
		if not data.needJump then
			singleInfo.btnJump:setVisible(false)
		end
		return singleInfo
	end
	for i, v in ipairs(condConfig) do
		for m, n in ipairs(self.upgradeCond[v.name]) do
			createSingleItem(v, n)
		end
	end
end
function masteryUpgradePopView:scrollSingleCallBack(singleData)
	if singleData.singleType == BUILD_CONDITION_TYPE_TIME then
		local leftTime = singleData.singleData.timerNode.timer:getRemainTime()
		if leftTime <= 0 then
			self.upgradeCond = buildLogic.isCanMasteryUpgrade(self.bid, self.curLv + 1)
			self:initScroll()
		else
			SoraDShowSpeedUpBox(singleData.singleData, nil, i18n("common_text_765"))
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_BUILD then
		local bid = singleData.singleData.bid
		local __, iid = cityCtrl:getBuildMaxLv(bid)
		local buildCell = cityCtrl:getBuildCell(bid, iid)
		if not buildCell then
			GLOBAL_BUILD_PRE_BID = bid
			_ENV = bid
			bid.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			bid.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			bid.bid = bid
			bid.iid = nil
			bid.isRecover = true
			SoraDSendMessage(bid)
			SoraDRemoveAllPrePanelFromManager(self)
		else
			if self.parent and self.parent.needRecover then
				self.parent.needRecover = false
			end
			local mainCityFunctions = include("mainCityFunctions")
			mainCityFunctions.masteryJumpToBuildUpgrade(bid, iid)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_RES then
		_ENV = cityCtrl:getBuildCell(bid, iid)
		cityCtrl:getBuildCell(bid, iid).rid = singleData.singleData.resid
		cityCtrl:getBuildCell(bid, iid).needResData = self.upgradeCond._retCostRes
		uiManager:show("resourceBuyView", (cityCtrl:getBuildCell(bid, iid)))
	end
end
function masteryUpgradePopView:setBuildBtnTouchEnable(isEnable)
	self.Button_immed:setTouchEnabled(isEnable)
	self.Button_immed:setBright(isEnable)
	self.Button_upgrade:setTouchEnabled(isEnable)
	self.Button_upgrade:setBright(isEnable)
end
function masteryUpgradePopView:resUpdate()
	self.upgradeCond = buildLogic.isCanMasteryUpgrade(self.bid, self.curLv + 1)
	self.Text_gold:setString(tostring(self.upgradeCond._immediatelyGold))
	self:initScroll()
end
function masteryUpgradePopView:onClick_immed(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self:checkUpgradeCond(true) then
		return
	end
	_ENV = nil
	;(nil).name = buildRead.getName(self.bid)
	SoraDShowBuyBox(i18n("common_text_745", nil), self.upgradeCond._immediatelyGold, i18n("common_text_378"), function(event)
		if event == MSGBOX_CALLBACK_YES then
			cityCtrl:sendReqMasteryUpgrade(self.mid, OPERATE_MODE.IMMEDIATELY)
		end
	end)
end
function masteryUpgradePopView:onClick_upgrade(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self:checkUpgradeCond() then
		return
	end
	local _ENV, tableResNeedBuy = self:checkUpgradeCond(), self:checkUpgradeCond()
	for i, v in ipairs(self.upgradeCond._retCostRes) do
		if not v.isreach then
			local needBuyRes = v.rescount - v.curcount
			if 0 < needBuyRes then
				_ENV = nil
				;(nil).resid = v.resid
				;(nil).rescount = needBuyRes
				table.insert(tableResNeedBuy, nil)
			end
		end
	end
	if not next(tableResNeedBuy) then
		cityCtrl:sendReqMasteryUpgrade(self.mid, OPERATE_MODE.NORMAL)
		return
	end
	_ENV, _ENV = nil, OPERATE_MODE.NORMAL
	;(nil).resToGold = self.upgradeCond._resToGold
	OPERATE_MODE.NORMAL.needResData, (nil).retCostRes = nil, tableResNeedBuy
	OPERATE_MODE.NORMAL.viewType = RESBUYVIEW_TYPE.UPGRADE
	function OPERATE_MODE.NORMAL.handle()
		cityCtrl:sendReqMasteryUpgrade(self.mid, OPERATE_MODE.GOLD_REPLACE)
	end
	uiManager:show("buildCreateResBuy", OPERATE_MODE.NORMAL)
end
function masteryUpgradePopView:checkUpgradeCond(ignoreMasteryQyeye)
	if not ignoreMasteryQyeye then
		for i, v in ipairs(self.upgradeCond._masteryQueueList) do
			SoraDShowMsgTip(i18n("specialization_tips_01"))
			return false
		end
	end
	for i, v in ipairs(self.upgradeCond._buildQueueList) do
		SoraDShowMsgTip(i18n("specialization_tips_03"))
		return false
	end
	for i, v in ipairs(self.upgradeCond._retPreCond) do
		if not v.isreach then
			SoraDShowMsgTip(i18n("specialization_tips_02"))
			return false
		end
	end
	for i, v in ipairs(self.upgradeCond._retCostTools) do
		if not v.isreach then
			_ENV = i18n("specialization_tips_02")
			i18n("specialization_tips_02").name = itemDesRead.getName(v.toolid)
			SoraDShowMsgTip(i18n("commom_text_4302", i18n("specialization_tips_02")))
			return false
		end
	end
	return true
end
return masteryUpgradePopView
