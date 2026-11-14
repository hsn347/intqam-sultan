local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local unchartedCtrl = gametop.playertop_:getModule("unchartedCtrl")
local itemDesRead = include("itemDesRead")
local unchartedView = class("unchartedView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("unchartedView")
	end
	return target
end)
unchartedView.ZORDER = 99
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
local CORLOR_GREEN = cc.c3b(0, 190, 30)
_ENV, _UPVALUE29_ = 190, 0
;(190).x = 0
;(190).y = 0
_ENV, (190).dir = 30, "MID"
;(30).x = 1
;(30).y = 1
_ENV, (30).dir = nil, "RT"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = 1
_ENV, (nil).dir = nil, "LT"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = 1
_ENV, (nil).dir = nil, "LT"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = 1
_ENV, (nil).dir = nil, "RT"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = 1
;(nil).y = -1
_ENV, (nil).dir = nil, "RB"
;(nil).x = -1
;(nil).y = -1
_ENV, (nil).dir = nil, "LB"
;(nil).x = -1
;(nil).y = -1
;(nil).dir = "LB"
_ENV, _ENV, (0)[1] = 30, 190, 190
_ENV, _ENV, (0)[2] = 30, 190, 30
_ENV, _ENV, (0)[3] = 30, 190
_ENV, _ENV, (0)[4] = 30, 190
_ENV, _ENV, (0)[5] = 30, 190
_ENV, _ENV, (0)[6] = 30, 190
_ENV, _ENV, (0)[7] = 30, 190
_ENV, _ENV, (0)[8] = 30, 190
_ENV, _ENV, (0)[9] = 30, 190
_ENV, _ENV, (0)[10] = 30, 190
_ENV, _ENV, (0)[11] = 30, 190
_ENV, _ENV, (0)[12] = 30, 190
_ENV, _ENV, (0)[13] = 30, 190
_ENV, _ENV, (0)[14] = 30, 190
_ENV, _ENV, (0)[15] = 30, 190
_ENV, _ENV, (0)[16] = 30, 190
_ENV, _ENV, (0)[17] = 30, 190
_ENV, _ENV, (0)[18] = 30, 190
_ENV, _ENV, (0)[19] = 30, 190
_ENV, _ENV, (0)[20] = 30, 190
_ENV, _ENV, (0)[21] = 30, 190
_ENV, _ENV, (0)[22] = 30, 190
_ENV, _ENV, (0)[23] = 30, 190
_ENV, _ENV, (0)[24] = 30, 190
_ENV, _ENV, (0)[25] = 30, 190
_ENV, _ENV, (0)[26] = 30, 190
_ENV, _ENV, (0)[27] = 30, 190
_ENV, _ENV, (0)[28] = 30, 190
_ENV, _ENV, (0)[29] = 30, 190
_ENV, _ENV, (0)[30] = 30, 190
_ENV, _ENV, (0)[31] = 30, 190
_ENV, _ENV, (0)[32] = 30, 190
_ENV, _ENV, (0)[33] = 30, 190
_ENV, _ENV, (0)[34] = 30, 190
_ENV, _ENV, (0)[35] = 30, 190
_ENV, _ENV, (0)[36] = 30, 190
_ENV, _ENV, (0)[37] = 30, 190
_ENV, _ENV, (0)[38] = 30, 190
_ENV, _ENV, (0)[39] = 30, 190
_ENV, _ENV, (0)[40] = 30, 190
_ENV, _ENV, (0)[41] = 30, 190
_ENV, _ENV, (0)[42] = 30, 190
_ENV, _ENV, (0)[43] = 30, 190
_ENV, _ENV, (0)[44] = 30, 190
_ENV, _ENV, (0)[45] = 30, 190
_ENV, _ENV, (0)[46] = 30, 190
_ENV, _ENV, (0)[47] = 30, 190
_ENV, _ENV, (0)[48] = 30, 190
_ENV, _ENV, (0)[49] = 30, 190
local _ENV, _ENV, (0)[50], coordinatePoints = 30, 190, nil, 0
;(30).x = -98
;(30).y = 48
;(30).z = -1
;(30).isFlipX = false
;(30).image = "#zhencha_yd_wn_01.png"
_ENV, (190).LT, (30).angle = 30, 30, "wn"
;(30).x = -98
;(30).y = -49
;(30).z = 1
;(30).isFlipX = false
;(30).image = "#zhencha_yd_ws_01.png"
_ENV, (190).LB, (30).angle = 30, 30, "ws"
;(30).x = 98
;(30).y = 49
;(30).z = -1
;(30).isFlipX = true
;(30).image = "#zhencha_yd_wn_01.png"
_ENV, (190).RT, (30).angle = 30, 30, "wn"
;(30).x = 98
;(30).y = -49
;(30).z = 1
;(30).isFlipX = true
;(30).image = "#zhencha_yd_ws_01.png"
_ENV, (190).RB, (30).angle = 30, 30, "ws"
;(30).x = 0
;(30).y = 0
;(30).z = 0
;(190).MID, (30).isFlipX = 30, true
local FourDirection = 190
function unchartedView:ctor()
	self:initControls()
	self:initScroll()
