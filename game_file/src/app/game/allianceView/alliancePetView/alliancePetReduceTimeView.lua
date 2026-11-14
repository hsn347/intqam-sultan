local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local alliancePetReduceTimeView = class("alliancePetReduceTimeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePetReduceTimeView")
	end
	return target
end)
function alliancePetReduceTimeView:ctor()
	self.round = 0
	self:initControls()
end
function alliancePetReduceTimeView:initControls()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_pet")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnDonate = SoraDGetChildByName(self, "btn_donate")
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.txtRemainTime = SoraDGetChildByName(self, "text_remainTime")
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.txtRemainTime)
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.txtReduceTime = SoraDGetChildByName(self, "text_donateTime")
	self.txtWarining = SoraDGetChildByName(self, "text_warning")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.panelCom = SoraDGetChildByName(self, "Panel_combine")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	local totalTime = alliancePetCtrl:getAlliancePetTotalTime()
	self.txtRemainTime:setTimeLast(function(str)
		self.loadingBar:setPercent(callTimeCD / totalTime * 100)
		callTimeCD = callTimeCD / totalTime * 100
		;(callTimeCD / totalTime * 100).time = str
		return i18n("common_text_725", callTimeCD / totalTime * 100)
	end)
	self.txtRemainTime:beginTime(callTimeCD)
	self.txtRemainTime:setTimeEndListener(function(...)
		self:removeFromParent()
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AlliancePetSelect")
		else
			SoraDCreatePanel("alliancePetSelectView"):show()
		end
	end)
	self.nodeTitle:setTitle(i18n("alliance_beast_text_31"))
	self.btnHelp:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnDonate:addTouchEventListener(handler(self, self.donateClickCallBack))
	local comStr = string.format([[
%s
%s]], i18n("alliance_beast_text_37"), i18n("alliance_beast_text_38"))
	self.txtWarining:setString(comStr)
	if math.floor(display.height) == 853 then
		self.txtWarining:setVisible(false)
	end
	self.txtTitle:setString(i18n("alliance_beast_text_35"))
	self.panelTable, _ENV = self.txtTitle.setString, self.txtTitle.setString
	self.costList = require("app." .. LocalTblPath .. ".config_server.alliance_beast_reduce")
	alliancePetCtrl:sendReqPetInfo()
	SoraDShowLoading(self)
end
function alliancePetReduceTimeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_REQ_INFO_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.reduceList, _ENV = SoraDCloseLoading, SoraDCloseLoading
		for k, v in pairs(data.alliancePetData.reduceList) do
			if v.name then
				table.insert(self.reduceList, v)
			end
		end
		table.sort(self.reduceList, function(l, r)
			local time1 = l.opTime or l.time
			local time2 = r.opTime or r.time
			return time1 < time2
		end)
		self.round = tonumber(data.alliancePetData.reduceNum)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.round = tonumber(data.alliancePetData.reduceNum)
		alliancePetCtrl:sendReqReducePetCDList()
		SoraDShowLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_LIST_BACK", function(target, data)
		SoraDCloseLoading(self)
		if self.panelTable and table.nums(self.panelTable) then
			for k, v in pairs(self.panelTable) do
				v:setVisible(false)
			end
			self.panelTable, _ENV = pairs(self.panelTable)
			self.reduceList = data.alliancePetData.reduceList
			self:initData()
		end
		local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
		if callTimeCD <= 0 then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("AlliancePetSelect")
			else
				SoraDCreatePanel("alliancePetSelectView"):show()
			end
		end
	end)
end
function alliancePetReduceTimeView:initData()
	if not self.costList[self.round + 1] then
		_ENV = nil
		;(nil).Time = SoraDConvertSecondToString(self.costList[self.round].Reduce)
		self.txtReduceTime:setString(i18n("alliance_beast_text_36", nil))
		self.txtGold:setString(self.costList[self.round].Cost)
	else
		_ENV = i18n("alliance_beast_text_36", nil)
		i18n("alliance_beast_text_36", nil).Time = SoraDConvertSecondToString(self.costList[self.round + 1].Reduce)
		self.txtReduceTime:setString(i18n("alliance_beast_text_36", i18n("alliance_beast_text_36", nil)))
		self.txtGold:setString(self.costList[self.round + 1].Cost)
	end
	for i, v in ipairs(self.reduceList) do
		local cell = self.panelCom:clone()
		cell:setPosition(cc.p(-320, -90 - 35 * (i - 1) + 20))
		cell:addTo(self.topNode)
		local txtName = SoraDGetChildByName(cell, "text_name")
		txtName:setString(v.name)
		local txtTime = SoraDGetChildByName(cell, "text_reduceTime")
		SoraDSetTextWidthHeight(txtTime, cc.size(350, 45))
		txtTime:setFontSize(16)
		local timeStr = string.format("%s s", v.time)
		_ENV = cc.size(350, 45)
		cc.size(350, 45).Name = ""
		cc.size(350, 45).Time = timeStr
		txtTime:setString(i18n("alliance_beast_text_34", cc.size(350, 45)))
		if SoraDFIsRA() then
			txtTime:setPositionX(330)
			txtName:setPositionX(350)
		else
			txtTime:setPositionX(200)
			txtName:setPositionX(180)
		end
		table.insert(self.panelTable, cell)
	end
	local callTimeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	local totalTime = alliancePetCtrl:getAlliancePetTotalTime()
	if 0 < callTimeCD then
		self.txtRemainTime:setTimeLast(function(str)
			self.loadingBar:setPercent(callTimeCD / totalTime * 100)
			callTimeCD = callTimeCD / totalTime * 100
			;(callTimeCD / totalTime * 100).time = str
			return i18n("common_text_725", callTimeCD / totalTime * 100)
		end)
		self.txtRemainTime:beginTime(callTimeCD)
	else
		self:removeFromParent()
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AlliancePetSelect")
		else
			SoraDCreatePanel("alliancePetSelectView"):show()
		end
	end
end
function alliancePetReduceTimeView:donateClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.costList[self.round + 1] then
			if lordInfoCtrl:getBaseInfo().gold >= self.costList[self.round + 1].Cost then
				_ENV = nil
				;(nil).Gold = self.costList[self.round + 1].Cost
				SoraDShowMsgBox(i18n("alliance_beast_text_33", nil), i18n("common_text_054"), nil, function(eventType)
					if MSGBOX_CALLBACK_YES == eventType then
						alliancePetCtrl:sendReqReducePetCD()
						SoraDShowLoading(self)
					end
				end)
			else
				SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
			end
		else
			SoraDShowMsgTip(i18n("alliance_beast_text_39"))
		end
	end
end
function alliancePetReduceTimeView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function alliancePetReduceTimeView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_PET_REDUCE)
	end
end
return alliancePetReduceTimeView
