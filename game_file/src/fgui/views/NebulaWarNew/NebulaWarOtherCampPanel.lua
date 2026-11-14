local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarOtherCampPanel = class("NebulaWarOtherCampPanel", baseFguiPanel)
function NebulaWarOtherCampPanel:ctor(...)
	NebulaWarOtherCampPanel.super.ctor(self, ...)
	print("NebulaWarOtherCampPanel:ctor", self.viewName)
end
function NebulaWarOtherCampPanel:onInit()
	print("=======NebulaWarOtherCampPanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0614"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
	self.fields.Com_myInfo:addClickListener(handler(self, self.onClickMyInfo))
end
function NebulaWarOtherCampPanel:onShow()
	print("=======NebulaWarOtherCampPanel:onShow")
	if not self.param or not self.param.campScoreInfo then
		_ENV = self.param.campScoreInfo
	end
	self.campScoreInfo = self.param.campScoreInfo
	local selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	local _ENV, groupIdList = nebulaActivityCtrl, nebulaActivityCtrl
	local groupCount = nebulaWarUtil.getGroupCount()
	for groupId = 1, groupCount do
		if groupId ~= selfGroupId then
			table.insert(groupIdList, groupId)
		end
	end
	self.groupIdList = groupIdList
	self.fields.List:setNumItems(#self.groupIdList)
	local groupIcon = nebulaWarRead.getWarGroupIcon(selfGroupId)
	self.fields.Com_myInfo:setIcon(groupIcon)
	local groupName = nebulaWarRead.getWarGroupName(selfGroupId)
	_ENV = groupId
	groupId.camp = groupName
	self.fields.Text_name:setString(i18n("nebula_war_text_0499", groupId))
	local score = nebulaActivityCtrl:getSeasonScore(selfGroupId)
	_ENV = i18n("nebula_war_text_0499", groupId)
	i18n("nebula_war_text_0499", groupId).num = string.formatnumberthousands(score)
	self.fields.Text_score:setString(i18n("nebula_war_text_0504", i18n("nebula_war_text_0499", groupId)))
end
function NebulaWarOtherCampPanel:onItemRenderer(index, obj)
	local Com_group = obj:getChild("Com_group")
	local groupId = self.groupIdList[index + 1]
	Com_group:initData(groupId, self.campScoreInfo)
end
function NebulaWarOtherCampPanel:onClickMyInfo(...)
	SoraDPlaySound()
	local selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	_ENV = nil
	;(nil).groupId = selfGroupId
	uiManager:show("NebulaWarCampKingdom", nil)
end
return NebulaWarOtherCampPanel
