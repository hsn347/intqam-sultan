local ctGridScroll = include("ctGridScroll")
local PyramidBattleManager = class("pyramidBattleManager", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleManager")
	end
	return target
end)
function PyramidBattleManager:ctor()
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_manager"):setTitle(i18n("common_text_3317"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_manager")
	self.scroll = ctGridScroll.new(self.scroll)
	self.txtPeople = SoraDGetChildByName(self, "Text_people")
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_264"))
	SoraDGetChildByName(self, "Text_state"):setString(i18n("common_text_3336"))
	SoraDGetChildByName(self, "Text_force"):setString(i18n("common_text_090"))
	SoraDGetChildByName(self, "Text_probability"):setString(i18n("common_text_3332"))
	SoraDGetChildByName(self, "Text_tip"):setString(i18n("common_text_3337"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_APPOINTINFOBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MANAGERCALLBACK", handler(self, self.bindData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MANAGERCALLBACKERR", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ALLIANCEQUIT", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	self:createSingleClass()
	self:req4Info()
end
function PyramidBattleManager:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	pyramidWarCtrl:pyramidwarGetAppointInfoReq()
end
function PyramidBattleManager:createSingleClass()
	self.singleClass = class("PyramidBattleManagerSingle", function()
		local target = self.copyItem:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.imgHead = self:getChildByName("Image_itemHead")
		self.btnClose = self:getChildByName("Button_itemClose")
		self.btnOpen = self:getChildByName("Button_itemOpen")
		self.txtState = self:getChildByName("Text_itemState")
		self.txtName = self:getChildByName("Text_itemName")
		self.txtForce = self:getChildByName("Text_itemForce")
		self.txtGailv = self:getChildByName("Text_itemProbability")
		self.imgItemBg = self:getChildByName("Image_itemBg")
		self.imgAllianceLevel = self:getChildByName("Image_itemLevel")
		self.btnClose:setTitleText(i18n("common_text_184"))
		self.btnOpen:setTitleText(i18n("common_text_3333"))
		self:setSwallowTouches(false)
		self.imgHead:setTouchEnabled(true)
		self.imgHead:addTouchEventListener(handler(self, self.headClick))
		self.btnClose:addTouchEventListener(handler(self, self.btnCloseClick))
		self.btnOpen:addTouchEventListener(handler(self, self.btnOpenClick))
	end
	function self.singleClass:setIsMe(bool)
		self.isMe = bool
	end
	function self.singleClass:initData(info)
		self.initData = info
		self:initView()
	end
	function self.singleClass:initView(...)
		local allianceDesRead = include("allianceDesRead")
		SoraDGetHeadFromManager(self.imgHead, self.initData.iconID, self.initData.avatar)
		self.imgAllianceLevel:loadTexture(allianceDesRead.getIcon(self.initData.rank), ccui.TextureResType.plistType)
		if self.initData.rank == gAllianceRank.OFFICIAL then
			self.imgAllianceLevel:setScale(1.0)
		else
			self.imgAllianceLevel:setScale(0.6)
		end
		self.txtName:setString(self.initData.nickName)
		self.txtForce:setString(string.formatnumberthousands(self.initData.power))
		self.txtGailv:setString(string.format("%.1f", self.initData.joinRate * 100) .. "%")
		self.imgItemBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		self:changeMode(self.initData.state)
		if self.isMe then
			self.imgItemBg:loadTexture("frame_alliance_pank_02.png", ccui.TextureResType.plistType)
			self.txtName:setColor(cc.c3b(255, 233, 200))
			self.txtForce:setColor(cc.c3b(255, 233, 200))
		end
	end
	function self.singleClass:changeMode(_state)
		if _state == gMemberState.NO_APPOINT then
			self.btnClose:setVisible(false)
			self.btnOpen:setVisible(true)
			self.txtState:setString("")
		elseif _state == gMemberState.APPOINT_ED then
			self.btnClose:setVisible(true)
			self.btnOpen:setVisible(false)
			self.txtState:setString("")
			self.imgItemBg:loadTexture("frame_alliance_pank_06.png", ccui.TextureResType.plistType)
		elseif _state == gMemberState.ENTER_BATTLE then
			self.btnClose:setVisible(false)
			self.btnOpen:setVisible(false)
			self.txtState:setColor(cc.c3b(255, 255, 255))
			self.txtState:setString(i18n("common_text_3334"))
		elseif _state == gMemberState.CANNOT_APPOINT then
			self.btnClose:setVisible(false)
			self.btnOpen:setVisible(false)
			self.txtState:setColor(cc.c3b(155, 155, 155))
			self.txtState:setString(i18n("common_text_3335"))
		end
		if not self:judgeAllianceLevel(true) then
			self.btnClose:setVisible(false)
			self.btnOpen:setVisible(false)
			if self.isMe and _state == gMemberState.NO_APPOINT then
				self.txtState:setString(i18n("pyramid_columntext_01"))
				self.txtState:setColor(cc.c3b(161, 156, 152))
			end
		end
	end
	function self.singleClass:panelClick(panel, eventType)
		if gMemberState.APPOINT_ED == self.initData.state and self.singleCb then
			self.singleCb(panel, eventType)
		end
	end
	function self.singleClass:judgeAllianceLevel(notShow)
		local ret = true
		local gametop = gModuleMgr.getObject("gametop")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank <= RANK_TOP_SPECIAL then
			ret = false
			if not notShow then
				SoraDShowMsgTip(i18n("common_text_3407"))
			end
		end
		return ret
	end
	function self.singleClass:judgePeopleMax(...)
		local ret = true
		if self.pPanel:getInWarPeople() >= APPOINT_MAX then
			ret = false
			SoraDShowMsgTip(i18n("common_text_3406"))
		end
		return ret
	end
	function self.singleClass:btnCloseClick(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("撤销")
			SoraDPlaySound()
			if self:judgeAllianceLevel() then
				SoraDShowLoading(self.pPanel)
				local gametop = gModuleMgr.getObject("gametop")
				local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
				pyramidWarCtrl:pyramidwarCancelAppointReq(self.initData.uid)
			end
		end
	end
	function self.singleClass:btnOpenClick(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("出战")
			SoraDPlaySound()
			if self:judgeAllianceLevel() and self:judgePeopleMax() then
				SoraDShowLoading(self.pPanel)
				local gametop = gModuleMgr.getObject("gametop")
				local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
				pyramidWarCtrl:pyramidwarAppointReq(self.initData.uid)
			end
		end
	end
	function self.singleClass:headClick(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			print("领主信息")
			SoraDPlaySound()
			local gametop = gModuleMgr.getObject("gametop")
			local kid = gametop.playertop_:getKingdomID()
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			_ENV = nil
			;(nil).targetName = self.__cname
			local playerData = lordInfoCtrl:getLordInfoByUid(self.initData.uid, kid, nil)
		end
	end
	function self.singleClass:setCallBack(handl)
		self.singleCb = handl
	end
	function self.singleClass:setPPanel(panel)
		self.pPanel = panel
	end
end
function PyramidBattleManager:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
function PyramidBattleManager:closeMe(target, redata)
	self:close(nil, ccui.TouchEventType.ended)
end
function PyramidBattleManager:bindData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "PyramidBattleManager:bindData")
	dump(self.infoTbl, "self.infoTbl1")
	for k, v in pairs(self.infoTbl) do
		if tostring(v.uid) == tostring(redata.uid) then
			v.state = redata.state
		end
	end
	dump(self.infoTbl, "self.infoTbl2")
	self:initView()
end
function PyramidBattleManager:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "PyramidBattleManager")
	self.infoTbl = redata.info
	self:initView()
end
function PyramidBattleManager:getInWarPeople(...)
	return self.inWarPeople
end
function PyramidBattleManager:singleTouch(panel, eventType)
	if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif eventType == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(panel:getTouchBeganPosition())
		self:openItem(panel, pos)
	end
end
function PyramidBattleManager:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:setNoTitleStyle()
	self.pFloor:customDes(i18n("common_text_4257"))
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y)
		else
			self.pFloor:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y)
	else
		self.pFloor:setPosition(pos.x, pos.y)
	end
	self.pFloor:addTo(self, 100)
end
function PyramidBattleManager:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local playerID = gametop.playertop_:getPlayerID()
	local _ENV, tmpTbl = gametop.playertop_, gametop.playertop_
	for _, v in pairs(self.infoTbl) do
		_ENV = nil
		;(nil).data = v
		table.insert(tmpTbl, nil)
	end
	if table.nums(tmpTbl) > 1 then
		table.sort(tmpTbl, function(a, b)
			return a.data.power > b.data.power
		end)
	end
	local createFun = function(data)
		local cSingle = self.singleClass.new()
		cSingle:setIsMe(tonumber(playerID) == tonumber(data.uid))
		cSingle:setPPanel(self)
		cSingle:setCallBack(handler(self, self.singleTouch))
		cSingle:initData(data)
		return cSingle
	end
	if not self.fistInit then
		self.scroll:init(tmpTbl, createFun, self.copyItem:getContentSize())
		self.scroll:begin2Run()
		self.fistInit = true
	else
		self.scroll:setNewTable(tmpTbl)
	end
	self.inWarPeople = 0
	for k, v in pairs(self.infoTbl) do
		if v.state == gMemberState.APPOINT_ED or v.state == gMemberState.ENTER_BATTLE then
			self.inWarPeople = self.inWarPeople + 1
		end
	end
	_ENV = self.copyItem:getContentSize()
	self.copyItem:getContentSize().cur = self.inWarPeople
	self.copyItem:getContentSize().max = APPOINT_MAX
	self.txtPeople:setString(i18n("common_text_3408", self.copyItem:getContentSize()))
end
function PyramidBattleManager:serverMessageGetLordInfo(target, data)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return PyramidBattleManager
