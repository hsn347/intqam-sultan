local divineBeastMarkRead = include("divineBeastMarkRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatMarkBuffPopPanel = class("CheatMarkBuffPopPanel", baseFguiPanel)
function CheatMarkBuffPopPanel:ctor(...)
	self.isLRU = true
	CheatMarkBuffPopPanel.super.ctor(self, ...)
	print("CheatMarkBuffPopPanel:ctor", self.viewName)
end
function CheatMarkBuffPopPanel:onInit()
	print("=======CheatMarkBuffPopPanel:onInit")
	self.fields.Text_elem:setString("元素")
	self.fields.Text_buff1:setString("随机属性1")
	self.fields.Text_buff2:setString("随机属性2")
	self.fields.Text_lv:setString("等级")
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnClick))
	self.input = self.fields.input:getChild("input")
	self.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
end
function CheatMarkBuffPopPanel:onSubmit()
	local lv = tonumber(self.input:getText())
	self.lv = lv or self.lv
	if self.maxLv then
		self.lv = math.min(self.lv, self.maxLv)
	end
	self:updateShow()
end
function CheatMarkBuffPopPanel:onComboBoxElemClick()
	SoraDPlaySound()
	self.elem = self.fields.ComboBox_elem:getValue()
end
function CheatMarkBuffPopPanel:onComboBoxClick(index)
	SoraDPlaySound()
	self["buff" .. index] = self.fields["ComboBox_" .. index]:getValue()
end
function CheatMarkBuffPopPanel:endShow()
	print("=======CheatMarkBuffPopPanel:endShow")
	self.index = self.param.index
	self.divineID = self.param.divineID
	self.markID = self.param.markID
	self.mark = self.param.mark
	self.markRandomBuffType = divineBeastMarkRead.getMarkRandomBuffType(self.markID)
	self.quality = divineBeastMarkRead.getQuality(self.markID)
	self.elem = self.mark.randomElem or 0
	self.lv = self.mark.level
	self.maxLv = nil
	self.fields.Panel_bg:setString(self.markID .. " " .. divineBeastMarkRead.getName(self.markID))
	local elems = divineBeastMarkRead.getElements()
	divineBeastMarkRead = self.fields.Panel_bg
	local divineBeastMarkRead, self.fields.Panel_bg[1], elem_items = "无", "无", self.fields.Panel_bg
	local ("无")[1], elem_values = 0, "无"
	for k, v in ipairs(elems) do
		if v.type == 1 then
			table.insert(elem_items, i18n(v.name))
			table.insert(elem_values, v.index)
		end
	end
	_ENV = nil
	;(nil).items = elem_items
	;(nil).values = elem_values
	;(nil).changedCallback = handler(self, self.onComboBoxElemClick)
	self:setComboBox(self.fields.ComboBox_elem, nil)
	self.fields.ComboBox_elem:setSelectedIndex(self.elem)
	self.buffCfg = divineBeastMarkRead.getRandomBuffList()
	self:updateShow()
end
function CheatMarkBuffPopPanel:updateShow()
	local _ENV, buffList
	local _ENV, buff_items
	local _ENV, buff_values
	for buffID, cfg in pairs(self.buffCfg) do
		for quality, v in pairs(cfg) do
			if not self.lv then
				self.lv = v.maxLv
			end
			if not self.maxLv then
				self.maxLv = v.maxLv
			end
			if quality == self.quality then
				local effectType = buffDesRead.getEffectType(buffID)
				local numStr = v[self.lv][self.markRandomBuffType]
				if effectType == 1 then
					numStr = numStr / 100 .. "%"
				else
					numStr = numStr / 10
				end
				_ENV = nil
				;(nil).id = buffID
				;(nil).value = v[self.lv][self.markRandomBuffType]
				_ENV = nil
				;(nil).num = numStr
				;(nil).name = i18n(v.name, nil)
				table.insert(buffList, nil)
			end
		end
	end
	self.input:setText(self.lv)
	table.sort(buffList, function(a, b)
		return a.id < b.id
	end)
	for k, v in ipairs(buffList) do
		table.insert(buff_items, v.name)
		table.insert(buff_values, v.id)
	end
	self.buff1 = self.mark.randomBuffs[1] and self.mark.randomBuffs[1] ~= 0 and self.mark.randomBuffs[1] or buff_values[1]
	self.buff2 = self.mark.randomBuffs[2] and self.mark.randomBuffs[2] ~= 0 and self.mark.randomBuffs[2] or buff_values[1]
	for i = 1, 2 do
		_ENV = "ComboBox_" .. i
		;("ComboBox_" .. i).items = buff_items
		;("ComboBox_" .. i).values = buff_values
		;("ComboBox_" .. i).changedCallback = handlerEx(self, self.onComboBoxClick, i)
		self:setComboBox(self.fields["ComboBox_" .. i], "ComboBox_" .. i)
	end
	local toIndex1 = table.indexof(buff_values, self.buff1) and table.indexof(buff_values, self.buff1) - 1 or 0
	local toIndex2 = table.indexof(buff_values, self.buff2) and table.indexof(buff_values, self.buff2) - 1 or 0
	self.fields.ComboBox_1:setSelectedIndex(toIndex1)
	self.fields.ComboBox_2:setSelectedIndex(toIndex2)
end
function CheatMarkBuffPopPanel:btnClick()
	SoraDPlaySound()
	print("选择参数======", self.elem, self.buff1, self.buff2)
	if self.buff1 ~= 0 and self.buff2 ~= 0 and self.buff1 == self.buff2 then
		SoraDShowMsgTip("随机属性buff不能一样!!")
		return
	end
	_ENV = "随机属性buff不能一样!!"
	;("随机属性buff不能一样!!").msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_MARK"
	;("随机属性buff不能一样!!").divineID = self.divineID
	;("随机属性buff不能一样!!").index = self.index
	_ENV, ("随机属性buff不能一样!!").markID = self.markID, self.markID
	self.markID.elem = self.elem
	self.markID.buff1 = self.buff1
	self.markID.buff2 = self.buff2
	self.markID.quality = self.quality
	;("随机属性buff不能一样!!").cfg, self.markID.lv = self.markID, self.lv
	SoraDSendMessage("随机属性buff不能一样!!")
	self:close()
end
return CheatMarkBuffPopPanel
