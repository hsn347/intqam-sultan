local activityTimeRead = include("activityTimeRead")
local crossDecryptionCtrl = SoraDGetCtrl("crossMission2022Ctrl")
local crossDecryptionRead = include("crossDecryptionRead")
_ENV = "crossDecryptionRead"
;("crossDecryptionRead").DOING = 1
;("crossDecryptionRead").COMLIETE = 2
local ("crossDecryptionRead").COMLIETE_DONE, taskStatus = 3, "crossDecryptionRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MoonAndTreasureMapPanel = class("MoonAndTreasureMapPanel", baseFguiPanel)
function MoonAndTreasureMapPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MoonAndTreasureMapPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CROSS_MISSION_2022_ACTIVITY
	crossDecryptionRead.init(self.activityID)
end
function MoonAndTreasureMapPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
	end
	return self._packageList
end
function MoonAndTreasureMapPanel:onInit()
	print("=======MoonAndTreasureMapPanel:onInit")
	local activityname = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityname), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	for i = 1, 16 do
		local com_thelamp = self.fields["com_thelamp" .. i - 1]
		com_thelamp:getChild("Text_index"):setString(i)
		com_thelamp:getChild("Text_index2"):setString(i)
		com_thelamp:addClickListener(handler(self, self.onClickLamp))
		com_thelamp:setTag(i)
		com_thelamp.c_state = com_thelamp:getController("c_state")
		com_thelamp.c_color = com_thelamp:getController("c_color")
		com_thelamp.c_flash = com_thelamp:getController("c_flash")
		_UPVALUE2_ = com_thelamp
		com_thelamp[1] = "t0"
		com_thelamp[2] = "t_flash"
		for __, tName in ipairs(com_thelamp) do
			local t0 = com_thelamp:getTransition(tName)
			t0:play(1, 0, math.random(0, 100) / 100, -1, function()
				t0:play(-1, 0)
			end)
		end
	end
	for i = 1, 8 do
		do
			local com_package = self.fields["com_package" .. i]
			com_package:addClickListener(handler(self, self.onClickPackage))
			com_package:setTag(i)
			com_package.c_state = com_package:getController("c_state")
			local t0 = com_package:getTransition("t0")
			t0:play(1, 0, math.random(0, 100) / 100, -1, function()
				t0:play(-1, 0)
			end)
			local Movie_package = com_package:getChild("Movie_package")
			Movie_package:setAllFrameName("dh_zhounianzh4_%02d.png", 0)
		end
	end
	local Com_box = self.fields.Com_box
	Com_box:addClickListener(handler(self, self.onClickPackage))
	Com_box:setTag(9)
	Com_box.c_state = Com_box:getController("c_state")
	local Movie_box = Com_box:getChild("Movie_box")
	Movie_box:setAllFrameName("dh_zhounianzh6_%02d.png", 0)
end
function MoonAndTreasureMapPanel:onShow()
	print("=======MoonAndTreasureMapPanel:onShow")
	self:initData()
end
function MoonAndTreasureMapPanel:playGZAction(index)
	SoraDPlaySound("sixYear", "glory_seal")
	self:initData()
end
function MoonAndTreasureMapPanel:initData()
	local taskData = crossDecryptionCtrl:getTaskData()
	self.taskData, crossDecryptionCtrl = crossDecryptionCtrl, crossDecryptionCtrl
	for k, v in pairs(taskData) do
		table.insert(self.taskData, v)
	end
	table.sort(self.taskData, function(a, b)
		return a.index < b.index
	end)
	crossDecryptionCtrl = table.sort
	table.sort[taskStatus.DOING] = 0
	table.sort[taskStatus.COMLIETE] = 1
	local table.sort[taskStatus.COMLIETE_DONE], state2index = 2, table.sort
	for i = 1, 16 do
		local com_thelamp = self.fields["com_thelamp" .. i - 1]
		local selectedIndex = state2index[self.taskData[i].taskStatus]
		com_thelamp.c_state:setSelectedIndex(selectedIndex)
		com_thelamp.c_color:setSelectedIndex(math.random(0, 3))
		local selectedIndex = 1
		if i < 10 then
			selectedIndex = 0
		end
		com_thelamp.c_flash:setSelectedIndex(selectedIndex)
	end
	for i = 1, 8 do
		local com_package = self.fields["com_package" .. i]
		local selectedIndex = 0
		if crossDecryptionCtrl:checkCurBoxStatus(i) then
			selectedIndex = 1
		end
		com_package.c_state:setSelectedIndex(selectedIndex)
	end
	local selectedIndex = 0
	if crossDecryptionCtrl:checkBigAward() then
		selectedIndex = 1
	end
	self.fields.Com_box.c_state:setSelectedIndex(selectedIndex)
end
function MoonAndTreasureMapPanel:onClickLamp(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	_ENV = nil
	;(nil).taskData = self.taskData[index]
	;(nil).activityID = self.activityID
	uiManager:show("DecryptionRewardPop", nil):setOwnerKey(self)
end
function MoonAndTreasureMapPanel:onClickPackage(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	_ENV = nil
	;(nil).idx = index
	;(nil).activityID = self.activityID
	uiManager:show("DecryptionLineRewardPop", nil):setOwnerKey(self)
end
function MoonAndTreasureMapPanel:onClickHelp()
	SoraDPlaySound()
	local activityname = activityTimeRead.getActivityNameByID(self.activityID)
	_ENV = nil
	;(nil).title = i18n(activityname)
	;(nil).content = i18n("glory_seal_01")
	uiManager:show("RuleView", nil)
end
return MoonAndTreasureMapPanel
