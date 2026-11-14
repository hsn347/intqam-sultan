local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Need = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Need", Com_ML_Need)
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Com_ML_Need:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.go:setTitle(i18n("common_text_337"))
	self.fields.go:addClickEventListener(handler(self, self.onGetClick))
end
function Com_ML_Need:onShow()
end
function Com_ML_Need:initByItem(item, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.itemData = item
	local itemNum = item.haveNum
	local isEnough = item.isEnough
	local scheduCountColor = isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0)
	_ENV = itemNum
	itemNum.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(itemNum), itemNum)
	local totalStr = string.format("/%s", string.formatnumberthousands(item.num))
	local value = string.format("%s %s%s", publicRead.getName(item.id), countStr, totalStr)
	self.controllers.c1:setSelectedIndex(isEnough and 0 or 1)
	self.fields.icon:setURL(publicRead.getIcon(item.id))
	fguiHelper.get_controllers(self.fields.go).c1:setSelectedIndex(2)
	if item.needcount and item.needcount ~= item.num then
		self.fields.title:setString(value)
		self:updateLuckyValue(true, item.needcount, isEnough)
	else
		self:updateLuckyValue(false)
	end
	self.fields.title:setString(value)
end
function Com_ML_Need:initByRes(res, index)
	self.needRes = res
	self.fields.bg:setVisible(index % 2 == 1)
	local isEnough = res.isEnough
	self.controllers.c1:setSelectedIndex(isEnough and 0 or 1)
	self.fields.title:setString(string.formatnumberthousands(res.num))
	self.fields.icon:setURL(publicRead.getIcon(res.id))
	local scheduCountColor = isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0)
	self.fields.title:setColor(scheduCountColor)
	fguiHelper.get_controllers(self.fields.go).c1:setSelectedIndex(2)
	if res.needcount and res.needcount ~= res.num then
		self:updateLuckyValue(true, res.needcount, isEnough)
	else
		self:updateLuckyValue(false)
	end
end
function Com_ML_Need:initByData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	local isEnough = data.isEnough
	self.controllers.c1:setSelectedIndex(isEnough and 0 or 1)
	self.fields.title:setString(data.name)
	self.fields.icon:setURL(data.icon)
	local scheduCountColor = isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0)
	self.fields.title:setColor(scheduCountColor)
	if data.getBtnTitle ~= nil then
		self.fields.go:setTitle(data.getBtnTitle)
		fguiHelper.get_controllers(self.fields.go).c1:setSelectedIndex(2)
	end
	self.fields.go:setVisible(data.getBtnTitle ~= nil)
	self.data = data
end
function Com_ML_Need:updateLuckyValue(isShow, needcount, isEnough)
	self.fields.Sprite_luckLine:setVisible(isShow)
	self.fields.Text_luckValue:setVisible(isShow)
	if isShow then
		local labelW = self.fields.title:getTextAreaWidth()
		self.fields.Sprite_luckLine:setWidth(labelW)
		self.fields.Text_luckValue:setString(string.formatnumberthousands(needcount))
		if not isEnough then
			self.fields.Text_luckValue:setColor(cc.c3b(234, 23, 22))
		else
			self.fields.Text_luckValue:setColor(cc.c3b(240, 230, 210))
		end
	end
end
function Com_ML_Need:setGetClickCallback(callback)
	self.getClickCallback = callback
end
function Com_ML_Need:onGetClick()
	SoraDPlaySound()
	if self.getClickCallback then
		self.getClickCallback(self.needRes, self.data, self.itemData)
	end
end
return Com_ML_Need
