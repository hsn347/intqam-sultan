local alliancePetCtrl = SoraDGetCtrl("alliancePetCtrl")
local alliancePetRead = include("alliancePetRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AlliancePetSelectPanel = class("AlliancePetSelectPanel", baseFguiPanel)
function AlliancePetSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AlliancePetSelectPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function AlliancePetSelectPanel:onInit()
	print("=======AlliancePetSelectPanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_beast_text_31"), handler(self, self.onClickClose))
	if IsArClient then
		self.fields.Com_title:setHelpCallBack(handler(self, self.onClickHelp))
	end
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("alliance_beast_text_02", nil)
	end)
	self.Text_time:setTimeEndListener(function(...)
		self.Text_time:setVisible(false)
	end)
	local timeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if 0 < timeCD then
		self.Text_time:beginTime(timeCD)
	else
		self.Text_time:setVisible(false)
	end
	self.fields.List_pet:setItemRenderer(handler(self, self.onItemRenderer))
	self.tablePetList = alliancePetRead.getPetInfoList()
	if #self.tablePetList % 2 ~= 0 then
		_ENV = handler(self, self.onItemRenderer)
		handler(self, self.onItemRenderer).PetType = 9999
		table.insert(self.tablePetList, handler(self, self.onItemRenderer))
	end
	self.fields.List_pet:setNumItems(#self.tablePetList)
end
function AlliancePetSelectPanel:onShow()
	print("=======AlliancePetSelectPanel:onShow")
end
function AlliancePetSelectPanel:onClickHelp(...)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR_PET)
end
function AlliancePetSelectPanel:onItemRenderer(index, obj)
	local petType = self.tablePetList[index + 1].PetType
	obj:initPetType(petType)
end
return AlliancePetSelectPanel
