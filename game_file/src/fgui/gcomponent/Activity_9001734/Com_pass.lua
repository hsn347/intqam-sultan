local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_pass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_pass", Com_pass)
function Com_pass:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_oneKey:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_lock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.fields.Button_lockSenior:setTitle(i18n("StarlitNight_text_12"))
	self.fields.Button_lockSenior:addClickListener(handler(self, self.onClick_Button_lockSenior))
	self.fields.Text_passTip:setString(i18n("Ramadan_treasure_hunt_text_02"))
	self.fields.Text_day:setString(i18n("daily_salute_text21"))
	self.fields.Text_nor:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.fields.Text_senior:setString(i18n("StarlitNight_text_11"))
	self.fields.floor:fix()
	self.fields.sheer:fixPos()
	self.fields.sheer2:fixPos()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.Text_day:fixPos()
	self.fields.Text_nor:fixPos()
	self.fields.Text_adv:fixPos()
	self.fields.Text_senior:fixPos()
	self.fields.Button_lock:fixPos()
	self.fields.Button_lockSenior:fixPos()
end
function Com_pass:onShow()
end
function Com_pass:initData()
	self.passList = activity_9001734_Read.getBattlePassCfg()
	self.fields.List:setNumItems(#self.passList)
	local isUnlockAdv = activity_9001734_Ctrl:getUnlockAdv()
	self.fields.Button_lock:setVisible(not isUnlockAdv)
	self.fields.sheer:setVisible(not isUnlockAdv)
	local isUnlockSenior = activity_9001734_Ctrl:getUnlockSenior()
	self.fields.Button_lockSenior:setVisible(not isUnlockSenior)
	self.fields.sheer2:setVisible(not isUnlockSenior)
	local passRedNum = activity_9001734_Ctrl:getPassRedNum()
	self.fields.Button_oneKey:setEnabled(0 < passRedNum)
end
function Com_pass:itemRenderer_List(index, obj)
	local data = self.passList[index + 1]
	obj:initData(data)
end
function Com_pass:onClick_Button_oneKey(context)
	SoraDPlaySound()
	activity_9001734_Ctrl:reqSignMsg()
end
function Com_pass:onClick_Button_lock(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
	uiManager:show("CommonBuyGift", nil)
end
function Com_pass:onClick_Button_lockSenior(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
	;(nil).rewardType = 3
	uiManager:show("CommonBuyGift", nil)
end
return Com_pass
