local ctGridScroll = include("ctGridScroll")
local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local palaceInfoRead = include("palaceInfoRead")
local CrazyIntegralRankView = class("crazyIntegralRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("crazyIntegralRankView")
	end
	return target
end)
function CrazyIntegralRankView:ctor()
	self.myRankTbl, _ENV, self.isAlreadyReq, _ENV, self.wGet, _ENV, self.sIndex, _ENV, self.rankList, _ENV, self.myRank = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	_UPVALUE4_, self.curRankType = gCrazyScoreRankType.UID_RANK_TYPE, gCrazyScoreRankType.UID_RANK_TYPE
	_UPVALUE3_, self.ocxStyle, gCrazyScoreRankType.UID_RANK_TYPE[1] = gCrazyScoreRankType.UID_RANK_TYPE, gCrazyScoreRankType.UID_RANK_TYPE, "glow_red1_01.png"
	_UPVALUE3_, self.ocxStyle, gCrazyScoreRankType.UID_RANK_TYPE[2] = gCrazyScoreRankType.UID_RANK_TYPE, gCrazyScoreRankType.UID_RANK_TYPE, "glow_red1_02.png"
	_UPVALUE3_, self.ocxStyle, gCrazyScoreRankType.UID_RANK_TYPE[3] = gCrazyScoreRankType.UID_RANK_TYPE, gCrazyScoreRankType.UID_RANK_TYPE, "glow_red1_03.png"
	_UPVALUE3_, self.ocxStyle, gCrazyScoreRankType.UID_RANK_TYPE[4] = gCrazyScoreRankType.UID_RANK_TYPE, gCrazyScoreRankType.UID_RANK_TYPE, "glow_red1_04.png"
	self.ocxNum, gCrazyScoreRankType.UID_RANK_TYPE[1] = gCrazyScoreRankType.UID_RANK_TYPE, "icon_ranking_1.png"
	self.ocxNum, gCrazyScoreRankType.UID_RANK_TYPE[2] = gCrazyScoreRankType.UID_RANK_TYPE, "icon_ranking_2.png"
	self.ocxNum, gCrazyScoreRankType.UID_RANK_TYPE[3] = gCrazyScoreRankType.UID_RANK_TYPE, "icon_ranking_3.png"
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rankings")
	self.scroll = ctGridScroll.new(self.scroll)
	self.panelCopy = SoraDFIsRA() and SoraDGetChildByName(self, "Panel_copy") or SoraDGetChildByName(self, "Panel_copyEn")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnKingDom = SoraDGetChildByName(self, "Button_kingdom")
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnPersonal = SoraDGetChildByName(self, "Button_personal")
	self.txtMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.txtMyInt = SoraDGetChildByName(self, "Text_myInt")
	self.btnKingDom:addTouchEventListener(handler(self, self.btnKingDomClick))
	self.btnAlliance:addTouchEventListener(handler(self, self.btnAllianceClick))
	self.btnPersonal:addTouchEventListener(handler(self, self.btnPersonalClick))
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_rank"):setTitle(i18n("common_text_3052"))
	if SoraDFIsRA() then
		SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_264"))
		SoraDGetChildByName(self, "Text_des"):setString(i18n("common_text_1764"))
	else
		SoraDGetChildByName(self, "Text_name"):setString(i18n("common_text_1764"))
		SoraDGetChildByName(self, "Text_des"):setString(i18n("common_text_264"))
	end
	self.btnKingDom:setTitleText(i18n("common_text_3055"))
	self.btnAlliance:setTitleText(i18n("common_text_3054"))
	self.btnPersonal:setTitleText(i18n("common_text_3053"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnHelp:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CRAZYINTEGRAL_RANKDATA", handler(self, self.initData))
end
function CrazyIntegralRankView:start2req()
	self:initCrazyRankInfoCtrl()
	self:btnPersonalClick(self.btnPersonal, ccui.TouchEventType.ended)
end
function CrazyIntegralRankView:setMyRankData(tbl)
	self.myRankTbl = tbl
end
function CrazyIntegralRankView:initCrazyRankInfoCtrl(...)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	newActivityCtrl:clearCrazyRankData()
end
function CrazyIntegralRankView:req4Data(index)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	newActivityCtrl:sendCrazyScoreRank(index, self.curRankType)
	SoraDShowLoading(self)
end
function CrazyIntegralRankView:initData(target, data)
	SoraDCloseLoading(self)
	local selfFactory = function(tbl)
		local _ENV, reTbl
		for _, v in ipairs(tbl) do
			_ENV = nil
			;(nil).data = v
			table.insert(reTbl, nil)
		end
		return reTbl
	end
	if data and data.rankList then
		self.curRankType = data.dataType
		self.isAlreadyReq[self.curRankType] = true
		self.rankList[self.curRankType] = selfFactory(data.rankList)
		self.sIndex[self.curRankType] = data.idx
		self.wGet[self.curRankType] = data.wget
	else
		return
	end
	self:initView()
end
function CrazyIntegralRankView:cleanRankList()
	local selfFactory = function(tbl)
		local _ENV, reTbl
		for _, v in ipairs(tbl) do
			_ENV = nil
			;(nil).data = v.data
			table.insert(reTbl, nil)
		end
		return reTbl
	end
	self.rankList[self.curRankType] = selfFactory(self.rankList[self.curRankType])
end
function CrazyIntegralRankView:initView()
	self.scroll:init(self.rankList[self.curRankType], handler(self, self.createSingle), cc.size(640, 125))
	self.scroll:begin2Run()
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
end
function CrazyIntegralRankView:personalSingle(ocx, info)
	local head = ocx:getChildByName("Image_head")
	local sheer = ocx:getChildByName("Image_sheer")
	local imgNum = ocx:getChildByName("Image_lordNum")
	local txtNum = ocx:getChildByName("Text_lordNum")
	local txtLordInt = ocx:getChildByName("Text_lordInt")
	local txtLordName = ocx:getChildByName("Text_lordName")
	local imgFlag = ocx:getChildByName("Image_flag")
	local imgPalace = ocx:getChildByName("Image_palace")
	imgFlag:setVisible(false)
	imgPalace:setVisible(false)
	head:setTouchEnabled(true)
	head:setSwallowTouches(false)
	head:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local playerID = info.uid
			local kid = info.kid
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			_ENV = nil
			;(nil).targetName = self.__cname
			local playerData = lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		end
	end)
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			imgNum:setVisible(false)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if rank <= RANK_TOP_SPECIAL then
		sheer:loadTexture(self.ocxStyle[rank + 1], ccui.TextureResType.plistType)
	else
		sheer:setVisible(false)
	end
	if rank == self.myRank then
		sheer:setVisible(true)
		sheer:loadTexture(self.ocxStyle[1], ccui.TextureResType.plistType)
	end
	txtLordInt:setString(string.formatnumberthousands(info.score))
	SoraDGetHeadFromManager(head, info.headid, info.avatar)
	if info.allianceAbbr ~= "" then
		txtLordName:setString("(" .. info.allianceAbbr .. ")" .. info.nickName .. "#" .. info.kid)
	else
		txtLordName:setString(info.nickName .. "#" .. info.kid)
	end
	return ocx
end
function CrazyIntegralRankView:allianceSingle(ocx, info)
	local head = ocx:getChildByName("Image_head")
	local sheer = ocx:getChildByName("Image_sheer")
	local imgNum = ocx:getChildByName("Image_lordNum")
	local txtNum = ocx:getChildByName("Text_lordNum")
	local txtLordInt = ocx:getChildByName("Text_lordInt")
	local txtLordName = ocx:getChildByName("Text_lordName")
	local imgFlag = ocx:getChildByName("Image_flag")
	local imgPalace = ocx:getChildByName("Image_palace")
	head:setVisible(false)
	imgPalace:setVisible(false)
	imgFlag:setTouchEnabled(true)
	imgFlag:setSwallowTouches(false)
	imgFlag:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			;(nil).from = "CrazyIntegralRankView"
			allianceQuery:reqAllianceInfo(info.kid, info.aid, nil)
		end
	end)
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			imgNum:setVisible(false)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if rank <= RANK_TOP_SPECIAL then
		sheer:loadTexture(self.ocxStyle[rank + 1], ccui.TextureResType.plistType)
	else
		sheer:setVisible(false)
	end
	if rank == self.myRank then
		sheer:setVisible(true)
		sheer:loadTexture(self.ocxStyle[1], ccui.TextureResType.plistType)
	end
	txtLordInt:setString(string.formatnumberthousands(info.score))
	imgFlag:loadTexture(allianceDesRead.getFlagIcon(info.allianceFlag or 1), ccui.TextureResType.plistType)
	if info.allianceAbbr and info.allianceAbbr ~= "" then
		_ENV = string.formatnumberthousands(info.score)
		string.formatnumberthousands(info.score).abbr = info.allianceAbbr
		string.formatnumberthousands(info.score).name = info.allianceName
		txtLordName:setString(i18n("common_text_186", string.formatnumberthousands(info.score)) .. "#" .. info.kid)
	else
		txtLordName:setString(info.allianceName .. "#" .. info.kid)
	end
	return ocx
