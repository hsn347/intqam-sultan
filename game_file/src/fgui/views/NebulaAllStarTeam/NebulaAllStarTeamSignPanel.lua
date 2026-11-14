local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarTeamSignPanel = class("NebulaAllStarTeamSignPanel", baseFguiPanel)
function NebulaAllStarTeamSignPanel:ctor(...)
	NebulaAllStarTeamSignPanel.super.ctor(self, ...)
	print("NebulaAllStarTeamSignPanel:ctor", self.viewName)
	self.selfUid = gametop.playertop_:getPlayerID()
end
function NebulaAllStarTeamSignPanel:onInit()
	print("=======NebulaAllStarTeamSignPanel:onInit")
	self.fields.Com_title:initData(i18n("NebulaAllstar_96"), handler(self, self.onClickClose))
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).num = 0
	self.fields.Text_sign:setString(i18n("NebulaAllstar_97", handler(self, self.onClickClose)))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_title1:setString(i18n("NebulaAllstar_98"))
	_fields.Text_title2:setString(i18n("common_text_2037"))
	_fields.Text_title3:setString(i18n("common_text_090"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setVirtual()
	self.fields.Text_notice:setString(i18n("NebulaAllstar_280"))
	self.fields.Text_tip:setString(i18n("NebulaAllstar_274"))
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function NebulaAllStarTeamSignPanel:onShow()
	print("=======NebulaAllStarTeamSignPanel:onShow")
	nebulaAllStarCtrl:reqBackupRank()
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarTeamSignPanel:onItemRederer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		obj.c_self = obj:getController("c_self")
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local data = self.rankData[index + 1]
	_fields.Com_head:setHeadSprite(data.headid, data.avatar)
	_fields.Com_head:setAvatarFrame(data.avatarFrameId)
	local nameStr = textParser.formatPlayerName(nil, data.nickName, data.kid)
	_fields.Text_name:setString(nameStr)
	_fields.Text_score:setString(string.formatnumberthousands(data.oneMonthMaxFc or 0))
	local isSelf = self.selfUid == data.uid
	obj.c_self:setSelectedIndex(isSelf and 1 or 0)
	_ENV = isSelf and 1 or 0
	;(isSelf and 1 or 0).rank = data.rank
	;(isSelf and 1 or 0).isSelf = isSelf
	_fields.Com_rankBase:initRankBaseData(isSelf and 1 or 0)
end
function NebulaAllStarTeamSignPanel:onMsgSignRankBack(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	local total = rspdata.total or 0
	_ENV = self:displayObject()
	self:displayObject().num = total
	self.fields.Text_sign:setString(i18n("NebulaAllstar_97", self:displayObject()))
	if not rspdata.rankData then
		_ENV = rspdata.rankData
	end
	self.rankData = rspdata.rankData
	self.fields.List:setNumItems(#self.rankData)
	self.fields.Text_notice:setVisible(0 >= #self.rankData)
end
return NebulaAllStarTeamSignPanel
