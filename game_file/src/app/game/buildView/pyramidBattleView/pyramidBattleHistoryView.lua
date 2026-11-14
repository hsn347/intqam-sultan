local ctGridScroll = include("ctGridScroll")
local PyramidBattleHistoryView = class("pyramidBattleHistoryView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleHistoryView")
	end
	return target
end)
function PyramidBattleHistoryView:ctor()
	local gametop = gModuleMgr.getObject("gametop")
	self.myKid = gametop.playertop_:getKingdomID() or 0
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidBattleHistory"):setTitle(i18n("common_text_3032"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.scroll = ctGridScroll.new(self.scroll)
	self.imgCopy = SoraDGetChildByName(self, "Panel_single")
	self.txtJoint = SoraDGetChildByName(self, "Text_joint")
	self.txtSeasonTimes = SoraDGetChildByName(self, "Text_times")
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.txtNoRecord:setString(i18n("common_text_1464"))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_HISTORYLISTBACK", handler(self, self.initData))
	self:req4Info()
end
function PyramidBattleHistoryView:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	self.mySeasonCount = pyramidWarCtrl.applyRegularSeasonCount
	pyramidWarCtrl:regularSeasonGetBattleRecordReq()
end
function PyramidBattleHistoryView:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "PyramidBattleHistoryView")
	self.infoTbl = redata.log
	self.gailv = redata.gailv
	self:initView()
end
function PyramidBattleHistoryView:initView(...)
	_ENV = nil
	;(nil).gailv = string.format("%.1f", self.gailv * 100) .. "%"
	self.txtJoint:setString(i18n("common_text_3346", nil))
	_ENV = i18n("common_text_3346", nil)
	i18n("common_text_3346", nil).num = self.mySeasonCount
	self.txtSeasonTimes:setString(i18n("common_text_3345", i18n("common_text_3346", nil)))
	local createFun = function(data)
		local cSingle = self.imgCopy:clone()
		cSingle:getChildByName("Text_time"):setString(os.date("%x", data.time))
		if self.myKid == data.selfinfo.kid then
			self = os.date("%x", data.time)
			os.date("%x", data.time).abbr = data.selfinfo.abbr
			os.date("%x", data.time).name = data.selfinfo.name
			cSingle:getChildByName("Text_leftName"):setString(i18n("common_text_186", os.date("%x", data.time)))
		else
			self = i18n("common_text_186", os.date("%x", data.time))
			i18n("common_text_186", os.date("%x", data.time)).abbr = data.selfinfo.abbr
			i18n("common_text_186", os.date("%x", data.time)).name = data.selfinfo.name
			cSingle:getChildByName("Text_leftName"):setString(i18n("common_text_186", i18n("common_text_186", os.date("%x", data.time))) .. "#" .. data.selfinfo.kid)
		end
		if data.selfinfo.rank <= 0 then
			self = data.selfinfo.kid
			data.selfinfo.kid.rank = i18n("common_text_827")
			cSingle:getChildByName("Text_leftRank"):setString(i18n("common_text_3409", data.selfinfo.kid))
		else
			self = i18n("common_text_3409", data.selfinfo.kid)
			i18n("common_text_3409", data.selfinfo.kid).rank = data.selfinfo.rank
			cSingle:getChildByName("Text_leftRank"):setString(i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))
		end
		self = i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))
		i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)).gailv = string.format("%.1f", data.selfinfo.winrate * 100) .. "%"
		cSingle:getChildByName("Text_leftGailv"):setString(i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))))
		self = i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))
		i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))).point = data.selfinfo.ascore
		cSingle:getChildByName("Text_leftInt"):setString(i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))))
		if self.myKid == data.otherinfo.kid then
			self = i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))))
			i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))).abbr = data.otherinfo.abbr
			i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))).name = data.otherinfo.name
			cSingle:getChildByName("Text_rightName"):setString(i18n("common_text_186", i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))))))
		else
			self = i18n("common_text_186", i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))))
			i18n("common_text_186", i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))))).abbr = data.otherinfo.abbr
			i18n("common_text_186", i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid))))).name = data.otherinfo.name
			cSingle:getChildByName("Text_rightName"):setString(i18n("common_text_186", i18n("common_text_186", i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.selfinfo.kid)))))) .. "#" .. data.otherinfo.kid)
		end
		if 0 >= data.otherinfo.rank then
			self = data.otherinfo.kid
			data.otherinfo.kid.rank = i18n("common_text_827")
			cSingle:getChildByName("Text_rightRank"):setString(i18n("common_text_3409", data.otherinfo.kid))
		else
			self = i18n("common_text_3409", data.otherinfo.kid)
			i18n("common_text_3409", data.otherinfo.kid).rank = data.otherinfo.rank
			cSingle:getChildByName("Text_rightRank"):setString(i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid)))
		end
		self = i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid))
		i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid)).gailv = string.format("%.1f", data.otherinfo.winrate * 100) .. "%"
		cSingle:getChildByName("Text_rightGailv"):setString(i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid))))
		self = i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid)))
		i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid))).point = data.otherinfo.ascore
		cSingle:getChildByName("Text_rightInt"):setString(i18n("common_text_3347", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", data.otherinfo.kid)))))
		if data.otherinfo.iswin then
			cSingle:getChildByName("Image_state"):setPositionX(520)
			cSingle:getChildByName("Image_vs"):getVirtualRenderer():setState(1)
		end
		return cSingle
	end
	local createFormatTbl = function(tbl)
		local _ENV, reTbl
		table.sort(tbl, function(l, r)
			return l.time > r.time
		end)
		for i, v in ipairs(tbl) do
			_ENV = nil
			;(nil).data = v
			table.insert(reTbl, nil)
		end
		return reTbl
	end
	self.txtNoRecord:setVisible(not next(self.infoTbl))
	self.scroll:init(createFormatTbl(self.infoTbl), createFun, self.imgCopy:getContentSize())
	self.scroll:begin2Run()
end
return PyramidBattleHistoryView
