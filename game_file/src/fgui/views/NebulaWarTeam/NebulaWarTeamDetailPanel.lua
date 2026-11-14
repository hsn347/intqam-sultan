local teamDef = include("teamDef")
local teamDataFactory = include("teamDataFactory")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamDetailPanel = class("NebulaWarTeamDetailPanel", baseFguiPanel)
function NebulaWarTeamDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamDetailPanel:ctor", self.viewName)
end
function NebulaWarTeamDetailPanel:onInit()
	print("=======NebulaWarTeamDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("remains_text_125"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setVirtual()
end
function NebulaWarTeamDetailPanel:onShow()
	print("=======NebulaWarTeamDetailPanel:onShow")
	if not self.proxy.param or not self.proxy.param.teamData then
		local _ENV, teamData = self.proxy.param.teamData, self.proxy.param.teamData
	end
	local teamInfo = teamDataFactory:createTeamData(teamDef.teamAreaEnum.NEBULA_WAR)
	teamInfo:setMyTeamInfo(teamData)
	self.memberList = teamInfo:getTeamMemberList()
	local _ENV, ret = teamInfo:getTeamMemberList(), teamInfo:getTeamMemberList()
	for __, member in ipairs(self.memberList) do
		_ENV = member.uid
		ret[tostring(member.uid)], member.uid.isLeader = member.uid, teamInfo:isTeamLeader(member.uid)
	end
	self.memberMap = ret
	table.sort(self.memberList, function(a, b)
		local dataA = ret[tostring(a.uid)]
		local dataB = ret[tostring(b.uid)]
		if dataA.isLeader ~= dataB.isLeader then
			return dataA.isLeader
		end
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
	self.fields.List:setNumItems(#self.memberList)
end
function NebulaWarTeamDetailPanel:onItemRederer(index, obj)
	if not obj.fields then
		obj:fixChildrenPos()
		obj.fields = fguiHelper.get_fields(obj)
		obj.fields.Com_castleLv:fixChildrenPos()
	end
	local data = self.memberList[index + 1]
	obj.fields.Com_head:setHeadSprite(data.headid, data.avatar or "")
	obj.fields.Com_head:setPlayerID(data.uid)
	obj.fields.Text_name:setString(string.format("%s#%d", data.nickName, data.kid))
	obj.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	obj.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	local member = self.memberMap[tostring(data.uid)]
	obj.fields.Sprite_leader:setVisible(member.isLeader)
end
return NebulaWarTeamDetailPanel
