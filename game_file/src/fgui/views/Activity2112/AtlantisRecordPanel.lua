local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisRecordPanel = class("AtlantisRecordPanel", baseFguiPanel)
function AtlantisRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisRecordPanel:ctor", self.viewName)
	local gametop = gModuleMgr.getObject("gametop")
	self.selfKid = gametop.playertop_:getMapID()
	self.isHidePrePanel = false
	self.debug = true
	self.selfTitle = KWKingdomCtrl:getAtlantisTitle()
	self:setVisible(false)
end
function AtlantisRecordPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "fonts"
	end
	return self._packageList
end
function AtlantisRecordPanel:refreshSelfTitle(...)
	self.selfTitle = KWKingdomCtrl:getAtlantisTitle()
end
function AtlantisRecordPanel:onInit()
	print("=======AtlantisRecordPanel:onInit")
	self.fields.Com_title:initData(i18n("atlantiswar_text_0397"), handler(self, self.onClickClose))
	self.fields.Com_titleCheck:fixChildrenPos()
	self.fields.Com_titleCheck:fixChildren()
	self.fields.Text_showTitle = self.fields.Com_titleCheck:getChild("Text_showTitle")
	self.fields.Text_showTitle:setString(i18n("atlantiswar_text_0422"))
	self.fields.Text_brief1:setString(i18n("atlantiswar_text_0402"))
	self.fields.Text_edit:setString(i18n("atlantiswar_text_0403"))
	self.fields.Button_edit:addClickListener(handler(self, self.onClickEdit))
	self.fields.Load_flag:addClickListener(handler(self, self.onClickFlag))
	self.fields.Check_tick = self.fields.Com_titleCheck:getChild("Check_tick")
	self.fields.Check_tick:addClickListener(handler(self, self.onClickCheck))
	self.fields.List_season:setItemRenderer(handler(self, self.onSeasonItemRenderer))
	self.fields.List_season:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function AtlantisRecordPanel:onShow()
	print("=======AtlantisRecordPanel:onShow")
	atlantisActivityCtrl:reqHistory()
end
function AtlantisRecordPanel:onSeasonItemRenderer(index, obj)
	local data = self.historyInfo[index + 1]
	obj:getChild("Text_season"):setString(data.season)
	local isEnd = false
	if SoraDFIsRA() then
		isEnd = index == 0
	else
		isEnd = index == #self.historyInfo - 1
	end
	obj:getController("c_end"):setSelectedIndex(isEnd and 1 or 0)
end
function AtlantisRecordPanel:onClickItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_season:getChildIndex(obj)
	local selectIndex = childIndex + 1
	if self.curSelect == selectIndex then
		return
	end
	self.curSelect = selectIndex
	self:initKingdomInfo()
