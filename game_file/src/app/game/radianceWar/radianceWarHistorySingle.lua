local radianceWarHistorySingle = class("radianceWarHistorySingle", function(target)
	return target
end)
function radianceWarHistorySingle:ctor()
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.textDate = SoraDGetChildByName(self, "Text_date")
	self.textKindomInfo = SoraDGetChildByName(self, "Text_KindomInfo")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDChangeTextToHtml(self.textTime)
	self.spFlagSuc = SoraDGetChildByName(self, "Sprite_flag_suc")
	self.spFlagFail = SoraDGetChildByName(self, "Sprite_flag_fail")
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
end
function radianceWarHistorySingle:onMessageListener()
end
function radianceWarHistorySingle:initData(data, otherData)
	dump(data, "historyInfoList", 10)
	if otherData then
		self.ownScroll = otherData.scroll
	end
	self.data = data
	local timeStr = os.date("!%Y/%m/%d", data.time)
	self.textDate:setString(timeStr)
	local myInfo = self:getKinNameAndTime()
	self.textKindomInfo:setString(myInfo.kingdomName)
	_ENV = nil
	_ENV, _ENV, (nil).time = myInfo.occupyTime, SoraDConvertSecondToString(myInfo.occupyTime), SoraDConvertSecondToString(myInfo.occupyTime)
	_ENV, SoraDConvertSecondToString(myInfo.occupyTime).time, myInfo.occupyTime.color = myInfo.occupyTime, myInfo.occupyTime, "#FFFE96"
	SoraDConvertSecondToString(myInfo.occupyTime)._default, myInfo.occupyTime.color = myInfo.occupyTime, "#D3D1CC"
	self.textTime:setString(i18n_html("brightWar_text_36", nil, (SoraDConvertSecondToString(myInfo.occupyTime))))
	local isWin = myInfo.isWin
	self.spFlagSuc:setVisible(isWin)
	self.spFlagFail:setVisible(not isWin)
	if isWin then
		SoraChangeSpriteImage(self.Image_bg, "frame_yjzz_newbg_06.png")
	else
		SoraChangeSpriteImage(self.Image_bg, "frame_yjzz_newbg_05.png")
	end
end
function radianceWarHistorySingle:getKinNameAndTime()
	local gametop = gModuleMgr.getObject("gametop")
	local currentKid = gametop.playertop_:getKingdomID()
	for i, v in ipairs(self.data.settleData) do
		if v.kid == currentKid then
			return v
		end
	end
end
function radianceWarHistorySingle:btnRecordClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.ownScroll and not SoraDIsNodeVisibleOnScroll(target, self.ownScroll, eventType) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("radianceWarHistoryDetailView")
		panel:initData(self.data)
		panel:show()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarHistorySingle
