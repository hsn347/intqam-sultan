local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local WatchTowerDetailSoulView = class("watchTowerDetailSoulView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("watchTowerDetailSoulView")
	end
	return target
end)
function WatchTowerDetailSoulView:ctor()
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.txtAim = SoraDGetChildByName(self, "Text_aim")
	self.txtPos = SoraDGetChildByName(self, "Text_position")
	self.nodeTarget = SoraDGetChildByName(self, "Node_target")
	self.attackBar = SoraDGetExtendChildFromCCSByName(self, "CCS_watchTowerProgressBar_watchTowerDetail")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_watchTowerDetail")
	self.txtTotalArmy = SoraDGetChildByName(self, "Text_totalCount")
	self.btnArmyBar = SoraDGetChildByName(self, "Top_Button_army")
	self.btnScienceBar = SoraDGetChildByName(self, "Button_science")
	_UPVALUE3_, self.btnTalentBar = SoraDGetChildByName(self, "Button_talent"), SoraDGetChildByName(self, "Button_talent")
	self.barsTbl, SoraDGetChildByName(self, "Button_talent")[1] = SoraDGetChildByName(self, "Button_talent"), self.btnArmyBar
	self.barsTbl, SoraDGetChildByName(self, "Button_talent")[2] = SoraDGetChildByName(self, "Button_talent"), self.btnScienceBar
	self.barsTbl, SoraDGetChildByName(self, "Button_talent")[3] = SoraDGetChildByName(self, "Button_talent"), self.btnTalentBar
	self.scrollMain = SoraDGetChildByName(self, "ScrollView_watchTowerDetail")
	self.scrollScience = SoraDGetChildByName(self, "ScrollView_science")
	_UPVALUE3_, self.scrollTalent = SoraDGetChildByName(self, "ScrollView_talent"), SoraDGetChildByName(self, "ScrollView_talent")
	self.scrollsTbl, SoraDGetChildByName(self, "ScrollView_talent")[1] = SoraDGetChildByName(self, "ScrollView_talent"), self.scrollMain
	self.scrollsTbl, SoraDGetChildByName(self, "ScrollView_talent")[2] = SoraDGetChildByName(self, "ScrollView_talent"), self.scrollScience
	self.scrollsTbl, SoraDGetChildByName(self, "ScrollView_talent")[3] = SoraDGetChildByName(self, "ScrollView_talent"), self.scrollTalent
	self.btn_head = SoraDGetChildByName(self, "Button_head")
	self.btn_head:setPressedActionEnabled(false)
	self.btnBack = SoraDGetChildByName(self, "Button_back")
	self.btnBack:setVisible(false)
	self.txtTotalArmyTitle = SoraDGetChildByName(self, "Text_totalArmyTitle")
	self.txtTotalArmyTitle:setString(i18n("common_text_584"))
	self.btnHide = SoraDGetChildByName(self, "Button_hide")
	self.btnHide:setTitleText(i18n("common_text_1266"))
	self.btnHide:setTouchEnabled(false)
	self.btnHide:setBright(false)
	self.btnHide:addTouchEventListener(handler(self, self.btnHideClick))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Image_headBg"):setFillType(1)
	SoraDAutoSizeButtonText(self.btnHide, cc.size(200, 65))
	self:rangeScrollHeigh()
	self:rangeBars()
