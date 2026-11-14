local publicRead = include("publicRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local storesCtrl = SoraDGetCtrl("storesCtrl")
local baseComponent = require("fgui.base.baseComponent")
local merchanteSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://merchanteView/merchanteSingle", merchanteSingle)
function merchanteSingle:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self:showLightEffect()
	self.fields.item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Button_buy:fixPos()
	self.fields.n11:fixPos()
	self.fields.n11:fix()
	self.fields.Text_benefits:fixPos()
	self.fields.Text_benefits:fix()
end
function merchanteSingle:onShow()
end
function merchanteSingle:initData(data, parent, com)
	self.itemData = data
	self.parent = self.parent or parent
	self.com = self.com or com
	self.fields.item:initData(self.itemData.itemId)
	_ENV = nil
	;(nil).name = publicRead.getName(self.itemData.itemId)
	;(nil).count = string.formatnumberthousands(self.itemData.itemNum)
	self.fields.Text_des:setString(i18n("common_text_1460", nil))
	local cond = publicRead.checkLevelCondition(self.itemData.itemId)
	self.fields.Text_des:setColor(cond and cc.c3b(190, 40, 40) or cc.c3b(240, 230, 210))
	self.controllers.c1:setSelectedIndex(self.itemData.quality <= gQualityDef.BLUE and 0 or 1)
	if self.itemData.quality > gQualityDef.BLUE and self.itemData.quality < gQualityDef.GOLD then
		self.fields.Text_benefits:setString(i18n("common_text_437"))
	elseif self.itemData.quality >= gQualityDef.GOLD then
		self.fields.Text_benefits:setString(i18n("common_text_438"))
	end
	self.fields.Button_buy:initData(self.itemData)
	self:addEffectByColor(self.itemData.quality)
end
function merchanteSingle:showLightEffect()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	_UPVALUE3_ = math.random()
	_UPVALUE1_ = 50
	_UPVALUE2_ = os.time()
	os.time()[1] = ffa.fadeTo(0.25, 0.8)
	os.time()[2] = ffa.delay(0.45)
	os.time()[3] = ffa.fadeTo(0.25, 0)
	os.time()[4] = ffa.fadeTo(0.25, 0)
	os.time()[5] = ffa.fadeTo(0.25, 0)
	os.time()[6] = ffa.fadeTo(0.25, 0)
	_UPVALUE1_ = ffa.fadeTo(0.25, 0.8)
	ffa.fadeTo(0.25, 0.8)[1] = ffa.moveTo(0.25, 65, 4)
	ffa.fadeTo(0.25, 0.8)[2] = ffa.moveTo(0.7, 460, 4)
	ffa.fadeTo(0.25, 0.8)[3] = ffa.moveTo(0.7, 460, 4)
	ffa.fadeTo(0.25, 0.8)[4] = ffa.moveTo(0.7, 460, 4)
	ffa.fadeTo(0.25, 0.8)[5] = ffa.moveTo(0.7, 460, 4)
	;(50)[1] = ffa.seq(os.time())
	;(50)[2] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[3] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[4] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[5] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[6] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[7] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	;(50)[8] = ffa.seq((ffa.fadeTo(0.25, 0.8)))
	math.random()[1] = ffa.delay(math.random(50, 200) / 100)
	math.random()[2] = ffa.spawn(50)
	math.random()[3] = ffa.callFunc(function()
		self.fields.Image_light:setPosition(-100, 4)
		self.fields.Image_light:setAlpha(0)
	end)
	math.random()[4] = ffa.delay(2)
	math.random()[5] = ffa.delay(2)
	math.random()[6] = ffa.delay(2)
	math.random()[7] = ffa.delay(2)
	math.random()[8] = ffa.delay(2)
	math.random()[9] = ffa.delay(2)
	math.random()[10] = ffa.delay(2)
	math.random()[11] = ffa.delay(2)
	local action = ffa.repeatForever(ffa.seq((math.random())))
	self.fields.Image_light:runAction(action)
end
function merchanteSingle:overTurnAction(data)
	self.itemData = data
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1, 0)
	;(nil)[2] = ffa.callFunc(function()
		self:initData(self.itemData, self.parent, self.com)
	end)
	;(nil)[3] = ffa.scaleTo(0.2, 1, 1)
	;(nil)[4] = ffa.scaleTo(0.2, 1, 1)
	;(nil)[5] = ffa.scaleTo(0.2, 1, 1)
	;(nil)[6] = ffa.scaleTo(0.2, 1, 1)
	local action = ffa.seq(nil)
	self:runAction(action)
end
function merchanteSingle:getData()
	return self.itemData
end
function merchanteSingle:addEffectByColor(color)
	self.controllers.c2:setSelectedIndex(color)
end
function merchanteSingle:btnBuyClick()
	SoraDPlaySound()
	if self.parent and self.parent.setCurClickItem then
		self.parent:setCurClickItem(self.itemData.itemId)
	end
	if gIDDef.GOLD == self.itemData.pricetype then
		_ENV = nil
		;(nil).itemData = self.itemData
		uiManager:show("merchanteItemBuyPopBox", nil)
	elseif self:comparePrice() then
		self:confirm2Buy()
	end
end
function merchanteSingle:confirm2Buy()
	storesCtrl:purchase(self.itemData.shopItemID)
end
function merchanteSingle:comparePrice()
	if gIDDef.GOLD == self.itemData.pricetype then
		return SoraDEnoughGold(self.itemData.price)
	else
		local result = SoraDEnoughRes(self.itemData.pricetype, self.itemData.price)
		if not result then
			SoraDShowMsgBox(i18n("common_text_565"), i18n("common_text_282"), nil, function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					_ENV, _ENV = nil, MSGBOX_CALLBACK_YES
					;(nil).resid = self.itemData.pricetype
					;(nil).rescount = self.itemData.price
					MSGBOX_CALLBACK_YES[1], (nil).curcount = nil, cityCtrl:getResCount(self.itemData.pricetype)
					local needResList = MSGBOX_CALLBACK_YES
					_ENV = self.itemData.pricetype
					self.itemData.pricetype.rid = self.itemData.pricetype
					self.itemData.pricetype.needResData = needResList
					uiManager:show("resourceBuyView", self.itemData.pricetype)
				end
			end)
		end
		return result
	end
end
return merchanteSingle
