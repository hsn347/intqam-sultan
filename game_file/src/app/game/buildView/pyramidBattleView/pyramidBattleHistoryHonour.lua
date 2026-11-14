local ctGridScroll = include("ctGridScroll")
local PyramidBattleHistoryHonour = class("pyramidBattleHistoryHonour", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleHistoryHonour")
	end
	return target
end)
function PyramidBattleHistoryHonour:ctor()
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.panelCopy = SoraDGetChildByName(self, "Panel_touch")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_main")
	self.scroll = ctGridScroll.new(self.scroll)
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidHonourHistory"):setTitle(i18n("pyramid_btn_01"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self.txtNoRecord:setString(i18n("common_text_927"))
	self:req4Info()
end
function PyramidBattleHistoryHonour:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_FAIL_BACK", handler(self, self.sMsgReqFailInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDPOSTSEASON_HONOURHISTORY", handler(self, self.initData))
end
function PyramidBattleHistoryHonour:req4Info(...)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	SoraDShowLoading(self)
	pyramidWarCtrl:getHonourHistoryList()
end
function PyramidBattleHistoryHonour:initData(target, redata)
	dump(redata, "redata", 10)
	SoraDCloseLoading(self)
	self.myListData = redata.redata
	self:initView()
end
function PyramidBattleHistoryHonour:initView(...)
	local getKingdomName = function(kid)
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
		local ok, ret = kingdomCtrl:isFoundKingdomID(kid)
		if ok then
			return ret.kname
		else
			return kid
		end
	end
	local createSingle = function(data)
		local single = self.panelCopy:clone()
		local ainfo = data.aInfo
		self = nil
		;(nil).abbr = ainfo.abbr
		;(nil).name = ainfo.name
		single:getChildByName("Text_name"):setString(i18n("common_text_186", nil))
		self = i18n("common_text_186", nil)
		i18n("common_text_186", nil).name = ainfo.leadername
		single:getChildByName("Text_alliance"):setString(i18n("common_text_170", i18n("common_text_186", nil)))
		single:getChildByName("Text_server"):setString(getKingdomName(ainfo.kid))
		single:getChildByName("Text_time"):setString(os.date("%Y-%m-%d", data.time))
		if data.isFirst then
			self = os.date("%Y-%m-%d", data.time)
			os.date("%Y-%m-%d", data.time).num = data.season
			if "(" .. i18n("common_text_4345") .. ")\n" .. i18n("pyramid_title_02", os.date("%Y-%m-%d", data.time)) then
				goto lbl_70
			end
		end
		self = ")\n"
		;(")\n").num = data.season
		local seasonName = i18n("pyramid_title_02", ")\n")
		::lbl_70::
		local Text_index = single:getChildByName("Text_index")
		Text_index:setString(seasonName)
		SoraDGetAutoHeightLabel(Text_index, 100)
		local nodeFlag = single:getChildByName("Node_flag")
		local allianceDesRead = include("allianceDesRead")
		allianceDesRead.getFlagWithParticle(ainfo.flag, nodeFlag)
		if data.isFirst then
			single:getChildByName("Image_curBg"):loadTexture("frame_alliance_pank_06.png", ccui.TextureResType.plistType)
		else
			single:getChildByName("Image_curBg"):loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
		single:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				local gametop = gModuleMgr.getObject("gametop")
				local allianceQuery = gametop.playertop_:getModule("allianceQuery")
				_ENV = nil
				;(nil).from = "PyramidBattleHistoryHonour"
				allianceQuery:reqAllianceInfo(ainfo.kid, ainfo.aid, nil)
			end
		end)
		return single
	end
	local selfFactory = function(tbl)
		local _ENV, reTbl
		for _, v in pairs(tbl) do
			_ENV = nil
			;(nil).data = v
			table.insert(reTbl, nil)
		end
		table.sort(reTbl, function(l, r)
			return l.data.season > r.data.season
		end)
		if reTbl[1] then
			reTbl[1].data.isFirst = true
		end
		return reTbl
	end
	self.txtNoRecord:setVisible(not next(self.myListData))
	if not self.firstInit then
		self.scroll:init(selfFactory(self.myListData), createSingle, cc.size(640, 125))
		self.scroll:begin2Run()
		self.firstInit = true
	else
		self.scroll:setNewTable(selfFactory(self.myListData))
	end
end
function PyramidBattleHistoryHonour:sMsgReqInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleHistoryHonour" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function PyramidBattleHistoryHonour:sMsgReqFailInfoBack(target, data)
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleHistoryHonour" then
			if gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE == data.err then
				SoraDShowMsgTip(i18n("common_text_4346"))
			else
				SoraDShowMsgTip("unknow err")
			end
		end
	end
end
return PyramidBattleHistoryHonour
