local abcClubCtrl = SoraDGetCtrl("abcClubCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_row = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://letterClub/Com_row", Com_row)
function Com_row:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.Com_item:setClickCallback(handler(self, self.onClickItem))
	self.fields.Com_item:fixPos()
	self.fields.List:fixPos()
end
function Com_row:onShow()
	self.isRunSlot = false
	self.runeMap, _UPVALUE0_, self.isCanExchange = nil, nil, false
end
function Com_row:onItemRenderer(index, obj)
	obj:initData(self.data.rune[index + 1], index + 1, self.runeMap, handler(self, self.onClickExchange))
end
function Com_row:initData(data)
	self.data = data
	self:updateView()
	if self.isRunSlot then
		self:stopSlot()
	else
		self.fields.List:setNumItems(6)
	end
end
function Com_row:updateView()
	self.runeMap, _ENV, self.isCanExchange = nil, nil, true
	local _ENV, map
	for i, v in ipairs(self.data.rune) do
		map[v] = (map[v] or 0) + 1
		local isEnough = backpackCtrl:getItemCount(v) >= map[v]
		if not isEnough then
			self.isCanExchange = false
		end
		self.runeMap[i] = isEnough
	end
	self.fields.Com_item:initData(self.data.reward.id, self.data.reward.count)
	if self.isCanExchange then
		self.fields.Com_item:setEffect(1)
	else
		self.fields.Com_item:hideEffect()
	end
end
function Com_row:runSlot()
	self.isRunSlot = true
	for i, v in ipairs(self.fields.List:getChildren()) do
		v:runSlot(self.data.rune)
	end
end
function Com_row:stopSlot()
	local delay = 0.1
	self.isRunSlot = false
	for i, v in ipairs(self.fields.List:getChildren()) do
		_UPVALUE1_ = self.fields.List:getChildren()
		self.fields.List:getChildren()[1] = ffa.delay(i * delay)
		self.fields.List:getChildren()[2] = ffa.callFunc(function(...)
			v:stopSlot(self.data.rune[i], i, self.runeMap, handler(self, self.onClickExchange))
		end)
		self.fields.List:getChildren()[3] = ffa.callFunc(function(...)
			v:stopSlot(self.data.rune[i], i, self.runeMap, handler(self, self.onClickExchange))
		end)
		v:runAction(ffa.seq(self.fields.List:getChildren()))
	end
end
function Com_row:onClickExchange()
	if self.isRunSlot then
		return
	end
	SoraDPlaySound()
	if self.isCanExchange then
		_ENV = nil
		;(nil).content = i18n("common_text_2073")
		;(nil).confirmFunc = function()
			abcClubCtrl:sendExchange(self.data.rid)
			self:runSlot()
		end
		uiManager:show("MessageBox", nil)
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function Com_row:onClickItem()
	if not self.isCanExchange then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		self:onClickExchange()
	end
end
return Com_row
