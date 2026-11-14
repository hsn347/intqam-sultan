local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_popbox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://angerSnowWolf/list_popbox", list_popbox)
function list_popbox:onInit()
	self.needList, _ENV = nil, nil
	self.fields.Btn_bigBox:addClickListener(handler(self, self.btnClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlign(SoraDFIsRA() and 0 or 2)
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
end
function list_popbox:onShow()
end
function list_popbox:onItemRenderer(index, obj)
	obj:initData(self.needList[index + 1])
end
function list_popbox:initData(data, index)
	self.data = data
	self.index = index
	self.fields.Text_singleTitle:setString(i18n(self.data.boxName))
	self.fields.Image_bigBox:setSpriteFrame(self.data.picture)
	_UPVALUE2_ = self.data.picture
	self.data.picture[1] = "id"
	self.data.picture[2] = "count"
	self.needList = serviceFunctions.tableFormat(self.data.needItem, self.data.picture)
	self.fields.List:setNumItems(#self.needList)
end
function list_popbox:btnClick()
	SoraDPlaySound()
	local isCanExchange = true
	for k, v in ipairs(self.needList) do
		local haveItemNum = backpackCtrl:getItemCount(v.id)
		if haveItemNum < v.count then
			isCanExchange = false
			break
		end
	end
	_ENV = nil
	;(nil).index = self.index
	;(nil).isCanExchange = isCanExchange
	uiManager:show("angerRewardView", nil)
end
return list_popbox
