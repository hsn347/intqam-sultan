local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceDesRead = include("allianceDesRead")
local PyramidBattleHonourBoard = class("pyramidBattleHonourBoard", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleHonourBoard")
	end
	return target
end)
function PyramidBattleHonourBoard:ctor()
	self.top3Data, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSearch")
	self.nodeTitle:setTitle(i18n("common_text_4010"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_main")
	self.imgCopy = SoraDGetChildByName(self, "Panel_single")
	self.labelTip = SoraDGetChildByName(self, "Center_Text_tip")
	self.labelTip:setString(i18n("common_text_4058"))
	self.labelTip:setVisible(true)
	self.txtOnePeople = SoraDGetChildByName(self, "Text_people")
	self.imgOnePeople = SoraDGetChildByName(self, "Image_people")
	self.txtOnePower = SoraDGetChildByName(self, "Text_power")
	self.imageOnePower = SoraDGetChildByName(self, "Image_power")
	self.txtOneName = SoraDGetChildByName(self, "Text_name")
	self.txtOneKing = SoraDGetChildByName(self, "Text_king")
	self.nodeOneFlag = SoraDGetChildByName(self, "Node_flag")
	self.btnOneHistory = SoraDGetChildByName(self, "Button_oneAlliance")
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(100)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(100)
	nodeFireR:addTo(self.Node_fire_R)
	self.Sprite_rank = SoraDGetChildByName(self, "Sprite_rank")
	self.btnHistory = SoraDGetChildByName(self, "Button_history")
	self.btnHistory:addTouchEventListener(handler(self, self.btnHistoryClick))
	self.btnHistory:setTitleText(i18n("pyramid_btn_01"))
	SoraDAutoSizeButtonText(self.btnHistory)
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self:createSingleClass()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqAllianceInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_FAIL_BACK", handler(self, self.sMsgReqAllianceInfoBack))
end
function PyramidBattleHonourBoard:sMsgReqAllianceInfoBack(target, data)
	if data.clientData then
		if data.err and data.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
			SoraDShowMsgTip(i18n("common_text_4346"))
		else
			local from = data.clientData.from
			if from == "pyramidBattleHonourBoard" then
				local alliance = data.alliance
				SoraDOpenAllianceInfoView(alliance)
			end
		end
	end
	SoraDCloseLoading(self)
end
function PyramidBattleHonourBoard:initData(...)
	self:initView()
end
function PyramidBattleHonourBoard:initView(...)
	dump(pyramidWarCtrl.top4Alliance, "pyramidWarCtrl.top4Alliance")
	local oneAllianceData = pyramidWarCtrl.top4Alliance[tostring(1)]
	if oneAllianceData then
		_ENV = nil
		;(nil).member = oneAllianceData.info.memnum
		;(nil).total = oneAllianceData.info.limitCount or 50
		self.txtOnePeople:setString(i18n("common_text_155", nil))
		self.txtOnePower:setString(string.formatnumberthousands(oneAllianceData.info.power))
		_ENV = string.formatnumberthousands(oneAllianceData.info.power)
		_ENV = string.formatnumberthousands(oneAllianceData.info.power)
		string.formatnumberthousands(oneAllianceData.info.power).abbr = oneAllianceData.info.abbr
		string.formatnumberthousands(oneAllianceData.info.power).name = oneAllianceData.info.name
		string.formatnumberthousands(oneAllianceData.info.power).conten = i18n("common_text_186", string.formatnumberthousands(oneAllianceData.info.power))
		self.txtOneName:setString(i18n("common_text_925", string.formatnumberthousands(oneAllianceData.info.power)))
		_ENV = i18n("common_text_925", string.formatnumberthousands(oneAllianceData.info.power))
		i18n("common_text_925", string.formatnumberthousands(oneAllianceData.info.power)).name = oneAllianceData.info.kname
		self.txtOneKing:setString(i18n("common_text_971", i18n("common_text_925", string.formatnumberthousands(oneAllianceData.info.power))))
		allianceDesRead.getFlagWithParticle(oneAllianceData.info.flag, self.nodeOneFlag)
		self.btnOneHistory:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				local allianceQuery = gametop.playertop_:getModule("allianceQuery")
				SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard"))
				_ENV = SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard")
				SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard").from = "pyramidBattleHonourBoard"
				allianceQuery:reqAllianceInfo(oneAllianceData.info.kid, oneAllianceData.info.aid, SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard"))
			end
		end)
	end
	local isVisible = oneAllianceData ~= nil
	self.imgOnePeople:setVisible(isVisible)
	self.imageOnePower:setVisible(isVisible)
	self.Sprite_rank:setVisible(isVisible)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, (table.nums(pyramidWarCtrl.top4Alliance) - 1) * self.singleClass.returnHeigh())
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local index = 1
	for i = 2, 4 do
		local allianceData = pyramidWarCtrl.top4Alliance[tostring(i)]
		if allianceData and allianceData.info then
			local panel = self.singleClass.new()
			panel:setPosition(sSize.width / 2, sH - (index - 1) * panel.returnHeigh())
			panel:initData(allianceData.info, i)
			panel:addTo(self.scroll)
			index = index + 1
			self.labelTip:setVisible(false)
		end
	end
end
function PyramidBattleHonourBoard:createSingleClass(...)
	self.singleClass = class("PyramidBattleHonourBoardSingle", function(target)
		return self.imgCopy:clone()
	end)
	function self.singleClass:ctor()
		self.nodeFlag = self:getChildByName("Node_flag")
		self.txtName = self:getChildByName("Text_name")
		self.txtKing = self:getChildByName("Text_king")
		self.txtPower = self:getChildByName("Text_power")
		self.txtPeople = self:getChildByName("Text_people")
		self.spriteRank = self:getChildByName("Sprite_rank")
		self.Text_rank = self:getChildByName("Text_rank")
		self.imgLvFade = self:getChildByName("Image_lvFade")
	end
	function self.singleClass:initData(data, rank)
		_UPVALUE4_ = nil
		;(nil)[1] = "icon_battlefield_playoff_gold.png"
		;(nil)[2] = "icon_battlefield_playoff_silver.png"
		;(nil)[3] = "icon_battlefield_playoff_cuprum.png"
		local (nil)[4], tableIcon = "", nil
		self.info = data
		self:initView()
		if tableIcon[rank] and tableIcon[rank] ~= "" then
			self.spriteRank:setSpriteFrame(tableIcon[rank])
			self.spriteRank:setVisible(true)
			self.Text_rank:setVisible(false)
		else
			self.spriteRank:setVisible(false)
			self.Text_rank:setString(tostring(rank))
			self.Text_rank:setVisible(true)
		end
	end
	function self.singleClass:initView(...)
		_ENV = nil
		_ENV = nil
		;(nil).abbr = self.info.abbr
		;(nil).name = self.info.name
		;(nil).conten = i18n("common_text_186", nil)
		self.txtName:setString(i18n("common_text_925", nil))
		_ENV = i18n("common_text_925", nil)
		i18n("common_text_925", nil).name = self.info.kname
		self.txtKing:setString(i18n("common_text_971", i18n("common_text_925", nil)))
		self.txtPower:setString(string.formatnumberthousands(self.info.power))
		_ENV = string.formatnumberthousands(self.info.power)
		string.formatnumberthousands(self.info.power).member = self.info.memnum
		string.formatnumberthousands(self.info.power).total = 50
		self.txtPeople:setString(i18n("common_text_155", string.formatnumberthousands(self.info.power)))
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.info.flag, self.nodeFlag)
		local allianceJump = self:getChildByName("Button_alliance")
		allianceJump:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				local allianceQuery = gametop.playertop_:getModule("allianceQuery")
				SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard"))
				_ENV = SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard")
				SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard").from = "pyramidBattleHonourBoard"
				allianceQuery:reqAllianceInfo(self.info.kid, self.info.aid, SoraDSearchPanelFromManagerByName("pyramidBattleHonourBoard"))
			end
		end)
	end
	function self.singleClass.returnHeigh(...)
		return 200
	end
end
function PyramidBattleHonourBoard:btnHistoryClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCreatePanel("pyramidBattleHistoryHonour"):show()
	end
end
return PyramidBattleHonourBoard
