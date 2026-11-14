local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRankPanel = require("fgui.views.NebulaEmperor.NebulaEmperorRankPanel")
local NebulaEmperorGloryRankPanel = class("NebulaEmperorGloryRankPanel", NebulaEmperorRankPanel)
_ENV = "NebulaEmperorGloryRankPanel"
;("NebulaEmperorGloryRankPanel").TYPE_CAMP = 1
local ("NebulaEmperorGloryRankPanel").TYPE_PLAYER, RANK_TYPE = 2, "NebulaEmperorGloryRankPanel"
function NebulaEmperorGloryRankPanel:ctor(...)
	NebulaEmperorGloryRankPanel.super.ctor(self, ...)
	print("NebulaEmperorGloryRankPanel:ctor", self.viewName)
end
function NebulaEmperorGloryRankPanel:onInit()
	print("=======NebulaEmperorGloryRankPanel:onInit")
	self.rankType = self.param.rankType
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	_ENV = "=======NebulaEmperorGloryRankPanel:onInit"
	;("=======NebulaEmperorGloryRankPanel:onInit")[1] = i18n("nebulaemperor_text_92")
	local ("=======NebulaEmperorGloryRankPanel:onInit")[2], config = i18n("nebulaemperor_text_93"), "=======NebulaEmperorGloryRankPanel:onInit"
	self.fields.Com_title:initData(config[self.rankType], handler(self, self.onClickClose), handlerHelp)
	self.fields.Com_rankTitle:fixChildrenPos()
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	_fields.Text_title3:setString(i18n("common_text_2193"))
	self.Text_title1 = _fields.Text_title1
	self.Text_title2 = _fields.Text_title2
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
end
function NebulaEmperorGloryRankPanel:onShow()
	print("=======NebulaEmperorGloryRankPanel:onShow")
	if self.rankType == RANK_TYPE.TYPE_CAMP then
		self.hasMore = false
		self.rankList = self.param.rankList
		self:updateRankList()
	else
		self:req4Data()
	end
	self:updateRankTitle()
end
function NebulaEmperorGloryRankPanel:req4Data()
	nebulaEmperorCtrl:reqBiographyRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function NebulaEmperorGloryRankPanel:refreshRankData(rspdata)
	local _ENV, rankList = nil, rspdata or nil
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self:updateRankList()
end
function NebulaEmperorGloryRankPanel:updateRankList(...)
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
return NebulaEmperorGloryRankPanel
