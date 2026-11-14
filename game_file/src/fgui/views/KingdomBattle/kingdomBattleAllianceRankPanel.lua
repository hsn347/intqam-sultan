local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleAllianceRankPanel = class("kingdomBattleAllianceRankPanel", baseFguiPanel)
function kingdomBattleAllianceRankPanel:ctor(...)
	kingdomBattleAllianceRankPanel.super.ctor(self, ...)
	print("kingdomBattleAllianceRankPanel:ctor", self.viewName)
	self.sIndex = 1
	self.wGet = false
	self.kid = lordInfoCtrl:getMapSourceKid()
	self.rankList, kingdomBattleAllianceRankPanel, self.selfUid = gametop.playertop_:getPlayerID(), gametop.playertop_:getPlayerID(), gametop.playertop_:getPlayerID()
end
function kingdomBattleAllianceRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleAllianceRankPanel:onInit()
	print("=======kingdomBattleAllianceRankPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3153"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local Com_rankTitle = self.fields.Com_rankTitle
	Com_rankTitle:fixChildrenPos()
	local titleFields = fguiHelper.get_fields(Com_rankTitle)
	titleFields.Text_name:setString(i18n("common_text_264"))
	titleFields.Text_score:setString(i18n("common_text_1764"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
end
function kingdomBattleAllianceRankPanel:onShow()
	print("=======kingdomBattleAllianceRankPanel:onShow")
	self:req4Data(self.sIndex)
end
function kingdomBattleAllianceRankPanel:onClickHelp(...)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.KINGDOMBATTLE_HELP)
end
function kingdomBattleAllianceRankPanel:req4Data(index)
	conquestWarCtrl:reqGetRankInAlliance(index)
	SoraDShowLoading(self:displayObject())
end
function kingdomBattleAllianceRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function kingdomBattleAllianceRankPanel:onPullUpRelease(...)
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function kingdomBattleAllianceRankPanel:refreshRankSingle(obj, rank, data)
	if not obj.objFields then
		obj.objFields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
		obj.objFields.Load_bg:fix()
	end
	local objFields = obj.objFields
	if 0 < rank and rank <= 3 then
		obj.controllers.c_top3:setSelectedIndex(0)
		objFields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		objFields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		obj.controllers.c_top3:setSelectedIndex(1)
		if 0 < rank and rank <= 150 then
			objFields.Text_rank:setString(tostring(rank))
		else
			objFields.Text_rank:setString(i18n("herobattle_text_05"))
		end
		objFields.Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.uid == self.selfUid then
		objFields.Load_bg:setURL("frame_alliance_pank_05.png")
	end
	local Com_head = objFields.Com_head
	Com_head:setHeadSprite(data.iconID, data.avatar)
	Com_head:setPlayerID(data.uid)
	local _kid = self.kid
	if data.sourceKid and 0 < data.sourceKid then
		_kid = data.sourceKid
	elseif data.kid and 0 < data.kid then
		_kid = data.kid
	end
	if 0 < checknumber(data.aid) and 0 < checknumber(data.alliancerank) then
		objFields.Text_name:setString("(" .. data.abbr .. ")" .. data.nickName .. "#" .. _kid)
	else
		objFields.Text_name:setString(data.nickName .. "#" .. _kid)
	end
	objFields.Text_score:setString(0 < data.score and string.formatnumberthousands(data.score) or i18n("common_text_827"))
end
function kingdomBattleAllianceRankPanel:initData(target, rspdata)
	dump(rspdata, "==kingdomBattleAllianceRankPanel:initData==")
	SoraDCloseLoading(self:displayObject())
	if self.sIndex == 1 then
		if not rspdata.myInfo then
			local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		local lordInfo = lordInfoCtrl:getLordInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.abbr = lordInfo.abbr
		local lordInfoCtrl.nickName, data = lordInfo.base.nickName, lordInfoCtrl
		if myInfo then
			data.rank = myInfo.rank or 0
			data.score = myInfo.score or 0
			self.myInfo = myInfo
		end
		self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, data)
	end
	self.sIndex = rspdata.idx
	self.wGet = rspdata.wget
	if next(rspdata.rankList) ~= nil then
		self.rankList = rspdata.rankList
	else
		return
	end
	self.fields.List_rank:setNumItems(#self.rankList)
end
return kingdomBattleAllianceRankPanel
