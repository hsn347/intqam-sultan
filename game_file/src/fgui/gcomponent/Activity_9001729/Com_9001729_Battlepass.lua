local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001729_Battlepass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_9001729_Battlepass", Com_9001729_Battlepass)
function Com_9001729_Battlepass:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.btnAllReceive:setTitle(i18n("summoned_btn_01"))
	self.fields.btnAllReceive:addClickListener(handler(self, self.onClick_btnAllReceive))
	self.fields.Button_buyGift:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_buyGift:addClickListener(handler(self, self.onClick_Button_buyGift))
	self.fields.txtAdv:setString(i18n("StarlitNight_text_07"))
	self.fields.txtNormal:setString(i18n("cityUp_title_03"))
	self.fields.txtLv:setString(i18n("daily_salute_text21"))
	self.fields.txtTip:setString(i18n("Ramadan_treasure_hunt_text_02"))
	self.fields.n7:fix()
end
function Com_9001729_Battlepass:onShow()
end
function Com_9001729_Battlepass:itemRenderer_List(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data, self.activityDay)
end
function Com_9001729_Battlepass:onClick_btnAllReceive(context)
	SoraDPlaySound()
	if not activity_9001729_Ctrl:getBattlePassCanReceive() then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	activity_9001729_Ctrl:reqSignMsg()
end
function Com_9001729_Battlepass:onClick_Button_buyGift(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001729_BuyGift")
end
function Com_9001729_Battlepass:initData(activityID)
	self.activityID = activityID
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.activityDay = activityShowCtrl:getCurOpenDay(self.activityID)
	self.rewards = activity_9001729_Read.getRewardList()
	self.fields.List:setNumItems(#self.rewards)
	self.fields.btnAllReceive:setGrayed(not activity_9001729_Ctrl:getBattlePassCanReceive())
	self.controllers.c1:setSelectedIndex(activity_9001729_Ctrl:isActiveGold() and 1 or 0)
end
return Com_9001729_Battlepass