end
function AtlantisRecordPanel:refreshView(historyInfo)
	self.historyInfo = historyInfo
	self:setVisible(true)
	if #self.historyInfo <= 0 then
		self:closePanel()
		SoraDShowMsgTip(i18n("atlantiswar_text_0034"))
		return
	end
	self.curSelect = 1
	self:initKingdomInfo()
	self.fields.List_season:setNumItems(#self.historyInfo)
	self.fields.List_season:scrollToView(self.curSelect - 1)
	self.fields.List_season:getChildAt(self.curSelect - 1):setSelected(true)
end
function AtlantisRecordPanel:initKingdomInfo(...)
	local data = self.historyInfo[self.curSelect]
	self.fields.Text_season:setString(data.season)
	local timeStr = os.date("!%Y.%m.%d", data.activeTime) .. "-" .. os.date("!%Y.%m.%d", data.finishTime)
	self.fields.Text_time:setString(timeStr)
	local kInfo = data.rankData[1]
	if kInfo then
		self.fields.Load_flag:setURL(allianceDesRead.getFlagIcon(kInfo.flag))
		_ENV = allianceDesRead.getFlagIcon(kInfo.flag)
		allianceDesRead.getFlagIcon(kInfo.flag).var = serviceFunctions.getKingdomFormatName(kInfo.kingdomName, kInfo.kid)
		self.fields.Text_name:setString(i18n("atlantiswar_text_0017", allianceDesRead.getFlagIcon(kInfo.flag)))
	else
		self.fields.Load_flag:setURL("Allianceflag_001.png")
		self.fields.Text_name:setString(i18n("common_text_480"))
	end
	if self:checkIsKing() then
		self.controllers.c_isKing:setSelectedIndex(1)
		self.fields.Check_tick:setSelected(self.selfTitle == data.season)
		self.fields.Button_edit:setVisible(true)
	else
		self.controllers.c_isKing:setSelectedIndex(0)
	end
	if not kInfo or not kInfo.top3UserInfo then
		local _ENV, top3UserInfo = kInfo.top3UserInfo, kInfo.top3UserInfo
	end
	for i = 1, 3 do
		local Com_player = self.fields["Com_player" .. i]
		local Text_name = Com_player:getChild("Text_name")
		local Com_head = Com_player:getChild("Com_head")
		local c_hasPlayer = Com_player:getController("c_hasPlayer")
		local Load_head = Com_head:getLoadHead()
		local uInfo = top3UserInfo[i]
		if uInfo then
			Com_head:setHeadSprite(uInfo.headid, uInfo.avatar)
			Com_head:setPlayerID(uInfo.uid)
			Com_head:setKid(kInfo.kid)
			Text_name:setString(serviceFunctions.getKingdomFormatName(uInfo.nickName, kInfo.kid))
			c_hasPlayer:setSelectedIndex(0)
			Load_head:setVisible(true)
		else
			Text_name:setString(i18n("common_text_480"))
			c_hasPlayer:setSelectedIndex(1)
			Load_head:setVisible(false)
		end
	end
	if kInfo and kInfo.legionBrief then
		self.fields.Text_brief2:setString(kInfo.legionBrief)
		self.controllers.c_edit:setSelectedIndex(1)
	else
		self.controllers.c_edit:setSelectedIndex(0)
	end
end
function AtlantisRecordPanel:checkIsKing(showTip)
	if not SoraDIsSelfKing() then
		if showTip then
			SoraDShowMsgTip(i18n("atlantiswar_text_0406"))
		end
		return false
	end
	local data = self.historyInfo[self.curSelect]
	local kInfo = data.rankData[1]
	if not kInfo or kInfo.kid ~= self.selfKid then
		return false
	end
	return true
end
function AtlantisRecordPanel:onClickEdit(...)
	if not self:checkIsKing(true) then
		self.controllers.c_isKing:setSelectedIndex(0)
		return
	end
	local data = self.historyInfo[self.curSelect]
	_ENV = nil
	;(nil).season = data.season
	uiManager:show("AtlantisBriefEdit", nil)
end
function AtlantisRecordPanel:onClickFlag(...)
	SoraDPlaySound()
	local data = self.historyInfo[self.curSelect]
	local kInfo = data.rankData[1]
	if not kInfo then
		return
	end
	if worldMapDefine.isInAtlantis() then
		SoraDShowMsgTip(i18n("atlantiswar_text_0009"))
		return
	end
	local panel = SoraDSearchPanelFromManagerByName("bigWorldView")
	if panel then
		panel.isHidePrePanel = false
		panel:closePanel()
	end
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType(kInfo.kid)
	_ENV = i18n("atlantiswar_text_0009")
	i18n("atlantiswar_text_0009").regionType = regionType
	i18n("atlantiswar_text_0009").regionId = regionId
	local bigWorldView = uiManager:show("BigWorldView", i18n("atlantiswar_text_0009"))
	_ENV = i18n("atlantiswar_text_0009")
	i18n("atlantiswar_text_0009").kid = kInfo.kid
	bigWorldView:jumpToKingdom(nil, i18n("atlantiswar_text_0009"))
end
function AtlantisRecordPanel:onClickCheck(...)
	print("==AtlantisRecordPanel:onClickCheck==")
	if not self:checkIsKing(true) then
		self.fields.Check_tick:setSelected(not self.fields.Check_tick:isSelected())
		self.controllers.c_isKing:setSelectedIndex(0)
		return
	end
	local Check_tick = self.fields.Check_tick
	local isSelect = Check_tick:isSelected()
	local season = self.historyInfo[self.curSelect].season
	if isSelect then
		if self.selfTitle then
			Check_tick:setSelected(false)
			_ENV = nil
			;(nil).season1 = self.selfTitle
			;(nil).season2 = season
			SoraDShowMsgBox(i18n("atlantiswar_text_0401", nil), nil, nil, function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					Check_tick:setSelected(true)
					atlantisWarCtrl:reqSetAtlantisTitle(season)
				end
			end)
		else
			atlantisWarCtrl:reqSetAtlantisTitle(season)
		end
	else
		Check_tick:setSelected(true)
		_ENV = nil
		;(nil).season = season
		SoraDShowMsgBox(i18n("atlantiswar_text_0400", nil), nil, nil, function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				Check_tick:setSelected(false)
				atlantisWarCtrl:reqSetAtlantisTitle()
			end
		end)
	end
end
function AtlantisRecordPanel:refreshBrief(target, data)
	local rspdata = data.rspdata
	for i, v in ipairs(self.historyInfo) do
		if v.season == rspdata.season then
			local kInfo = v.rankData[1]
			kInfo.legionBrief = rspdata.brief
			break
		end
	end
	local data = self.historyInfo[self.curSelect]
	if data.season ~= rspdata.season then
		return
	end
	self.fields.Text_brief2:setString(rspdata.brief)
	self.controllers.c_edit:setSelectedIndex(1)
end
return AtlantisRecordPanel
