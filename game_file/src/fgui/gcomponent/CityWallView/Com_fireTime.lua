local wallsCtrl = SoraDGetCtrl("wallsCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_fireTime = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityWallView/Com_fireTime", Com_fireTime)
function Com_fireTime:onInit()
	self.fields.Text_titleBurnTime:setString(i18n("common_text_398"))
	self.fields.btnDownFire:setString(i18n("common_text_391"))
	self.fields.btnDownFire:setCostTitle(DEFENDVIEW_DOWNFIRE_GOLD)
	self.fields.btnDownFire:addClickListener(handler(self, self.btnDownFireClick))
	self.fields.Text_pyramid:setString(i18n("common_text_3201"))
	self.fields.Text_pyramid:setVisible(false)
end
function Com_fireTime:onShow()
end
function Com_fireTime:isShowPyramidText(ret)
	self.fields.Text_pyramid:setVisible(ret)
end
function Com_fireTime:setBurnContent(timeStr)
	self.fields.Text_burnContent:setString(timeStr)
end
function Com_fireTime:initData(tableWall)
	self.tableWall = tableWall
	self.fields.btnDownFire:setGoldColor(SoraDEnoughGold(WALL_PUT_OUT_FIRE_GOLD, true) and cc.c3b(255, 251, 213) or display.COLOR_RED)
	if self.tableWall.burnTime > 0 then
		self.fields.btnDownFire:setEnabled(true)
		self.controllers.c1:setSelectedIndex(1)
	else
		self.fields.btnDownFire:setEnabled(false)
		self.fields.Text_burnContent:setString(i18n("common_text_395"))
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_fireTime:btnDownFireClick()
	SoraDPlaySound()
	if not SoraDEnoughGold(WALL_PUT_OUT_FIRE_GOLD, true) then
		_ENV = nil
		;(nil).gold = WALL_PUT_OUT_FIRE_GOLD
		SoraDShowBuyBox(i18n("common_text_397", nil), WALL_PUT_OUT_FIRE_GOLD, i18n("common_text_391") .. "&" .. i18n("common_text_282"), handler(self, self.downFireByGold), true)
	else
		wallsCtrl:wallsFire()
	end
end
function Com_fireTime:downFireByGold(exitType)
	if exitType == MSGBOX_CALLBACK_CANCEL then
		print("取消购买")
	elseif exitType == MSGBOX_CALLBACK_YES then
		print("确认购买")
		wallsCtrl:wallsFire()
	end
end
return Com_fireTime
