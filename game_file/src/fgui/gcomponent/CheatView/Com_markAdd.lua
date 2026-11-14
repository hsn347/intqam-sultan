local divineBeastMarkRead = include("divineBeastMarkRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_markAdd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_markAdd", Com_markAdd)
function Com_markAdd:onInit()
	self.markID = nil
	self.fields.Text_none:setString("空")
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Button_delete:addClickListener(handler(self, self.btnDeleteClick))
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
end
function Com_markAdd:onShow()
end
function Com_markAdd:initData(index, divineID, editData)
	self.index = index
	self.divineID = divineID
	self.fields.Text_index:setString("印记" .. index)
	if editData.beast[tostring(divineID)] and editData.beast[tostring(divineID)][index] and editData.beast[tostring(divineID)][index] ~= 0 then
		self.controllers.c1:setSelectedIndex(1)
		local bagMarkId = editData.beast[tostring(divineID)][index]
		self.mark = editData.beastMarkBag[tostring(bagMarkId)]
		self.markID = self.mark.markId
		self.fields.Text_name:setString(divineBeastMarkRead.getName(self.markID))
		self.fields.Text_name:setColor(gQualityTextColorDef[divineBeastMarkRead.getQuality(self.markID)])
		local elemStr = "?"
		local randomElem = self.mark.randomElem or 0
		if randomElem ~= 0 then
			print("randomElem", randomElem)
			local elemCfg = divineBeastMarkRead.getElementCfg(randomElem)
			elemStr = i18n(elemCfg.name)
		end
		if self.mark.randomBuffs[1] == 0 and self.mark.randomBuffs[2] == 0 then
			self.fields.Text_buff:setString("元素:" .. elemStr)
		else
			self.fields.Text_buff:setString("元素:" .. elemStr .. " B1:" .. self.mark.randomBuffs[1] .. ",B2:" .. self.mark.randomBuffs[2])
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.mark = nil
		self.markID = nil
	end
end
function Com_markAdd:btnTouchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).divineID = self.divineID
	;(nil).index = self.index
	uiManager:show("CheatMarkChoose", nil)
end
function Com_markAdd:btnDeleteClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_MARK"
	;(nil).divineID = self.divineID
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
function Com_markAdd:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).divineID = self.divineID
	;(nil).index = self.index
	;(nil).markID = self.markID
	;(nil).mark = self.mark
	uiManager:show("CheatMarkBuffPop", nil)
end
return Com_markAdd
