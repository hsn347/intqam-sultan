local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMemberBattlePointViewPanel = class("allianceMemberBattlePointViewPanel", baseFguiPanel)
function allianceMemberBattlePointViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMemberBattlePointViewPanel:ctor", self.viewName)
end
function allianceMemberBattlePointViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMemberBattlePointViewPanel:onInit()
	print("=======allianceMemberBattlePointViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_btn_21"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_power:setString(i18n("common_text_090"))
	self.fields.Text_none:setString(i18n("herobattle_text_05"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_power:fixPos()
end
function allianceMemberBattlePointViewPanel:onItemRenderer(index, obj)
	local info = self.memberList[index + 1]
	_UPVALUE0_ = index + 1
	;(index + 1).rank = info.rank
	;(index + 1).num = info.data.uinfo.totalFc
	;(index + 1).nickName = info.data.uinfo.nickName
	;(index + 1).allianceAbbr = info.data.allianceAbbr
	;(index + 1).uid = info.data.minfo.uid
	;(index + 1).iconID = info.data.uinfo.iconID
	local (index + 1).avatar, data = info.data.uinfo.avatar, index + 1
	obj:setHeight(92)
	obj:initData(data)
end
function allianceMemberBattlePointViewPanel:onShow()
	print("=======allianceMemberBattlePointViewPanel:onShow")
	self.aid = allianceMgr:getOwnAid()
	allianceQuery:reqMemberList(self.aid)
	SoraDShowLoading(self)
end
function allianceMemberBattlePointViewPanel:initData()
	SoraDCloseLoading(self)
	local memberList = allianceMgr:getMemberList(self.aid)
	local _ENV, memberArray = allianceMgr, allianceMgr
	for rank, list in pairs(memberList) do
		for k, v in pairs(list) do
			table.insert(memberArray, v)
		end
	end
	table.sort(memberArray, function(a, b)
		return a.uinfo.totalFc > b.uinfo.totalFc
	end)
	self.selfMember, _ENV, self.memberList, _ENV = table.sort, table.sort, table.sort, table.sort
	for k, v in ipairs(memberArray) do
		if tonumber(v.minfo.uid) == tonumber(gametop.playertop_:getPlayerID()) then
			_ENV = tonumber(v.minfo.uid)
			tonumber(v.minfo.uid).rank = k
			self.selfMember, tonumber(v.minfo.uid).data = tonumber(v.minfo.uid), v
		end
		_ENV = gametop.playertop_:getPlayerID()
		gametop.playertop_:getPlayerID().rank = k
		gametop.playertop_:getPlayerID().data = v
		table.insert(self.memberList, gametop.playertop_:getPlayerID())
	end
	self.fields.List:setNumItems(#self.memberList)
	_ENV = #self.memberList
	;(#self.memberList).rank = self.selfMember.rank
	;(#self.memberList).num = self.selfMember.data.uinfo.totalFc
	;(#self.memberList).nickName = self.selfMember.data.uinfo.nickName
	;(#self.memberList).allianceAbbr = self.selfMember.data.allianceAbbr
	;(#self.memberList).uid = self.selfMember.data.minfo.uid
	;(#self.memberList).iconID = self.selfMember.data.uinfo.iconID
	;(#self.memberList).avatar = self.selfMember.data.uinfo.avatar
	self.fields.Com_self:initData(#self.memberList)
end
return allianceMemberBattlePointViewPanel
