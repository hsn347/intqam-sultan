local baseComponent = require("fgui.base.baseComponent")
local divineBeastMarkRead = include("divineBeastMarkRead")
local Com_MC_Mark = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
fgui.register_extension("ui://MythicalCreatures/Com_MC_Mark", Com_MC_Mark)
fgui.register_extension("ui://MythicalCreatures/Com_MC_Mark90", Com_MC_Mark)
fgui.register_extension("ui://MythicalCreatures/Com_MC_Mark100", Com_MC_Mark)
fgui.register_extension("ui://MythicalCreatures/Com_MC_Mark120", Com_MC_Mark)
function Com_MC_Mark:onInit()
	self.fields.Com_item:setClickCallback(handler(self, self.onClick))
	self.fields.Com_item:forbidLongPress()
	self:fixChildrenPos()
end
function Com_MC_Mark:onShow()
end
function Com_MC_Mark:initData(data, pos, isHideLv)
	self.data = data
	self.markPos = pos
	if self.data then
		self.fields.Com_item:initData(data.markId)
		self.fields.Com_item:getSetupItemUI():initData(data.markCfg, data.lv, data.star, data.randomElem)
		if isHideLv then
			self.fields.Com_item:getSetupItemUI():hideLv()
		end
		self.fields.icon_sign:setVisible(data.slot ~= nil)
		if data.slot ~= nil then
			local icon = divineBeastMarkRead.getBeastSlotIcon(data.beastId)
			if icon ~= nil then
				self.fields.icon_sign:setURL(icon)
			end
		end
		self.fields.lock:setVisible(data.lock == 1)
		if self.lastBagMarkId ~= nil and self.lastBagMarkId == self.data.bagMarkId and self.fields.Ani_sj and (self.lastLv < self.data.lv or self.lastMarkId ~= self.data.markId) then
			self.fields.Ani_sj:setVisible(true)
			self.fields.Ani_sj:setAllFrameNameOnce("ssyj_effect_sj_%02d.png", 1, false)
		end
		self.lastMarkId = self.data.markId
		self.lastBagMarkId = self.data.bagMarkId
		self.lastLv = self.data.lv
		self.lastStar = self.data.star
	else
		self.lastBagMarkId = nil
	end
end
function Com_MC_Mark:updateMark(bagMarkId)
	if self.data and (bagMarkId == nil or self.data.bagMarkId == bagMarkId) then
		self.data = divineBeastMarkCtrl:getMarkByBagMarkId(self.data.bagMarkId)
		self:initData(self.data, self.markPos)
	end
end
function Com_MC_Mark:setSelected(val)
	self.controllers.c1:setSelectedIndex(val and 1 or 0)
end
function Com_MC_Mark:setNewVisible(val)
end
function Com_MC_Mark:getItemData(...)
end
function Com_MC_Mark:onClick()
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self, self.data)
		return
	end
	if self.markPos then
		_ENV = self
		self.msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
		self.pos = self.markPos
		self.data = self.data
		SoraDSendMessage(self)
	end
end
function Com_MC_Mark:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_MC_Mark:showLongPress()
	self.fields.Com_item:openLongPress()
	self.fields.Com_item:setCustomTip(self.data)
end
return Com_MC_Mark
