local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local baseComponent = require("fgui.base.baseComponent")
local Com_feastSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001625/Com_feastSingle", Com_feastSingle)
function Com_feastSingle:onInit()
	self.fields.Text_state1:setString(i18n("gathering_activity_text4"))
	self.fields.Text_state2:setString(i18n("common_text_4120"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_place:addClickListener(handler(self, self.onClickBtnPlace))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(timeStr)
		return i18n("gathering_activity_text5") .. "\n" .. timeStr
	end)
	self.fields.Text_time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001625_UPDATE"
		;(nil).subMsg = "updateFeast"
		SoraDSendMessage(nil)
	end)
end
function Com_feastSingle:onShow()
end
function Com_feastSingle:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function Com_feastSingle:onClickBtnPlace(...)
	SoraDPlaySound()
	if self.feast then
		local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(self.feast.x, self.feast.y))
		SoraDGotoWorldMapPoint(clientPos, true)
		SoraDRemoveAllPanelFromManager()
		return
	end
	if not activity_9001625_Ctrl:checkCanPlaceFeast() then
		return
	end
	_ENV = clientPos
	clientPos.level = self.feastId
	local msgStr = i18n("gathering_activity_text16", clientPos)
	SoraDShowMsgBox(msgStr, i18n("common_text_2132"), i18n("common_text_185"), function(eventType)
		if MSGBOX_CALLBACK_YES == eventType then
			if not activity_9001625_Ctrl:checkCanPlaceFeast() then
				return
			end
			_ENV = activity_9001625_Ctrl:checkCanPlaceFeast()
			local activity_9001625_Ctrl:checkCanPlaceFeast().feastLv, layInstanceData = self.feastId, activity_9001625_Ctrl:checkCanPlaceFeast()
			SoraDGotoWorldMapPoint(nil, nil, nil, worldMapLayInstanceTypeDef.layInstanceFeast, layInstanceData)
			SoraDRemoveAllPanelFromManager()
		end
	end)
end
function Com_feastSingle:initData(data)
	self.feastId = data.feastId
	self.feast = data.feast
	self.cfg = data.cfg
	self.point = data.point
	self.placeIndex = data.placeIndex
	if self.placeIndex then
		if self.placeIndex == self.feastId then
			self:setIsPlace(true)
		else
			self:setIsPlace(false)
		end
	else
		local c_state = self.controllers.c_state
		local point = self.cfg.point
		if self.feast then
			c_state:setSelectedIndex(1)
		elseif point > self.point then
			c_state:setSelectedIndex(2)
		else
			c_state:setSelectedIndex(0)
			self.fields.Button_place:setString(i18n("btn_place_feast"))
		end
	end
	_ENV = i18n("btn_place_feast")
	i18n("btn_place_feast").var1 = self.feastId
	self.fields.Text_lv:setString(i18n("activity_feastLv_name", i18n("btn_place_feast")))
	local point = self.cfg.point
	_ENV = i18n("activity_feastLv_name", i18n("btn_place_feast"))
	i18n("activity_feastLv_name", i18n("btn_place_feast")).point = string.formatnumberthousands(point)
	self.fields.Text_point:setString(i18n("gathering_activity_text10", i18n("activity_feastLv_name", i18n("btn_place_feast"))))
	_UPVALUE2_ = i18n("gathering_activity_text10", i18n("activity_feastLv_name", i18n("btn_place_feast")))
	i18n("gathering_activity_text10", i18n("activity_feastLv_name", i18n("btn_place_feast")))[1] = "id"
	i18n("gathering_activity_text10", i18n("activity_feastLv_name", i18n("btn_place_feast")))[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.cfg.reward, i18n("gathering_activity_text10", i18n("activity_feastLv_name", i18n("btn_place_feast"))))
	self.fields.List:setNumItems(#self.rewards)
end
function Com_feastSingle:setIsPlace(isPlace)
	self.controllers.c_black:setSelectedIndex(isPlace and 0 or 1)
	if isPlace then
		self.controllers.c_state:setSelectedIndex(0)
		local remainTime = activity_9001625_Ctrl:getRemainTime(self.feast)
		self.fields.Text_time:beginTime(remainTime)
		local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(self.feast.x, self.feast.y))
		activity_9001625_Ctrl = cc.p(self.feast.x, self.feast.y)
		cc.p(self.feast.x, self.feast.y).x = clientPos.x
		cc.p(self.feast.x, self.feast.y).y = clientPos.y
		local posStr = i18n("common_text_2155", cc.p(self.feast.x, self.feast.y))
		self.fields.Button_place:setString(i18n("NewYear_Gift_02") .. "\n" .. posStr)
		self.fields.Usm_1:setVisible(true)
	else
		self.fields.Usm_1:setVisible(false)
	end
end
return Com_feastSingle
