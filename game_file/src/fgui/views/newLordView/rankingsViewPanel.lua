local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rankingsViewPanel = class("rankingsViewPanel", baseFguiPanel)
function rankingsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rankingsViewPanel:ctor", self.viewName)
end
function rankingsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rankingsViewPanel:onInit()
	print("=======rankingsViewPanel:onInit")
	self.rankList, _ENV = print, print
	self.tab = 1
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function rankingsViewPanel:onShow()
	print("=======rankingsViewPanel:onShow")
	_UPVALUE9_, _ENV = "=======rankingsViewPanel:onShow", print
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[1] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.lordPower
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[2] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.lordKill
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[3] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.lordCastle
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[4] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.lordLevel
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[5] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.htStage
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[6] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.htLike
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[7] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.achieveDoneRatio
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[8] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.flowerNum
	_UPVALUE3_, print.lord, ("=======rankingsViewPanel:onShow")[9] = "=======rankingsViewPanel:onShow", "=======rankingsViewPanel:onShow", lordRankingsDef.militaryRank
	self.tableTitle, print.alliance, ("=======rankingsViewPanel:onShow")[1] = print, "=======rankingsViewPanel:onShow", lordRankingsDef.alliancePower
	self.tableTitle, print.alliance, ("=======rankingsViewPanel:onShow")[2] = print, "=======rankingsViewPanel:onShow", lordRankingsDef.allianceKill
	self.tableTitle, print.alliance, ("=======rankingsViewPanel:onShow")[3] = print, "=======rankingsViewPanel:onShow", lordRankingsDef.allianceTerrScore
	local cityltCtrl = include("cityltCtrl")
	local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, 1, BUILD_LVINFO.KINGDOMLV)
	local buildLogic = include("buildLogic")
	if buildLogic.checkKingdomLevel(unlockLv) then
		table.insert(self.tableTitle.lord, 4, lordRankingsDef.lordCastleStarLamp)
	end
	self.tab = 1
	_ENV = 4
	_ENV, _ENV, (4).defaultClick = lordRankingsDef.htLike, self.tab, self.tab
	lordRankingsDef.htLike.title = i18n("common_text_1152")
	_ENV, self.tab[1], lordRankingsDef.htLike.tag = lordRankingsDef.htLike, lordRankingsDef.htLike, 1
	lordRankingsDef.htLike.title = i18n("common_text_1153")
	;(4).tabsetArray, self.tab[2], lordRankingsDef.htLike.tag = self.tab, lordRankingsDef.htLike, 2
	;(4).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(4)
end
function rankingsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1], self.tab)
end
function rankingsViewPanel:onClickTab(tag)
	self.rankList, _ENV, self.tab = nil, nil, tag
	local rankCfg = self.tab == 1 and self.tableTitle.lord or self.tableTitle.alliance
	for i = 1, #rankCfg, 3 do
		_ENV = nil
		;(nil).data1 = rankCfg[i]
		;(nil).data2 = rankCfg[i + 1]
		;(nil).data3 = rankCfg[i + 2]
		table.insert(self.rankList, nil)
	end
	self.fields.List:setNumItems(#self.rankList)
end
return rankingsViewPanel
