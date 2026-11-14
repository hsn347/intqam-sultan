local publicRead = include("publicRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_chipSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_chipSingle", Button_chipSingle)
function Button_chipSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.lock:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.Image_num:fix()
end
function Button_chipSingle:onShow()
end
function Button_chipSingle:initData(data)
	self.data = data
	self.fields.imgBg:setSpriteFrame(publicRead.getBg(self.data.id))
	self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
	self.fields.Text_num:setString(self.data.count)
	local heroInfo = heroCtrl:getHeroInfoByID(heroltCtrl:getHeroIDByItemID(self.data.id))
	self.controllers.c1:setSelectedIndex(heroInfo and (self.data.isSelect and 1 or 0) or 2)
end
function Button_chipSingle:btnClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 2 then
		SoraDShowMsgTip(i18n("Hero_reshape_25"))
	else
		self.data.isSelect = not self.data.isSelect
		_ENV = not self.data.isSelect
		;(not self.data.isSelect).msg = "MESSAGE_UI_HERO_CHIP_SELECT"
		;(not self.data.isSelect).chip = self.data
		SoraDSendMessage(not self.data.isSelect)
	end
end
return Button_chipSingle
