local nebulaWarRead = include("nebulaWarRead")
local lordLocalData = include("lordLocalData")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarPlayerResultPanel = class("NebulaAllStarPlayerResultPanel", baseFguiPanel)
function NebulaAllStarPlayerResultPanel:ctor(...)
	NebulaAllStarPlayerResultPanel.super.ctor(self, ...)
	print("NebulaAllStarPlayerResultPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaAllStarPlayerResultPanel:onInit()
	print("=======NebulaAllStarPlayerResultPanel:onInit")
	if not self.param or not self.param.notifyData then
		_ENV = self.param.notifyData
	end
	self.notifyData = self.param.notifyData
	if SoraDFIsRA() then
		self.fields.Load_regionTitle:setURL("frame_qmx_zhanqu_ar.png")
		self.fields.Load_playerTitle:setURL("frame_qmx_mlzx_ar.png")
	else
		self.fields.Load_regionTitle:setURL("frame_qmx_zhanqu_en.png")
		self.fields.Load_playerTitle:setURL("frame_qmx_mlzx_en.png")
	end
	self.fields.Button_quit:setString(i18n("NebulaAllstar_32"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickClose))
	local areaName = ""
	if not self.notifyData.winCamp then
		local _ENV, winCamp = self.notifyData.winCamp, self.notifyData.winCamp
	end
	if next(winCamp) then
		local regionId = winCamp.camp or 1
		areaName = nebulaWarRead.getAreaName(regionId)
		local areaIcon = nebulaWarRead.getAreaBigIcon(regionId)
		self.fields.Text_region:setString(areaName)
		self.fields.Load_region:setIcon(areaIcon)
	end
	local playerName = ""
	if not self.notifyData.charmPlayer then
		local _ENV, player = self.notifyData.charmPlayer, self.notifyData.charmPlayer
	end
	if next(player) then
		self.fields.Load_player:setURL(lordLocalData.getPortrait(player.iconID))
		local areaAbbr = nebulaWarRead.getAreaAbbr(player.camp)
		_ENV = lordLocalData.getPortrait(player.iconID)
		lordLocalData.getPortrait(player.iconID).abbr = areaAbbr
		lordLocalData.getPortrait(player.iconID).name = player.name
		playerName = i18n("common_text_186", lordLocalData.getPortrait(player.iconID))
		self.fields.Text_player:setString(playerName)
	end
	_ENV = self.fields.Text_player
	self.fields.Text_player.area = areaName
	self.fields.Text_player.time = SoraDConvertSecondToString(winCamp.occupyPalaceSecs or 0)
	self.fields.Text_player.NAME = playerName
	self.fields.Text_player.NUM = player.charm or 0
	local desStr = i18n("NebulaAllstar_31", self.fields.Text_player)
	self.fields.Text_result:setString(desStr)
end
function NebulaAllStarPlayerResultPanel:onShow()
	print("=======NebulaAllStarPlayerResultPanel:onShow")
end
function NebulaAllStarPlayerResultPanel:close(...)
	self:closePanel()
	if nebulaAllStarCtrl:getIsViewer() then
		nebulaAllStarCtrl:reqViewerStopSync()
	end
	if worldMapDefine.isInNebulaAllStar() then
		nebulaAllStarCtrl:resetNebulaAllStarEnd()
	else
		_G.SoraDQuickLogin()
	end
end
function NebulaAllStarPlayerResultPanel:initTestData(...)
	_UPVALUE0_ = nil
	_UPVALUE0_, (nil).round = nil, 1
	;(nil).camp = 1
	_UPVALUE0_, (nil).winCamp, (nil).occupyPalaceSecs = nil, nil, 0
	;(nil).camp = 1
	;(nil).charm = 0
	;(nil).name = "nickName"
	self.notifyData, (nil).charmPlayer, (nil).iconID = nil, nil, 1401
end
return NebulaAllStarPlayerResultPanel
