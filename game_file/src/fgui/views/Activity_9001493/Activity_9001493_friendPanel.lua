local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001493_friendPanel = class("Activity_9001493_friendPanel", baseFguiPanel)
function Activity_9001493_friendPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001493_friendPanel:ctor", self.viewName)
	self.rankIndex = 1
	self.switcher = false
end
function Activity_9001493_friendPanel:onInit()
	print("=======Activity_9001493_friendPanel:onInit")
	self.activityID = self.param.activityID
	self.fields.Com_title:initData(i18n("friend_name_01"), handler(self, self.onClickClose))
	self.fields.List_friend:setItemRenderer(handler(self, self.onFriendItemRederer))
	self.fields.List_friend:setVirtual()
	self.c_select = self.fields.Com_choose:getController("c_select")
	local _fields = fguiHelper.get_fields(self.fields.Com_choose)
	_ENV, _ENV = "c_select", self.fields.Com_choose
	;("c_select").widget = _fields.Button_choose
	_ENV, self.fields.Com_choose[1], ("c_select").title = "c_select", "c_select", ""
	;("c_select").widget = _fields.Button_name
	_ENV, self.fields.Com_choose[2], ("c_select").title = "c_select", "c_select", i18n("friend_text_02")
	;("c_select").widget = _fields.Button_uid
	self.fields.Com_choose[3], ("c_select").title = "c_select", i18n("friend_text_03")
	local config = self.fields.Com_choose
	self.btnConfig = config
	for k, v in pairs(config) do
		v.widget:addClickListener(handler(self, self.onClickBtnText))
		v.widget:setTag(k)
		v.widget:setString(v.title)
	end
	self:setSwitcher()
	if not SoraDFIsRA() then
		self.fields.Com_choose:fixPos()
		self.fields.Text_friendNum:fixPos()
	end
end
function Activity_9001493_friendPanel:onShow()
	print("=======Activity_9001493_friendPanel:onShow")
	contactCtrl:reqGetData(true, false, false)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001493_friendPanel:onFriendItemRederer(index, obj)
	local curList = self.sortList[self.rankIndex]
	local data = self.firendMap[curList[index + 1]]
	_UPVALUE0_ = nil
	;(nil).rankIndex = self.rankIndex
	;(nil).activityID = self.activityID
	obj:initData(data, nil)
end
function Activity_9001493_friendPanel:updateFriendList(...)
	SoraDCloseLoading(self:displayObject())
	local mapList = contactCtrl:getContactList()
	for k, v in pairs(mapList) do
		v.uid = tonumber(k)
	end
	self.firendMap = mapList
	local temp1 = table.keys(mapList)
	table.sort(temp1, function(a, b)
		local p1 = mapList[a]
		local p2 = mapList[b]
		return p1.totalFc > p2.totalFc
	end)
	local temp2 = table.keys(mapList)
	table.sort(temp2, function(a, b)
		local p1 = mapList[a]
		local p2 = mapList[b]
		return p1.cityLevel > p2.cityLevel
	end)
	_UPVALUE2_ = table.sort
	self.sortList, table.sort[1] = table.sort, temp1
	self.sortList, table.sort[2] = table.sort, temp2
	self:updateCurSortList()
	local friendCount = #self.sortList[1]
	local contactMax = contactCtrl:getContactFriendMax()
	_ENV = self:displayObject()
	self:displayObject().member = friendCount
	self:displayObject().total = contactMax
	self.fields.Text_friendNum:setString(i18n("friend_text_01") .. " " .. i18n("common_text_155", self:displayObject()))
end
function Activity_9001493_friendPanel:updateCurSortList(...)
	local curList = self.sortList[self.rankIndex]
	self.fields.List_friend:setNumItems(#curList)
end
function Activity_9001493_friendPanel:onClickBtnText(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	local cfg = self.btnConfig[tag]
	if tag == 1 then
		self.switcher = not self.switcher
	elseif tag == 2 then
		self.switcher = false
		if self.rankIndex ~= 1 then
			self.rankIndex = 1
			self:updateCurSortList()
		end
	elseif tag == 3 then
		self.switcher = false
		if self.rankIndex ~= 2 then
			self.rankIndex = 2
			self:updateCurSortList()
		end
	end
	self:setSwitcher()
end
function Activity_9001493_friendPanel:setSwitcher()
	local cfg = self.btnConfig[self.rankIndex + 1]
	local Button_choose = self.btnConfig[1].widget
	Button_choose:setString(cfg.title)
	self.c_select:setSelectedIndex(self.switcher and 1 or 0)
end
return Activity_9001493_friendPanel