end
function unchartedView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_INIT_INFO", function(target, data)
		SoraDCloseLoading(self)
		local unchartedInfo = unchartedCtrl:getUnchartedInfo()
		self.curGridId = unchartedInfo.gridId
		self.throwFreeTimes = unchartedInfo.throwFree
		self.taskInfo = unchartedInfo.taskInfo
		self.mapGrid = unchartedInfo.mapGrid
		self.diceCount = 0
		self.resImgArray, _ENV, self.switcher = unchartedInfo.mapGrid, unchartedInfo.mapGrid, nil
		self.needDelay = false
		self.clickInterval = false
		local posX, posY, zOrder = 300, 1700, unchartedView.ZORDER
		for i = 1, #self.mapGrid do
			local cell = self.panel:clone()
			local btn = SoraDGetChildByName(cell, "btn_single")
			local icon = SoraDGetChildByName(cell, "image_icon")
			local bottom = SoraDGetChildByName(cell, "Image_49")
			local info = self:getConfigPosition(i)
			posX = posX + info.x
			posY = posY + info.y
			zOrder = zOrder + info.z
			cell:addTo(self.viewScrollView, zOrder)
			btn:setSwallowTouches(false)
			cell:setPosition(cc.p(posX, posY))
			icon:setVisible(self.mapGrid[i] < 5000)
			local image = ""
			if self.mapGrid[i] == gUnchartedGridType.TASK then
				image = "icon_mjtx_renwugezi.png"
			elseif self.mapGrid[i] == gUnchartedGridType.TRADER then
				image = "lvxingshangren.png"
				icon:setContentSize(cc.size(320, 240))
				icon:setScale(0.5)
			elseif self.mapGrid[i] == gUnchartedGridType.SURPRICE then
				image = "icon_mjtx_qiyu.png"
			elseif self.mapGrid[i] == gUnchartedGridType.BOX then
				image = "icon_mjtx_baoxiang.png"
			elseif self.mapGrid[i] == gUnchartedGridType.BEGIN then
				image = "gan.png"
				icon:setContentSize(cc.size(115, 312))
				icon:setScale(0.5)
				icon:setPosition(cc.p(icon:getPositionX() - 50, icon:getPositionY() + 50))
				local spine_flag = sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)
				spine_flag:setPosition(cc.p(icon:getPositionX() + 25, icon:getPositionY() + 100))
				spine_flag:addTo(icon)
				bottom:loadTexture("icon_mjtx2.png", ccui.TextureResType.plistType)
			elseif self.mapGrid[i] == gUnchartedGridType.FINISH then
				image = "zwbx_01.png"
			elseif self.mapGrid[i] > 5000 then
				bottom:loadTexture("icon_mjtx2.png", ccui.TextureResType.plistType)
			end
			icon:loadTexture(image, ccui.TextureResType.plistType)
			table.insert(self.gridBtn, btn)
			table.insert(self.gridTable, cell)
			table.insert(self.gridIcon, icon)
			self:refreshItemBtnEffect(cell, self.mapGrid[i])
		end
		for i, v in ipairs(self.mapGrid) do
			self.gridBtn[i]:setTag(v)
		end
		self:initData(unchartedInfo)
		self.oldGridId = unchartedInfo.gridId
		if self.curGridId > table.nums(self.mapGrid) then
			self.curGridId = table.nums(self.mapGrid)
		end
		self:initCammelAnimation(self.gridTable[self.oldGridId]:getPositionX(), self.gridTable[self.oldGridId]:getPositionY(), self.oldGridId)
		if not self.taskInfo.bFinish and self.taskInfo.type ~= gUnchartedGridType.NORMAL and self.taskInfo.type ~= gUnchartedGridType.BEGIN and 0 < table.nums(self.taskInfo) then
			local panel = SoraDCreatePanel("unchartedCommonPopView")
			panel:show()
			panel:initData(self.taskInfo)
		elseif self.taskInfo.type == gUnchartedGridType.TASK and 0 < table.nums(self.taskInfo.data) then
			local panel = SoraDCreatePanel("unchartedCommonPopView")
			panel:show()
			panel:initData(self.taskInfo)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_THROW_DICE_REFRESH", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_GIVEUP_TASK_BACK", handler(self, self.giveUpTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_UNCHARTED_HELP_BUY_BACK", handler(self, self.refreshData))
end
function unchartedView:initControls()
	self.imageFreeBg = SoraDGetChildByName(self, "image_taskBg")
	self.panel = SoraDGetChildByName(self, "panel_excel")
	self.panelDown = SoraDGetChildByName(self, "panel_down")
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.txtStore = SoraDGetChildByName(self, "text_store")
	self.txtReward = SoraDGetChildByName(self, "text_reward")
	self.txtTask = SoraDGetChildByName(self, "text_task")
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.txtThrow = SoraDGetChildByName(self, "text_throw")
	self.txtTaskTitle = SoraDGetChildByName(self, "text_taskTitle")
	self.txtWarning = SoraDGetChildByName(self, "text_warning")
	self.frameStore = SoraDGetChildByName(self, "image_store")
	self.frameReward = SoraDGetChildByName(self, "image_reward")
	self.frameTask = SoraDGetChildByName(self, "image_task")
	self.txtFirst = SoraDGetChildByName(self, "text_first")
	self.txtFirstPlan = SoraDGetChildByName(self, "text_firstPlan")
	self.txtSecond = SoraDGetChildByName(self, "text_second")
	self.txtSecondPlan = SoraDGetChildByName(self, "text_secondPlan")
	self.textThird = SoraDGetChildByName(self, "text_third")
	self.textThirdPlan = SoraDGetChildByName(self, "text_thirdPlan")
	self.txtFourth = SoraDGetChildByName(self, "text_fourth")
	self.txtFourthPlan = SoraDGetChildByName(self, "text_fourthPlan")
	self.imageIcon = SoraDGetChildByName(self, "image_gold")
	if SoraDGetDefaultLanguage() == "de" then
		self.txtSecondPlan:setPositionY(self.txtSecondPlan:getPositionY() - 10)
	end
	self.btnSingle = SoraDGetChildByName(self, "btn_single")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.btnStore = SoraDGetChildByName(self, "btn_store")
	self.btnReward = SoraDGetChildByName(self, "btn_reward")
	self.btnTask = SoraDGetChildByName(self, "btn_task")
	self.btnThrow = SoraDGetChildByName(self, "btn_throw")
	self:setThrowEffect()
	self.iconHaveFree = SoraDGetChildByName(self, "icon_free")
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.nodeTitle:setTitle(i18n("Secret_explore_text_01"))
	self.txtStore:setString(i18n("Secret_explore_text_02"))
	self.txtReward:setString(i18n("Secret_explore_text_03"))
	self.txtTask:setString(i18n("Secret_explore_text_04"))
	self.txtTaskTitle:setString(i18n("Secret_explore_text_04"))
	self.txtWarning:setString(i18n("Secret_explore_text_55"))
	self.btnSingle:addTouchEventListener(handler(self, self.singleClickCallBack))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnStore:addTouchEventListener(handler(self, self.storeClickCallBack))
	self.btnReward:addTouchEventListener(handler(self, self.rewardClickCallBack))
	self.btnTask:addTouchEventListener(handler(self, self.taskClickCallBack))
	self.btnThrow:addTouchEventListener(handler(self, self.throwClickCallBack))
	self.imageFreeBg:addTouchEventListener(handler(self, self.taskClickCallBack))
	SoraDSetTextWidthHeight(self.txtStore, cc.size(100, 60))
	SoraDSetTextWidthHeight(self.txtReward, cc.size(100, 60))
	SoraDSetTextWidthHeight(self.txtTask, cc.size(100, 60))
	self.frameStore:setContentSize(cc.size(90, self.txtStore:getContentSize().height - 20))
	self.frameReward:setContentSize(cc.size(90, self.txtReward:getContentSize().height - 20))
	self.frameTask:setContentSize(cc.size(90, self.txtTask:getContentSize().height - 20))
	SoraDSetTextWidthHeight(self.txtFirst, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtFirstPlan, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtSecond, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtSecondPlan, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.textThird, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.textThirdPlan, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtFourth, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtFourthPlan, cc.size(250, 60))
	SoraDSetTextWidthHeight(self.txtWarning, cc.size(600, 60))
	self.numChar, _ENV, self.gridIcon, _ENV, self.gridBtn, _ENV, self.gridTable, _ENV = SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight, SoraDSetTextWidthHeight
	unchartedCtrl:sendInitUnchartedMsg()
	SoraDShowLoading(self)
end
function unchartedView:initScroll()
	self.containerView = self:createBaseBg()
	self.bgArea = display.newTilesSprite("SinglePicture/bg_mapTile.png", cc.rect(0, 0, self.viewSize.width, self.viewSize.height))
	self.bgArea:ignoreAnchorPointForPosition(false)
	self.bgArea:setAnchorPoint(cc.p(0.0, 0.0))
	self.containerView:addChild(self.bgArea, 0)
	local viewScrollView = cc.ScrollView:create(self:getContentSize())
	viewScrollView:setContainer(self.containerView)
	viewScrollView:setMinScale(1.0)
	viewScrollView:setMaxScale(1.0)
	viewScrollView:setZoomScale(1)
	viewScrollView:setBounceable(false)
	local containerViewSize = self.containerView:getContentSize()
	local containerViewscale = viewScrollView:getZoomScale()
	viewScrollView:setContentOffset(cc.p(-(containerViewSize.width - display.width) / 2 * containerViewscale, -(containerViewSize.height - display.height) * containerViewscale), false)
	viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(viewScrollView, 0)
	self.viewScrollView = viewScrollView
	self.viewScrollView:setDelegate()
	self:addTreesAndStones()
end
function unchartedView:addTreesAndStones()
	local leftUpTree = display.newSprite("#BG_tree_01.png")
	leftUpTree:addTo(self.viewScrollView, 10)
	leftUpTree:setPosition(250, 1890)
	local leftUpSingleTree = display.newSprite("#BG_tree_02.png")
	leftUpSingleTree:addTo(self.viewScrollView, 10)
	leftUpSingleTree:setPosition(185, 1880)
	local leftMiddleStone = display.newSprite("#BG_undeveloped_plant_02.png")
	leftMiddleStone:addTo(self.viewScrollView, 10)
	leftMiddleStone:setPosition(220, 1630)
	local leftDownStone = display.newSprite("#BG_undeveloped_hill_01.png")
	leftDownStone:addTo(self.viewScrollView, 10)
	leftDownStone:setScale(0.8)
	leftDownStone:setPosition(220, 1370)
	local rightUpTree = display.newSprite("#BG_tree_03.png")
	rightUpTree:addTo(self.viewScrollView, 10)
	rightUpTree:setPosition(670, 1870)
	local rightUpStone = display.newSprite("#BG_undeveloped_surface_02.png")
	rightUpStone:addTo(self.viewScrollView, 10)
	rightUpStone:setPosition(800, 1900)
	local rightMiddleStone = display.newSprite("#BG_undeveloped_surface_01.png")
	rightMiddleStone:addTo(self.viewScrollView, 10)
	rightMiddleStone:setPosition(750, 1550)
	local leftUpCloud = display.newSprite("#cloud_03.png")
	leftUpCloud:addTo(self.viewScrollView, 10)
	leftUpCloud:setPosition(250, 1940)
	local rightUpCloud = display.newSprite("#cloud_10.png")
	rightUpCloud:addTo(self.viewScrollView, 10)
	rightUpCloud:setPosition(900, 2000)
	local rightDownCloud = display.newSprite("#cloud_11.png")
	rightDownCloud:addTo(self.viewScrollView, 10000)
	rightDownCloud:setPosition(900, 1400)
	local rightDownStone = display.newSprite("#BG_undeveloped_plant_01.png")
	rightDownStone:addTo(self.viewScrollView, 10000)
	rightDownStone:setPosition(800, 1200)
	local middleTree = display.newSprite("#BG_tree_03.png")
	middleTree:addTo(self.viewScrollView, 10000)
	middleTree:setPosition(300, 975)
end
function unchartedView:initData(unchartedInfo)
	if not unchartedInfo then
		return
	end
	self.curGridId = unchartedInfo.gridId
	if table.nums(self.numChar) > 0 then
		for i, v in ipairs(self.numChar) do
			v:setVisible(false)
		end
		self.numChar, _ENV = ipairs(self.numChar)
	end
	local remainFreeTimes = self:getFreeTaskRemainTimes(unchartedInfo)
	self.iconHaveFree:setVisible(0 < unchartedInfo.totalReset or 0 < remainFreeTimes)
	_ENV = v.setVisible
	v.setVisible.level = unchartedInfo.curLayer
	self.txtTitle:setString(i18n("common_text_1721", v.setVisible))
	self.txtGold:setString(unchartedInfo.coin)
	self.txtThrow:setString(unchartedInfo.throwFree)
	self:setFourTasksInfo(unchartedInfo.wishInfo, self.txtFirst, self.txtFirstPlan, i18n("Secret_explore_text_08"))
	self:setFourTasksInfo(unchartedInfo.costPWCoin, self.txtSecond, self.txtSecondPlan, i18n("Secret_explore_text_09"))
	self:setFourTasksInfo(unchartedInfo.costPhysical, self.textThird, self.textThirdPlan, i18n("Secret_explore_text_10"))
	self:setFourTasksInfo(unchartedInfo.openChest, self.txtFourth, self.txtFourthPlan, i18n("Secret_explore_text_11"))
	for i, v in ipairs(self.mapGrid) do
		if 5000 < v then
			local remain = v % 5000
			local numChar = cc.Label:createWithCharMap("fonts/font_vip.png", 25, 36, 48)
			numChar:setAnchorPoint(cc.p(0.5, 0.5))
			numChar:setPosition(90, 50)
			numChar:setString(remain)
			numChar:addTo(self.gridTable[i], 10)
			table.insert(self.numChar, numChar)
		end
	end
end
function unchartedView:startThrowDiceAnimation()
	if self.dice then
		self.dice:removeFromParent()
		self.dice = nil
	end
	local spriteName1 = "#uncharted_dice_01.png"
	self.dice = display.newSprite(spriteName1)
	self.dice:setPosition(576, 305)
	self.dice:addTo(self.panelDown)
	local frames = self:getShuffleFrames("et_uncharted_dice_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.05)
	self.dice:playAnimationForever(animation)
	local moveTo = cca.moveTo(0.5, display.width / 2, display.height / 2)
	local callFunc = cca.callFunc(function()
		self:stopThrowDiceAnimationShowCount(self.diceCount)
	end)
	local callFunc1 = cca.callFunc(function()
		self:runCammelToTargetGrid()
	end)
	_UPVALUE3_ = nil
	;(nil)[1] = moveTo
	;(nil)[2] = callFunc
	;(nil)[3] = callFunc1
	local seq = cca.seq(nil)
	self.dice:runAction(seq)
end
function unchartedView:stopThrowDiceAnimationShowCount(count)
	if 1 <= count and count <= 18 then
		self.dice:stopAllActions()
		if self.diceRate and 1 < self.diceRate then
			count = math.floor(count / self.diceRate)
			self:showDiceRateForRunning(self.diceRate)
		end
		self.dice:setSpriteFrame("uncharted_dice_0" .. count .. ".png")
		_ENV = count
		count.delay = 0.5
		function count.onComplete()
			self.dice:setVisible(false)
		end
		transition.execute(self, nil, count)
	else
		self.dice:setVisible(false)
	end
end
function unchartedView:showDiceRateForRunning(times)
	local diceStr = ""
	_ENV, diceStr = "X", "X" .. times
	;("X").color = cc.c3b(255, 255, 0)
	;("X").fontSize = 18
	;("X").pos = cc.p(display.width / 2 + 100, display.height / 2)
	;("X").zOrder = 10
	;("X").duration = 0.4
	;("X").moveH = 155
	;("X").scale = 1.2
	local ("X").font, param = "res/fonts/Arial_Bold_Border.fnt", "X"
	_ENV = display.width / 2 + 100
	;(display.width / 2 + 100).text = diceStr
	;(display.width / 2 + 100).font = param.font
	local waveLabel = display.newBMFontLabel(display.width / 2 + 100)
	waveLabel:addTo(self.panelDown, 10)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
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
end
function unchartedView:getShuffleFrames(pattern, begin, length, isReversed)
	local _ENV, frames
	frames = display.newFrames(pattern, begin, length, isReversed)
	for i = 1, #frames * 2 do
		local a = math.random(#frames)
		local b = math.random(#frames)
		frames[a], frames[b] = frames[b], frames[a]
	end
	return frames
end
function unchartedView:initCammelAnimation(x, y, id)
	if self.cammel then
		self.cammel:removeFromParent()
		self.cammel = nil
	end
	local data = self:getConfigPosition(id + 1)
	data = data or self:getConfigPosition(id)
	self.cammel = display.newSprite(data.image)
	self.cammel:addTo(self.viewScrollView, 1000)
	local frames = display.newFrames("zhencha_yd_" .. data.angle .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 1 / #frames)
	local animate = cc.Animate:create(animation)
	local repeatForever = cca.repeatForever(animate)
	repeatForever:setTag(15)
	self.cammel:setScale(1.3)
	self.cammel:setFlippedX(data.isFlipX)
	self.cammel:runAction(repeatForever)
	self.cammel:setPosition(cc.p(x, y + 15))
	self:moveMapViewToCammel(x, y)
end
function unchartedView:moveMapViewToCammel(x, y)
	pos = self:convertToWorldSpace(cc.p(x, y))
	point = self.viewScrollView:convertToNodeSpace(pos)
	local zoomScale = self.viewScrollView:getZoomScale()
	local centerPoint = cc.p(display.cx, display.cy)
	local covertPoint = self.containerView:convertToNodeSpace(centerPoint)
	local offsetPoint = self.viewScrollView:getContentOffset()
	local subPoint = cc.pSub(covertPoint, point)
	local containerSize = self.containerView:getContentSize()
	local newOffsetPoint = cc.pAdd(offsetPoint, subPoint)
	newOffsetPoint = cc.p(newOffsetPoint.x * zoomScale, newOffsetPoint.y * zoomScale)
	if newOffsetPoint.x > 0 then
		newOffsetPoint.x = 0
	end
	if newOffsetPoint.x < display.width - containerSize.width then
		newOffsetPoint.x = display.width - containerSize.width
	end
	if newOffsetPoint.y > 0 then
		newOffsetPoint.y = 0
	end
	if newOffsetPoint.y < display.height - containerSize.height then
		newOffsetPoint.y = display.height - containerSize.height
	end
	self.viewScrollView:setContentOffsetInDuration(newOffsetPoint, 0.5)
end
function unchartedView:runCammelToTargetGrid()
	local seq = cca.seq()
	local finalGrid = 0
	if 0 >= self.curGridId - self.oldGridId then
		finalGrid = #self.mapGrid
	else
		finalGrid = self.curGridId
	end
	for i = self.oldGridId + 1, finalGrid do
		local moveTo = cca.moveTo(0.5, self.gridTable[i]:getPositionX(), self.gridTable[i]:getPositionY() + 15)
		local callFunc = cca.callFunc(function()
			self.cammel:stopAllActionsByTag(15)
			local data = self:getConfigPosition(i + 1)
			data = data or self:getConfigPosition(i)
			self.cammel:setSpriteFrame(data.image)
			local frames = display.newFrames("zhencha_yd_" .. data.angle .. "_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 1 / #frames)
			local animate = cc.Animate:create(animation)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(15)
			self.cammel:runAction(repeatForever)
			self.cammel:setFlippedX(data.isFlipX)
			self:moveMapViewToCammel(self.gridTable[i]:getPositionX(), self.gridTable[i]:getPositionY())
		end)
		local callFunc1 = cca.callFunc(function()
			if i == self.curGridId then
				i = nil
				;(nil).delay = 0.3
				;(nil).onComplete = function()
					if self.taskInfo.type ~= gUnchartedGridType.BEGIN and self.taskInfo.type ~= gUnchartedGridType.NORMAL and self.taskInfo.type ~= gUnchartedGridType.FINISH and self.taskInfo.data then
						local panel = SoraDCreatePanel("unchartedCommonPopView")
						panel:show()
						panel:initData(self.taskInfo)
						self.clickInterval = false
						panel:setHandle(function()
							self:checkDelayShow()
						end)
					end
					if self.taskInfo.type == gUnchartedGridType.NORMAL and self.taskInfo.data.coin then
						self:getCoinsOrCountsAnimation(self.taskInfo.data.coin, false)
					end
				end
				transition.execute(self, nil, nil)
				i = nil
				;(nil).delay = 0.6 * (self.curGridId - self.oldGridId)
				;(nil).onComplete = function()
					self.btnThrow:setEnabled(true)
					SoraDCloseLoading(self.btnThrow)
				end
				transition.execute(self, nil, nil)
			end
			if i == #self.mapGrid then
				self.gridIcon[i]:setVisible(false)
				self.cammel:setVisible(false)
				local box = display.newSprite("#zwbx_01.png")
				box:addTo(self.gridTable[i], 1000)
				box:setPosition(self.gridIcon[i]:getPositionX(), self.gridIcon[i]:getPositionY())
				local frames = display.newFrames("zwbx_0%d.png", 1, 6)
				local animation = display.newAnimation(frames, 1 / #frames)
				local animate = cc.Animate:create(animation)
				local callFunc = cca.callFunc(function()
					local finishReward = unchartedCtrl:getFinishRewardTable()
					SoraDMailGainItems(finishReward)
				end)
				local callFunc1 = cca.callFunc(function()
					box:setVisible(false)
					self.btnThrow:setEnabled(true)
					SoraDCloseLoading(self.btnThrow)
				end)
				local callFunc2 = cca.callFunc(function()
					if not self.switcher then
						self.switcher = include("switcherView").new()
						self.switcher:showSwitcherInUncharted(self)
					end
					self:refreshMapInfo()
				end)
				local callFunc3 = cca.callFunc(function()
					if self.switcher then
						self.switcher:closeSwitcher()
						self.switcher = nil
						self.clickInterval = false
					end
				end)
				_UPVALUE7_ = self.gridIcon[i]:getPositionY()
				self.gridIcon[i]:getPositionY()[1] = animate
				self.gridIcon[i]:getPositionY()[2] = callFunc
				self.gridIcon[i]:getPositionY()[3] = callFunc1
				self.gridIcon[i]:getPositionY()[4] = cca.delay(1.5)
				self.gridIcon[i]:getPositionY()[5] = callFunc2
				self.gridIcon[i]:getPositionY()[6] = cca.delay(0.5)
				self.gridIcon[i]:getPositionY()[7] = callFunc3
				local seqA = cca.seq(self.gridIcon[i]:getPositionY())
				box:runAction(seqA)
			end
		end)
		_UPVALUE4_ = self.gridTable[i]
		self.gridTable[i][1] = seq
		self.gridTable[i][2] = moveTo
		self.gridTable[i][3] = callFunc
		self.gridTable[i][4] = callFunc1
		seq = cca.seq(self.gridTable[i])
	end
	self.cammel:runAction(seq)
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.oldGridId = unchartedInfo.gridId
end
function unchartedView:gotoFreeTaskView()
	local panel = SoraDCreatePanel("unchartedFreeTaskView")
	panel:show()
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	panel:initData(unchartedInfo)
end
function unchartedView:refreshData(target, data)
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.throwFreeTimes = unchartedInfo.throwFree
	self.taskInfo = unchartedInfo.taskInfo
	self.diceRate = unchartedInfo.diceRate
	self:initData(unchartedInfo)
	if data.msg == "MESSAGE_SERVER_UNCHARTED_THROW_DICE_REFRESH" then
		self.diceCount = self.curGridId - self.oldGridId
		if self.curGridId == #unchartedInfo.mapGrid then
			self.diceCount = math.random(self.curGridId - self.oldGridId, 6)
		end
		self:startThrowDiceAnimation()
	end
	if data.msg == "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK" and data.isOnlyOne and self.taskInfo.bFinish then
		if self.taskInfo.type == gUnchartedGridType.TRADER then
			if self.taskInfo.data and next(self.taskInfo.data) then
				self:getCoinsOrCountsAnimation(self.taskInfo.data.coin, true)
			end
		elseif self.taskInfo.type == gUnchartedGridType.TASK then
			self:getCoinsOrCountsAnimation(200, true)
		elseif self.taskInfo.type == gUnchartedGridType.BOX then
			self.needDelay = true
		elseif self.taskInfo.type == gUnchartedGridType.SURPRICE then
			self.needDelay = true
		end
	end
end
function unchartedView:getCoinsOrCountsAnimation(multiple, isTrader)
	local multiple = multiple / 2
	if 50 <= multiple then
		multiple = 25
	end
	local frmx, frmy = display.cx, display.cy
	local tablePosX = SoraDGetRandNum(multiple, 100, 550)
	local tablePosY = SoraDGetRandNum(multiple, frmy + 100, frmy + 180)
	self:clearAnimationCache(multiple)
	for i = 1, multiple do
		self.resImgArray[i] = nil
		self.resImgArray[i] = cc.Sprite:createWithSpriteFrameName("icon_mjtx_tanxianbi.png")
		self.resImgArray[i]:setPosition(cc.p(frmx, frmy + 50))
		self.resImgArray[i]:addTo(self.panelDown)
		local callFunc = cca.callFunc(function()
			self.resImgArray[i]:removeFromParent()
			self.resImgArray[i] = nil
		end)
		local actionTo0 = cca.jumpTo(0.5, tablePosX[i], tablePosY[i], 50, 2)
		local actionTo1 = cca.delay(0.5)
		local failAction = cca.moveTo(0.5, self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY()))))
		local actionTo2 = cc.EaseExponentialOut:create(failAction)
		_UPVALUE4_ = self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))
		self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))[1] = actionTo0
		self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))[2] = actionTo1
		self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))[3] = actionTo2
		self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))[4] = callFunc
		self.resImgArray[i]:runAction(cca.seq(self.panelDown:convertToNodeSpace(self.imageIcon:convertToWorldSpace(cc.p(self.txtGold:getPositionX(), self.txtGold:getPositionY())))))
		self.resImgArray[i]:setGlobalZOrder(1000)
	end
	if isTrader then
		local sprite = cc.Sprite:createWithSpriteFrameName("icon_mjtx3.png")
		sprite:setPosition(cc.p(frmx, frmy))
		sprite:addTo(self.panelDown)
		local callFunc = cca.callFunc(function()
			sprite:removeFromParent()
		end)
		local actionTo0 = cca.jumpTo(0.5, tablePosX[1], tablePosY[1], 50, 2)
		local actionTo1 = cca.delay(0.5)
		local failAction = cca.moveTo(0.5, self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20))))
		local actionTo2 = cc.EaseExponentialOut:create(failAction)
		_UPVALUE4_ = self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))
		self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))[1] = actionTo0
		self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))[2] = actionTo1
		self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))[3] = actionTo2
		self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))[4] = callFunc
		sprite:runAction(cca.seq(self.panelDown:convertToNodeSpace(self.btnThrow:convertToWorldSpace(cc.p(self.txtThrow:getPositionX(), self.txtThrow:getPositionY() + 20)))))
		sprite:setGlobalZOrder(1000)
	end
	self.clickInterval = false
