local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local alliancePBLScheduleView = class("alliancePBLScheduleView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePBLScheduleView")
	end
	return target
end)
function alliancePBLScheduleView:ctor()
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self.centerNode, "CCS_commonPopBox_bg")
	self.nodeBg:setTitleName(i18n("pyramid_text_77"))
	self.nodeSchedule = SoraDGetChildByName(self.centerNode, "Node_schedule")
	self.nodeHegemony = SoraDGetChildByName(self.centerNode, "Node_hegemony")
	self.labelTime16 = SoraDGetChildByName(self.centerNode, "Text_time_1_6")
	self.labelDes6 = SoraDGetChildByName(self.centerNode, "Text_des_6")
	self.labelTime15 = SoraDGetChildByName(self.centerNode, "Text_time_1_5")
	self.labelDes7 = SoraDGetChildByName(self.centerNode, "Text_des_7")
	self.labelTime14 = SoraDGetChildByName(self.centerNode, "Text_time_1_4")
	self.labelDes5 = SoraDGetChildByName(self.centerNode, "Text_des_5")
	self.labelTime13 = SoraDGetChildByName(self.centerNode, "Text_time_1_3")
	self.labelDes4 = SoraDGetChildByName(self.centerNode, "Text_des_4")
	self.labelTitle5 = SoraDGetChildByName(self.centerNode, "Text_title_5")
	self.labelTime12 = SoraDGetChildByName(self.centerNode, "Text_time_1_2")
	self.labelTime11 = SoraDGetChildByName(self.centerNode, "Text_time_1_1")
	self.labelDes2 = SoraDGetChildByName(self.centerNode, "Text_des_2")
	self.labelDes3 = SoraDGetChildByName(self.centerNode, "Text_des_3")
	self.nodeMiddle = SoraDGetChildByName(self.centerNode, "Node_middle")
	self.nodeTop = SoraDGetChildByName(self.centerNode, "Node_top")
	self.labelTime1 = SoraDGetChildByName(self.centerNode, "Text_time_1")
	self.labelTitle1 = SoraDGetChildByName(self.centerNode, "Text_title_1")
	self.labelTitle2 = SoraDGetChildByName(self.centerNode, "Text_title_2")
	self.labelTitle3 = SoraDGetChildByName(self.centerNode, "Text_title_3")
	self.labelTitle4 = SoraDGetChildByName(self.centerNode, "Text_title_4")
	self.labelDes1 = SoraDGetChildByName(self.centerNode, "Text_des_1")
	self.nodeToday = SoraDGetChildByName(self.centerNode, "Node_today")
	self:initView()
