local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarRead = include("nebulaAllStarRead")
local lordLocalData = include("lordLocalData")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local teamDef = include("teamDef")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarTeamCommanderPanel = class("NebulaAllStarTeamCommanderPanel", baseFguiPanel)
function NebulaAllStarTeamCommanderPanel:ctor(...)
	NebulaAllStarTeamCommanderPanel.super.ctor(self, ...)
	print("NebulaAllStarTeamCommanderPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.numMax = nebulaAllStarRead.getTeamCommandMax()
end
function NebulaAllStarTeamCommanderPanel:onInit()
	print("=======NebulaAllStarTeamCommanderPanel:onInit")
	local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("teamCommander")
	self.fields.Com_title:initData(i18n("NebulaAllstar_62"), handler(self, self.onClickClose), handlerHelp)
	self.fields = fguiHelper.get_fields(self.fields.Com_content)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaAllStarTeamCommanderPanel:onShow()
	print("=======NebulaAllStarTeamCommanderPanel:onShow")
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if myTeamInfo:getIsSuperTeam() then
		self.memberList = teamDef.getLeaderCommanderList(myTeamInfo)
	else
		if not self.param or not self.param.memberList then
			_ENV = self.param.memberList
		end
		self.memberList = self.param.memberList
	end
	self:onItemRenderer(-1, self.fields.Com_leader)
	self.fields.List:setNumItems(self.numMax)
	self.fields.List:resizeToFit(self.numMax)
	local imageH = math.max(self.fields.Image_bg:getHeight(), self:getHeight())
	self.fields.Image_bg:setHeight(imageH)
end
function NebulaAllStarTeamCommanderPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	local _controllers = obj._controllers
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_controllers = fguiHelper.get_controllers(obj)
		obj._controllers = _controllers
		if index == -1 then
			_fields.title:setString(i18n("free_team_text_77"))
		else
			_fields.title:setString(i18n("NebulaAllstar_79"))
		end
		_fields.Text_noData:setString(i18n("NebulaAllstar_80"))
		_controllers.c1:setSelectedIndex(0)
	end
	local data = self.memberList[index + 2]
	if not data then
		_controllers.c1:setSelectedIndex(1)
		return
	end
	_controllers.c1:setSelectedIndex(0)
	_fields.Image_bust:setURL(lordLocalData.getBust(data.headid))
	local nickName = textParser.formatPlayerName(nil, data.nickName, data.kid)
	_fields.Text_name:setString(nickName)
	if data.uid == gametop.playertop_:getPlayerID() then
		_controllers.c_self:setSelectedIndex(1)
	else
		_controllers.c_self:setSelectedIndex(0)
	end
end
return NebulaAllStarTeamCommanderPanel
