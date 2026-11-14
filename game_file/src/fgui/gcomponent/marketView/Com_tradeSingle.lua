local publicRead = include("publicRead")
local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_tradeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/Com_tradeSingle", Com_tradeSingle)
function Com_tradeSingle:onInit()
	self.fields.Text_nowPriceTip:setString(i18n("common_text_2807"))
	self.fields.Button_addPrice:setString(i18n("common_text_2806"))
	self.fields.Button_addPrice:addClickListener(handler(self, self.btnClick))
	self.fields.TextField_addPrice:setAlign(SoraDFLabelR())
	self.fields.TextField_addPrice:setMaxLength(8)
	self.fields.icon_jpz:setSpriteFrame(SoraDFIsRA() and "ay_jpz.png" or "en_jpz.png")
	self:fixChildrenPos()
	self.fields.n2:fix()
end
function Com_tradeSingle:onShow()
end
function Com_tradeSingle:initData(data, myUid)
	self.data = data
	self.uid = myUid
	self.isMyPrice = self.data.ownUid and tostring(self.data.ownUid) == tostring(self.uid)
	self.controllers.c1:setSelectedIndex(self.isMyPrice and 1 or 0)
	self.fields.TextField_addPrice:setText("")
	if not self.isMyPrice or not "" then
		_ENV = nil
		;(nil).price = tostring(self.data.currSaleGold + self.data.plus)
	end
	self.fields.TextField_addPrice:setPrompt((fguiHelper.getColorString("#746e65", i18n("common_text_3030", nil))))
	self.fields.item:initData(self.data.item, self.data.num)
	self.fields.Text_title:setString(publicRead.getName(self.data.item))
	local leftTime = self.data.endTime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Text_timeLimit:beginTime(leftTime)
	end
	self.fields.Text_nowPrice:setString(self.data.currSaleGold)
end
function Com_tradeSingle:btnClick()
	SoraDPlaySound()
	if self.isMyPrice then
		SoraDShowMsgTip(i18n("common_text_2845"))
		return
	end
	local inputPrice = self.fields.TextField_addPrice:getText()
	if inputPrice == "" then
		self.fields.TextField_addPrice:setText(tostring(self.data.currSaleGold + self.data.plus))
		self.fields.TextField_addPrice:setPrompt("")
		inputPrice = self.fields.TextField_addPrice:getText()
	end
	local tmpInputPrice = tonumber(inputPrice) or 0
	if tmpInputPrice >= self.data.currSaleGold + self.data.plus then
		if SoraDEnoughGold(tmpInputPrice) then
			local preID = self.data.shopID
			_ENV = tostring(self.data.currSaleGold + self.data.plus)
			_ENV = tostring(self.data.currSaleGold + self.data.plus)
			tostring(self.data.currSaleGold + self.data.plus).name = publicRead.getName(self.data.item)
			tostring(self.data.currSaleGold + self.data.plus).count = self.data.num
			tostring(self.data.currSaleGold + self.data.plus).item = i18n("common_text_1460", tostring(self.data.currSaleGold + self.data.plus))
			tostring(self.data.currSaleGold + self.data.plus).gold = inputPrice
			SoraDShowMsgBox(i18n("common_text_2812", tostring(self.data.currSaleGold + self.data.plus)), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					salesRoomAgCtrl:sendAddPlusMsg(preID, inputPrice)
				end
			end)
		end
	else
		SoraDShowMsgTip(i18n("common_text_3110"))
	end
end
return Com_tradeSingle