end
function unchartedView:clearAnimationCache(multiple)
	for i = 1, multiple do
		if self.resImgArray[i] then
			transition.stopTarget(self.resImgArray[i])
			self.panelDown:removeChild(self.resImgArray[i], true)
		end
	end
end
function unchartedView:giveUpTask(target, data)
	SoraDCloseLoading(self)
end
function unchartedView:refreshMapInfo(target, data)
	SoraDCloseLoading(self)
	for i, v in ipairs(self.gridTable) do
		v:setVisible(false)
	end
	for i, v in ipairs(self.gridBtn) do
		v:setVisible(false)
	end
	for i, v in ipairs(self.gridIcon) do
		v:setVisible(false)
	end
	self.gridTable, _ENV, self.gridIcon, _ENV, self.gridBtn, _ENV = ipairs(self.gridIcon)
	self.oldGridId = 1
	local unchartedInfo = unchartedCtrl:getUnchartedInfo()
	self.curGridId = unchartedInfo.gridId
	self.taskInfo = unchartedInfo.taskInfo
	self.mapGrid = unchartedInfo.mapGrid
	local posX, posY, zOrder = 300, 1700, unchartedView.ZORDER
	for i = 1, #self.mapGrid do
		local cell = self.panel:clone()
		local btn = SoraDGetChildByName(cell, "btn_single")
		local icon = SoraDGetChildByName(cell, "image_icon")
		local bottom = SoraDGetChildByName(cell, "Image_49")
		local info = self:getConfigPosition(i)
		posX = posX + info.x
		posY = posY + info.y
		zOrder = zOrder + info.z
		cell:addTo(self.viewScrollView, zOrder)
		btn:setSwallowTouches(false)
		cell:setPosition(cc.p(posX, posY))
		icon:setVisible(self.mapGrid[i] < 5000)
		local image = ""
		if self.mapGrid[i] == gUnchartedGridType.TASK then
			image = "icon_mjtx_renwugezi.png"
		elseif self.mapGrid[i] == gUnchartedGridType.TRADER then
			image = "lvxingshangren.png"
			icon:setContentSize(cc.size(320, 240))
			icon:setScale(0.5)
		elseif self.mapGrid[i] == gUnchartedGridType.SURPRICE then
			image = "icon_mjtx_qiyu.png"
		elseif self.mapGrid[i] == gUnchartedGridType.BOX then
			image = "icon_mjtx_baoxiang.png"
		elseif self.mapGrid[i] == gUnchartedGridType.BEGIN then
			image = "gan.png"
			icon:setContentSize(cc.size(115, 312))
			icon:setScale(0.5)
			icon:setPosition(cc.p(icon:getPositionX() - 50, icon:getPositionY() + 50))
			local spine_flag = sp.SkeletonAnimation:create("spine/qizhi.skel", "spine/qizhi.atlas", 1)
			spine_flag:setPosition(cc.p(icon:getPositionX() + 25, icon:getPositionY() + 100))
			spine_flag:addTo(icon)
			bottom:loadTexture("icon_mjtx2.png", ccui.TextureResType.plistType)
		elseif self.mapGrid[i] == gUnchartedGridType.FINISH then
			image = "zwbx_01.png"
		elseif self.mapGrid[i] > 5000 then
			bottom:loadTexture("icon_mjtx2.png", ccui.TextureResType.plistType)
		end
		icon:loadTexture(image, ccui.TextureResType.plistType)
		table.insert(self.gridBtn, btn)
		table.insert(self.gridTable, cell)
		table.insert(self.gridIcon, icon)
		self:refreshItemBtnEffect(cell, self.mapGrid[i])
	end
	self:initData(unchartedInfo)
	for i, v in ipairs(self.mapGrid) do
		self.gridBtn[i]:setTag(v)
	end
	self:initCammelAnimation(self.gridTable[self.oldGridId]:getPositionX(), self.gridTable[self.oldGridId]:getPositionY(), self.oldGridId)
