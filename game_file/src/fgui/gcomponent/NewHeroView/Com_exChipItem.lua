local publicRead = include("publicRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_exChipItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_exChipItem", Com_exChipItem)
function Com_exChipItem:onInit()
	self:addClickListener(handler(self, self.onClick))
	self.fields.Text_num:fixPos()
	self.fields.Image_num:fixPos()
	self.fields.lock:fixPos()
	self.fields.Image_num:fix()
end
function Com_exChipItem:onShow()
end
function Com_exChipItem:initData(data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		local heroInfo = heroCtrl:getHeroInfoByID(heroltCtrl:getHeroIDByItemID(self.data.id))
		self.controllers.c2:setSelectedIndex(heroInfo and 0 or 1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_exChipItem:setSelected(val)
end
function Com_exChipItem:setNewVisible(val)
end
function Com_exChipItem:getItemData(...)
end
function Com_exChipItem:onClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 and self.controllers.c2:getSelectedIndex() == 1 then
		SoraDShowMsgTip(i18n("Hero_reshape_25"))
	else
		_ENV = i18n("Hero_reshape_25")
		i18n("Hero_reshape_25").msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
		i18n("Hero_reshape_25").pos = self.pos
		i18n("Hero_reshape_25").data = self.data
		SoraDSendMessage(i18n("Hero_reshape_25"))
	end
end
return Com_exChipItem
