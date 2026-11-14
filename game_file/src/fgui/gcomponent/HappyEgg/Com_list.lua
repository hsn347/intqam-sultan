local newLotteryRead = include("newLotteryRead")
local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HappyEgg/Com_list", Com_list)
function Com_list:onInit()
	self.chooseList, _ENV, self.chooseNum = nil, nil, 0
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_list:onShow()
end
function Com_list:initData(data, index, handle)
	self.groupIndx = index
	local config = newLotteryRead.getChooseConfig(self.groupIndx)
	self.fields.Com_titleNormal:setString(i18n(config.title))
	self.fields.Com_titleNormal:getController("c2"):setSelectedIndex(self.groupIndx == 3 and 0 or 1)
	self.maxNum = config.maxNum
	newLotteryRead = i18n(config.title)
	i18n(config.title).num = self.maxNum
	self.fields.Text_SubTitle:setString(i18n("happyegg_09", i18n(config.title)))
	self.data = data
	self.fields.List:setNumItems(#self.data)
	self.fields.List:resizeToFit(#self.data)
	self.handle = handle
	dump(self.chooseList, "chooseList")
	self.handle(self.groupIndx, self.chooseList)
end
function Com_list:onItemRenderer(index, target)
	local data = self.data[index + 1]
	local Com_Item = target:getChildByName("Com_Item")
	local Check_tick = target:getChildByName("Check_tick")
	Com_Item:initData(data.reward[1].id, data.reward[1].count)
	Check_tick:setSelected(happyEggCtrl:isItemSelected(data.index))
	if happyEggCtrl:isItemSelected(data.index) then
		table.insert(self.chooseList, data.index)
	end
	Check_tick:addClickListener(handlerEx(self, self.onClickTick, data.index))
end
function Com_list:onClickTick(index, eventcontent)
	print("onClickTick")
	SoraDPlaySound()
	local isChoosed = false
	for i, v in ipairs(self.chooseList) do
		if v == index then
			isChoosed = true
			break
		end
	end
	if isChoosed then
		table.removebyvalue(self.chooseList, index)
	elseif table.nums(self.chooseList) >= self.maxNum then
		eventcontent:getSender():setSelected(false)
		_ENV = nil
		;(nil).num = self.maxNum
		SoraDShowMsgTip(i18n("Lamp_secret_text_03", nil))
	else
		table.insert(self.chooseList, index)
	end
	if self.handle then
		self.handle(self.groupIndx, self.chooseList)
	end
end
function Com_list:isChoosed()
	return table.nums(self.chooseList) >= self.maxNum
end
function Com_list:getChooseList()
	return self.chooseList
end
return Com_list