end
function unchartedView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_ADVENTURE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function unchartedView:createBaseBg()
	local layer = ccui.Layout:create()
	layer:setTouchEnabled(false)
	local size = cc.size(1000, 2050)
	layer:setContentSize(size)
	self.viewSize = size
	return layer
end
function unchartedView:getConfigPosition(i)
	if coordinatePoints[i] then
		local dir = coordinatePoints[i].dir
		return FourDirection[dir]
	end
end
function unchartedView:getFreeTaskRemainTimes(unchartedInfo)
	local totalTimes = 0
	if unchartedInfo.wishInfo then
		totalTimes = totalTimes + unchartedInfo.wishInfo.cando
	end
	if unchartedInfo.costPWCoin then
		totalTimes = totalTimes + unchartedInfo.costPWCoin.cando
	end
	if unchartedInfo.costPhysical then
		totalTimes = totalTimes + unchartedInfo.costPhysical.cando
	end
	if unchartedInfo.openChest then
		totalTimes = totalTimes + unchartedInfo.openChest.cando
	end
	return totalTimes
end
function unchartedView:setFourTasksInfo(infoTable, textUp, textDown, taskName)
	if table.nums(infoTable) > 0 and textUp and textDown then
		local commonStr = string.format("%s %d/%d", taskName, infoTable.plan, infoTable.need)
		textUp:setString(commonStr)
		local commonCanDoStr = string.format("(%s %d/%d)", i18n("Secret_explore_text_45"), infoTable.cando, infoTable.maxdo)
		textDown:setString(commonCanDoStr)
		textUp:setColor(0 < infoTable.cando and CORLOR_NORMAL or CORLOR_GREY)
		textDown:setColor(0 < infoTable.cando and CORLOR_GREEN or CORLOR_GREY)
	end