end
function CrazyIntegralRankView:kingdomSingle(ocx, info)
	local head = ocx:getChildByName("Image_head")
	local sheer = ocx:getChildByName("Image_sheer")
	local imgNum = ocx:getChildByName("Image_lordNum")
	local txtNum = ocx:getChildByName("Text_lordNum")
	local txtLordInt = ocx:getChildByName("Text_lordInt")
	local txtLordName = ocx:getChildByName("Text_lordName")
	local imgFlag = ocx:getChildByName("Image_flag")
	local imgPalace = ocx:getChildByName("Image_palace")
	imgFlag:setVisible(false)
	head:setVisible(false)
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL then
			txtNum:setVisible(false)
			imgNum:loadTexture(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			imgNum:setVisible(false)
			txtNum:setString(num)
		end
	end
	local rank = info.rank
	switchNum(rank)
	if rank <= RANK_TOP_SPECIAL then
		sheer:loadTexture(self.ocxStyle[rank + 1], ccui.TextureResType.plistType)
	else
		sheer:setVisible(false)
	end
	if rank == self.myRank then
		sheer:setVisible(true)
		sheer:loadTexture(self.ocxStyle[1], ccui.TextureResType.plistType)
	end
	txtLordInt:setString(string.formatnumberthousands(info.score))
	imgPalace:loadTexture(palaceInfoRead.getIcon(info.palaceModel or 1), ccui.TextureResType.plistType)
	txtLordName:setString(info.kname or "")
	return ocx
end
function CrazyIntegralRankView:createSingle(info)
	local ocx = self.panelCopy:clone()
	if gCrazyScoreRankType.UID_RANK_TYPE == self.curRankType then
		self:personalSingle(ocx, info)
	elseif gCrazyScoreRankType.AID_RANK_TYPE == self.curRankType then
		self:allianceSingle(ocx, info)
	elseif gCrazyScoreRankType.KID_RANK_TYPE == self.curRankType then
		self:kingdomSingle(ocx, info)
	end
	return ocx
end
function CrazyIntegralRankView:scrollEventCallBack(scroll, eventType)
	if eventType == ccui.ScrollviewEventType.scrolling then
	elseif eventType == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底")
		if self.wGet[self.curRankType] then
			self:req4Data(self.sIndex[self.curRankType])
		end
	end
end
function CrazyIntegralRankView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "CrazyIntegralRankView" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function CrazyIntegralRankView:serverMessageGetLordInfo(target, data)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function CrazyIntegralRankView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_3064"))
	end
end
function CrazyIntegralRankView:btnJumpClick(button, type)
	if type == ccui.TouchEventType.ended then
		self.txtMyRank:setScale(1.0)
		if self.myRank > 0 then
			self.scroll:ctJumpToByRule(function(single)
				if single.index == self.myRank then
					SoraDPlaySound()
					return true
				else
					return false
				end
			end)
		end
	elseif type == ccui.TouchEventType.began then
		self.txtMyRank:setScale(1.1)
	elseif type == ccui.TouchEventType.canceled then
		self.txtMyRank:setScale(1.0)
	end
end
function CrazyIntegralRankView:switchBtns(btn)
	SoraDPlaySound()
	_UPVALUE3_ = SoraDPlaySound
	SoraDPlaySound[1] = self.btnKingDom
	SoraDPlaySound[2] = self.btnAlliance
	local SoraDPlaySound[3], btns = self.btnPersonal, SoraDPlaySound
	for _, v in pairs(btns) do
		if btn == v then
			v:setTouchEnabled(false)
			v:setBright(true)
			v:setTitleColor(cc.c3b(255, 210, 138))
		else
			v:setTouchEnabled(true)
			v:setBright(false)
			v:setTitleColor(cc.c3b(85, 65, 55))
		end
	end
end
function CrazyIntegralRankView:switchTitleInfo(btn)
	local judgeInt = function(val)
		if val < 0 then
			return i18n("common_text_827")
		else
			return val
		end
	end
	if btn == self.btnKingDom then
		_ENV = nil
		;(nil).rank = judgeInt(self.myRankTbl.kingdomRank)
		self.txtMyRank:setString(i18n("common_text_3043", nil))
		_ENV = i18n("common_text_3043", nil)
		i18n("common_text_3043", nil).num = self.myRankTbl.kingdomInt
		self.txtMyInt:setString(i18n("common_text_2556", i18n("common_text_3043", nil)))
		self.myRank = self.myRankTbl.kingdomRank
	elseif btn == self.btnAlliance then
		_ENV = i18n("common_text_2556", i18n("common_text_3043", nil))
		i18n("common_text_2556", i18n("common_text_3043", nil)).rank = judgeInt(self.myRankTbl.allianceRank)
		self.txtMyRank:setString(i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil))))
		_ENV = i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil)))
		i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil))).num = self.myRankTbl.allianceInt
		self.txtMyInt:setString(i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil)))))
		self.myRank = self.myRankTbl.allianceRank
	elseif btn == self.btnPersonal then
		_ENV = i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil))))
		i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil)))).rank = judgeInt(self.myRankTbl.personalRank)
		self.txtMyRank:setString(i18n("common_text_825", i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil))))))
		_ENV = i18n("common_text_825", i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil)))))
		i18n("common_text_825", i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil))))).num = self.myRankTbl.personalInt
		self.txtMyInt:setString(i18n("common_text_1256", i18n("common_text_825", i18n("common_text_2556", i18n("common_text_3042", i18n("common_text_2556", i18n("common_text_3043", nil)))))))
		self.myRank = self.myRankTbl.personalRank
	end
end
function CrazyIntegralRankView:btnKingDomClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchBtns(button)
		self:switchTitleInfo(button)
		self.curRankType = gCrazyScoreRankType.KID_RANK_TYPE
		if self.isAlreadyReq[self.curRankType] then
			self:cleanRankList()
			self:initView()
		else
			self:req4Data(1)
		end
	end
end
function CrazyIntegralRankView:btnAllianceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchBtns(button)
		self:switchTitleInfo(button)
		self.curRankType = gCrazyScoreRankType.AID_RANK_TYPE
		if self.isAlreadyReq[self.curRankType] then
			self:cleanRankList()
			self:initView()
		else
			self:req4Data(1)
		end
	end
end
function CrazyIntegralRankView:btnPersonalClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchBtns(button)
		self:switchTitleInfo(button)
		self.curRankType = gCrazyScoreRankType.UID_RANK_TYPE
		if self.isAlreadyReq[self.curRankType] then
			self:cleanRankList()
			self:initView()
		else
			self:req4Data(1)
		end
	end
end
return CrazyIntegralRankView
