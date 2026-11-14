local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorGloryPanel = class("NebulaEmperorGloryPanel", baseFguiPanel)
function NebulaEmperorGloryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorGloryPanel:ctor", self.viewName)
	self.gloryData, _ENV, self.isHideCurrentSceneView = print, print, true
end
function NebulaEmperorGloryPanel:onInit()
	print("=======NebulaEmperorGloryPanel:onInit")
	self.fields.Com_title:initData(i18n("nebulaemperor_text_20"), handler(self, self.onClickClose))
	self.fields.List_season:setItemRenderer(handler(self, self.onSeasonItemRenderer))
	self.fields.List_season:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Text_brief1:setString(i18n("nebulaemperor_text_132"))
	self.fields.Button_edit:setString(i18n("common_text_244"))
	self.fields.Button_edit:setString(i18n("common_text_244"))
	self.fields.Button_edit:addClickListener(handler(self, self.onClickEdit))
	self.fields.Button_edit:setVisible(false)
	self.fields.Button_rank1:setString(i18n("nebulaemperor_text_92"))
	self.fields.Button_rank1:addClickListener(handler(self, self.onClickBtnRank))
	self.fields.Button_rank2:setString(i18n("nebulaemperor_text_93"))
	self.fields.Button_rank2:addClickListener(handler(self, self.onClickBtnRank))
end
function NebulaEmperorGloryPanel:onShow()
	print("=======NebulaEmperorGloryPanel:onShow")
	local seasonMax = nebulaEmperorCtrl:getGlorySeasonMax()
	self.seasonMax = seasonMax
	self.fields.List_season:setNumItems(seasonMax)
	self:updateCurSeason(seasonMax)
	local itemIndex = self.curSeason - 1
	self.fields.List_season:scrollToView(itemIndex)
	local item = self.fields.List_season:getChildAt(itemIndex)
	item:setSelected(true)
	item:getChild("mv_ryxz"):setAllFrameName("dh_xingyunryxz_%02d.png", 1)
end
function NebulaEmperorGloryPanel:updateCurSeason(season)
	self.curSeason = season
	self.fields.Com_season:setString("S" .. season)
	nebulaEmperorCtrl:reqBiography(season)
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorGloryPanel:onSeasonItemRenderer(index, obj)
	local season = index + 1
	obj:setString("S" .. season)
	local Image_1 = obj:getChild("Image_1")
	if SoraDFIsRA() then
		Image_1:setVisible(season ~= self.seasonMax)
	else
		Image_1:setVisible(season ~= 1)
	end
end
function NebulaEmperorGloryPanel:onClickItem(EventContext)
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_season:getChildIndex(obj)
	local selectSeason = childIndex + 1
	if self.curSeason == selectSeason then
		return
	end
	self:updateCurSeason(selectSeason)
end
function NebulaEmperorGloryPanel:onClickEdit(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).season = self.curSeason
	;(nil).warType = gKingdomClassType.nebulaEmperor
	uiManager:show("AtlantisBriefEdit", nil)
end
function NebulaEmperorGloryPanel:onClickBtnRank(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_rank1 then
		if not self.gloryData[self.curSeason] then
			local _ENV, data = self.gloryData[self.curSeason], self.gloryData[self.curSeason]
		end
		if not data.campOccupyRank then
			local _ENV, campOccupyRank = data.campOccupyRank, data.campOccupyRank
		end
		_ENV = nil
		;(nil).rankType = 1
		;(nil).rankList = campOccupyRank
		uiManager:show("NebulaEmperorGloryRank", nil)
	elseif sender == self.fields.Button_rank2 then
		_ENV = uiManager
		uiManager.rankType = 2
		uiManager:show("NebulaEmperorGloryRank", uiManager)
	end
end
function NebulaEmperorGloryPanel:onMsgReqGloryData(target, event)
	SoraDCloseLoading(self:displayObject())
	local rspdata = event.rspdata
	if rspdata then
		local round = rspdata.round
		self.gloryData[round] = rspdata
		self:updateEmperorInfo()
	end
	local edict = event.edict
	if edict then
		local data = self.gloryData[self.curSeason]
		data.edict = edict
	end
	self:updateTextBrief()
	self:updateBtnEdit()
end
function NebulaEmperorGloryPanel:updateEmperorInfo(...)
	if not self.gloryData[self.curSeason] then
		local _ENV, data = self.gloryData[self.curSeason], self.gloryData[self.curSeason]
	end
	local info = data.emperorInfo
	if info then
		local mailFunctions = include("mailFunctions")
		local nameStr = mailFunctions:getWrappedName(info.teamAbbr, info.nickName, info.fromKid)
		self.fields.Text_name:setString(nameStr)
	else
		self.fields.Text_name:setString(i18n("nebula_war_text_0484"))
	end
end
function NebulaEmperorGloryPanel:updateTextBrief(...)
	if not self.gloryData[self.curSeason] then
		local _ENV, data = self.gloryData[self.curSeason], self.gloryData[self.curSeason]
	end
	if data.edict and data.edict ~= "" then
		self.fields.Text_brief2:setString(data.edict)
	else
		self.fields.Text_brief2:setString(i18n("nebulaemperor_text_227"))
	end
end
function NebulaEmperorGloryPanel:updateBtnEdit(...)
	self.fields.Button_edit:setVisible(self:checkEditState())
end
function NebulaEmperorGloryPanel:checkEditState()
	if not self.gloryData[self.curSeason] then
		local _ENV, data = self.gloryData[self.curSeason], self.gloryData[self.curSeason]
	end
	if data.edict and data.edict ~= "" then
		return false
	end
	local info = data.emperorInfo
	if info then
		local gametop = gModuleMgr.getObject("gametop")
		local selfPlayerID = gametop.playertop_:getPlayerID()
		return info.uid == selfPlayerID
	end
	return false
end
return NebulaEmperorGloryPanel
