local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local publicRead = include("publicRead")
local exclusiveVipRead = include("exclusiveVipRead")
local head = include("head")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gotPrivilegePopViewPanel = class("gotPrivilegePopViewPanel", baseFguiPanel)
function gotPrivilegePopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gotPrivilegePopViewPanel:ctor", self.viewName)
end
function gotPrivilegePopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gotPrivilegePopViewPanel:onInit()
	print("=======gotPrivilegePopViewPanel:onInit")
	self:initControls()
	self:initScroll()
end
function gotPrivilegePopViewPanel:onShow()
	print("=======gotPrivilegePopViewPanel:onShow")
end
function gotPrivilegePopViewPanel:initControls()
	self.fields.Panel_bg:setTitle(i18n("privilege_text_17"))
	self.scroll = self.fields.scroll
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function gotPrivilegePopViewPanel:initScroll()
	local totalScore = exaltedPrivilegeCtrl:getTotalScores()
	local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
	local exaltedPrivilegeCtrl, taskList = totalScore, totalScore
	for i, v in ipairs(curPrivilegeList) do
		local curTask = exclusiveVipRead:getPrivilegeInfo(v)
		table.insert(taskList, curTask)
	end
	table.sort(taskList, function(l, r)
		if l.grade == r.grade then
			return l.index < r.index
		else
			return l.grade < r.grade
		end
	end)
	self.taskList = taskList
	self.scroll:setNumItems(#taskList)
end
function gotPrivilegePopViewPanel:onItemRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:fixChildrenPos()
	local fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).num = data.value
	fields.txtName:setString(i18n(data.name, nil))
	fields.txtIns:setString(i18n(data.describe))
	if data.type == gExaltedPrivilegeType.LORD_HEAD_PRIVILEGE then
		local strName = i18n(head[data.value[1]].name)
		_ENV = i18n(data.describe)
		i18n(data.describe).name = strName
		fields.txtName:setString(i18n(data.name, i18n(data.describe)))
		_ENV = i18n(data.name, i18n(data.describe))
		i18n(data.name, i18n(data.describe)).name = strName
		fields.txtIns:setString(i18n(data.describe, i18n(data.name, i18n(data.describe))))
	end
	fields.imgIcon:setURL(data.icon)
end
return gotPrivilegePopViewPanel
