local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local WarframeBagItemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/WarframeBagItemSingle", WarframeBagItemSingle)
function WarframeBagItemSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
	self:fixChildrenPos()
end
function WarframeBagItemSingle:onShow()
end
function WarframeBagItemSingle:initData(data, pos)
	self.data = data
	dump(self.data, "self.data")
	self.pos = pos
	self.fields.icon_Wear:setVisible(false)
	if data and next(data) then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.armorId)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.armorId))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self:updateWearIcon()
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function WarframeBagItemSingle:updateWearIcon()
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armyNum = armorSystemCtrl:getArmyNumByArmorId(self.data.armorId)
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.data.armorId)
	if cfg.newLv == 14 then
		_ENV = nil
		;(nil).isArmorID = true
		;(nil).armorID = self.data.armorId
		self.fields.icon_Wear:setVisible(SoraDIsGildedArmorOpen(nil) and commonCheck.GILT_ARMOR_WEAR and 0 < armyNum)
	else
		_ENV = nil
		;(nil).isArmorID = true
		;(nil).armorID = self.data.armorId
		self.fields.icon_Wear:setVisible(SoraDIsBrave8Level(nil) and commonCheck.WARFRAME_WEAR and 0 < armyNum)
	end
end
function WarframeBagItemSingle:setSelected(val)
end
function WarframeBagItemSingle:setNewVisible(val)
end
function WarframeBagItemSingle:getItemData(...)
end
function WarframeBagItemSingle:onClick()
	if self.data and next(self.data) then
		SoraDPlaySound()
		_ENV = self.data
		self.data.msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
		_ENV, self.data.pos = self.pos, self.pos
		self.pos.id = self.data.armorId
		self.data.data, self.pos.count = self.pos, self.data.count
		SoraDSendMessage(self.data)
	end
end
return WarframeBagItemSingle