end
function unchartedView:isHaveFreeTimesToThrow()
	if self.throwFreeTimes > 0 then
		if not self.clickInterval then
			SoraDShowLoading(self.btnThrow)
			self.btnThrow:setEnabled(false)
			unchartedCtrl:sendThrowDiceMsg(gUnchartedThrowDiceType.FREE)
			self.clickInterval = true
		end
	elseif lordInfoCtrl:getBaseInfo().gold < 200 then
		SoraDShowMsgBox(i18n("Secret_explore_notice_01"), i18n("common_text_054"), i18n("common_text_185"), function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				self:gotoFreeTaskView()
			end
		end)
	else
		local panel = SoraDCreatePanel("unchartedBuyFreeThrowView")
		panel:show()
	end
end
function unchartedView:singleClickCallBack(button, type)
	if type == ccui.TouchEventType.ended and button:getTag() == gUnchartedGridType.FINISH then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("unchartedFinalGridRewardView")
		panel:show()
	end
end
function unchartedView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.LOST_ADVENTURE)
	end
end
function unchartedView:storeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("unchartedStoreView")
		panel:show()
	end
end
function unchartedView:rewardClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("unchartedRewardView")
		panel:show()
	end
end
function unchartedView:taskClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:gotoFreeTaskView()
	end
