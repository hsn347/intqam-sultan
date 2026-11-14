local activity_9001676_Read = include("activity_9001676_Read")
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local MAX_RANK_NUM = 100
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_RankPanel = class("Activity_9001676_RankPanel", baseFguiPanel)
function Activity_9001676_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_RankPanel.super.ctor(self, ...)
	print("Activity_9001676_RankPanel:ctor", self.viewName)
end
function Activity_9001676_RankPanel:onInit()
	print("=======Activity_9001676_RankPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Korean_chess_text101"))
	self.fields.Text_noData:setString(i18n("god_beast_text_16"))
	self.fields.Text_noData:setVisible(false)
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_count:setString(i18n("Korean_chess_text102"))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_count:fixPos()
end
function Activity_9001676_RankPanel:onRankItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1)
end
function Activity_9001676_RankPanel:endShow()
	print("=======Activity_9001676_RankPanel:endShow")
	self.rankList, _ENV, self.isInit = print, print, true
	self.selfRank = 0
	self.selfScore = 0
	self:updateUI()
end
function Activity_9001676_RankPanel:updateUI()
	if self.isInit then
		self.isInit = false
		activity_9001676_Ctrl:reqKoreanChessPlayerSpeedRank(1, MAX_RANK_NUM)
		SoraDShowLoading(self)
	else
		self:updateRankView()
	end
end
function Activity_9001676_RankPanel:rankMsgBack(target, data)
	SoraDCloseLoading(self)
	if not data.rankList then
		_ENV = data.rankList
	end
	self.rankList = data.rankList
	if not data.myInfo then
		_ENV = data.myInfo
	end
	self.myInfo = data.myInfo
	self:updateRankView()
end
function Activity_9001676_RankPanel:updateRankView()
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	self.fields.Com_self:initData(self.myInfo, self.myInfo.rank, true)
	self.controllers.ctrlNoData:setSelectedIndex(#self.rankList == 0 and 1 or 0)
end
return Activity_9001676_RankPanel
