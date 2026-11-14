local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorOfficerPanel = class("NebulaEmperorOfficerPanel", baseFguiPanel)
function NebulaEmperorOfficerPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorOfficerPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	self.lordList = nebulaEmperorRead.getOfficerList(gLegendBuffType.PLAYER)
	self.areaList = nebulaEmperorRead.getOfficerList(gLegendBuffType.KINGDOM)
end
function NebulaEmperorOfficerPanel:onInit()
	print("=======NebulaEmperorOfficerPanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(i18n("nebulaemperor_text_23"), handler(self, self.onClickClose), handlerHelp)
	self.fields.Com_title:getLabelTime():initActivityTimeStyle(self.activityID, "nebulaemperor_text_14")
	self.fields.Label_region:setString(i18n("nebulaemperor_text_17"))
	self.fields.List_region:setItemRenderer(handler(self, self.onRegionItemRederer))
	nebulaEmperorUtil, _UPVALUE4_ = self.fields.List_region, self.fields.List_region.setItemRenderer
	nebulaEmperorUtil, self.fields.List_region[1] = self.fields.Button_glory, self.fields.Button_glory
	nebulaEmperorUtil, self.fields.List_region[2] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[3] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[4] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[5] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[6] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[7] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[8] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[9] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[10] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.List_region[11] = self.fields.Button_glory, i18n("nebulaemperor_text_20")
	nebulaEmperorUtil, self.fields.Button_glory[1] = self.fields.Button_reward, self.fields.Button_reward
	nebulaEmperorUtil, self.fields.Button_glory[2] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[3] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[4] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[5] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[6] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[7] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[8] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[9] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_glory[10] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_reward[1] = self.fields.Button_rank, self.fields.Button_rank
	nebulaEmperorUtil, self.fields.Button_reward[2] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[3] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[4] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[5] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[6] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[7] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[8] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_reward[9] = self.fields.Button_rank, i18n("common_text_2193")
	self.fields.Button_rank[1] = self.fields.Button_grant
	self.fields.Button_rank[2] = i18n("common_text_1441")
	self.fields.Button_rank[3] = i18n("common_text_1441")
	self.fields.Button_rank[4] = i18n("common_text_1441")
	self.fields.Button_rank[5] = i18n("common_text_1441")
	self.fields.Button_rank[6] = i18n("common_text_1441")
	self.fields.Button_rank[7] = i18n("common_text_1441")
	self.fields.Button_rank[8] = i18n("common_text_1441")
	self.fields.List_region.setItemRenderer[1] = self.fields.List_region
	self.fields.List_region.setItemRenderer[2] = self.fields.Button_glory
	self.fields.List_region.setItemRenderer[3] = self.fields.Button_reward
	local self.fields.List_region.setItemRenderer[4], config = self.fields.Button_rank, self.fields.List_region.setItemRenderer
	for __, cfg in ipairs(config) do
		local widget = cfg[1]
		local title = cfg[2]
		if title then
			widget:setString(title)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
end
function NebulaEmperorOfficerPanel:onShow()
	print("=======NebulaEmperorOfficerPanel:onShow")
	self:updateOfficer()
	SoraDShowLoading(self:displayObject())
	nebulaEmperorCtrl:reqAllTitleInfo()
end
function NebulaEmperorOfficerPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_glory then
		if nebulaEmperorUtil.isWarTest() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_238"))
			return
		end
		uiManager:show("NebulaEmperorGlory")
	elseif sender == self.fields.Button_reward then
		uiManager:show("NebulaEmperorReward")
	elseif sender == self.fields.Button_rank then
		uiManager:show("NebulaEmperorRank")
	elseif sender == self.fields.Button_grant then
		if nebulaEmperorUtil.isWarTest() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_238"))
			return
		end
		uiManager:show("NebulaEmperorAward")
	end
end
function NebulaEmperorOfficerPanel:onRegionItemRederer(index, obj)
	local officerID = self.areaList[index + 1]
	obj:updateDataOfficer(officerID, self.regionTitle)
end
function NebulaEmperorOfficerPanel:onMsgReqAllTitleBack(target, event)
	SoraDCloseLoading(self:displayObject())
	local rspdata = event.rspdata
	self.userTitle = rspdata.userTitleInfo
	self.regionTitle = rspdata.regionTitle
	self:updateOfficer()
end
function NebulaEmperorOfficerPanel:onMsgUpdateSingleTitle(target, event)
	local titleID = event.titleID
	if nebulaEmperorRead.getOfficerType(titleID) == gLegendBuffType.KINGDOM then
		self.regionTitle[tostring(titleID)] = event.regionId
	else
		self.userTitle[tostring(titleID)] = event.playerInfo
	end
	self:updateOfficer()
end
function NebulaEmperorOfficerPanel:updateOfficer(...)
	for i = 1, 9 do
		local Com_officer = self.fields["Com_officer" .. i]
		local officerID = self.lordList[i]
		if officerID then
			Com_officer:updateDataOfficer(officerID, self.userTitle)
		else
			Com_officer:setVisible(false)
		end
	end
	self.fields.List_region:setNumItems(#self.areaList)
end
return NebulaEmperorOfficerPanel
