local djCtrl = SoraDGetCtrl("djCtrl")
local djRead = include("djRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjValueRankViewPanel = class("DjValueRankViewPanel", baseFguiPanel)
function DjValueRankViewPanel:ctor(...)
	self.isLRU = true
	DjValueRankViewPanel.super.ctor(self, ...)
	print("DjValueRankViewPanel:ctor", self.viewName)
end
function DjValueRankViewPanel:onInit()
	print("=======DjValueRankViewPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Com_title:initData(i18n("Anchor_text_93"), handler(self, self.onClickClose))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_val:setString(i18n("Anchor_text_89"))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_val:fixPos()
end
function DjValueRankViewPanel:endShow()
	print("=======DjValueRankViewPanel:endShow")
	self.tag = self.param and self.param.tag or 1
	self.isDJ = self.param and self.param.isDJ or false
	self.fields.Com_title:updateTitle(self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93"))
	_ENV = self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93")
	_ENV, _ENV, (self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93")).defaultClick = nil, self.tag, self.tag
	;(nil).title = self.isDJ and i18n("Anchor_text_130") or i18n("Anchor_text_94")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = self.isDJ and i18n("Anchor_text_131") or i18n("Anchor_text_95")
	;(self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93")).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93")).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(self.isDJ and i18n("Anchor_text_129") or i18n("Anchor_text_93"))
end
function DjValueRankViewPanel:onTabClick(tag)
	self.tag = tag
	if self.isDJ then
		self.fields.Text_val:setString(self.tag == 1 and i18n("Anchor_text_132") or i18n("Anchor_text_133"))
	else
		self.fields.Text_val:setString(i18n("Anchor_text_89"))
	end
	local rankType = djRead.gChatAnchorRankType.MEMBER_MONTH
	if self.isDJ then
		rankType = self.tag == 1 and djRead.gChatAnchorRankType.ANCHOR_POPULARITY_MONTH or djRead.gChatAnchorRankType.ANCHOR_POPULARITY_TOTAL
	else
		rankType = self.tag == 1 and djRead.gChatAnchorRankType.MEMBER_MONTH or djRead.gChatAnchorRankType.MEMBER_TOTAL
	end
	djCtrl:initChatDJRank(nil, rankType)
	SoraDShowLoading(self)
end
function DjValueRankViewPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.rankInfo = data.rankInfo
	self.selfInfo = data.selfInfo
	self.fields.List:setNumItems(#self.rankInfo)
	local rankStr = self.selfInfo.rank
	local limitNum = self.isDJ and 50 or 200
	if self.selfInfo.rank == 0 then
		rankStr = i18n("herobattle_text_05")
	elseif limitNum < self.selfInfo.rank then
		rankStr = tostring(limitNum) .. "+"
	end
	_ENV = nil
	;(nil).rankStr = rankStr
	self.fields.Com_self:initData(self.selfInfo, nil)
end
function DjValueRankViewPanel:itemRenderer_List(index, obj)
	local data = self.rankInfo[index + 1]
	obj:initData(data)
end
return DjValueRankViewPanel
