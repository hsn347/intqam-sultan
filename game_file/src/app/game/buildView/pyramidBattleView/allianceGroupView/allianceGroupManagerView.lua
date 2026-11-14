local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local allianceltCtrl = include("allianceltCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceGroupManagerView = class("allianceGroupManagerView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceGroupManagerView")
	end
	return target
end)
function AllianceGroupManagerView:ctor()
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeBg:setTitleName(i18n("pyramid_btn_03"))
	_UPVALUE3_, self.layerCut = SoraDGetChildByName(self, "Panel_cut"), SoraDGetChildByName(self, "Panel_cut")
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[1] = cc.p(400, 525), cc.p(400, 525), cc.p(400, 525)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[2] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 525)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[3] = cc.p(400, 525), cc.p(400, 525), cc.p(400, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[4] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[5] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[6] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[7] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[8] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[9] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[10] = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	local self.tableFlag, _ENV, SoraDGetChildByName(self, "Panel_cut")[11], flagPos = cc.p(400, 525), cc.p(400, 525), cc.p(140, 195)
	self.tableFlag[1] = SoraDGetChildByName(self, "Node_flag_1")
	local corpsCount = allianceltCtrl:getCorpsCount()
	for i = 1, corpsCount do
		if self.tableFlag[i] == nil then
			self.tableFlag[i] = self.tableFlag[1]:clone()
			self.tableFlag[i]:addTo(self.layerCut)
		end
		self.tableFlag[i].btnFlag = SoraDGetChildByName(self.tableFlag[i], "Button_flag")
		self.tableFlag[i].btnCreate = SoraDGetChildByName(self.tableFlag[i], "Button_create")
		self.tableFlag[i].nodeGroup = SoraDGetChildByName(self.tableFlag[i], "Node_group")
		self.tableFlag[i].spriteFlag = SoraDGetChildByName(self.tableFlag[i], "Sprite_flag")
		self.tableFlag[i].labelTime = SoraDGetChildByName(self.tableFlag[i], "Text_time")
		self.tableFlag[i].labelNum = SoraDGetChildByName(self.tableFlag[i], "Text_num")
		self.tableFlag[i].labelName = SoraDGetChildByName(self.tableFlag[i], "Text_name")
		self.tableFlag[i].nodeUnlock = SoraDGetChildByName(self.tableFlag[i], "Node_unlock")
		self.tableFlag[i].labelUnlock = SoraDGetChildByName(self.tableFlag[i], "Text_unlock")
		self.tableFlag[i].spriteIndex = SoraDGetChildByName(self.tableFlag[i], "Sprite_index")
		self.tableFlag[i].spriteIn = SoraDGetChildByName(self.tableFlag[i], "Sprite_in")
		self.tableFlag[i].labelIndex = SoraDGetChildByName(self.tableFlag[i], "Text_index")
		self.tableFlag[i].btnGo = SoraDGetChildByName(self.tableFlag[i], "Button_go")
		self.tableFlag[i].btnApply = SoraDGetChildByName(self.tableFlag[i], "Button_apply")
		self.tableFlag[i].btnCreate:setTouchEnabled(pyramidWarCtrl:getGroupManagerRank() >= 2)
		self.tableFlag[i].btnCreate:setBright(pyramidWarCtrl:getGroupManagerRank() >= 2)
		self.tableFlag[i].btnCreate:setTitleText(i18n("pyramid_btn_02"))
		self.tableFlag[i].btnApply:setTitleText(i18n("common_text_3315"))
		self.tableFlag[i].btnGo:setTitleText(i18n("common_text_477"))
		SoraDChangeTextToHtml(self.tableFlag[i].labelNum)
		self.tableFlag[i].btnFlag:setTag(i)
		self.tableFlag[i].btnFlag:addTouchEventListener(handler(self, self.btnFlagClick))
		self.tableFlag[i].btnCreate:addTouchEventListener(handler(self, self.btnCreaeClick))
		self.tableFlag[i].btnGo:addTouchEventListener(handler(self, self.btnGoClick))
		self.tableFlag[i].btnApply:addTouchEventListener(handler(self, self.btnApplyClick))
		self.tableFlag[i].btnApply:setTag(i)
		self.tableFlag[i]:setPosition(SoraDFPoint(flagPos[i].x, flagPos[i].y, self.tableFlag[i]))
	end
	self:initData()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_APPLY_BACK", function(target, data)
		SoraDCloseLoading(self)
	end)
end
function AllianceGroupManagerView:btnFlagClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local i = button:getTag()
		local panel = SoraDCreatePanel("allianceGroupMemberList")
		panel:initData(i, false)
		panel:show()
	end
end
function AllianceGroupManagerView:btnApplyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local i = button:getTag()
		if pyramidWarCtrl:getGroupManagerRank(i) > 0 then
			pyramidWarCtrl:newApplyPinnacleSeasonReq(self.legionInfoList[i].legionId)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
			self:initData()
		end
	end
end
function AllianceGroupManagerView:btnGoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ssid = button:getTag()
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = nil
			;(nil).sid = ssid
			uiManager:show("AllianceScience", nil)
		else
			local panel = SoraDCreatePanel("allianceScienceView")
			panel:jumpToSicence(ssid)
			panel:show()
		end
	end
end
function AllianceGroupManagerView:btnCreaeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceGroupCreateView")
		panel:initCreate()
		panel:show()
	end
