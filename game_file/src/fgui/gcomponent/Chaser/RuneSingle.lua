local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local RuneSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/RuneSingle", RuneSingle)
function RuneSingle:onInit()
	self.fields.Lab_season:setVisible(false)
	self.fields.Text_wearing:setString(i18n("lordequip_btn_01"))
	self:addClickListener(handler(self, self.onClick))
	self.fields.bar_lucky:fixChildrenPos()
	self.fields.bar_lucky:setMax(artifactRuneRead.getLuckyValueLimit())
end
function RuneSingle:onShow()
end
function RuneSingle:initData(data)
	self.data = data
	local info = artifactRuneRead.getRuneInfo(data.rid)
	self.fields.icon:setSpriteFrame(info.Runelcon)
	if data.isExp then
		self.fields.icon_lock:setVisible(false)
		self.fields.Text_wearing:setVisible(false)
		self.fields.bg_wear:setVisible(false)
		self.fields.Text_lv:setString(data.num)
		self.fields.Text_stage:setVisible(false)
		self.fields.n4:setVisible(false)
		self.fields.Lab_season:setVisible(false)
		self.fields.Com_attrEx:setVisible(false)
	else
		self.fields.icon_lock:setVisible(data.isLock)
		local isWear = data.isWear
		self.fields.Text_wearing:setVisible(isWear)
		self.fields.bg_wear:setVisible(isWear)
		artifactRuneRead = nil
		;(nil).lv = data.cLevel or data.level
		self.fields.Text_lv:setString(i18n("common_text_101", nil))
		self.fields.Text_stage:setVisible(true)
		self.fields.n4:setVisible(true)
		self.fields.Text_stage:setString(data.class)
		local season = SoraDGetCtrl("nebulaActivityCtrl"):getCurSeason() or 1
		local subscript = artifactRuneRead.getRuneSubscript(data.rid)
		if subscript then
			self.fields.Lab_season:setVisible(true)
			self.fields.Lab_season:setIcon(subscript)
		else
			self.fields.Lab_season:setVisible(false)
		end
		self.fields.Com_attrEx:setVisible(true)
		self.fields.Com_attrEx:initData(self.data.extraProperty)
	end
	if data.luckyValue then
		self.fields.bar_lucky:setValue(data.luckyValue)
	end
	self.controllers.c2:setSelectedIndex(data.luckyValue and 1 or 0)
end
function RuneSingle:onClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 0 and not self.data.isExp then
		_ENV = nil
		;(nil).data = self.data
		;(nil).cIndex = 1
		uiManager:show("RunePopView", nil)
	end
end
return RuneSingle
