local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_RankPanel = class("Activity_9001573_RankPanel", baseFguiPanel)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
function Activity_9001573_RankPanel:ctor(...)
	Activity_9001573_RankPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001573_RankPanel:ctor", self.viewName)
end
function Activity_9001573_RankPanel:onInit()
	print("=======Activity_9001573_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("Celestial_defense_text_043"), handler(self, self.onClickClose))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.title1:setString(i18n("common_text_2193"))
	self.fields.title2:setString(i18n("hero_text_93"))
	self.fields.title3:setString(i18n("Celestial_defense_text_044"))
end
function Activity_9001573_RankPanel:onShow()
	print("=======Activity_9001573_RankPanel:onShow")
	self:req4Data()
end
function Activity_9001573_RankPanel:updateUI()
	self:req4Data()
end
function Activity_9001573_RankPanel:req4Data()
	activity_9001573_Ctrl:reqRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001573_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function Activity_9001573_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.rankList then
		_ENV = rspdata.rankList
	end
	self.rankList = rspdata.rankList
	local _ENV, myInfo = rspdata.rankList, rspdata.rankList
	for i, v in ipairs(self.rankList) do
		activity_9001573_Ctrl = self:displayObject()
		self:displayObject()[1] = i
		self:displayObject()[2] = rspdata.selfRank
		dump(self:displayObject())
		if i == rspdata.selfRank then
			myInfo = v
		end
	end
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfo = lordInfoCtrl:getLordInfo()
	_ENV = lordInfoCtrl
	lordInfoCtrl.nickName = lordInfo.base.nickName
	local lordInfoCtrl.kid, data = gametop.playertop_:getKingdomID(), lordInfoCtrl
	if myInfo then
		data.ranking = myInfo.ranking or activity_9001573_Ctrl:getMyPoint()
		data.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or nil
	end
	self.fields.Com_ownRank:setVisible(true)
	local rank = rspdata.selfRank or 0
	_ENV = "i == rspdata.selfRank"
	;("i == rspdata.selfRank").index = 100 < rank and 0 or rank
	;("i == rspdata.selfRank").bootom = 1
	;("i == rspdata.selfRank").kid = data.kid
	self.fields.Com_ownRank:initData(data, "i == rspdata.selfRank")
	dump(rspdata.rankList, "rspdata.rankList")
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
return Activity_9001573_RankPanel
