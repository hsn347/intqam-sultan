local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BosList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://JerseyActivity/Com_BosList", Com_BosList)
function Com_BosList:onInit()
	self.itemsList, _UPVALUE0_ = nil, nil
	self.fields.Com_bar:getChild("bar"):fixPos()
end
function Com_BosList:onShow()
end
function Com_BosList:initData(num, awardList, type)
	local maxLen = (num - 1) * 108 + 20
	local maxPosx = maxLen + 30
	self.fields.Com_bar:setContentSize(cc.size(maxLen, 32))
	local offset = 108
	local numFinish = footballClothesCtrl:getFinishRewardNum(type)
	for i, v in ipairs(awardList) do
		local index = math.floor(1 + (i - 1) * 7 / (num - 1))
		local item = fgui.UIPackage:createObjectFromURL("ui://JerseyActivity/Com_box")
		item:addTo(self)
		item:setPosition(SoraDFPosX(maxPosx - offset * (i - 1), maxLen + 80), 60)
		table.insert(self.itemsList, item)
		item:initData(v, index, type)
	end
	self:getScrollPane():setPosX(SoraDFIsRA() and maxPosx + 60 - 640 - numFinish * offset or numFinish * offset)
end
function Com_BosList:updateItems()
	for i, v in ipairs(self.itemsList) do
		v:updateItem()
	end
end
function Com_BosList:setBarValue(value)
	self.fields.Com_bar:setValue(value)
end
function Com_BosList:setBarMax(maxValue)
	self.fields.Com_bar:setMax(maxValue)
end
return Com_BosList