end
function AllianceGroupManagerView:initData()
	self.legionInfoList = pyramidWarCtrl:getLegionInfoList()
	self.isShowLock = false
	for i, v in ipairs(self.tableFlag) do
		self:initFlag(i)
	end
end
function AllianceGroupManagerView:initApply()
	self.isPBLApply = true
	for i, v in ipairs(self.tableFlag) do
		self:initFlag(i)
	end
end
function AllianceGroupManagerView:initFlag(i)
	local data = self.legionInfoList[i]
	self.tableFlag[i].btnApply:setVisible(false)
	self.tableFlag[i].nodeUnlock:setVisible(false)
	self.tableFlag[i].spriteIn:setVisible(false)
	if data then
		self.tableFlag[i].labelName:setString(data.legionName)
		local cur_num = table.nums(data.memberList)
		local numColor = 0 < cur_num and self.tableFlag[i]:getColor() or display.COLOR_RED
		_ENV = nil
		;(nil).member = table.nums(data.memberList)
		_ENV, _ENV, (nil).total = data.memberList, ALLIANCE_GROUP_MEMBER_MAX, ALLIANCE_GROUP_MEMBER_MAX
		ALLIANCE_GROUP_MEMBER_MAX.member, data.memberList.color = data.memberList, numColor
		local strNum = i18n_html("common_text_155", nil, ALLIANCE_GROUP_MEMBER_MAX)
		self.tableFlag[i].labelNum:setString(strNum)
		self.tableFlag[i].btnCreate:setVisible(false)
		self.tableFlag[i].btnFlag:setTouchEnabled(true)
		self.tableFlag[i].btnFlag:setBright(true)
		self.tableFlag[i].nodeGroup:setVisible(true)
		self.tableFlag[i].spriteIn:setVisible(data.memberList[tostring(include("chatFunctions"):getSelfId())] ~= nil)
		self.tableFlag[i].spriteIndex:setVisible(0 < data.number)
		self.tableFlag[i].labelIndex:setString(data.number)
		self.tableFlag[i].labelTime:setVisible(0 < data.number)
		if 0 < data.number then
			if data.battleSeasonType == gSeasonType.PINNACLE_SEASON then
				self.tableFlag[i].labelTime:setString(pyramidWarltCtrl.getWeedTimeStrByData(data, "\n"))
			else
				self.tableFlag[i].labelTime:setString(pyramidWarltCtrl.getWeedTimeStr(data.number, pyramidWarCtrl.regularSeasonState ~= gRegularSeasonState.WAIT_APPLY_NEXT, "\n"))
			end
		end
		if self.isPBLApply then
			self.tableFlag[i].btnFlag:setTouchEnabled(false)
			self.tableFlag[i].btnFlag:setBright(true)
			if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.APPLY_ING_A and data.pinnacleSeasonAllianceState ~= gPinnacleSeasonAllianceState.PINNACLE_SIGN_UP then
				if 0 < pyramidWarCtrl:getGroupManagerRank(i) then
					self.tableFlag[i].btnApply:setVisible(true)
				else
					self.tableFlag[i].labelTime:setVisible(true)
					self.tableFlag[i].labelTime:setString(i18n("pyramid_text_41"))
				end
			else
				self.tableFlag[i].labelTime:setVisible(true)
				self.tableFlag[i].labelTime:setString(i18n("pyramid_text_66"))
				self.tableFlag[i].btnFlag:loadTextures("frame_flag_red.png", "", "", ccui.TextureResType.plistType)
				self.tableFlag[i].spriteFlag:setSpriteFrame("btn_JZT_pblbiaozhi.png")
			end
			self.tableFlag[i].spriteIndex:setVisible(false)
		end
		if data.battleSeasonType == gSeasonType.PINNACLE_SEASON then
			self.tableFlag[i].btnFlag:loadTextures("frame_flag_red.png", "", "", ccui.TextureResType.plistType)
			self.tableFlag[i].spriteFlag:setSpriteFrame("btn_JZT_pblbiaozhi.png")
			self.tableFlag[i].spriteIndex:setVisible(false)
		end
	else
		local unlock, ssdata = allianceltCtrl:getLegionUnlock(i)
		if not unlock then
			self.tableFlag[i].nodeUnlock:setVisible(true)
			if not self.isShowLock then
				_ENV = ""
				;("").name = allianceDesRead.getScienceName(ssdata[1])
				;("").num = ssdata[2]
				self.tableFlag[i].labelUnlock:setString(i18n("pyramid_text_46", ""))
				self.tableFlag[i].btnGo:setVisible(true)
				self.isShowLock = true
			else
				self.tableFlag[i].labelUnlock:setString("")
				self.tableFlag[i].btnGo:setVisible(false)
			end
			self.tableFlag[i].nodeGroup:setVisible(false)
			self.tableFlag[i].btnCreate:setVisible(false)
			self.tableFlag[i].btnFlag:setTouchEnabled(false)
			self.tableFlag[i].btnFlag:setBright(false)
			self.tableFlag[i].btnGo:setTag(ssdata[1])
		else
			self.tableFlag[i].nodeGroup:setVisible(false)
			self.tableFlag[i].btnCreate:setVisible(true)
			self.tableFlag[i].btnFlag:setTouchEnabled(false)
			self.tableFlag[i].btnFlag:setBright(false)
		end
	end
end
return AllianceGroupManagerView
