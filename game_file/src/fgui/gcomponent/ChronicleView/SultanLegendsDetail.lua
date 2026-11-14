local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local mailFunctions = include("mailFunctions")
local militaryRankRead = include("militaryRankRead")
local hegemonRead = include("hegemonRead")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local SultanLegendsDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/SultanLegendsDetail", SultanLegendsDetail)
function SultanLegendsDetail:onInit()
	self.pageType = legendMDesRead.PageType.KINGDETAIL
	self.pageTitle = i18n("history_text_34")
	self.txtTimeEdit = self.fields.Button_Edit:getChild("txt_Time")
	self.fields.Button_Edit:addClickListener(handler(self, self.onClick_btnEdit))
end
function SultanLegendsDetail:onShow()
end
function SultanLegendsDetail:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_SET_BIOGRAPHY_BACK", handler(self, self.sMsgSetDesBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_DES_NOTIFY_SUCCESS", handler(self, self.msgKingdomDesNotifySuccess))
end
function SultanLegendsDetail:initData(data)
	self.data = data
	self.serverData = self.data.data
	self.fields.Com_Detail:jumpToTop()
	self.fields.Com_Detail:initData(self.serverData)
	self:updateBtnEdit()
end
function SultanLegendsDetail:updateBtnEdit()
	local chatFunctions = include("chatFunctions")
	local selfId = chatFunctions:getSelfId()
	local isSelf = selfId == self.serverData.uid
	if isSelf then
		self.fields.Button_Edit:setVisible(true)
		self:updateBtnState()
	else
		self.fields.Button_Edit:setVisible(false)
	end
end
function SultanLegendsDetail:updateBtnState()
	print("SultanLegendsDetail:updateBtnState()")
	dump(self.serverData, "self.serverData", 10)
	self.txtTimeEdit:setVisible(false)
	local content = self.serverData.content
	if type(content) == "table" then
		local status = content.status
		if status == gKingBiographyStatus.STATUS_NONE then
			local strTimeLeft, timeLeft = self:getLeftEditTime()
			if 0 < timeLeft then
				print("1111111,timeLeft = ", timeLeft)
				self.txtTimeEdit:setVisible(true)
				self.txtTimeEdit:setString(strTimeLeft)
				self.fields.Button_Edit:setBright(false)
				self:beginTime()
			else
				print("222222")
				self.fields.Button_Edit:setBright(true)
			end
			self.fields.Button_Edit:setString(i18n("common_text_244"))
		elseif status == gKingBiographyStatus.STATUS_WATING then
			self.fields.Button_Edit:setString(i18n("history_text_56"))
			self.fields.Button_Edit:setBright(false)
			print("33333")
		elseif status == gKingBiographyStatus.STATUS_FAILED then
			self.fields.Button_Edit:setString(i18n("common_text_244"))
			self.fields.Button_Edit:setBright(true)
			print("44444")
		else
			self.fields.Button_Edit:setString(i18n("common_text_244"))
			self.fields.Button_Edit:setBright(true)
		end
	else
		self.fields.Button_Edit:setBright(true)
	end
end
function SultanLegendsDetail:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	self:updateTime()
end
function SultanLegendsDetail:updateTime()
	local timeLeft, tTick = self:getLeftEditTime()
	self.txtTimeEdit:setString(timeLeft)
	if tTick == 0 then
		self:endTime()
	end
end
function SultanLegendsDetail:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.timeHandler = nil
	self.txtTimeEdit:setVisible(false)
end
function SultanLegendsDetail:getLeftEditTime()
	local content = self.serverData.content
	if not content.finishTime then
		return 0, 0
	end
	local timeLeft = content.finishTime - serviceFunctions.systemTime()
	return SoraDConvertSecondToString(timeLeft), timeLeft
end
function SultanLegendsDetail:setPageType(pageType)
	self.pageType = pageType
end
function SultanLegendsDetail:getTitle()
	return self.pageTitle
end
function SultanLegendsDetail:onClick_btnEdit()
	SoraDPlaySound()
	local content = self.serverData.content
	if type(content) == "table" then
		local status = content.status
		print("status = ", status)
		if status == gKingBiographyStatus.STATUS_NONE then
			local strTimeLeft, timeLeft = self:getLeftEditTime()
			if 0 < timeLeft then
				SoraDShowMsgTip(i18n("history_text_41"))
				return
			end
		elseif status == gKingBiographyStatus.STATUS_WATING then
			SoraDShowMsgTip(i18n("history_text_10"))
			return
		elseif status == gKingBiographyStatus.STATUS_FAILED then
		end
	end
	_ENV = i18n("history_text_10")
	i18n("history_text_10").pageType = self.pageType
	i18n("history_text_10").serverData = self.serverData
	uiManager:show("LegendMPopEditKingDes", i18n("history_text_10"))
end
function SultanLegendsDetail:sMsgSetDesBack(target, data)
	dump(data, "SultanLegendsDetail:sMsgSetDesBack", 10)
	local content = data.content
	SoraDCloseLoading()
	if content and content.setType == self.serverData.setType and content.kid == self.serverData.kid then
		local isvalid = false
		if self.serverData.setType == gKingBiographyType.king then
			isvalid = true
		elseif content.round == self.serverData.round then
			isvalid = true
		end
		if isvalid then
			self.serverData.content = content
			self:updateBtnEdit()
		end
	else
		print("没找到数据-----------")
		dump(self.serverData, "self.serverData", 10)
	end
end
function SultanLegendsDetail:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading()
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function SultanLegendsDetail:msgKingdomDesNotifySuccess(target, data)
	print("SultanLegendsDetail:msgKingdomDesNotifySuccess(target, data)------")
	if data.uid == self.serverData.uid then
		self.fields.Com_Detail:initData(self.serverData)
		self:updateBtnEdit()
	end
end
return SultanLegendsDetail
