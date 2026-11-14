local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_letter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://letterClub/Com_letter", Com_letter)
function Com_letter:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.transitions.t0:setHook("new", handler(self, self.randomRune))
	self.transitions.t0:setHook("end", handler(self, self.endShow))
	self.transitions.t0:setTimeScale(1.5)
end
function Com_letter:onShow()
	self:stopSlot()
end
function Com_letter:initData(itemID, index, runeMap, handler)
	self.itemID = itemID
	self.index = index
	self.runeMap = runeMap
	self.handler = handler
	if not self.isRunning then
		self:initView()
	end
end
function Com_letter:initView()
	if self.itemID then
		self.fields.Com_item:setVisible(true)
		self.fields.Com_item:initData(self.itemID)
		self.fields.Com_item:setGrayed(not self.runeMap[self.index])
	else
		self.fields.Com_item:setVisible(false)
	end
end
function Com_letter:randomRune()
	local rune = self.runeList[math.random(1, #self.runeList)]
	self.fields.Com_item:initData(rune)
end
function Com_letter:endShow()
	if not self.isRunning then
		self.transitions.t0:stop()
		self:initData(self.rune, self.index, self.runeMap, self.handler)
	end
end
function Com_letter:runSlot(runeList)
	self.isRunning = true
	self.runeList = runeList
	self.transitions.t0:play(-1, 0, 0, -1)
end
function Com_letter:stopSlot(rune, index, runeMap, handler)
	self.isRunning = false
	self.rune = rune
	self.index = index
	self.runeMap = runeMap
	self.handler = handler
end
function Com_letter:btnClick()
	if self.itemID then
		SoraDPlaySound()
		local ret = shopCtrl:getShopItemByItemID(self.itemID)
		if ret then
			_ENV = nil
			;(nil).itemData = ret
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	elseif self.handler then
		self.handler()
	end
end
return Com_letter
