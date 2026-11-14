local remainsWarRead = include("remainsWarRead")
local itemDesRead = include("itemDesRead")
local remainsWarCtrl = SoraDGetCtrl("remainsWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_buffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_buffSingle", Com_buffSingle)
function Com_buffSingle:onInit()
	self.fields.Button_op:setString(i18n("common_text_246"))
	self.fields.Button_op:addClickListener(handler(self, self.btnOpClick))
	self.fields.touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
	self.fields.Bar:setScale(SoraDFIsRA() and -1 or 1)
end
function Com_buffSingle:onItemRenderer(index, obj)
	obj:initData(self.dataList[index + 1])
end
function Com_buffSingle:onShow()
end
function Com_buffSingle:initData(data, index)
	self.index = index
	self.data = data.data
	self.isOpen = data.isOpen or false
	self.dataList = self.data.data
	local buffData = self.data.showData
	self.buffData = buffData
	self.tableBuff = remainsWarRead.getBuffShowData(buffData)
	self.fields.buff:getChildByName("icon"):setSpriteFrame(self.tableBuff.icon)
	self.fields.buff:getChildByName("bg"):setSpriteFrame(itemDesRead.getBgByLv(self.tableBuff.quaitly))
	if buffData then
		self:initRemainsWarBuff(buffData)
	end
	self.fields.Text_name:setString(self.tableBuff.buffname)
	self.fields.Text_des:setString(self.tableBuff.bufdes)
	if (buffData.effect == _G.gBuffEffect.RUINS_WAR_SEND_ROME or buffData.effect == _G.gBuffEffect.RUINS_WAR_LOCK_PLAYER_MOVE_CITY or buffData.effect == _G.gBuffEffect.RUINS_WAR_LOCK_PLAYER_SPEED_QUEUE) and buffData.value > 0 then
		self.controllers.c1:setSelectedIndex(0)
		local enable = worldMapDefine.isInRemains()
		self.fields.Button_op:setEnabled(enable)
		remainsWarRead = itemDesRead.getBgByLv(self.tableBuff.quaitly)
		itemDesRead.getBgByLv(self.tableBuff.quaitly).count = buffData.value
		self.fields.Text_time_num:setString(i18n("common_text_1673", itemDesRead.getBgByLv(self.tableBuff.quaitly)))
		self.fields.List:setPositionY(0)
		self.fields.List:setNumItems(0)
		self.fields.List:setHeight(0)
		self.fields.bgx:setHeight(0)
		self:setHeight(152)
	else
		self.controllers.c1:setSelectedIndex(1)
		remainsWarRead = i18n("common_text_1673", itemDesRead.getBgByLv(self.tableBuff.quaitly))
		i18n("common_text_1673", itemDesRead.getBgByLv(self.tableBuff.quaitly)).amount = #self.data.data
		self.fields.Text_time_num:setString(i18n("remains_text_344", i18n("common_text_1673", itemDesRead.getBgByLv(self.tableBuff.quaitly))))
		if self.isOpen then
			self.fields.arrow:setRotation(0)
			self.fields.List:setPositionY(155)
			self.fields.List:setNumItems(#self.dataList)
			local line = math.ceil(#self.dataList / 2)
			local listH = line * 50 + (line - 1) * 10
			self.fields.List:setHeight(listH)
			self.fields.bgx:setHeight(listH + 22)
			self:setHeight(152 + listH + 17)
		else
			self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
			self.fields.List:setPositionY(0)
			self.fields.List:setNumItems(0)
			self.fields.List:setHeight(0)
			self.fields.bgx:setHeight(0)
			self:setHeight(152)
		end
	end
end
function Com_buffSingle:initRemainsWarBuff(buffData)
	self.timerNumber = 0
	self.timerTotal = 1
	local getTimeNodeTicket
	if buffData and buffData.endTime then
		local timeRemains = buffData.endTime - serviceFunctions.systemTime()
		if timeRemains < 0 then
			timeRemains = 0
		end
		if buffData.beginTime then
			local timeTotal = buffData.endTime - buffData.beginTime
			if timeTotal <= 0 then
				timeTotal = 1
			end
			self.timerTotal = timeTotal
		end
		self.timerNumber = timeRemains
	end
	local value = buffData.value
	self.fields.Text_int:setVisible(true)
	if buffData.effect == gBuffEffect.RUINS_WAR_OCCUPY_DOUBLE_POINTS or buffData.effect == gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED or buffData.effect == gBuffEffect.RUINS_WAR_SPEED_QUEUE_LOCKED then
		self.fields.Text_int:setVisible(false)
	elseif "boolean" == type(value) or buffData.effect == gBuffEffect.RUINS_WAR_SEND_ROME or buffData.effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_MOVE_CITY or buffData.effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_SPEED_QUEUE then
		self.fields.Text_int:setString(i18n("common_text_246"))
	elseif "number" == type(value) then
		local val = ""
		if buffData.effect == gBuffEffect.TROOP_ATTACK_REDUCE or buffData.effect == gBuffEffect.TROOP_DEFENSE_REDUCE then
			val = "-" .. value / 10 .. "%"
		else
			_ENV = "%"
			;("%").title = ""
			;("%").value = value / 10
			val = i18n("common_text_1298", "%")
		end
		_ENV = i18n("common_text_246")
		i18n("common_text_246").val = val
		self.fields.Text_int:setString(i18n("common_text_2837", i18n("common_text_246")))
	end
	self.fields.Text_time:setTimeLast(function(str, tick)
		self.fields.Bar:setValue(tick)
		self = tick
		tick.time = str
		return i18n("common_text_421", tick)
	end)
	self.fields.Text_time:setTimeEndListener(function(...)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_REMAINS_WAR_BUFF_REFRESH"
		SoraDSendMessage(nil)
	end)
	if self.timerNumber > 0 then
		self.fields.Bar:setMax(self.timerTotal)
		self.fields.Text_time:beginTime(self.timerNumber)
	end
end
function Com_buffSingle:btnOpClick()
	SoraDPlaySound()
	if self.buffData.effect == _G.gBuffEffect.RUINS_WAR_SEND_ROME then
		local gametop = gModuleMgr.getObject("gametop")
		local mapId = gametop.playertop_:getMapID()
		remainsWarCtrl:reqRemainsWarRomeAttack(mapId)
	elseif self.buffData.effect == _G.gBuffEffect.RUINS_WAR_LOCK_PLAYER_MOVE_CITY or self.buffData.effect == _G.gBuffEffect.RUINS_WAR_LOCK_PLAYER_SPEED_QUEUE then
		local panel = SoraDCreatePanel("remainsWarBuffUse")
		panel:initData(self.buffData)
		panel:show()
	end
end
function Com_buffSingle:btnTouchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_REMAINS_UI_OPEN"
	;(nil).index = self.index
	;(nil).isOpen = not self.isOpen
	SoraDSendMessage(nil)
end
return Com_buffSingle
