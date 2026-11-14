local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local allianceDesRead = include("allianceDesRead")
local palaceInfoRead = include("palaceInfoRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleWarStatusPanel = class("kingdomBattleWarStatusPanel", baseFguiPanel)
function kingdomBattleWarStatusPanel:ctor(...)
	self.isLRU = true
	kingdomBattleWarStatusPanel.super.ctor(self, ...)
	print("kingdomBattleWarStatusPanel:ctor", self.viewName)
end
function kingdomBattleWarStatusPanel:onInit()
	print("=======kingdomBattleWarStatusPanel:onInit")
	self.battery = palaceInfoRead.getBatteryConfig()
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_4906"), handler(self, self.onClickClose))
	self.fields.Button_rank:setTitle(i18n("atlantiswar_text_0304"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Label_time_cx:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_4907", nil)
	end)
	self.fields.Label_time_lj:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_4908", nil)
	end)
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#FFFFFF", time)
		return i18n("common_text_2553", nil)
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function kingdomBattleWarStatusPanel:onItemRender(index, obj)
	obj:initData(self.battery[index + 1], self.data.buildOwnersAndOccupyTime.buildingOwners, self.data.buildOwnersAndOccupyTime.kingInfo, self.kid)
end
function kingdomBattleWarStatusPanel:btnRankClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).kid = self.kid
	uiManager:show("kingdomBattleWarRank", nil)
end
function kingdomBattleWarStatusPanel:endShow()
	print("=======kingdomBattleWarStatusPanel:endShow")
	self.kid = self.param.kid
	self.castleModel = self.param.castleModel or 1
	self.fields.icon_castle:setURL(palaceInfoRead.getImg(self.castleModel))
	conquestWarCtrl:reqBattleInfo(self.kid)
	SoraDShowLoading(self)
end
function kingdomBattleWarStatusPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.data = data.data
	local castleOwnerData = self.data.buildOwnersAndOccupyTime.buildingOwners[tostring(gPlaceId)]
	if castleOwnerData then
		self.fields.Com_head:setVisible(true)
		self.fields.Com_head:setHeadSprite(castleOwnerData.iconID, castleOwnerData.avatar)
		self.fields.Com_head:setPlayerID(castleOwnerData.uid)
		self.fields.Com_head:setKid(castleOwnerData.hostKid)
		self.fields.Text_name:setString(textParser.formatPlayerName(castleOwnerData.abbr, castleOwnerData.name))
		self.fields.Lab_aInfo:setVisible(true)
		self.fields.Lab_aInfo:setIcon(allianceDesRead.getFlagIcon(castleOwnerData.flag))
		self.fields.Lab_aInfo:setTitle(castleOwnerData.aName)
	else
		self.fields.Com_head:setVisible(false)
		self.fields.Text_name:setString(i18n("atlantiswar_text_0069"))
		self.fields.Lab_aInfo:setVisible(false)
	end
	local currSecs = self.data.buildOwnersAndOccupyTime.currSecs or 0
	local histSecs = self.data.buildOwnersAndOccupyTime.histSecs or 0
	if 0 < currSecs then
		self.fields.Label_time_cx:setVisible(true)
		self.fields.Label_time_cx:beginTime(currSecs, true)
	else
		self.fields.Label_time_cx:setVisible(false)
	end
	if 0 < currSecs + histSecs then
		self.fields.Label_time_lj:setVisible(true)
		self.fields.Label_time_lj:beginTime(currSecs + histSecs, true)
	else
		self.fields.Label_time_lj:setVisible(false)
	end
	self.fields.List:setNumItems(#self.battery)
	if not self.data.matchKingdomInfo then
		local _ENV, matchKingdomInfo = self.data.matchKingdomInfo, self.data.matchKingdomInfo
	end
	local _ENV, tempData = self.fields.List, self.fields.List
	for _, v in pairs(matchKingdomInfo) do
		table.insert(tempData, v)
	end
	table.sort(tempData, function(a, b)
		return a.kid < b.kid
	end)
	_ENV = table.sort
	table.sort.blue = tempData[1]
	local table.sort.red, warInfo = tempData[2], table.sort
	self.fields.com_Fight:initData(warInfo)
	local leftTime = self.data.warEndTime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Label_time:beginTime(leftTime)
	end
end
return kingdomBattleWarStatusPanel
