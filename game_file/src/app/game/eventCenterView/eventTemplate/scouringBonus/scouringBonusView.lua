local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local equipDesRead = include("equipDesRead")
local scouringPropertyTable = require("app." .. LocalTblPath .. ".config_server.slim_sort_config")
local scouringRangeTable = require("app." .. LocalTblPath .. ".config_server.slim_range_config")
local scouringBonusView = class("scouringBonusView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("scouringBonusView")
	end
	return target
end)
function scouringBonusView:ctor()
	self:initControls()
	self:initData()
end
function scouringBonusView:initControls()
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function(...)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.iconHour = SoraDGetChildByName(self, "icon_hourglass_83")
	self.nodeCenter = SoraDGetChildByName(self, "nodeCenter")
	self.btnIns = SoraDGetChildByName(self, "btn_instruct")
	self.btnGo = SoraDGetChildByName(self, "btn_go")
	self.nodeAttr = SoraDGetChildByName(self, "node_attr")
	self.scroll = SoraDGetChildByName(self, "ScrollView_1")
	self.txtDetail = SoraDGetChildByName(self, "txtDetail")
	self.txtAttrValue = SoraDGetChildByName(self, "txtAttrValue")
	self.txtAttrGet = SoraDGetChildByName(self, "txtAttrGet")
	self.frameWord = SoraDGetChildByName(self, "bg_xljc_ysz_en_9")
	_UPVALUE3_ = "bg_xljc_ysz_en_9"
	;("bg_xljc_ysz_en_9")[1] = "ar"
	;("bg_xljc_ysz_en_9")[2] = "en"
	;("bg_xljc_ysz_en_9")[3] = "ko"
	local iconName = SoraDGetImageNameByLang("bg_xljc_ysz_%s.png", "bg_xljc_ysz_en_9")
	self.frameWord:setSpriteFrame(iconName)
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.txtDetail:setString(i18n("common_text_779"))
	SoraDDrawTextUnderLine(self.txtDetail, cc.c4b(0, 190, 30, 255))
	self.btnIns:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.buttonGoCallBack))
	self.nodeCenter:setPositionY(display.height / 2)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txtTime:setString(SoraDConvertSecondToString(leftTime))
		self.txtTime:beginTime(leftTime)
	end
	self.iconHour:setPositionX(self.txtTime:getPositionX() + SoraDFSign(self.txtTime:getContentSize().width / 2) + SoraDFSign(25))
end
function scouringBonusView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if data.activityID == gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY then
			self:initData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function scouringBonusView:initData()
	self.data = activityShowCtrl:getActivityData(gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY)
	if not self.data.param or not self.data.param.propertyList then
		activityShowCtrl = self.data.param.propertyList
	end
	self.propertyList = self.data.param.propertyList
	if not self.data.param or not self.data.param.rangeList then
		activityShowCtrl = self.data.param.rangeList
	end
	self.rangeList = self.data.param.rangeList
	local propertyName = ""
	local rangeName = ""
	dump(self.propertyList, "wlekrjwlekrje")
	dump(self.rangeList, "oooooooo")
	self.txtAttrValue:setVisible(table.nums(self.propertyList) > 0)
	self.txtAttrGet:setVisible(table.nums(self.rangeList) > 0)
	if table.nums(self.propertyList) > 0 and table.nums(self.rangeList) <= 0 then
		propertyName = i18n(self:getPropertyTypeByGroup(tonumber(self.propertyList[1])))
	elseif table.nums(self.propertyList) <= 0 and table.nums(self.rangeList) > 0 then
		rangeName = i18n(self:getRangeByQuality(tonumber(self.rangeList[1])))
	elseif table.nums(self.propertyList) > 0 and table.nums(self.rangeList) > 0 then
		propertyName = i18n(self:getPropertyTypeByGroup(tonumber(self.propertyList[1])))
		rangeName = i18n(self:getRangeByQuality(tonumber(self.rangeList[1])))
	end
	activityShowCtrl = self:getRangeByQuality(tonumber(self.rangeList[1]))
	self:getRangeByQuality(tonumber(self.rangeList[1])).num = rangeName
	self.txtAttrGet:setString(i18n("slim_text_02", self:getRangeByQuality(tonumber(self.rangeList[1]))))
	activityShowCtrl = i18n("slim_text_02", self:getRangeByQuality(tonumber(self.rangeList[1])))
	i18n("slim_text_02", self:getRangeByQuality(tonumber(self.rangeList[1]))).type = propertyName
	self.txtAttrValue:setString(i18n("slim_text_01", i18n("slim_text_02", self:getRangeByQuality(tonumber(self.rangeList[1])))))
	self:initScroll()
