local PyramidBattleOppoInfo = class("pyramidBattleOppoInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidBattleOppoInfo")
	end
	return target
end)
function PyramidBattleOppoInfo:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3319"))
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtKing = SoraDGetChildByName(self, "Text_king")
	self.txtAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.txtForce = SoraDGetChildByName(self, "Text_force")
	self.txtArmy = SoraDGetChildByName(self, "Text_army")
	self.txtRank = SoraDGetChildByName(self, "Text_rank")
	self.txtRankInt = SoraDGetChildByName(self, "Text_rankIntegral")
	self.txtVictory = SoraDGetChildByName(self, "Text_victory")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.btnOtherOppo = SoraDGetChildByName(self, "Button_otherOppo")
	self.btnOtherOppo:setTitleText(i18n("common_text_3316"))
	SoraDAutoSizeButtonText(self.btnOtherOppo)
	self.btnOtherOppo:addTouchEventListener(handler(self, self.btnOtherOppoClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_OPPOINFOBACK", handler(self, self.initData))
	self:req4Info()
end
function PyramidBattleOppoInfo:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	pyramidWarCtrl:regularSeasonGetMatchAllianceInfoReq()
end
function PyramidBattleOppoInfo:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "PyramidBattleOppoInfo")
	self.infoTbl = redata.info
	self:initView()
end
function PyramidBattleOppoInfo:initView(...)
	_ENV = nil
	;(nil).abbr = self.infoTbl.abbr
	;(nil).name = self.infoTbl.name
	self.txtName:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).kid = self.infoTbl.kname
	self.txtKing:setString(i18n("common_text_342", i18n("common_text_186", nil)))
	_ENV = i18n("common_text_342", i18n("common_text_186", nil))
	i18n("common_text_342", i18n("common_text_186", nil)).name = self.infoTbl.leadername
	self.txtAlliance:setString(i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))
	_ENV = i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))
	i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))).count = string.formatnumberthousands(self.infoTbl.apower)
	self.txtForce:setString(i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))
	_ENV = i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))
	_ENV = i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))
	i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))).member = self.infoTbl.curmem
	i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))).total = self.infoTbl.totalmem
	i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))).num = i18n("common_text_155", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))
	self.txtArmy:setString(i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))
	if self.infoTbl.rank <= 0 then
		_ENV = i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))
		i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))).rank = i18n("common_text_827")
		self.txtRank:setString(i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))))
	else
		_ENV = i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))
		i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))).rank = self.infoTbl.rank
		self.txtRank:setString(i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))))
	end
	_ENV = i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))))
	i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))).point = self.infoTbl.honor
	self.txtRankInt:setString(i18n("common_text_3339", i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))))))
	_ENV = i18n("common_text_3339", i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))))
	i18n("common_text_3339", i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil)))))))).gailv = string.format("%.1f", self.infoTbl.winrate * 100) .. "%"
	self.txtVictory:setString(i18n("common_text_3340", i18n("common_text_3339", i18n("common_text_3042", i18n("common_text_3042", i18n("chat_text_14", i18n("common_text_555", i18n("common_text_926", i18n("common_text_342", i18n("common_text_186", nil))))))))))
	local allianceDesRead = include("allianceDesRead")
	local spFlag = SoraDGetAllianceFlagByFid(self.infoTbl.flag)
	spFlag:setScale(0.7)
	spFlag:addTo(self.nodeFlag)
end
function PyramidBattleOppoInfo:btnOtherOppoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("pyramidBattleOtherOppoView")
		panel:show()
	end
end
return PyramidBattleOppoInfo
