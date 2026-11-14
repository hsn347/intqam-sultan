local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_PackagePanel = class("Activity_9001729_PackagePanel", baseFguiPanel)
function Activity_9001729_PackagePanel:ctor(...)
	self.isLRU = true
	Activity_9001729_PackagePanel.super.ctor(self, ...)
	print("Activity_9001729_PackagePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function Activity_9001729_PackagePanel:onInit()
	self:fixChildrenPos()
	print("=======Activity_9001729_PackagePanel:onInit")
	self.fields.listPackage:setItemRenderer(handler(self, self.itemRenderer_listPackage))
	self.fields.Panel_bg:setString(i18n("kindofwar_btn_01"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.txtFree:setString(i18n("snow_competition_text_20"))
	self.fields.icon:fixPos()
	self.fields.txtName:fixPos()
	self.fields.btnReceive:fixPos()
end
function Activity_9001729_PackagePanel:endShow()
	print("=======Activity_9001729_PackagePanel:endShow")
	self:initData()
end
function Activity_9001729_PackagePanel:itemRenderer_listPackage(index, obj)
	local data = self.packages[index + 1]
	obj:initData(data)
end
function Activity_9001729_PackagePanel:onClick_btnReceive(context)
	SoraDPlaySound()
	if activity_9001729_Ctrl:getDailyRewardReceived() then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	else
		activity_9001729_Ctrl:reqGetDailyRewardMsg()
	end
end
function Activity_9001729_PackagePanel:initData()
	self.dailyReward = activity_9001729_Read.getDailyReward()
	self.fields.icon:initData(self.dailyReward.id, self.dailyReward.count)
	self.fields.txtName:setString(publicRead.getName(self.dailyReward.id))
	if activity_9001729_Ctrl:getDailyRewardReceived() then
		self.fields.btnReceive:setTitle(i18n("common_text_1892"))
		self.fields.btnReceive:setGrayed(true)
	else
		self.fields.btnReceive:setTitle(i18n("common_text_1146"))
		self.fields.btnReceive:setGrayed(false)
	end
	self.packages = activity_9001729_Read.getDailyPackages()
	self.fields.listPackage:setNumItems(#self.packages)
end
return Activity_9001729_PackagePanel