end
function scouringBonusView:initScroll()
	self.scroll:removeAllChildren()
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width + 200, self.scroll:getContentSize().height))
	local tempList = self:getPropertyListByGroup(tonumber(self.propertyList[1]))
	local scrollH = math.max(#tempList * 35, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	dump(tempList, "wjkefjjwelkjflw")
	for i, v in ipairs(tempList) do
		local cell = self.nodeAttr:clone()
		if SoraDFIsRA() then
			cell:setPosition(cc.p(425, scrollH - (i - 1) * 35 - 20))
		else
			cell:setPosition(cc.p(25, scrollH - (i - 1) * 35 - 20))
		end
		cell:addTo(self.scroll)
		local cellName = SoraDGetChildByName(cell, "text_attr")
		if v[1] == 79 then
			SoraDSetTextWidthHeight(cellName, cc.size(400, 60))
			cellName:setString(equipDesRead.getAttrName(v[1]) .. i18n("slim_text_08"))
		else
			cellName:setString(equipDesRead.getAttrName(v[1]))
		end
		local txtRank = SoraDGetChildByName(cell, "txtRank")
		txtRank:setString(i)
	end
end
function scouringBonusView:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local comStr = ""
		local rangeKey = ""
		local propertyKey = ""
		if next(self.propertyList) then
			propertyKey = i18n(self:getPropertyTypeByGroup(tonumber(self.propertyList[1])))
		end
		if next(self.rangeList) then
			rangeKey = i18n(self:getRangeByQuality(tonumber(self.rangeList[1])))
		end
		if not next(self.propertyList) and not next(self.rangeList) then
			return
		elseif next(self.propertyList) and next(self.rangeList) then
			_ENV = self:getRangeByQuality(tonumber(self.rangeList[1]))
			self:getRangeByQuality(tonumber(self.rangeList[1])).type = propertyKey
			self:getRangeByQuality(tonumber(self.rangeList[1])).num = rangeKey
			comStr = i18n("slim_text_03", self:getRangeByQuality(tonumber(self.rangeList[1])))
		elseif not next(self.propertyList) and next(self.rangeList) then
			_ENV = self:getRangeByQuality(tonumber(self.rangeList[1]))
			self:getRangeByQuality(tonumber(self.rangeList[1])).num = rangeKey
			comStr = i18n("slim_text_02", self:getRangeByQuality(tonumber(self.rangeList[1])))
		elseif next(self.propertyList) and not next(self.rangeList) then
			_ENV = self:getRangeByQuality(tonumber(self.rangeList[1]))
			self:getRangeByQuality(tonumber(self.rangeList[1])).type = propertyKey
			comStr = i18n("slim_text_01", self:getRangeByQuality(tonumber(self.rangeList[1])))
		end
		_ENV = self:getRangeByQuality(tonumber(self.rangeList[1]))
		self:getRangeByQuality(tonumber(self.rangeList[1])).float = SoraDFLabelR()
		SoraDShowHelpMsgTip(comStr, self:getRangeByQuality(tonumber(self.rangeList[1])))
	end
end
function scouringBonusView:buttonGoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).operateType = gEquipOperateType.BAPTIZE
		uiManager:show("equipMenuView", nil)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function scouringBonusView:getPropertyListByGroup(group)
	local _ENV, propertyList
	for k, v in pairs(scouringPropertyTable) do
		if group == v.group then
			table.insert(propertyList, v.propertyType)
		end
	end
	return propertyList
end
function scouringBonusView:getPropertyTypeByGroup(group)
	local typeName = ""
	for k, v in pairs(scouringPropertyTable) do
		if group == v.group then
			typeName = v.name
			break
		end
	end
	return typeName
end
function scouringBonusView:getRangeByQuality(quality)
	local rangeName = ""
	for k, v in pairs(scouringRangeTable) do
		if quality == v.quality then
			rangeName = v.name
		end
	end
	return rangeName
end
function scouringBonusView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return scouringBonusView