end
function alliancePBLScheduleView:initView()
	_UPVALUE11_ = nil
	_UPVALUE12_, (nil)[1] = i18n("common_text_289"), i18n("common_text_289")
	_UPVALUE12_, (nil)[2] = i18n("common_text_289"), i18n("pyramid_btn_09")
	_UPVALUE12_, (nil)[3] = i18n("common_text_289"), i18n("pyramid_btn_10")
	_UPVALUE12_, (nil)[4] = i18n("common_text_289"), i18n("pyramid_btn_11")
	_UPVALUE12_, (nil)[5] = i18n("common_text_289"), i18n("pyramid_text_81")
	_UPVALUE12_, (nil)[6] = i18n("common_text_289"), i18n("pyramid_text_79")
	_UPVALUE12_, (nil)[7] = i18n("common_text_289"), i18n("pyramid_text_80")
	_UPVALUE12_, (nil)[8] = i18n("common_text_289"), i18n("pyramid_text_80")
	_UPVALUE12_, (nil)[9] = i18n("common_text_289"), i18n("pyramid_text_60")
	_UPVALUE12_, (nil)[10] = i18n("common_text_289"), i18n("pyramid_text_61")
	_UPVALUE12_, (nil)[11] = i18n("common_text_289"), i18n("pyramid_text_62")
	_UPVALUE12_, (nil)[12] = i18n("common_text_289"), i18n("pyramid_text_63")
	_UPVALUE12_, (nil)[13] = i18n("common_text_289"), i18n("pyramid_text_63")
	_UPVALUE12_, (nil)[14] = i18n("common_text_289"), i18n("pyramid_text_63")
	_UPVALUE12_, (nil)[15] = i18n("common_text_289"), i18n("pyramid_text_63")
	_UPVALUE12_, (nil)[16] = i18n("common_text_289"), i18n("pyramid_text_63")
	_UPVALUE12_, (nil)[17] = i18n("common_text_289"), i18n("pyramid_text_63")
	local _UPVALUE12_, (nil)[18], str = i18n("common_text_289"), i18n("pyramid_text_63")
	i18n("common_text_289")[1] = self.labelTitle1
	i18n("common_text_289")[2] = self.labelTitle2
	i18n("common_text_289")[3] = self.labelTitle3
	i18n("common_text_289")[4] = self.labelTitle4
	i18n("common_text_289")[5] = self.labelTitle5
	i18n("common_text_289")[6] = self.labelDes1
	i18n("common_text_289")[7] = self.labelDes2
	i18n("common_text_289")[8] = self.labelDes3
	i18n("common_text_289")[9] = self.labelDes4
	i18n("common_text_289")[10] = self.labelDes5
	i18n("common_text_289")[11] = self.labelDes6
	local i18n("common_text_289")[12], strnode = self.labelDes7, i18n("common_text_289")
	for i, v in ipairs(str) do
		strnode[i]:setString(v)
	end
	_UPVALUE7_ = (for generator)
	self.tableTime, _ENV, ipairs(str)[1] = "Sun", "Sun", "Sun"
	self.tableTime, _ENV, ipairs(str)[2] = "Sun", "Sun", "Mon"
	self.tableTime, _ENV, ipairs(str)[3] = "Sun", "Sun", "Tues"
	self.tableTime, _ENV, ipairs(str)[4] = "Sun", "Sun", "Wed"
	self.tableTime, _ENV, ipairs(str)[5] = "Sun", "Sun", "Thur"
	self.tableTime, _ENV, ipairs(str)[6] = "Sun", "Sun", "Fri"
	local self.tableTime, _ENV, ipairs(str)[7], wstr = "Sun", "Sun", "Sat", ipairs(str)
	self.starTime = pyramidWarCtrl.seasonStartTime
	self.starTime = self.starTime + 691200
	local theday = os.date("!*t", self.starTime)
	_ENV = "Wed"
	;("Wed").label = self.labelTime1
	;("Wed").value = self.starTime
	;("Wed").time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, "Wed")
	self.applyLegionNum = pyramidWarCtrl.applyLegionNum
	local count = 0
	if self.applyLegionNum == 512 then
		count = 4
	elseif self.applyLegionNum == 256 then
		count = 3
	elseif self.applyLegionNum == 128 then
		count = 2
	elseif self.applyLegionNum == 64 then
		count = 1
	end
	if 0 < count then
		for i = 1, count do
			local node = self.nodeClone:clone()
			node:addTo(self.nodeTop)
			node:setPosition(0, -88 * i)
			self.starTime = self.starTime + 604800
			theday = os.date("!*t", self.starTime)
			_ENV = self.starTime
			self.starTime.label = node:getChildByName("Text_time_1")
			self.starTime.value = self.starTime
			self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
			table.insert(self.tableTime, self.starTime)
			local starTime2 = self.starTime + 86400
			theday = os.date("!*t", starTime2)
			_ENV = starTime2
			starTime2.label = node:getChildByName("Text_time_2")
			starTime2.value = starTime2
			starTime2.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
			table.insert(self.tableTime, starTime2)
		end
	end
	self.starTime = self.starTime + 604800
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime11
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	self.starTime = self.starTime + 86400
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime12
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	self.starTime = self.starTime + 518400
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime13
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	self.starTime = self.starTime + 604800
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime14
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	self.starTime = self.starTime + 604800
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime15
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	self.starTime = self.starTime + 604800
	theday = os.date("!*t", self.starTime)
	_ENV = self.starTime
	self.starTime.label = self.labelTime16
	self.starTime.value = self.starTime
	self.starTime.time = string.format("%02d.%02d %s", theday.month, theday.day, wstr[theday.wday])
	table.insert(self.tableTime, self.starTime)
	local curTime = serviceFunctions.systemTime()
	local isOwn = false
	for i, v in ipairs(self.tableTime) do
		v.label:setString(v.time)
		if not isOwn and curTime < v.value then
			local posY = 44 * (#self.tableTime - (i - 1))
			if i - 1 <= #self.tableTime - 4 then
				posY = posY + 44
			end
			self.nodeToday:setPositionY(posY)
			isOwn = true
		end
	end
	self.nodeTop:setPositionY(89 + count * 88)
	self.nodeBg:setSize(cc.size(470, 459 + count * 88))
	self.centerNode:setPositionY(self.centerNode:getPositionY() + 0.5 * (4 - count) * 88)
end
return alliancePBLScheduleView
