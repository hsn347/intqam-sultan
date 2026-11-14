local activity_9001571_Read = include("activity_9001571_Read")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local activity_9001571_Ctrl = SoraDGetCtrl("activity_9001571_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001571_ChoosePanel = class("Activity_9001571_ChoosePanel", baseFguiPanel)
function Activity_9001571_ChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001571_ChoosePanel:ctor", self.viewName)
end
function Activity_9001571_ChoosePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
	end
	return self._packageList
end
function Activity_9001571_ChoosePanel:onInit()
	print("=======Activity_9001571_ChoosePanel:onInit")
	self.fields.panel_normal:setString(i18n("Back_battlefield_02"))
	self.fields.Text_Tips:setString(i18n("Back_battlefield_03"))
	self.groupList = clone(activity_9001571_Read.getGroupList(activity_9001571_Ctrl:getClassType()))
	local nameStr = ""
	for i, v in ipairs(self.groupList) do
		nameStr = nameStr .. i18n(heroltCtrl.getHeroName(v.heroID))
		if i ~= #self.groupList then
			nameStr = nameStr .. ","
		end
	end
	_ENV = activity_9001571_Read.getGroupList(activity_9001571_Ctrl:getClassType())
	activity_9001571_Read.getGroupList(activity_9001571_Ctrl:getClassType()).name = nameStr
	self.fields.Text_title:setString(i18n("Back_battlefield_04", activity_9001571_Read.getGroupList(activity_9001571_Ctrl:getClassType())))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollCallBack))
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndCallBack))
	dump(self.groupList, "self.groupList")
	self.fields.List_point:setNumItems(#self.groupList)
	_ENV = handler(self, self.onScrollEndCallBack)
	table.insert(self.groupList, 1, handler(self, self.onScrollEndCallBack))
	_ENV = 1
	table.insert(self.groupList, 1)
	self.fields.List:setNumItems(#self.groupList)
	self.fields.Button_Choose:setString(i18n("treasure_crystal_btn_02"))
	self.fields.Button_Choose:addClickListener(handler(self, self.onClickChoose))
end
function Activity_9001571_ChoosePanel:onShow()
	print("=======Activity_9001571_ChoosePanel:onShow")
	self:btnDressChoose(self:getChooseIndexByGroupId(activity_9001571_Ctrl:getGroupID()))
	self:onScrollCallBack()
	if activity_9001571_Ctrl:getGroupID() > 0 and not activity_9001571_Ctrl:getCanChangeReward() then
		local heroID = self.groupList[self.chooseIndex + 1].heroID
		local nameStr = i18n(heroltCtrl.getHeroName(heroID))
		_ENV = heroltCtrl.getHeroName(heroID)
		heroltCtrl.getHeroName(heroID).name = nameStr
		self.fields.Text_title:setString(i18n("Back_battlefield_13", heroltCtrl.getHeroName(heroID)))
		for __, obj in pairs(self.fields.List:getChildren()) do
			obj:setChooseIndex(self.chooseIndex)
		end
		self.fields.List:setTouchEnabled(false)
		self.fields.Button_Choose:setVisible(false)
	end
end
function Activity_9001571_ChoosePanel:onItemRederer(index, target)
	target:setPivot(0.5, 0.5)
	target:setMyHandle(handler(self, self.btnDressChoose))
	target:initData(self.groupList[index + 1], index)
end
function Activity_9001571_ChoosePanel:onScrollCallBack()
	local midX = self.fields.List:getScrollPane():getPositionX() + self.fields.List:getWidth() / 2
	local cnt = self.fields.List:numChildren()
	for i = 0, cnt - 1 do
		local obj = self.fields.List:getChildAt(i)
		local dist = math.abs(midX - obj:getPositionX() - obj:getWidth() / 2)
		if dist > obj:getWidth() then
			obj:setScale(1, 1)
		else
			local ss = 1 + (1 - dist / obj:getWidth()) * 0.15
			obj:setScale(ss, ss)
		end
	end
end
function Activity_9001571_ChoosePanel:onScrollEndCallBack()
	local midX = self.fields.List:getScrollPane():getPositionX() + self.fields.List:getWidth() / 2
	local chooseIndex = 3
	local minOffsetX = self.fields.List:getInnerContainerSize().width
	local cnt = self.fields.List:numChildren()
	for i = 0, cnt - 1 do
		local obj = self.fields.List:getChildAt(i)
		if not obj:isEmptyCom() then
			local dist = math.abs(midX - obj:getPositionX() - obj:getWidth() / 2)
			if minOffsetX > dist then
				chooseIndex = i
				minOffsetX = dist
			end
		end
	end
	self:btnDressChoose(chooseIndex)
	self:onScrollCallBack()
end
function Activity_9001571_ChoosePanel:btnDressChoose(chooseIndex)
	self.chooseIndex = chooseIndex
	self.fields.List:scrollToCenter(self.fields.List:getChildAt(self.chooseIndex), true)
	self.fields.List_point:setSelectedIndex(self.chooseIndex - 1)
	self.fields.List:setSelectedIndex(self.chooseIndex)
end
function Activity_9001571_ChoosePanel:getChooseIndexByGroupId(groupID)
	for i, v in ipairs(self.groupList) do
		if v.group and v.group == groupID then
			return i - 1
		end
	end
	return 1
end
function Activity_9001571_ChoosePanel:onClickChoose()
	SoraDPlaySound()
	local contentKey = ""
	if activity_9001571_Ctrl:getCanChangeReward() then
		contentKey = "Back_battlefield_12"
	else
		contentKey = "Back_battlefield_05"
	end
	_ENV = nil
	_ENV = nil
	;(nil).name = i18n(heroltCtrl.getHeroName(self.groupList[self.chooseIndex + 1].heroID))
	;(nil).content = i18n(contentKey, nil)
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		SoraDShowLoading()
		activity_9001571_Ctrl:reqHeroOrderChangeRewardGroup(self.groupList[self.chooseIndex + 1].group)
	end
	uiManager:show("MessageBox", nil)
end
return Activity_9001571_ChoosePanel