end
function unchartedView:throwClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.taskInfo.bFinish and self.taskInfo.type == gUnchartedGridType.TRADER then
			SoraDShowMsgBox(i18n("Secret_explore_notice_05"), i18n("Secret_explore_text_14"), i18n("Secret_explore_text_13"), function(exitType)
				if MSGBOX_CALLBACK_YES == exitType then
					local panel = SoraDCreatePanel("unchartedCommonPopView")
					panel:show()
					panel:initData(self.taskInfo)
				elseif MSGBOX_CALLBACK_NO == exitType then
					unchartedCtrl:sendGiveUpRewardsMsg()
					SoraDShowLoading(self)
				end
			end)
			return
		end
		if not self.taskInfo.bFinish and self.taskInfo.type ~= gUnchartedGridType.NORMAL and self.curGridId > 1 and self.curGridId <= table.nums(self.mapGrid) then
			SoraDShowMsgBox(i18n("Secret_explore_notice_04"), i18n("Secret_explore_text_12"), i18n("Secret_explore_text_13"), function(exitType)
				if MSGBOX_CALLBACK_YES == exitType then
					local panel = SoraDCreatePanel("unchartedCommonPopView")
					panel:show()
					panel:initData(self.taskInfo)
				elseif MSGBOX_CALLBACK_NO == exitType then
					unchartedCtrl:sendGiveUpRewardsMsg()
					SoraDShowLoading(self)
				end
			end)
		elseif self.taskInfo.type == gUnchartedGridType.TASK and self.taskInfo.data.coin and table.nums(self.taskInfo.data) > 0 then
			SoraDShowMsgBox(i18n("Secret_explore_notice_07"), i18n("common_text_204"), nil, function(exitType)
				if MSGBOX_CALLBACK_YES == exitType then
					local panel = SoraDCreatePanel("unchartedCommonPopView")
					panel:show()
					panel:initData(self.taskInfo)
				end
			end)
		else
			self:isHaveFreeTimesToThrow()
		end
	end
