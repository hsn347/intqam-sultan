local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_exchangebox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://evilPalace/list_exchangebox", list_exchangebox)
function list_exchangebox:onInit()
	self.needList, _ENV, self.isCanExchange = nil, nil, true
	self.fields.Btn_bigBox:addClickListener(handler(self, self.btnClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function list_exchangebox:onShow()
end
function list_exchangebox:onItemRenderer(index, obj)
	obj:initData(self.needList[index + 1])
end
function list_exchangebox:initData(data, index)
	self.data = data
	self.index = index
	self.fields.Text_singleTitle:setString(i18n(self.data.boxName))
	_UPVALUE2_ = i18n(self.data.boxName)
	i18n(self.data.boxName)[1] = "id"
	i18n(self.data.boxName)[2] = "count"
	self.needList = serviceFunctions.tableFormat(self.data.needItem, i18n(self.data.boxName))
	self.fields.List:setNumItems(#self.needList)
	self.isCanExchange = true
	for k, v in ipairs(self.needList) do
		local haveItemNum = backpackCtrl:getItemCount(v.id)
		if haveItemNum < v.count then
			self.isCanExchange = false
			break
		end
	end
	self.fields.Image_bigBox:setSpriteFrame(self.data.picture)
	self.fields.Image_bigBox:setGrayed(not self.isCanExchange)
end
function list_exchangebox:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).isCanExchange = self.isCanExchange
	uiManager:show("evilPalaceRewardView", nil)
end
return list_exchangebox
