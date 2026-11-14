local activity_9001731_Read = include("activity_9001731_Read")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_pass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_pass", Com_pass)
function Com_pass:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_oneKey:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_lock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.fields.Text_passTip:setString(i18n("Ludo_test_011"))
	self.fields.Text_day:setString(i18n("common_text_748"))
	self.fields.Text_nor:setString(i18n("Braque_text_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_pass:onShow()
end
function Com_pass:initData()
	self.cfg = activity_9001731_Read.getBattlePassCfg()
	self.fields.List:setNumItems(#self.cfg)
	local isUnlockAdv = activity_9001731_Ctrl:isUnlockAdvSign()
	self.fields.Button_lock:setVisible(not isUnlockAdv)
	self.fields.sheer:setVisible(not isUnlockAdv)
	local haveReward = activity_9001731_Ctrl:isHaveSignReward()
	self.fields.Button_oneKey:setEnabled(haveReward)
	self.fields.Button_oneKey:setReddot(haveReward)
end
function Com_pass:itemRenderer_List(index, obj)
	local data = self.cfg[index + 1]
	obj:initData(data)
end
function Com_pass:onClick_Button_oneKey(context)
	SoraDPlaySound()
	activity_9001731_Ctrl:reqSign()
end
function Com_pass:onClick_Button_lock(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
	uiManager:show("CommonBuyGift", nil)
end
return Com_pass
