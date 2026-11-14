local ctGridScroll = include("ctGridScroll")
local allianceDesRead = include("allianceDesRead")
local PyramidBattleOtherOppoView = class("pyramidBattleOtherOppoView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleOtherOppoView")
	end
	return target
end)
function PyramidBattleOtherOppoView:ctor()
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_oppos"):setTitle(i18n("common_text_3316"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.txtNoTip = SoraDGetChildByName(self, "Text_noTip")
	self.scroll = ctGridScroll.new(self.scroll)
	self.imgCopy = SoraDGetChildByName(self, "Panel_single")
	self.txtNoTip:setString(i18n("common_text_3397"))
	self.txtNoTip:setPositionY(self.scroll:getPositionY() - self.scroll:getContentSize().height / 2)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OTHEROPPOINFOBACK", handler(self, self.initData))
	self:req4Info()
end
function PyramidBattleOtherOppoView:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	pyramidWarCtrl:regularSeasonGetMatchTotalInfoReq()
end
function PyramidBattleOtherOppoView:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "PyramidBattleOtherOppoView", 5)
	self.infoTbl = redata.info
	self:initView()
end
function PyramidBattleOtherOppoView:initView(...)
	if self.infoTbl and next(self.infoTbl) then
		self.txtNoTip:setVisible(false)
		local createFun = function(data)
			local cSingle = self.imgCopy:clone()
			if data[1].rank <= 0 then
				self = nil
				;(nil).rank = i18n("common_text_480")
				cSingle:getChildByName("Text_leftRank"):setString(i18n("common_text_3409", nil))
			else
				self = i18n("common_text_3409", nil)
				i18n("common_text_3409", nil).rank = data[1].rank
				cSingle:getChildByName("Text_leftRank"):setString(i18n("common_text_3409", i18n("common_text_3409", nil)))
			end
			self = i18n("common_text_3409", i18n("common_text_3409", nil))
			i18n("common_text_3409", i18n("common_text_3409", nil)).gailv = string.format("%.1f", data[1].winrate * 100) .. "%"
			cSingle:getChildByName("Text_leftGailv"):setString(i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))
			self = i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))
			i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))).point = data[1].honor
			cSingle:getChildByName("Text_leftInt"):setString(i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))
			self = i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))
			self = i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))).abbr = data[1].abbr
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))).name = data[1].name
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))).conten = i18n("common_text_186", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))
			cSingle:getChildByName("Text_leftAlliance"):setString(i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))
			self = i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))
			i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))).kid = data[1].kname
			cSingle:getChildByName("Text_leftKing"):setString(i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))
			if 0 >= data[2].rank then
				self = i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))
				i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))).rank = i18n("common_text_480")
				cSingle:getChildByName("Text_rightRank"):setString(i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))
			else
				self = i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))
				i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))).rank = data[2].rank
				cSingle:getChildByName("Text_rightRank"):setString(i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))
			end
			self = i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))
			i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))).gailv = string.format("%.1f", data[2].winrate * 100) .. "%"
			cSingle:getChildByName("Text_rightGailv"):setString(i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))))
			self = i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))
			i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))).point = data[2].honor
			cSingle:getChildByName("Text_rightInt"):setString(i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))))
			self = i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))))
			self = i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))))
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))).abbr = data[2].abbr
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))).name = data[2].name
			i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))).conten = i18n("common_text_186", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))))
			cSingle:getChildByName("Text_rightAlliance"):setString(i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))))))
			self = i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))))
			i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil))))))))))).kid = data[2].kname
			cSingle:getChildByName("Text_rightKing"):setString(i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", i18n("common_text_342", i18n("common_text_925", i18n("common_text_3339", i18n("common_text_3340", i18n("common_text_3409", i18n("common_text_3409", nil)))))))))))))
			cSingle:getChildByName("Image_leftFlag"):loadTexture(allianceDesRead.getFlagIcon(data[1].flag), ccui.TextureResType.plistType)
			cSingle:getChildByName("Image_rightFlag"):loadTexture(allianceDesRead.getFlagIcon(data[2].flag), ccui.TextureResType.plistType)
			cSingle:getChildByName("Image_leftFlag"):setTouchEnabled(true)
			cSingle:getChildByName("Image_rightFlag"):setTouchEnabled(true)
			cSingle:getChildByName("Image_leftFlag"):setSwallowTouches(false)
			cSingle:getChildByName("Image_rightFlag"):setSwallowTouches(false)
			cSingle:getChildByName("Image_leftFlag"):addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local gametop = gModuleMgr.getObject("gametop")
					local allianceQuery = gametop.playertop_:getModule("allianceQuery")
					_ENV = nil
					;(nil).from = "PyramidBattleOtherOppoView"
					allianceQuery:reqAllianceInfo(data[1].kid, data[1].aid, nil)
				end
			end)
			cSingle:getChildByName("Image_rightFlag"):addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local gametop = gModuleMgr.getObject("gametop")
					local allianceQuery = gametop.playertop_:getModule("allianceQuery")
					_ENV = nil
					;(nil).from = "PyramidBattleOtherOppoView"
					allianceQuery:reqAllianceInfo(data[2].kid, data[2].aid, nil)
				end
			end)
			return cSingle
		end
		local createFormatTbl = function(tbl)
			local _ENV, reTbl
			for i, v in ipairs(tbl) do
				_ENV = nil
				;(nil).data = v
				table.insert(reTbl, nil)
			end
			return reTbl
		end
		self.scroll:init(createFormatTbl(self.infoTbl), createFun, self.imgCopy:getContentSize())
		self.scroll:begin2Run()
	else
		self.txtNoTip:setVisible(true)
	end
end
function PyramidBattleOtherOppoView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "PyramidBattleOtherOppoView" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
return PyramidBattleOtherOppoView
