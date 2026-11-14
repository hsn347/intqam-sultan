local baseComponent = require("fgui.base.baseComponent")
local Com_ML_have = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_have", Com_ML_have)
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Com_ML_have:onInit()
	self.fields.Button_add:addClickEventListener(handler(self, self.onClickAdd))
	self.fields.title:fixPos()
	self.fields.icon:fixPos()
	self.fields.Button_add:fixPos()
end
function Com_ML_have:onClickAdd()
	SoraDPlaySound()
	if self.addCallback then
		self.addCallback()
	else
		local _ENV, sourcesData = self.addCallback, self.addCallback
		local list = include("itemDesRead").getOutput(self.itemID)
		for i, v in ipairs(list) do
			if not table.keyof(sourcesData, v) then
				table.insert(sourcesData, v)
			end
		end
		_ENV = nil
		;(nil).sources = sourcesData
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Com_ML_have:onShow()
end
function Com_ML_have:initData(itemID)
	self.itemID = itemID
	self:setIcon(publicRead.getIcon(itemID))
end
function Com_ML_have:updateNum(needNum, subPercent)
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	local newNeedNum = math.ceil(needNum * subPercent)
	local isEnough = itemNum >= newNeedNum
	print("subPercent", subPercent, needNum)
	local scheduCountColor = isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0)
	backpackCtrl = itemNum
	itemNum.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(itemNum), itemNum)
	local totalStr = string.format("/%s", string.formatnumberthousands(newNeedNum))
	local buffStr = subPercent == 1 and "" or string.format(" %s", string.formatnumberthousands(math.ceil(needNum)))
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	buffStr = _pq(buffStr)
	if subPercent ~= 1 then
		self.fields.title:setString(buffStr)
		local buffStrWidth = self.fields.title:getWidth()
		self.fields.Sprite_luckLine:setWidth(buffStrWidth)
	end
	self.fields.Sprite_luckLine:setVisible(subPercent ~= 1)
	backpackCtrl = string.formatnumberthousands(math.ceil(needNum))
	string.formatnumberthousands(math.ceil(needNum)).c = buffStr
	backpackCtrl, backpackCtrl, string.formatnumberthousands(math.ceil(needNum)).n = string.formatnumberthousands(math.ceil(needNum))
	string.formatnumberthousands(math.ceil(needNum)).c, string.formatnumberthousands(math.ceil(needNum)).color = string.formatnumberthousands(math.ceil(needNum))
	self.fields.title:setString(i18n_html("%{n}%{c}", string.formatnumberthousands(math.ceil(needNum))))
	return itemNum, isEnough
end
function Com_ML_have:setAddCallback(cb)
	self.addCallback = cb
end
return Com_ML_have
