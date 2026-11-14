local baseComponent = require("fgui.base.baseComponent")
local Com_ML_NeedItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_NeedItem", Com_ML_NeedItem)
function Com_ML_NeedItem:onInit()
end
function Com_ML_NeedItem:onShow()
end
function Com_ML_NeedItem:initByItem(item)
	local itemNum = item.haveNum
	local isEnough = item.isEnough
	local scheduCountColor = isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0)
	local buffStr = ""
	if item.needcount and item.needcount ~= item.num then
		buffStr = string.format(" %s", string.formatnumberthousands(item.num))
		self.fields.title:setString(buffStr)
		local buffStrWidth = self.fields.title:getWidth()
		self.fields.Sprite_luckLine:setWidth(buffStrWidth)
	end
	self.fields.Sprite_luckLine:setVisible(item.needcount and item.needcount ~= item.num)
	_ENV = itemNum
	itemNum.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(itemNum), itemNum)
	local totalStr = string.format("/%s", string.formatnumberthousands(item.needcount))
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	buffStr = _pq(buffStr)
	_ENV = string.formatnumberthousands(item.needcount)
	string.formatnumberthousands(item.needcount).c = buffStr
	_ENV, _ENV, string.formatnumberthousands(item.needcount).n = string.formatnumberthousands(item.needcount)
	string.formatnumberthousands(item.needcount).c, string.formatnumberthousands(item.needcount).color = string.formatnumberthousands(item.needcount)
	self.fields.title:setString(i18n_html("%{n}%{c}", string.formatnumberthousands(item.needcount)))
	self.fields.item:initData(item.id)
end
return Com_ML_NeedItem
