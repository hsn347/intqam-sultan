local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_TipPanel = class("Activity_9001680_TipPanel", baseFguiPanel)
local activity_9001680_Read = include("activity_9001680_Read")
local MAP_OBJ_TYPE = activity_9001680_Read.MAP_OBJ_TYPE
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local publicRead = include("publicRead")
function Activity_9001680_TipPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_TipPanel.super.ctor(self, ...)
	print("Activity_9001680_TipPanel:ctor", self.viewName)
end
function Activity_9001680_TipPanel:onInit()
	print("=======Activity_9001680_TipPanel:onInit")
	self.view:fixChildrenPos()
	self.itemID = 1698
	self.fields.Button_confirm:setTitle(i18n("common_text_204"))
	self.fields.Button_cancel:setTitle(i18n("common_text_185"))
	self.fields.Button_cancel2:setTitle(i18n("common_text_185"))
	self.fields.Button_cost1:setTitle(i18n("minecraft_text_29"))
	self.fields.Button_boom:setTitle(i18n("minecraft_text_25"))
	self.fields.Button_pick:setTitle(i18n("minecraft_text_24"))
	self.fields.Button_confirm:addClickEventListener(handler(self, self.onClickClose))
	self.fields.Button_cancel:addClickEventListener(handler(self, self.onClickClose))
	self.fields.Button_cancel2:addClickEventListener(handler(self, self.onClickClose))
	self.fields.Button_cost1:addClickEventListener(handler(self, self.onClickBoomRock))
	self.fields.Button_boom:addClickEventListener(handler(self, self.onClickBoomGem))
	self.fields.Button_pick:addClickEventListener(handler(self, self.onClickPickGem))
end
function Activity_9001680_TipPanel:endShow()
	print("=======Activity_9001680_TipPanel:endShow")
	self.fields.Text_content:setString("")
	self:updateView()
end
function Activity_9001680_TipPanel:updateView()
	self.cellX = self.param.x
	self.cellY = self.param.y
	self.objCfg = self.param.objCfg
	self.objType = self.objCfg and self.objCfg.type or self.param.objType
	if self.objType == MAP_OBJ_TYPE.ROCK then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.title:setString(i18n("minecraft_text_27"))
		MAP_OBJ_TYPE = i18n("minecraft_text_27")
		i18n("minecraft_text_27").num = self.objCfg.explosives[2]
		self.fields.Text_content:setString(i18n("minecraft_text_28", i18n("minecraft_text_27")))
		self.fields.Button_cost1:setCost(self.objCfg.explosives[1], self.objCfg.explosives[2])
	elseif self.objType == MAP_OBJ_TYPE.TREASURE_CLEW then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.title:setString(i18n("minecraft_text_30"))
		local pos = activity_9001680_Ctrl:getTreasurePos()
		MAP_OBJ_TYPE = [[

(X:%d Y:%d)]]
		;([[

(X:%d Y:%d)]]).color = "#70C723"
		local posStr = SoraDWrapHtmlTagByStyle(string.format([[

(X:%d Y:%d)]], pos[1], pos[2]), [[

(X:%d Y:%d)]])
		local str = i18n("minecraft_text_31") .. posStr
		self.fields.Text_content:setString(str)
	elseif self.objType == MAP_OBJ_TYPE.GEM then
		local pickingTime = activity_9001680_Ctrl:getPickingTime(self.cellX, self.cellY)
		if pickingTime ~= nil then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.title:setString(i18n(self.objCfg.window_name))
			MAP_OBJ_TYPE = i18n(self.objCfg.window_name)
			i18n(self.objCfg.window_name).num = self.objCfg.explosives[2]
			self.fields.Text_content:setString(i18n("minecraft_text_26", i18n(self.objCfg.window_name)))
			self.fields.Button_cost1:setCost(self.objCfg.explosives[1], self.objCfg.explosives[2])
		else
			self.controllers.c1:setSelectedIndex(2)
			self.fields.title:setString(i18n(self.objCfg.window_name))
			local costTime = SoraDConvertSecondToString(self.objCfg.dig_time)
			MAP_OBJ_TYPE = i18n(self.objCfg.window_name)
			i18n(self.objCfg.window_name).time = costTime
			i18n(self.objCfg.window_name).num = self.objCfg.explosives[2]
			self.fields.Text_content:setString(i18n(self.objCfg.window_text, i18n(self.objCfg.window_name)))
			self.fields.Button_boom:setCost(self.objCfg.explosives[1], self.objCfg.explosives[2])
			self.fields.timeLabel:setTitle(costTime)
		end
	end
end
function Activity_9001680_TipPanel:onClickClose()
	self:close()
end
function Activity_9001680_TipPanel:onClickBoomRock(sender)
	SoraDPlaySound()
	print("onClickBoomRock")
	if sender:checkItem(true) then
		activity_9001680_Ctrl:reqGoldMinerPick(self.objCfg.index, self.cellX, self.cellY, true)
		self:close()
	end
end
function Activity_9001680_TipPanel:onClickBoomGem(sender)
	SoraDPlaySound()
	print("onClickBoomGem")
	if sender:checkItem(true) then
		activity_9001680_Ctrl:reqGoldMinerPick(self.objCfg.index, self.cellX, self.cellY, true)
		self:close()
	end
end
function Activity_9001680_TipPanel:onClickPickGem(sender)
	SoraDPlaySound()
	self.monsterCountInClick = activity_9001680_Ctrl:getMonsterCount()
	local needPickNum = self.objCfg.minepick
	if needPickNum == 1 then
		needPickNum = self.objCfg.minepick * (self.monsterCountInClick + 1)
		if needPickNum > activity_9001680_Ctrl:getItemCount() then
			_ENV = nil
			;(nil).item = publicRead.getName(self.itemID)
			SoraDShowMsgTip(i18n("Glory_text_19", nil))
			return
		end
	end
	if self.objCfg.type == MAP_OBJ_TYPE.GEM and activity_9001680_Ctrl:getIsPicking() then
		local pickingTime = activity_9001680_Ctrl:getPickingTime(self.cellX, self.cellY)
		if pickingTime == nil then
			SoraDShowMsgTip(i18n("minecraft_text_43"))
			return
		end
	end
	activity_9001680_Ctrl:reqGoldMinerPick(self.objCfg.index, self.cellX, self.cellY, false)
	self:close()
end
return Activity_9001680_TipPanel
