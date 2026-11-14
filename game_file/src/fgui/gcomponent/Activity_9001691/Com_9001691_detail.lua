local baseComponent = require("fgui.base.baseComponent")
local Com_9001691_detail = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
fgui.register_extension("ui://Activity_9001691/Com_9001691_detail", Com_9001691_detail)
function Com_9001691_detail:onInit()
	self:fixChildrenPos()
	self.fields.clickBg:fix()
	self.fields.clickBg:addEventListener(fgui.UIEventType.Click, handler(self, self.onSwitchClick))
	self.fields.list_myhp:setItemRenderer(handler(self, self.onMyHpRenderer))
	self.fields.list_aihp:setItemRenderer(handler(self, self.onAIHpRenderer))
	self.fields.txt_desc:setString(i18n("surprise_box_007"))
	self.fields.txt_aihp:setString(i18n("surprise_box_008"))
	self.fields.txt_aiItem:setString(i18n("surprise_box_009"))
	self.fields.txt_myhp:setString(i18n("surprise_box_010"))
	self.fields.txt_myItem:setString(i18n("surprise_box_011"))
	self.fields.txt_myPoint:setString(i18n("surprise_box_012"))
	self.fields.txt_record:setString(i18n("surprise_box_013"))
	self.fields.group_record:ensureBoundsCorrect()
	self.isShow = false
end
function Com_9001691_detail:onShow()
	self.isShow = false
	self.controllers.c1:setSelectedIndex(0)
end
function Com_9001691_detail:onSwitchClick()
	SoraDPlaySound()
	self.isShow = not self.isShow
	self.controllers.c1:setSelectedIndex(self.isShow and 1 or 0)
end
function Com_9001691_detail:initData(lvCfg)
	local lv = lvCfg.stage
	local aihp = lvCfg.antagonistHp
	local myhp = lvCfg.playerHp
	local aipItemNum = lvCfg.antagonistProp
	local mypItemNum = lvCfg.playerProp
	_ENV = nil
	;(nil).num = lv
	self.fields.text_stage:setString(i18n("surprise_box_083", nil))
	self.fields.list_aihp:setNumItems(aihp)
	self.fields.list_myhp:setNumItems(myhp)
	self.fields.txt_aiItemNum:setString(aipItemNum)
	self.fields.txt_myItemNum:setString(mypItemNum)
	self.fields.txt_myPointNum:setString(activity_9001691_Ctrl:getMaxLevelScore(lv))
	self.fields.txt_recordNum:setString(activity_9001691_Ctrl:getGlobalMaxLevelScore(lv))
end
function Com_9001691_detail:onMyHpRenderer(index, obj)
end
function Com_9001691_detail:onAIHpRenderer(index, obj)
end
return Com_9001691_detail