end
function unchartedView:setThrowEffect(...)
	local effectNode = SoraDCreatAnimation("touzhi")
	effectNode:setPosition(cc.p(47, 46))
	self.btnThrow:addChild(effectNode)
	local sp = SoraDGetChildByName(effectNode, "gddaf_1")
	if sp:isOpacityModifyRGB() then
		sp:setBlendFunc(gl.ONE, gl.ONE)
	else
		sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
end
function unchartedView:setItemBtnEffect(cell)
	local effectNode_1 = SoraDCreatAnimation("gezi_di")
	cell.gezi_di = effectNode_1
	effectNode_1:setPosition(cc.p(90, 50))
	cell:addChild(effectNode_1)
	local effectNode_2 = SoraDCreatAnimation("gezi_gao")
	cell.gezi_gao = effectNode_2
	effectNode_2:setPosition(cc.p(90, 50))
	cell:addChild(effectNode_2)
end
function unchartedView:refreshItemBtnEffect(cell, type)
	if not cell.gezi_di and not cell.gezi_gao then
		self:setItemBtnEffect(cell)
	end
	if type == gUnchartedGridType.TASK or type == gUnchartedGridType.TRADER then
		cell.gezi_di:setVisible(false)
		cell.gezi_gao:setVisible(true)
	elseif type == gUnchartedGridType.SURPRICE or type == gUnchartedGridType.BOX then
		cell.gezi_di:setVisible(true)
		cell.gezi_gao:setVisible(false)
	else
		cell.gezi_di:setVisible(false)
		cell.gezi_gao:setVisible(false)
	end
end
function unchartedView:checkDelayShow()
	if self.needDelay then
		local isTrader = false
		if self.taskInfo.type == gUnchartedGridType.SURPRICE and self.taskInfo.data.type == gUnchartedSurpriseType.ADD_THROW then
			isTrader = true
		end
		self:getCoinsOrCountsAnimation(self.taskInfo.data.coin, isTrader)
		self.needDelay = false
	end
end
return unchartedView
