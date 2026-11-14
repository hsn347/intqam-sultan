local baseComponent = require("fgui.base.baseComponent")
local Com_grid = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/Com_grid", Com_grid)
function Com_grid:onInit()
	self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
end
function Com_grid:onSubmit()
	local data = tonumber(self.fields.input:getText())
	if data and 1 <= data and data <= 9 then
		_ENV = self.fields.input:getText()
		self.fields.input:getText().msg = "MESSAGE_GAME_NUMBER_GAME_UPDATE"
		self.fields.input:getText().row = self.row
		self.fields.input:getText().col = self.col
		self.fields.input:getText().num = data
		SoraDSendMessage(self.fields.input:getText())
	else
		self.fields.input:setText("")
		self.fields.bg:setColor("#FFFFCC")
	end
end
function Com_grid:onShow()
end
function Com_grid:initData(sudokuData, sudokuRecordData, row, col)
	self.sudokuData = sudokuData
	self.sudokuRecordData = sudokuRecordData
	self.row = row
	self.col = col
	self.controllers.c1:setSelectedIndex(self.sudokuRecordData == -1 and 0 or 1)
	if self.sudokuRecordData == -1 then
		self.fields.title:setString(self.sudokuData)
	elseif self.sudokuRecordData == 0 then
		self.fields.input:setText("")
		self.fields.bg:setColor("#FFFFCC")
	elseif self.sudokuRecordData == -2 then
		self.fields.input:setText(self.sudokuData)
		self.fields.input:setColor("#FF00FF")
	else
		self.fields.input:setText(self.sudokuRecordData)
		self.fields.input:setColor("#FFFF00")
		self.fields.bg:setColor(self.sudokuData == self.sudokuRecordData and "#FFFFCC" or "#FF0000")
	end
end
return Com_grid
