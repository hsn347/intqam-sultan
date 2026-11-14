local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Anniversary2022/Com_giftSingle", Com_giftSingle)
function Com_giftSingle:onInit()
	self:fixChildrenPos()
	self.fields.Com_slider:setInpuBoxFixPos(65, 65)
	self.fields.touch_delete:addClickListener(handler(self, self.onClickDelete))
end
function Com_giftSingle:initData(index, data, deleteCallBack, changeCallBack, submitCallBack)
	dump(data, "Fdlkfldkfld")
	self.index = index
	self.data = data
	self.deleteCallBack = deleteCallBack
	self.changeCallBack = changeCallBack
	self.fields.Text_itemName:setString(publicRead.getName(data.id))
	self.fields.Com_slider:getChild("title"):setString(data.price * data.count)
	self.fields.Com_item:initData(data.id, data.count * data.singleCount)
	_ENV = data.id
	data.id.maxValue = data.maxCount
	data.id.minValue = data.minCount
	data.id.curValue = data.count
	self.fields.Com_slider:initData(data.id)
	self.fields.Com_slider:setMinValue(data.minCount)
	self.fields.Com_slider:setSliderCallBack(handler(self, self.changeHandle))
end
function Com_giftSingle:changeHandle(count)
	if count == 0 then
		self.fields.Com_slider:getChild("slider"):setCanDrag(false)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(0.25)
		;(nil)[2] = ffa.callFunc(function()
			self.deleteCallBack(self.index)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.deleteCallBack(self.index)
		end)
		self:runAction(ffa.seq(nil))
		return
	else
		self.fields.Com_slider:getChild("title"):setString(count * self.data.price)
		self.fields.Com_item:initData(self.data.id, count * self.data.singleCount)
		self.changeCallBack(self.index, count)
	end
end
function Com_giftSingle:onClickDelete()
	SoraDPlaySound()
	_ENV = nil
	;(nil).item = publicRead.getName(self.data.id)
	SoraDShowMsgBox(i18n("giftgiving_text_13", nil), i18n("common_text_204"), nil, function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.loading = true
			self.deleteCallBack(self.index)
		end
	end)
end
function Com_giftSingle:onShow()
end
return Com_giftSingle
