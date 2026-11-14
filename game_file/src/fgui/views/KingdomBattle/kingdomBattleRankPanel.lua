local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleAllianceRankPanel = require("fgui.views.KingdomBattle.kingdomBattleAllianceRankPanel")
local kingdomBattleRankPanel = class("kingdomBattleRankPanel", kingdomBattleAllianceRankPanel)
function kingdomBattleRankPanel:ctor(...)
	kingdomBattleRankPanel.super.ctor(self, ...)
	print("kingdomBattleRankPanel:ctor", self.viewName)
	self.myRank = 0
end
function kingdomBattleRankPanel:onInit(...)
	kingdomBattleRankPanel.super.onInit(self, ...)
	self.fields.Com_title:setTitle(i18n("common_text_1469"))
	self.fields.Com_ownRank:addClickListener(handler(self, self.onClickOwnRank))
end
function kingdomBattleRankPanel:req4Data(index)
	conquestWarCtrl:getConquestWarRankReq()
	SoraDShowLoading(self:displayObject())
end
function kingdomBattleRankPanel:refreshRankSingle(obj, rank, data)
	kingdomBattleRankPanel.super.refreshRankSingle(self, obj, rank, data)
	local objFields = obj.objFields
	local isEmenyAlliance = data.kid ~= self.kid
	obj.controllers.c_rankType:setSelectedIndex(1)
	kingdomBattleRankPanel = nil
	;(nil).power = string.formatnumberthousands(data.power)
	objFields.Text_power:setString(i18n("common_text_128", nil))
	if data.aid and data.aid > 0 then
		if isEmenyAlliance then
			objFields.Text_pname:setString("(" .. data.abbr .. ")" .. data.nickName .. "#" .. data.kid)
		else
			objFields.Text_pname:setString("(" .. data.abbr .. ")" .. data.nickName)
		end
	elseif isEmenyAlliance then
		objFields.Text_pname:setString(data.nickName .. "#" .. data.kid)
	else
		objFields.Text_pname:setString(data.nickName)
	end
	if not data.isOwn then
		if isEmenyAlliance then
			objFields.Text_power:setColor(cc.c3b(115, 155, 215))
			objFields.Text_pname:setColor(cc.c3b(115, 155, 215))
		else
			objFields.Text_power:setColor(cc.c3b(255, 115, 115))
			objFields.Text_pname:setColor(cc.c3b(255, 115, 115))
		end
	end
end
function kingdomBattleRankPanel:onClickOwnRank(...)
	if self.rankList[self.myRank] then
		self.fields.List_rank:scrollToView(self.myRank - 1, true, true)
	end
end
function kingdomBattleRankPanel:initData(target, event)
	dump(event, "==kingdomBattleRankPanel:initData==", 10)
	SoraDCloseLoading(self:displayObject())
	local rspdata = event.data
	if next(rspdata.ranklist) ~= nil then
		self.rankList = rspdata.ranklist
	end
	local lordInfo = lordInfoCtrl:getLordInfo()
	_ENV = lordInfoCtrl
	lordInfoCtrl.abbr = lordInfo.abbr
	lordInfoCtrl.nickName = lordInfo.base.nickName
	lordInfoCtrl.power = lordInfo.fcInfo.totalFc
	lordInfoCtrl.aid = allianceMgr:getOwnAid()
	lordInfoCtrl.kid = self.kid
	local lordInfoCtrl.isOwn, data = true, lordInfoCtrl
	if rspdata then
		self.myRank = rspdata.myrank or 0
		data.rank = self.myRank
		data.score = self.rankList[self.myRank] and self.rankList[self.myRank].score or 0
	end
	self:refreshRankSingle(self.fields.Com_ownRank, data.rank or 0, data)
	self.fields.List_rank:setNumItems(#self.rankList)
end
return kingdomBattleRankPanel