end
function WatchTowerDetailSoulView:rangeBars(num)
	num = num or 3
	local barH = self.btnArmyBar:getContentSize().height
	local downImgH = SoraDGetChildByName(self, "Bottom_Image_backgroud"):getContentSize().height
	_ENV, _ENV = "Bottom_Image_backgroud", SoraDGetChildByName(self, "Bottom_Image_backgroud")
	local _ENV, upTbl, downTbl, haveBars = nil, SoraDGetChildByName(self, "Bottom_Image_backgroud"), "Bottom_Image_backgroud", nil
	for i = 1, num do
		table.insert(upTbl, self.barTopY - barH / 2 - (i - 1) * barH)
		table.insert(downTbl, downImgH + barH * i - barH / 2)
		table.insert(haveBars, self.barsTbl[i])
	end
	local barCallBack = function(bar, eventType)
		if eventType == ccui.TouchEventType.ended then
			local findIt = false
			for i, v in ipairs(haveBars) do
				local arrow = v:getChildByName("frame_arrow")
				if findIt then
					v:setPositionY(downTbl[#haveBars - i + 1])
				else
					v:setPositionY(upTbl[i])
				end
				if v == bar then
					findIt = true
					self.scrollsTbl[i]:setVisible(true)
					arrow:setRotation(0)
				else
					self.scrollsTbl[i]:setVisible(false)
					arrow:setRotation(SoraDFPosX(90, 0))
				end
			end
		end
	end
	for i, v in ipairs(haveBars) do
		v:setPressedActionEnabled(false)
		v:addTouchEventListener(barCallBack)
	end
	for i, v in ipairs(self.barsTbl) do
		if not haveBars[i] then
			v:setVisible(false)
		end
	end
end
function WatchTowerDetailSoulView:rangeScrollHeigh(num)
	num = num or 3
	self.barTopY = self.btnArmyBar:getPositionY() + self.btnArmyBar:getContentSize().height / 2
	local scrollH = self.barTopY - self.btnArmyBar:getContentSize().height * num - SoraDGetChildByName(self, "Bottom_Image_backgroud"):getContentSize().height
	local sSize = self.scrollMain:getContentSize()
	self.scrollMain:setContentSize(cc.size(sSize.width, scrollH))
	self.scrollScience:setContentSize(cc.size(sSize.width, scrollH))
	self.scrollTalent:setContentSize(cc.size(sSize.width, scrollH))
end
function WatchTowerDetailSoulView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO", handler(self, self.reciveData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO", handler(self, self.reciveData))
end
function WatchTowerDetailSoulView:reciveData(target, redata)
	if self.myQueueObj and redata and redata.indexID == self.myQueueObj:getId() then
		if "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO" == redata.msg then
			SoraDRemoveAllPrePanelFromManager(self)
		elseif "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO" == redata.msg then
			self:afterInitData(redata.data:getFilterDataByWatchTower())
		end
	end
end
function WatchTowerDetailSoulView:afterInitData(qOBJ)
	self.scrollMain:removeAllChildren()
	self.myQueueObj = qOBJ
	self:initView()
end
function WatchTowerDetailSoulView:initView(...)
	local fromData = self.myQueueObj:getFrom()
	self:checkIgnoreBtn()
	self.txtName:setString(i18n("common_text_1222"))
	self.imgHead:loadTexture("roman_full.png", ccui.TextureResType.plistType)
	if fromData then
		self.txtPos:setTouchEnabled(true)
		self.txtPos:setTouchScaleChangeEnabled(true)
		if fromData.x and fromData.y then
			_ENV = i18n("common_text_1222")
			i18n("common_text_1222").x = fromData.x
			i18n("common_text_1222").y = fromData.y
			self.txtPos:setString(i18n("common_text_2155", i18n("common_text_1222")))
		else
			_ENV = i18n("common_text_2155", i18n("common_text_1222"))
			i18n("common_text_2155", i18n("common_text_1222")).x = "???"
			i18n("common_text_2155", i18n("common_text_1222")).y = "???"
			self.txtPos:setString(i18n("common_text_2155", i18n("common_text_2155", i18n("common_text_1222"))))
		end
		self.txtPos:addTouchEventListener(handler(self, self.panelFromPosClick))
		SoraDDrawTextUnderLine(self.txtPos, cc.c4b(45, 187, 196, 255))
	end
	local toData = self.myQueueObj:getTo()
	if toData then
		self.nodeTarget:setVisible(true)
		local Text_targetPos = self.nodeTarget:getChildByName("Text_targetPos")
		Text_targetPos:setString("X:" .. toData.x .. " Y:" .. toData.y)
		Text_targetPos:setTouchEnabled(true)
		Text_targetPos:setTouchScaleChangeEnabled(true)
		Text_targetPos:addTouchEventListener(handler(self, self.panelToPosClick))
		SoraDDrawTextUnderLine(Text_targetPos, cc.c4b(45, 187, 196, 255))
		if toData.mapType then
			local mapObjUtil = include("mapObjUtil")
			self.nodeTarget:getChildByName("Text_target"):setString(mapObjUtil.reOutDoor(toData))
		end
	else
		self.nodeTarget:setVisible(false)
	end
	if fromData.lv then
		_ENV = mapObjUtil.reOutDoor(toData)
		mapObjUtil.reOutDoor(toData).num = fromData.lv
		self.txtLevel:setString(i18n("common_text_1236", mapObjUtil.reOutDoor(toData)))
	else
		_ENV = i18n("common_text_1236", mapObjUtil.reOutDoor(toData))
		i18n("common_text_1236", mapObjUtil.reOutDoor(toData)).num = "???"
		self.txtLevel:setString(i18n("common_text_1236", i18n("common_text_1236", mapObjUtil.reOutDoor(toData))))
	end
	self:class2Load()
end
function WatchTowerDetailSoulView:showTotalArmy(_num, _title)
	dump(_num, "_num")
	if _num then
		self.txtTotalArmy:setString(type(_num) == "number" and string.formatnumberthousands(_num) or _num)
	else
		_ENV = nil
		;(nil).level = WATCH_TOWER_VIEW_ARMYTOTALCOUNT
		self.txtTotalArmy:setString(i18n("common_text_596", nil))
	end
	if _title then
		self.txtTotalArmyTitle:setString(_title)
	end
end
function WatchTowerDetailSoulView:class2Load(...)
	self:rangeScrollHeigh(1)
	self:rangeBars(1)
	self:setTitle(i18n("common_text_008"))
	self.txtAim:setColor(display.COLOR_RED)
	self.txtAim:setString(i18n("common_text_008"))
	self.attackBar:initData(self.myQueueObj:getStatusRemainTime(), self.myQueueObj:getOrgStatusTotalTime())
	self:showTotalArmy(self.myQueueObj:getFrom().totalCount, i18n("common_text_584"))
	self:showSingleArmy()
end
function WatchTowerDetailSoulView:showSingleArmy(...)
	local armyItemH = 80
	local createImageBg = function(...)
		local imageBg = self.scrollMain:getChildByName("Image_abg")
		if imageBg then
			return imageBg
		else
			local Fimage = SoraDCreateCSBNode("watchTowerDetailArmySingle")
			local image = Fimage:getChildByName("Image_abg"):clone()
			function image:setMyHeigh(heigh)
				local mySize = image:getContentSize()
				image:setContentSize(cc.size(mySize.width, heigh))
			end
			image:addTo(self.scrollMain, 1)
			return image
		end
	end
	local addTextToPanel = function(fPanel, text)
		local noMsg = ccui.Text:create(text, "", 22)
		noMsg:ignoreContentAdaptWithSize(false)
		noMsg:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		noMsg:setAnchorPoint(cc.p(0.5, 0.5))
		noMsg:setContentSize(cc.size(580, 56))
		local imgSize = fPanel:getContentSize()
		noMsg:setPosition(imgSize.width / 2, imgSize.height / 2)
		noMsg:addTo(fPanel)
	end
	local armyData = self.myQueueObj:getFromArmy()
	if armyData and next(armyData) then
		local sSize = self.scrollMain:getContentSize()
		local sH = math.max(#armyData * armyItemH + 20, sSize.height)
		self.scrollMain:setInnerContainerSize(cc.size(sSize.width, sH))
		for i, v in ipairs(armyData) do
			local item = SoraDCreatePanel("watchTowerDetailArmyItem")
			item:initData(v)
			item:addTo(self.scrollMain, 2)
			item:setPosition(sSize.width / 2, sH - (i - 1) * armyItemH - 10)
			if i == 1 then
				SoraDGetChildByName(item, "Image_line"):setVisible(false)
			end
		end
		local imageBg = createImageBg()
		imageBg:setPosition(sSize.width / 2, sH)
		imageBg:setMyHeigh(#armyData * armyItemH + 20)
	else
		local sSize = self.scrollMain:getContentSize()
		local panel = SoraDCreateCSBNode("watchTowerDetailScience")
		panel:addTo(self.scrollMain)
		local panelH = panel:getChildByName("Image_bgMiddle"):getContentSize().height
		local sH = math.max(panelH, sSize.height)
		panel:setPosition(sSize.width / 2, sH)
		_ENV = SoraDGetChildByName(item, "Image_line").setVisible
		SoraDGetChildByName(item, "Image_line").setVisible.level = WATCH_TOWER_VIEW_ARMYCLASS
		addTextToPanel(panel:getChildByName("Image_bgMiddle"), i18n("common_text_596", SoraDGetChildByName(item, "Image_line").setVisible))
		self.scrollMain:setInnerContainerSize(cc.size(sSize.width, sH))
	end
end
function WatchTowerDetailSoulView:setTitle(str)
	_ENV = nil
	;(nil).type = str
	self.txtAim:setString(i18n("common_text_3516", nil))
	self.windowTitle:setTitle(str)
end
function WatchTowerDetailSoulView:panelFromPosClick(panel, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myQueueObj:getFromX() and self.myQueueObj:getFromY() then
			SoraDGotoWorldMapPoint(cc.p(self.myQueueObj:getFromX(), self.myQueueObj:getFromY()), true)
			SoraDRemoveAllPrePanelFromManager(self)
		else
			_ENV = self.myQueueObj:getFromY()
			self.myQueueObj:getFromY().level = WATCH_TOWER_VIEW_ARRIVEPOS_LV
			SoraDShowMsgTip(i18n("common_text_596", self.myQueueObj:getFromY()))
		end
	end
end
function WatchTowerDetailSoulView:panelToPosClick(panel, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myQueueObj:getTo() then
			SoraDGotoWorldMapPoint(cc.p(self.myQueueObj:getToX(), self.myQueueObj:getToY()), true)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	end
end
function WatchTowerDetailSoulView:checkIgnoreBtn(...)
	if not kingdomMapCtrl:getWatchTowerQueue():isIgnoreRomanSoul() then
		self.btnHide:setTouchEnabled(true)
		self.btnHide:setBright(true)
	end
end
function WatchTowerDetailSoulView:btnHideClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_1504"), i18n("common_text_204"), nil, function(msgType)
			if MSGBOX_CALLBACK_YES == msgType then
				kingdomMapCtrl:getWatchTowerQueue():ignoreRomanSoul()
				_ENV = kingdomMapCtrl:getWatchTowerQueue()
				kingdomMapCtrl:getWatchTowerQueue().msg = "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL"
				SoraDSendMessage((kingdomMapCtrl:getWatchTowerQueue()))
				self.btnHide:setTouchEnabled(false)
				self.btnHide:setBright(false)
			end
		end)
	end
end
return WatchTowerDetailSoulView
