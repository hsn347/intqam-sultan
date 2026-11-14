local baseComponent = require("fgui.base.baseComponent")
local Com_ChooseList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WishMeteor/Com_ChooseList", Com_ChooseList)
_UPVALUE4_ = fgui.register_extension
_UPVALUE3_, fgui.register_extension[1] = "Wishing_Meteor_04", "Wishing_Meteor_04"
_UPVALUE3_, fgui.register_extension[2] = "Wishing_Meteor_04", "Wishing_Meteor_05"
_UPVALUE3_, fgui.register_extension[3] = "Wishing_Meteor_04", "Wishing_Meteor_06"
local _UPVALUE3_, fgui.register_extension[4], titleConfig = "Wishing_Meteor_04", "Wishing_Meteor_07", fgui.register_extension
;("Wishing_Meteor_04")[1] = cc.c3b(253, 170, 68)
;("Wishing_Meteor_04")[2] = cc.c3b(213, 106, 239)
;("Wishing_Meteor_04")[3] = cc.c3b(57, 145, 201)
;("Wishing_Meteor_04")[4] = cc.c3b(54, 182, 37)
;("Wishing_Meteor_04")[5] = cc.c3b(54, 182, 37)
;("Wishing_Meteor_04")[6] = cc.c3b(54, 182, 37)
local ("Wishing_Meteor_04")[7], colorConfig = cc.c3b(54, 182, 37)
function Com_ChooseList:onInit()
	self.chooseNum = 0
	self.chooseList, _ENV, self.index = nil, nil, 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_ChooseList:onShow()
end
function Com_ChooseList:onItemRederer(index, target)
	target:initData(self.awardConfig[index + 1], index + 1)
	target:setHandle(handler(self, self.onClickItem))
end
function Com_ChooseList:onClickItem(index, id)
	print("index", index)
	local ret = 0
	local isChange = false
	if self.chooseList[index] then
		self.chooseList[index] = false
		self.chooseNum = self.chooseNum - 1
		isChange = true
	elseif self.chooseNum < 2 then
		self.chooseList[index] = id
		self.chooseNum = self.chooseNum + 1
		ret = 1
		isChange = true
	else
		SoraDShowMsgTip(i18n("Wishing_Meteor_09"))
	end
	if isChange and self.handle then
		self.handle(self.index, self.chooseNum == 2, self.chooseList)
	end
	return ret
end
function Com_ChooseList:setHandle(handle)
	self.handle = handle
end
function Com_ChooseList:initData(index, data)
	self.index = index + 1
	self.fields.title:setString(i18n(titleConfig[self.index]))
	self.fields.title:setColor(colorConfig[self.index])
	colorConfig = colorConfig[self.index]
	colorConfig[self.index][1] = "id"
	colorConfig[self.index][2] = "count"
	self.awardConfig = serviceFunctions.tableFormat(data.reward, colorConfig[self.index])
	for i, v in ipairs(self.awardConfig) do
		self.chooseList[i] = false
	end
	self.fields.List:setNumItems(#self.awardConfig)
end
return Com_ChooseList
